//
//  MDPSplitView+SubviewToggleHelper.m
//
//  Created by Jan Weiß on 2017-08-15.
//

#import "MDPSplitView+SubviewToggleHelper.h"

#import <QuartzCore/QuartzCore.h>


@implementation MDPSplitView (SubviewToggleHelper)

// The following two methods don’t do anything but wrap and rename
// the core method so that method calls are more readable.
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
	
	if ([self isAnimatingDividerAtIndex:dividerIndex]) {
		return;
	}
	
	BOOL dividedLeftToRight = self.isVertical;
	
	BOOL initiallyOpen = ![self isSubviewCollapsed:subview];
	
	CGFloat position = (initiallyOpen ? 0.0 : *lastExtent);
	if (collapsesInPositiveDirection) {
		if (dividedLeftToRight) {
			position = self.frame.size.width - position;
		}
		else {
			position = self.frame.size.height - position;
		}
	}
	
	[subview removeConstraint:extentConstraint];
	
	if (initiallyOpen) {
		if (dividedLeftToRight) {
			*lastExtent = subview.frame.size.width;
		}
		else {
			*lastExtent = subview.frame.size.height;
		}
	}
	else {
		NSRect frame = subview.frame;
		
		if (dividedLeftToRight) {
			frame.size.width = 0.0;
		}
		else {
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
		 if (initiallyOpen == NO) {
			 [subview addConstraint:extentConstraint];
		 }
		 if (completionHandler != NULL) {
			 completionHandler(!initiallyOpen);
		 }
	 }];
}

@end

//  Copyright (c) 2017 Jan Weiß.
//
//  Some rights reserved: https://opensource.org/licenses/MIT
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

