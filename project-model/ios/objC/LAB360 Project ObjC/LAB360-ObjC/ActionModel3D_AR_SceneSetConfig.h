//
//  ActionModel3D_AR_SceneSetConfig.h
//  LAB360-ObjC
//
//  Created by Erico GT on 25/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ActionModel3DViewerSceneQualityAuto        = 0,
    ActionModel3DViewerSceneQualityLow         = 1,
    ActionModel3DViewerSceneQualityMedium      = 2,
    ActionModel3DViewerSceneQualityHigh        = 3,
    ActionModel3DViewerSceneQualityUltra       = 4,
} ActionModel3DViewerSceneQuality;

//typedef enum {
//    ActionModel3DViewerSceneInstructionStyleHide          = 0,
//    ActionModel3DViewerSceneInstructionStyleMinimal       = 1,
//    ActionModel3DViewerSceneInstructionStyleNormal        = 2,
//    ActionModel3DViewerSceneInstructionStyleExtended      = 3
//} ActionModel3DViewerSceneInstructionStyle;

typedef enum {
    ActionModel3DViewerSceneRotationModeNone       = 0,
    ActionModel3DViewerSceneRotationModeFree       = 1,
    ActionModel3DViewerSceneRotationModeYAxis      = 2,
    ActionModel3DViewerSceneRotationModeXAxis      = 3,
    ActionModel3DViewerSceneRotationModeLimited    = 4
} ActionModel3DViewerSceneRotationMode;

typedef enum {
    ActionModel3DViewerSceneBackgroundStyleSolidColor     = 1,
    ActionModel3DViewerSceneBackgroundStyleImage          = 2,
    ActionModel3DViewerSceneBackgroundStyleFrontCamera    = 3,
    ActionModel3DViewerSceneBackgroundStyleBackCamera     = 4,
    ActionModel3DViewerSceneBackgroundStyleEnviroment     = 5
} ActionModel3DViewerSceneBackgroundStyle;

typedef enum {
    ActionModel3DViewerSceneHDRStateOFF                    = 1,
    ActionModel3DViewerSceneHDRStateON                     = 2,
    ActionModel3DViewerSceneHDRStateExposureAdaptation     = 3
} ActionModel3DViewerSceneHDRState;

@interface ActionModel3D_AR_SceneSetConfig : NSObject<NSCoding, NSSecureCoding>

#pragma mark - Properties
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSString *backgroundURL;
@property (nonatomic, strong) UIImage* backgroundImage;
@property (nonatomic, assign) int maxSimultaneousObjectsAllowed;
@property (nonatomic, assign) ActionModel3DViewerSceneQuality sceneQuality;
@property (nonatomic, assign) ActionModel3DViewerSceneRotationMode rotationMode;
@property (nonatomic, assign) ActionModel3DViewerSceneBackgroundStyle backgroundStyle;
@property (nonatomic, assign) ActionModel3DViewerSceneHDRState HDRState;
//
@property (nonatomic, assign) float maximumHorizontalAngle; //ambos os valores do eixo zerados permitem rotação completa do componente
@property (nonatomic, assign) float minimumHorizontalAngle;
@property (nonatomic, assign) float maximumVerticalAngle;
@property (nonatomic, assign) float minimumVerticalAngle;
//
@property (nonatomic, strong) NSString* localAudioFileURL;

#pragma mark - Support Methods
+ (ActionModel3D_AR_SceneSetConfig*)createObjectFromDictionary:(NSDictionary*)dicData;
- (NSDictionary*)dictionaryJSON;
- (ActionModel3D_AR_SceneSetConfig*)copyObject;

#pragma mark - NSCoding Methods
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder;

#pragma mark - NSSecureCoding Methods
+ (BOOL)supportsSecureCoding;

@end
