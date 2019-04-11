//
//  BeaconService.h
//  LAB360-ObjC
//
//  Created by Erico GT on 09/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LaBeacon.h"
//
#define KEY_ENTER_REGION_BEACON_NOTIFICATION @"KEY_ENTER_REGION_BEACON_NOTIFICATION"
#define KEY_EXIT_REGION_BEACON_NOTIFICATION @"KEY_EXIT_REGION_BEACON_NOTIFICATION"

typedef enum {
    BeaconServiceTypeMonitoring        = 1,
    BeaconServiceTypeRanging           = 2
} BeaconServiceType;

@interface BeaconService : NSObject<CLLocationManagerDelegate>

//Properties:
@property(nonatomic, assign, readonly) BeaconServiceType serviceType;
@property(nonatomic, assign) long secondsToReportBeaconEvents;

//Methods:
+ (BeaconService*)newBeaconService;
//
- (void)registerBeaconsToMonitor:(NSArray<LaBeacon*>*)beacons;
- (void)startMonitoringRegisteredBeaconsUsingServiceType:(BeaconServiceType)type;
- (void)stopMonitoringRegisteredBeacons;
- (void)stopMonitoringEspecificBeacon:(LaBeacon*)beacon;
- (void)restartMessagesForAllMonitoredBeacons;

@end
