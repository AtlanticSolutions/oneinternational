//
//  ActionModel3D_AR_SceneSetConfig.m
//  LAB360-ObjC
//
//  Created by Erico GT on 25/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "ActionModel3D_AR_SceneSetConfig.h"
#import "ConstantsManager.h"
#import "ToolBox.h"

#define CLASS_ACTION3D_AR_SCENESET_DEFAULT @"scene_set"
#define CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDCOLOR @"background_color"
#define CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDIMAGEURL @"background_url"
#define CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDIMAGE @"background_image"
#define CLASS_ACTION3D_AR_SCENESET_KEY_SCENEQUALITY @"scene_quality"
#define CLASS_ACTION3D_AR_SCENESET_KEY_SCENEROTATION @"rotation_mode"
#define CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDSTYLE @"background_style"
#define CLASS_ACTION3D_AR_SCENESET_KEY_HDRSTATE @"hdr_state"
//
#define CLASS_ACTION3D_AR_SCENESET_KEY_MAXHORANGLE @"max_horizontal_angle"
#define CLASS_ACTION3D_AR_SCENESET_KEY_MINHORANGLE @"min_horizontal_angle"
#define CLASS_ACTION3D_AR_SCENESET_KEY_MAXVERTANGLE @"max_vertical_angle"
#define CLASS_ACTION3D_AR_SCENESET_KEY_MINVERTANGLE @"min_vertical_angle"
//
#define CLASS_ACTION3D_AR_SCENESET_KEY_MSOA @"max_simultaneous_objects_allowed"
//
#define CLASS_ACTION3D_AR_SCENESET_KEY_LOCALAUDIOFILEURL @"audio_url"

@implementation ActionModel3D_AR_SceneSetConfig

@synthesize backgroundColor, backgroundURL, backgroundImage, localAudioFileURL, sceneQuality, rotationMode, backgroundStyle, HDRState, maximumHorizontalAngle, minimumHorizontalAngle, maximumVerticalAngle, minimumVerticalAngle, maxSimultaneousObjectsAllowed;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        backgroundColor = nil;
        backgroundURL = nil;
        backgroundImage = nil;
        localAudioFileURL = nil;
        sceneQuality = ActionModel3DViewerSceneQualityAuto;
        rotationMode = ActionModel3DViewerSceneRotationModeFree;
        backgroundStyle = ActionModel3DViewerSceneBackgroundStyleSolidColor;
        HDRState = ActionModel3DViewerSceneHDRStateON;
        //
        maximumHorizontalAngle = 180.0; //limite real
        minimumHorizontalAngle = -180.0; //limite real
        maximumVerticalAngle = 90.0; //limite real
        minimumVerticalAngle = -90.0; //limite real
        //
        maxSimultaneousObjectsAllowed = 0;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Support Methods
//-------------------------------------------------------------------------------------------------------------

+ (ActionModel3D_AR_SceneSetConfig*)createObjectFromDictionary:(NSDictionary*)dicData
{
    ActionModel3D_AR_SceneSetConfig *ss = [ActionModel3D_AR_SceneSetConfig new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        if ([keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDCOLOR]){
            NSString *hexColor = [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDCOLOR]];
            if ([ToolBox textHelper_CheckRelevantContentInString:hexColor]){
                ss.backgroundColor = [ToolBox graphicHelper_colorWithHexString:hexColor];
            }
        }
        
        ss.backgroundURL = [keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDIMAGEURL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDIMAGEURL]] : ss.backgroundURL;
        
        ss.backgroundImage = nil;
        
        int enumQuality = [keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEQUALITY] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEQUALITY] intValue] : ss.sceneQuality;
        ss.sceneQuality = (enumQuality >= ActionModel3DViewerSceneQualityAuto && enumQuality <= ActionModel3DViewerSceneQualityUltra) ? enumQuality : ss.sceneQuality;
    
        //int enumInstruction = [keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEINSTRUCTION] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEINSTRUCTION] intValue] : ss.instructionStyle;
        //ss.instructionStyle = (enumInstruction >= ActionModel3DViewerSceneInstructionStyleHide && enumInstruction <= ActionModel3DViewerSceneInstructionStyleExtended) ? enumInstruction : ss.instructionStyle;
    
        int enumRotation = [keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEROTATION] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEROTATION] intValue] : ss.rotationMode;
        ss.rotationMode = (enumRotation >= ActionModel3DViewerSceneRotationModeNone && enumRotation <= ActionModel3DViewerSceneRotationModeLimited) ? enumRotation : ss.rotationMode;
    
        int enumBackground = [keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDSTYLE] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDSTYLE] intValue] : ss.backgroundStyle;
        ss.backgroundStyle = (enumBackground >= ActionModel3DViewerSceneBackgroundStyleSolidColor && enumBackground <= ActionModel3DViewerSceneBackgroundStyleEnviroment) ? enumBackground : ss.backgroundStyle;
        
        int enumHDR = [keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_HDRSTATE] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_HDRSTATE] intValue] : ss.HDRState;
        ss.HDRState = (enumHDR >= ActionModel3DViewerSceneHDRStateOFF && enumHDR <= ActionModel3DViewerSceneHDRStateExposureAdaptation) ? enumHDR : ss.HDRState;
        
        ss.maximumHorizontalAngle = [keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_MAXHORANGLE] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_MAXHORANGLE] floatValue] : ss.maximumHorizontalAngle;
        
        ss.minimumHorizontalAngle = [keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_MINHORANGLE] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_MINHORANGLE] floatValue] : ss.minimumHorizontalAngle;
        
        ss.maximumVerticalAngle = [keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_MAXVERTANGLE] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_MAXVERTANGLE] floatValue] : ss.maximumVerticalAngle;
        
        ss.minimumVerticalAngle = [keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_MINVERTANGLE] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_MINVERTANGLE] floatValue] : ss.minimumVerticalAngle;
        
        ss.maxSimultaneousObjectsAllowed = [keysList containsObject:CLASS_ACTION3D_AR_SCENESET_KEY_MSOA] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCENESET_KEY_MSOA] intValue] : ss.maxSimultaneousObjectsAllowed;
        
    }
    
    //validations:
    
    ss.maximumHorizontalAngle = ss.maximumHorizontalAngle > 180.0 ? 180.0 : ss.maximumHorizontalAngle;
    ss.minimumHorizontalAngle = ss.minimumHorizontalAngle < -180.0 ? -180.0 : ss.minimumHorizontalAngle;
    ss.maximumVerticalAngle = ss.maximumVerticalAngle > 90.0 ? 90.0 : ss.maximumVerticalAngle;
    ss.minimumVerticalAngle = ss.minimumVerticalAngle < -90.0 ? -90.0 : ss.minimumVerticalAngle;
    ss.maxSimultaneousObjectsAllowed = ss.maxSimultaneousObjectsAllowed < 0 ? 0 : ss.maxSimultaneousObjectsAllowed;
    
    return ss;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:(self.backgroundColor ? [ToolBox graphicHelper_hexStringFromUIColor:self.backgroundColor] : @"") forKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDCOLOR];
    [dicData setValue:(self.backgroundURL ? [NSString stringWithFormat:@"%@", self.backgroundURL] : @"") forKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDIMAGEURL];
    [dicData setValue:@(self.sceneQuality) forKey:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEQUALITY];
    [dicData setValue:@(self.rotationMode) forKey:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEROTATION];
    [dicData setValue:@(self.backgroundStyle) forKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDSTYLE];
    [dicData setValue:@(self.HDRState) forKey:CLASS_ACTION3D_AR_SCENESET_KEY_HDRSTATE];
    [dicData setValue:@(self.maximumHorizontalAngle) forKey:CLASS_ACTION3D_AR_SCENESET_KEY_MAXHORANGLE];
    [dicData setValue:@(self.minimumHorizontalAngle) forKey:CLASS_ACTION3D_AR_SCENESET_KEY_MINHORANGLE];
    [dicData setValue:@(self.maximumVerticalAngle) forKey:CLASS_ACTION3D_AR_SCENESET_KEY_MAXVERTANGLE];
    [dicData setValue:@(self.minimumVerticalAngle) forKey:CLASS_ACTION3D_AR_SCENESET_KEY_MINVERTANGLE];
    [dicData setValue:@(self.maxSimultaneousObjectsAllowed) forKey:CLASS_ACTION3D_AR_SCENESET_KEY_MSOA];
    
    //
    return dicData;
}

- (ActionModel3D_AR_SceneSetConfig*)copyObject
{
    ActionModel3D_AR_SceneSetConfig *ss = [ActionModel3D_AR_SceneSetConfig new];
    ss.backgroundColor = self.backgroundColor.CGColor ? [UIColor colorWithCGColor:self.backgroundColor.CGColor] : nil;
    ss.backgroundURL = self.backgroundURL ? [NSString stringWithFormat:@"%@", self.backgroundURL] : nil;
    ss.localAudioFileURL = self.localAudioFileURL ? [NSString stringWithFormat:@"%@", self.localAudioFileURL] : nil;
    ss.backgroundImage = self.backgroundImage ? [UIImage imageWithData:UIImagePNGRepresentation(self.backgroundImage)] : nil;
    ss.sceneQuality = self.sceneQuality;
    ss.rotationMode = self.rotationMode;
    ss.backgroundStyle = self.backgroundStyle;
    ss.HDRState = self.HDRState;
    ss.maximumHorizontalAngle = self.maximumHorizontalAngle;
    ss.minimumHorizontalAngle = self.minimumHorizontalAngle;
    ss.maximumVerticalAngle = self.maximumVerticalAngle;
    ss.minimumVerticalAngle = self.minimumVerticalAngle;
    ss.maxSimultaneousObjectsAllowed = self.maxSimultaneousObjectsAllowed;
    //
    return ss;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - NSCoding Methods
//-------------------------------------------------------------------------------------------------------------

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.backgroundImage forKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDIMAGE];
    [aCoder encodeObject:self.backgroundColor forKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDCOLOR];
    [aCoder encodeObject:self.backgroundURL forKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDIMAGEURL];
    [aCoder encodeInt:self.sceneQuality forKey:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEQUALITY];
    [aCoder encodeInt:self.rotationMode forKey:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEROTATION];
    [aCoder encodeInt:self.backgroundStyle forKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDSTYLE];
    [aCoder encodeInt:self.HDRState forKey:CLASS_ACTION3D_AR_SCENESET_KEY_HDRSTATE];
    [aCoder encodeFloat:self.maximumHorizontalAngle forKey:CLASS_ACTION3D_AR_SCENESET_KEY_MAXHORANGLE];
    [aCoder encodeFloat:self.minimumHorizontalAngle forKey:CLASS_ACTION3D_AR_SCENESET_KEY_MINHORANGLE];
    [aCoder encodeFloat:self.maximumVerticalAngle forKey:CLASS_ACTION3D_AR_SCENESET_KEY_MAXVERTANGLE];
    [aCoder encodeFloat:self.minimumVerticalAngle forKey:CLASS_ACTION3D_AR_SCENESET_KEY_MINVERTANGLE];
    [aCoder encodeInt:self.maxSimultaneousObjectsAllowed forKey:CLASS_ACTION3D_AR_SCENESET_KEY_MSOA];
    [aCoder encodeObject:self.localAudioFileURL forKey:CLASS_ACTION3D_AR_SCENESET_KEY_LOCALAUDIOFILEURL];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self != nil ){
        
        self.backgroundImage = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDIMAGE];
        self.backgroundColor = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDCOLOR];
        self.backgroundURL = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDIMAGEURL];
        self.sceneQuality = [aDecoder decodeIntForKey:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEQUALITY];
        self.rotationMode = [aDecoder decodeIntForKey:CLASS_ACTION3D_AR_SCENESET_KEY_SCENEROTATION];
        self.backgroundStyle = [aDecoder decodeIntForKey:CLASS_ACTION3D_AR_SCENESET_KEY_BACKGROUNDSTYLE];
        self.HDRState = [aDecoder decodeIntForKey:CLASS_ACTION3D_AR_SCENESET_KEY_HDRSTATE];
        self.maximumHorizontalAngle = [aDecoder decodeFloatForKey:CLASS_ACTION3D_AR_SCENESET_KEY_MAXHORANGLE];
        self.minimumHorizontalAngle = [aDecoder decodeFloatForKey:CLASS_ACTION3D_AR_SCENESET_KEY_MINHORANGLE];
        self.maximumVerticalAngle = [aDecoder decodeFloatForKey:CLASS_ACTION3D_AR_SCENESET_KEY_MAXVERTANGLE];
        self.minimumVerticalAngle = [aDecoder decodeFloatForKey:CLASS_ACTION3D_AR_SCENESET_KEY_MINVERTANGLE];
        self.maxSimultaneousObjectsAllowed = [aDecoder decodeIntForKey:CLASS_ACTION3D_AR_SCENESET_KEY_MSOA];
        self.localAudioFileURL = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_SCENESET_KEY_LOCALAUDIOFILEURL];
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - NSSecureCoding Methods
//-------------------------------------------------------------------------------------------------------------

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
