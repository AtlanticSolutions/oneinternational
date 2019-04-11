/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "HRHSVColorUtil.h"

@protocol HRColorCursor
@optional
- (void)setEditing:(BOOL)editing;
@end

@interface HRColorCursor : UIView <HRColorCursor>

@property (nonatomic, strong) UIColor *color;

+ (CGSize)cursorSize;

+ (HRColorCursor *)colorCursorWithPoint:(CGPoint)point;

@end
