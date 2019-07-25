//
//  Viewer3DSceneRendererVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 23/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "Viewer3DSceneRendererVC.h"
#import "AppDelegate.h"
#import "VuforiaManager.h"
#import <ModelIO/ModelIO.h>
#import <SceneKit/ModelIO.h>
//
#import "SceneLightControlVC.h"
#import "VirtualObjectProperties.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface Viewer3DSceneRendererVC ()<VuforiaManagerDelegate, VuforiaEAGLViewSceneSource, VuforiaEAGLViewDelegate, SceneLightControlDelegate>

//Data:
@property (nonatomic, strong) NSString *vuforiaLicenseKey;
@property (nonatomic, strong) VuforiaManager *vuforiaManager;
@property (nonatomic, strong) NSString *lastSceneName;
@property (nonatomic, strong) SCNNode *ambientLightNode;
//
@property (nonatomic, strong) SCNScene *mainScene;
@property (nonatomic, strong) NSString *modelErrorMessage;

//Layout:
@property (nonatomic, strong) SceneLightControlVC *sceneLightControl;

@end

#pragma mark - • IMPLEMENTATION
@implementation Viewer3DSceneRendererVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize screenTitle, xmlDataSetFileURL, objectModelURL, showShareButton, showTargetHintButton, hintImage, ambientLightNode, mainScene, modelErrorMessage, enableMaterialAutoIlumination;
@synthesize lightPositionX, lightPositionY, lightPositionZ, modelPositionX, modelPositionY, modelPositionZ, modelRotationX, modelRotationY, modelRotationZ, modelRotationW, modelScale;
@synthesize vuforiaLicenseKey, vuforiaManager, lastSceneName, sceneLightControl;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mainScene = nil;
    enableMaterialAutoIlumination = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *licenseKey = [userDefaults valueForKey:@"vuforia_license_key"];
    vuforiaLicenseKey = licenseKey;
    
    sceneLightControl = [SceneLightControlVC newSceneLightControl];
    [sceneLightControl setCategoryBitMask:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (vuforiaManager == nil){
        [self.view layoutIfNeeded];
        [self setupLayout:screenTitle];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (vuforiaManager == nil){
        [self showLoadingAnimation];
        [self prepare];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSError *error = nil;
    [vuforiaManager stop:&error];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionShare:(id)sender
{
    UIImage *openGLsnapshot = [vuforiaManager.eaglView snapshot];
    //
    [self apllyPhotoEffect];
    //
    [vuforiaManager pause:nil];
    //
    [self prepareAndShareModel3DPrintWithBackground:openGLsnapshot];
}

- (void)apllyPhotoEffect
{
    //
    [AppD.soundManager playSound:SoundMediaNameCameraClick withVolume:0.85];
    //
    __block UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, vuforiaManager.eaglView.frame.size.width, vuforiaManager.eaglView.frame.size.height)];
    blankView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:blankView];
    [self.view bringSubviewToFront:blankView];
    [UIView animateWithDuration:0.15 delay:0.10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        blankView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [blankView removeFromSuperview];
        blankView = nil;
    }];
    //
}

- (IBAction)actionHint:(id)sender
{
    if (hintImage){
        [vuforiaManager pause:nil];
    }else{
        return;
    }
    
    SCLAlertViewPlus *alert = [AppD createDefaultRichAlert: NSLocalizedString(@"ALERT_MESSAGE_3DVIEWER_HINT", @"") images:@[hintImage] animationTimePerFrame:0.0];
    [alert addButton:NSLocalizedString(@"BUTTON_TITLE_PRINT", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[hintImage] applicationActivities:nil];
        if (IDIOM == IPAD){
            activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems.lastObject;
        }
        [self presentViewController:activityController animated:YES completion:^{
            NSLog(@"activityController presented");
        }];
        [activityController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            [vuforiaManager resume:nil];
            NSLog(@"activityController completed: %@", (completed ? @"YES" : @"NO"));
        }];
    }];
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:^{
        [vuforiaManager resume:nil];
    }];
    [alert showInfo:NSLocalizedString(@"ALERT_TITLE_3DVIEWER_HINT", @"") subTitle:@"" closeButtonTitle:nil duration:0.0];
}

- (IBAction)actionLightControl:(id)sender
{
    [sceneLightControl showSceneLightControlWithDelegate:self];
}

- (void)prepareAndShareModel3DPrintWithBackground:(UIImage*)backImage
{
    UIImage *watermark = [UIImage imageNamed:@"watermark-lab360-viewer3D.png"];
    
    CGFloat aspectWatermark = watermark.size.width / watermark.size.height;
    CGFloat newHeightWatermark = backImage.size.width / aspectWatermark;
    CGFloat newWidthWatermark = backImage.size.width;
    
    UIImage *finalWatermark = [ToolBox graphicHelper_ResizeImage:watermark toSize:CGSizeMake(newWidthWatermark, newHeightWatermark)];
    UIImage *finalPhoto = [ToolBox graphicHelper_MergeImage:backImage withImage:finalWatermark position:CGPointMake(0.0, (backImage.size.height - finalWatermark.size.height) - (finalWatermark.size.height / 2.0)) blendMode:kCGBlendModeNormal alpha:1.0 scale:1.0];
    
    if (finalPhoto){
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[finalPhoto] applicationActivities:nil];
        if (IDIOM == IPAD){
            activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems.firstObject;
        }
        [self presentViewController:activityController animated:YES completion:^{
            NSLog(@"activityController presented");
        }];
        [activityController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            [vuforiaManager resume:nil];
            NSLog(@"activityController completed: %@", (completed ? @"YES" : @"NO"));
        }];
    }else{
        [vuforiaManager resume:nil];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - VuforiaManagerDelegate

-(void)vuforiaManagerDidFinishPreparing:(VuforiaManager *)manager
{
    NSLog(@"vuforiaManagerDidFinishPreparing");
    
    NSError *error;
    [vuforiaManager start:&error];
    
    if (error == nil){
        [vuforiaManager setContinuousAutofocusEnabled:YES];
        [vuforiaManager setExtendedTrackingEnabled:YES];
        //
        NSMutableArray *buttons = [NSMutableArray new];
        UIBarButtonItem *shareButton = nil;
        UIBarButtonItem *hintButton = nil;
        
        [buttons addObject:[self createLightControlBarButton]];
        //
        if (showShareButton){
            shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(actionShare:)];
            [buttons addObject:shareButton];
        }
        if (showTargetHintButton){
            hintButton = [self createHintBarButton];
            [buttons addObject:hintButton];
        }
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItems = buttons;
        });
    }
    
    [self hideLoadingAnimation];
}

-(void)vuforiaManager:(VuforiaManager *)manager didFailToPreparingWithError:(NSError *)error
{
    NSLog(@"didFailToPreparingWithError");
    //
    [self hideLoadingAnimation];
}

-(void)vuforiaManager:(VuforiaManager *)manager didUpdateWithState:(VuforiaState *)state
{
    return;
}

#pragma mark - VuforiaEAGLViewSceneSource

-(SCNScene *)sceneForEAGLView:(VuforiaEAGLView *)view userInfo:(NSDictionary<NSString *,id> *)userInfo
{
    SCNScene *scene = [self createObjectSceneWith:view];
    
    if (scene == nil){
        if (modelErrorMessage != nil){
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                [vuforiaManager stop:nil];
                //
                [self pop:1];
            }];
            [alert showError:@"Erro" subTitle:[NSString stringWithFormat:@"O visualizador 3D comunicou o seguinte erro:\n%@", modelErrorMessage] closeButtonTitle:nil duration:0.0];
        }
    }
    
    return scene;
}

- (SCNScene*)createObjectSceneWith:(VuforiaEAGLView*)view
{
    // Load the .OBJ file
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"CADEIRA_URBAN_TRAMA_MARROM_B" withExtension:@"obj"];
    NSURL *url = [NSURL URLWithString:objectModelURL];

    if (url == nil){
        [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_LOAD_ERROR", @"")];
        return nil;
    }

    NSDictionary *modelMaterialPropertiesDic = [VirtualObjectProperties loadMaterialPropertiesInfoForFile:url];
    
    for (NSString *key in [modelMaterialPropertiesDic allKeys]){
        VirtualObjectProperties *vop = [modelMaterialPropertiesDic objectForKey:key];
        if (vop.invalidMapAssetDetected){
            [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_INVALID_TEXTURE_MAP", @"")];
            return nil;
        }
    }
    
    MDLAsset *asset = [[MDLAsset alloc] initWithURL:url];
    
    if (asset == nil){
        [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_INVALID_ASSET", @"")];
        return nil;
    }
    
    if (asset.count == 0){
        [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_NO_MESH", @"")];
        return nil;
    }else{
        if (![[asset objectAtIndex:0] isKindOfClass:[MDLMesh class]]){
            [self communicateError: NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_INVALID_MESH", @"")];
            return nil;
        }
    }
    
    MDLMesh *object = (MDLMesh*)[asset objectAtIndex:0];

    // Wrap the ModelIO object in a SceneKit object
    SCNNode *node = [SCNNode nodeWithMDLObject:object];

    [node setCastsShadow:YES];
    [node setCategoryBitMask:1];

    //NSDictionary *modelMaterialPropertiesDic = [VirtualObjectProperties loadMaterialPropertiesInfoForFile:url];

    for (SCNMaterial *material in node.geometry.materials){

        [material setLightingModelName:SCNLightingModelPhong];
        //[material setLocksAmbientWithDiffuse:NO];

        VirtualObjectProperties *vop = nil;
        if ([[modelMaterialPropertiesDic allKeys] containsObject:material.name]){
            vop = [modelMaterialPropertiesDic objectForKey:material.name];
        }

        if (vop.reflectionMap){
            UIImage *refl = [UIImage imageWithData:[NSData dataWithContentsOfURL:vop.imageRef]];
            material.reflective.contents = refl;
        }

        /*
        * Nota: O tratamento para material transparente causa um bug visual no render para o vuforia, por isso ele está comentado.
        * O certo deveria ser '[material setWritesToDepthBuffer:NO];' para materiais transparentes, mas atualmente o openGL não entende corretamente.
        * Futuramente pode-se tentar algum método alternativo para se chegar no resultado esperado.
        */
        
        //if (vop.transparent){
        //    [material setWritesToDepthBuffer:NO];
        //}else{
        //    [material setWritesToDepthBuffer:YES];
        //}

        if (vop.transparencyMap){
            [material setWritesToDepthBuffer:YES];
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

    SCNScene *scene = [SCNScene new];
    [scene.rootNode addChildNode:node];

    if (ambientLightNode){
        [ambientLightNode removeFromParentNode];
    }
    ambientLightNode = [SCNNode new];
    ambientLightNode.light = [SCNLight new];
    [ambientLightNode.light setCategoryBitMask:1];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor whiteColor];
    ambientLightNode.light.intensity = 700; //1000 é o default
    ambientLightNode.position = SCNVector3Make(lightPositionX, lightPositionY, lightPositionZ);
    [scene.rootNode addChildNode:ambientLightNode];

    //Criação de luzes ao redor do objeto:
    [self createSurroundLightsInScene:scene forObject:node andIntensity:300]; //compensando a luz ambiente

    [sceneLightControl.directionalLightNode removeFromParentNode];
    [sceneLightControl.directionalLightNode setHidden:YES];
    [scene.rootNode addChildNode:sceneLightControl.directionalLightNode];

    [node setPivot:SCNMatrix4Identity];
    node.position = SCNVector3Make(modelPositionX, modelPositionY, modelPositionZ);
    node.rotation = SCNVector4Make(modelRotationX, modelRotationY, modelRotationZ, modelRotationW);

    view.objectScale = modelScale;

    return scene;
}

#pragma mark - VuforiaEAGLViewDelegate

- (void)vuforiaEAGLView:(VuforiaEAGLView*)view didTouchDownNode:(SCNNode *)node
{
    NSLog(@"didTouchDownNode: %@", node.name);
}

- (void)vuforiaEAGLView:(VuforiaEAGLView*)view didTouchUpNode:(SCNNode *)node
{
    NSLog(@"didTouchUpNode: %@", node.name);
}

- (void)vuforiaEAGLView:(VuforiaEAGLView*)view didTouchCancelNode:(SCNNode *)node
{
    NSLog(@"didTouchCancelNode: %@", node.name);
}

#pragma mark - SceneLightControlDelegate

- (void)sceneLightControlWillHide:(SceneLightControlVC*)lControl
{
    return;
}

- (void)sceneLightControl:(SceneLightControlVC*)lControl changeLightState:(BOOL)newState
{
    if (newState){
        [ambientLightNode setHidden:YES];
    }else{
        [ambientLightNode setHidden:NO];
    }
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)pause
{
    NSError *error = nil;
    [vuforiaManager pause:&error];
}

- (void)resume
{
    NSError *error = nil;
    [vuforiaManager resume:&error];
}

- (UIBarButtonItem*)createLightControlBarButton
{
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    UIImage *img = [[UIImage imageNamed:@"VirtualSceneLightControlIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    //
    [userButton setFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
    [userButton setClipsToBounds:YES];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(actionLightControl:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}

- (UIBarButtonItem*)createHintBarButton
{
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    UIImage *img = [[UIImage imageNamed:@"NavControllerHelpIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    //
    [userButton setFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
    [userButton setClipsToBounds:YES];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(actionHint:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}

- (void)createSurroundLightsInScene:(SCNScene*)scene forObject:(SCNNode*)node andIntensity:(long)intensity
{
//    for (int i=0; i<6; i++){
//        SCNNode *omniLightNode = [SCNNode new];
//        omniLightNode.light = [SCNLight new];
//        [omniLightNode.light setCategoryBitMask:1];
//        omniLightNode.light.type = SCNLightTypeOmni;
//        omniLightNode.light.color = [UIColor whiteColor];
//        omniLightNode.light.intensity = intensity;
//        //
//        switch (i) {
//            case 0:{ omniLightNode.position = SCNVector3Make(0.0, 10.0, 0.0); }break; //TOP
//            case 1:{ omniLightNode.position = SCNVector3Make(-10.0, 0.0, 0.0); }break; //LEFT
//            case 2:{ omniLightNode.position = SCNVector3Make(10.0, 0.0, 0.0); }break; //RIGHT
//            case 3:{ omniLightNode.position = SCNVector3Make(0.0, -10.0, 0.0); }break; //BOTTOM
//            case 4:{ omniLightNode.position = SCNVector3Make(0.0, 0.0, 10.0); }break; //FRONT
//            case 5:{ omniLightNode.position = SCNVector3Make(0.0, 0.0, -10.0); }break; //BACK
//            //default:{ omniLightNode.position = SCNVector3Make(0.0, 0.0, 0.0); }break; //CENTER
//        }
//        //
//        [scene.rootNode addChildNode:omniLightNode];
//    }
    
    for (int i=0; i<5; i++){
        SCNNode *omniLightNode = [SCNNode new];
        omniLightNode.light = [SCNLight new];
        [omniLightNode.light setCategoryBitMask:1];
        omniLightNode.light.type = SCNLightTypeSpot;
        omniLightNode.light.color = [UIColor whiteColor];
        omniLightNode.light.intensity = intensity;
        omniLightNode.light.castsShadow = YES;
        //
        ObjectBoxSize objectBoxSize = [VirtualObjectProperties boxSizeForObject:node];
        CGFloat halfHeight = objectBoxSize.H / 2.0;
        //
        switch (i) {
            case 0:{ omniLightNode.position = SCNVector3Make(0.0, 10.0, 0.0); }break; //TOP
            case 1:{ omniLightNode.position = SCNVector3Make(-10.0, halfHeight, 0.0); }break; //LEFT
            case 2:{ omniLightNode.position = SCNVector3Make(10.0, halfHeight, 0.0); }break; //RIGHT
            case 3:{ omniLightNode.position = SCNVector3Make(0.0, -10.0, 0.0); }break; //BOTTOM
            case 4:{ omniLightNode.position = SCNVector3Make(0.0, halfHeight, 10.0); }break; //FRONT
            case 5:{ omniLightNode.position = SCNVector3Make(0.0, halfHeight, -10.0); }break; //BACK
        }
        //
        omniLightNode.light.spotInnerAngle = 0.0;
        omniLightNode.light.spotOuterAngle = 45.0;
        //
        omniLightNode.light.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.75];
        //omniLightNode.light.shadowMode = SCNShadowModeDeferred;
        omniLightNode.light.shadowRadius = 8.0;
        //
        SCNLookAtConstraint *constraint = [SCNLookAtConstraint lookAtConstraintWithTarget:node];
        constraint.gimbalLockEnabled = NO;
        omniLightNode.constraints = @[constraint];
        //
        [scene.rootNode addChildNode:omniLightNode];
    }
}

- (void)communicateError:(NSString*)errorMessage
{
    modelErrorMessage = errorMessage;
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
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD hideLoadingAnimation];
    });
}

#pragma mark - Vuforia Private

- (void)prepare
{
    vuforiaManager = [[VuforiaManager alloc] initWithLicenseKey:vuforiaLicenseKey dataSetFile:xmlDataSetFileURL];
    if (vuforiaManager){
        vuforiaManager.delegate = self;
        vuforiaManager.eaglView.sceneSource = self;
        vuforiaManager.eaglView.delegate = self;
        [vuforiaManager.eaglView setupRenderer];
        //
        self.view = vuforiaManager.eaglView; //só fica visível assim
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [vuforiaManager prepareWithOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)didRecieveWillResignActiveNotification:(NSNotification*)notification
{
    [self pause];
}

- (void)didRecieveDidBecomeActiveNotification:(NSNotification*)notification
{
    [self resume];
}

@end
