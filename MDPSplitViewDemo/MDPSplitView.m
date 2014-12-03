//
//  MDPSplitView.m
//  CleanRoom
//
//  Created by Matt Diephouse on 12/2/14.
//  Copyright (c) 2014 Matt Diephouse. All rights reserved.
//

#import "MDPSplitView.h"


#import <QuartzCore/QuartzCore.h>

static NSString * const MDPKeyPrefix = @"mdp_";

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

@implementation MDPSplitView

#pragma mark - NSView

+ (id)defaultAnimationForKey:(NSString *)key
{
    if ([key hasPrefix:MDPKeyPrefix])
    {
        return [CABasicAnimation new];
    }
    else
        return [super defaultAnimationForKey:key];
}

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
        
        hideViewIfNecessary(self.subviews[index]);
        hideViewIfNecessary(self.subviews[index + 1]);
    }
    else
        [super setValue:value forKey:key];
}


#pragma mark - API

- (void)setPosition:(CGFloat)position ofDividerAtIndex:(NSInteger)dividerIndex animated:(BOOL)animated
{
    if (animated)
    {
        [self.animator setValue:@(position) forKey:MDPKeyFromIndex(dividerIndex)];
    }
    else
    {
        [self setPosition:position ofDividerAtIndex:dividerIndex];
    }
}


@end
