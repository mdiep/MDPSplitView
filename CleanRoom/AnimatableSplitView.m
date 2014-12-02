//
//  AnimatableSplitView.m
//  CleanRoom
//
//  Created by Matt Diephouse on 12/2/14.
//  Copyright (c) 2014 Matt Diephouse. All rights reserved.
//

#import "AnimatableSplitView.h"


#import <QuartzCore/QuartzCore.h>

@implementation AnimatableSplitView

#pragma mark - NSView

+ (id)defaultAnimationForKey:(NSString *)key
{
	if ([key isEqual:@"splitPosition"])
	{
		return [CABasicAnimation new];
	}
	else
		return [super defaultAnimationForKey:key];
}


#pragma mark - API

- (CGFloat)splitPosition
{
	NSView *leftView = self.subviews[0];
	return leftView.frame.size.width;
}

- (void)setSplitPosition:(CGFloat)newPosition
{
	[self setPosition:newPosition ofDividerAtIndex:0];
	
	// If a split view item is "collapsed", then it's hidden. I'm not sure why NSSplitView isn't doing this.
	if (newPosition == 0)
	{
		NSView *leftView = self.subviews[0];
		leftView.hidden = YES;
	}
}

@end
