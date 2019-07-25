//
//  AdAliveLogHelper.h
//  AdAliveSDK
//
//  Created by Erico GT on 08/06/18.
//  Copyright © 2018 atlantic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdAliveLogObject.h"

#define SERVICE_URL_LOG_GENERIC @"/api/v1/logs/generic"
#define SERVICE_URL_LOG_TARGET @"/api/v1/logs/target"
#define SERVICE_URL_LOG_ACTION @"/api/v1/logs/action"
#define SERVICE_URL_LOG_DEVICE @"/api/v1/logs/device"
#define SERVICE_URL_LOG_PRODUCT @"/api/v1/logs/product"
#define SERVICE_URL_LOG_ORDER @"/api/v1/logs/order"
#define SERVICE_URL_COUPON @"/api/v1/coupons"
#define SERVICE_URL_BANNER @"/api/v1/logs/banner"
#define SERVICE_URL_BANNER_CLICK @"/api/v1/logs/banner_click"
#define SERVICE_URL_SURVEY @"/api/v1/surveys"
#define SERVICE_URL_SURVEY_LOG @"/api/v1/logs/survey"
#define SERVICE_URL_LOG_TRACKING @"/api/v1/logs/user_tracking"
#define SERVICE_URL_LOG_TRACK @"/api/v1/create_geo_log"
#define SERVICE_URL_LOG_ACCESS_SCREEN @"/api/v1/logs/access/screen"
#define SERVICE_URL_BEACON_LOG @"/api/v1/logs/beacon"
#define SERVICE_URL_MASK_LOG @"/api/v1/logs/mask"
#define SERVICE_URL_LOG_ERROR @"/api/v1/logs/error"
#define SERVICE_URL_LOG_REGION_SUCCESS @"/api/v1/logs/geofence_register"

#define NEW_RELIC_EVENT_URL @"https://insights-collector.newrelic.com/v1/accounts/848422/events"
#define NEW_RELIC_EVENT_KEY @"II_5fx_XKNDrF3yIvruAzp0nANzC0ZH6"

@interface AdAliveLogHelper : NSObject

//Properties:
@property(nonatomic, strong) NSString *urlServer;
@property(nonatomic, strong) NSString *userEmail;
@property(nonatomic, strong) NSString *helperAgent;

//Constructor:
+ (AdAliveLogHelper *)sharedInstance;

//Configuration:
- (void) setUrlServer:(NSString *)urlServer userEmail:(NSString *)userEmail agent:(NSString*)agent;

//Methods:
- (void)useSelfDataGPS:(BOOL)useGPS;
- (BOOL)deviceLogReported;
- (void)logDataToServer:(AdAliveLogObject*)logObject;

@end
