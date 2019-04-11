//
//  VC_Configurations.m
//  GS&MD
//
//  Created by Lab360 on 21/06/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "ViewControllerModel.h"
#import "VC_Configurations.h"
#import "ConnectionManager.h"
#import "AdAliveWS.h"
#import "AdAliveGeofence.h"
#import "AdAliveLogHelper.h"
#import "AppDelegate.h"
#import "LocationService.h"
#import "AppConfigDataSource.h"
#import "BiometricAuthentication.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_Configurations()<ConnectionManagerDelegate, AdAliveWSDelegate, AdAliveGeofenceDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btTryAgain;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_Configurations
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize btTryAgain, backgroundImage;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Layout
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getAsyncServerDataFromMasterServer];
    
    [[AdAliveLogHelper sharedInstance] useSelfDataGPS:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [AppD statusBarStyleForViewController:self];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)clickTryAgainButton:(id)sender
{
    [self getAsyncServerDataFromMasterServer];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - AdAliveWS methods

-(void)didReceiveResponse:(AdAliveWS *)adalivews withSuccess:(NSDictionary *)response{
    
    NSArray *allKeys = [response allKeys];
    
    if([allKeys containsObject:@"regions"]){
        
        AdAliveGeofence *adGeofence = [AdAliveGeofence sharedManager];
        adGeofence.email = AppD.loggedUser.email;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        adGeofence.urlServer = [userDefaults objectForKey:BASE_APP_URL];
        adGeofence.delegate = self;
        NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
        adGeofence.appID = appID;
        adGeofence.distanceFilter = [response objectForKey:@"distance_accurancy"];
        adGeofence.geofenceTime = [response objectForKey:@"geofence_time"];
        
        [adGeofence registerAppToGeofencingWithRegions:[response objectForKey:@"regions"]];
    }
    else if([allKeys containsObject:@"beacons"]){
        
        NSArray *beacons = [response objectForKey:@"beacons"];
        [self configureBeacons: beacons];
    }
}

-(void)didReceiveResponse:(AdAliveWS *)adalivews withError:(NSError *)error
{
    NSLog(@"AdAliveWS >> didReceiveResponse:withError: >> %@", [error localizedDescription]);
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Navigation Controller
    [self.navigationController setNavigationBarHidden:YES];
    
    //Button:
    btTryAgain.backgroundColor = [UIColor clearColor];
    [btTryAgain.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [btTryAgain setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btTryAgain.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [btTryAgain setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btTryAgain.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:[UIColor darkGrayColor]] forState:UIControlStateHighlighted];
    [btTryAgain setTitle:NSLocalizedString(@"TRY_AGAIN", @"") forState:UIControlStateNormal];
    [btTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btTryAgain.hidden = YES;
    
    //Background:
    self.view.backgroundColor = [UIColor whiteColor];
    self.backgroundImage.image = [UIImage imageNamed:@"splash-lab360.jpg"];
}

- (void)updateImageBackground:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BACKGROUND object:nil];
    //
    [AppD.styleManager.baseLayoutManager saveConfiguration];
}

- (void)updateImageLogo:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_LOGO object:nil];
    //
    [AppD.styleManager.baseLayoutManager saveConfiguration];
}

- (void)updateImageBanner:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BANNER object:nil];
    //
    [AppD.styleManager.baseLayoutManager saveConfiguration];
    
}

-(void)configureBeacons:(NSArray *)beacons
{
    AppD.beaconsManager = [BeaconService new];
    
    NSMutableArray *b2Monitor = [NSMutableArray new];
    
    for (NSDictionary *dicB in beacons){
        
        LaBeacon *beacon = [LaBeacon createObjectFromDictionary:dicB];
        
        //Tipo 1 refere-se a iBeacons para monitoramento de região. O modelo 'estimote' é tipo 0 e não é usado neste caso.
        if (beacon.beaconID != 0 && [beacon.type isEqualToString:@"1"]) {
            [b2Monitor addObject:beacon];
        }
    }
    
    [AppD.beaconsManager registerBeaconsToMonitor:b2Monitor];
    //NOTE: O start do monitoramento acontece na timeline.
}

- (void)checkBiometricProtection
{
    if (AppD.loggedUser.userID == 0){
        //Continua (pois não há usuário logado):
        [self goToLogin];
    }else{
        
        NSString *userID = [NSString stringWithFormat:@"user%i", AppD.loggedUser.userID];
        UIImage *lock = [ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:[UIImage imageNamed:@"BeaconMenuLock"]];
        
        if ([BiometricAuthentication getAppProtectionStatusForUserIdentifier:userID]){
            
            BiometricType type = [BiometricAuthentication biometricTypeAvailable];
            
            if (type == BiometricTypeNone){
                
                //O usuário protegeu o app mas a autenticação biométrica não está disponível.
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                    //Reseta o usuário local (idem logout):
                    [BiometricAuthentication setAppProtectionStatus:NO forUserIdentifier:userID];
                    [AppD registerLogoutForCurrentUser];
                    [self getAsyncServerDataFromMasterServer];
                }];
                [alert showCustom:lock color:AppD.styleManager.colorPalette.backgroundNormal title:@"Autenticação" subTitle:@"A aplicação foi protegida com autenticação biométrica mas este recurso não está disponível no momento.\nSerá necessário logar-se novamente no sistema." closeButtonTitle:nil duration:0.0];
                
            }else{
                
                [BiometricAuthentication authenticateUserWithCompletionHandler:^(BOOL success, NSString * _Nullable errorMessage) {
                    
                    if (success){
                        //Continua:
                        [self goToLogin];
                    }else{
                        
                        UIImage *bioIcon = type == BiometricTypeTouchID ? [UIImage imageNamed:@"BiometricAuthenticationTouchID"] : [UIImage imageNamed:@"BiometricAuthenticationFaceID"];
                        NSString *bioName = type == BiometricTypeTouchID ? @"TouchID" : @"FaceID";
                        //
                        SCLAlertViewPlus *alert = [AppD createDefaultRichAlert:[NSString stringWithFormat:@"A autenticação biométrica está ativa para o usuário '%@'.\n", AppD.loggedUser.name] images:@[bioIcon] animationTimePerFrame:0.0];
                        [alert addButton:@"Tentar Novamente" withType:SCLAlertButtonType_Normal actionBlock:^{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                //Continua na checagem:
                                [self checkBiometricProtection];
                            });
                        }];
                        [alert addButton:@"Entrar com outro usuário" withType:SCLAlertButtonType_Neutral actionBlock:^{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                //Reseta o usuário local (idem logout):
                                [AppD registerLogoutForCurrentUser];
                                [self getAsyncServerDataFromMasterServer];
                            });
                        }];
                        [alert showCustom:lock color:AppD.styleManager.colorPalette.backgroundNormal title:@"Erro Autenticação" subTitle:bioName closeButtonTitle:nil duration:0.0];
                    }
                    
                }];
                
            }
            
        }else{
            //Continua (o usuário logado não protegeu o app):
            [self goToLogin];
        }
    }
    
    
//    if (AppD.loggedUser.userID == 0){
//        //Continua:
//        [self goToLogin];
//    }else{
//
//        BiometricType type = [BiometricAuthentication biometricTypeAvailable];
//
//        if (type == BiometricTypeNone){
//            //Continua:
//            [self goToLogin];
//        }else{
//            NSString *userID = [NSString stringWithFormat:@"user%i", AppD.loggedUser.userID];
//            if ([BiometricAuthentication getAppProtectionStatusForUserIdentifier:userID]){
//                [BiometricAuthentication authenticateUserWithCompletionHandler:^(BOOL success, NSString * _Nullable errorMessage) {
//
//                    if (success){
//                        //Continua:
//                        [self goToLogin];
//                    }else{
//                        UIImage *lock = [ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:[UIImage imageNamed:@"BeaconMenuLock"]];
//                        UIImage *bioIcon = type == BiometricTypeTouchID ? [UIImage imageNamed:@"BiometricAuthenticationTouchID"] : [UIImage imageNamed:@"BiometricAuthenticationFaceID"];
//                        NSString *bioName = type == BiometricTypeTouchID ? @"TouchID" : @"FaceID";
//                        //
//                        SCLAlertViewPlus *alert = [AppD createDefaultRichAlert:[NSString stringWithFormat:@"A autenticação biométrica está ativa para o usuário '%@'.\n", AppD.loggedUser.name] images:@[bioIcon] animationTimePerFrame:0.0];
//                        [alert addButton:@"Tentar Novamente" withType:SCLAlertButtonType_Normal actionBlock:^{
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                //Continua na checagem:
//                                [self checkBiometricProtection];
//                            });
//                        }];
//                        [alert addButton:@"Entrar com outro usuário" withType:SCLAlertButtonType_Neutral actionBlock:^{
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                //Reseta o usuário local (idem logout):
//                                [AppD registerLogoutForCurrentUser];
//                                [self getAsyncServerDataFromMasterServer];
//                            });
//                        }];
//                        [alert showCustom:lock color:AppD.styleManager.colorPalette.backgroundNormal title:@"Erro Autenticação" subTitle:bioName closeButtonTitle:nil duration:0.0];
//                    }
//
//                }];
//            }else{
//                //Continua:
//                [self goToLogin];
//            }
//        }
//    }
        
}

#pragma mark - Connection

- (void)getAsyncServerDataFromMasterServer
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            self.btTryAgain.hidden = YES;
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        //Dados do device log -
        NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
        NSUUID *idVendor = [[UIDevice currentDevice] identifierForVendor];
        NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys: [[UIDevice currentDevice] systemName], @"device_system_name", [[UIDevice currentDevice] systemVersion], @"device_system_version", [[UIDevice currentDevice] model], @"device_model", [idVendor UUIDString], @"device_id_vendor", [ToolBox deviceHelper_Model], @"device_version", [NSString stringWithFormat:@"%f", 0.0], @"latitude", [NSString stringWithFormat:@"%f", 0.0], @"longitude", appID, @"app_id", nil];
        
        NSArray *allKeys = [dicParameters allKeys];
        NSString *parameters;
        
        for (int i = 0; i < [allKeys count]; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            
            if (parameters)
            {
                if (i == [allKeys count] - 1) {
                    parameters = [NSString stringWithFormat:@"%@%@=%@", parameters, key, [dicParameters objectForKey:key]];
                }
                else{
                    parameters = [NSString stringWithFormat:@"%@%@=%@&", parameters, key, [dicParameters objectForKey:key]];
                }
            }
            else
            {
                if (i == [allKeys count] - 1) {
                    parameters = [NSString stringWithFormat:@"%@=%@", key, [dicParameters objectForKey:key]];
                }
                else{
                    parameters = [NSString stringWithFormat:@"%@=%@&", key, [dicParameters objectForKey:key]];
                }
            }
        }
        
        NSString *url = [NSString stringWithFormat:@"http://%s", VALUE_MASTER_URL(MASTER_URL)];
        if (!parameters) {
            parameters = url;
        }
        else{
            parameters = [NSString stringWithFormat:@"%@?%@", url, parameters];
        }
        
        parameters = [parameters stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [connectionManager getRemoteDataFromMasterServerUsingURLParameters:parameters withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            if (response) {
                
                NSLog(@"\n\ngetRemoteDataFromMasterServerUsingURLParameters > response: %@\n\n", response);
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                NSString *urlBase = [response objectForKey:BASE_APP_URL];
                if (![urlBase isKindOfClass:[NSNull class]]) {
                    urlBase = [NSString stringWithFormat:@"http://%@", [urlBase lastPathComponent]];
                }
                
                NSString *urlChat = [response objectForKey:BASE_CHAT_URL];
                if (![urlChat isKindOfClass:[NSNull class]]) {
                    urlChat = [NSString stringWithFormat:@"http://%@", [urlChat lastPathComponent]];
                }
                
                [userDefaults setObject:urlBase forKey:BASE_APP_URL];
                [userDefaults setObject:urlChat forKey:BASE_CHAT_URL];
                
                [self verifyIfPresentCodeView];
            }
            else{
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                //
                self.btTryAgain.hidden = NO;
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_APP", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_APP", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
            
        }];
        
    }
    else{
        self.btTryAgain.hidden = NO;
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (void)verifyIfPresentCodeView
{    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AdAliveWS *adAliveWS = [[AdAliveWS alloc] initWithUrlServer:[userDefaults stringForKey:BASE_APP_URL] andUserEmail:AppD.loggedUser.email error:nil];
    adAliveWS.delegate = self;
    NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    //Busca geofences e beacons
    [adAliveWS getGeofenceRegionsWithAppID:appID];
    [adAliveWS findBeaconsWithAppId:[NSNumber numberWithInteger:[appID integerValue]]];
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    NSString *url = [userDefaults stringForKey:BASE_APP_URL];
    
    if(url){
        if ([connectionManager isConnectionActive])
        {
//            dispatch_async(dispatch_get_main_queue(),^{
//                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
//            });
            
            connectionManager.delegate = self;
            NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
            [connectionManager getAppConfig:[appID integerValue] andRole:@"" withCompletionHandler:^(NSDictionary *response, NSError *error) {
                
                if (error){
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    self.btTryAgain.hidden = NO;
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_CONFIGURATION_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CONFIGURATION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }else{
                    
                    self.btTryAgain.hidden = YES;
                    NSArray *keysList = [response allKeys];
                    
                    if ([keysList containsObject:@"app"]){
                        
                        //[Answers logLoginWithMethod:@"Sucesso Code" success:@YES customAttributes:@{}];
                        
                        NSDictionary *appDic = [[NSDictionary alloc] initWithDictionary:[response valueForKey:@"app"]];
                        appDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:appDic withString:@""];
                        
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        bool showCode = [[appDic objectForKey:@"show_code"] boolValue];
                        [userDefaults setBool:showCode forKey:PLISTKEY_SHOW_CODE];
                        
                        bool showRegisterButton = [[appDic objectForKey:PLISTKEY_SHOW_REGISTER_BUTTON] boolValue];
                        [userDefaults setBool:showRegisterButton forKey:PLISTKEY_SHOW_REGISTER_BUTTON];
                        
                        NSString *surveyTargetName = [[appDic objectForKey:PLISTKEY_SURVEY_GENERAL] isKindOfClass:[NSNull class]] ? @"": [appDic objectForKey:PLISTKEY_SURVEY_GENERAL];
                        [userDefaults setObject:surveyTargetName forKey:PLISTKEY_SURVEY_GENERAL];
                        
                        NSString *loginError = [appDic objectForKey:PLISTKEY_LOGIN_ERROR_MESSAGE];
                        if (loginError != nil && ![loginError isKindOfClass:[NSNull class]]){
                            [userDefaults setObject:loginError forKey:PLISTKEY_LOGIN_ERROR_MESSAGE];
                        }
                        
                        [userDefaults setObject:[appDic objectForKey:VUFORIA_ACCESS_KEY] forKey:VUFORIA_ACCESS_KEY];
                        [userDefaults setObject:[appDic objectForKey:VUFORIA_SECRET_KEY] forKey:VUFORIA_SECRET_KEY];
                        [userDefaults setObject:[appDic objectForKey:VUFORIA_LICENSE_KEY] forKey:VUFORIA_LICENSE_KEY];
                        
                        //Chaves Vuforia (23/01/2019)
                        //vuforia_access_key : a6f703306e53ed79b5339616bd311d869ac8770b
                        //vuforia_secret_key : 3c8988b1fc4856cdfa472784810ac2408ebbcebf
                        //vuforia_license_key : AWi+Y9T/////AAAACH9aa3Ynh0iBrEMUDGdZr8k5mDdT2GUyX0Iywx1D+Nw65AvDhGNRHJB+XHCnak9o7JDhUW+BGuZ2hUWHU74IBebt3NMSMykXkZ7dC0cky9wCJy8lzEpRSwD19e8U+c4uW5WOp7Bfe+aafg4GR7cLwzMNlnW6WPG41QSWv8vg9iEWznJP8TedYzEdxOgbT0rhvMetU+kbIut/KAC3msfOtgmtZE93I8IfBEclUUPM5O9sQGxRd25mvxDzX0eWGGgrBbz0pcoid3OziX1092x8wd1TZqzUSYEVr24/8SfN0cCIy5ZJ2j5tj0dELr4H74EeW12QXIt8jeXfg8K4RFuepyk/WsV0XZVPfnBMlO1Qmnw5
                        
                        [userDefaults setValue:[appDic objectForKey:@"name"] forKey:PLISTKEY_APP_NAME];
                        [userDefaults synchronize];
                        
                        //carregar dicionario com dados dos roles.
                        //Verificar se existe usuario logado, salvar o master event de acordo com o role.
                        //senao usar o role default (reseller)
                        
                        NSArray *allKeys = [appDic allKeys];
                        
                        AppD.appName = [appDic objectForKey:@"name"];
                        
                        if (![allKeys containsObject:@"roles"]) {
                            AppD.masterEventID = [[appDic valueForKey:@"master_event_id"] integerValue];
                            //
                            [userDefaults setInteger:AppD.masterEventID forKey:PLISTKEY_MASTER_EVENT_ID];
                            [userDefaults synchronize];
                            
                            [AppD createDefaultBackgroundImage];
                            //
                            NSString *backStr = [appDic valueForKey:@"background_image"];
                            NSString *logoStr = [appDic valueForKey:@"logo"];
                            NSString *bannerStr = [appDic valueForKey:@"head_image"];
                            
                            if (backStr != nil && ![backStr isEqualToString:@""]){
                                AppD.styleManager.baseLayoutManager.urlBackground = backStr;
                            }
                            
                            if (logoStr != nil && ![logoStr isEqualToString:@""]){
                                AppD.styleManager.baseLayoutManager.urlLogo = logoStr;
                            }
                            
                            if (bannerStr != nil && ![bannerStr isEqualToString:@""]){
                                AppD.styleManager.baseLayoutManager.urlBanner = bannerStr;
                            }
                            
                            [AppD.styleManager.colorPalette applyCustomColorLayout:appDic];
                            
                        }
                        else {
                            [AppD loadStyleManagerRoles:appDic];
                        }
                        
                        //Remove Previus Observer
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BACKGROUND object:nil];
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_LOGO object:nil];
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BANNER object:nil];
                        //Add Observer
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageBackground:) name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BACKGROUND object:nil];
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageLogo:) name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_LOGO object:nil];
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageBanner:) name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BANNER object:nil];
                        //
                        [AppD.styleManager.baseLayoutManager updateImagesFromURLs:false];
                        
                        //[AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:YES];
                        //[self checkBiometricProtection];
                        //NOTE: Para desabilitar o menu dinâmico comentar a linha abaixo e descomentar as duas acima. Também é necessário ir na classe AppDelegate e descomentar a chamada '[viewMenu createCompleteMenu];'.
                        [self getSideMenuDataFromServer];
                        
                    }else{
                        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:YES];
                        self.btTryAgain.hidden = NO;
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_APP", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_APP", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                }
            }];
        }
        else
        {
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:YES];
            self.btTryAgain.hidden = NO;
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }
    else{
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:YES];
        self.btTryAgain.hidden = NO;
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_APP", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_APP", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (void)getSideMenuDataFromServer
{
    AppConfigDataSource *configDS = [AppConfigDataSource new];
    
    [configDS getSideMenuConfigurationFromServerWithCompletionHandler:^(SideMenuConfig * _Nullable data, DataSourceResponse * _Nonnull response) {
       
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:YES];
        
        if (response.status == DataSourceResponseStatusSuccess) {
            [AppD setSideMenuConfigurations:data];
            //
            [self checkBiometricProtection];
        }else{
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:YES];
            self.btTryAgain.hidden = NO;
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_APP", @"") subTitle:response.message closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
        
    }];
}

- (void)goToLogin
{
    [self performSegueWithIdentifier:@"SegueToLogin" sender:self];
}

#pragma mark - AdAliveGeofence

-(void)didRegisterAllRegions
{
    NSLog(@"AdAliveGeofence >> didRegisterAllRegions");
}

-(void)didReceivePushMessage:(NSString *)message
{
    //Se caiu aqui significa que uma mensagem foi encontrada mais sua exibição não é automática (a SDK não fez uma notificação local).
    
    //Notificação de sistema:
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertTitle = @"Geofence";
    notification.alertBody = message;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.category = ADALIVE_GEOFENCE_PUSHNOTIFICATION_CATEGORY_NAME;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    //
    [AppD.soundManager vibrateDevice];
    
    NSLog(@"AdAliveGeofence >> didReceivePushMessage >> %@", message);
}

-(void)didReceiveRequestWithError
{
    NSLog(@"AdAliveGeofence >> didReceiveRequestWithError");
}

@end
