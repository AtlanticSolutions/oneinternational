//
//  LoadingViewLAB360.h
//  LAB360-ObjC
//
//  Created by Erico GT on 01/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewLAB360 : UIView

#pragma mark - Properties
@property (nonatomic, strong) UIImage *logoBackgroundImage;
@property (nonatomic, strong) UIColor *logoBackgroundColor;
@property (nonatomic, strong) UIColor *logoPrimaryColor;
@property (nonatomic, strong) UIColor *logoSecondaryColor;

#pragma mark - Methods
-(instancetype) __unavailable init;
//
+ (LoadingViewLAB360*) newLoadingViewWithFrame:(CGRect)frame primaryColor:(UIColor*)pColor andSecondaryColor:(UIColor*)sColor;
//
- (void)startOnceAnimation;
//
- (void)startAnimating;
- (void)stopAnimating;

@end

