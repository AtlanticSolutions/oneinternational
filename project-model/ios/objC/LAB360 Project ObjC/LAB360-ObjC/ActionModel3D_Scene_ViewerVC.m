//
//  ActionModel3D_Scene_ViewerVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 28/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <ModelIO/ModelIO.h>
#import <SceneKit/SceneKit.h>
#import <SceneKit/ModelIO.h>
#import <SpriteKit/SpriteKit.h>
#import <ARKit/ARKit.h>
//
#import "ActionModel3D_Scene_ViewerVC.h"
#import "AppDelegate.h"
#import "ToolBox.h"
#import "UIImage+animatedGIF.h"
#import "VirtualObjectProperties.h"
#import "AsyncImageDownloader.h"
#import "InternetConnectionManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "SSZipArchive.h"
#import "ActionModel3D_AR_DataManager.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface ActionModel3D_Scene_ViewerVC ()<UIGestureRecognizerDelegate, InternetConnectionManagerDelegate, AVAudioPlayerDelegate, CAAnimationDelegate>

//Data: ========================================================
@property (nonatomic, assign) CGFloat lastScale;
@property(nonatomic, assign) ObjectBoxSize objectBoxSize;
@property (nonatomic, strong) NSString *modelErrorMessage;
@property (nonatomic, assign) SCNVector3 lastPosition;
//
@property (nonatomic, assign) CGFloat lastAngleX;
@property (nonatomic, assign) CGFloat lastAngleY;
@property (nonatomic, assign) CGFloat lastAngleZ;
//
@property (nonatomic, strong) SCNScene *currentScene;
@property (nonatomic, strong) SCNNode *modelNode;
@property (nonatomic, strong) SCNNode *cameraNode;
@property (nonatomic, strong) NSURL *modelURL;
//
@property (nonatomic, strong) NSArray *enviromentScenesList;
//
@property (nonatomic, strong) ActionModel3D_AR_DataManager *modelManager;
//
@property (nonatomic, strong) NSMutableDictionary *modelAnimations;
@property (nonatomic, assign) BOOL modelIdle;

//Camera
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *capturePreviewLayer;
@property (nonatomic, strong) NSOperationQueue *captureQueue;
@property (nonatomic, assign) UIImageOrientation imageOrientation;
@property (assign, nonatomic) AVCaptureTorchMode torchMode;

//Sound
@property (nonatomic, strong) AVAudioPlayer* audioPlayer;

//Layout: ========================================================
@property (nonatomic, weak) IBOutlet UIImageView *imvBackground;
@property (nonatomic, strong) UIImageView *imvAnimatedBackground;
@property (nonatomic, weak) IBOutlet SCNView *sceneView;
//
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UILabel *lblMessage;

//Camera
@property (nonatomic, strong) UIButton *btnTorchMode;

@end

#pragma mark - • IMPLEMENTATION
@implementation ActionModel3D_Scene_ViewerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize actionM3D, backgroundPreviewImage, modelManager;
@synthesize audioPlayer;
@synthesize lastScale, objectBoxSize, modelErrorMessage, lastPosition, lastAngleX, lastAngleY, lastAngleZ, currentScene, modelNode, cameraNode, modelURL, enviromentScenesList, modelAnimations, modelIdle;
@synthesize session, capturePreviewLayer, captureQueue, imageOrientation, torchMode;
@synthesize imvBackground, imvAnimatedBackground, sceneView, footerView, lblMessage, btnTorchMode;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commomInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commomInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commomInit];
    }
    return self;
}

- (void)commomInit
{
    enviromentScenesList = nil;
    modelURL = nil;
    modelErrorMessage = nil;
    //
    lastAngleX = 0.0;
    lastAngleY = 0.0;
    lastAngleZ = 0.0;
    lastScale = 1.0;
    //
    modelAnimations = [NSMutableDictionary new];
    modelIdle = YES;
}

#pragma mark - • DEALLOC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Initialise the capture queue
    self.captureQueue = [NSOperationQueue new];
    
    modelManager = [ActionModel3D_AR_DataManager sharedInstance];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(actionReturn:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self.view layoutIfNeeded];
    
    if (sceneView.scene == nil){
        
        if (self.actionM3D == nil || (self.actionM3D.type != ActionModel3DViewerTypeScene && self.actionM3D.type != ActionModel3DViewerTypeAnimatedScene)){
            [self.navigationController popViewControllerAnimated:self.animatedTransitions];
        }else{
            
            [self setupLayout:actionM3D.screenSet.screenTitle];
            
            //Cache control and data aquisition:
            [self loadActionContent];
        }
    }
    
    //NOTE: Aqui busca-se pelo gesto de rotação para que, se necessário, o mesmo possa ser bloqueado no futuro:
    for (UIGestureRecognizer *gr in sceneView.gestureRecognizers){
        if ([gr isKindOfClass:[UIRotationGestureRecognizer class]]){
            gr.delegate = self;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController])
    {
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
        [self.view layoutIfNeeded];
        //
        [self destroyCompleteScene];
        [self.session stopRunning];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionReturn:(id)sender
{
    [self.navigationController popViewControllerAnimated:self.animatedTransitions];
}

- (IBAction)actionShare:(id)sender
{
    if (actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleFrontCamera || actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleBackCamera){
        
        [self takePhoto:(UIBarButtonItem*)sender];
        
    }else{
        
        UIImage *background = [self imageWithView:imvBackground];
        //
        [self apllyPhotoEffect];
        //
        [self prepareAndShareModel3DPrintWithBackground:background];
        
    }
}

- (void)apllyPhotoEffect
{
    [AppD.soundManager playSound:SoundMediaNameCameraClick withVolume:0.85];
    //
    __block UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, sceneView.frame.size.width, sceneView.frame.size.height)];
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

- (IBAction)actionGestureTwoFingerPan:(UIPanGestureRecognizer*)gesture
{
    //if (translateAllowed){
    
    if (gesture.state == UIGestureRecognizerStateBegan){
        
        lastPosition = modelNode.position;
        
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        
        //NOTE: para saber mais sobre a translação visite https://stackoverflow.com/questions/27346757/scenekit-pan-2d-translation-to-orthographic-3d-only-horizontal .;
        
        CGPoint translation = [gesture translationInView:sceneView];
        
        CGPoint location = [gesture locationInView:sceneView];
        
        CGPoint secLocation = CGPointMake(translation.x + location.x, translation.y + location.y);
        
        SCNVector3 P1 = [sceneView unprojectPoint:SCNVector3Make(location.x, location.y, 0.0)];
        SCNVector3 P2 = [sceneView unprojectPoint:SCNVector3Make(location.x, location.y, 1.0)];
        
        SCNVector3 Q1 = [sceneView unprojectPoint:SCNVector3Make(secLocation.x, secLocation.y, 0.0)];
        SCNVector3 Q2 = [sceneView unprojectPoint:SCNVector3Make(secLocation.x, secLocation.y, 1.0)];
        
        CGFloat t1 = -P1.z / (P2.z - P1.z);
        CGFloat t2 = -Q1.z / (Q2.z - Q1.z);
        
        CGFloat x1 = P1.x + (t1 * (P2.x - P1.x));
        CGFloat y1 = P1.y + (t1 * (P2.y - P1.y));
        
        SCNVector3 P0 = SCNVector3Make(x1, y1, 0.0);
        
        CGFloat x2 = Q1.x + (t2 * (Q2.x - Q1.x));
        CGFloat y2 = Q1.y + (t2 * (Q2.y - Q1.y));
        
        SCNVector3 Q0 = SCNVector3Make(x2, y2, 0.0);
        
        SCNVector3 diffR = SCNVector3Make(Q0.x - P0.x, Q0.y - P0.y, Q0.z - P0.z);
        //diffR = SCNVector3Make(diffR.x * -1, diffR.y * -1, diffR.z * -1);
        
        modelNode.position = SCNVector3Make(lastPosition.x + diffR.x, lastPosition.y + diffR.y, lastPosition.z + diffR.z);
    }
    //}
}

- (IBAction)actionGestureDoubleTap:(UITapGestureRecognizer*)gesture
{
    //Rotation
    lastAngleX = modelNode.eulerAngles.x;
    lastAngleY = modelNode.eulerAngles.y;
    lastAngleZ = modelNode.eulerAngles.z;
    
    switch (actionM3D.sceneSet.rotationMode) {
        case ActionModel3DViewerSceneRotationModeNone:{
            return;
        }break;
            
        case ActionModel3DViewerSceneRotationModeFree:{
            lastAngleX = 0.0;
            lastAngleY = 0.0;
            lastAngleZ = 0.0;
        }break;
            
        case ActionModel3DViewerSceneRotationModeYAxis:{
             lastAngleY = 0.0;
        }break;
            
        case ActionModel3DViewerSceneRotationModeXAxis:{
            lastAngleX = 0.0;
        }break;
            
        case ActionModel3DViewerSceneRotationModeLimited:{
            lastAngleX = 0.0;
            lastAngleY = 0.0;
            lastAngleZ = 0.0;
        }break;
    }
    
    [modelNode setEulerAngles:SCNVector3Make(lastAngleX, lastAngleY, lastAngleZ)];
    
    //Translation
    modelNode.position = SCNVector3Make(0.0, 0.0, 0.0);
    lastPosition = SCNVector3Make(0.0, 0.0, 0.0);
    
    //Scale
    modelNode.scale = SCNVector3Make(1.0, 1.0, 1.0);
    lastScale = 1.0;
}

- (IBAction)actionGestureSingleTap:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded){
        
        CGPoint tapPoint = [gesture locationInView:sceneView];
        
        NSMutableDictionary *options = [NSMutableDictionary new];
        [options setValue:@(YES) forKey:SCNHitTestBoundingBoxOnlyKey];
        [options setValue:@(YES) forKey:SCNHitTestIgnoreHiddenNodesKey];
        [options setValue:@(SCNHitTestSearchModeAll) forKey:SCNHitTestOptionSearchMode];
        
        NSArray <SCNHitTestResult *> *result = [sceneView hitTest:tapPoint options:options];
        
        if (result.count > 0){
            if (modelIdle){
                [self playAnimationFromSceneView];
            }else{
                [self stopAnimationFromSceneView];
            }
            modelIdle = !modelIdle;
        }else{
            
            if (self.navigationController.navigationBar.isHidden){
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                //
                [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
                    [footerView setAlpha:1.0];
                }];
            }else{
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                //
                [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
                    [footerView setAlpha:0.0];
                }];
            }
            
        }
        
    }
}

- (IBAction)actionGesturePan:(UIPanGestureRecognizer*)gesture
{
    switch (actionM3D.sceneSet.rotationMode) {
        case ActionModel3DViewerSceneRotationModeNone:{
            return;
        }break;
            
        case ActionModel3DViewerSceneRotationModeFree:{
            return;
        }break;
            
        case ActionModel3DViewerSceneRotationModeYAxis:{
            
            CGPoint translation = [gesture translationInView:sceneView];
            CGFloat newAngle = translation.x * (M_PI / 180.0);
            newAngle += lastAngleY;
            //
            [modelNode setEulerAngles:SCNVector3Make(modelNode.eulerAngles.x, newAngle, modelNode.eulerAngles.z)];
            
            if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
                lastAngleY = newAngle;
            }
            
        }break;
            
        case ActionModel3DViewerSceneRotationModeXAxis:{
            
            CGPoint translation = [gesture translationInView:sceneView];
            CGFloat newAngle = translation.y * (M_PI / 180.0);
            newAngle += lastAngleX;
            //
            [modelNode setEulerAngles:SCNVector3Make(newAngle, modelNode.eulerAngles.y, modelNode.eulerAngles.z)];
            
            if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
                lastAngleX = newAngle;
            }
            
        }break;
            
        case ActionModel3DViewerSceneRotationModeLimited:{
            return;
        }break;
    }
}

- (IBAction)actionTorch:(id)sender
{
    //AUTO >> NO >> OFF
    
    if([self currentDevice].hasTorch){
        if (self.torchMode == AVCaptureTorchModeAuto){
            self.torchMode = AVCaptureTorchModeOn;
        }else if (self.torchMode == AVCaptureTorchModeOn){
            self.torchMode = AVCaptureTorchModeOff;
        }else{
            self.torchMode = AVCaptureTorchModeAuto;
        }
    }
    
    [self updateFlashlightState];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag){
        if (!modelIdle){
            for (NSString *key in [self.modelAnimations allKeys]){
                CAAnimation *animation = [modelAnimations objectForKey:key];
                if (animation == anim){
                    modelIdle = YES;
                    break;
                }
            }
        }
    }
}

#pragma mark - InternetConnectionManagerDelegate

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithSuccess:(id _Nullable)responseObject
{
    NSLog(@"didConnectWithSuccess");
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithFailure:(NSError * _Nullable)error
{
    [self showProcessError:[error localizedDescription]];
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithSuccessData:(id _Nullable)responseObject
{
    [AppD showLoadingAnimationWithType:eActivityIndicatorType_Processing];
    [AppD updateLoadingAnimationMessage:@""];
    //
    [self processDataForOBJ:(NSData*)responseObject];
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager downloadProgress:(float)dProgress
{
    dProgress = dProgress < 0.0 ? 0.0 : (dProgress > 1.0 ? 1.0 : dProgress);
    [AppD updateLoadingAnimationMessage:[NSString stringWithFormat:@"%.1f %%", (dProgress * 100.0)]];
}

#pragma mark -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (actionM3D.sceneSet.rotationMode == ActionModel3DViewerSceneRotationModeFree){
        return YES;
    }else{
        if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]){
            return NO;
        }
        return YES;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
//    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
//        return NO;
//    }
//    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]){
//        return NO;
//    }
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]){
//        return NO;
//    }
//    //
//    if ([otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
//        return NO;
//    }
//    if ([otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]){
//        return NO;
//    }
//    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]){
//        return NO;
//    }
    
    return YES;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:[UIColor colorWithWhite:0.0 alpha:0.75]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.view layoutIfNeeded];
    
    //Footer
    footerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    [footerView setClipsToBounds:YES];
    //
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textColor = [UIColor whiteColor];
    lblMessage.text = @"";
    [lblMessage setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    
    [imvBackground setContentMode:UIViewContentModeScaleAspectFill];
    
    if (actionM3D.sceneSet.backgroundColor){
        imvBackground.backgroundColor = actionM3D.sceneSet.backgroundColor;
    }else{
        imvBackground.backgroundColor = [UIColor clearColor];
    }
    
    if (actionM3D.sceneSet.backgroundImage){
        imvBackground.image = actionM3D.sceneSet.backgroundImage;
    }else{
        imvBackground.image = nil;
    }
    
    sceneView.backgroundColor = [UIColor clearColor];
    
    btnTorchMode.backgroundColor = [UIColor clearColor];
    btnTorchMode = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTorchMode.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnTorchMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
    [btnTorchMode addTarget:self action:@selector(actionTorch:) forControlEvents:UIControlEventTouchUpInside];
    [btnTorchMode setFrame:CGRectMake(0, 0, 36, 36)];
    [btnTorchMode setExclusiveTouch:YES];
    
    [self.view layoutIfNeeded];
}

- (void)showProcessError:(NSString*)errorMessage
{
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD hideLoadingAnimation];
    });
    //
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
        [self.navigationController popViewControllerAnimated:self.animatedTransitions];
    }];
    [alert showError:@"Erro" subTitle:errorMessage closeButtonTitle:nil duration:0.0];
}

- (void)communicateError:(NSString*)errorMessage
{
    modelErrorMessage = errorMessage;
}

#pragma mark -

- (void)didRecieveWillResignActiveNotification:(NSNotification*)notification
{
    if (self.actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleBackCamera || self.actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleFrontCamera){
        [btnTorchMode setHidden:YES];
        [self.session stopRunning];
        [self.capturePreviewLayer removeFromSuperlayer];
        self.session = nil;
        [self.captureQueue cancelAllOperations];
        self.captureQueue = nil;
    }
    //
    [self pauseCompleteScene];
}

- (void)didRecieveDidBecomeActiveNotification:(NSNotification*)notification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleBackCamera || self.actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleFrontCamera){
            self.torchMode = AVCaptureTorchModeAuto;
            self.captureQueue = [NSOperationQueue new];
            [self enableCapture];
        }
        //
        [self playCompleteScene];
    });
}

#pragma mark - Scene Configuration

- (void)configureScene
{
    BOOL saved = [modelManager saveActionModel3D:actionM3D];
    NSLog(@"configureScene >> saveActionModel3D >> %@", (saved ? @"YES" : @"NO"));
    
    [self loadSceneData];
    
    if (sceneView.scene == nil){
        
        if (modelErrorMessage != nil){
            
            [self showProcessError:[NSString stringWithFormat:@"O visualizador 3D comunicou o seguinte erro:\n%@", modelErrorMessage]];
            
        }else{
            
            [self showProcessError:NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_EMPTY_OBJ", @"")];
            
        }
        
    }else{
        
        //Show Navigation Item Buttons
        NSMutableArray *buttons = [NSMutableArray new];
        
        if (actionM3D.screenSet.showPhotoButton){
            UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(actionShare:)];
            [buttons addObject:shareButton];
        }
        
        if (actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleBackCamera || actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleFrontCamera){
            UIBarButtonItem *shareFlash = [[UIBarButtonItem alloc] initWithCustomView:btnTorchMode];
            [buttons addObject:shareFlash];
            //
            [self enableCapture];
        }
        
        if (buttons.count > 0){
            self.navigationItem.rightBarButtonItems = buttons;
        }
        
        switch (actionM3D.sceneSet.rotationMode) {
            case ActionModel3DViewerSceneRotationModeNone:{
                lblMessage.text = @"";
            }break;
            case ActionModel3DViewerSceneRotationModeFree:{
                lblMessage.text = @"Mova, rotacione e amplie o objeto livremente para ter uma melhor visualização.";
            }break;
            case ActionModel3DViewerSceneRotationModeYAxis:{
                lblMessage.text = @"Rotacione o objeto horizontalmente.";
            }break;
            case ActionModel3DViewerSceneRotationModeXAxis:{
                lblMessage.text = @"Rotacione o objeto verticalmente.";
            }break;
            case ActionModel3DViewerSceneRotationModeLimited:{
                lblMessage.text = @"O rotação do objeto foi limitada horizontalmente e verticalmente.";
            }break;
        }
        
        [self playCompleteScene];
        
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD hideLoadingAnimation];
    });
}
    
- (void)loadSceneData
{
    //Carregamento do modelo 3D:
    
    if (actionM3D.type == ActionModel3DViewerTypeAnimatedScene){
        
        [self loadSceneForFileTypeSCN];
        
    }else if (actionM3D.type == ActionModel3DViewerTypeScene){
        
        [self loadSceneForFileTypeOBJ];
        
    }else{
        
        [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_FILETYPE_ERROR", @"")];
        return;
        
    }
}

- (void)loadSceneForFileTypeOBJ
{
    //Carregando o objeto ***********************************************************************************************************************
    
    NSURL *url = [NSURL URLWithString:actionM3D.objSet.objLocalURL];
    
    if (url == nil){
        [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_LOAD_ERROR", @"")];
        return;
    }
    
    NSDictionary *materialPropertiesDic = [VirtualObjectProperties loadMaterialPropertiesInfoForFile:url];
    
    for (NSString *key in [materialPropertiesDic allKeys]){
        VirtualObjectProperties *vop = [materialPropertiesDic objectForKey:key];
        if (vop.invalidMapAssetDetected){
            [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_INVALID_TEXTURE_MAP", @"")];
            return;
        }
    }

    MDLAsset *asset = [[MDLAsset alloc] initWithURL:url];
    
    if (asset == nil){
        [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_INVALID_ASSET", @"")];
        return;
    }
    
    if (asset.count == 0){
        [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_NO_MESH", @"")];
        return;
    }else{
        if (![[asset objectAtIndex:0] isKindOfClass:[MDLMesh class]]){
            [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_INVALID_MESH", @"")];
            return;
        }
    }
    
    MDLMesh *object = (MDLMesh*)[asset objectAtIndex:0];
    
    //Reset ***********************************************************************************************************************
    if (currentScene){
        for (SCNNode *n in currentScene.rootNode.childNodes){
            [n removeFromParentNode];
        }
        currentScene = nil;
    }
    sceneView.scene = nil;
    sceneView.autoenablesDefaultLighting = NO;
    
    //Object Node ***********************************************************************************************************************
    modelNode = [SCNNode nodeWithMDLObject:object];
    
    //    NSDictionary *materialPropertiesDic = [VirtualObjectProperties loadMaterialPropertiesInfoForFile:modelURL];
    
    for (SCNMaterial *material in modelNode.geometry.materials){
        
        //[material setLightingModelName:SCNLightingModelPhong];
        //[material setLocksAmbientWithDiffuse:NO];
        
        VirtualObjectProperties *vop = nil;
        if ([[materialPropertiesDic allKeys] containsObject:material.name]){
            vop = [materialPropertiesDic objectForKey:material.name];
        }
        
        if (vop.reflectionMap){
            
            if (actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleEnviroment){
                material.reflective.contents = actionM3D.sceneSet.backgroundImage;
            }else{
                UIImage *refl = [UIImage imageWithData:[NSData dataWithContentsOfURL:vop.imageRef]];
                material.reflective.contents = refl;
            }
            
        }
        
        if (vop.transparencyMap){
            [material setWritesToDepthBuffer:NO];
            //
            if ([material.transparent.contents isKindOfClass:[NSString class]]){
                if ([[material.transparent.contents uppercaseString] hasSuffix:@".PNG"]){
                    [material setTransparencyMode:SCNTransparencyModeAOne];
                }else{
                    [material setTransparencyMode:SCNTransparencyModeRGBZero];
                }
            }else{
                [material setTransparency:vop.transparencyValue];
            }
        }else{
            [material setWritesToDepthBuffer:YES];
        }
        
        [material setDoubleSided:NO];
        
        //Removendo a emissão (auto iluminação) do objeto, vinda do arquivo mtl. Apenas o iOS12 carrega essa propriedade, portanto é condicional.
        if (!actionM3D.objSet.enableMaterialAutoIllumination){
            if (@available(iOS 12.0, *)) {
                material.emission.contents = [UIColor blackColor];
            }
        }
        
    }
    modelNode.castsShadow = YES;
    
    //Current Scene ***********************************************************************************************************************
    currentScene = [SCNScene new];
    [currentScene.rootNode addChildNode:modelNode];
    
    if (actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleEnviroment){
        currentScene.background.contents = actionM3D.sceneSet.backgroundImage;
    }
    
    //Background:
    if (actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleImage){
        imvBackground.image = actionM3D.sceneSet.backgroundImage;
    }
    imvBackground.backgroundColor = actionM3D.sceneSet.backgroundColor;
    
    //Scene Lights ***********************************************************************************************************************
    
    [self createDefaultSceneLightsWithScene:currentScene];
    
    //Initial Parameters ***********************************************************************************************************************
    
    [SCNTransaction begin];
    
    //pivot
    //[modelNode setPivot:SCNMatrix4MakeTranslation(0.5, 0.5, 0.5)];
    
    //translation
    [modelNode setPosition:SCNVector3Make(actionM3D.objSet.modelTranslationX, actionM3D.objSet.modelTranslationY, actionM3D.objSet.modelTranslationZ)];
    lastPosition = modelNode.position;
    
    //rotation
    [modelNode setEulerAngles:SCNVector3Make(actionM3D.objSet.modelRotationX, actionM3D.objSet.modelRotationY, actionM3D.objSet.modelRotationZ)];
    lastAngleX = actionM3D.objSet.modelRotationX;
    lastAngleY = actionM3D.objSet.modelRotationY;
    lastAngleZ = actionM3D.objSet.modelRotationZ;
    
    //scale
    [modelNode setScale:SCNVector3Make(actionM3D.objSet.modelScale, actionM3D.objSet.modelScale, actionM3D.objSet.modelScale)];
    lastScale = actionM3D.objSet.modelScale;
    
    [SCNTransaction commit];
    
    //Scene Creation ***********************************************************************************************************************
    [currentScene setPaused:YES];
    sceneView.scene = currentScene;
    
    //Movement ***********************************************************************************************************************
    
    if (actionM3D.sceneSet.rotationMode == ActionModel3DViewerSceneRotationModeFree){
        
        //Habilita os gestos padrões permitidos pela classe SCNView.
        sceneView.allowsCameraControl = YES;
        
    }else if (actionM3D.sceneSet.rotationMode == ActionModel3DViewerSceneRotationModeLimited){
        
        //Habilita os gestos padrões, adicionando limitadores angulares.
        sceneView.allowsCameraControl = YES;
        //
        if (@available(iOS 11.0, *)) {
            sceneView.defaultCameraController.maximumHorizontalAngle = actionM3D.sceneSet.maximumHorizontalAngle; //180
            sceneView.defaultCameraController.minimumHorizontalAngle = actionM3D.sceneSet.minimumHorizontalAngle; //-180
            //
            sceneView.defaultCameraController.maximumVerticalAngle = actionM3D.sceneSet.maximumVerticalAngle; //90
            sceneView.defaultCameraController.minimumVerticalAngle = actionM3D.sceneSet.minimumVerticalAngle; //-90
        }
        
    }else if (actionM3D.sceneSet.rotationMode == ActionModel3DViewerSceneRotationModeXAxis || actionM3D.sceneSet.rotationMode == ActionModel3DViewerSceneRotationModeYAxis){
        
        for (UIGestureRecognizer *gesture in sceneView.gestureRecognizers){
            [sceneView removeGestureRecognizer:gesture];
        }
        
        sceneView.allowsCameraControl = NO;
        
        // MOVE - Handle two-finger pans
        UIPanGestureRecognizer *twoPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionGestureTwoFingerPan:)];
        twoPan.minimumNumberOfTouches = 2;
        twoPan.maximumNumberOfTouches = 2;
        twoPan.delegate = self;
        [sceneView addGestureRecognizer:twoPan];
        
        // ZOOM - Handle pinches
        //UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(actionGesturePinch:)];
        //pinch.delegate = self;
        //[sceneView addGestureRecognizer:pinch];
        
        // PARTIAL ROTATION - Handle Single Pan
        UIPanGestureRecognizer *singlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionGesturePan:)];
        singlePan.minimumNumberOfTouches = 1;
        singlePan.maximumNumberOfTouches = 1;
        singlePan.delegate = self;
        [sceneView addGestureRecognizer:singlePan];
        
        // RESTORE POSITION - Handle Double Tap
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionGestureDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        doubleTap.delegate = self;
        [sceneView addGestureRecognizer:doubleTap];
    }
    
    //Camera ***********************************************************************************************************************
    
    SCNCamera *camera = [SCNCamera new];
    [camera setZNear: 0.01];
    [camera setZFar: 1000.0];
    //
    if (@available(iOS 10.0, *)) {
        
        switch (actionM3D.sceneSet.HDRState) {
            case ActionModel3DViewerSceneHDRStateOFF:{
                [camera setWantsHDR:NO];
                [camera setWantsExposureAdaptation:NO];
            }break;
                
            case ActionModel3DViewerSceneHDRStateON:{
                [camera setWantsHDR:YES];
                [camera setWantsExposureAdaptation:NO];
            }break;
                
            case ActionModel3DViewerSceneHDRStateExposureAdaptation:{
                [camera setWantsHDR:YES];
                [camera setWantsExposureAdaptation:YES];
            }break;
        }

    }
    //
    cameraNode = [SCNNode new];
    cameraNode.camera = camera;
    //
    objectBoxSize = [VirtualObjectProperties boxSizeForObject:modelNode];
    if (objectBoxSize.H == 0.0){
        cameraNode.position = SCNVector3Make(0, 0, 1);
    }else{
        //A camera é posicionada numa distância 2 vezes maior que o maior lado do objeto, na altura equivalente ao centro de sua altura:
        cameraNode.position = SCNVector3Make(0, (objectBoxSize.H / 2.0), (MAX(objectBoxSize.W,MAX(objectBoxSize.H, objectBoxSize.L))) * 2.0);
    }
    [sceneView.scene.rootNode addChildNode:cameraNode];
    
    [sceneView setPointOfView:cameraNode];
    
    //Qualidade da cena (O HDR pode ser ligado em outro momento).
    if (@available(iOS 10.0, *)) {
        [cameraNode.camera setWantsHDR:NO];
        [cameraNode.camera setWantsExposureAdaptation:NO];
    }
    
    //NOTA: Neste visualizador o AR não é utilizado, no entando, através da classe é possível determinar se o device suporta configurações mais avançadas (jittering e antialising).
    if (@available(iOS 11.0, *)) {
        if (ARWorldTrackingConfiguration.isSupported) {
            
            sceneView.jitteringEnabled = YES;
            
            switch (actionM3D.sceneSet.sceneQuality) {
                case ActionModel3DViewerSceneQualityAuto:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeMultisampling2X];
                }break;
                    
                case ActionModel3DViewerSceneQualityLow:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeNone];
                }break;
                    
                case ActionModel3DViewerSceneQualityMedium:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeMultisampling2X];
                }break;
                    
                case ActionModel3DViewerSceneQualityHigh:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeMultisampling2X];
                }break;
                    
                case ActionModel3DViewerSceneQualityUltra:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeMultisampling4X];
                }break;
            }
            
        }
    }
    
}

- (void)loadSceneForFileTypeSCN
{
    //Carregando o objeto ***********************************************************************************************************************
    
    NSString *model1 = nil;
    NSArray *models = [actionM3D.objSet.objLocalURL componentsSeparatedByString:@" ; "];
    for (NSString *m in models){
        if ([m hasSuffix:@"model1.scn"]){
            model1 = m;
            break;
        }
    }
    
    NSURL *url = [NSURL fileURLWithPath:model1];
    
    if (url == nil){
        [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_LOAD_ERROR", @"")];
        return;
    }
    
    //Reset ***********************************************************************************************************************
    if (currentScene){
        for (SCNNode *n in currentScene.rootNode.childNodes){
            [n removeFromParentNode];
        }
        currentScene = nil;
    }
    sceneView.scene = nil;
    sceneView.autoenablesDefaultLighting = NO;
    
    //Current Scene ***********************************************************************************************************************
    NSError *loadError;
    currentScene = [SCNScene new];
    
    NSMutableDictionary *sceneOptions = [NSMutableDictionary new];
    //SCNSceneSourceAnimationImportPolicyKey
    [sceneOptions setValue:SCNSceneSourceAnimationImportPolicyPlayUsingSceneTimeBase forKey:SCNSceneSourceAnimationImportPolicyKey];
    //SCNSceneSourceAssetDirectoryURLsKey
    [sceneOptions setValue:[NSArray new] forKey:SCNSceneSourceAssetDirectoryURLsKey];
    //SCNSceneSourceCheckConsistencyKey
    [sceneOptions setValue:@(NO) forKey:SCNSceneSourceCheckConsistencyKey];
    //SCNSceneSourceConvertToYUpKey
    [sceneOptions setValue:@(NO) forKey:SCNSceneSourceConvertToYUpKey];
    //SCNSceneSourceConvertUnitsToMetersKey
    [sceneOptions setValue:[NSNull null] forKey:SCNSceneSourceConvertUnitsToMetersKey];
    //SCNSceneSourceCreateNormalsIfAbsentKey
    [sceneOptions setValue:@(YES) forKey:SCNSceneSourceCreateNormalsIfAbsentKey];
    //SCNSceneSourceFlattenSceneKey
    [sceneOptions setValue:@(NO) forKey:SCNSceneSourceFlattenSceneKey];
    //SCNSceneSourceOverrideAssetURLsKey
    [sceneOptions setValue:@(NO) forKey:SCNSceneSourceOverrideAssetURLsKey];
    //SCNSceneSourceLoadingOptionPreserveOriginalTopology
    [sceneOptions setValue:@(YES) forKey:SCNSceneSourceLoadingOptionPreserveOriginalTopology];
    //SCNSceneSourceStrictConformanceKey
    [sceneOptions setValue:@(YES) forKey:SCNSceneSourceStrictConformanceKey];
    
    SCNScene *tempScene = [SCNScene sceneWithURL:url options:sceneOptions error:&loadError];
    
    if (loadError){
        [self communicateError: [loadError localizedDescription]];
        return;
    }
    
    //Object Node ***********************************************************************************************************************
    modelNode = [SCNNode new];
    
    // Add all the child nodes to the parent node
    for (SCNNode *child in tempScene.rootNode.childNodes) {
        [modelNode addChildNode:child];
    }
    
    modelNode.castsShadow = YES;
    
    [currentScene.rootNode addChildNode:modelNode];
    [currentScene setPaused:YES];
    sceneView.scene = currentScene;
    
    if (actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleEnviroment){
        currentScene.background.contents = actionM3D.sceneSet.backgroundImage;
    }
    
    //Background:
    if (actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleImage){
        imvBackground.image = actionM3D.sceneSet.backgroundImage;
    }
    imvBackground.backgroundColor = actionM3D.sceneSet.backgroundColor;
    
    //Scene Lights ***********************************************************************************************************************
    
    [self createDefaultSceneLightsWithScene:currentScene];
    
    //Initial Parameters ***********************************************************************************************************************
    
    [SCNTransaction begin];
    
    //pivot
    //[modelNode setPivot:SCNMatrix4MakeTranslation(0.5, 0.5, 0.5)];
    
    //translation
    [modelNode setPosition:SCNVector3Make(actionM3D.objSet.modelTranslationX, actionM3D.objSet.modelTranslationY, actionM3D.objSet.modelTranslationZ)];
    lastPosition = modelNode.position;
    
    //rotation
    [modelNode setEulerAngles:SCNVector3Make(actionM3D.objSet.modelRotationX, actionM3D.objSet.modelRotationY, actionM3D.objSet.modelRotationZ)];
    lastAngleX = actionM3D.objSet.modelRotationX;
    lastAngleY = actionM3D.objSet.modelRotationY;
    lastAngleZ = actionM3D.objSet.modelRotationZ;
    
    //scale
    [modelNode setScale:SCNVector3Make(actionM3D.objSet.modelScale, actionM3D.objSet.modelScale, actionM3D.objSet.modelScale)];
    lastScale = actionM3D.objSet.modelScale;
    
    [SCNTransaction commit];
    
    //Movement ***********************************************************************************************************************
    
    if (actionM3D.sceneSet.rotationMode == ActionModel3DViewerSceneRotationModeFree){
        
        //Habilita os gestos padrões permitidos pela classe SCNView.
        sceneView.allowsCameraControl = YES;
        
    }else if (actionM3D.sceneSet.rotationMode == ActionModel3DViewerSceneRotationModeLimited){
        
        //Habilita os gestos padrões, adicionando limitadores angulares.
        sceneView.allowsCameraControl = YES;
        //
        if (@available(iOS 11.0, *)) {
            sceneView.defaultCameraController.maximumHorizontalAngle = actionM3D.sceneSet.maximumHorizontalAngle; //180
            sceneView.defaultCameraController.minimumHorizontalAngle = actionM3D.sceneSet.minimumHorizontalAngle; //-180
            //
            sceneView.defaultCameraController.maximumVerticalAngle = actionM3D.sceneSet.maximumVerticalAngle; //90
            sceneView.defaultCameraController.minimumVerticalAngle = actionM3D.sceneSet.minimumVerticalAngle; //-90
        }
        
    }else if (actionM3D.sceneSet.rotationMode == ActionModel3DViewerSceneRotationModeXAxis || actionM3D.sceneSet.rotationMode == ActionModel3DViewerSceneRotationModeYAxis){
        
        for (UIGestureRecognizer *gesture in sceneView.gestureRecognizers){
            [sceneView removeGestureRecognizer:gesture];
        }
        
        sceneView.allowsCameraControl = NO;
        
        // MOVE - Handle two-finger pans
        UIPanGestureRecognizer *twoPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionGestureTwoFingerPan:)];
        twoPan.minimumNumberOfTouches = 2;
        twoPan.maximumNumberOfTouches = 2;
        twoPan.delegate = self;
        [sceneView addGestureRecognizer:twoPan];
        
        // ZOOM - Handle pinches
        //UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(actionGesturePinch:)];
        //pinch.delegate = self;
        //[sceneView addGestureRecognizer:pinch];
        
        // PARTIAL ROTATION - Handle Single Pan
        UIPanGestureRecognizer *singlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionGesturePan:)];
        singlePan.minimumNumberOfTouches = 1;
        singlePan.maximumNumberOfTouches = 1;
        singlePan.delegate = self;
        [sceneView addGestureRecognizer:singlePan];
        
        // RESTORE POSITION - Handle Double Tap
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionGestureDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        doubleTap.delegate = self;
        [sceneView addGestureRecognizer:doubleTap];
    }
    
    //Animations ***********************************************************************************************************************
    
    if (models.count > 1){
        NSString *model2 = nil;
        for (NSString *m in models){
            if ([m hasSuffix:@"model2.scn"]){
                model2 = m;
                break;
            }
        }
        
        if (model2){
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionGestureSingleTap:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            singleTap.delegate = self;
            [sceneView addGestureRecognizer:singleTap];
            
            [self loadAnimationsFromSceneFile:model2];
        }
    }
    
    //Camera ***********************************************************************************************************************
    
    SCNCamera *camera = [SCNCamera new];
    [camera setZNear: 0.01];
    [camera setZFar: 1000.0];
    //
    if (@available(iOS 10.0, *)) {
        
        switch (actionM3D.sceneSet.HDRState) {
            case ActionModel3DViewerSceneHDRStateOFF:{
                [camera setWantsHDR:NO];
                [camera setWantsExposureAdaptation:NO];
            }break;
                
            case ActionModel3DViewerSceneHDRStateON:{
                [camera setWantsHDR:YES];
                [camera setWantsExposureAdaptation:NO];
            }break;
                
            case ActionModel3DViewerSceneHDRStateExposureAdaptation:{
                [camera setWantsHDR:YES];
                [camera setWantsExposureAdaptation:YES];
            }break;
        }
        
    }
    //
    cameraNode = [SCNNode new];
    cameraNode.camera = camera;
    //
    objectBoxSize = [VirtualObjectProperties boxSizeForObject:modelNode];
    if (objectBoxSize.H == 0.0){
        cameraNode.position = SCNVector3Make(0, 0, 1);
    }else{
        //A camera é posicionada numa distância 2 vezes maior que o maior lado do objeto, na altura equivalente ao centro de sua altura:
        cameraNode.position = SCNVector3Make(0, (objectBoxSize.H / 2.0), (MAX(objectBoxSize.W,MAX(objectBoxSize.H, objectBoxSize.L))) * 2.0);
    }
    [sceneView.scene.rootNode addChildNode:cameraNode];
    
    [sceneView setPointOfView:cameraNode];
    
    //Qualidade da cena (O HDR pode ser ligado em outro momento).
    if (@available(iOS 10.0, *)) {
        [cameraNode.camera setWantsHDR:NO];
        [cameraNode.camera setWantsExposureAdaptation:NO];
    }
    
    //NOTA: Neste visualizador o AR não é utilizado, no entando, através da classe é possível determinar se o device suporta configurações mais avançadas (jittering e antialising).
    if (@available(iOS 11.0, *)) {
        if (ARWorldTrackingConfiguration.isSupported) {
            
            sceneView.jitteringEnabled = YES;
            
            switch (actionM3D.sceneSet.sceneQuality) {
                case ActionModel3DViewerSceneQualityAuto:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeMultisampling2X];
                }break;
                    
                case ActionModel3DViewerSceneQualityLow:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeNone];
                }break;
                    
                case ActionModel3DViewerSceneQualityMedium:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeMultisampling2X];
                }break;
                    
                case ActionModel3DViewerSceneQualityHigh:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeMultisampling2X];
                }break;
                    
                case ActionModel3DViewerSceneQualityUltra:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeMultisampling4X];
                }break;
            }
            
        }
    }
    
}

- (void)createDefaultSceneLightsWithScene:(SCNScene*)scene
{
    //Luz adicional para intencificação (não influencia no 'autoenablesDefaultLighting').
    SCNNode *ambientLightNode = [SCNNode new];
    ambientLightNode.light = [SCNLight new];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor whiteColor];
    ambientLightNode.light.intensity = 300; //1000 é o default
    [currentScene.rootNode addChildNode:ambientLightNode];
    //
    sceneView.autoenablesDefaultLighting = YES;
}

- (void)playCompleteScene
 {
     [sceneView.scene setPaused:NO];
     //
     if (audioPlayer){
         [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
         [[AVAudioSession sharedInstance] setActive:YES error:nil];
         [audioPlayer play];
     }
     //
     [self stopAnimatedBackgroundView];
 }

- (void)pauseCompleteScene
{
    [sceneView.scene setPaused:YES];
    //
    if (audioPlayer){
        [audioPlayer pause];
    }
}

- (void)destroyCompleteScene
{
    [sceneView.scene setPaused:YES];
    for (SCNNode *node in [sceneView.scene.rootNode childNodes]) {
        [node removeFromParentNode];
    }
    [sceneView.scene.rootNode removeAllActions];
    [sceneView.scene.rootNode removeAllAnimations];
    sceneView.scene = nil;
    //
    if (audioPlayer){
        [audioPlayer stop];
    }
}

#pragma mark - Utils

- (UIImage *)imageWithView:(UIView *)view
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.bounds.size.width * scale, view.bounds.size.height * scale), view.opaque, scale);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //
    return img;
}

-(UIImage*)processPhotoImageToCorrectSize:(UIImage*)imageToResize
{
    CGFloat aspect = capturePreviewLayer.bounds.size.width / capturePreviewLayer.bounds.size.height;
    CGFloat newHeight = imageToResize.size.height;
    CGFloat newWidth = imageToResize.size.width;
    
    //reaspect:
    newWidth = newHeight * aspect;
    
    CGRect cropRect = CGRectMake((imageToResize.size.width - newWidth) / 2.0, (imageToResize.size.height - newHeight) / 2.0, newWidth, newHeight);
    UIImage *reaspectedImage = [ToolBox graphicHelper_CropImage:imageToResize usingFrame:cropRect];
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIImage *resizedImage = [ToolBox graphicHelper_ResizeImage:reaspectedImage toSize:CGSizeMake((capturePreviewLayer.bounds.size.width * scale), (capturePreviewLayer.bounds.size.height * scale))];
    
    return resizedImage;
}

- (UIImage *)normalizeImageOrientationToPortrait:(UIImage *)imageIn
{
    CGImageRef        imgRef    = imageIn.CGImage;
    CGFloat           width     = CGImageGetWidth(imgRef);
    CGFloat           height    = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect            bounds    = CGRectMake( 0, 0, width, height );
    
    CGFloat            scaleRatio   = bounds.size.width / width;
    CGSize             imageSize    = CGSizeMake( CGImageGetWidth(imgRef),         CGImageGetHeight(imgRef) );
    UIImageOrientation orient       = imageIn.imageOrientation;
    CGFloat            boundHeight;
    
    switch(orient)
    {
        case UIImageOrientationUp:                                        //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored:                                //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:                                      //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:                              //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:                              //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft:                                      //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:                             //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:                                     //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise: NSInternalInconsistencyException format: @"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext( bounds.size );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ( orient == UIImageOrientationRight || orient == UIImageOrientationLeft )
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM( context, transform );
    
    CGContextDrawImage( UIGraphicsGetCurrentContext(), CGRectMake( 0, 0, width, height ), imgRef );
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return( imageCopy );
}


- (void)prepareAndShareModel3DPrintWithBackground:(UIImage*)backImage
{
    UIImage *snapshot = [sceneView snapshot];
    UIImage *watermark = [UIImage imageNamed:@"watermark-lab360-viewer3D.png"];
    
    CGFloat aspectWatermark = watermark.size.width / watermark.size.height;
    CGFloat newHeightWatermark = snapshot.size.width / aspectWatermark;
    CGFloat newWidthWatermark = snapshot.size.width;
    
    CGFloat aspectBackground = backImage.size.width / backImage.size.height;
    CGFloat newHeightBackground = snapshot.size.width / aspectBackground;
    CGFloat newWidthBackground = snapshot.size.width;
    
    UIImage *finalWatermark = [ToolBox graphicHelper_ResizeImage:watermark toSize:CGSizeMake(newWidthWatermark, newHeightWatermark)];
    UIImage *finalBackground = [ToolBox graphicHelper_ResizeImage:backImage toSize:CGSizeMake(newWidthBackground, newHeightBackground)];
    UIImage *intermediaryPhoto = [ToolBox graphicHelper_MergeImage:finalBackground withImage:snapshot position:CGPointZero blendMode:kCGBlendModeNormal alpha:1.0 scale:1.0];
    UIImage *finalPhoto = [ToolBox graphicHelper_MergeImage:intermediaryPhoto withImage:finalWatermark position:CGPointMake(0.0, (finalBackground.size.height - finalWatermark.size.height) - (finalWatermark.size.height / 2.0)) blendMode:kCGBlendModeNormal alpha:1.0 scale:1.0];
    
    if (finalPhoto){
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[finalPhoto] applicationActivities:nil];
        if (IDIOM == IPAD){
            activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems.firstObject;
        }
        [self presentViewController:activityController animated:YES completion:^{
            NSLog(@"activityController presented");
        }];
        [activityController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (session && !session.isRunning){
                [self restartPhotoView];
            }
            NSLog(@"activityController completed: %@", (completed ? @"YES" : @"NO"));
        }];
    }else{
        if (session && !session.isRunning){
            [self restartPhotoView];
        }
    }
}

#pragma mark - Camera Control

- (void)enableCapture
{
    if (self.session) return;
    
    btnTorchMode.hidden = YES;
    
    NSBlockOperation *operation = [self captureOperation];
    operation.completionBlock = ^{
        [self operationCompleted];
    };
    operation.queuePriority = NSOperationQueuePriorityVeryHigh;
    [self.captureQueue addOperation:operation];
}

- (NSBlockOperation *)captureOperation
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
        
        AVCaptureDevice *device = nil;
        if (actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleFrontCamera){
            NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            for (AVCaptureDevice *d in devices) {
                if (d.position == AVCaptureDevicePositionFront) {
                    device = d;
                    break;
                }
            }
        }else{
            device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }
        
        NSError *error = nil;
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        
        if (!input) return;
        
        [self.session addInput:input];
        
        // Turn on point autofocus for middle of view
        [device lockForConfiguration:&error];
        if (!error) {
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                device.focusPointOfInterest = CGPointMake(0.5,0.5);
                device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            }
            
            //Flash and Torch
            
            if(device.hasTorch){
                if ([device isTorchModeSupported:AVCaptureTorchModeAuto]){
                    device.torchMode = AVCaptureTorchModeAuto;
                }else{
                    device.torchMode = AVCaptureTorchModeOff;
                }
            }
            
            self.torchMode = device.torchMode;
            //self.flashMode = device.flashMode;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.torchMode == AVCaptureTorchModeAuto){
                    //AUTO
                    [btnTorchMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
                }else if (self.torchMode == AVCaptureTorchModeOn){
                    //ON
                    [btnTorchMode setImage:[UIImage imageNamed:@"PhotoFlashON"] forState:UIControlStateNormal];
                }else{
                    //OFF
                    [btnTorchMode setImage:[UIImage imageNamed:@"PhotoFlashOFF"] forState:UIControlStateNormal];
                }
            });
            
        }
        [device unlockForConfiguration];
        
        self.capturePreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.capturePreviewLayer.frame = CGRectMake(0.0, 0.0, imvBackground.frame.size.width, imvBackground.frame.size.height);
        });
        self.capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        // Still Image Output
        AVCaptureStillImageOutput *stillOutput = [[AVCaptureStillImageOutput alloc] init];
        stillOutput.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
        [self.session addOutput:stillOutput];
    }];
    return operation;
}

- (void)operationCompleted
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.session) return;
        [imvBackground.layer addSublayer:self.capturePreviewLayer];
        [self.session startRunning];
        
        if ([self currentDevice].hasTorch) {
            [self updateFlashlightState];
            self.btnTorchMode.hidden = NO;
        }
    });
}

- (void)takePhoto:(UIBarButtonItem*)sender
{
    if (!sender.enabled) return;
    
    AVCaptureStillImageOutput *output = self.session.outputs.lastObject;
    AVCaptureConnection *videoConnection = output.connections.lastObject;
    if ([videoConnection isVideoOrientationSupported]){
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    if (!videoConnection) return;
    
    sender.enabled = NO;
    [AppD.soundManager playSound:SoundMediaNameCameraClick withVolume:1.0];
    [output captureStillImageAsynchronouslyFromConnection:videoConnection
                                        completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                            
                                            if (!imageDataSampleBuffer || error){
                                                sender.enabled = YES;
                                                return;
                                            }
                                            
                                            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                            UIImage *rawImage = [[UIImage alloc] initWithData:imageData];
                                            UIImage *image = [self normalizeImageOrientationToPortrait:rawImage];
                                            UIImage *processedImage = [self processPhotoImageToCorrectSize:image];
                                            
                                            sender.enabled = YES;
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.session stopRunning];
                                                //
                                                [self apllyPhotoEffect];
                                                //
                                                [self prepareAndShareModel3DPrintWithBackground:processedImage];
                                            });
                                            
                                        }];
}

- (void)updateFlashlightState
{
    AVCaptureDevice *device = [self currentDevice];
    
    if (!device) return;
    
    NSError *error = nil;
    BOOL success = [device lockForConfiguration:&error];
    if (success) {
        
        if (device.hasTorch){
            //TORCH
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.torchMode == AVCaptureTorchModeAuto){
                    //AUTO
                    [btnTorchMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
                }else if (self.torchMode == AVCaptureTorchModeOn){
                    //ON
                    [btnTorchMode setImage:[UIImage imageNamed:@"PhotoFlashON"] forState:UIControlStateNormal];
                }else{
                    //OFF
                    [btnTorchMode setImage:[UIImage imageNamed:@"PhotoFlashOFF"] forState:UIControlStateNormal];
                }
            });
            device.torchMode = self.torchMode;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.btnTorchMode setHidden: !(device.isFlashAvailable || device.isTorchAvailable)];
        });
        
        [device unlockForConfiguration];
    }
}

- (void)restartPhotoView
{
    [session startRunning];
    //
    [self updateFlashlightState];
}

- (AVCaptureDevice *)currentDevice
{
    return [(AVCaptureDeviceInput *)self.session.inputs.firstObject device];
}

- (AVCaptureDevice *)frontCamera
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

#pragma mark - Load Data

- (void)loadActionContent
{
    actionM3D = [modelManager loadResourcesFromDiskUsingReference:actionM3D];
    
    [self configureAudioForScene];
    
    if (actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleImage || actionM3D.sceneSet.backgroundStyle == ActionModel3DViewerSceneBackgroundStyleEnviroment){
        
        [self fetchDownloadImagesWithCompletion:^(NSString* errorMessage, int readyImages) {
            NSLog(@"ActionModel3D_Scene_Viewer >> fetchDownloadImagesWithCompletion >> Error >> %@", errorMessage);
            
            //Verificando se existem imagens para serem rastreadas:
            if (readyImages == 0){
                
                [self showProcessError:@"Nenhuma imagem para rastreio está disponível para que o AR possa ser utilizado!"];
                
            }else{
                
                [self fetchDownloadModelOBJ];
                
            }
            
        }];
        
    }else{
        
        [self fetchDownloadModelOBJ];
        
    }
    
}

-(void)fetchDownloadImagesWithCompletion:(void (^)(NSString* errorMessage, int readyImages))completion
{
    __block NSString *msgError = @"";
    __block int totalImagesReady = 0;
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    //Background Image / Enviroment Image (Cube Map)
    if (self.actionM3D.sceneSet.backgroundImage == nil){
        
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Downloading];
            [self startAnimatedBackgroundView];
        });
        
        dispatch_group_enter(serviceGroup);
        [[[AsyncImageDownloader alloc] initWithFileURL:self.actionM3D.sceneSet.backgroundURL successBlock:^(NSData *data) {
            if (data != nil){
                @try {
                    self.actionM3D.sceneSet.backgroundImage = [UIImage imageWithData:data];
                    totalImagesReady += 1;
                } @catch (NSException *exception) {
                    self.actionM3D.sceneSet.backgroundImage = nil;
                }
            }
            dispatch_group_leave(serviceGroup);
        } failBlock:^(NSError *error) {
            msgError = [NSString stringWithFormat:@"%@\n%@", msgError, [error localizedDescription]];
            dispatch_group_leave(serviceGroup);
        }] startDownload];
        
    }else{
        totalImagesReady += 1;
    }
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(),^{
        completion(msgError, totalImagesReady);
    });
}

-(void)fetchDownloadModelOBJ
{
    if ([ToolBox textHelper_CheckRelevantContentInString:self.actionM3D.objSet.objLocalURL]){
        [self configureScene];
    }else{
        
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Downloading];
            [self startAnimatedBackgroundView];
        });
        
        //precisa baixar o arquivo OBJ:
        InternetConnectionManager *icm = [InternetConnectionManager new];
        InternetActiveConnectionType iType = [icm activeConnectionType];
        
        if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
            
            [icm downloadDataFrom:self.actionM3D.objSet.objRemoteURL withDelegate:self andCompletionHandler:nil];
            
        }else{
            
            [self showProcessError:@"O modelo 3D não pode ser baixado pois não há uma conexão com internet disponível."];
            
        }
        
    }
}

- (void)processDataForOBJ:(NSData*)zipData
{
    long identifier = self.actionM3D.objSet.objID != 0 ? self.actionM3D.objSet.objID : self.actionM3D.actionID;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *mainFolder = @"objects3D";
    NSString *objFolder = [NSString stringWithFormat:@"obj%li", identifier];
    NSString *objName = [NSString stringWithFormat:@"obj%li.zip", identifier];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *mainPath = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", mainFolder]];
    NSString *objPath = [mainPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objFolder]];
    
    //Controle de diretórios ******************************************************************************************************
    
    if (![self directoryExists:objPath])
    {
        if (![self createDirectoryAtPath:objPath]) {
            [self showProcessError:@"Não foi possível processar o arquivo baixado no momento."];
            return;
        }
    }else{
        NSError *error;
        NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:objPath error:&error];
        if (directoryContents != nil){
            for (NSString *path in directoryContents){
                NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                if ([fileManager removeItemAtPath:fullPath error:&error]){
                    NSLog(@"Arquivo antigo removido: %@", fullPath);
                }else{
                    [self showProcessError:[error localizedDescription]];
                    return;
                }
            }
        }else{
            [self showProcessError:[error localizedDescription]];
            return;
        }
    }
    
    NSString *objFile = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objName]];
    
    if (![self fileExists:objFile])
    {
        if (![self createFileAtPath:objFile])
        {
            [self showProcessError:@"Não foi possível processar o arquivo baixado no momento."];
            return;
        }
    }
    
    [zipData writeToFile:objFile atomically:NO];
    
    //Unzip do arquivo ******************************************************************************************************
    
    if ([SSZipArchive unzipFileAtPath:objFile toDestination:objPath]){
        
        NSError *zipError;
        NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:objPath error:&zipError];
        if (directoryContents != nil){
            
            NSString *currentOBJ = nil;
            
            //Audio File:
            for (NSString *path in directoryContents){
                NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                //
                if ([[fullPath lowercaseString] hasSuffix:@"mp3"]){
                    actionM3D.sceneSet.localAudioFileURL = fullPath;
                    [self configureAudioForScene];
                    break;
                }
            }
            
            //OBJ
            if (actionM3D.type == ActionModel3DViewerTypeScene){
                for (NSString *path in directoryContents){
                    NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                    //
                    if ([[fullPath lowercaseString] hasSuffix:@"obj"]){
                        currentOBJ = fullPath;
                        break;
                    }
                }
            
            }
            //SCN
            else if (actionM3D.type == ActionModel3DViewerTypeAnimatedScene){
                for (NSString *path in directoryContents){
                    NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                    //
                    if ([[fullPath lowercaseString] hasSuffix:@"scn"]){
                        if (currentOBJ == nil){
                            currentOBJ = [NSString stringWithFormat:@"%@", fullPath];
                        }else{
                            currentOBJ = [NSString stringWithFormat:@"%@ ; %@", currentOBJ, fullPath];
                        }
                    }
                }
            }
            
            if (currentOBJ){
                
                actionM3D.objSet.objLocalURL = currentOBJ;
                [self configureScene];
                
            }else{
                [self showProcessError:@"Nenhum arquivo 3D válido foi encontrado no zip baixado."];
                return;
            }
            
        }else{
            [self showProcessError:[zipError localizedDescription]];
            return;
        }
        
    }else{
        [self showProcessError:@"Não foi possível processar o arquivo baixado no momento."];
        return;
    }
}

- (void)configureAudioForScene
{
    if (actionM3D.sceneSet.localAudioFileURL){
        NSURL *url = [NSURL fileURLWithPath:actionM3D.sceneSet.localAudioFileURL];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        if (error){
            NSLog(@"PanoramaGalleryVC >> viewDidLoad >> audioPlayer >> Error >> %@", [error localizedDescription]);
        }
    }
}

#pragma mark - Animations

- (void)loadAnimationsFromSceneFile:(NSString*)sceneFileURL
{
    NSURL *url = [NSURL fileURLWithPath:sceneFileURL];
    
    if (url == nil){
        return;
    }
    
    NSError *loadError;
    SCNScene *scene = [SCNScene sceneWithURL:url options:nil error:&loadError];
    
    for (SCNNode *node in scene.rootNode.childNodes){
        for (NSString *key in [node animationKeys]){
            id<SCNAnimation> animation = [node animationForKey:key];
            [modelAnimations setObject:animation forKey:key];
        }
    }
}

- (void)playAnimationFromSceneView
{
    for (NSString *key in [self.modelAnimations allKeys]){
        CAAnimation *animation = [modelAnimations objectForKey:key];
        animation.repeatCount = 1.0;
        animation.fadeInDuration = 0.5f;
        animation.fadeOutDuration = 0.5f;
        animation.delegate = self;
        //
        [modelNode addAnimation:animation forKey:key ];
    }
}

- (void)stopAnimationFromSceneView
{
    for (NSString *key in [self.modelAnimations allKeys]){
        [modelNode removeAnimationForKey:key fadeOutDuration:0.5f];
    }
}

#pragma mark - File Manipulation Methods

-(BOOL)directoryExists:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:directoryPath];
}

-(BOOL)fileExists:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

-(BOOL)createDirectoryAtPath:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
}

-(BOOL)createFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

#pragma mark -

- (void)startAnimatedBackgroundView
{
    if (backgroundPreviewImage && self.imvAnimatedBackground == nil){
        CGRect rect = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        imvAnimatedBackground = [[UIImageView alloc] initWithFrame:rect];
        imvAnimatedBackground.contentMode = UIViewContentModeScaleAspectFill;
        imvAnimatedBackground.image = backgroundPreviewImage;
        //
        [self.view addSubview:imvAnimatedBackground];
    }
}

- (void)stopAnimatedBackgroundView
{
    if (imvAnimatedBackground){
        [UIView animateWithDuration:0.25f animations:^{
            [self.imvAnimatedBackground setAlpha:0.0];
        } completion:^(BOOL finished) {
            [self.imvAnimatedBackground removeFromSuperview];
            self.imvAnimatedBackground = nil;
        }];
    }
}

@end
