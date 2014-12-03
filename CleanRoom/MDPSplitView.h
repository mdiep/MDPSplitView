//
//  MDPSplitView.h
//  CleanRoom
//
//  Created by Matt Diephouse on 12/2/14.
//  Copyright (c) 2014 Matt Diephouse. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MDPSplitView : NSSplitView

- (void)setPosition:(CGFloat)position ofDividerAtIndex:(NSInteger)dividerIndex animated:(BOOL)animated;

@end
