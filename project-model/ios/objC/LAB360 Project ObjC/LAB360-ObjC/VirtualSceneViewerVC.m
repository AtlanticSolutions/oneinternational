//
//  VirtualSceneViewerVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 23/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <ModelIO/ModelIO.h>
#import <SceneKit/ModelIO.h>
#import <SpriteKit/SpriteKit.h>
#import <ARKit/ARKit.h>
//
#import "VirtualSceneViewerVC.h"
#import "AppDelegate.h"
#import "ToolBox.h"
#import "FloatingPickerView.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VirtualSceneViewerVC ()<FloatingPickerViewDelegate, UIGestureRecognizerDelegate>

//Data: ========================================================
//@property (nonatomic, assign) BOOL scaleAllowed;
@property (nonatomic, assign) CGFloat lastScale;
//
//@property (nonatomic, assign) BOOL translateAllowed;
@property (nonatomic, assign) SCNVector3 lastPosition;
//
@property (nonatomic, assign) VirtualSceneViewerRotationMode rotationAllowed;
@property (nonatomic, assign) CGFloat lastAngleX;
@property (nonatomic, assign) CGFloat lastAngleY;
@property (nonatomic, assign) CGFloat lastAngleZ;
//
@property (nonatomic, strong) SCNScene *currentScene;
@property (nonatomic, strong) SCNNode *modelNode;
@property (nonatomic, strong) SCNNode *cameraNode;
@property (nonatomic, strong) NSURL *modelURL;
//
@property (nonatomic, assign) VirtualSceneViewerBackgroundStyle backgroundStyle;
//
@property (nonatomic, assign) VirtualSceneViewerHDRState HDRState;
//
@property (nonatomic, strong) NSArray *enviromentScenesList;

//Camera
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *capturePreviewLayer;
@property (nonatomic, strong) NSOperationQueue *captureQueue;
@property (nonatomic, assign) UIImageOrientation imageOrientation;
@property (assign, nonatomic) AVCaptureFlashMode flashMode;
@property (assign, nonatomic) AVCaptureTorchMode torchMode;

//Layout: ========================================================
@property(nonatomic, strong) FloatingPickerView *pickerView;
//
@property (nonatomic, weak) IBOutlet UIImageView *imvBackground;
@property (nonatomic, weak) IBOutlet SCNView *sceneView;
//
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UILabel *lblMessage;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *footerHeightConstraint;

//Camera
@property (nonatomic, strong) UIButton *btnFlashMode;

@end

#pragma mark - • IMPLEMENTATION
@implementation VirtualSceneViewerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize delegate, tagID, objectBoxSize, lastScale, lastPosition, rotationAllowed, lastAngleX, lastAngleY, lastAngleZ, backgroundStyle, maxZoomAlowed, HDRState, enviromentScenesList;
@synthesize currentScene, modelNode, cameraNode, modelURL, sceneQuality, enableMaterialAutoIlumination;
@synthesize pickerView, imvBackground, sceneView, footerView, lblMessage, footerHeightConstraint;
@synthesize session, capturePreviewLayer, captureQueue, imageOrientation, flashMode, torchMode, btnFlashMode;

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
    delegate = nil;
    tagID = 0;
    maxZoomAlowed = 10.0;
    sceneQuality = Virtual3DViewerSceneQualityUltra;
    enviromentScenesList = nil;
    modelURL = nil;
    enableMaterialAutoIlumination = NO;
    //
    lastAngleX = 0.0;
    lastAngleY = 0.0;
    lastAngleZ = 0.0;
    lastScale = 1.0;
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
    
    HDRState = VirtualSceneViewerHDRStateOFF;
    
    pickerView = [FloatingPickerView newFloatingPickerView];
    pickerView.contentStyle = FloatingPickerViewContentStyleAuto;
    pickerView.backgroundTouchForceCancel = YES;
    pickerView.tag = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if (sceneView.scene == nil){
        [self.view layoutIfNeeded];
        [self setupLayout:@"Visualizador 3D"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (sceneView.scene == nil){
        [self loadSceneData];
        if (sceneView.scene == nil){
            lblMessage.text = NSLocalizedString(@"LABEL_3DVIEWER_NO_MODEL_LOADED", @"");
        }else{
            
            //Show Navigation Item Buttons
            NSMutableArray *buttons = [NSMutableArray new];
            
            if (delegate){
                if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewerShowShareButton:)]){
                    BOOL showShare = [delegate virtualSceneViewerShowShareButton:self];
                    if (showShare){
                        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(actionShare:)];
                        [buttons addObject:shareButton];
                    }
                }
                
                if (backgroundStyle == VirtualSceneViewerBackgroundStyleEnviroment){
                    if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewerEnviromentSceneNames:)]){
                        enviromentScenesList = [delegate virtualSceneViewerEnviromentSceneNames:self];
                        if (enviromentScenesList && enviromentScenesList.count > 1){
                            UIBarButtonItem *enviromentButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(actionEnviromentChange:)];
                            [buttons addObject:enviromentButton];
                        }
                    }
                }
                
            }else{
                //Sem delegate apenas o botão de share aparece
                UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(actionShare:)];
                [buttons addObject:shareButton];
            }
            
            if (backgroundStyle == VirtualSceneViewerBackgroundStyleBackCamera || backgroundStyle == VirtualSceneViewerBackgroundStyleFrontCamera){
                UIBarButtonItem *shareFlash = [[UIBarButtonItem alloc] initWithCustomView:btnFlashMode];
                [buttons addObject:shareFlash];
                //
                [self enableCapture];
            }
            
            if (buttons.count > 0){
                self.navigationItem.rightBarButtonItems = buttons;
            }
            
            //Footer Message:
            if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewerMessageForInstructionMessage:)]){
                lblMessage.text = [delegate virtualSceneViewerMessageForInstructionMessage:self];
            }else{
                lblMessage.text = NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_MANIPULATION", @"");
            }
        }
    }
    
    //NOTE: Aqui busca-se pelo gesto de rotação para que, se necessário, o mesmo possa ser bloqueado no futuro:
    for (UIGestureRecognizer *gr in sceneView.gestureRecognizers){
        if ([gr isKindOfClass:[UIRotationGestureRecognizer class]]){
            gr.delegate = self;
        }
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

- (void)setTitleScreen:(NSString*)titleScreen
{
    self.navigationItem.title = titleScreen;
}

- (void)setInstructionsText:(NSString*)text withStyle:(VirtualSceneViewerInstructionStyle)style
{
    switch (style) {
        case VirtualSceneViewerInstructionStyleHide:{
            footerHeightConstraint.constant = 0.0;
            [footerView setHidden:YES];
        }break;
        case VirtualSceneViewerInstructionStyleMinimal:{
            footerHeightConstraint.constant = 20.0;
        }break;
        case VirtualSceneViewerInstructionStyleNormal:{
            footerHeightConstraint.constant = 40.0;
        }break;
        case VirtualSceneViewerInstructionStyleExtended:{
            footerHeightConstraint.constant = 60.0;
        }break;
    }
    
    [self.view layoutIfNeeded];
    
    lblMessage.text = text;
}

#pragma mark - • ACTION METHODS

- (IBAction)actionShare:(id)sender
{
    if (backgroundStyle ==  VirtualSceneViewerBackgroundStyleFrontCamera || backgroundStyle ==  VirtualSceneViewerBackgroundStyleBackCamera){
        
        [self takePhoto:(UIBarButtonItem*)sender];
        
    }else{
        
        UIImage *background = [self imageWithView:imvBackground];
        //
        [self apllyPhotoEffect];
        //
        [self prepareAndShareModel3DPrintWithBackground:background];
        
    }
}

- (IBAction)actionEnviromentChange:(id)sender
{
    [pickerView showFloatingPickerViewWithDelegate:self];
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
    switch (rotationAllowed) {
        case VirtualSceneViewerRotationModeNone:{
            return;
        }break;
        case VirtualSceneViewerRotationModeFree:{
            lastAngleX = 0.0;
            lastAngleY = 0.0;
            lastAngleZ = 0.0;
        }break;
        case VirtualSceneViewerRotationModeYAxis:{
            lastAngleY = 0.0;
        }break;
        case VirtualSceneViewerRotationModeXAxis:{
            lastAngleX = 0.0;
        }break;
        case VirtualSceneViewerRotationModeLimited:{
            lastAngleX = 0.0;
            lastAngleY = 0.0;
            lastAngleZ = 0.0;
        }
    }
    [modelNode setEulerAngles:SCNVector3Make(lastAngleX, lastAngleY, lastAngleZ)];
    
    //Translation
    modelNode.position = SCNVector3Make(0.0, 0.0, 0.0);
    lastPosition = SCNVector3Make(0.0, 0.0, 0.0);
    
    //Scale
    modelNode.scale = SCNVector3Make(1.0, 1.0, 1.0);
    lastScale = 1.0;
}

- (IBAction)actionGesturePinch:(UIPinchGestureRecognizer*)gesture
{
    if (rotationAllowed != VirtualSceneViewerRotationModeFree && rotationAllowed != VirtualSceneViewerRotationModeLimited){
        lastScale = lastScale * gesture.scale;
        lastScale = lastScale < 0.1 ? 0.1 : (lastScale > maxZoomAlowed ? maxZoomAlowed : lastScale);
        modelNode.scale = SCNVector3Make(lastScale, lastScale, lastScale);
        gesture.scale = 1.0;
    }
}

- (IBAction)actionGesturePan:(UIPanGestureRecognizer*)gesture
{
    switch (rotationAllowed) {
        case VirtualSceneViewerRotationModeNone:{
            return;
        }break;
        case VirtualSceneViewerRotationModeFree:{
            return;
        }break;
        case VirtualSceneViewerRotationModeYAxis:{
            
            CGPoint translation = [gesture translationInView:sceneView];
            CGFloat newAngle = translation.x * (M_PI / 180.0);
            newAngle += lastAngleY;
            //
            [modelNode setEulerAngles:SCNVector3Make(modelNode.eulerAngles.x, newAngle, modelNode.eulerAngles.z)];

            if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
                lastAngleY = newAngle;
            }
            
        }break;
        case VirtualSceneViewerRotationModeXAxis:{
            
            CGPoint translation = [gesture translationInView:sceneView];
            CGFloat newAngle = translation.y * (M_PI / 180.0);
            newAngle += lastAngleX;
            //
            [modelNode setEulerAngles:SCNVector3Make(newAngle, modelNode.eulerAngles.y, modelNode.eulerAngles.z)];
            
            if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
                lastAngleX = newAngle;
            }
        }break;
        case VirtualSceneViewerRotationModeLimited:{
            return;
        }break;
    }
}

- (IBAction)actionFlash:(id)sender
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
    
//    if ([self currentDevice].hasFlash){
//        if (self.flashMode == AVCaptureFlashModeAuto){
//            self.flashMode = AVCaptureFlashModeOn;
//        }else if (self.flashMode == AVCaptureFlashModeOn){
//            self.flashMode = AVCaptureFlashModeOff;
//        }else{
//            self.flashMode = AVCaptureFlashModeAuto;
//        }
//    }else if([self currentDevice].hasTorch){
//        if (self.torchMode == AVCaptureTorchModeAuto){
//            self.torchMode = AVCaptureTorchModeOn;
//        }else if (self.torchMode == AVCaptureTorchModeOn){
//            self.torchMode = AVCaptureTorchModeOff;
//        }else{
//            self.torchMode = AVCaptureTorchModeAuto;
//        }
//    }
    
    [self updateFlashlightState];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (rotationAllowed == VirtualSceneViewerRotationModeFree){
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
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        return NO;
    }
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]){
        return NO;
    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]){
        return NO;
    }
    //
    if ([otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        return NO;
    }
    if ([otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]){
        return NO;
    }
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]){
        return NO;
    }
    
    return YES;
}

#pragma mark - FloatingPickerElement

- (NSArray<FloatingPickerElement*>* _Nonnull)floatingPickerViewElementsList:(FloatingPickerView *)pickerView
{
    NSMutableArray *elements = [NSMutableArray new];
    
    for (int i=0; i<enviromentScenesList.count; i++){
        NSString *elName = [enviromentScenesList objectAtIndex:i];
        FloatingPickerElement *element = [FloatingPickerElement newElementWithTitle:elName selection:NO tagID:i enum:0 andData:nil];
        if (i == pickerView.tag){
            element.selected = YES;
        }
        //
        [elements addObject:element];
    }
    
    return elements;
}

//Appearence:
- (NSString* _Nonnull)floatingPickerViewTextForCancelButton:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Cancelar";
}

- (NSString* _Nonnull)floatingPickerViewTextForConfirmButton:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Confirmar";
}

- (NSString* _Nonnull)floatingPickerViewTitle:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Seleção de Fundo";
}

- (NSString* _Nonnull)floatingPickerViewSubtitle:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Selecione a cena que deseja carregar:";
}

//Control:
- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willCancelPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    return YES;
}

- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willConfirmPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    if (elements.count == 0){
        return NO;
    }else{
        FloatingPickerElement *element = [elements firstObject];
        
        for (int i=0; i<enviromentScenesList.count; i++){
            NSString *elName = [enviromentScenesList objectAtIndex:i];
            if ([elName isEqualToString:element.title]){
                pickerView.tag = i;
                break;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *images = [delegate virtualSceneViewer:self enviromentImagesForScene:element.tagID];
            NSDictionary *reflectionsDic = [VirtualObjectProperties loadMaterialPropertiesInfoForFile:modelURL];
            
            for (SCNMaterial *material in modelNode.geometry.materials){
                
                VirtualObjectProperties *vop = nil;
                if ([[reflectionsDic allKeys] containsObject:material.name]){
                    vop = [reflectionsDic objectForKey:material.name];
                }
                
                if (vop.reflectionMap){
                    if ([[reflectionsDic allKeys] containsObject:material.name]){
                        if (images.count == 1){
                            material.reflective.contents = [images firstObject];
                        }else{
                            material.reflective.contents = images;
                        }
                    }
                }
            }
            
            if (images.count == 1){
                //sceneView.scene.lightingEnvironment.contents = [images firstObject];
                //sceneView.scene.lightingEnvironment.intensity = 1.0;
                sceneView.scene.background.contents = [images firstObject];
            }else{
                //sceneView.scene.lightingEnvironment.contents = images;
                //sceneView.scene.lightingEnvironment.intensity = 1.0;
                sceneView.scene.background.contents = images;
            }
        });
        
        return YES;
    }
}

- (void)floatingPickerViewDidShow:(FloatingPickerView* _Nonnull)pickerView
{
    NSLog(@"floatingPickerViewDidShow");
}

- (void)floatingPickerViewDidHide:(FloatingPickerView* _Nonnull)pickerView
{
    NSLog(@"floatingPickerViewDidHide");
}

//Aparência
- (UIColor* _Nonnull)floatingPickerViewBackgroundColorCancelButton:(FloatingPickerView* _Nonnull)pickerView
{
    return COLOR_MA_RED;
}

- (UIColor* _Nonnull)floatingPickerViewTextColorCancelButton:(FloatingPickerView* _Nonnull)pickerView
{
    return [UIColor whiteColor];
}

- (UIColor* _Nonnull)floatingPickerViewBackgroundColorConfirmButton:(FloatingPickerView* _Nonnull)pickerView
{
    return COLOR_MA_GREEN;
}

- (UIColor* _Nonnull)floatingPickerViewTextColorConfirmButton:(FloatingPickerView* _Nonnull)pickerView
{
    return [UIColor whiteColor];
}

- (UIColor* _Nonnull)floatingPickerViewSelectedBackgroundColor:(FloatingPickerView* _Nonnull)pickerView
{
    return [UIColor groupTableViewBackgroundColor];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    //Footer
    footerView.backgroundColor = AppD.styleManager.colorPalette.primaryButtonSelected;
    [footerView setClipsToBounds:YES];
    //
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textColor = [UIColor whiteColor];
    lblMessage.text = @"";
    [lblMessage setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    
    imvBackground.backgroundColor = [UIColor blackColor];
    [imvBackground setContentMode:UIViewContentModeScaleAspectFill];
    imvBackground.image = nil;
    
    sceneView.backgroundColor = [UIColor clearColor];
    
    //NOTA: Neste visualizador o AR não é utilizado, no entando, através da classe é possível determinar se o device suporta configurações mais avançadas (jittering e antialising).
    if (@available(iOS 11.0, *)) {
        if (ARWorldTrackingConfiguration.isSupported) {
            sceneView.antialiasingMode = SCNAntialiasingModeMultisampling4X;
            sceneView.jitteringEnabled = YES;
        }
    }
    
    btnFlashMode.backgroundColor = [UIColor clearColor];
    btnFlashMode = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFlashMode.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
    [btnFlashMode addTarget:self action:@selector(actionFlash:) forControlEvents:UIControlEventTouchUpInside];
    [btnFlashMode setFrame:CGRectMake(0, 0, 36, 36)];
    [btnFlashMode setExclusiveTouch:YES];
    
    rotationAllowed = VirtualSceneViewerRotationModeFree;
    backgroundStyle = VirtualSceneViewerBackgroundStyleSolidColor;
    
    if (maxZoomAlowed <= 0.0){
        maxZoomAlowed = 10.0;
    }
    
    [self delegateRequired];
    
    [self delegateOptional];
}

#pragma mark -

- (void)didRecieveWillResignActiveNotification:(NSNotification*)notification
{
    return;
}

- (void)didRecieveDidBecomeActiveNotification:(NSNotification*)notification
{
    self.torchMode = AVCaptureTorchModeAuto;
    
    [self updateFlashlightState];
}

#pragma mark -

- (void)delegateRequired
{
    if (delegate == nil){
        return;
    }
    
    //scaleAllowed = [delegate virtualSceneViewerScaleObjectAllowed:self];
    lastScale = 1.0;
    
    //translateAllowed = [delegate virtualSceneViewerTranslateObjectAllowed:self];
    lastPosition = SCNVector3Make(0.0, 0.0, 0.0);
    
    rotationAllowed = [delegate virtualSceneViewerRotationMode:self];
    lastAngleX = 0.0;
    lastAngleY = 0.0;
    lastAngleZ = 0.0;
    
    backgroundStyle = [delegate virtualSceneViewerBackgroundStyle:self];
}

- (void)delegateOptional
{
    if (delegate == nil){
        return;
    }
    
    //Title:
    if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewerNavigationBarTitle:)]){
        self.navigationItem.title = [delegate virtualSceneViewerNavigationBarTitle:self];
    }
    
    //Footer Style:
    if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewerStyleForInstructionMessage:)]){
        VirtualSceneViewerInstructionStyle style = [delegate virtualSceneViewerStyleForInstructionMessage:self];
        switch (style) {
            case VirtualSceneViewerInstructionStyleHide:{
                footerHeightConstraint.constant = 0.0;
                [footerView setHidden:YES];
            }break;
            case VirtualSceneViewerInstructionStyleMinimal:{
                footerHeightConstraint.constant = 20.0;
            }break;
            case VirtualSceneViewerInstructionStyleNormal:{
                footerHeightConstraint.constant = 40.0;
            }break;
            case VirtualSceneViewerInstructionStyleExtended:{
                footerHeightConstraint.constant = 60.0;
            }break;
        }
        [self.view layoutIfNeeded];
    }
    
    //Background Style:
    if (backgroundStyle == VirtualSceneViewerBackgroundStyleSolidColor){
        if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewerBackgroundColorForScene:)]){
            imvBackground.backgroundColor = [delegate virtualSceneViewerBackgroundColorForScene:self];
        }
    }else if (backgroundStyle == VirtualSceneViewerBackgroundStyleImage){
        if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewerBackgroundImageForScene:)]){
            imvBackground.image = [delegate virtualSceneViewerBackgroundImageForScene:self];
        }
    }
    //NOTE: VirtualSceneViewerBackgroundStyleFrontCamera e VirtualSceneViewerBackgroundStyleBackCamera são configurados em outro ponto.
}

#pragma mark - loading animation

- (void) showLoadingAnimation
{
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });
}

- (void) hideLoadingAnimation
{
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
}

#pragma mark - Scene Configuration

- (void)loadSceneData
{
    if (delegate == nil){
        return;
    }
    
    //Carregando o objeto ***********************************************************************************************************************
    
    modelURL = [delegate virtualSceneViewerLocalURLFor3DModel:self];
    
    if (modelURL == nil){
        [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_LOAD_ERROR", @"")];
        return;
    }
    
    NSDictionary *materialPropertiesDic = [VirtualObjectProperties loadMaterialPropertiesInfoForFile:modelURL];
    
    for (NSString *key in [materialPropertiesDic allKeys]){
        VirtualObjectProperties *vop = [materialPropertiesDic objectForKey:key];
        if (vop.invalidMapAssetDetected){
            [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_INVALID_TEXTURE_MAP", @"")];
            return;
        }
    }
    
    MDLAsset *asset = [[MDLAsset alloc] initWithURL:modelURL];
    
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
        
        [material setLightingModelName:SCNLightingModelPhong];
        [material setLocksAmbientWithDiffuse:NO];
        
        VirtualObjectProperties *vop = nil;
        if ([[materialPropertiesDic allKeys] containsObject:material.name]){
            vop = [materialPropertiesDic objectForKey:material.name];
        }
        
        if (vop.reflectionMap){
            if (backgroundStyle == VirtualSceneViewerBackgroundStyleEnviroment){
                if (delegate){
                    if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewer:enviromentImagesForScene:)]){
                        NSArray *images = [delegate virtualSceneViewer:self enviromentImagesForScene:0];
                        if (images.count == 1){
                            material.reflective.contents = [images firstObject];
                        }else{
                            material.reflective.contents = images;
                        }
                    }
                }
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
        if (!enableMaterialAutoIlumination){
            if (@available(iOS 12.0, *)) {
                material.emission.contents = [UIColor blackColor];
            }
        }
    
    }
    modelNode.castsShadow = YES;
    
    [modelNode setPivot:SCNMatrix4Identity];
    [modelNode setPosition:SCNVector3Make(0.0, 0.0, 0.0)];
    [modelNode setEulerAngles:SCNVector3Make(0.0, 0.0, 0.0)];
    [modelNode setScale:SCNVector3Make(1.0, 1.0, 1.0)];
    
    //Current Scene ***********************************************************************************************************************
    currentScene = [SCNScene new];
    [currentScene.rootNode addChildNode:modelNode];
    
    if (backgroundStyle == VirtualSceneViewerBackgroundStyleEnviroment){
        if (delegate){
            if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewer:enviromentImagesForScene:)]){

                NSArray *images = [delegate virtualSceneViewer:self enviromentImagesForScene:0];
                if (images.count == 1){
                    //currentScene.lightingEnvironment.contents = [images firstObject];
                    //currentScene.lightingEnvironment.intensity = 0.05;
                    currentScene.background.contents = [images firstObject];
                }else{
                    //currentScene.lightingEnvironment.contents = images;
                    //currentScene.lightingEnvironment.intensity = 0.05;
                    currentScene.background.contents = images;
                }
            }
        }
    }
    
    //Scene Lights ***********************************************************************************************************************
    if (delegate){
        if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewerCustomLightNodes:)]){
            NSArray *lights = [delegate virtualSceneViewerCustomLightNodes:self];
            for (SCNNode *node in lights){
                if (node.light){
                    [currentScene.rootNode addChildNode:node];
                }
            }
        }else{
            [self createDefaultSceneLightsWithScene:currentScene];
        }
        //
        if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewerModelInitialStateParameters:)]){
            VirtualSceneNodeParameters *modelParameters = [delegate virtualSceneViewerModelInitialStateParameters:self];
            lastAngleX = modelParameters.posX;
            lastAngleY = modelParameters.posY;
            lastAngleZ = modelParameters.posZ;
            lastScale = modelParameters.scale;
            lastScale = lastScale < 0.1 ? 0.1 : (lastScale > 10.0 ? 10.0 : lastScale);
            //
            [modelNode setEulerAngles:SCNVector3Make(lastAngleX, lastAngleY, lastAngleZ)];
            modelNode.scale = SCNVector3Make(lastScale, lastScale, lastScale);
        }
    }else{
        [self createDefaultSceneLightsWithScene:currentScene];
    }
    
    sceneView.scene = currentScene;
    
    if (rotationAllowed == VirtualSceneViewerRotationModeFree){
        
        //Habilita os gestos padrões permitidos pela classe SCNView.
        sceneView.allowsCameraControl = YES;
        
    }else if (rotationAllowed == VirtualSceneViewerRotationModeLimited){
        
        //Habilita os gestos padrões, adicionando limitadores angulares.
        sceneView.allowsCameraControl = YES;
        //
        if (@available(iOS 11.0, *)) {
            sceneView.defaultCameraController.maximumHorizontalAngle = 90.0; //180
            sceneView.defaultCameraController.minimumHorizontalAngle = -90.0; //-180
            //
            sceneView.defaultCameraController.maximumVerticalAngle = 45.0; //90
            sceneView.defaultCameraController.minimumVerticalAngle = -1.0; //-90
        }
        
    }else if (rotationAllowed == VirtualSceneViewerRotationModeXAxis || rotationAllowed == VirtualSceneViewerRotationModeYAxis){
        
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
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(actionGesturePinch:)];
        pinch.delegate = self;
        [sceneView addGestureRecognizer:pinch];
        
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
        if (delegate){
            if ([((NSObject*)delegate) respondsToSelector:@selector(virtualSceneViewerHDRState:)]){
                HDRState = [delegate virtualSceneViewerHDRState:self];
                switch (HDRState) {
                    case VirtualSceneViewerHDRStateOFF:{
                        [camera setWantsHDR:NO];
                        [camera setWantsExposureAdaptation:NO];
                    }break;
                    case VirtualSceneViewerHDRStateON:{
                        [camera setWantsHDR:YES];
                        [camera setWantsExposureAdaptation:NO];
                    }break;
                    case VirtualSceneViewerHDRStateUsingExposureAdaptation:{
                        [camera setWantsHDR:YES];
                        [camera setWantsExposureAdaptation:YES];
                    }break;
                }
            }
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
    
    //Qualidade da cena (O HDR pode ser ligado em outro momento).
    if (@available(iOS 10.0, *)) {
        [cameraNode.camera setWantsHDR:NO];
        [cameraNode.camera setWantsExposureAdaptation:NO];
    }
    
    //NOTA: Neste visualizador o AR não é utilizado, no entando, através da classe é possível determinar se o device suporta configurações mais avançadas (jittering e antialising).
    if (@available(iOS 11.0, *)) {
        if (ARWorldTrackingConfiguration.isSupported) {
            switch (sceneQuality) {
                case Virtual3DViewerSceneQualityLow:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeNone];
                }break;
                case Virtual3DViewerSceneQualityMedium:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeNone];
                }break;
                case Virtual3DViewerSceneQualityHigh:{
                    [sceneView setAntialiasingMode:SCNAntialiasingModeMultisampling2X];
                }break;
                case Virtual3DViewerSceneQualityUltra:{
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

#pragma mark - Error Constructor

- (void)communicateError:(NSString*)errorMessage
{
    lblMessage.text = errorMessage;
    
    if (delegate == nil){
        return;
    }
    
    [delegate virtualSceneViewer:self errorWithMessage:errorMessage];
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
    
    btnFlashMode.hidden = YES;
    
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
        if (backgroundStyle == VirtualSceneViewerBackgroundStyleFrontCamera){
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
            
            if (device.hasFlash){
                if ([device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                    device.flashMode = AVCaptureFlashModeAuto;
                } else {
                    device.flashMode = AVCaptureFlashModeOff;
                }
            }
            
            self.torchMode = device.torchMode;
            self.flashMode = device.flashMode;
            
//            if (device.hasFlash){
//                if ([device isFlashModeSupported:AVCaptureFlashModeAuto]) {
//                    device.flashMode = AVCaptureFlashModeAuto;
//                } else {
//                    device.flashMode = AVCaptureFlashModeOff;
//                }
//                self.flashMode = device.flashMode;
//                self.torchMode = AVCaptureTorchModeOff;
//            }else if(device.hasTorch){
//                if ([device isTorchModeSupported:AVCaptureTorchModeAuto]){
//                    device.torchMode = AVCaptureTorchModeAuto;
//                }else{
//                    device.torchMode = AVCaptureTorchModeOff;
//                }
//                self.torchMode = device.torchMode;
//                self.flashMode = AVCaptureFlashModeOff;
//            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.flashMode == AVCaptureFlashModeAuto || self.torchMode == AVCaptureTorchModeAuto){
                    //AUTO
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
                }else if (self.flashMode == AVCaptureFlashModeOn || self.torchMode == AVCaptureTorchModeOn){
                    //ON
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashON"] forState:UIControlStateNormal];
                }else{
                    //OFF
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashOFF"] forState:UIControlStateNormal];
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
        
        if ([self currentDevice].hasFlash || [self currentDevice].hasTorch) {
            [self updateFlashlightState];
            self.btnFlashMode.hidden = NO;
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
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
                }else if (self.torchMode == AVCaptureTorchModeOn){
                    //ON
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashON"] forState:UIControlStateNormal];
                }else{
                    //OFF
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashOFF"] forState:UIControlStateNormal];
                }
            });
            device.torchMode = self.torchMode;
        }
        
//        if (device.hasFlash){
//            //FLASH
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (self.flashMode == AVCaptureFlashModeAuto){
//                    //AUTO
//                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
//                }else if (self.flashMode == AVCaptureFlashModeOn){
//                    //ON
//                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashON"] forState:UIControlStateNormal];
//                }else{
//                    //OFF
//                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashOFF"] forState:UIControlStateNormal];
//                }
//            });
//            device.flashMode = self.flashMode;
//        }else if (device.hasTorch){
//            //TORCH
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (self.torchMode == AVCaptureTorchModeAuto){
//                    //AUTO
//                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
//                }else if (self.torchMode == AVCaptureTorchModeOn){
//                    //ON
//                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashON"] forState:UIControlStateNormal];
//                }else{
//                    //OFF
//                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashOFF"] forState:UIControlStateNormal];
//                }
//            });
//            device.torchMode = self.torchMode;
//        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.btnFlashMode setHidden: !(device.isFlashAvailable || device.isTorchAvailable)];
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

@end
