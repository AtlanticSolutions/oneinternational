//
//  VC_CameraAdAlive.m
//  AHK-100anos
//
//  Created by Erico GT on 10/27/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
//
#import "VC_CameraAdAlive.h"
#import "ProductViewController.h"
#import "AdAliveCamera.h"
#import "AdAliveView.h"
#import "AdAliveWS.h"
#import "ButtonActionDelegate.h"
#import "VC_WebViewCustom.h"
#import "AdAliveScannerTargetManager.h"
#import "ActionModel3D_AR.h"
#import "ActionModel3D_Scene_ViewerVC.h"
#import "ActionModel3D_AR_ViewerVC.h"
#import "ActionModel3D_PlaceableAR_ViewerVC.h"
#import "ActionModel3D_TargetImage_ViewerVC.h"
#import "ActionModel3D_QuickLookAR_ViewerVC.h"
//
#import "AVPlayerView.h"

//NOTA: A animação do scan pesa no processamento. Para deixar habilitado por padrão é aconselhável verificar o dispositivo e apenas liberar para hardwares mais fortes.
#define USE_SCANLINE_ANIMATION YES

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_CameraAdAlive()<AdAliveViewDelegate, AdAliveDelegate, ButtonActionDelegate, AdAliveWSDelegate, ProductViewControllerDelegate, UIAlertViewDelegate, AVPlayerViewDelegate>

@property (nonatomic, strong) IBOutlet AdAliveView* eaglView;
@property(nonatomic, strong) IBOutlet UIButton *btnFlashButton;

@property(nonatomic, assign) CGRect viewFrame;
@property(nonatomic, assign) BOOL suspendScanning;
@property(nonatomic, assign) int lastErrorCode;
@property(nonatomic, strong) AdAliveCamera *adAlive;
@property(nonatomic, strong) NSString *lastTargetName;
@property(nonatomic, strong) NSString *videoURL;

@property(nonatomic, assign) BOOL productDetailOpened;
@property(nonatomic, strong) NSMutableDictionary *scannedProductsCache;
@property(nonatomic, strong) NSMutableDictionary *scannedProductsError;

@property(nonatomic, strong) NSDictionary *registeredProductAction;

@property(nonatomic, strong) AdAliveScannerTargetManager *scannerTargetManager;
@property(nonatomic, strong) UIImage *snapshot;

@property(nonatomic, strong) UIImageView *splashView;

@property(nonatomic, strong) UIView *cameraView;

@property(nonatomic, strong) AVPlayerView *avPlayerView;

@property(nonatomic, assign) AdAliveViewStatusVideoAR videoARStatus;

@property(nonatomic, strong) UIBarButtonItem *shareButton;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_CameraAdAlive
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
}

#pragma mark - • SYNTESIZES
@synthesize eaglView, btnFlashButton, cameraView, splashView, avPlayerView, videoARStatus, shareButton;
@synthesize viewFrame, suspendScanning, lastErrorCode, adAlive, lastTargetName, videoURL;
@synthesize productDetailOpened, scannerTargetManager, scannedProductsCache, scannedProductsError, snapshot, showVideoShareButton;
//
@synthesize registeredProductAction;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

		self.adAlive = [[AdAliveCamera alloc] initWithAccessKey:[defaults stringForKey:VUFORIA_ACCESS_KEY] secretKey:[defaults stringForKey:VUFORIA_SECRET_KEY] licenseKey:[defaults stringForKey:VUFORIA_LICENSE_KEY] urlServer:[defaults stringForKey:BASE_APP_URL] userEmail:AppD.loggedUser.email andDelegate:self error:nil];
        
        // we use the iOS notification to pause/resume the AR when the application goes (or comeback from) background
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseAR) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAR) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [self stopCamera];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    eaglView.delegate = nil;
    eaglView.buttonDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (AppD.adAliveVideoCacheManager == nil){
        AppD.adAliveVideoCacheManager = [AdAliveVideoCacheManager newVideoCache];
    }
    
    productDetailOpened = NO;
    suspendScanning = NO;
    snapshot = nil;
    videoARStatus = AdAliveViewStatusVideoAR_Unknown;
    videoURL = nil;
    scannedProductsCache = [NSMutableDictionary new];
    scannedProductsError = [NSMutableDictionary new];
    
    lastErrorCode = 99;
    
    //FLASH
    btnFlashButton.backgroundColor = [UIColor clearColor];
    btnFlashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFlashButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnFlashButton setImage:[ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal andImageTemplate:[UIImage imageNamed:@"flash-button.png"]] forState:UIControlStateNormal];
    [btnFlashButton setImage:[ToolBox graphicHelper_ImageWithTintColor:[UIColor orangeColor] andImageTemplate:[UIImage imageNamed:@"flash-button.png"]] forState:UIControlStateSelected];
    [btnFlashButton addTarget:self action:@selector(flashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnFlashButton setFrame:CGRectMake(0, 0, 30, 30)];
    [btnFlashButton setExclusiveTouch:YES];
    
    UIBarButtonItem *flashView = [[UIBarButtonItem alloc] initWithCustomView:btnFlashButton];
    
    //SHARE
    shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionShareVideo:)];
    [shareButton setEnabled:NO];
    [shareButton setTintColor:AppD.styleManager.colorPalette.backgroundNormal];
    
    //INFO
    UIImage *image = [[UIImage imageNamed:@"NavControllerInfoIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *buttonInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonInfo.tag = 1;
    buttonInfo.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    [buttonInfo setImage:image forState:UIControlStateNormal];
    [buttonInfo setImage:image forState:UIControlStateHighlighted];
    [buttonInfo setFrame:CGRectMake(0, 0, 32, 32)];
    [buttonInfo setClipsToBounds:YES];
    [buttonInfo setExclusiveTouch:YES];
    [buttonInfo setTintColor:AppD.styleManager.colorPalette.textNormal];
    [buttonInfo addTarget:self action:@selector(actionTargets:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[buttonInfo.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[buttonInfo.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithCustomView:buttonInfo];
    
    //ALL
    self.navigationItem.rightBarButtonItems = @[infoButton, flashView, shareButton];
    
    scannerTargetManager = [AdAliveScannerTargetManager new];
    [scannerTargetManager loadIdentifiedProductsToUser:AppD.loggedUser.userID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
    if (productDetailOpened) {
		[self resumeAR];
        productDetailOpened = NO;
        //
        if (splashView){
            [splashView removeFromSuperview];
            splashView = nil;
        }
        //
        [self verifyRegisteredVideosURLs];
	}
	else{
        
//        dispatch_async(dispatch_get_main_queue(),^{
//            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
//        });
        [self showLoadingView];
        
        NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
        [self.adAlive registerAppID:appID];
        @try {
            [self.adAlive initAR];
        } @catch (NSException *exception) {
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert showError:@"Erro" subTitle:[NSString stringWithFormat:@"Um erro inesperado impediu que a câmera fosse configurada corretamente.\n [%@]", [exception reason]] closeButtonTitle:nil duration:0.0];
        }
		
	}
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        suspendScanning = NO;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout:@"Scanner AdAlive"];
    
    //Criando a eaglView:
    
    if (self.eaglView){
        [self.eaglView removeFromSuperview];
    }
    viewFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    self.eaglView = [[AdAliveView alloc] initWithFrame:viewFrame viewController:self andCamera:adAlive];
    
    //Para habilitar o snapshot:
    [((CAEAGLLayer*)self.eaglView.layer) setOpaque:YES];
    [((CAEAGLLayer*)self.eaglView.layer) setDrawableProperties:@{kEAGLDrawablePropertyRetainedBacking: [NSNumber numberWithBool:YES], kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8,}];
    
    self.eaglView.delegate = self;
    self.eaglView.buttonDelegate = self;
    
    //Criando a cameraView:
    if (cameraView){
        [cameraView removeFromSuperview];
    }
    cameraView  = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    cameraView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cameraView];
    [cameraView addSubview:eaglView];
    
    //splash:
    splashView = [[UIImageView alloc] initWithFrame:viewFrame];
    [splashView setContentMode:UIViewContentModeScaleAspectFill];
    [splashView setImage:[UIImage imageNamed:@"adalive_scan_background.jpg"]];
    [self.view addSubview:splashView];
    
    avPlayerView = [[AVPlayerView alloc] initWithFrame:CGRectMake(5.0, 5.0, self.view.frame.size.width - 10.0, self.view.frame.size.height - 10.0)];
    [self.view addSubview:avPlayerView];
    avPlayerView.delegate = self;
    //
    UIView * scanLineView = [self.view viewWithTag:VIEW_SCAN_LINE_TAG];
    if (scanLineView == nil){
        [self scanlineCreate];
    }else{
        [self.view bringSubviewToFront:scanLineView];
    }
    
    self.lastTargetName = nil;
    
    suspendScanning = YES;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.eaglView stopVideoAR];
    
    if (productDetailOpened) {
        [self pauseAR];
    }
    else{
        [self stopCamera];
    }

    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self hideLoadingView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)flashButtonTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    BOOL value = !button.isSelected;
    
    if ([self.adAlive setFlashMode:value]){
        [button setSelected:value];
    }
}

-(IBAction)actionPhoto:(UIButton*)sender
{
    //pausando o scanner
    [sender setEnabled:NO];
    suspendScanning = YES;
    
    [self apllyPhotoEffect];
    
    snapshot = [self snapshotOpenGL];
    
    if (snapshot){
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[snapshot] applicationActivities:nil];
        if (IDIOM == IPAD){
            activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems.firstObject;
        }
        [self presentViewController:activityController animated:YES completion:^{
            NSLog(@"activityController presented");
        }];
        [activityController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            NSLog(@"activityController completed: %@", (completed ? @"YES" : @"NO"));
            [sender setEnabled:YES];
            suspendScanning = NO;
        }];
    }else{
        [sender setEnabled:YES];
        suspendScanning = NO;
    }
}

- (UIImage*)snapshotOpenGL
{
    const int s = [UIScreen mainScreen].nativeScale;
    const int w = eaglView.frame.size.width;
    const int h = eaglView.frame.size.height;
    
    const NSInteger myDataLength = w * h * 4 * s * s;
    
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, w*s, h*s, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    //gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y < h*s; y++)
    {
        memcpy( buffer2 + (h*s - 1 - y) * w * 4 * s, buffer + (y * 4 * w * s), w * 4 * s );
    }
    free(buffer);
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w * s;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageAlphaInfo alphaInfo = kCGImageAlphaNoneSkipFirst;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(w*s, h*s, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, YES, renderingIntent);
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t length = width * height * 4;
    uint32_t *pixels = (uint32_t *)malloc(length);
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * 4, CGImageGetColorSpace(imageRef), alphaInfo | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), imageRef);
    CGImageRef outputRef = CGBitmapContextCreateImage(context);
    
    UIImage *print = [UIImage imageWithCGImage:outputRef];
    
    // release:
    CGImageRelease(imageRef);
    CGImageRelease(outputRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpaceRef);
    free(buffer2);
    free(pixels);
    
    return print;
    
    
    
    
    //Método antigo:
    /*
    //desenhando o contexto:
    int areaWidth = (int)(cameraView.frame.size.width);
    int areaHeight = (int)(cameraView.frame.size.height);
    //
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect s = CGRectMake(0, 0, areaWidth * scale, areaHeight * scale);
    uint8_t *buffer = (uint8_t *) malloc(s.size.width * s.size.height * 4);
    glReadPixels(0, 0, s.size.width, s.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, buffer, s.size.width * s.size.height * 4, NULL);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate(s.size.width, s.size.height, 8, 32, s.size.width * 4, colorSpaceRef, kCGBitmapByteOrderDefault, ref, NULL, true, kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpaceRef);
    size_t width = CGImageGetWidth(iref);
    size_t height = CGImageGetHeight(iref);
    size_t length = width * height * 4;
    uint32_t *pixels = (uint32_t *)malloc(length);
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * 4, CGImageGetColorSpace(iref), kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
    
    //transform
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformMakeTranslation(0.0f, height);
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    CGContextConcatCTM(context, transform);
    
    //draw:
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
    CGImageRef outputRef = CGBitmapContextCreateImage(context);
    UIImage *print = [UIImage imageWithCGImage:outputRef];
    
    //free memory
    CGDataProviderRelease(ref);
    CGImageRelease(iref);
    CGContextRelease(context);
    CGImageRelease(outputRef);
    free(pixels);
    free(buffer);
    
    return print;
     */
}

- (IBAction)actionShareVideo:(UIBarButtonItem*)sender
{
    [self.eaglView pauseVideoAR];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSURL *nsurl = nil;
        if ([videoURL hasPrefix:@"http"] || [videoURL hasPrefix:@"ftp"] || [videoURL hasPrefix:@"www"]){
            nsurl = [NSURL URLWithString:videoURL];
        }else{
            nsurl = [NSURL fileURLWithPath:videoURL];
        }
        
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[nsurl] applicationActivities:nil];
        if (IDIOM == IPAD){
            activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems.firstObject;
        }
        [self presentViewController:activityController animated:YES completion:^{
            NSLog(@"activityController presented");
        }];
        [activityController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            NSLog(@"activityController completed: %@", (completed ? @"YES" : @"NO"));
            [self.eaglView resumeVideoAR];
        }];
    });
}

-(IBAction)actionTargets:(id)sender
{
    suspendScanning = YES;
    //
    [self performSegueWithIdentifier:@"SegueToTargets" sender:nil];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - AVPlayerViewDelegate

- (BOOL)avPlayerViewActionForCloseButton:(AVPlayerView*)view
{
    [self.eaglView stopVideoAR];
    //
    return YES;
}

- (BOOL)avPlayerViewActionForPlayButton:(AVPlayerView*)view
{
    if (videoARStatus == AdAliveViewStatusVideoAR_Paused){
        [self.eaglView resumeVideoAR];
        return YES;
    }else{
        [self.eaglView pauseVideoAR];
        return NO;
    }
}

- (BOOL)avPlayerViewActionForMuteButton:(AVPlayerView*)view
{
    float volume = [self.eaglView getVolumeFromVideoAR];
    
    if (volume == 0.0){
        [self.eaglView setVolumeToVideoAR:1.0];
        return YES;
    }else{
        [self.eaglView setVolumeToVideoAR:0.0];
        return NO;
    }
}

#pragma mark - UIAlertViewDelegate

- (void) pauseAR {
    
    [self.eaglView stopVideoAR];
    
    NSError * error = nil;
    if (![self.adAlive pauseAR:&error]) {
        NSLog(@"Error pausing AR:%@", [error description]);
    }
    //[self freeOpenGLESResources];
}

- (void) resumeAR {
    NSError * error = nil;
    if(! [self.adAlive resumeAR:&error]) {
        NSLog(@"Error resuming AR:%@", [error description]);
    }
    
    //[self finishOpenGLESCommands];
    [self.eaglView updateRenderingPrimitives];
    
    // on resume, we reset the flash and the associated menu item
    [self.adAlive setFlashMode:false];

}

-(void)stopCamera
{
    [self.adAlive stopAR:nil];
    
    // Be a good OpenGL ES citizen: now that Vuforia is paused and the render
    // thread is not executing, inform the root view controller that the
    // EAGLView should finish any OpenGL ES commands
    [self.eaglView finishOpenGLESCommands];
}

- (void)finishOpenGLESCommands
{
    // Called in response to applicationWillResignActive.  Inform the EAGLView
    [self.eaglView finishOpenGLESCommands];
}

- (void)freeOpenGLESResources
{
    // Called in response to applicationDidEnterBackground.  Inform the EAGLView
    [self.eaglView freeOpenGLESResources];
}

#pragma mark - AdAliveViewDelegate

-(void)willRecognizeTargetWithName:(NSString *)targetName
{
    if (![targetName isEqualToString:self.lastTargetName] && !suspendScanning){
        
        //Verificação de produtos com erro:
        if ([[scannedProductsError allKeys] containsObject:targetName]){
            return;
        }
        
        //Verificação de produtos já escaneados:
        NSDictionary *cachedProduct = [scannedProductsCache objectForKey:targetName];
        if (cachedProduct){
            self.lastTargetName = targetName;
            [self didReceiveResponse:nil withSuccess:cachedProduct];
            return;
        }
        
        
        //mock teste:
        
        //PlaceableAR
//        self.lastTargetName = targetName;
//        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ActionModel3D_Sample_TypePlaceableAR" ofType:@"json"]];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        [self didReceiveResponse:nil withSuccess:dic];
        
        //Específicos
//        if ([targetName isEqualToString:@"4nrMm9BkVB"] || [targetName isEqualToString:@"yNnCca8p5x"] || [targetName isEqualToString:@"kLdgGtxGhu"]){
//
//            self.lastTargetName = targetName;
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                NSError *error;
//                NSData *data = nil;
//                NSDictionary *dic = [NSDictionary new];
//
//                if ([targetName isEqualToString:@"4nrMm9BkVB"]){
//                    //SCENE
//                    data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ActionModel3D_Sample_TypeScene" ofType:@"json"]];
//                    dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//
//                }else if ([targetName isEqualToString:@"yNnCca8p5x"]){
//                    //AR
//                    data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ActionModel3D_Sample_TypeAR" ofType:@"json"]];
//                    dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//
//                }else if ([targetName isEqualToString:@"kLdgGtxGhu"]){
//                    //IMAGE TARGET
//                    data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ActionModel3D_Sample_TypeImageTarget" ofType:@"json"]];
//                    dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//                }
//
//                [self didReceiveResponse:nil withSuccess:dic];
//
//            });
//
//        }else{
//
//            [self showLoadingView];
//
//            self.lastTargetName = targetName;
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            AdAliveWS *adalivews = [[AdAliveWS alloc] initWithUrlServer:[defaults stringForKey:BASE_APP_URL] andUserEmail:AppD.loggedUser.email error:nil];
//            adalivews.delegate = self;
//            NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
//            [adalivews findProductWithTargetName:targetName appID:appID];
//
//        }
        
        //código original:
        
        [self showLoadingView];
        self.lastTargetName = targetName;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        AdAliveWS *adalivews = [[AdAliveWS alloc] initWithUrlServer:[defaults stringForKey:BASE_APP_URL] andUserEmail:AppD.loggedUser.email error:nil];
        adalivews.delegate = self;
        NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
        [adalivews findProductWithTargetName:targetName appID:appID];
	}
}

-(void)didFinishVideoAR
{
    NSLog(@"didFinishVideoAR");
    //
    //self.lastTargetName = nil;
    //[self scanlineStart];
}

-(void)didChangePlaybackStateVideoAR:(AdAliveViewStatusVideoAR)videoStatus
{
    BOOL needRestartScanning;
    
    videoARStatus = videoStatus;
    
    switch (videoStatus) {
        case AdAliveViewStatusVideoAR_Unknown:{
            needRestartScanning = YES;
            NSLog(@"AdAliveViewStatusVideoAR_Unknown");
            
        }break;
        //
        case AdAliveViewStatusVideoAR_ReachedEnd:{
            needRestartScanning = YES;
            [avPlayerView stopVideo];
            [self resumeAR];
            if (showVideoShareButton){
                [shareButton setEnabled:NO];
                [shareButton setTintColor:AppD.styleManager.colorPalette.backgroundNormal];
            }
            NSLog(@"AdAliveViewStatusVideoAR_ReachedEnd");
            
        }break;
        //
        case AdAliveViewStatusVideoAR_Paused:{
            needRestartScanning =  NO;
            NSLog(@"AdAliveViewStatusVideoAR_Paused");
            
        }break;
        //
        case AdAliveViewStatusVideoAR_Stopped:
        {
            needRestartScanning = YES;
            [avPlayerView stopVideo];
            [self resumeAR];
            if (showVideoShareButton){
                [shareButton setEnabled:NO];
                [shareButton setTintColor:AppD.styleManager.colorPalette.backgroundNormal];
            }
            NSLog(@"AdAliveViewStatusVideoAR_Stopped");
            
        }break;
        //
        case AdAliveViewStatusVideoAR_Playing:{
            needRestartScanning =  NO;
            [self scanlineStop];
            if (showVideoShareButton){
                [shareButton setEnabled:YES];
                [shareButton setTintColor:AppD.styleManager.colorPalette.textNormal];
            }
            NSLog(@"AdAliveViewStatusVideoAR_Playing");
            
        }break;
        //
        case AdAliveViewStatusVideoAR_Ready:{
            needRestartScanning =  NO;
            [self scanlineStop];
            NSLog(@"AdAliveViewStatusVideoAR_Ready");
            
        }break;
        //
        case AdAliveViewStatusVideoAR_PlayingFullscreen:{
            needRestartScanning =  NO;
            [self scanlineStop];
            if (showVideoShareButton){
                [shareButton setEnabled:YES];
                [shareButton setTintColor:AppD.styleManager.colorPalette.textNormal];
            }
            NSLog(@"AdAliveViewStatusVideoAR_PlayingFullscreen");
            
        }break;
        //
        case AdAliveViewStatusVideoAR_NotReady:{
            needRestartScanning =  NO;
            NSLog(@"AdAliveViewStatusVideoAR_NotReady");
            
        }break;
        //
        case AdAliveViewStatusVideoAR_Error:{
            needRestartScanning = YES;
            [avPlayerView stopVideo];
            [self resumeAR];
            if (showVideoShareButton){
                [shareButton setEnabled:NO];
                [shareButton setTintColor:AppD.styleManager.colorPalette.backgroundNormal];
            }
            NSLog(@"AdAliveViewStatusVideoAR_Error");
            
        }break;
    }
    
    if (needRestartScanning && productDetailOpened == NO) {
        
        //Verificando se após um video tocar é necessário apresentar o resto das actions:
        AdAliveIdentifiedProduct *iProduct = [scannerTargetManager.productsFound objectForKey:self.lastTargetName];
        if (iProduct){
            NSArray *actions = [[NSArray alloc] initWithArray:[iProduct.productData valueForKey:@"actions"]];
            BOOL needContinueToProducts = NO;
            
            for (NSDictionary *dicAction in actions){
                NSString *type = [dicAction valueForKey:@"type"];
                if (![type isEqualToString:ACTION_VIDEO_AR] && ![type isEqualToString:ACTION_VIDEO_AR_TRANSP]){
                    needContinueToProducts = YES;
                    break;
                }
            }
            
            if (needContinueToProducts) {
                [self openProductsDetailWithData:iProduct.productData];
            }else{
                self.lastTargetName = nil;
                [self scanlineStart];
            }
        }else{
            self.lastTargetName = nil;
            [self scanlineStart];
        }
    }
}

-(BOOL)continuePlayingAfterLostImageTargetWithVideoPlayer:(AVPlayer *)player
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (player){
            [avPlayerView playVideoUsingExternalPlayer:player];
        }else{
            [avPlayerView stopVideo];
        }
    });
    //
    return YES;
}


#pragma mark - ButtonActionDelegate

-(void)clickedButtonWithData:(NSDictionary *)dicData
{
    NSLog(@"clickedButtonWithData: %@", dicData);
    
    //Interrompendo o scan:
    [self.eaglView stopVideoAR];
    [self scanlineStop];
    
    //Abrindo o link associado ao botão:
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"WebView" bundle:[NSBundle mainBundle]];
    VC_WebViewCustom *destViewController = [storyboard instantiateViewControllerWithIdentifier:@"WKWebViewVC"];
    destViewController.titleNav = [dicData valueForKey:@"label"];
    destViewController.fileURL = [dicData valueForKey:@"href"];
    destViewController.showShareButton = YES;
    destViewController.hideViewButtons = YES;
    destViewController.showAppMenu = NO;
    [destViewController awakeFromNib];
    //
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
    [self.navigationController pushViewController:destViewController animated:YES];
}

-(void)actionButtonsWillAppear
{
    if (avPlayerView){
        [avPlayerView setFrame:CGRectMake(5.0, 5.0, self.view.frame.size.width - 10.0, self.view.frame.size.height - 10.0 - 54.0)];
    }
}

-(void)actionButtonsWillDisappear
{
    if (avPlayerView){
        [avPlayerView setFrame:CGRectMake(5.0, 5.0, self.view.frame.size.width - 10.0, self.view.frame.size.height - 10.0)];
    }
}

#pragma mark - AdAliveDelegate

- (void)onInitARDone:(NSError *)error
{
    //Retorno do método init()
    //Ideal para remover uma tela de loading e tratamento de erros.
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        [self hideLoadingView];
        
        if (splashView){
            [splashView removeFromSuperview];
            splashView = nil;
        }
        
        if (error){
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") actionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_CONFIGURATION_ERROR", @"") subTitle:[error localizedDescription] closeButtonTitle:nil duration:0.0];
        }else{
            [self scanlineStart];
        }
    });
}

- (void)updateRenderingPrimitives
{
    [self.eaglView updateRenderingPrimitives];
}

#pragma mark - Webservice delegate

//The delegate method to receive server response with success
-(void)didReceiveResponse:(AdAliveWS *)adAliveWs withSuccess:(NSDictionary *)response
{
    NSLog(@"%@", response);
	
    [self hideLoadingView];
    
    NSArray *allKeys = [response allKeys];
    if ([allKeys containsObject:@"product"] && self.lastTargetName != nil)
    {
        [AppD.soundManager playSound:SoundMediaNameBeep withVolume:0.85];
        
        //=============================================================================================
        //O servidor retornou um product.
        //=============================================================================================
        
        //NOTE: Se o produto possuir uma action de VideoAR ou VideoARTransp, a exibição ocorre nesta mesma tela
        
        NSDictionary *proDic = [response valueForKey:@"product"];
        
        //-----------------------------------------
        AdAliveIdentifiedProduct *iProduct = [AdAliveIdentifiedProduct new];
        iProduct.targetID = [NSString stringWithFormat:@"%@", self.lastTargetName];
        iProduct.identificationDate = [ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_BARRA_LONGA_NORMAL];
        iProduct.productData = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:proDic withString:@" "];
        //
        [scannerTargetManager.productsFound setValue:iProduct forKey:self.lastTargetName];
        [scannerTargetManager saveIdentifiedProductsToUser:AppD.loggedUser.userID];
        //-----------------------------------------
        [scannedProductsCache setObject:response forKey:self.lastTargetName];
        //-----------------------------------------
        
        NSArray *actions = [[NSArray alloc] initWithArray:[proDic valueForKey:@"actions"]];
        
        BOOL needContinueToProducts = YES;
        
        ActionModel3D_AR *model3D = nil;
        
        for (NSDictionary *dicAction in actions){
            NSString *type = [dicAction valueForKey:@"type"];
            if ([type isEqualToString:ACTION_VIDEO_AR] || [type isEqualToString:ACTION_VIDEO_AR_TRANSP]){
                
                NSArray *allKeysAction = [dicAction allKeys];
                if ([allKeysAction containsObject:@"href"])
                {
                    videoURL = [dicAction objectForKey:@"href"];
                    
                    //proteção contra lista de botões nula:
                    NSArray *buttonsList = [NSArray new];
                    if ([allKeysAction containsObject:@"metadata"] && [[dicAction objectForKey:@"metadata"] isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicMetadata = [dicAction objectForKey:@"metadata"];
                        if ([[dicMetadata objectForKey:@"buttons"] isKindOfClass:[NSArray class]]){
                            buttonsList = [dicMetadata objectForKey:@"buttons"];
                        }
                    }
                    
                    BOOL isART = [type isEqualToString:ACTION_VIDEO_AR_TRANSP] ? YES : NO;
                    
                    //****************************************************************************************************************
                    //Controle de cache do vídeo:
                    //NOTE: (ericogt) Salvar o vídeo local depende do uso do app. Aplicações com poucos targets ou uso limitado do scan talvez nem precisem deste recurso ativado.
                    //****************************************************************************************************************
                    NSString *actionID = [NSString stringWithFormat:@"%li", [[dicAction valueForKey:@"id"] longValue]];
                    NSString *cachedVideoURL = [AppD.adAliveVideoCacheManager loadVideoURLforID:actionID andRemotelURL:videoURL];
                    
                    if (cachedVideoURL == nil){
                        [AppD.adAliveVideoCacheManager saveVideoWithID:actionID andRemoteURL:videoURL withCompletionHandler:^(BOOL success, NSString *localVideoURL, NSError *error) {
                            NSLog(@"AdAliveVideoCacheManager >> Save >> Success: %d", success);
                            NSLog(@"AdAliveVideoCacheManager >> Save >> LocalVideoURL: %@", localVideoURL);
                            NSLog(@"AdAliveVideoCacheManager >> Save >> Error: %@", [error localizedDescription]);
                        }];
                    }else{
                            videoURL = cachedVideoURL;
                            NSLog(@"AdAliveVideoCacheManager >> Usando cache video.");
                    }
                    //****************************************************************************************************************
                    
                    AdAliveVideoEffects *videoEffects = [self createDefaultVideoEffetcs];
                    if ([allKeysAction containsObject:@"video_ar_effects"]){
                        if ([[dicAction valueForKey:@"video_ar_effects"] isKindOfClass:[NSDictionary class]]){
                            NSDictionary *dicEffects = [dicAction valueForKey:@"video_ar_effects"];
                            videoEffects = [self createVideoEffectsWithDictionary:dicEffects];
                        }
                    }
                    
                    //validations:
                    videoEffects.isTransparentVideo = isART;
                    //confirmação de transparência
                    if (!videoEffects.isTransparentVideo){
                        videoEffects.useChromaKeyMask = NO;
                    }
                    //não permitir escala zero, nem negativa
                    if (videoEffects.scaleInTarget <= 0.0){
                        videoEffects.scaleInTarget = 1.0;
                    }
                    
                    //****************************************************************************************************************
                    
                    //Para carregar vídeos locais:
                    //videoUrl = [[NSBundle mainBundle] URLForResource:@"umbrella" withExtension:@"mov"].absoluteString;
                    
                    //****************************************************************************************************************
                    
                    [self.eaglView playARVideoWithURL:videoURL usingEffects:videoEffects andButtons:buttonsList];
                    
                    needContinueToProducts = NO;
                    //
                    [AppD logAdAliveActionWithID:[[dicAction valueForKey:@"id"] longValue]];
                    //
                    break;
                }
            
            }else{
                
                //****************************************************************************************************************
                //Controle para chamar o visualizador 3D
                //****************************************************************************************************************
                //if ([type isEqualToString:ACTION_MODEL_3D] && model3D == nil){
                //    NSArray *allKeysAction = [dicAction allKeys];
                //    if ([allKeysAction containsObject:@"action_model_3d"]){
                //        model3D = [ActionModel3D_AR createObjectFromDictionary:[dicAction valueForKey:@"action_model_3d"]];
                //        needContinueToProducts = NO;
                //    }
                //}
            }
        }
        
        if (needContinueToProducts){
            [self openProductsDetailWithData:[response objectForKey:@"product"]];
        }
        //else{
            //if (model3D.actionID != 0){
            //    [self show3DViewerForModel:model3D];
            //}
        //}
    
    }else{
        
        if ([allKeys containsObject:@"errors"]){
            
            suspendScanning = YES;
            
            NSString *message = nil;
            id errors = [response objectForKey:@"errors"];
            if ([errors isKindOfClass:[NSArray class]]){
                if ([[((NSArray*)errors) firstObject] isKindOfClass:[NSDictionary class]]){
                    NSDictionary *errorDic = [((NSArray*)errors) firstObject];
                    message = [errorDic valueForKey:@"message"];
                }
            }
            
            if (message){
                
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                    
                    [scannedProductsError setValue:errors forKey:self.lastTargetName];
                    //
                    self.lastTargetName = nil;
                    [self scanlineStart];
                    suspendScanning = NO;
                    
                }];
                [alert showError:@"Erro" subTitle:message closeButtonTitle:nil duration:0.0];
                
            }else{
                
                self.lastTargetName = nil;
                [self scanlineStart];
                
            }
            
        }else{
            
            self.lastTargetName = nil;
            [self scanlineStart];
            
        }
        
    }
   
}

//The delegate method to receive server response with error
-(void)didReceiveResponse:(AdAliveWS *)adaliveWS withError:(NSError *)error
{
    NSLog(@"%@", error);
    
    [scannedProductsError setValue:error forKey:self.lastTargetName];
    
    [self hideLoadingView];
    
    self.lastTargetName = nil;
    [self scanlineStart];
}

#pragma mark - • ProductViewControllerDelegate

- (void)registerProductAction:(NSDictionary*)dicAction
{
    if (dicAction){
        @try {
            //deep copy parameter:
            NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:dicAction];
            self.registeredProductAction = [[NSDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:dicData]];
        } @catch (NSException *exception) {
            NSLog(@"VC_CameraAdAlive >> registerProductAction >> Error >> %@", [exception reason]);
        }
    }
}

- (void)verifyRegisteredVideosURLs
{
    if (self.registeredProductAction != nil) {
        
        NSString *type = [self.registeredProductAction valueForKey:@"type"];
        if ([type isEqualToString:ACTION_VIDEO_AR] || [type isEqualToString:ACTION_VIDEO_AR_TRANSP]){
            
            NSArray *allKeysAction = [self.registeredProductAction allKeys];
            if ([allKeysAction containsObject:@"href"])
            {
                NSString *videoUrl = [self.registeredProductAction objectForKey:@"href"];
                
                //proteção contra lista de botões nula:
                NSArray *buttonsList = [NSArray new];
                if ([allKeysAction containsObject:@"metadata"] && [[self.registeredProductAction objectForKey:@"metadata"] isKindOfClass:[NSDictionary class]]){
                    NSDictionary *dicMetadata = [self.registeredProductAction objectForKey:@"metadata"];
                    if ([[dicMetadata objectForKey:@"buttons"] isKindOfClass:[NSArray class]]){
                        buttonsList = [dicMetadata objectForKey:@"buttons"];
                    }
                }
                
                BOOL isART = [type isEqualToString:ACTION_VIDEO_AR_TRANSP] ? YES : NO;
                
                //****************************************************************************************************************
                NSString *actionID = [NSString stringWithFormat:@"%li", [[self.registeredProductAction valueForKey:@"id"] longValue]];
                NSString *cachedVideoURL = [AppD.adAliveVideoCacheManager loadVideoURLforID:actionID andRemotelURL:videoUrl];
                
                if (cachedVideoURL){
                    videoUrl = cachedVideoURL;
                    NSLog(@"AdAliveVideoCacheManager >> Usando cache video.");
                }
                //****************************************************************************************************************
                
                AdAliveVideoEffects *videoEffects = [self createDefaultVideoEffetcs];
                if ([allKeysAction containsObject:@"video_ar_effects"]){
                    if ([[self.registeredProductAction valueForKey:@"video_ar_effects"] isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicEffects = [self.registeredProductAction valueForKey:@"video_ar_effects"];
                        videoEffects = [self createVideoEffectsWithDictionary:dicEffects];
                    }
                }
                
                //validations:
                videoEffects.isTransparentVideo = isART;
                //confirmação de transparência
                if (!videoEffects.isTransparentVideo){
                    videoEffects.useChromaKeyMask = NO;
                }
                //não permitir escala zero
                if (videoEffects.scaleInTarget == 0.0){
                    videoEffects.scaleInTarget = 1.0;
                }
                
                //****************************************************************************************************************

                [self.eaglView playARVideoWithURL:videoUrl usingEffects:videoEffects andButtons:buttonsList];
                
                [AppD logAdAliveActionWithID:[[self.registeredProductAction valueForKey:@"id"] longValue]];
            }
        }
        
    }else{
        [self scanlineStart];
    }
    
    self.lastTargetName = nil;
    self.registeredProductAction = nil;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    //
    [self.view layoutIfNeeded];
}

- (void)apllyPhotoEffect
{
    [AppD.soundManager playSound:SoundMediaNameCameraClick withVolume:0.85];
    //
    __block UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    blankView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:blankView];
    [self.view bringSubviewToFront:blankView];
    [UIView animateWithDuration:0.15 delay:0.10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        blankView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [blankView removeFromSuperview];
        blankView = nil;
    }];
}

/*
- (void)show3DViewerForModel:(ActionModel3D_AR*)model3D
{
    //TODO: mock do modelo animado
    //model3D.type = ActionModel3DViewerTypeAnimatedScene;
    
    switch (model3D.type) {
        case ActionModel3DViewerTypeScene:
        case ActionModel3DViewerTypeAnimatedScene:{
            
            [self.eaglView stopVideoAR];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Model3DViewers" bundle:nil];
            ActionModel3D_Scene_ViewerVC *vc = (ActionModel3D_Scene_ViewerVC *)[sb instantiateViewControllerWithIdentifier:@"ActionModel3D_Scene_ViewerVC"];
            vc.actionM3D = model3D;
            vc.animatedTransitions = NO;
            vc.backgroundPreviewImage = [self snapshotOpenGL];
            //
            productDetailOpened = YES;
            //
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:vc animated:NO];
            
        }break;
        //
        case ActionModel3DViewerTypeImageTarget:{
            
            [self.eaglView stopVideoAR];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Model3DViewers" bundle:nil];
            ActionModel3D_TargetImage_ViewerVC *vc = (ActionModel3D_TargetImage_ViewerVC *)[sb instantiateViewControllerWithIdentifier:@"ActionModel3D_TargetImage_ViewerVC"];
            vc.actionM3D = model3D;
            vc.animatedTransitions = NO;
            //
            productDetailOpened = YES;
            //
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:vc animated:NO];
            
        }break;
        //
        case ActionModel3DViewerTypeAR:{
            
            [self.eaglView stopVideoAR];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Model3DViewers" bundle:nil];
            ActionModel3D_AR_ViewerVC *vc = (ActionModel3D_AR_ViewerVC *)[sb instantiateViewControllerWithIdentifier:@"ActionModel3D_AR_ViewerVC"];
            vc.actionM3D = model3D;
            vc.animatedTransitions = NO;
            //
            productDetailOpened = YES;
            //
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:vc animated:NO];
            
        }break;
            //
        case ActionModel3DViewerTypePlaceableAR:{
            
            [self.eaglView stopVideoAR];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Model3DViewers" bundle:nil];
            ActionModel3D_PlaceableAR_ViewerVC *vc = (ActionModel3D_PlaceableAR_ViewerVC *)[sb instantiateViewControllerWithIdentifier:@"ActionModel3D_PlaceableAR_ViewerVC"];
            vc.actionM3D = model3D;
            vc.animatedTransitions = NO;
            //
            productDetailOpened = YES;
            //
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:vc animated:NO];
            
        }break;
            
        case ActionModel3DViewerTypeQuickLookAR:{
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Model3DViewers" bundle:nil];
            ActionModel3D_QuickLookAR_ViewerVC *vc = (ActionModel3D_QuickLookAR_ViewerVC *)[sb instantiateViewControllerWithIdentifier:@"ActionModel3D_QuickLookAR_ViewerVC"];
            vc.actionM3D = model3D;
            vc.animatedTransitions = NO;
            //
            vc.backgroundPreviewImage = [self snapshotOpenGL];
            //
            productDetailOpened = YES;
            //
            [self.eaglView stopVideoAR];
            //
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:vc animated:NO];
            
        }break;
            
    }
    
    [self hideLoadingView];
}
*/

//- (void)autofocus:(UITapGestureRecognizer *)sender
//{
//    [self performSelector:@selector(cameraPerformAutoFocus) withObject:nil afterDelay:.4];
//}

- (void)handleTapInEaglView:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        // handling code
        CGPoint touchPoint = [sender locationInView:self.eaglView];
        [self.eaglView handleTouchPoint:touchPoint];
    }
    
    [self.adAlive adjustAutoFocus];
}

//- (void)cameraPerformAutoFocus
//{
//    [self.adAlive adjustAutoFocus];
//}

- (void)openProductsDetailWithData:(NSDictionary*)pData
{
    [self showLoadingView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ANIMA_TIME_FAST * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductViewController *productController = (ProductViewController *)[sb instantiateViewControllerWithIdentifier:@"ProductViewController"];
        //
        productController.dicProductData = pData;
        productController.targetName = self.lastTargetName;
        productController.showBackButton = YES;
        productController.executeAutoLaunch = YES;
        productController.vcDelegate = self; //ericogt
        //
        productDetailOpened = YES;
        //
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:productController animated:YES];
        //
        [self.eaglView stopVideoAR];
        //
        [self scanlineStop];

    });
}

#pragma mark - Scanline

const int VIEW_SCAN_LINE_TAG = 999; //upside_down

- (void) scanlineCreate
{
    if (USE_SCANLINE_ANIMATION){
        UIImage *image = [UIImage imageNamed:@"adalive_arscanner_scanline_green.png"];
        CGFloat aspect = image.size.width / image.size.height;
        CGFloat newHeight = self.view.frame.size.width / aspect;
        //
        UIImageView *scanLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, newHeight)];
        scanLineView.tag = VIEW_SCAN_LINE_TAG;
        scanLineView.contentMode = UIViewContentModeScaleAspectFit;
        [scanLineView setImage:image];
        [scanLineView setHidden:YES];
        //
        [self.view addSubview:scanLineView];
    }
}

- (void) scanlineStart
{
    if (USE_SCANLINE_ANIMATION){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView * scanLineView = [self.view viewWithTag:VIEW_SCAN_LINE_TAG];
            if (scanLineView) {
                [scanLineView setHidden:NO];
                //
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
                animation.fromValue = @(0.0);
                animation.toValue = @(self.view.frame.size.height);
                animation.autoreverses = YES;
                animation.duration = 4.0;
                animation.repeatCount = HUGE_VAL;
                animation.removedOnCompletion = NO;
                animation.fillMode = kCAFillModeForwards;
                [scanLineView.layer addAnimation:animation forKey:@"position.y"];
            }
        });
    }
}

- (void) scanlineStop
{
    if (USE_SCANLINE_ANIMATION){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView * scanLineView = [self.view viewWithTag:VIEW_SCAN_LINE_TAG];
            if (scanLineView) {
                [scanLineView setHidden:YES];
                [scanLineView.layer removeAllAnimations];
            }
        });
    }
}

- (void)showLoadingView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showActivityIndicatorView];
        UIView * scanLineView = [self.view viewWithTag:VIEW_SCAN_LINE_TAG];
        if (scanLineView){
            scanLineView.alpha = 0.0;
        }
    });
}

- (void)hideLoadingView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideActivityIndicatorView];
        UIView * scanLineView = [self.view viewWithTag:VIEW_SCAN_LINE_TAG];
        if (scanLineView){
            scanLineView.alpha = 1.0;
        }
    });
}

#pragma mark -

- (AdAliveVideoEffects*)createDefaultVideoEffetcs
{
    AdAliveVideoEffects *videoEffects = [AdAliveVideoEffects new];
    
    //NOTE: somente modifique os parâmetros base para testes locais
//    videoEffects.isTransparentVideo = YES;      //NO
//    videoEffects.useChromaKeyMask = NO;         //NO
//    videoEffects.isPlayableFullscreen = YES;    //YES
//    videoEffects.muteOnStart = NO;              //NO
//    videoEffects.isDoubleSided = NO;            //NO
//    //
//    videoEffects.rotationX = 0.0f;              //0.0
//    videoEffects.rotationY = 0.0f;              //0.0
//    videoEffects.rotationZ = 0.0f;              //0.0
//    //
//    videoEffects.translationX = 0.0f;           //0.0
//    videoEffects.translationY = 0.0f;           //0.0
//    videoEffects.translationZ = 0.0f;           //0.0
//    //
//    videoEffects.scaleInTarget = 2.0f;          //1.0
    
    
    //efeito tampa notebook:
//    videoEffects.rotationX = 45.0f;
//    videoEffects.rotationY = 0.0f;
//    videoEffects.rotationZ = 0.0f;
//    //
//    videoEffects.translationX = 0.0f;
//    videoEffects.translationY = 0.8574f;
//    videoEffects.translationZ = 0.3518f;
//    //
//    videoEffects.scaleInTarget = 1.0f;
    
    
    return videoEffects;
}

- (AdAliveVideoEffects*)createVideoEffectsWithDictionary:(NSDictionary*)dicEffects
{
    AdAliveVideoEffects *videoEffects = [AdAliveVideoEffects new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicEffects withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        videoEffects.isTransparentVideo = [keysList containsObject:@"is_transparent"] ?  [[neoDic valueForKey:@"is_transparent"] boolValue] : videoEffects.isTransparentVideo;
        videoEffects.useChromaKeyMask = [keysList containsObject:@"use_chroma_key"] ?  [[neoDic valueForKey:@"use_chroma_key"] boolValue] : videoEffects.useChromaKeyMask;
        videoEffects.isPlayableFullscreen = [keysList containsObject:@"is_playable_fullscreen"] ?  [[neoDic valueForKey:@"is_playable_fullscreen"] boolValue] : videoEffects.isPlayableFullscreen;
        videoEffects.isDoubleSided = [keysList containsObject:@"is_double_sided"] ?  [[neoDic valueForKey:@"is_double_sided"] boolValue] : videoEffects.isDoubleSided;
        videoEffects.muteOnStart = [keysList containsObject:@"mute_on_start"] ?  [[neoDic valueForKey:@"mute_on_start"] boolValue] : videoEffects.muteOnStart;
        videoEffects.rotationX = [keysList containsObject:@"rotation_x"] ?  [[neoDic valueForKey:@"rotation_x"] floatValue] : videoEffects.rotationX;
        videoEffects.rotationY = [keysList containsObject:@"rotation_y"] ?  [[neoDic valueForKey:@"rotation_y"] floatValue] : videoEffects.rotationY;
        videoEffects.rotationZ = [keysList containsObject:@"rotation_z"] ?  [[neoDic valueForKey:@"rotation_z"] floatValue] : videoEffects.rotationZ;
        videoEffects.translationX = [keysList containsObject:@"translation_x"] ?  [[neoDic valueForKey:@"translation_x"] floatValue] : videoEffects.translationX;
        videoEffects.translationY = [keysList containsObject:@"translation_y"] ?  [[neoDic valueForKey:@"translation_y"] floatValue] : videoEffects.translationY;
        videoEffects.translationZ = [keysList containsObject:@"translation_z"] ?  [[neoDic valueForKey:@"translation_z"] floatValue] : videoEffects.translationZ;
        videoEffects.scaleInTarget = [keysList containsObject:@"scale_in_target"] ?  [[neoDic valueForKey:@"scale_in_target"] floatValue] : videoEffects.scaleInTarget;
    }
    
    return videoEffects;
}

@end

