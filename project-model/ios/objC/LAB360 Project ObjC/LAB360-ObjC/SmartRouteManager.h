//
//  SmartRouteManager.h
//  Siga
//
//  Created by Erico GT on 27/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
//
#import "SmartRouteInterestPoint.h"
#import "DataSourceResponse.h"

#define SMART_ROUTE_GEOFENCE_MODE NO

@class SmartRouteManager;

@protocol SmartRouteManagerDelegate <NSObject>

@required

- (void)smartRouteManager:(SmartRouteManager* _Nonnull)manager didUpdateCurrentInterestPoint:(SmartRouteInterestPoint* _Nullable)interestPoint;

@end

#pragma mark - Class

@interface SmartRouteManager : NSObject

//Properties:
@property(nonatomic, weak) id <SmartRouteManagerDelegate> _Nullable delegate;
@property(nonatomic, strong) NSDate* _Nullable lastUpdate;
@property(nonatomic, assign) NSTimeInterval timeBetweenBanners;

//Methods:
- (void) updateBannersFromServerWithCompletionHandler:(void (^_Nullable)(DataSourceResponse* _Nonnull response)) handler;
- (void) startUpdatingUserLocation;
- (void) stopUpdatingUserLocation;
- (NSArray<SmartRouteInterestPoint*>* _Nonnull) getBannersList;

@end
