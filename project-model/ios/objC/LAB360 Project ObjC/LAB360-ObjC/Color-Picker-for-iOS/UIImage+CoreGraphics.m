/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 */


#import "UIImage+CoreGraphics.h"

@implementation UIImage (CoreGraphics)

+ (UIImage *)hr_imageWithSize:(CGSize)size renderer:(renderToContext)renderer {
    return [UIImage hr_imageWithSize:size opaque:NO renderer:renderer];
}

+ (UIImage *)hr_imageWithSize:(CGSize)size opaque:(BOOL)opaque renderer:(renderToContext)renderer {
    UIImage *image;

    UIGraphicsBeginImageContextWithOptions(size, opaque, 0);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect imageRect = CGRectMake(0.f, 0.f, size.width, size.height);

    renderer(context, imageRect);

    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
