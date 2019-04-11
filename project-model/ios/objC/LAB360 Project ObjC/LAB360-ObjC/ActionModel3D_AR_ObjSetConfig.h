//
//  ActionModel3D_AR_ObjSetConfig.h
//  LAB360-ObjC
//
//  Created by Erico GT on 23/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ActionModel3DViewerFileTypeOBJ         = 1,
    ActionModel3DViewerFileTypeSCN         = 2,
    ActionModel3DViewerFileTypeUSDZ        = 3,
    ActionModel3DViewerFileTypeSFB         = 4,
    ActionModel3DViewerFileTypeDefault = ActionModel3DViewerFileTypeOBJ
} ActionModel3DViewerFileType;

@interface ActionModel3D_AR_ObjSetConfig : NSObject<NSCoding, NSSecureCoding>

#pragma mark - Properties
@property (nonatomic, assign) long objID;
@property (nonatomic, strong) NSString *objRemoteURL;
@property (nonatomic, strong) NSString *objLocalURL;
@property (nonatomic, assign) BOOL enableMaterialAutoIllumination;
@property (nonatomic, assign) BOOL autoSizeFit;
@property (nonatomic, assign) BOOL autoShadow;
@property (nonatomic, assign) float modelRotationX;
@property (nonatomic, assign) float modelRotationY;
@property (nonatomic, assign) float modelRotationZ;
@property (nonatomic, assign) float modelTranslationX;
@property (nonatomic, assign) float modelTranslationY;
@property (nonatomic, assign) float modelTranslationZ;
@property (nonatomic, assign) float modelScale;

#pragma mark - Support Methods
+ (ActionModel3D_AR_ObjSetConfig*)createObjectFromDictionary:(NSDictionary*)dicData;
- (NSDictionary*)dictionaryJSON;
- (ActionModel3D_AR_ObjSetConfig*)copyObject;

#pragma mark - NSCoding Methods
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder;

#pragma mark - NSSecureCoding Methods
+ (BOOL)supportsSecureCoding;

@end
