/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 */


#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef void(^renderToContext)(CGContextRef, CGRect);

@interface UIImage (CoreGraphics)

+ (UIImage *)hr_imageWithSize:(CGSize)size renderer:(renderToContext)renderer;

+ (UIImage *)hr_imageWithSize:(CGSize)size opaque:(BOOL)opaque renderer:(renderToContext)renderer;

@end
