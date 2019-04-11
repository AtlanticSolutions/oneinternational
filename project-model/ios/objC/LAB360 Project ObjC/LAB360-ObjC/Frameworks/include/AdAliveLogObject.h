//
//  AdAliveLogObject.h
//  AdAliveSDK
//
//  Created by Erico GT on 08/06/18.
//  Copyright © 2018 atlantic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import "AdAliveGenericLogPackage.h"

typedef enum : NSUInteger {
    GenericLogType               = 0,
    DeviceLogType                = 1,
    TargetLogType                = 2,
    ProductLogType               = 3,
    FavoriteLogType              = 4,
    IdentifiedLogType            = 5,
    RecommendationLogType        = 6,
    ActionLogType                = 7,
    BeaconLogType                = 8,
    OrderLogType                 = 9,
    CouponLogType                = 10,
    BannerClickLogType           = 11,
    SurveyLogType                = 12,
    NewRelicLogType              = 13,
    MaskLogType                  = 14,
    AccessScreenLogType          = 15,
    TrackingLogType              = 16,
    GeofenceLogType              = 17,
    ErrorLogType                 = 18
} AdAliveLogType;

@interface AdAliveLogObject : NSObject

//Properties
@property (nonatomic, assign) AdAliveLogType type;
@property (nonatomic, assign) long actionID;
@property (nonatomic, assign) NSString *appID;
@property (nonatomic, assign) NSString *geofenceID;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, assign) long metaID;
@property (nonatomic, strong) NSString *screen;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *targetName;
@property (nonatomic, assign) long productID;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) AdAliveGenericLogPackage *genericLogPackage;
//
@property (nonatomic, strong) NSString *email;

//Methods
- (NSDictionary*)dictionaryJSONtoLogHelperAgent:(NSString*)agent;

@end
