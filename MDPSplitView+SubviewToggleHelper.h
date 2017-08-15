//
//  MDPSplitView+SubviewToggleHelper.h
//
//  Created by Jan Weiß on 2017-08-15.
//

#import "MDPSplitView.h"

@interface MDPSplitView (SubviewToggleHelper)

// The following two methods don’t do anything but wrap and rename
// the core method so that method calls are more readable.
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
