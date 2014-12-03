//
//  MDPSplitView.h
//  CleanRoom
//
//  Created by Matt Diephouse on 12/2/14.
//  Copyright (c) 2014 Matt Diephouse. All rights reserved.
//

#import <Cocoa/Cocoa.h>


/*!
 An `NSSplitView` subclass that provides a method to animate the position of a
 divider.
 */
@interface MDPSplitView : NSSplitView

/*!
 Set the position of a divider, possibly with an animation.
 
 @discussion
	This method will use the split view's animator proxy to animate by calling
	`-setPosition:ofDividerAtIndex:`.
 
 @param position
	The new position of the divider.
 @param dividerIndex
	The index of the divider to position.
 @param	animated
	Whether the positioning should be animated.
 */
- (void)setPosition:(CGFloat)position ofDividerAtIndex:(NSInteger)dividerIndex animated:(BOOL)animated;


@end
