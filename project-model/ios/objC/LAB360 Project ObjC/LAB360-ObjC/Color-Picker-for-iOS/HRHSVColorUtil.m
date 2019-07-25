/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 */

#import "HRHSVColorUtil.h"

void HSVColorFromUIColor(UIColor *uiColor, HRHSVColor *hsv) {
    CGFloat alpha;
    [uiColor getHue:&hsv->h saturation:&hsv->s brightness:&hsv->v alpha:&alpha];
}

