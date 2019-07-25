/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 */

/////////////////////////////////////////////////////////////////////////////
//
// 0.0f~1.0fの値をとるHSVの構造体です
//
/////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat h;
    CGFloat s;
    CGFloat v;
} HRHSVColor;

void HSVColorFromUIColor(UIColor *, HRHSVColor *outHSV);

