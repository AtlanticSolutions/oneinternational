//
//  ActionModel3D_AR.m
//  LAB360-ObjC
//
//  Created by Erico GT on 24/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "ActionModel3D_AR.h"
#import "ConstantsManager.h"
#import "ToolBox.h"

#define CLASS_ACTION3D_AR_DEFAULT @"action_model_3d"
#define CLASS_ACTION3D_AR_KEY_ID @"id"
#define CLASS_ACTION3D_AR_KEY_TYPE @"type"
#define CLASS_ACTION3D_AR_KEY_CACHEPOLICY @"cache_policy"
#define CLASS_ACTION3D_AR_KEY_IMAGESET @"target_image_set"
#define CLASS_ACTION3D_AR_KEY_SCREENSET @"screen_set"
#define CLASS_ACTION3D_AR_KEY_OBJSET @"obj_set"
#define CLASS_ACTION3D_AR_KEY_SCENESET @"scene_set"
#define CLASS_ACTION3D_AR_KEY_TARGETID @"target_id"
#define CLASS_ACTION3D_AR_KEY_PRODUCTID @"product_id"
#define CLASS_ACTION3D_AR_KEY_PRODUCTDATA @"product_data"
#define CLASS_ACTION3D_AR_KEY_CACHEDATE @"cache_date"
#define CLASS_ACTION3D_AR_KEY_CACHEOWNER @"cache_owner"

@implementation ActionModel3D_AR

@synthesize actionID, type, cachePolicy, cacheDate, cacheOwnerID, targetImageSet, screenSet, objSet, sceneSet, targetID, productID, productData;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        actionID = 0;
        type = ActionModel3DViewerTypeScene;
        cachePolicy = ActionModel3DDataCachePolicyNever;
        targetImageSet = [ActionModel3D_AR_TargetImageSetConfig new];
        screenSet = [ActionModel3D_AR_ScreenSetConfig new];
        objSet = [ActionModel3D_AR_ObjSetConfig new];
        sceneSet = [ActionModel3D_AR_SceneSetConfig new];
        //
        targetID = nil;
        productID = 0;
        productData = nil;
        //
        cacheDate = nil;
        cacheOwnerID = 0;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Support Methods
//-------------------------------------------------------------------------------------------------------------

+ (ActionModel3D_AR*)createObjectFromDictionary:(NSDictionary*)dicData
{
    ActionModel3D_AR *m3d = [ActionModel3D_AR new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        m3d.actionID = [keysList containsObject:CLASS_ACTION3D_AR_KEY_ID] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_KEY_ID] longValue] : m3d.actionID;
        
        int enumType = [keysList containsObject:CLASS_ACTION3D_AR_KEY_TYPE] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_KEY_TYPE] intValue] : m3d.type;
        m3d.type = (enumType >= ActionModel3DViewerTypeScene && enumType <= ActionModel3DViewerTypeAnimatedScene) ? enumType : m3d.type;
        
        int enumRotation = [keysList containsObject:CLASS_ACTION3D_AR_KEY_CACHEPOLICY] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_KEY_CACHEPOLICY] intValue] : m3d.cachePolicy;
        m3d.cachePolicy = (enumRotation >= ActionModel3DDataCachePolicyNever && enumRotation <= ActionModel3DDataCachePolicyPermanent) ? enumRotation : m3d.cachePolicy;
        
//        if ([keysList containsObject:CLASS_ACTION3D_AR_KEY_IMAGESET]){
//            id iSet = [neoDic objectForKey:CLASS_ACTION3D_AR_KEY_IMAGESET];
//            if ([iSet isKindOfClass:[NSArray class]]){
//                for (NSDictionary *dic in iSet){
//                    ActionModel3D_AR_ImageSetConfig *set = [ActionModel3D_AR_ImageSetConfig createObjectFromDictionary:dic];
//                    [m3d.imageSet addObject:set];
//                }
//            }
//        }
        
        m3d.targetImageSet = [keysList containsObject:CLASS_ACTION3D_AR_KEY_IMAGESET] ? [ActionModel3D_AR_TargetImageSetConfig createObjectFromDictionary: [neoDic valueForKey:CLASS_ACTION3D_AR_KEY_IMAGESET]] : m3d.targetImageSet;
        
        m3d.screenSet = [keysList containsObject:CLASS_ACTION3D_AR_KEY_SCREENSET] ? [ActionModel3D_AR_ScreenSetConfig createObjectFromDictionary: [neoDic valueForKey:CLASS_ACTION3D_AR_KEY_SCREENSET]] : m3d.screenSet;
        
        m3d.objSet = [keysList containsObject:CLASS_ACTION3D_AR_KEY_OBJSET] ? [ActionModel3D_AR_ObjSetConfig createObjectFromDictionary: [neoDic valueForKey:CLASS_ACTION3D_AR_KEY_OBJSET]] : m3d.objSet;
        
        m3d.sceneSet = [keysList containsObject:CLASS_ACTION3D_AR_KEY_SCENESET] ? [ActionModel3D_AR_SceneSetConfig createObjectFromDictionary: [neoDic valueForKey:CLASS_ACTION3D_AR_KEY_SCENESET]] : m3d.sceneSet;
        
        //Os seguintes campos não vem na action, precisando ser atribuídos posteriormente:
        
        m3d.targetID = [keysList containsObject:CLASS_ACTION3D_AR_KEY_TARGETID] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ACTION3D_AR_KEY_TARGETID]] : m3d.targetID;
        
        m3d.productID = [keysList containsObject:CLASS_ACTION3D_AR_KEY_PRODUCTID] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_KEY_PRODUCTID] longValue] : m3d.productID;
        
        if ([keysList containsObject:CLASS_ACTION3D_AR_KEY_PRODUCTDATA]){
            id p = [neoDic objectForKey:CLASS_ACTION3D_AR_KEY_PRODUCTDATA];
            if ([p isKindOfClass:[NSDictionary class]]){
                m3d.productData = [[NSDictionary alloc] initWithDictionary:[neoDic objectForKey:CLASS_ACTION3D_AR_KEY_PRODUCTDATA]];
            }
        }
        
        if ([keysList containsObject:CLASS_ACTION3D_AR_KEY_CACHEDATE]){
            NSString *date = [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ACTION3D_AR_KEY_CACHEDATE]];
            m3d.cacheDate = [ToolBox dateHelper_DateFromString:date withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA];
        }
        
        m3d.cacheOwnerID = [keysList containsObject:CLASS_ACTION3D_AR_KEY_CACHEOWNER] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_KEY_CACHEOWNER] longValue] : m3d.cacheOwnerID;
        
    }
    
    return m3d;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.actionID) forKey:CLASS_ACTION3D_AR_KEY_ID];
    [dicData setValue:@(self.type) forKey:CLASS_ACTION3D_AR_KEY_TYPE];
    [dicData setValue:@(self.cachePolicy) forKey:CLASS_ACTION3D_AR_KEY_CACHEPOLICY];
    [dicData setValue:(self.targetImageSet ? [self.targetImageSet dictionaryJSON] : [NSDictionary new]) forKey:CLASS_ACTION3D_AR_KEY_IMAGESET];
    [dicData setValue:(self.screenSet ? [self.screenSet dictionaryJSON] : [NSDictionary new]) forKey:CLASS_ACTION3D_AR_KEY_SCREENSET];
    [dicData setValue:(self.objSet ? [self.objSet dictionaryJSON] : [NSDictionary new]) forKey:CLASS_ACTION3D_AR_KEY_OBJSET];
    [dicData setValue:(self.sceneSet ? [self.sceneSet dictionaryJSON] : [NSDictionary new]) forKey:CLASS_ACTION3D_AR_KEY_SCENESET];
    //
    [dicData setValue:(self.targetID ? [NSString stringWithFormat:@"%@", self.targetID] : @"") forKey:CLASS_ACTION3D_AR_KEY_TARGETID];
    [dicData setValue:@(self.productID) forKey:CLASS_ACTION3D_AR_KEY_PRODUCTID];
    [dicData setValue:(self.productData ? self.productData : [NSDictionary new]) forKey:CLASS_ACTION3D_AR_KEY_PRODUCTDATA];
    [dicData setValue:(self.cacheDate ? [ToolBox dateHelper_StringFromDate:self.cacheDate withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] : @"") forKey:CLASS_ACTION3D_AR_KEY_CACHEDATE];
    [dicData setValue:@(self.cacheOwnerID) forKey:CLASS_ACTION3D_AR_KEY_CACHEOWNER];
    //
    return dicData;
}

- (ActionModel3D_AR*)copyObject
{
    ActionModel3D_AR *m3d = [ActionModel3D_AR new];
    m3d.actionID = self.actionID;
    m3d.type = self.type;
    m3d.cachePolicy = self.cachePolicy;
//    if (self.imageSet){
//        for (ActionModel3D_AR_ImageSetConfig *is in self.imageSet){
//            [m3d.imageSet addObject:[is copyObject]];
//        }
//    }else{
//        m3d.imageSet = nil;
//    }
    m3d.targetImageSet = self.targetImageSet ? [self.targetImageSet copyObject] : nil;
    m3d.screenSet = self.screenSet ? [self.screenSet copyObject] : nil;
    m3d.objSet = self.objSet ? [self.objSet copyObject] : nil;
    m3d.sceneSet = self.sceneSet ? [self.sceneSet copyObject] : nil;
    //
    m3d.targetID = self.targetID ? [NSString stringWithFormat:@"%@", self.targetID] : @"";
    m3d.productID = self.productID;
    if (self.productData){
        //deep copy parameter:
        NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:self.productData];
        m3d.productData = [[NSDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:dicData]];
    }else{
        m3d.productData = nil;
    }
    m3d.cacheDate = [ToolBox dateHelper_CopyDate:self.cacheDate];
    m3d.cacheOwnerID = self.cacheOwnerID;
    //
    return m3d;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - NSCoding Methods
//-------------------------------------------------------------------------------------------------------------

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.actionID forKey:CLASS_ACTION3D_AR_KEY_ID];
    [aCoder encodeInteger:self.type forKey:CLASS_ACTION3D_AR_KEY_TYPE];
    [aCoder encodeInteger:self.cachePolicy forKey:CLASS_ACTION3D_AR_KEY_CACHEPOLICY];
    [aCoder encodeObject:self.targetImageSet forKey:CLASS_ACTION3D_AR_KEY_IMAGESET];
    [aCoder encodeObject:self.screenSet forKey:CLASS_ACTION3D_AR_KEY_SCREENSET];
    [aCoder encodeObject:self.objSet forKey:CLASS_ACTION3D_AR_KEY_OBJSET];
    [aCoder encodeObject:self.sceneSet forKey:CLASS_ACTION3D_AR_KEY_SCENESET];
    //
    [aCoder encodeObject:self.targetID forKey:CLASS_ACTION3D_AR_KEY_TARGETID];
    [aCoder encodeInteger:self.productID forKey:CLASS_ACTION3D_AR_KEY_PRODUCTID];
    [aCoder encodeObject:self.productData forKey:CLASS_ACTION3D_AR_KEY_PRODUCTDATA];
    [aCoder encodeObject:self.cacheDate forKey:CLASS_ACTION3D_AR_KEY_CACHEDATE];
    [aCoder encodeInteger:self.cacheOwnerID forKey:CLASS_ACTION3D_AR_KEY_CACHEOWNER];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self != nil ){
        
        self.actionID = [aDecoder decodeIntegerForKey:CLASS_ACTION3D_AR_KEY_ID];
        self.type = (int)[aDecoder decodeIntegerForKey:CLASS_ACTION3D_AR_KEY_TYPE];
        self.cachePolicy = (int)[aDecoder decodeIntegerForKey:CLASS_ACTION3D_AR_KEY_CACHEPOLICY];
        self.targetImageSet = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_KEY_IMAGESET];
        self.screenSet = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_KEY_SCREENSET];
        self.objSet = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_KEY_OBJSET];
        self.sceneSet = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_KEY_SCENESET];
        //
        self.targetID = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_KEY_TARGETID];
        self.productID = [aDecoder decodeIntegerForKey:CLASS_ACTION3D_AR_KEY_PRODUCTID];
        self.productData = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_KEY_PRODUCTDATA];
        self.cacheDate = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_KEY_CACHEDATE];
        self.cacheOwnerID = [aDecoder decodeIntegerForKey:CLASS_ACTION3D_AR_KEY_CACHEOWNER];
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
