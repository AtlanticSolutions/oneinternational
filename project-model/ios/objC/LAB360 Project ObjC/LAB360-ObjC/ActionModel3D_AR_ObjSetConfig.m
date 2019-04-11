//
//  ActionModel3D_AR_ObjSetConfig.m
//  LAB360-ObjC
//
//  Created by Erico GT on 23/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "ActionModel3D_AR_ObjSetConfig.h"
#import "ConstantsManager.h"
#import "ToolBox.h"

#define CLASS_ACTION3D_AR_OBJSET_DEFAULT @"image_set"
#define CLASS_ACTION3D_AR_OBJSET_KEY_ID @"id"
#define CLASS_ACTION3D_AR_OBJSET_KEY_OBJURL @"obj_url_ios"
#define CLASS_ACTION3D_AR_OBJSET_KEY_OBJLOCALURL @"obj_local_url"
#define CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSIZEFIT @"auto_size_fit"
#define CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSHADOW @"auto_shadow"
#define CLASS_ACTION3D_AR_OBJSET_KEY_ENABLEAUTOILLUM @"enable_material_auto_illumination"
#define CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONX @"model_rotation_x"
#define CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONY @"model_rotation_Y"
#define CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONZ @"model_rotation_Z"
#define CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONX @"model_translation_x"
#define CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONY @"model_translation_y"
#define CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONZ @"model_translation_z"
#define CLASS_ACTION3D_AR_OBJSET_KEY_SCALE @"model_scale"

@implementation ActionModel3D_AR_ObjSetConfig
@synthesize objID, objRemoteURL, objLocalURL, enableMaterialAutoIllumination, autoSizeFit, autoShadow, modelRotationX, modelRotationY, modelRotationZ, modelTranslationX, modelTranslationY, modelTranslationZ, modelScale;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        objID = 0;
        objRemoteURL = nil;
        objLocalURL = nil;
        enableMaterialAutoIllumination = NO;
        autoSizeFit = NO;
        autoShadow = YES;
        modelRotationX = 0.0;
        modelRotationY = 0.0;
        modelRotationZ = 0.0;
        modelTranslationX = 0.0;
        modelTranslationY = 0.0;
        modelTranslationZ = 0.0;
        modelScale = 1.0;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Support Methods
//-------------------------------------------------------------------------------------------------------------

+ (ActionModel3D_AR_ObjSetConfig*)createObjectFromDictionary:(NSDictionary*)dicData
{
    ActionModel3D_AR_ObjSetConfig *os = [ActionModel3D_AR_ObjSetConfig new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        os.objID = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_ID] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_ID] longValue] : os.objID;
        os.objRemoteURL = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_OBJURL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_OBJURL]] : os.objRemoteURL;
        os.objLocalURL = nil;
        os.enableMaterialAutoIllumination = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_ENABLEAUTOILLUM] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_ENABLEAUTOILLUM] boolValue] : os.enableMaterialAutoIllumination;
        os.autoSizeFit = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSIZEFIT] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSIZEFIT] boolValue] : os.autoSizeFit;
        os.autoShadow = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSHADOW] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSHADOW] boolValue] : os.autoShadow;
        os.modelRotationX = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONX] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONX] floatValue] : os.modelRotationX;
        os.modelRotationY = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONY] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONY] floatValue] : os.modelRotationY;
        os.modelRotationZ = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONZ] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONZ] floatValue] : os.modelRotationZ;
        os.modelTranslationX = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONX] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONX] floatValue] : os.modelTranslationX;
        os.modelTranslationY = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONY] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONY] floatValue] : os.modelTranslationY;
        os.modelTranslationZ = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONZ] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONZ] floatValue] : os.modelTranslationZ;
        os.modelScale = [keysList containsObject:CLASS_ACTION3D_AR_OBJSET_KEY_SCALE] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_OBJSET_KEY_SCALE] floatValue] : os.modelScale;
    }
    
    //convertendo grau para radiano:
    os.modelRotationX = os.modelRotationX * (M_PI / 180.0);
    os.modelRotationY = os.modelRotationY * (M_PI / 180.0);
    os.modelRotationZ = os.modelRotationZ * (M_PI / 180.0);
    //
    os.modelScale = os.modelScale <= 0.0 ? 1.0 : os.modelScale;
    
    return os;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.objID) forKey:CLASS_ACTION3D_AR_OBJSET_KEY_ID];
    
    [dicData setValue:(self.objRemoteURL ? [NSString stringWithFormat:@"%@", self.objRemoteURL] : @"") forKey:CLASS_ACTION3D_AR_OBJSET_KEY_OBJURL];
    [dicData setValue:@(enableMaterialAutoIllumination) forKey:CLASS_ACTION3D_AR_OBJSET_KEY_ENABLEAUTOILLUM];
    [dicData setValue:@(autoSizeFit) forKey:CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSIZEFIT];
    [dicData setValue:@(autoShadow) forKey:CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSHADOW];
    [dicData setValue:@(modelRotationX) forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONX];
    [dicData setValue:@(modelRotationY) forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONY];
    [dicData setValue:@(modelRotationZ) forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONZ];
    [dicData setValue:@(modelTranslationX) forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONX];
    [dicData setValue:@(modelTranslationY) forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONY];
    [dicData setValue:@(modelTranslationZ) forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONZ];
    [dicData setValue:@(modelScale) forKey:CLASS_ACTION3D_AR_OBJSET_KEY_SCALE];
    //
    return dicData;
    
}

- (ActionModel3D_AR_ObjSetConfig*)copyObject
{
    ActionModel3D_AR_ObjSetConfig *os = [ActionModel3D_AR_ObjSetConfig new];
    os.objID = self.objID;
    os.objRemoteURL = self.objRemoteURL ? [NSString stringWithFormat:@"%@", self.objRemoteURL] : nil;
    os.objLocalURL = self.objLocalURL ? [NSString stringWithFormat:@"%@", self.objLocalURL] : nil;
    os.enableMaterialAutoIllumination = self.enableMaterialAutoIllumination;
    os.autoSizeFit = self.autoSizeFit;
    os.autoShadow = self.autoShadow;
    os.modelRotationX = self.modelRotationX;
    os.modelRotationY = self.modelRotationY;
    os.modelRotationZ = self.modelRotationZ;
    os.modelTranslationX = self.modelTranslationX;
    os.modelTranslationY = self.modelTranslationY;
    os.modelTranslationZ = self.modelTranslationZ;
    os.modelScale = self.modelScale;
    //
    return os;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - NSCoding Methods
//-------------------------------------------------------------------------------------------------------------

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.objID forKey:CLASS_ACTION3D_AR_OBJSET_KEY_ID];
    [aCoder encodeObject:self.objRemoteURL forKey:CLASS_ACTION3D_AR_OBJSET_KEY_OBJURL];
    [aCoder encodeObject:self.objLocalURL forKey:CLASS_ACTION3D_AR_OBJSET_KEY_OBJLOCALURL];
    [aCoder encodeBool:self.enableMaterialAutoIllumination forKey:CLASS_ACTION3D_AR_OBJSET_KEY_ENABLEAUTOILLUM];
    [aCoder encodeBool:self.autoSizeFit forKey:CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSIZEFIT];
    [aCoder encodeBool:self.autoShadow forKey:CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSHADOW];
    [aCoder encodeFloat:self.modelRotationX forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONX];
    [aCoder encodeFloat:self.modelRotationY forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONY];
    [aCoder encodeFloat:self.modelRotationZ forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONZ];
    [aCoder encodeFloat:self.modelTranslationX forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONX];
    [aCoder encodeFloat:self.modelTranslationY forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONY];
    [aCoder encodeFloat:self.modelTranslationZ forKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONZ];
    [aCoder encodeBool:self.modelScale forKey:CLASS_ACTION3D_AR_OBJSET_KEY_SCALE];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self != nil ){
        
        self.objID = [aDecoder decodeIntegerForKey:CLASS_ACTION3D_AR_OBJSET_KEY_ID];
        self.objRemoteURL = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_OBJSET_KEY_OBJURL];
        self.objLocalURL = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_OBJSET_KEY_OBJLOCALURL];
        self.enableMaterialAutoIllumination = [aDecoder decodeBoolForKey:CLASS_ACTION3D_AR_OBJSET_KEY_ENABLEAUTOILLUM];
        self.autoSizeFit = [aDecoder decodeBoolForKey:CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSIZEFIT];
        self.autoShadow = [aDecoder decodeBoolForKey:CLASS_ACTION3D_AR_OBJSET_KEY_AUTOSHADOW];
        self.modelRotationX = [aDecoder decodeFloatForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONX];
        self.modelRotationY = [aDecoder decodeFloatForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONY];
        self.modelRotationZ = [aDecoder decodeFloatForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MROTATIONZ];
        self.modelTranslationX = [aDecoder decodeFloatForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONX];
        self.modelTranslationY = [aDecoder decodeFloatForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONY];
        self.modelTranslationZ = [aDecoder decodeFloatForKey:CLASS_ACTION3D_AR_OBJSET_KEY_MTRANSLATIONZ];
        self.modelScale = [aDecoder decodeBoolForKey:CLASS_ACTION3D_AR_OBJSET_KEY_SCALE];
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
