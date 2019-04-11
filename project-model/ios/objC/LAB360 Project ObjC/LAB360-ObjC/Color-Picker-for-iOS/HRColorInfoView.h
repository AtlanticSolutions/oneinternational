/*-
 * Copyright (c) 2011 Ryota Hayashi
 * All rights reserved.
 */


#import <UIKit/UIKit.h>

@protocol HRColorInfoView
@property (nonatomic, strong) UIColor *color;
@end

@interface HRColorInfoView : UIView <HRColorInfoView>

@end
