//
//  SceneLightControlVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 10/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SceneLightControlVC;

#pragma mark - Protocol

@protocol SceneLightControlDelegate
@required
- (void)sceneLightControlWillHide:(SceneLightControlVC*)lControl;
- (void)sceneLightControl:(SceneLightControlVC*)lControl changeLightState:(BOOL)newState;
@end

#pragma mark - Class

typedef enum {
    SceneLightControlShadowQualityLow         = 1,
    SceneLightControlShadowQualityMedium      = 2,
    SceneLightControlShadowQualityHigh        = 3,
    SceneLightControlShadowQualityUltra       = 4
} SceneLightControlShadowQuality;

@interface SceneLightControlVC : UIViewController

#pragma mark - Properties
@property (nonatomic, strong, readonly) SCNNode *directionalLightNode;
@property (nonatomic, assign) SceneLightControlShadowQuality shadowQuality;

#pragma mark - Methods
+ (SceneLightControlVC*)newSceneLightControl;
- (void)showSceneLightControlWithDelegate:(UIViewController<SceneLightControlDelegate>*)vcDelegate;
- (void)hideSceneLightControl;
- (void)setCategoryBitMask:(NSInteger)bitMask;

@end

