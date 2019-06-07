//
//  AppDelegate.m
//  AHK-100anos
//
//  Created by Erico GT on 9/29/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "ConstantsManager.h"
#import "PanoramaViewerVC.h"
#import "Video360VC.h"
#import "HTYGLKVC.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "AdAliveLogHelper.h"
#import "AdAliveWS.h"
#import "AdAliveGeofence.h"
#import "AppConfigDataSource.h"
#import "StoreReviewHelper.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@property (nonatomic, strong) VC_SideMenu *viewMenu;
@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) MessageNotificationView *messageNotificationView;
//
@property (nonatomic, strong) GCDWebServer *webServerLogger;

@end

@implementation AppDelegate

@synthesize styleManager, openedByNotification, downloadConnectionManager, masterEventID, notificationInteraction, mainMenuLoaded, forceTimelineUpdate, chatInteractionEnabled, appName, beaconsManager, soundManager, devLogger, urlFileAdAliveIncoming;
@synthesize rootViewController, viewMenu, loadingView;
@synthesize loggedUser, eventsList, downloadsList;
@synthesize tokenFirebase, messageNotificationView;
@synthesize webServerLogger, adAliveVideoCacheManager, adAliveImageCacheManager, timelineVideoCacheManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Pasta da aplicação no simulador
    NSLog(@"%@", [ToolBox applicationHelper_InstalationDataForSimulator]);
    
    //NOTE: A configuração do plist está ocorrendo por target (no Build Phases existe um script para isso).
    [FIRApp configure];
    
    [[Crashlytics sharedInstance] setDebugMode:YES];
    [Fabric with:@[[Crashlytics class], [Answers class]]];

    //Managers
    styleManager = [AppStyleManager new];
    beaconsManager = nil;
    soundManager = [SoundManager new];
    [soundManager loadConfigurationsAndData];
    
    //Loading View
    [self setupLoadingView];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];

    //MessageNotification
    [self setupMessageNotificationView];

    //Side Menu
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewMenu = (VC_SideMenu *)[sb instantiateViewControllerWithIdentifier:@"VC_SideMenu"];
    //NOTE: ericogt >> Descomente o método abaixo para utilizar o menu lateral fixo (não dinâmico).
    //[viewMenu createCompleteMenu];
    
    //Lista de eventos
    eventsList = nil;
    [self loadDownloadsList];

    notificationInteraction = nil;
    mainMenuLoaded = false;
    forceTimelineUpdate = true;
    chatInteractionEnabled = YES;
    self.tokenFirebase = @"";
    openedByNotification = false;
    urlFileAdAliveIncoming = nil;

    [self configureNotifications:application];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSInteger logged = [[userDefaults valueForKey:PLISTKEY_USER_ID] integerValue];
  
    if (logged > 0){

        FileManager *fileManager = [FileManager sharedInstance];
        NSDictionary *dicUser = [[NSDictionary alloc]initWithDictionary:[fileManager getProfileData]];

        if (dicUser && dicUser.count > 0){
            AppD.loggedUser = [User createObjectFromDictionary:dicUser];
            AppD.loggedUser.accountID = APP_ACCOUNT_ID;

            //if ([AppD isEnableForRemoteNotifications]){
            //	[AppD registerForRemoteNotifications];
            //}
        }else{
            AppD.loggedUser = nil;
        }
    }else{
        AppD.loggedUser = nil;
    }

    AppD. masterEventID = [userDefaults integerForKey:PLISTKEY_MASTER_EVENT_ID];

    //Contador de usos
    NSInteger startCount = [userDefaults integerForKey:PLISTKEY_APP_START_COUNT];
    startCount += 1;
    [userDefaults setValue:@(startCount) forKey:PLISTKEY_APP_START_COUNT];
    [userDefaults synchronize];
    
    // Add any custom logic here.
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    //Caso a aplicação seja aberta por uma notificação.
    if (launchOptions) {
        
        NSDictionary *dicNotification = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

        if (dicNotification){
            openedByNotification = true;
            [userDefaults setValue:dicNotification forKey:PLISTKEY_PUSH_NOTIFICATION_DICTIONARY_DATA];
            [userDefaults synchronize];
        }
        
        //O bloco abaixo pode ser utilizado, por exemplo, para notificações locais criadas pelos beacons:
        UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (locationNotification) {
            //TODO:
            //A aplicação abriu por uma notificação local:
            NSLog(@"\n\nLocalNotification >> Title: %@, Message: %@\n\n", locationNotification.alertTitle, locationNotification.alertBody);
        }
        
    }
    
    [StoreReviewHelper incrementAppOpenedCount];
    [StoreReviewHelper checkAndAskForReview];
    
    //Show All Fonts
    //    for (NSString *familyName in [UIFont familyNames]){
    //        NSLog(@"Family name: %@", familyName);
    //        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
    //            NSLog(@"--Font name: %@", fontName);
    //        }
    //    }
    
    //DevDataLogger
    devLogger = [DevDataLogger createLoggerWithAgent:@"LAB360-DEV" andMaxLogLimiter:100];
    [devLogger loadLoggerState];
    [GCDWebServer setLogLevel:4]; //Somente erros serão exibidos no console!
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    forceTimelineUpdate = true;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //[self saveContext];
    
    NSLog(@"%@", [devLogger logEvents]);
    [devLogger saveLoggerState];
}


#pragma mark - UserDtaa
- (bool)registerLoginForUser:(NSString*)userEmail data:(NSDictionary*)userData
{
    bool success = true;
    
    @try {
        FileManager *fileManager = [FileManager sharedInstance];
        [fileManager saveProfileData:userData];
        //
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:[userData objectForKey:@"id"] forKey:PLISTKEY_USER_ID];
        [userDefaults synchronize];
    } @catch (NSException *exception) {
        success = false;
        NSLog(@"ERROR (UserLoginRegister): %@", [exception reason]);
    } @finally {
        loggedUser = [User createObjectFromDictionary:userData];
        AppD.loggedUser.accountID = APP_ACCOUNT_ID;
        forceTimelineUpdate = true;
    }
    
    return success;
}

- (bool)registerLogoutForCurrentUser
{
    bool success = true;
    
    @try {
        FileManager *fileManager = [FileManager sharedInstance];
        [fileManager deleteProfileData];
        //
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:nil forKey:PLISTKEY_USER_ID];
        [userDefaults setBool:false forKey:PLISTKEY_LOGIN_STATE];
        [userDefaults setInteger:0 forKey:PLISTKEY_MASTER_EVENT_ID];
        
        [userDefaults synchronize];
        
        //BaseLayoutUpdate
        styleManager.baseLayoutManager = [BaseLayoutManager createNewBaseLayoutAppUsingStoredValues];
        [styleManager.baseLayoutManager saveConfiguration];
    } @catch (NSException *exception) {
        success = false;
        NSLog(@"ERROR (UserLoginRegister): %@", [exception reason]);
    } @finally {
        loggedUser = nil;
        [FBSDKAccessToken setCurrentAccessToken:nil];
        mainMenuLoaded = false;
        //
        [beaconsManager stopMonitoringRegisteredBeacons];
    }
    
    return success;
}

- (void)checkUserAuthenticationToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:PLISTKEY_ACCESS_TOKEN];
    if ([ToolBox textHelper_CheckRelevantContentInString:token]){
        AppConfigDataSource *configDS = [AppConfigDataSource new];
        [configDS validateUserAuthenticationToken:token withCompletionHandler:^(UserAuthenticationTokenStatus tokenStatus, DataSourceResponse * _Nonnull response) {
            if (response.status == DataSourceResponseStatusSuccess) {
                if (tokenStatus == UserAuthenticationTokenStatusInvalid) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_USER_AUTHENTICATION_TOKEN_INVALID_ALERT object:nil userInfo:nil];
                    });
                }
            }
        }];
    }
}

#pragma mark - LoadingView
- (void) showLoadingAnimationWithType:(enumActivityIndicator)type
{
    if(!loadingView){
        [self setupLoadingView];
    }
    //
    NSString *message = @"";
    switch (type) {
        case eActivityIndicatorType_Loading:{message = NSLocalizedString(@"MESSAGE_ACTIVITY_INDICATOR_LOADING", @"");}break;
        case eActivityIndicatorType_Processing:{message = NSLocalizedString(@"MESSAGE_ACTIVITY_INDICATOR_PROCESSING", @"");}break;
        case eActivityIndicatorType_Downloading:{message = NSLocalizedString(@"MESSAGE_ACTIVITY_INDICATOR_DOWNLOADING", @"");}break;
        case eActivityIndicatorType_Updating:{message = NSLocalizedString(@"MESSAGE_ACTIVITY_INDICATOR_UPDATING", @"");}break;
        case eActivityIndicatorType_Publishing:{message = NSLocalizedString(@"MESSAGE_ACTIVITY_INDICATOR_PUBLISHING", @"");}break;
        default:{message = NSLocalizedString(@"MESSAGE_ACTIVITY_INDICATOR_LOADING", @"");}break;
    }
    //
    [loadingView startWithMessage:message];
    [self.window bringSubviewToFront:loadingView];
    loadingView.alpha = 1.0;
}

- (void) hideLoadingAnimation
{
    if(loadingView){
        [loadingView stop];
        loadingView.alpha = 0.0;
    }
}

- (void) updateLoadingAnimationMessage:(NSString*)message
{
    if(loadingView){
        [loadingView updateMessage:message];
    }
}

- (void) updateLoadingFrameUsingSize:(CGSize)size
{
    if(loadingView){
        loadingView.frame = CGRectMake(0.0, 0.0, size.width, size.height);
        [loadingView layoutIfNeeded];
    }
}

- (void)setupLoadingView
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
    loadingView = (LoadingView *)[nibArray objectAtIndex:0];
    [loadingView setFrame:self.window.frame];
    //
    loadingView.backgroundColor = [UIColor clearColor];
    loadingView.lblMessage.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    loadingView.lblMessage.textColor = styleManager.colorPalette.primaryButtonTitleNormal;
    loadingView.lblDownload.backgroundColor = [UIColor clearColor];
    loadingView.lblDownload.textColor = [UIColor lightGrayColor];
    [loadingView.lblDownload setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_NORMAL]];
    //
    loadingView.btnDownloadCancel.backgroundColor = [UIColor clearColor];
    [loadingView.btnDownloadCancel setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(180.0, 40.0) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
    [loadingView.btnDownloadCancel.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [loadingView.btnDownloadCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loadingView.btnDownloadCancel setTitle:NSLocalizedString(@"BUTTON_TITLE_DOWNLOAD_CANCEL", @"") forState:UIControlStateNormal];
    [loadingView.btnDownloadCancel addTarget:self action:@selector(cancelDownload:) forControlEvents:UIControlEventTouchUpInside];
    //
    loadingView.imvBackground.backgroundColor = [UIColor blackColor];
    loadingView.imvBackground.alpha = 0.3;
    loadingView.imvCenter.backgroundColor = [UIColor clearColor];
    loadingView.imvCenter.image = [ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(180.0, 180.0) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(6.0, 6.0) andColor:[UIColor grayColor]];
    loadingView.activityIndicator.tintColor = styleManager.colorPalette.primaryButtonTitleNormal;
    loadingView.tag = 100;
    [self.window addSubview:loadingView];
    loadingView.alpha = 0.0;
    //
    [ToolBox graphicHelper_ApplyShadowToView:loadingView.imvCenter withColor:[UIColor blackColor] offSet:CGSizeMake(2.0, 2.0) radius:2.0 opacity:0.5];
    [ToolBox graphicHelper_ApplyShadowToView:loadingView.btnDownloadCancel withColor:[UIColor blackColor] offSet:CGSizeMake(2.0, 2.0) radius:2.0 opacity:0.5];
}

- (void)cancelDownload:(id)sender
{
    if (downloadConnectionManager){
        [downloadConnectionManager cancelCurrentDownload];
    }
    //
    [self performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
}

#pragma mark - NotificationView
- (void)setupMessageNotificationView
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"MessageNotificationView" owner:self options:nil];
    messageNotificationView = (MessageNotificationView *)[nibArray objectAtIndex:0];
    //
    messageNotificationView.frame = CGRectMake(0, 86.0, self.window.frame.size.width, 86.0);
    [messageNotificationView configureLayout];
}

- (void)showMessageNotificationWithTitle:(NSString*) title andMessage:(NSString*)message andObject:(ChatMessage*)messageObject
{
    if (messageNotificationView){
        if (rootViewController){
            [messageNotificationView showMessageNotificationWithTitle:title andMessage:message object:messageObject];
        }
    }
}

#pragma mark - showSideMenu
- (void)showSideMenu
{
    if (viewMenu){
        [self.window addSubview:viewMenu.view];
        //
        [viewMenu show];
    }
}

- (void)setSideMenuDelegate:(id<SideMenuDelegate>)delegate
{
    if (viewMenu){
        viewMenu.menuDelegate = delegate;
    }
}

- (void)setSideMenuConfigurations:(SideMenuConfig*)config
{
    if (viewMenu){
        [viewMenu registerConfiguration:config];
    }
}

- (void)callForBarButtonsItems
{
    if (viewMenu){
        [viewMenu createBarButtonsForRegisteredConfiguration];
    }
}

#pragma mark - Downloads Control

- (NSString*)serverEnvironmentIdentifier
{
    if ([[NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)] isEqualToString:@"12"]){
        return @"P";
    }else{
        return @"H";
    }
}

- (void)loadDownloadsList
{
    FileManager *fManager = [FileManager new];
    
    NSDictionary *allDownloads = [fManager getDownloadsData];
    
    if (allDownloads && allDownloads.count > 0){
        
        NSArray *keysList = [allDownloads allKeys];
        
        NSMutableArray *finalList = [NSMutableArray new];
        
        for (NSString *key in keysList){
            DownloadItem *dI = [DownloadItem createObjectFromDictionary:[allDownloads valueForKey:key]];
            [finalList addObject:dI];
        }
        
        if (finalList.count > 0){
            downloadsList = [[NSMutableArray alloc] initWithArray:finalList];
        }
    }else{
        downloadsList = [NSMutableArray new];
    }
}

- (void)saveAndUpdateDownloadsList:(NSArray*)list
{
    FileManager *fManager = [FileManager new];
    
    if (list == nil || list.count == 0){
        
        //Limpa lista:
        [fManager deleteDownloadsData];
    }else{
        
        //Salva a atualiza:
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        
        for (DownloadItem *dI in list){
            [mDic setValue:[dI dictionaryJSON] forKey:dI.fileName];
        }
        
        [fManager saveDownloadsData:mDic];
        [self loadDownloadsList];
    }
}

#pragma mark - Fake Factory Helper
- (UIImage*)createDefaultBackgroundImage
{
    return (styleManager.baseLayoutManager.imageBackground ? styleManager.baseLayoutManager.imageBackground : styleManager.baseLayoutManager.defaultBackground);
}

- (SCLAlertViewPlus*)createDefaultAlert
{
    //SCLAlertViewPlus *alert = [[SCLAlertViewPlus alloc] initWithNewWindow];
    SCLAlertViewPlus *alert = [[SCLAlertViewPlus alloc] initWithNewWindowWidth:([UIScreen mainScreen].bounds.size.width * (4.0 / 5.0))];
    [alert.labelTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:20.0]];
    [alert.viewText setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:16.0]];
    [alert setButtonsTextFontFamily:FONT_DEFAULT_SEMIBOLD withSize:16.0];
    alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromTop;//SlideInFromTop;
    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToBottom;//SlideOutToBottom;
    alert.backgroundType = SCLAlertViewBackgroundShadow;
    alert.statusBarStyle = [self statusBarStyleForViewController:nil];
    return alert;
}

- (SCLAlertViewPlus*)createLargeAlert
{
    SCLAlertViewPlus *alert = [[SCLAlertViewPlus alloc] initWithNewWindowWidth:[UIScreen mainScreen].bounds.size.width - 40.0];
    [alert.labelTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:20.0]];
    [alert.viewText setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:16.0]];
    [alert setButtonsTextFontFamily:FONT_DEFAULT_SEMIBOLD withSize:16.0];
    alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromTop;//SlideInFromTop;
    alert.hideAnimationType = SCLAlertViewHideAnimationSlideOutToBottom;//SlideOutToBottom;
    alert.backgroundType = SCLAlertViewBackgroundShadow;
    alert.statusBarStyle = [self statusBarStyleForViewController:nil];
    return alert;
}

- (SCLAlertViewPlus*)createDefaultRichAlert:(NSString*)bodyMessage images:(NSArray<UIImage*>*)imageList animationTimePerFrame:(NSTimeInterval)time
{
    //SCLAlertViewPlus *alert = [self createLargeAlert];
    SCLAlertViewPlus *alert = [self createDefaultAlert];
    
    if ([ToolBox textHelper_CheckRelevantContentInString:bodyMessage]){
        
        UIFont *font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
        CGFloat alertWidth = ([UIScreen mainScreen].bounds.size.width * (3.0 / 4.0)) - 24.0;
        CGSize constraintRect = CGSizeMake(alertWidth, CGFLOAT_MAX);
        CGRect boundingBox = [bodyMessage boundingRectWithSize:constraintRect options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
        
        //Label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, alertWidth, ceil(boundingBox.size.height))];
        label.font = font;
        label.textColor = [UIColor darkTextColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = bodyMessage;
        
        //Images
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, (label.frame.size.height + 10.0), alertWidth, 120.0)];
        imageView.backgroundColor = nil;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        if (imageList.count == 1){
            imageView.image = [imageList objectAtIndex:0];
        }else{
            imageView.animationImages = imageList;
            imageView.animationDuration = time * ((double) imageList.count);
            [imageView startAnimating];
        }
        
        //CustomView
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, alertWidth, (label.frame.size.height + 10.0 + imageView.frame.size.height))];
        [subView addSubview:label];
        [subView addSubview:imageView];
        
        [alert addCustomView:subView];
        
        return alert;
        
    }else{
        
        CGFloat alertWidth = ([UIScreen mainScreen].bounds.size.width * (3.0 / 4.0)) - 24.0;
        
        //Images
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, alertWidth, 120.0)];
        imageView.backgroundColor = nil;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        if (imageList.count == 1){
            imageView.image = [imageList objectAtIndex:0];
        }else{
            imageView.animationImages = imageList;
            imageView.animationDuration = time * ((double) imageList.count);
            [imageView startAnimating];
        }
        
        //CustomView
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, alertWidth, imageView.frame.size.height)];
        [subView addSubview:imageView];
        
        [alert addCustomView:subView];
        
        return alert;
    }
}

- (SCLAlertViewPlus*)createLargeRichAlert:(NSString*)bodyMessage images:(NSArray<UIImage*>*)imageList animationTimePerFrame:(NSTimeInterval)time
{
    SCLAlertViewPlus *alert = [self createLargeAlert];
    
    if ([ToolBox textHelper_CheckRelevantContentInString:bodyMessage]){
        
        UIFont *font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
        CGFloat alertWidth = [UIScreen mainScreen].bounds.size.width - 40.0 - 24.0;
        CGSize constraintRect = CGSizeMake(alertWidth, CGFLOAT_MAX);
        CGRect boundingBox = [bodyMessage boundingRectWithSize:constraintRect options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
        
        //Label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, alertWidth, ceil(boundingBox.size.height))];
        label.font = font;
        label.textColor = [UIColor darkTextColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = bodyMessage;
        
        //Images
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, (label.frame.size.height + 10.0), alertWidth, 120.0)];
        imageView.backgroundColor = nil;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        if (imageList.count == 1){
            imageView.image = [imageList objectAtIndex:0];
        }else{
            imageView.animationImages = imageList;
            imageView.animationDuration = time * ((double) imageList.count);
            [imageView startAnimating];
        }
        
        //CustomView
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, alertWidth, (label.frame.size.height + 10.0 + imageView.frame.size.height))];
        [subView addSubview:label];
        [subView addSubview:imageView];
        
        [alert addCustomView:subView];
        
        return alert;
        
    }else{
        
        CGFloat alertWidth = [UIScreen mainScreen].bounds.size.width - 40.0 - 24.0;
        
        //Images
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, alertWidth, 120.0)];
        imageView.backgroundColor = nil;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        if (imageList.count == 1){
            imageView.image = [imageList objectAtIndex:0];
        }else{
            imageView.animationImages = imageList;
            imageView.animationDuration = time * ((double) imageList.count);
            [imageView startAnimating];
        }
        
        //CustomView
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, alertWidth, imageView.frame.size.height)];
        [subView addSubview:imageView];
        
        [alert addCustomView:subView];
        
        return alert;
    }
}

- (UIBarButtonItem*)createProfileButton
{
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;

    //	if (loggedUser.profilePic){
    //        [userButton setImage:loggedUser.profilePic forState:UIControlStateNormal];
    //        [userButton setImage:loggedUser.profilePic forState:UIControlStateHighlighted];
    //    }else{
    UIImage *img = [[UIImage imageNamed:@"icon-menu-hamburguer.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    //    }
    [userButton setFrame:CGRectMake(0, 0, 32, 32)];
    [userButton setClipsToBounds:YES];
    //[userButton.layer setCornerRadius:16];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(showSideMenu) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}

-(UIView*)createAcessoryViewWithTarget:(UIView*)target andSelector:(SEL)selector
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.rootViewController.view.frame.size.width, 40)];
    view.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
    
    UIButton *btnApply = [[UIButton alloc] initWithFrame:CGRectMake(self.rootViewController.view.frame.size.width/2, 0, self.rootViewController.view.frame.size.width/2, 40)];
    btnApply.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnApply addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btnApply setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [btnApply setTitleColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal forState:UIControlStateNormal];
    [btnApply.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [btnApply setTitle:NSLocalizedString(@"BUTTON_TITLE_DONE", @"") forState:UIControlStateNormal];
    
    [view addSubview:btnApply];
    
    return view;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if (url) {
        if([[[url pathExtension] uppercaseString] isEqualToString:@"ADALIVE"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.urlFileAdAliveIncoming = url;
                [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_NEW_URL_ADALIVE_OPENFILE object:url userInfo:nil];
            });
        }
    }
    
    //Facebook:
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    NSLog(@"Facebook >> application:openURL:options: >> handled(%@)", (handled ? @"YES" : @"NO"));
    
    return YES;
}

#pragma  mark - Push Notification Control

- (bool)isEnableForRemoteNotifications
{
    UIUserNotificationSettings *cs = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (cs.types != UIUserNotificationTypeNone){
        return true;
    }else{
        return false;
    }
}

- (void)registerForRemoteNotifications
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud valueForKey:PLISTKEY_PUSH_NOTIFICATION_FIREBASE_TOKEN];
    //
    self.tokenFirebase = token ? [NSString stringWithFormat:@"%@", token] : @"";
    
    if (token && ![token isEqualToString:@""]){
        ConnectionManager *connection = [[ConnectionManager alloc] init];
        
        if ([connection isConnectionActive])
        {
            NSMutableDictionary *dicParameters = [[NSMutableDictionary alloc] init];
            [dicParameters setValue:@"registerDeviceId" forKey:@"action"]; //Fixo
            [dicParameters setValue:token forKey:@"deviceId"];
            [dicParameters setValue:@"IOS" forKey:@"platform"]; //Fixo
            [dicParameters setValue:@(AppD.loggedUser.userID) forKey:@"userId"];
            [dicParameters setValue:@(AppD.loggedUser.accountID) forKey:@"accountId"];
            
            [connection registerAPSTokenWithParameters:dicParameters withCompletionHandler:^(NSDictionary *response, NSError *error) {
                
                if (error){
                    NSLog(@"\n-> RegisterForRemoteNotifications_Result_Error: %@\n", error.description);
                }else{
                    NSLog(@"\n-> RegisterForRemoteNotifications_Result_Success: %@\n", response);
                }
            }];
        }
    }
}

- (void)removeForRemoteNotifications
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud valueForKey:PLISTKEY_PUSH_NOTIFICATION_FIREBASE_TOKEN];
    
    if (token && ![token isEqualToString:@""]){
        ConnectionManager *connection = [[ConnectionManager alloc] init];
        
        if ([connection isConnectionActive])
        {
            NSMutableDictionary *dicParameters = [[NSMutableDictionary alloc] init];
            [dicParameters setValue:@"unregisterDeviceId" forKey:@"action"]; //Fixo
            [dicParameters setValue:token forKey:@"deviceId"];
            [dicParameters setValue:@(AppD.loggedUser.userID) forKey:@"userId"];
            [dicParameters setValue:@(AppD.loggedUser.accountID) forKey:@"accountId"];
            
            [connection unregisterAPSTokenWithParameters:dicParameters withCompletionHandler:^(NSDictionary *response, NSError *error) {
                
                if (error){
                    NSLog(@"\n-> RemoveForRemoteNotifications_Result_Error: %@\n", error.description);
                }else{
                    NSLog(@"\n-> RemoveForRemoteNotifications_Result_Success: %@\n", response);
                }
            }];
        }
    }
}

#pragma  mark - Tokens

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<> "]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:token forKey:PLISTKEY_PUSH_NOTIFICATION_TOKEN];
    [ud synchronize];
    
    //[[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeUnknown];
    [FIRMessaging messaging].APNSToken = deviceToken ;
    
    NSLog(@"deviceToken: %@",deviceToken);
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"%@", notificationSettings);
    [application registerForRemoteNotifications];
}

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    //NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSString *refreshedToken = [FIRMessaging messaging].FCMToken;
    
    if (refreshedToken == nil){
        
        refreshedToken = notification.object;
    }
    
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:refreshedToken forKey:PLISTKEY_PUSH_NOTIFICATION_FIREBASE_TOKEN];
    [ud synchronize];
    
    self.tokenFirebase = [NSString stringWithFormat:@"%@", refreshedToken];
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    //[self connectToFcm];
    
    // Send token to application server.
    if (loggedUser.userID != 0){
        [self registerForRemoteNotifications];
    }
}
// [END refresh_token]

#pragma  mark - Configuração de Notificações

- (void)configureNotifications:(UIApplication *)application
{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        //iOS 10 and above:
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

        //*********************************************************************************************************
        //MESSAGE:
        
        //Ações disponíveis:
        UNNotificationAction *actionMESSAGE_1 = [UNNotificationAction actionWithIdentifier:@"opt_message_read" title:NSLocalizedString(@"PUSH_NOTIFICATION_OPTION_READ_MESSAGE", @"") options:UNNotificationActionOptionAuthenticationRequired | UNNotificationActionOptionForeground];
        //UNNotificationAction *actionMESSAGE_2 = [UNNotificationAction actionWithIdentifier:@"optIgnore" title:@"Ignorar" options:UNNotificationActionOptionNone];
        
        //Categoria:
        UNNotificationCategory *categoryMESSAGE = [UNNotificationCategory categoryWithIdentifier:PUSHNOT_CATEGORY_MESSAGE actions:@[actionMESSAGE_1] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];

        //*********************************************************************************************************
        //INTERACTIVE:
        
        //Ações disponíveis:
        UNNotificationAction *actionSURVEY_1 = [UNNotificationAction actionWithIdentifier:@"opt_interactive_ok" title:NSLocalizedString(@"PUSH_NOTIFICATION_OPTION_INTERACTIVE_YES", @"") options:UNNotificationActionOptionAuthenticationRequired | UNNotificationActionOptionForeground];
        UNNotificationAction *actionSURVEY_2 = [UNNotificationAction actionWithIdentifier:@"opt_interactive_cancel" title:NSLocalizedString(@"PUSH_NOTIFICATION_OPTION_INTERACTIVE_NO", @"") options:UNNotificationActionOptionAuthenticationRequired];
        
        //Categoria:
        UNNotificationCategory *categorySURVEY = [UNNotificationCategory categoryWithIdentifier:PUSHNOT_CATEGORY_INTERACTIVE actions:@[actionSURVEY_1, actionSURVEY_2] intentIdentifiers:@[@"intent1", @"intent2"] options:UNNotificationCategoryOptionNone];
        
        //*********************************************************************************************************
        //SECTOR:
        
        //Categoria:
        UNNotificationCategory *categorySECTOR = [UNNotificationCategory categoryWithIdentifier:PUSHNOT_CATEGORY_SECTOR actions:@[] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        
        //*********************************************************************************************************
        //Setando as opções:
        center.delegate = self;
        NSSet *set = [NSSet setWithObjects:categoryMESSAGE, categorySURVEY, categorySECTOR, nil];
        [center setNotificationCategories:set];

        //
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }else{
                NSLog(@"requestAuthorizationWithOptionsError: %@", [error localizedDescription]);
            }
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:FIRMessagingRegistrationTokenRefreshedNotification object:nil];
}

// [START connect_to_fcm]
//- (void)connectToFcm {
//    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
//        if (error != nil) {
//            NSLog(@"Unable to connect to FCM. %@", error);
//        } else {
//            NSLog(@"Connected to FCM.");
//        }
//    }];
//}
// [END connect_to_fcm]

#pragma  mark - Recebimento Notificações - iOS 10

// The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSString *category = notification.request.content.categoryIdentifier;
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    if ([category isEqualToString:PUSHNOT_CATEGORY_LOCAL] || [category isEqualToString:ADALIVE_GEOFENCE_PUSHNOTIFICATION_CATEGORY_NAME]){
        
        //Notificações locais independem do usuário logado:
        [self showMessageNotificationWithTitle:notification.request.content.title andMessage:notification.request.content.body andObject:nil];
        NSLog(@"\n\nLocalNotification >> Title: %@, Message: %@\n\n", notification.request.content.title, notification.request.content.body);
        
    }else{
        
        if (AppD.loggedUser.userID != 0){
            
            if ([category isEqualToString:PUSHNOT_CATEGORY_MESSAGE] && self.chatInteractionEnabled){
                
                if (rootViewController){
                    
                    bool showNotification = false;
                    ChatMessage *newMessage = [self chatMessageFromDictionary:userInfo];
                    
                    if ([[rootViewController.navigationController topViewController] isKindOfClass:[VC_Chat class]]){
                        
                        VC_Chat *vcChat = (VC_Chat*)[rootViewController.navigationController topViewController];
                        
                        if ((vcChat.chatType == eChatScreenType_Single && vcChat.outerUser.userID == newMessage.userID) || (vcChat.chatType == eChatScreenType_Group && vcChat.receiverGroup.groupId == newMessage.outerGroupID)){
                            
                            //Avisa sobre o recebimento da mensagem:
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_CHAT_NEW_MESSAGE object:newMessage userInfo:userInfo];
                            });
                            
                        }else{
                            showNotification = true;
                        }
                    }else{
                        showNotification = true;
                    }
                    
                    //Avisa por notificação, caso o usuário esteja em qualquer outra tela.
                    if (showNotification){
                        
                        NSDictionary *dicNotification = [userInfo valueForKey:@"aps"];
                        
                        if (dicNotification){
                            
                            NSDictionary *dicAlert = [dicNotification valueForKey:@"alert"];
                            
                            if (dicAlert){
                                
                                NSString *title = [dicAlert valueForKey:@"title"];
                                NSString *body = [dicAlert valueForKey:@"body"];
                                //
                                [self showMessageNotificationWithTitle:title andMessage:body andObject:newMessage];
                            }
                        }
                    }
                }
                
            }else if([category isEqualToString:PUSHNOT_CATEGORY_INTERACTIVE]){
                
                //A aplicação está em foreground (não há notificação mas o usuário será notificado)
                
                notificationInteraction = [NotificationInteraction new];
                notificationInteraction.notificationID = [[userInfo valueForKey:@"notificationId"] integerValue];
                notificationInteraction.title = [userInfo valueForKey:@"title"];
                notificationInteraction.userMessage = [userInfo valueForKey:@"message"];
                notificationInteraction.category = [userInfo valueForKey:@"type"];
                notificationInteraction.action = @"YES";
                notificationInteraction.isFeedback = false;
                
                //Avisa sobre o recebimento da mensagem:
                if (AppD.mainMenuLoaded){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_PUSH_NOTIFICATION_INTERACTIVE object:notificationInteraction userInfo:userInfo];
                    });
                }
                
            }else if([category isEqualToString:PUSHNOT_CATEGORY_SECTOR]){
                NSLog(@"Push Notification > SECTOR > Content:\n%@", userInfo);
                
                //Busca pelo "targetName" (que se chama 'info' na notificação) para poder abrir a tela de pesquisa:
                ChatMessage *newMessage = nil;
                if (![[userInfo valueForKey:@"info"] isKindOfClass:[NSNull class]]){
                    NSString *targetName = [userInfo valueForKey:@"info"];
                    if (targetName != nil && ![targetName isEqualToString:@""]){
                        newMessage = [ChatMessage new];
                        newMessage.auxAlert = [AuxAlertMessage new];
                        newMessage.auxAlert.showInScreen = true;
                        newMessage.auxAlert.targetName = targetName;
                    }
                }
                
                NSDictionary *dicNotification = [userInfo valueForKey:@"aps"];
                
                if (dicNotification){
                    
                    NSDictionary *dicAlert = [dicNotification valueForKey:@"alert"];
                    
                    if (dicAlert){
                        
                        NSString *title = [dicAlert valueForKey:@"title"];
                        NSString *body = [dicAlert valueForKey:@"body"];
                        //
                        [self showMessageNotificationWithTitle:title andMessage:body andObject:newMessage];
                    }
                }
            }
        }
    }
    
    completionHandler(UNNotificationPresentationOptionNone);
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
{
    NSString *category = response.notification.request.content.categoryIdentifier;
    
    if ([category isEqualToString:PUSHNOT_CATEGORY_MESSAGE] && self.chatInteractionEnabled){
        
        //MARK: Para o chat, o tratamento de tocar na ação "ler" ou tocar no corpo na notificação é igual:
        
        NSDictionary *userInfo = response.notification.request.content.userInfo;
        ChatMessage *newMessage = [self chatMessageFromDictionary:userInfo];
        
        if (newMessage){
            
            if (rootViewController){
                
                if ([[AppD.rootViewController.navigationController topViewController] isKindOfClass:[VC_Chat class]]){
                    
                    VC_Chat *vcChat = (VC_Chat*)[rootViewController.navigationController topViewController];
                    
                    if ((vcChat.chatType == eChatScreenType_Single && vcChat.outerUser.userID == newMessage.userID) || (vcChat.chatType == eChatScreenType_Group && vcChat.receiverGroup.groupId == newMessage.outerGroupID)){
                        
                        //Avisa sobre o recebimento da mensagem:
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_CHAT_NEW_MESSAGE object:newMessage userInfo:userInfo];
                        });
                    }
                }else{
                    
                    if ([[AppD.rootViewController.navigationController topViewController] isKindOfClass:[VC_ContactsChat class]]){
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]];
                        VC_Chat *vcChat = [storyboard instantiateViewControllerWithIdentifier:@"VC_Chat"];
                        [vcChat awakeFromNib];
                        //
                        if (newMessage.messageType == eChatMessageType_Single){
                            vcChat.chatType = eChatScreenType_Single;
                            //
                            User *rUser = [User new];
                            rUser.userID = newMessage.userID;
                            rUser.name = newMessage.userName;
                            vcChat.outerUser = rUser;
                        }else if(newMessage.messageType == eChatMessageType_Group){
                            vcChat.chatType = eChatScreenType_Group;
                            //
                            GroupChat *rGroup = [GroupChat new];
                            rGroup.groupId = newMessage.outerGroupID;
                            rGroup.groupName = newMessage.chatName;
                            vcChat.receiverGroup = rGroup;
                        }
                        //
                        UIViewController *vc = [AppD.rootViewController.navigationController topViewController];
                        vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                        vc.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
                        //Abrindo a tela
                        [vc.navigationController pushViewController:vcChat animated:YES];
                        
                    }else{
                        
                        if (AppD.loadingView.alpha == 0.0){
                            
                            UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
                            topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                            topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
                            
                            //==============================================================================================
                            //Readaptando a lista de controllers para que o voltar seja para a tela de grupos:
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]];
                            VC_ContactsChat *vcContactChat = [storyboard instantiateViewControllerWithIdentifier:@"VC_ContactsChat"];
                            [vcContactChat awakeFromNib];
                            //
                            [topVC.navigationController pushViewController:vcContactChat animated:NO];
                            
                            //==============================================================================================
                            //Tela de chat:
                            //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]];
                            VC_Chat *vcChat = [storyboard instantiateViewControllerWithIdentifier:@"VC_Chat"];
                            [vcChat awakeFromNib];
                            
                            if (newMessage.messageType == eChatMessageType_Single){
                                
                                vcChat.chatType = eChatScreenType_Single;
                                //
                                User *oUser = [User new];
                                oUser.userID = newMessage.userID;
                                oUser.name = newMessage.userName;
                                vcChat.outerUser = oUser;
                                //Group = null
                                vcChat.receiverGroup = nil;
                                
                            }else if(newMessage.messageType == eChatMessageType_Group){
                                
                                vcChat.chatType = eChatScreenType_Group;
                                //
                                GroupChat *gChat = [GroupChat new];
                                gChat.groupId = newMessage.outerGroupID;
                                gChat.groupName = newMessage.chatName;
                                vcChat.receiverGroup = gChat;
                                //User = null
                                vcChat.outerUser = nil;
                            }
                            
                            UIViewController *topVC2 = AppD.rootViewController.navigationController.topViewController;
                            topVC2.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                            topVC2.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
                            //
                            [topVC.navigationController pushViewController:vcChat animated:NO];
                        }
                    }
                }
            }
        }
    }
    else if([category isEqualToString:PUSHNOT_CATEGORY_INTERACTIVE]){
        
        if ([response.actionIdentifier isEqualToString:@"opt_interactive_ok"]){
            
            NSDictionary *userInfo = response.notification.request.content.userInfo;
            
            notificationInteraction = [NotificationInteraction new];
            notificationInteraction.notificationID = [[userInfo valueForKey:@"notificationId"] integerValue];
            notificationInteraction.title = [userInfo valueForKey:@"title"];
            notificationInteraction.userMessage = [userInfo valueForKey:@"message"];
            notificationInteraction.category = [userInfo valueForKey:@"type"];
            notificationInteraction.action = @"YES";
            notificationInteraction.isFeedback = true;
            
            //Avisa sobre o recebimento da mensagem:
            if (AppD.mainMenuLoaded){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_PUSH_NOTIFICATION_INTERACTIVE object:notificationInteraction userInfo:userInfo];
                });
            }
            
        }else if([response.actionIdentifier isEqualToString:@"opt_interactive_cancel"]){
            NSLog(@"Push Notification Action: INTERACTIVE > opt_interactive_cancel");
        }else{
            //TODO: Usuário tocou na notificação e não nas opções...
            NSLog(@"Push Notification Action: INTERACTIVE > user touch in notification");
        }

    }
    else if([category isEqualToString:PUSHNOT_CATEGORY_SECTOR]){
        
        NSLog(@"Push Notification > SECTOR > Content:\n%@", response.notification.request.content.userInfo);

        //OBS: Este método foi alterado dia (08/03/2018) por EricoGT
        //O campo 'info' na notificação pode trazer dados relevantes para saber para onde destinar o usuário, caso seja necessário para o cliente
        //O 'default' é abrir a tela de notificações
        
        if (![[response.notification.request.content.userInfo valueForKey:@"info"] isKindOfClass:[NSNull class]]){

            NSString *info = [response.notification.request.content.userInfo valueForKey:@"info"];
            NSLog(@"NotificationInfo: %@", info);

            if (self.rootViewController){

                if (self.loadingView.alpha == 0.0){

                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    VC_Notifications *vcNotifications = [storyboard instantiateViewControllerWithIdentifier:@"VC_Notifications"];
                    [vcNotifications awakeFromNib];
                    //
                    UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
                    topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                    topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
                    //Abrindo a tela
                    [AppD.rootViewController.navigationController pushViewController:vcNotifications animated:YES];
                    //Readaptando a lista de controllers:
                    NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
                    NSMutableArray *listaF = [NSMutableArray new];
                    [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
                    [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
                    [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
                    [listaF addObject:vcNotifications];
                    //Carregando dados
                    AppD.rootViewController.navigationController.viewControllers = listaF;

                }
            }
        }
    }
    
    completionHandler();
}



#pragma mark - Interpretação da Mensagem

- (ChatMessage*)chatMessageFromDictionary:(NSDictionary*)notificationDictionary
{
    NSString *type = [notificationDictionary valueForKey:@"type"];
    
    NSDictionary *dicData = [ToolBox converterHelper_DictionaryFromStringJson:[notificationDictionary valueForKey:@"message"]];
    dicData = [ToolBox converterHelper_NewDictionaryReplacingPlusSymbolFromDictionary:dicData];
    
    if (dicData){
        ChatMessage *cm = [ChatMessage createObjectFromDictionary:dicData];
        
        if ([type isEqualToString:@"SINGLE_MESSAGE"]){
            cm.messageType = eChatMessageType_Single;
            return cm;
            
        }else if([type isEqualToString:@"GROUP_MESSAGE"]){
            cm.messageType = eChatMessageType_Group;
            return cm;
        }
    }
    
    return nil;
}

#pragma mark - Device Orientation

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([[rootViewController.navigationController topViewController] isKindOfClass:[VC_VideoPlayer class]]){
        return UIInterfaceOrientationMaskAll;
    }else if ([[rootViewController.navigationController topViewController] isKindOfClass:[PanoramaViewerVC class]]){
        return UIInterfaceOrientationMaskAll;
    }else if ([[rootViewController.navigationController topViewController] isKindOfClass:[Video360VC class]]){
        return UIInterfaceOrientationMaskLandscape;
    }else if ([[rootViewController.navigationController topViewController] isKindOfClass:[HTYGLKVC class]]){
        return UIInterfaceOrientationMaskLandscape;
    }else if ([[rootViewController.navigationController topViewController] isKindOfClass:[BeaconShowroomRadarVC class]]){
        return UIInterfaceOrientationMaskAll;
    }else if ([[[rootViewController.navigationController topViewController] presentedViewController] isKindOfClass:[BeaconShowroomLiveCamVC class]]){
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark - StyleManager

-(void)setStyleManagerWithStyle:(NSDictionary *)appDic{

    AppD.masterEventID = [[appDic valueForKey:@"master_event_id"] integerValue];
    //
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:AppD.masterEventID forKey:PLISTKEY_MASTER_EVENT_ID];

    NSArray *allKeys = [appDic allKeys];
    bool canPost = ![allKeys containsObject:CONFIG_KEY_FLAG_POST] ? true : [[appDic objectForKey:CONFIG_KEY_FLAG_POST] boolValue];
    bool canLike = ![allKeys containsObject:CONFIG_KEY_FLAG_LIKE] ? true : [[appDic objectForKey:CONFIG_KEY_FLAG_LIKE] boolValue];
    bool canComment = ![allKeys containsObject:CONFIG_KEY_FLAG_COMMENT] ? true : [[appDic objectForKey:CONFIG_KEY_FLAG_COMMENT] boolValue];
    bool canShare = ![allKeys containsObject:CONFIG_KEY_FLAG_SHARE] ? true : [[appDic objectForKey:CONFIG_KEY_FLAG_SHARE] boolValue];

    [userDefaults setBool:canPost forKey:CONFIG_KEY_FLAG_POST];
    [userDefaults setBool:canLike forKey:CONFIG_KEY_FLAG_LIKE];
    [userDefaults setBool:canComment forKey:CONFIG_KEY_FLAG_COMMENT];
    [userDefaults setBool:canShare forKey:CONFIG_KEY_FLAG_SHARE];
    [userDefaults synchronize];
    //
    NSString *backStr = [appDic valueForKey:@"background_image"];
    NSString *logoStr = [appDic valueForKey:@"logo"];
    NSString *bannerStr = [appDic valueForKey:@"head_image"];

    AppD.styleManager.baseLayoutManager.urlBackground = [backStr isKindOfClass:[NSNull class]] ? @"": backStr;
    AppD.styleManager.baseLayoutManager.urlLogo = [logoStr isKindOfClass:[NSNull class]] ? @"": logoStr;
    AppD.styleManager.baseLayoutManager.urlBanner = [bannerStr isKindOfClass:[NSNull class]] ? @"": bannerStr;

    [AppD.styleManager.colorPalette applyCustomColorLayout:appDic];
}

- (void)loadStyleManagerRoles:(NSDictionary *)dicRoles{

    if (!AppD.styleForRole) {
        AppD.styleForRole = [NSMutableDictionary dictionary];
    }
    
    NSArray *roles = [dicRoles objectForKey:@"roles"];
    //set dictionary com styles por role
    for (NSDictionary *dicRole in roles) {
        [AppD.styleForRole setValue:dicRole forKey:[dicRole valueForKey:@"role"]];
    }
    
    if (AppD.loggedUser.userID == 0) {
        [self setStyleManagerWithStyle:dicRoles];
    }
    else{
        [self setStyleManagerWithStyle:[AppD.styleForRole valueForKey:AppD.loggedUser.role]];
    }
    
    //MARK: Caso os dados de config não venham dentro de 'roles', descomentar a linha abaixo:
    //    if (!AppD.styleForRole) {
    //        AppD.styleForRole = [NSMutableDictionary dictionary];
    //        [AppD.styleForRole setValue:dicRoles forKey:@"default"];
    //    }
    //    [self setStyleManagerWithStyle:dicRoles];
}

- (UIStatusBarStyle)statusBarStyleForViewController:(UIViewController*)viewController
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Web Server
- (NSString*)startWebServerLogger
{
    NSString *strResult = @"";
    
    __weak AppDelegate *weakSelf = self;
    
    //CONNECTIONS
    
    if (webServerLogger == nil) {
        // Create server
        webServerLogger = [[GCDWebServer alloc] init];
        
        // Add a handler to respond to GET requests on any URL
        [webServerLogger addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {

            NSString *logDevice = [weakSelf.devLogger logDeviceData];
            NSString *logInternet = [weakSelf.devLogger logInternetConnections];
            NSString *logEvent = [weakSelf.devLogger logEvents];
            //
            NSString *path = [[NSBundle mainBundle] pathForResource:@"web_server_dev_data_logger" ofType:@"html"];
            NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            //
            html = [html stringByReplacingOccurrencesOfString:@"[CODE0]" withString:[NSString stringWithFormat:@"last update: %@", [ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:@"HH:mm:ss"]]];
            html = [html stringByReplacingOccurrencesOfString:@"[CODE1]" withString:logDevice];
            html = [html stringByReplacingOccurrencesOfString:@"[CODE2]" withString:logInternet];
            html = [html stringByReplacingOccurrencesOfString:@"[CODE3]" withString:logEvent];
            //
            return [GCDWebServerDataResponse responseWithHTML:html];
            
            //Redirect sample
            //return [GCDWebServerResponse responseWithRedirect:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.creativebloq.com/web-design/examples-of-html-1233547"]] permanent:NO];
            
        }];
        
        // Start server on port 8080
        [webServerLogger startWithPort:8080 bonjourName:nil];
        
    }

    if ([webServerLogger isRunning]) {
        strResult = [NSString stringWithFormat:@"Web Server Running: %@", webServerLogger.serverURL];
    }else{
        strResult = @"Web Server Error: See DEBUG logs for detail.";
    }

    return strResult;
}

- (NSString*)stopWebServerLogger
{
    if (webServerLogger) {
        if ([webServerLogger isRunning]) {
            [webServerLogger stop];
            return @"Web Server Stoped!";
        }
    }
    
    return @"Web Server Not Running!";
}

- (NSString*)webServerLoggerStatus
{
    NSString *strResult = @"";
    if (webServerLogger) {
        if ([webServerLogger isRunning]) {
            strResult = [NSString stringWithFormat:@"Web Server Running: %@", webServerLogger.serverURL];
        }else{
            strResult = @"Web Server Error: See DEBUG logs for detail.";
        }
    }else{
        strResult = @"Web Server Not Started!";
    }

    return strResult;
}

- (BOOL)webServerLoggerIsRunning
{
    return [webServerLogger isRunning];
}

#pragma mark - AdAliveLogHelper

- (void)logAdAliveActionWithID:(long)actionID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AdAliveLogHelper *logHelper = [AdAliveLogHelper sharedInstance];
    [logHelper setUrlServer:[defaults stringForKey:BASE_APP_URL] userEmail:self.loggedUser.email agent:@"App-LAB360"];
    [logHelper useSelfDataGPS:YES];
    //
    AdAliveLogObject *logObject = [AdAliveLogObject new];
    logObject.type = ActionLogType;
    logObject.appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    logObject.email = self.loggedUser.email;
    logObject.UUID = [ToolBox deviceHelper_IdentifierForVendor];
    logObject.actionID = actionID;
    [logHelper logDataToServer:logObject];
    
    //DevLogger
    [self.devLogger newLogEvent:@"AdAlive" category:@"ActionLog" dicData:[logObject dictionaryJSONtoLogHelperAgent:@"DevLogger"]];
}

- (void)logAdAliveProductWithID:(long)productID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AdAliveLogHelper *logHelper = [AdAliveLogHelper sharedInstance];
    [logHelper setUrlServer:[defaults stringForKey:BASE_APP_URL] userEmail:self.loggedUser.email agent:@"App-LAB360"];
    [logHelper useSelfDataGPS:YES];
    //
    AdAliveLogObject *logObject = [AdAliveLogObject new];
    logObject.type = ProductLogType;
    logObject.appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    logObject.email = self.loggedUser.email;
    logObject.UUID = [ToolBox deviceHelper_IdentifierForVendor];
    logObject.productID = productID;
    [logHelper logDataToServer:logObject];
    
    //DevLogger
    [self.devLogger newLogEvent:@"AdAlive" category:@"ProductLog" dicData:[logObject dictionaryJSONtoLogHelperAgent:@"DevLogger"]];
}

- (void)logAdAliveEventWithName:(NSString*)eventName data:(NSDictionary*)eventData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AdAliveLogHelper *logHelper = [AdAliveLogHelper sharedInstance];
    [logHelper setUrlServer:[defaults stringForKey:BASE_APP_URL] userEmail:self.loggedUser.email agent:@"App-LAB360"];
    [logHelper useSelfDataGPS:YES];
    //
    AdAliveLogObject *logObject = [AdAliveLogObject new];
    logObject.type = GenericLogType;
    logObject.appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    logObject.email = self.loggedUser.email;
    logObject.UUID = [ToolBox deviceHelper_IdentifierForVendor];
    logObject.genericLogPackage = [AdAliveGenericLogPackage newPackageWith:@"device" request:eventData action:eventName];
    [logHelper logDataToServer:logObject];
    
    //DevLogger
    [self.devLogger newLogEvent:@"AdAlive" category:@"GenericLog" dicData:[logObject dictionaryJSONtoLogHelperAgent:@"DevLogger"]];
}

@end
