//
//  AdAliveWS.h
//  AdAlive
//
//  Created by Lab360 on 16/08/16.
//  Copyright (c) 2015 Lab360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionTypes.h"

//Errors
#define E_NULL_URLSERVER            301
#define E_NULL_TARGET               302
#define E_NULL_APP_ID               303
#define E_NULL_EMAIL                304
#define E_NULL_PROMOTION_ID         305
#define E_NULL_SURVEY_ID			306
#define E_NULL_BANNER_ID			307
#define E_ITEM_NOT_FOUND            404

@class AdAliveWS;

@protocol AdAliveWSDelegate <NSObject>
/**
 *  Returns the response object from server
 */
-(void)didReceiveResponse:(AdAliveWS *)adAliveWs withSuccess:(NSDictionary *)response;
/**
 *  Returns the error from request.
 *
 */
-(void)didReceiveResponse:(AdAliveWS *)adAliveWs withError:(NSError *)error;

@end

/**
 * Class with web service methods. Allows the user to search for products and their actions on the server.
 */
@interface AdAliveWS : NSObject
/**
 * The property to access a delegate of AdAliveWS.
 */
@property(nonatomic, weak) id<AdAliveWSDelegate> delegate;
/**
 * The property with url server.
 */
@property(nonatomic, strong) NSString *urlServer;

@property(nonatomic) NSUInteger tag;
/**
 * The property with email of user.
 */
@property(nonatomic, strong) NSString *userEmail;
/**
 * The id of application from user.
 */
@property(nonatomic, strong) NSString *referenceAppID;

/**
 *  Initialize the AdAliveWS object
 *
 *  \param baseUrl The base url to get data from server.
 *  \param userEmail The email of user.
 *  \param error The property with error data, if exists.
 *
 *  \return The AdAliveWS object.
 */
- (id)initWithUrlServer:(NSString *)baseUrl andUserEmail:(NSString *)userEmail error:(NSError **)error;
/**
 *  Get the product asynchronously based on target name and application id.
 *
 *  @deprecated This method is deprecated starting in version R17.
 *  @note Please use @code findProductWithTargetName:appID: @endcode instead.
 *  \param targetName The target identifier.
 *  \param appID The id of application from user.
 */
- (void)getProductWithTargetName:(NSString *)targetName appID:(NSString *)appID __attribute__((deprecated("Use findProductWithTargetName: method")));

/**
 *  Get the action asynchronously based on target name and application id.
 *
 *  @deprecated This method is deprecated starting in version R17.
 *  @note Please use @code findActionWithID: @endcode instead.
 *  \param targetName The target identifier.
 *  \param appID The id of application from user.
 *  \param actionType The type of action required.
 *  \param actionFilter The filter to get action.
 */
- (void)getActionWithTargetName:(NSString *)targetName appID:(NSString *)appID actionType:(ActionTypes)actionType andActionFilter:(ActionFilters)actionFilter __attribute__((deprecated("Use findActionWithID: method")));

/**
 *  Get the product asynchronously based on target name and application id.
 *
 *  \param targetName The target identifier.
 *  \param appID The id of application from user.
 */
- (void)findProductWithTargetName:(NSString *)targetName appID:(NSString *)appID;

/**
 *  Get the action asynchronously based on target name and application id.
 *
 *  \param actionID The action identifier.
 */
- (void)findActionWithID:(NSString *)actionID;

/**
 *  Get the action asynchronously based on target name and application id.
 *
 *  \param appID The action identifier.
 */
- (void)getGeofenceRegionsWithAppID:(NSString *)appID;

/**
 *  Gets the information of region that user is located.
 *
 *  \param regionId The region identifier.
 *  \param type Indicates if user is entering or exiting of region.
 *  \param latitude The latitude of app user.
 *  \param longitude The longitude of app user.
 */
- (void)findInfoForRegionWithID:(NSString *)regionId andType:(int)type latitude:(double)latitude longitude:(double)longitude;

/**
 *  Gets the information of the region that user is located.
 *
 *  \param promotionId The promotion identifier.
 */
-(void)findCouponsOfPromotion:(NSNumber*)promotionId;

/**
 *  Generates a coupon of the promotion requested.
 *
 *  \param promotionId The promotion identifier.
 *  \param productId The product identifier.
 *  \param actionId The action identifier.
 */
-(void)generateCoupon:(NSNumber*)promotionId productId:(NSNumber *)productId andActionId:(NSNumber *)actionId;

/**
 *  Gets the information of the survey requested.
 *
 *  \param surveyId The survey identifier.
 */
-(void)findSurveyWithId:(NSNumber*)surveyId;

/**
 *  Sends survey responses answered by the user.
 *
 *  \param surveyId The survey identifier.
 *  \param actionId The action identifier.
 *  \param answers The list of SurveyQuestion objects.
 */
-(void)sendSurvey:(NSNumber*)surveyId actionId:(NSNumber *)actionId andAnswers:(NSArray *)answers;

/**
 *  Sends order data to AdAlive server.
 *
 *  \param companyName The name identifier.
 *  \param businessCondition The action identifier.
 *  \param customerIdentification The customer identification.
 *  \param companyTradingName The trading name of the company.
 *  \param discount The discount value.
 *  \param products The list of ProductOrder objects.
 */
-(void)sendOrderWithCompanyName:(NSString*)companyName businessCondition:(NSString *)businessCondition customerIdentification:(NSString *)customerIdentification companyTradingName:(NSString *)companyTradingName discount:(NSNumber *)discount andProducts:(NSArray *)products;

/**
 *  Finds the actual banner os the app. The list of banners is returned in circular order.
 *
 *  \param appId The app identifier.
 */
-(void)findBannerWithAppId:(NSNumber*)appId;

/**
 *  Logs in the AdAlive Server the click in banner and gets the list of the actions relacted to it.
 *
 *  \param bannerId The banner identifier.
 *  \param destinationURL The URL that should be displayed to the user when clicking on the banner.
 */
-(void)clickBannerLog:(NSNumber*)bannerId destinationURL:(NSString *)destinationURL;

/**
 *  Finds a list of beacons of a specific app.
 *
 *  \param appId The app identifier.
 */
-(void)findBeaconsWithAppId:(NSNumber*)appId;

/**
 *  Gets a list of actions relacted to beacon.
 *
 *  \param beaconId The beacon identifier.
 */
-(void)getActionsForBeacon:(NSNumber *)beaconId;

-(void)startTimeCounting;

@end
