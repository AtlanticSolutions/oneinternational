//
//  AdAliveGeofence.h
//
//  Created by Lab360 on 20/02/17.
//  Copyright © 2017 atlantic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define E_NULL_URLSERVER            301
#define ADALIVE_GEOFENCE_PUSHNOTIFICATION_CATEGORY_NAME @"br.com.atlanticsolutions.adalive.pushnotification"

@protocol AdAliveGeofenceDelegate <NSObject>

@optional
-(void)didRegisterAllRegions;
-(void)didReceivePushMessage:(NSString *)message;
-(void)didReceiveRequestWithError;

@end

@interface AdAliveGeofence : NSObject

@property(nonatomic, assign) id<AdAliveGeofenceDelegate> delegate;
/**
 * The property with url server.
 */
@property(nonatomic, strong) NSString *urlServer;
/**
 * The property with app id.
 */
@property(nonatomic, strong) NSString *appID;

/**
 * The property with email of user.
 */
@property(nonatomic, strong) NSString *email;

/**
 * The property with distance to update user's location.
 */
@property(nonatomic, strong) NSNumber *distanceFilter;

/**
 * The property with distance to update user's location.
 */
@property(nonatomic, strong) NSNumber *geofenceTime;
+ (id)sharedManager;

/**
 *  Returns the AdAliveGeofence object for the process.
 *
 *  \param urlServer Base url from log server;
 *  \param appID A identification to filter the correct regions;
 *  \param error A object that return the error if exixts;
 *  \return The AdAliveGeofence object.
 */
- (id)initWithUrlServer:(NSString *)urlServer appID:(NSString *)appID andEmail:(NSString *)email error:(NSError **)error;

/**
 *  Register the list of regions to monitoring.
 **  \param regionList List of regions;
 */
-(void)registerAppToGeofencingWithRegions:(NSArray *)regionList;


@end
