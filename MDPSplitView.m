//
//  MDPSplitView.m
//
//  Created by Matt Diephouse on 12/2/14.
//  Copyright (c) 2014 Matt Diephouse.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "MDPSplitView.h"


#import <QuartzCore/QuartzCore.h>

static NSString * const MDPKeyPrefix = @"mdp_";
static BOOL MDPSplitViewRunning10_10OrLater;

static NSString *MDPKeyFromIndex(NSInteger index)
{
    return [NSString stringWithFormat:@"%@%@", MDPKeyPrefix, @(index)];
}

static NSInteger MDPKeyToIndex(NSString *key)
{
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSNumberFormatter new];
    });
    
    return [formatter numberFromString:[key substringFromIndex:MDPKeyPrefix.length]].integerValue;
}

@interface MDPSplitView ()

/*!
 The number of active animations for each divider by index.
 */
@property (strong, nonatomic ) NSCountedSet *mdp_animationCounts;

@end

static MDPSplitView *CommonInit(MDPSplitView *self)
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		MDPSplitViewRunning10_10OrLater = [NSProcessInfo instancesRespondToSelector:@selector(operatingSystemVersion)];
	});
    self.mdp_animationCounts = [NSCountedSet new];
    return self;
}

@implementation MDPSplitView

#pragma mark - NSObject

- (id)valueForKey:(NSString *)key
{
    if ([key hasPrefix:MDPKeyPrefix])
    {
        NSInteger index = MDPKeyToIndex(key);
        NSView *leftView = self.subviews[index];
        return @(self.isVertical ? NSMaxX(leftView.frame) : NSMaxY(leftView.frame));
    }
    else
        return [super valueForKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key hasPrefix:MDPKeyPrefix])
    {
        NSInteger index = MDPKeyToIndex(key);
        CGFloat newPosition = [(NSNumber *)value floatValue];
        
        NSView *view1 = self.subviews[index];
        NSView *view2 = self.subviews[index + 1];
        
        // Unhide collapsed items. It's not clear why NSSplitView
        // doesn't do this on 10.9.
		if (!MDPSplitViewRunning10_10OrLater)
		{
			view1.hidden = NO;
			view2.hidden = NO;
		}
		
        [self setPosition:newPosition ofDividerAtIndex:index];
        
        // If a split view item is "collapsed", then it's hidden.
        // I'm not sure why NSSplitView isn't doing this.
        void (^hideViewIfNecessary)(NSView *) = ^(NSView *view) {
            CGFloat width = (self.isVertical ? NSWidth(view.frame) : NSHeight(view.frame));
            if (width == 0 && [self.delegate splitView:self canCollapseSubview:view])
            {
                view.hidden = YES;
            }
        };
        
        hideViewIfNecessary(view1);
        hideViewIfNecessary(view2);
    }
    else
        [super setValue:value forKey:key];
}


#pragma mark - NSView

- (instancetype)initWithFrame:(NSRect)frame
{
    return CommonInit([super initWithFrame:frame]);
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    return CommonInit([super initWithCoder:decoder]);
}

+ (id)defaultAnimationForKey:(NSString *)key
{
    if ([key hasPrefix:MDPKeyPrefix])
    {
        return [CABasicAnimation new];
    }
    else
        return [super defaultAnimationForKey:key];
}


#pragma mark - API

- (void)setPosition:(CGFloat)position ofDividerAtIndex:(NSInteger)dividerIndex animated:(BOOL)animated
{
    if (animated)
    {
        NSView *view1 = self.subviews[dividerIndex];
        NSView *view2 = self.subviews[dividerIndex + 1];
        
        // NSSplitView is adding bogus width constraints. Remove them
        // manually.
        for (NSLayoutConstraint *constraint in self.constraints) {
            NSView *firstItem = constraint.firstItem;
            if (!([firstItem isEqual:view1] || [firstItem isEqual:view2])) continue;
            if (constraint.firstAttribute != (self.isVertical ? NSLayoutAttributeWidth : NSLayoutAttributeHeight)) continue;
            if (constraint.relation != NSLayoutRelationEqual) continue;
            if (constraint.secondItem != nil) continue;
            if (constraint.priority != NSLayoutPriorityRequired) continue;
            
            [self removeConstraint:constraint];
        }
        
        [NSAnimationContext
            runAnimationGroup:^(NSAnimationContext *context) {
                [self.mdp_animationCounts addObject:@(dividerIndex)];
                [self.animator setValue:@(position) forKey:MDPKeyFromIndex(dividerIndex)];
            }
            completionHandler:^{
                [self.mdp_animationCounts removeObject:@(dividerIndex)];
            }];
    }
    else
    {
        [self setPosition:position ofDividerAtIndex:dividerIndex];
    }
}

- (BOOL)isAnimatingDividerAtIndex:(NSInteger)dividerIndex
{
    return [self.mdp_animationCounts countForObject:@(dividerIndex)] > 0;
}


@end
