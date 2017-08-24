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
    {
        return [super valueForKey:key];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key hasPrefix:MDPKeyPrefix])
    {
        BOOL (^viewIsClosed)(NSView *) = ^ BOOL (NSView *view) {
            return (self.isVertical ? NSWidth(view.frame) : NSHeight(view.frame)) == 0;
        };
        
        NSInteger index = MDPKeyToIndex(key);
        CGFloat newPosition = [(NSNumber *)value floatValue];
        
        NSView *view1 = self.subviews[index];
        NSView *view2 = self.subviews[index + 1];
        
        BOOL view1WasClosed = viewIsClosed(view1);
        BOOL view2WasClosed = viewIsClosed(view2);
        
        [self setPosition:newPosition ofDividerAtIndex:index];
        
        BOOL view1IsClosed = viewIsClosed(view1);
        BOOL view2IsClosed = viewIsClosed(view2);
        
        // Why doesn't NSSplitView do this itself? I dunno. But it's buggy on
        // 10.9 at least. But it doesn't work to set them all the time. You have
        // to set the property only when the state should change.
        if (view1WasClosed != view1IsClosed)
        {
            view1.hidden = view1IsClosed;
        }
        if (view2WasClosed != view2IsClosed)
        {
            view2.hidden = view2IsClosed;
        }
    }
    else
    {
        [super setValue:value forKey:key];
    }
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
    {
        return [super defaultAnimationForKey:key];
    }
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


// The following two methods don’t do anything,
// apart from wrapping and renaming the core method
// so that method calls are more readable.
- (void)toggleSubview:(NSView * _Nonnull)subview
         dividerIndex:(NSUInteger)dividerIndex
            lastWidth:(CGFloat * _Nonnull)lastWidth
    animationDuration:(NSTimeInterval)duration
   collapsesRightward:(BOOL)collapsesRightward
      widthConstraint:(NSLayoutConstraint * _Nonnull)widthConstraint
    completionHandler:(nullable void (^)(BOOL isOpen))completionHandler;
{
    [self      toggleSubview:subview
                dividerIndex:dividerIndex
                  lastExtent:lastWidth
           animationDuration:duration
collapsesInPositiveDirection:collapsesRightward
            extentConstraint:widthConstraint
           completionHandler:completionHandler];
}

- (void)toggleSubview:(NSView * _Nonnull)subview
         dividerIndex:(NSUInteger)dividerIndex
           lastHeight:(CGFloat * _Nonnull)lastHeight
    animationDuration:(NSTimeInterval)duration
      collapsesUpward:(BOOL)collapsesUpwards
     heightConstraint:(NSLayoutConstraint * _Nonnull)heightConstraint
    completionHandler:(nullable void (^)(BOOL isOpen))completionHandler;
{
    [self      toggleSubview:subview
                dividerIndex:dividerIndex
                  lastExtent:lastHeight
           animationDuration:duration
collapsesInPositiveDirection:collapsesUpwards // Positive values extend upwards in Cocoa.
            extentConstraint:heightConstraint
           completionHandler:completionHandler];
}

// The core method.
- (void)       toggleSubview:(NSView * _Nonnull)subview
                dividerIndex:(NSUInteger)dividerIndex
                  lastExtent:(CGFloat * _Nonnull)lastExtent
           animationDuration:(NSTimeInterval)duration
collapsesInPositiveDirection:(BOOL)collapsesInPositiveDirection
            extentConstraint:(NSLayoutConstraint * _Nonnull)extentConstraint
           completionHandler:(nullable void (^)(BOOL isOpen))completionHandler
{
    
    if ([self isAnimatingDividerAtIndex:dividerIndex])
    {
        return;
    }
    
    BOOL dividedLeftToRight = self.isVertical;
    
    BOOL initiallyOpen = ![self isSubviewCollapsed:subview];
    
    CGFloat position = (initiallyOpen ? 0.0 : *lastExtent);
    if (collapsesInPositiveDirection)
    {
        if (dividedLeftToRight)
        {
            position = self.frame.size.width - position;
        }
        else
        {
            position = self.frame.size.height - position;
        }
    }
    
    [subview removeConstraint:extentConstraint];
    
    if (initiallyOpen)
    {
        if (dividedLeftToRight)
        {
            *lastExtent = subview.frame.size.width;
        }
        else
        {
            *lastExtent = subview.frame.size.height;
        }
    }
    else
    {
        NSRect frame = subview.frame;
        
        if (dividedLeftToRight)
        {
            frame.size.width = 0.0;
        }
        else
        {
            frame.size.height = 0.0;
        }
        
        subview.frame = frame;
    }
    
    [NSAnimationContext runAnimationGroup:
     ^(NSAnimationContext * _Nonnull context) {
         context.timingFunction =
         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
         context.duration = duration;
         
         [self setPosition:position
          ofDividerAtIndex:dividerIndex
                  animated:YES];
     } completionHandler:
     ^{
         if (initiallyOpen == NO)
         {
             [subview addConstraint:extentConstraint];
         }
         if (completionHandler != NULL)
         {
             completionHandler(!initiallyOpen);
         }
     }];
}


@end
