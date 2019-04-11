//
//  ConnectionManager.h
//  AdAlive
//
//  Created by Monique Trevisan on 11/25/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "Reachability.h"
#import "ToolBox.h"

@protocol ConnectionManagerDelegate <NSObject>

@optional
-(void)didConnectWithSuccess:(NSDictionary *)response;
-(void)didConnectWithFailure:(NSError *)error;
-(void)didConnectWithSuccessData:(NSData *)responseData;
-(void)downloadProgress:(float)dProgress;

@end

@interface ConnectionManager : NSObject <NSURLConnectionDelegate>

@property(nonatomic, assign) id<ConnectionManagerDelegate> delegate;

//+ (id)sharedInstance;
- (BOOL)isConnectionActive;
- (NSString*)getServerPreference;
- (NSString*)getServerAHKPreference;
- (NSString*)getServerChatPreference;

//Config
- (void)getRemoteDataFromMasterServerUsingURLParameters:(NSString *)urlParameters withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)getAppConfig:(long)appId andRole:(NSString *)role withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)getAboutPageWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
//login
- (void)authenticateUserUsingParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)authenticateUserByFacebookWithParameters:(NSDictionary*)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

//user data
- (void)resetUserPassword:(NSString *)email withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)createUserUsingParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)updateUserUsingParameters:(NSDictionary *)dicParameters withUserID:(int)ID withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)authenticateUserCode:(NSString *)code withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

//events
- (void)getAllEventsAvailableForMasterEventID:(long)masterEventID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
- (void)subscribeToEventUsingParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)sendEventInfoToServerForMasterEventID:(long)masterEventID withParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)removeEventInfoFromServerForMasterEventID:(long)masterEventID withParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)getEventsForUser:(long)userId andMasterEventID:(long)masterEventID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

//downloads
- (void)getDownloadsForEvent:(long)eventID andMasterEventID:(long)masterEventID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)getDownloadsForMasterEvent:(long)masterEventID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)downloadFileFromURL:(NSURL*)fileURL WithCompletionHandler:(void (^)(NSData *response, NSError *error)) handler;
- (void)cancelCurrentDownload;


//associates
- (void)getHiveOfActivitiesListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;

//contacts
- (void)getContactsListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;

//timeline
- (void)getTimelineListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
- (void)sendPhoto100YearsWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
-(void)createPostWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

//feed video
- (void)getFeedVideoWithAppID:(long)appID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
- (void)getParticipantsWithMasterEventID:(long)masterEventID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)getNotificationsWithUserID:(int)userID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

//news portal
- (void)getPortalNewsCategoriesWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
- (void)getPortalNewsUsingPostURL:(NSString*)urlNews WithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;

//chat
- (void)getMessagesFromSingleChatWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)postMessageToSingleChatWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)postMessageToGroupChatWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
//
- (void)registerAPSTokenWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)unregisterAPSTokenWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)postMessageInChatWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)getGroupsListForUserID:(int)userID fromAccountID:(int)accountID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
- (void)getAllGroupsFromAccountID:(int)accountID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
- (void)getAllUsersFromAccountID:(int)accountID forUser:(int)userID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
- (void)getPersonalChatListForUserID:(int)userID fromAccountID:(int)accountID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)getSpeakersChatListForUserID:(int)userID fromAccountID:(int)accountID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)addUserToGroupWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)removeUserFromGroupWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)blockOrUnblockUserWithParamters:(NSDictionary *)dicParameters FromUser:(int)userID blocking:(bool)blocking withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

//category
- (void)getCategoryListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;

//sector
- (void)getSectorsListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;

//get layout parameters
- (void)getLayoutDefinitions:(int)appId masterEventId:(long)masterEventId WithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

//sponsor
- (void)getSponsorForMasterEventID:(long)masterEventID ListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
- (void)getSponsorsPlansWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
-(void)getPointsStatementWithUserID:(long)userID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

//about
- (void)getMessageAboutAccountID:(int)accountID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
-(void)getInitialConfigurationsWithUserID:(long)userID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

//post
- (void)postCreatePostWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)getJobRolesListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
- (void)getPostsWithLimit:(long)limit fromMasterEventID:(long)masterEventID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
- (void)getPostsFromMasterEventID:(long)masterEventID postID:(long)postID andType:(NSString *)type withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
- (void)postRemovePostWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
//
- (void)postReadPersonalChat:(long)chatID user:(long)userID senderUserID:(long)senderUserID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)postAddLikeForPost:(long)postID user:(long)userID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)postRemoveLikeForPost:(long)postID user:(long)userID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
//
- (void)postAddCommentForPost:(long)postID userID:(long)userID message:(NSString*)commentMessage withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)postUpdateCommentForPost:(long)postID userID:(long)userID commentID:(long)commentID message:(NSString*)commentMessage withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)postRemoveCommentForPost:(long)postID userID:(long)userID commentID:(long)commentID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
//
- (void)pushNotificationInteractionFeedbackFor:(long)notificationID user:(long)userID action:(NSString*)actionChosen withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

// Distributor
- (void)postDistributorSignup:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
//- (void)getAddressByCEP:(NSString *)cep withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)findAddressByCEP:(NSString*)cep withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;

//Survey
- (void)loadSurveyWithId:(NSString *)idSurvey withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)surveyLogWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)loadProductWithId:(NSString *)idString withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

//Products (Mais Amigas)
- (void)MA_getUpdatedProducts:(NSString*)localDate withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)MA_getAllCatalogsWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)MA_getAllCategoriesWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
//Order Payment
- (void)MA_getPrePaymentOrderWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)MA_sendShopOrderUsingParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)MA_validateCoupon:(NSString*)coupon withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;

// Orders
- (void)getOrdersWithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)getOrderHistoryFor:(NSString*)orderID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
- (void)MA_getOrderItemsDetailFor:(long)orderID withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;

// Catalogs
- (void)getCatalogsWithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

// Points
- (void)MA_getPointsStatementWithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

// Categories
- (void)getCategoriesWithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

// MA_Profile
- (void)getProfileInfosWithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

//Promotions
- (void)getAvailablePromotionsWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)postRegisterUserInPromotionUsingParameters:(NSDictionary*)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)getCostumerWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)getCostumerDataUsingCPF:(NSString*)cpf withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)getExtractsForPromotion:(long)promotionID withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)postConsumeExtractBalanceForPromotion:(long)promotionID andUserCPF:(NSString*)cpf withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;

//Invoices
- (void)getMyInvoicesWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)postInvoicePhotoUsingParameters:(NSDictionary*)dicParameters WithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;

//Stores
- (void)getShoppingStoresWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;

//Categories
- (void)getCategories:(NSString*)type limit:(NSString*)limit offset:(NSString*)offset category_id:(NSString*)catId withCompletionHandler:(void (^)(NSDictionary * response, NSInteger statusCode, NSError * error)) handler;
- (void)getVideosWithLimit:(NSString*)limit offset:(NSString*)offset videoId:(NSString*)videoId category_id:(NSString*)catId subcategory_id:(NSString*)subcatId tag:(NSString*)tag withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)getDocumentsWithLimit:(NSString*)limit offset:(NSString*)offset documentId:(NSString*)videoId category_id:(NSString*)catId subcategory_id:(NSString*)subcatId tag:(NSString*)tag withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;

#pragma mark - Exemplos
- (void)getTicketDiscountInfo:(NSString*)ticketCode consumerID:(int)consumerID withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void)consumeTicketDiscount:(NSDictionary*)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;

@end
