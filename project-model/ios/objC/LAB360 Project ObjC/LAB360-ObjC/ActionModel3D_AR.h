//
//  ActionModel3D_AR.h
//  LAB360-ObjC
//
//  Created by Erico GT on 24/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionModel3D_AR_TargetImageSetConfig.h"
#import "ActionModel3D_AR_ScreenSetConfig.h"
#import "ActionModel3D_AR_ObjSetConfig.h"
#import "ActionModel3D_AR_SceneSetConfig.h"

typedef enum {
    ActionModel3DViewerTypeScene               = 1,
    ActionModel3DViewerTypeImageTarget         = 2,
    ActionModel3DViewerTypeAR                  = 3,
    ActionModel3DViewerTypePlaceableAR         = 4,
    ActionModel3DViewerTypeQuickLookAR         = 5,
    ActionModel3DViewerTypeAnimatedScene       = 6
    //ActionModel3DViewerTypeMapAR               = 10
} ActionModel3DViewerType;

typedef enum {
    ActionModel3DDataCachePolicyNever               = 0,
    ActionModel3DDataCachePolicySession             = 1,
    ActionModel3DDataCachePolicyLimited             = 2,
    ActionModel3DDataCachePolicyPermanent           = 3
} ActionModel3DDataCachePolicy;

@interface ActionModel3D_AR : NSObject<NSCoding, NSSecureCoding>

#pragma mark - Properties
@property (nonatomic, assign) long actionID;
@property (nonatomic, assign) ActionModel3DViewerType type;
@property (nonatomic, assign) ActionModel3DDataCachePolicy cachePolicy;
@property (nonatomic, strong) ActionModel3D_AR_TargetImageSetConfig* _Nullable targetImageSet;
@property (nonatomic, strong) ActionModel3D_AR_ScreenSetConfig* _Nullable screenSet;
@property (nonatomic, strong) ActionModel3D_AR_ObjSetConfig* _Nullable objSet;
@property (nonatomic, strong) ActionModel3D_AR_SceneSetConfig* _Nullable sceneSet;
//internal:
@property (nonatomic, strong) NSString* _Nullable targetID;
@property (nonatomic, assign) long productID;
@property (nonatomic, strong) NSDictionary* _Nullable productData;
//cache control:
@property (nonatomic, strong) NSDate *cacheDate;
@property (nonatomic, assign) long cacheOwnerID;

#pragma mark - Support Methods
+ (ActionModel3D_AR* _Nonnull)createObjectFromDictionary:(NSDictionary* _Nonnull)dicData;
- (NSDictionary* _Nonnull)dictionaryJSON;
- (ActionModel3D_AR* _Nonnull)copyObject;

#pragma mark - NSCoding Methods
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
- (nullable instancetype)initWithCoder:(NSCoder *_Nonnull)aDecoder;

#pragma mark - NSSecureCoding Methods
+ (BOOL)supportsSecureCoding;

@end
