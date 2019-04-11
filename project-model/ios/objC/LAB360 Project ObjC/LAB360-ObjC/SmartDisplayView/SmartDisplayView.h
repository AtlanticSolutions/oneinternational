//
//  SmartDisplayView.h
//  LAB360-ObjC
//
//  Created by Erico GT on 28/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SmartDisplayViewOrientation)
{
    SmartDisplayViewOrientationLeftToRight = 1,
    SmartDisplayViewOrientationRightToLeft = 2,
    SmartDisplayViewOrientationTopToBottom = 3,
    SmartDisplayViewOrientationBottomToTop = 4
};

typedef NS_ENUM(NSInteger, SmartDisplayViewAnimationTransition)
{
    SmartDisplayViewAnimationTransitionRevert = 1,
    SmartDisplayViewAnimationTransitionRevertSmoothly = 2,
    SmartDisplayViewAnimationTransitionRestart = 3,
    SmartDisplayViewAnimationTransitionRestartSmoothly = 4
};

@interface SmartDisplayView : UIView

#pragma mark - Properties
@property (nonatomic, strong) UIImage *displayImage;
@property (nonatomic, assign) BOOL autoAdjustToDeviceOrientationChange;
@property (nonatomic, assign) SmartDisplayViewAnimationTransition animationTransition;

#pragma mark - Methods
+ (SmartDisplayView*)newSmartDisplayViewWithFrame:(CGRect)frame image:(UIImage *)image parentView:(UIView *)parentView;
//
- (void) updateContentLayout;
- (void) startAnimating;
- (void) stopAnimating;
- (void) pauseAnimation:(BOOL)pause;

@end
