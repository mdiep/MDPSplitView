//
//  MDPSplitView.h
//
//  Created by Matt Diephouse on 12/2/14.
//  Copyright (c) 2014 Matt Diephouse.
//  Copyright (c) 2017 Jan Weiß.
//
//  Some rights reserved: https://opensource.org/licenses/MIT

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

#import <Cocoa/Cocoa.h>

//! Project version number for MDPSplitView.
FOUNDATION_EXPORT double MDPSplitViewVersionNumber;

//! Project version string for MDPSplitView.
FOUNDATION_EXPORT const unsigned char MDPSplitViewVersionString[];

/*!
 An `NSSplitView` subclass that provides a method to animate the position of a
 divider in a way that works with Auto Layout.
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
 @param animated
    Whether the positioning should be animated.
 */
- (void)setPosition:(CGFloat)position ofDividerAtIndex:(NSInteger)dividerIndex animated:(BOOL)animated;

/*!
 Whether the divider at the given index is currently being animated.
 */
- (BOOL)isAnimatingDividerAtIndex:(NSInteger)dividerIndex;


- (void)toggleSubview:(NSView * _Nonnull)subview
         dividerIndex:(NSUInteger)dividerIndex
            lastWidth:(CGFloat * _Nonnull)lastWidth
    animationDuration:(NSTimeInterval)duration
   collapsesRightward:(BOOL)collapsesRightward
      widthConstraint:(NSLayoutConstraint * _Nonnull)widthConstraint
    completionHandler:(nullable void (^)(BOOL isOpen))completionHandler;

- (void)toggleSubview:(NSView * _Nonnull)subview
         dividerIndex:(NSUInteger)dividerIndex
           lastHeight:(CGFloat * _Nonnull)lastHeight
    animationDuration:(NSTimeInterval)duration
      collapsesUpward:(BOOL)collapsesUpwards
     heightConstraint:(NSLayoutConstraint * _Nonnull)heightConstraint
    completionHandler:(nullable void (^)(BOOL isOpen))completionHandler;


@end

