//
//  VirtualARViewerVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 23/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"
#import "VirtualObjectProperties.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <SceneKit/ModelIO.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

typedef enum {
    VirtualARViewerSceneQualityLow         = 1,
    VirtualARViewerSceneQualityMedium      = 2,
    VirtualARViewerSceneQualityHigh        = 3,
    VirtualARViewerSceneQualityUltra       = 4,
} VirtualARViewerSceneQuality;

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE
@interface VirtualARViewerVC : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, strong) NSString *screenTitle;
@property(nonatomic, strong) NSString *objectModelURL;
//
@property(nonatomic, assign) float modelRotationX;
@property(nonatomic, assign) float modelRotationY;
@property(nonatomic, assign) float modelRotationZ;
@property(nonatomic, assign) float modelRotationW;
@property(nonatomic, assign) float modelScale;
//
@property (nonatomic, assign) BOOL showPhotoButton;
@property (nonatomic, assign) BOOL showLightControlOption;
@property (nonatomic, assign) VirtualARViewerSceneQuality sceneQuality;
//
@property(nonatomic, assign) BOOL enableMaterialAutoIlumination;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS
+ (BOOL) ARSupportedForDevice;

@end
