/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 */


#import <UIKit/UIKit.h>

@protocol HRColorMapView

@required
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) CGFloat brightness;

@optional
@property (nonatomic) NSNumber *saturationUpperLimit;

@end

@interface HRColorMapView : UIControl <HRColorMapView>

+ (HRColorMapView *)colorMapWithFrame:(CGRect)frame;
+ (HRColorMapView *)colorMapWithFrame:(CGRect)frame saturationUpperLimit:(CGFloat)saturationUpperLimit;

@property (nonatomic) NSNumber *tileSize;

@end
