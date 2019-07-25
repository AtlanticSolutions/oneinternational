//
//  ActionModel3D_AR_ImageSetConfig.h
//  LAB360-ObjC
//
//  Created by Erico GT on 23/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionModel3D_AR_TargetImageSetConfig : NSObject<NSCoding, NSSecureCoding>

#pragma mark - Properties
@property (nonatomic, assign) long imageID;
@property (nonatomic, strong) NSString* _Nullable imageURL;
@property (nonatomic, assign) float physicalWidth;
@property (nonatomic, strong) UIImage* _Nullable image;

#pragma mark - Support Methods
+ (ActionModel3D_AR_TargetImageSetConfig* _Nonnull)createObjectFromDictionary:(NSDictionary* _Nonnull)dicData;
- (NSDictionary* _Nonnull)dictionaryJSON;
- (ActionModel3D_AR_TargetImageSetConfig* _Nonnull)copyObject;

#pragma mark - NSCoding Methods
- (void)encodeWithCoder:(NSCoder* _Nonnull)aCoder;
- (nullable instancetype)initWithCoder:(NSCoder* _Nonnull)aDecoder;

#pragma mark - NSSecureCoding Methods
+ (BOOL)supportsSecureCoding;

@end
