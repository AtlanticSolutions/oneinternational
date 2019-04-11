//
//  RegionService.h
//  LAB360-ObjC
//
//  Created by Erico GT on 22/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GeofenceRegion.h"
//
#define KEY_ENTER_REGION_LOCATION_NOTIFICATION @"KEY_ENTER_REGION_LOCATION_NOTIFICATION"
#define KEY_EXIT_REGION_LOCATION_NOTIFICATION @"KEY_EXIT_REGION_LOCATION_NOTIFICATION"

@class RegionService;

@protocol RegionServiceDelegate<NSObject>
@optional
- (void)regionService:(RegionService*)regionService didStartMonitoringToRegion:(NSString*)regionIdentifier;
- (void)regionService:(RegionService*)regionService didEnterInRegion:(NSString*)regionIdentifier;
- (void)regionService:(RegionService*)regionService didExitFromRegion:(NSString*)regionIdentifier;
- (void)regionService:(RegionService*)regionService didFailMonitoringToRegion:(NSString*)regionIdentifier withError:(NSError*)error;
@end


@interface RegionService : NSObject<CLLocationManagerDelegate>

//Properties:
@property(nonatomic, weak) id<RegionServiceDelegate> delegate;

//Methods:
+ (RegionService*)newRegionService;
//
- (void)registerRegionsToMonitor:(NSArray<GeofenceRegion*>*)regions;
- (void)startMonitoringRegisteredRegions;
- (void)stopMonitoringRegisteredRegions;
- (void)stopMonitoringEspecificRegion:(GeofenceRegion*)region;
- (void)restartMessagesForAllMonitoredRegions;

@end
