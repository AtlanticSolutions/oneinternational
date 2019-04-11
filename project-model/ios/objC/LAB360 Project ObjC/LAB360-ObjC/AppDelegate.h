//
//  AppDelegate.h
//  AHK-100anos
//
//  Created by Erico GT on 9/29/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <CoreData/CoreData.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <FirebaseInstanceID/FirebaseInstanceID.h>
#import <Firebase/Firebase.h>
#import <UserNotifications/UserNotifications.h>

//Managers
#import "ConstantsManager.h"
#import "ConnectionManager.h"
#import "FileManager.h"
#import "AppStyleManager.h"
#import "AsyncImageDownloader.h"
#import "BeaconService.h"
#import "SoundManager.h"
#import "DevDataLogger.h"
#import "AdAliveVideoCacheManager.h"
#import "AdAliveImageCacheManager.h"
#import "TimelineVideoCacheManager.h"
#import "TimelineVideoPlayerManager.h"

//Views
#import "LoadingView.h"
#import "SCLAlertView.h"
#import "SCLAlertViewPlus.h"
#import "VC_SideMenu.h"
#import "VC_ContactsChat.h"
#import "VC_VideoPlayer.h"
#import "MessageNotificationView.h"
#import "VC_Notifications.h"
#import "BeaconShowroomLiveCamVC.h"
#import "BeaconShowroomRadarVC.h"
#import "SideMenuConfig.h"

//Classes
#import "ToolBox.h"
#import "User.h"
#import "Event.h"
#import "DownloadItem.h"
#import "ChatMessage.h"
#import "NotificationInteraction.h"

//fb
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, strong) UIViewController* rootViewController;
//@property (nonatomic, strong) NSString* startTimestamp;

//Classes
@property(nonatomic, strong) User *loggedUser;
@property(nonatomic, strong) NSMutableArray<Event*> *eventsList;
@property(nonatomic, strong) NSMutableArray<DownloadItem*> *downloadsList;
@property(nonatomic, strong) NSString *tokenFirebase;
@property(nonatomic, assign) bool openedByNotification;
@property(nonatomic, assign) long masterEventID;
@property(nonatomic, strong) NSString *appName;
@property(nonatomic, strong) NotificationInteraction *notificationInteraction;
@property(nonatomic, assign) bool mainMenuLoaded;
@property(nonatomic, assign) bool forceTimelineUpdate;
@property(nonatomic, assign) BOOL chatInteractionEnabled;
@property(nonatomic, strong) NSURL *urlFileAdAliveIncoming;

//Managers
@property(nonatomic, strong) AppStyleManager *styleManager;
@property(nonatomic, strong) NSMutableDictionary *styleForRole;
@property(nonatomic, strong) ConnectionManager *downloadConnectionManager;
@property(nonatomic, strong) BeaconService *beaconsManager;
@property(nonatomic, strong) SoundManager *soundManager;
@property(nonatomic, strong) DevDataLogger *devLogger;
@property(nonatomic, strong) AdAliveVideoCacheManager *adAliveVideoCacheManager;
@property(nonatomic, strong) AdAliveImageCacheManager *adAliveImageCacheManager;
@property(nonatomic, strong) TimelineVideoCacheManager *timelineVideoCacheManager;
@property(nonatomic, strong) TimelineVideoPlayerManager *timelineVideoPlayerManager;

//- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//User Control
- (bool)registerLoginForUser:(NSString*)userEmail data:(NSDictionary*)userData;
- (bool)registerLogoutForCurrentUser;
- (void)checkUserAuthenticationToken;

//Loading Control
- (void) showLoadingAnimationWithType:(enumActivityIndicator)type;
- (void) hideLoadingAnimation;
- (void) updateLoadingAnimationMessage:(NSString*)message;
- (void) updateLoadingFrameUsingSize:(CGSize)size;

//Side Menu
- (void)showSideMenu;
- (void)setSideMenuDelegate:(id<SideMenuDelegate>)delegate;
- (void)setSideMenuConfigurations:(SideMenuConfig*)config;
- (void)callForBarButtonsItems;

//Identificador de Ambiente
- (NSString*)serverEnvironmentIdentifier;

//Downloads Control
- (void)loadDownloadsList;
- (void)saveAndUpdateDownloadsList:(NSArray*)list;

//Fake Factory Helper
- (UIImage*)createDefaultBackgroundImage;
- (SCLAlertViewPlus*)createDefaultAlert;
- (SCLAlertViewPlus*)createLargeAlert;
- (SCLAlertViewPlus*)createDefaultRichAlert:(NSString*)bodyMessage images:(NSArray<UIImage*>*)imageList animationTimePerFrame:(NSTimeInterval)time;
- (SCLAlertViewPlus*)createLargeRichAlert:(NSString*)bodyMessage images:(NSArray<UIImage*>*)imageList animationTimePerFrame:(NSTimeInterval)time;
- (UIBarButtonItem*)createProfileButton;
- (UIView*)createAcessoryViewWithTarget:(UIView*)target andSelector:(SEL)selector;

//Push Notifications
- (bool)isEnableForRemoteNotifications;
- (void)registerForRemoteNotifications;
- (void)removeForRemoteNotifications;
- (ChatMessage*)chatMessageFromDictionary:(NSDictionary*)notificationDictionary;

//Style
- (void)setStyleManagerWithStyle:(NSDictionary *)appDic;
- (void)loadStyleManagerRoles:(NSDictionary *)dicRoles;
- (UIStatusBarStyle)statusBarStyleForViewController:(UIViewController*)viewController;

//Web Server
- (NSString*)startWebServerLogger;
- (NSString*)stopWebServerLogger;
- (NSString*)webServerLoggerStatus;
- (BOOL)webServerLoggerIsRunning;

//AdAliveLogs
- (void)logAdAliveActionWithID:(long)actionID;
- (void)logAdAliveProductWithID:(long)productID;
- (void)logAdAliveEventWithName:(NSString*)eventName data:(NSDictionary*)eventData;

@end

