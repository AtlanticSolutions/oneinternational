/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 */


#import <UIKit/UIKit.h>

@protocol HRBrightnessSlider

@required
@property (nonatomic, readonly) NSNumber *brightness;
@property (nonatomic) UIColor *color;

@optional
@property (nonatomic) NSNumber *brightnessLowerLimit;

@end

@interface HRBrightnessSlider : UIControl <HRBrightnessSlider>

@end
