//
//  BeaconShowroomRadarVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "BeaconShowroomRadarVC.h"
#import "AppManager.h"
#import "BeaconShowroomManager.h"
#import "BeaconShowroomLiveCamVC.h"
#import "BeaconShowroomDataSource.h"
#import "UIViewVideoPlayer.h"
#import "UIImageView+AFNetworking.h"
#import "AdAliveAction.h"
//
#import "SmartDisplayView.h"
//
#import <EstimoteSDK/EstimoteSDK.h>

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface BeaconShowroomRadarVC()<BeaconShowroomManagerDelegate, UIViewVideoPlayerDelegate>

//Data:
@property(nonatomic, strong) NSMutableDictionary *products;
@property(nonatomic, strong) BeaconShowroomManager *beaconManager;
@property(nonatomic, strong) LaBeacon *currentBeaconInAction;
@property(nonatomic, strong) NSMutableArray *beaconsList;
@property(nonatomic, assign) BOOL isLoaded;
@property(nonatomic, assign) BOOL pauseBeaconProccess;
@property(nonatomic, assign) BOOL hideNavigationBar;
//
@property (nonatomic, strong) NSTimer *refreshDataTimer;
@property (nonatomic, strong) NSTimer *autoCloseScreenTimer;

//Layout:
@property (nonatomic, weak) IBOutlet UILabel *lblEmptyList;
@property (nonatomic, weak) IBOutlet UIView *viewBeaconReady;
@property (nonatomic, weak) IBOutlet UILabel *lblBeaconReady;
@property (nonatomic, weak) IBOutlet UIImageView *imvBeaconReadyBackground;
@property (nonatomic, weak) IBOutlet UIImageView *imvBeaconReadyForeground;
@property(nonatomic, strong) BeaconShowroomLiveCamVC *modalMirrorScreen;
@property (nonatomic, weak) IBOutlet UILabel *lblHeader;
//
@property (nonatomic, weak) IBOutlet UIView *viewMedia;
@property (nonatomic, weak) IBOutlet UIViewVideoPlayer *viewVideoAdvertising;
@property (nonatomic, weak) IBOutlet UIImageView *imvAdvertising;
@property (nonatomic, strong) SmartDisplayView *smartDisplayAdvertising;

@end

#pragma mark - • IMPLEMENTATION
@implementation BeaconShowroomRadarVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize currentShelf, pinToUnlock;
@synthesize beaconManager, currentBeaconInAction, isLoaded, pauseBeaconProccess, hideNavigationBar, products, refreshDataTimer, autoCloseScreenTimer, beaconsList;
@synthesize modalMirrorScreen, lblEmptyList, lblHeader, viewBeaconReady, lblBeaconReady, imvBeaconReadyBackground, imvBeaconReadyForeground, viewMedia, viewVideoAdvertising, imvAdvertising, smartDisplayAdvertising;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isLoaded = NO;
    pauseBeaconProccess = NO;
    products = [NSMutableDictionary new];
    
    [ESTConfig setupAppID:@"lab360-app-model-dkj" andAppToken:@"340c98083439dd7756a4f333427743bd"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionApplicationDidChangeStatusBarOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    viewVideoAdvertising.delegate = self;
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionDoubleTapGesture:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [doubleTapGesture setNumberOfTouchesRequired:1];
    //doubleTapGesture.delegate = self;
    [viewMedia addGestureRecognizer:doubleTapGesture];
    
    hideNavigationBar = NO;
    
    currentBeaconInAction = nil;
    
    smartDisplayAdvertising = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (!isLoaded) {
        [self.view layoutIfNeeded];
        [self setupLayout:currentShelf.name];
        //
        if (self.pinToUnlock != nil && ![self.pinToUnlock isEqualToString:@""]){
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(actionExit:)];
        }
        smartDisplayAdvertising.alpha = 0.0;
        [self getBeaconsFromServer];
        //
        isLoaded = YES;
    }else{
        
        if (beaconsList) {
            [self startBeaconManager];
            //
            [self updateBeaconViewShowingContent:YES];
            //
            if (smartDisplayAdvertising){
                smartDisplayAdvertising.alpha = 0.0;
            }
        }else{
            [self updateBeaconViewShowingContent:NO];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.viewVideoAdvertising updateVideoFrame];
    
    if (smartDisplayAdvertising){
        [smartDisplayAdvertising updateContentLayout];
        [smartDisplayAdvertising startAnimating];
        //
        [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
            smartDisplayAdvertising.alpha = 1.0;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (modalMirrorScreen == nil && viewMedia.hidden == NO){
        if (viewVideoAdvertising.playerStatus == UIViewVideoPlayerPlaying){
            [viewVideoAdvertising stopVideo];
        }
    }
    
    //Caso o usuário esteja saindo da tela (com um pop), as variáveis de controle são anuladas.
    if (self.isMovingFromParentViewController){
        beaconManager.delegate = nil;
        [beaconManager stopUpdates];
        [refreshDataTimer invalidate];
        refreshDataTimer = nil;
        [autoCloseScreenTimer invalidate];
        autoCloseScreenTimer = nil;
        //
        [smartDisplayAdvertising stopAnimating];
        smartDisplayAdvertising = nil;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)prefersStatusBarHidden
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        if (hideNavigationBar){
            return YES;
        }else{
            return NO;
        }
    }else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        return YES;
    }
    return NO;
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (void)actionApplicationDidBecomeActive:(NSNotification*)notification
{
    if (viewBeaconReady.hidden == NO) {
        //radar animation
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        rotationAnimation.duration = 2.0;
        rotationAnimation.cumulative = NO;
        rotationAnimation.repeatCount = HUGE_VALF;
        [imvBeaconReadyForeground.layer removeAllAnimations];
        [imvBeaconReadyForeground.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    
    if (viewMedia.hidden == NO){
        if (viewVideoAdvertising.playerStatus == UIViewVideoPlayerPaused){
            [viewVideoAdvertising resumeVideo];
        }
    }
}

- (void)actionApplicationDidEnterBackground:(NSNotification*)notification
{
    if (viewMedia.hidden == NO){
        [viewVideoAdvertising pauseVideo];
    }
}

- (void)actionApplicationDidChangeStatusBarOrientation:(NSNotification*)notification
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        if (!hideNavigationBar){
            [[self navigationController] setNavigationBarHidden:NO animated:YES];
            [self setNeedsStatusBarAppearanceUpdate];
            //
            [AppD updateLoadingFrameUsingSize:[UIScreen mainScreen].bounds.size];
        }
    }else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [self setNeedsStatusBarAppearanceUpdate];
        //
        [AppD updateLoadingFrameUsingSize:[UIScreen mainScreen].bounds.size];
    }
    
//    if (smartDisplayAdvertising){
//        [smartDisplayAdvertising updateContentLayout];
//        [smartDisplayAdvertising startAnimating];
//    }
}

- (void)actionRefreshData:(NSTimer*)timer
{
    if (pauseBeaconProccess){
        [self initiateRefreshDataTimer];
    }else{
        if ([self isViewLoaded] && self.view.window != nil) {
            if (beaconManager){
                beaconManager.delegate = nil;
                [beaconManager stopUpdates];
            }
            //
            [self getBeaconsFromServer];
        }
    }
}

- (void)actionExit:(id)sender
{
    if (self.pinToUnlock != nil) {
        
        beaconManager.delegate = nil;
        [beaconManager stopUpdates];
        [refreshDataTimer invalidate];
        [smartDisplayAdvertising stopAnimating];
        smartDisplayAdvertising = nil;
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        
        UITextField *textField = [alert addTextField:@"Insira o PIN"];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [textField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TITLE_NAVBAR]];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [textField setSpellCheckingType:UITextSpellCheckingTypeNo];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        
        [alert addButton:@"Sair" withType:SCLAlertButtonType_Normal actionBlock:^{
            [textField resignFirstResponder];
            
            //'fibonacci sequence' é a senha mestre padrão
            if ([textField.text isEqualToString:self.pinToUnlock] || [textField.text isEqualToString:@"112358"]){
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self getBeaconsFromServer];
            }
        }];
        
        [alert showError:self title:@"Proteção de Tela" subTitle:@"Esta tela está protegida com um PIN de segurança. Para interromper o monitoramento é necessário inserir o código de desbloqueio." closeButtonTitle:nil duration:0.0];
    }
}

- (void)actionDoubleTapGesture:(UITapGestureRecognizer*)gesture
{
    if (viewMedia.tag == 0){
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
            viewMedia.tag = 1;
            //
            if (self.navigationController.isNavigationBarHidden){
                hideNavigationBar = NO;
                [[self navigationController] setNavigationBarHidden:NO animated:YES];
                [self setNeedsStatusBarAppearanceUpdate];
                [AppD updateLoadingFrameUsingSize:[UIScreen mainScreen].bounds.size];
            }else{
                hideNavigationBar = YES;
                [[self navigationController] setNavigationBarHidden:YES animated:YES];
                [self setNeedsStatusBarAppearanceUpdate];
                [AppD updateLoadingFrameUsingSize:[UIScreen mainScreen].bounds.size];
            }
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                viewMedia.tag = 0;
                
                if (smartDisplayAdvertising){
                    [smartDisplayAdvertising updateContentLayout];
                    [smartDisplayAdvertising startAnimating];
                }
            });
        }
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)showroomManager:(BeaconShowroomManager *)showroomManager didDetectPickupForBeacon:(NSString *)beaconIdentifier
{
    LaBeacon *beacon = [products objectForKey:beaconIdentifier];
    if (beacon) {
        if (!pauseBeaconProccess){
            pauseBeaconProccess = YES;
            [self getProductDataFromServerUsingBeacon:beacon];
        }else{
            if (autoCloseScreenTimer && currentBeaconInAction && [currentBeaconInAction.tagID isEqualToString:beacon.tagID]){
                [autoCloseScreenTimer invalidate];
                autoCloseScreenTimer = [NSTimer scheduledTimerWithTimeInterval:beacon.adAliveAction.autoCloseTime target:self selector:@selector(hideCurrentMirrorScreenForBeaconProduct:) userInfo:nil repeats:NO];
            }
        }
    }
}

- (void)showroomManager:(BeaconShowroomManager *)showroomManager didDetectPutdownForBeacon:(NSString *)beaconIdentifier
{
//    LaBeacon *beacon = [products objectForKey:beaconIdentifier];
//    if (beacon) {
//        [self hideCurrentMirrorScreenForBeaconProduct:beacon];
//    }
    return;
}

-(void)showroomManager:(BeaconShowroomManager *)showroomManager didDetectMotionChange:(BOOL)isMoving toBeacon:(NSString *)beaconIdentifier withData:(NSDictionary *)beaconData
{
    if (isMoving){
        //DetectPickup
        LaBeacon *beacon = [products objectForKey:beaconIdentifier];
        if (beacon) {
            if (!pauseBeaconProccess){
                pauseBeaconProccess = YES;
                beacon.estimoteBeaconData = [[NSMutableDictionary alloc] initWithDictionary:beaconData];
                [self getProductDataFromServerUsingBeacon:beacon];
            }else{
                if (autoCloseScreenTimer && currentBeaconInAction && [currentBeaconInAction.tagID isEqualToString:beacon.tagID]){
                    [autoCloseScreenTimer invalidate];
                    autoCloseScreenTimer = [NSTimer scheduledTimerWithTimeInterval:beacon.adAliveAction.autoCloseTime target:self selector:@selector(hideCurrentMirrorScreenForBeaconProduct:) userInfo:nil repeats:NO];
                }
            }
        }
        
    }else{
        //DetectPutdown
        LaBeacon *beacon = [products objectForKey:beaconIdentifier];
        if (beacon) {
            beacon.estimoteBeaconData = [[NSMutableDictionary alloc] initWithDictionary:beaconData];
            //[self hideCurrentMirrorScreenForBeaconProduct:beacon];
        }
    }
}

#pragma mark - UIViewVideoPlayerDelegate

- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView didChangeStatus:(UIViewVideoPlayerStatus)status
{
    if (status == UIViewVideoPlayerReachedEndOfVideo){
        [playerView resumeVideo];
    }
}

- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView videoProgressUpdate:(CGFloat)progress timePlayed:(long)sPlayed timeRemaining:(long)sRemaining totalTime:(long)sTotal
{
    return;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString*)screenName
{
    [super setupLayout:screenName];
    
    lblEmptyList.text = @"Nenhum beacon estimote foi encontrado para esta prateleira. Por favor, verifique sua conexão e se as prateleiras estão configuradas corretamente no servidor.";
    lblEmptyList.textColor = [UIColor grayColor];
    lblEmptyList.backgroundColor = nil;
    lblEmptyList.numberOfLines = 0;
    lblEmptyList.textAlignment = NSTextAlignmentCenter;
    lblEmptyList.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:17];
    [lblEmptyList setHidden:YES];
    
    viewBeaconReady.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //
    lblBeaconReady.text = @"Aguardando\nmovimentação de\nprodutos...";
    lblBeaconReady.textColor = [UIColor darkGrayColor];
    lblBeaconReady.backgroundColor = nil;
    lblBeaconReady.numberOfLines = 0;
    lblBeaconReady.textAlignment = NSTextAlignmentCenter;
    lblBeaconReady.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:22.0];
    //
    imvBeaconReadyBackground.backgroundColor = [UIColor clearColor];
    imvBeaconReadyBackground.image = [UIImage imageNamed:@"BeaconRadarBackground"];
    imvBeaconReadyForeground.backgroundColor = [UIColor clearColor];
    imvBeaconReadyForeground.image = [UIImage imageNamed:@"BeaconRadarForeground"];
    imvBeaconReadyForeground.alpha = 0.5;
    
    lblHeader.text = currentShelf.detail;
    lblHeader.textColor = [UIColor whiteColor];
    lblHeader.backgroundColor = [UIColor grayColor];
    lblHeader.numberOfLines = 0;
    lblHeader.textAlignment = NSTextAlignmentCenter;
    lblHeader.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:15];
    
    viewMedia.backgroundColor = [UIColor blackColor];
    viewVideoAdvertising.backgroundColor = [UIColor blackColor];
    imvAdvertising.backgroundColor = [UIColor clearColor];
    imvAdvertising.image = nil;
    
    [viewBeaconReady setHidden:YES];
    [viewMedia setHidden:YES];
    
}

- (void)getBeaconsFromServer
{
    BeaconShowroomDataSource *ds = [BeaconShowroomDataSource new];
    
    [self showActivityIndicatorView];
    
    [ds getBeaconsForShowroom:currentShelf.parentItemID shelf:currentShelf.itemID withCompletionHandler:^(NSMutableArray<LaBeacon *> * _Nullable data, DataSourceResponse * _Nonnull response) {
        
        if (response.status == DataSourceResponseStatusSuccess){
            [self configureBeacons: data];
        }else{
            [self updateBeaconViewShowingContent:NO];
            //
            [self initiateRefreshDataTimer];
        }
        
        [self hideActivityIndicatorView];
        
    }];
}

- (void)getProductDataFromServerUsingBeacon:(LaBeacon*)referenceBeacon
{
    BeaconShowroomDataSource *ds = [BeaconShowroomDataSource new];
    
    [self showActivityIndicatorView];
    
    [ds getProductInfoUsingSKU:referenceBeacon.sku withCompletionHandler:^(NSDictionary * _Nullable data, DataSourceResponse * _Nonnull response) {
        
        if (response.status == DataSourceResponseStatusSuccess){
            
            //Buscando a url do banner:
            NSDictionary *proDic = [data valueForKey:@"product"];
            NSArray *actions = [[NSArray alloc] initWithArray:[proDic valueForKey:@"actions"]];
            for (NSDictionary *dicAction in actions){
                NSString *type = [dicAction valueForKey:@"type"];
                if ([type isEqualToString:ACTION_BANNER]){
                    
                    BOOL ok = YES;
                    
                    @try {
                        referenceBeacon.adAliveAction = [AdAliveAction new];
                        referenceBeacon.adAliveAction.type = ACTION_BANNER;
                        referenceBeacon.adAliveAction.actionName = [dicAction valueForKey:@"name"];
                        referenceBeacon.adAliveAction.actionID = [[dicAction valueForKey:@"id"] longValue];
                        referenceBeacon.adAliveAction.horizontalURL = [dicAction valueForKey:@"href_horizontal_url"];
                        referenceBeacon.adAliveAction.verticalURL = [dicAction valueForKey:@"href_vertical_url"];
                        //
                        referenceBeacon.adAliveAction.autoCloseTime = [[dicAction valueForKey:@"time"] longValue];
                        if (referenceBeacon.adAliveAction.autoCloseTime <= 0){
                            referenceBeacon.adAliveAction.autoCloseTime = 5.0;
                        }
                        //
                        referenceBeacon.adAliveAction.productID = [[proDic valueForKey:@"id"] longValue];
                        referenceBeacon.adAliveAction.productSKU = [proDic valueForKey:@"sku"];
                        referenceBeacon.sku = [proDic valueForKey:@"sku"];
                    } @catch (NSException *exception) {
                        ok = NO;
                        NSLog(@"getProductDataFromServerUsingBeacon >> Error >> %@", [exception reason]);
                    }
                    
                    if (ok){
                       break;
                    }
                }
            }
            
            //Verificação da imagem:
            if ([ToolBox textHelper_CheckRelevantContentInString:referenceBeacon.adAliveAction.horizontalURL] || [ToolBox textHelper_CheckRelevantContentInString:referenceBeacon.adAliveAction.verticalURL]){
                [self showMirrorScreenForBeaconProduct:referenceBeacon];
            }else{
                pauseBeaconProccess = NO;
            }
        
        }else{
            pauseBeaconProccess = NO;
        }
        
        [self hideActivityIndicatorView];
    }];
}

-(void)configureBeacons:(NSArray *)beacons
{
    beaconsList = [NSMutableArray new];
    
    for (LaBeacon *beacon in beacons){
        //Beacon Type == 0 indica que se trata de um beacon estimote. Nesta tela apenas beacons deste tipo são relevantes.
        if (beacon.beaconID != 0 && [beacon.type isEqualToString:@"0"] && [ToolBox textHelper_CheckRelevantContentInString:beacon.tagID]){
            [products setValue:beacon forKey:beacon.tagID];
            [beaconsList addObject:[NSString stringWithFormat:@"%@", beacon.tagID]];
        }
    }
    
    if (beaconsList.count > 0) {
        [self startBeaconManager];
        //
        [self updateBeaconViewShowingContent:YES];
    }else{
        [self updateBeaconViewShowingContent:NO];
    }
    
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
}

- (void)showMirrorScreenForBeaconProduct:(LaBeacon*)beacon
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BeaconShowroom" bundle:[NSBundle mainBundle]];
    modalMirrorScreen = [storyboard instantiateViewControllerWithIdentifier:@"BeaconShowroomLiveCamVC"];
    modalMirrorScreen.beaconTagID = beacon.tagID;
    modalMirrorScreen.productSKU = beacon.sku;
    modalMirrorScreen.verticalBannerURL = beacon.adAliveAction.verticalURL;
    modalMirrorScreen.horizontalBannerURL = beacon.adAliveAction.horizontalURL;
    modalMirrorScreen.inheritedOrientation = [[UIDevice currentDevice] orientation];
    //
    [modalMirrorScreen awakeFromNib];
    
    modalMirrorScreen.modalPresentationStyle = UIModalPresentationFullScreen;
    modalMirrorScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:modalMirrorScreen animated:YES completion:^{

        if (viewMedia.hidden == NO){
            if (viewVideoAdvertising.playerStatus == UIViewVideoPlayerPlaying || viewVideoAdvertising.playerStatus == UIViewVideoPlayerReadyToPlay){
                [viewVideoAdvertising pauseVideo];
            }
        }
        
        if (smartDisplayAdvertising){
            [smartDisplayAdvertising stopAnimating];
        }
        
        //Temporizador para fechar a tela:
        currentBeaconInAction = [products objectForKey:beacon.tagID];
        autoCloseScreenTimer = [NSTimer scheduledTimerWithTimeInterval:beacon.adAliveAction.autoCloseTime target:self selector:@selector(hideCurrentMirrorScreenForBeaconProduct:) userInfo:nil repeats:NO];
        
        //AdAliveLog:
        if (beacon.adAliveAction.actionID != 0){
            [AppD logAdAliveActionWithID:beacon.adAliveAction.actionID];
        }
        if (beaconManager.managerType == BeaconShowroomManagerTypeRangingNearable){
            //Somente o tipo 'BeaconShowroomManagerTypeRangingNearable' executa este tipo de log.
            [beacon.estimoteBeaconData setValue:@(beacon.beaconID) forKey:@"beacon_id"];
            [beaconManager logEstimoteBeaconDataToServer:beacon.estimoteBeaconData forUser:AppD.loggedUser.email];
        }
        
    }];
}

//- (void)hideCurrentMirrorScreenForBeaconProduct:(LaBeacon*)beacon
- (void)hideCurrentMirrorScreenForBeaconProduct:(NSTimer*)timer
{
    [autoCloseScreenTimer invalidate];
    autoCloseScreenTimer = nil;
    
    if (modalMirrorScreen) {
        if ([modalMirrorScreen.beaconTagID isEqualToString:currentBeaconInAction.tagID]) {
            
            __block LaBeacon* beacon = [currentBeaconInAction copyObject];
            
            [self dismissViewControllerAnimated:YES completion:^{
                modalMirrorScreen = nil;
                currentBeaconInAction = nil;
                //AdAliveLog:
                if (beaconManager.managerType == BeaconShowroomManagerTypeRangingNearable){
                    //Somente o tipo 'BeaconShowroomManagerTypeRangingNearable' executa este tipo de log.
                    [beacon.estimoteBeaconData setValue:@(beacon.beaconID) forKey:@"beacon_id"];
                    [beaconManager logEstimoteBeaconDataToServer:beacon.estimoteBeaconData forUser:AppD.loggedUser.email];
                }
                //
                pauseBeaconProccess = NO;
            }];
        }
    }
}

- (void)updateBeaconViewShowingContent:(BOOL)show
{
    if (show) {
        
        BOOL showRadar = NO;
        
        if (currentShelf.mediaAdvertisingURL == nil) {
            showRadar = YES;
        }else{
            NSURL *url = [NSURL URLWithString:currentShelf.mediaAdvertisingURL];
            if (url && url.scheme && url.host)
            {
                [viewBeaconReady setHidden:YES];
                [viewMedia setHidden:NO];
                [lblEmptyList setHidden:YES];
                
                self.view.backgroundColor = [UIColor blackColor];
                
                imvAdvertising.alpha = 0.0;
                
                if (currentShelf.isMediaAdvertisingVideo){
                    //É uma url de vídeo
                    viewVideoAdvertising.alpha = 1.0;
                    //
                    if (viewVideoAdvertising.playerStatus == UIViewVideoPlayerPaused){
                        [viewVideoAdvertising resumeVideo];
                    }else{
                        [viewVideoAdvertising playVideoFrom:currentShelf.mediaAdvertisingURL atTime:0.0 muted:NO];
                        [viewVideoAdvertising setMute:NO];
                    }
                }else{
                    //É uma url de imagem
                    viewVideoAdvertising.alpha = 0.0;
                    //
                    [imvAdvertising setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentShelf.mediaAdvertisingURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

                        if ((image.size.width > (image.size.height * 1.2)) || (image.size.height > (image.size.width * 1.2))){
                            if (smartDisplayAdvertising == nil){
                                smartDisplayAdvertising = [SmartDisplayView newSmartDisplayViewWithFrame:viewMedia.frame image:image parentView:viewMedia];
                                smartDisplayAdvertising.alpha = 0.0;
                                smartDisplayAdvertising.animationTransition = SmartDisplayViewAnimationTransitionRestartSmoothly;
                                smartDisplayAdvertising.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
                                [smartDisplayAdvertising startAnimating];
                                //
                                [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
                                    smartDisplayAdvertising.alpha = 1.0;
                                }];
                            }
                        }else{
                            imvAdvertising.alpha = 1.0;
                            imvAdvertising.image = image;
                        }
                        
                    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                        imvAdvertising.alpha = 1.0;
                        imvAdvertising.image = nil;
                    }];
                }
            }else{
                showRadar = YES;
            }
        }
        
        if (showRadar){
            [viewBeaconReady setHidden:NO];
            [viewMedia setHidden:YES];
            [lblEmptyList setHidden:YES];
            
            //radar animation
            CABasicAnimation* rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
            rotationAnimation.duration = 2.0;
            rotationAnimation.cumulative = NO;
            rotationAnimation.repeatCount = HUGE_VALF;
            [imvBeaconReadyForeground.layer removeAllAnimations];
            [imvBeaconReadyForeground.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        }
    }else{
        [viewBeaconReady setHidden:YES];
        [lblEmptyList setHidden:NO];
    }
}

- (void)applicationDidChangeActive:(NSNotification *)notification
{
    if (viewBeaconReady.hidden == NO && modalMirrorScreen == nil){
        [self updateBeaconViewShowingContent:YES];
    }
}

- (void)startBeaconManager
{
    //"estimote_type": proximity / location / sticker
    
    NSString *tagID = [beaconsList firstObject];
    LaBeacon *beacon = [products objectForKey:tagID];
    beaconManager = nil;
    
    if ([beacon.estimoteType isEqualToString:@"sticker"]){
        beaconManager = [[BeaconShowroomManager alloc] initWithProductsIdentifiers:beaconsList type:BeaconShowroomManagerTypeRangingNearable andDelegate:self];
        //O tipo abaixo não executa captação de dados do dispositivo beacon estimote.
        //beaconManager = [[BeaconShowroomManager alloc] initWithProductsIdentifiers:beaconsList type:BeaconShowroomManagerTypeMotionNearable andDelegate:self];
    }else if ([beacon.estimoteType isEqualToString:@"location"]){
        beaconManager = [[BeaconShowroomManager alloc] initWithProductsIdentifiers:beaconsList type:BeaconShowroomManagerTypeMotionTelemetry andDelegate:self];
    }
    
    if (beaconManager) {
        pauseBeaconProccess = NO;
        //
        [beaconManager startUpdates];
        //
        [self initiateRefreshDataTimer];
    }
}

- (void)initiateRefreshDataTimer
{
    if (refreshDataTimer) {
        [refreshDataTimer invalidate];
    }
    refreshDataTimer = [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(actionRefreshData:) userInfo:nil repeats:NO];
}

@end
