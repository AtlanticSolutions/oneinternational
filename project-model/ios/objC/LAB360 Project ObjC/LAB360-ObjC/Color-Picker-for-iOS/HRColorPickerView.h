/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 */

#import <UIKit/UIKit.h>

typedef struct HRColorPickerStyle HRColorPickerStyle;

@protocol HRColorMapView;
@protocol HRBrightnessSlider;
@protocol HRColorInfoView;

@interface HRColorPickerView : UIControl

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) IBOutlet UIView <HRColorInfoView> *colorInfoView;
@property (nonatomic, strong) IBOutlet UIControl <HRColorMapView> *colorMapView;
@property (nonatomic, strong) IBOutlet UIControl <HRBrightnessSlider> *brightnessSlider;

@end
