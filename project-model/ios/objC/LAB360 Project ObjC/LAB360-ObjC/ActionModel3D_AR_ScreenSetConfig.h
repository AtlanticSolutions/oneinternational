//
//  ActionModel3D_AR_ScreenSetConfig.h
//  LAB360-ObjC
//
//  Created by Erico GT on 23/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionModel3D_AR_ScreenSetConfig : NSObject<NSCoding, NSSecureCoding>

#pragma mark - Properties
@property (nonatomic, assign) BOOL showPhotoButton;
@property (nonatomic, assign) BOOL showLightControlOption;
@property (nonatomic, strong) NSString* _Nullable screenTitle;
@property (nonatomic, strong) NSString* _Nullable footerMessage;

#pragma mark - Support Methods
+ (ActionModel3D_AR_ScreenSetConfig*)createObjectFromDictionary:(NSDictionary*)dicData;
- (NSDictionary*)dictionaryJSON;
- (ActionModel3D_AR_ScreenSetConfig*)copyObject;

#pragma mark - NSCoding Methods
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder;

#pragma mark - NSSecureCoding Methods
+ (BOOL)supportsSecureCoding;

@end
