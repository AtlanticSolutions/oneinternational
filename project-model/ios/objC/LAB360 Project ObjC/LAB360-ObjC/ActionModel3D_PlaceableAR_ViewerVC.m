//
//  ActionModel3D_PlaceableAR_ViewerVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 18/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <ModelIO/ModelIO.h>
#import <SceneKit/SceneKit.h>
#import <SceneKit/ModelIO.h>
#import <SpriteKit/SpriteKit.h>
#import <ARKit/ARKit.h>
//
#import "ActionModel3D_PlaceableAR_ViewerVC.h"
#import "VirtualObjectProperties.h"
#import "LightControlView.h"
#import "AppDelegate.h"
#import "ToolBox.h"
#import "AsyncImageDownloader.h"
#import "InternetConnectionManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "SSZipArchive.h"
#import "ActionModel3D_AR_DataManager.h"

typedef enum {
    TransformationNodeType_None               = 0,
    TransformationNodeType_Scale              = 1,
    TransformationNodeType_Rotation           = 2,
    TransformationNodeType_Position           = 3
} TransformationNodeType;

#pragma mark - • INTERFACE PRIVATE PROPERTIES
API_AVAILABLE(ios(11.0))
@interface ActionModel3D_PlaceableAR_ViewerVC ()<ARSCNViewDelegate, ARSessionDelegate, SCNSceneRendererDelegate, UIGestureRecognizerDelegate, LightControlViewDelegate, UIScrollViewDelegate>

//Data: ========================================================
@property (nonatomic, strong) SCNNode *objReferenceNode;
@property (nonatomic, weak)   SCNNode *modelNode;
@property (nonatomic, strong) SCNNode *currentPlaneNode;
@property (nonatomic, strong) SCNNode *directionalLightNode;
@property (nonatomic, strong) SCNNode *completeSceneNode;
//
@property (nonatomic, assign) CGPoint centerReticulePoint;
@property (nonatomic, assign) BOOL sceneLoaded;
@property (nonatomic, assign) BOOL modelPlaced;
@property (nonatomic, assign) CGFloat modelAngleY;
@property (nonatomic, assign) CGFloat modelOriginalScale;
@property (nonatomic, assign) SCNVector3 modelOriginalPosition;
@property (nonatomic, assign) BOOL useCustomDirectionalLight;
//
@property (nonatomic, strong) SCNNode *movedModelNode;
//
//@property (nonatomic, strong) NSString *ruleMessage;
@property (nonatomic, strong) NSMutableArray *colorsList;
@property (nonatomic, strong) NSMutableArray *additionalLightsList;
//
@property (nonatomic, strong) NSMutableArray *lightControlViewList;
@property (nonatomic, assign) BOOL enviromentReflectionEnabled;
//
@property (nonatomic, strong) NSString *modelErrorMessage;
//
@property (nonatomic, strong) ActionModel3D_AR_DataManager *modelManager;
//
@property (nonatomic, strong) NSMutableArray *objNodesList;
//@property (nonatomic, strong) NSMutableArray<NSDictionary*> *modelMaterialPropertiesList;
//
@property (nonatomic, assign) TransformationNodeType transformationNodeType;

//Layout: ========================================================
@property (nonatomic, strong) ARSCNView *arSceneView;
@property (nonatomic, weak) IBOutlet UIView *sceneContainerView;
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UILabel *lblInstructions;
@property (nonatomic, weak) IBOutlet UIImageView *imvInstructions;
//
@property (nonatomic, weak) IBOutlet UIView *lightControlView;
@property (nonatomic, weak) IBOutlet UIView *lightControlHeaderView;
@property (nonatomic, weak) IBOutlet UILabel *lblLightControlTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblLightControlMessage;
@property (nonatomic, weak) IBOutlet UISwitch *swtLightControl;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollLightControl;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
//
@property (nonatomic, weak) IBOutlet UIView *transformNodeViewContainer;
@property (nonatomic, weak) IBOutlet UILabel *lblTransformationInfo;
@property (nonatomic, weak) IBOutlet UIButton *btnTransformNodeDelete;
@property (nonatomic, weak) IBOutlet UIButton *btnTransformNodeScale;
@property (nonatomic, weak) IBOutlet UIButton *btnTransformNodePosition;
@property (nonatomic, weak) IBOutlet UIButton *btnTransformNodeRotation;
//
@property (nonatomic, weak) IBOutlet UIButton *targetButton;

@end

#pragma mark - • IMPLEMENTATION
@implementation ActionModel3D_PlaceableAR_ViewerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
}

#pragma mark - • SYNTESIZES
@synthesize actionM3D, modelManager, objNodesList;
//
@synthesize modelNode, objReferenceNode, currentPlaneNode, directionalLightNode, completeSceneNode, centerReticulePoint, sceneLoaded, modelPlaced, modelAngleY, modelOriginalScale, modelOriginalPosition, useCustomDirectionalLight, modelErrorMessage;
@synthesize arSceneView, sceneContainerView, footerView, lblInstructions, imvInstructions;
@synthesize lightControlView, targetButton, lightControlHeaderView, lblLightControlTitle, lblLightControlMessage, swtLightControl, confirmButton, scrollLightControl, pageControl;
@synthesize movedModelNode, colorsList, additionalLightsList, lightControlViewList, enviromentReflectionEnabled;
@synthesize transformNodeViewContainer, lblTransformationInfo, btnTransformNodeDelete, btnTransformNodeScale, btnTransformNodePosition, btnTransformNodeRotation, transformationNodeType;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

//- (void)loadView
//{
//    [super loadView];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    modelManager = [ActionModel3D_AR_DataManager sharedInstance];
    
    modelPlaced = NO;
    sceneLoaded = NO;
    modelAngleY = 0.0;
    modelOriginalScale = 0.0;
    modelOriginalPosition = SCNVector3Zero;
    useCustomDirectionalLight = NO;
    enviromentReflectionEnabled = NO;
    modelErrorMessage = nil;
    currentPlaneNode = nil;
    objNodesList = [NSMutableArray new];
    //modelMaterialPropertiesList = [NSMutableArray new];
    transformationNodeType = TransformationNodeType_None;
    
    colorsList = [NSMutableArray new];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Branco", @"name", [UIColor whiteColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Cinza Claro", @"name", [UIColor lightGrayColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Cinza Médio", @"name", [UIColor grayColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Cinza Escuro", @"name", [UIColor darkGrayColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Vermelho", @"name", [UIColor redColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rosa", @"name", [UIColor magentaColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Roxo", @"name",[UIColor purpleColor], @"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Azul", @"name", [UIColor blueColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Ciano", @"name", [UIColor cyanColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Verde", @"name", [UIColor greenColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Amarelo", @"name", [UIColor yellowColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Laranja", @"name", [UIColor orangeColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Marrom", @"name",[UIColor brownColor], @"color",  nil]];
    
    directionalLightNode = [self createDirectionalLightNode];
    
    [self setupSceneView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(actionReturn:)];
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
    
    if (sceneLoaded == NO){
        
        if (self.actionM3D == nil || self.actionM3D.type != ActionModel3DViewerTypePlaceableAR){
            [self.navigationController popViewControllerAnimated:self.animatedTransitions];
        }else{
            
            [self setupLayout:actionM3D.screenSet.screenTitle];
            
            //Cache control and data aquisition:
            [self loadActionContent];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

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
        [arSceneView.scene setPaused:YES];
        [arSceneView.session pause];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self handleRotation:[[UIApplication sharedApplication] statusBarOrientation]];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

+ (BOOL) ARSupportedForDevice
{
    if (@available(iOS 11.0, *)) {
        if (ARWorldTrackingConfiguration.isSupported){
            return YES;
        }
    }
    return NO;
}

#pragma mark - • ACTION METHODS

- (IBAction)actionReturn:(id)sender
{
    [self.navigationController popViewControllerAnimated:self.animatedTransitions];
}

- (IBAction)actionSetNewOBJNode:(id)sender
{
    if (self.arSceneView.session.currentFrame){
        
        //SCNNode *newModelNode = [self createModelNode];
        
        //deep clone
        SCNNode *newModelNode = [objReferenceNode clone];
        newModelNode.geometry = [objReferenceNode.geometry copy];
        newModelNode.geometry.firstMaterial = [objReferenceNode.geometry.firstMaterial copy];
        [objNodesList addObject:newModelNode];
        
        MDLTransform *transform = [[MDLTransform alloc] initWithMatrix:self.arSceneView.session.currentFrame.camera.transform];
        
        SCNVector3 modelPosition;
        modelPosition.x = transform.translation.x;
        modelPosition.y = transform.translation.y;
        modelPosition.z = transform.translation.z;
        
        [newModelNode setPosition:modelPosition];
        
        [SCNTransaction begin];
        [completeSceneNode addChildNode:newModelNode];
        [SCNTransaction commit];
        
        
        if (actionM3D.sceneSet.maxSimultaneousObjectsAllowed != 0 && (actionM3D.sceneSet.maxSimultaneousObjectsAllowed == objNodesList.count)){
            [targetButton setEnabled:NO];
        }
    }
}

- (IBAction)actionModelDelete:(id)sender
{
    if (modelNode){
        int index = -1;
        for (int i=0; i<objNodesList.count; i++){
            SCNNode *node = [objNodesList objectAtIndex:i];
            if (modelNode == node){
                [node removeFromParentNode];
                index = i;
                break;
            }
        }
        if (index != -1){
            [objNodesList removeObjectAtIndex:index];
            //
            [targetButton setEnabled:YES];
        }
        modelNode = nil;
        
        [self hideTransformationNodeView];
    }
}

- (IBAction)actionModelScale:(id)sender
{
    transformationNodeType = TransformationNodeType_Scale;
    //
    btnTransformNodeScale.backgroundColor = COLOR_MA_GREEN;
    btnTransformNodeRotation.backgroundColor = COLOR_MA_GRAY;
    btnTransformNodePosition.backgroundColor = COLOR_MA_GRAY;
    //
    [self updateTransformationInfoMessages];
}

- (IBAction)actionModelPosition:(id)sender
{
    transformationNodeType = TransformationNodeType_Position;
    //
    btnTransformNodeScale.backgroundColor = COLOR_MA_GRAY;
    btnTransformNodeRotation.backgroundColor = COLOR_MA_GRAY;
    btnTransformNodePosition.backgroundColor = COLOR_MA_GREEN;
    //
    [self updateTransformationInfoMessages];
}

- (IBAction)actionModelRotation:(id)sender
{
    transformationNodeType = TransformationNodeType_Rotation;
    //
    btnTransformNodeScale.backgroundColor = COLOR_MA_GRAY;
    btnTransformNodeRotation.backgroundColor = COLOR_MA_GREEN;
    btnTransformNodePosition.backgroundColor = COLOR_MA_GRAY;
    //
    [self updateTransformationInfoMessages];
}

- (void)actionTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded){
        
        CGPoint tapPoint = [gesture locationInView:arSceneView];
        
        NSMutableDictionary *options = [NSMutableDictionary new];
        [options setValue:@(YES) forKey:SCNHitTestBoundingBoxOnlyKey];
        [options setValue:@(YES) forKey:SCNHitTestIgnoreHiddenNodesKey];
        [options setValue:@(SCNHitTestSearchModeAll) forKey:SCNHitTestOptionSearchMode];
        
        NSArray <SCNHitTestResult *> *result = [arSceneView hitTest:tapPoint options:options];
        
        modelNode = nil;
        
        for (SCNNode *node in objNodesList){
            
            [node setOpacity:1.0];
            [node removeAnimationForKey:@"fade_animation"];
            
            for (SCNHitTestResult *hitResult in result){
                
                if ([hitResult node] == node  && modelNode == nil){
                    modelNode = node;
                    
                    //[node setOpacity:0.5];
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                    animation.fromValue = @1.0;
                    animation.toValue = @0.2;
                    animation.duration = 0.3;
                    animation.autoreverses = YES;
                    animation.repeatCount = INFINITY;
                    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    [modelNode addAnimation:animation forKey:@"fade_animation"];
                    //
                    [SCNTransaction begin];
                    [currentPlaneNode setHidden:NO];
                    [SCNTransaction commit];
                    
                    [self showTransformationNodeView];
                    
                }
                
                if (modelNode){
                    break;
                }
                
            }
            
        }
        
        if (modelNode == nil){
            
            [SCNTransaction begin];
            [currentPlaneNode setHidden:YES];
            [SCNTransaction commit];
            //
            [self hideTransformationNodeView];
        }
        
    }
}


- (void)actionSinglePanGesture:(UIPanGestureRecognizer*)gesture
{
    if (!modelNode){
        return;
    }
    
    switch (transformationNodeType) {
        case TransformationNodeType_None:{
            return;
        }break;
            
        case TransformationNodeType_Scale:{
            
            if (gesture.state == UIGestureRecognizerStateBegan){
                
                modelOriginalScale = modelNode.scale.x; //x, y ou z tem o mesmo efeito pois a escala sempre afeta todos ao mesmo tempo
                
            }else if (gesture.state == UIGestureRecognizerStateChanged){
                
                CGPoint translation = [gesture translationInView:sceneContainerView];
                CGFloat scale = translation.y / 2.0; //para um efeito suave
                
                if (scale < 0.0){
                    
                    //O dedo está subindo na tela (precisa aumentar a escala):
                    CGFloat factor = ((scale / 100.0) * (-1.0)) + 1.0;
                    CGFloat newScale = modelOriginalScale * factor;
                    //
                    [SCNTransaction begin];
                    [modelNode setScale:SCNVector3Make(newScale, newScale, newScale)];
                    [SCNTransaction commit];
                    
                    //display:
                    CGFloat originalReferenceScale = actionM3D.objSet.modelScale;
                    CGFloat currentScale = (newScale / originalReferenceScale) * 100.0;
                    [self setTransformationInfo:[NSString stringWithFormat:@"%.1f %%", currentScale]];
                    
                }else if (scale > 0.0){
                    
                    //O dedo está descendo na tela (precisa diminuir a escala):
                    CGFloat factor = 1.0 - ((scale / 100.0));
                    factor = factor < 0.001 ? 0.001 : factor;
                    CGFloat newScale = modelOriginalScale * factor;
                    //
                    [SCNTransaction begin];
                    [modelNode setScale:SCNVector3Make(newScale, newScale, newScale)];
                    [SCNTransaction commit];
                    
                    //display:
                    CGFloat originalReferenceScale = actionM3D.objSet.modelScale;
                    CGFloat currentScale = (newScale / originalReferenceScale) * 100.0;
                    [self setTransformationInfo:[NSString stringWithFormat:@"%.1f %%", currentScale]];
                    
                }
                
                
                
                
                NSLog(@"actionSinglePanGesture >> translation.y >> %.f", scale);
            }
            
        }break;
            
        case TransformationNodeType_Rotation:{
            
            if (gesture.state == UIGestureRecognizerStateBegan){
                
                modelAngleY = modelNode.eulerAngles.y;
                
            }else if (gesture.state == UIGestureRecognizerStateChanged){
                
                CGPoint translation = [gesture translationInView:sceneContainerView];
                CGFloat newAngle = translation.x * (M_PI / 180.0);
                newAngle += modelAngleY;
                //
                [SCNTransaction begin];
                [modelNode setEulerAngles:SCNVector3Make(modelNode.eulerAngles.x, newAngle, modelNode.eulerAngles.z)];
                [SCNTransaction commit];
                
                [self setTransformationInfo:[NSString stringWithFormat:@"%.1f º", [self normalizedAngleRadiansToDegree:modelNode.eulerAngles.y]]];
            }
            
        }break;
            
        case TransformationNodeType_Position:{
            
            if (gesture.state == UIGestureRecognizerStateBegan){
                
                modelOriginalPosition = modelNode.position;
                //
                [SCNTransaction begin];
                [currentPlaneNode setPosition:SCNVector3Make(modelOriginalPosition.x, modelOriginalPosition.y, modelOriginalPosition.z)];
                [SCNTransaction commit];
                
                
            }else if (gesture.state == UIGestureRecognizerStateChanged){
                
                CGPoint tapPoint = [gesture locationInView:arSceneView];
                NSArray<SCNHitTestResult *> *result = [arSceneView hitTest:tapPoint options:nil];
                
                if (result.count > 0) {
                    
                    for (SCNHitTestResult *r in result){
                        if (r.node == currentPlaneNode){
                            [SCNTransaction begin];
                            [modelNode setPosition:SCNVector3Make(r.worldCoordinates.x, modelNode.position.y, r.worldCoordinates.z)];
                            [SCNTransaction commit];
                            //
                            break;
                        }
                    }
                    
                }
                
            }
            
        }break;
    }
    
}

- (void)actionDoublePanGesture:(UIPanGestureRecognizer*)gesture
{
    if (modelNode && transformationNodeType == TransformationNodeType_Position){
        
        if (gesture.state == UIGestureRecognizerStateChanged){
            
            CGPoint tapPoint = [gesture locationInView:arSceneView];
            NSArray<SCNHitTestResult *> *result = [arSceneView hitTest:tapPoint options:nil];
            
            if (result.count > 0) {
                
                for (SCNHitTestResult *r in result){
                    if (r.node == currentPlaneNode){
                        [SCNTransaction begin];
                        [modelNode setPosition:SCNVector3Make(modelNode.position.x,r.worldCoordinates.y, modelNode.position.z)];
                        [SCNTransaction commit];
                        //
                        break;
                    }
                }
                
            }
        }
        
    }
}

- (IBAction)actionLightControl:(id)sender
{
    if (lightControlView.tag == 0){
        [self showLightControlView];
    }else{
        [self hideLightControlView];
    }
}

//- (IBAction)actionEnviromentReflection:(id)sender
//{
//    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
//
//    if (enviromentReflectionEnabled){
//        [alert addButton:@"Desativar" withType:SCLAlertButtonType_Normal actionBlock:^{
//            enviromentReflectionEnabled = NO;
//            ///
//            if (modelMaterialPropertiesDic){
//                for (SCNMaterial *material in modelNode.geometry.materials){
//                    VirtualObjectProperties *vop = nil;
//                    if ([[modelMaterialPropertiesDic allKeys] containsObject:material.name]){
//                        vop = [modelMaterialPropertiesDic objectForKey:material.name];
//                    }
//                    if (vop.reflectionMap){
//                        UIImage *refl = [UIImage imageWithData:[NSData dataWithContentsOfURL:vop.imageRef]];
//                        material.reflective.contents = refl;
//                    }
//                }
//            }
//        }];
//    }else{
//        [alert addButton:@"Ativar" withType:SCLAlertButtonType_Normal actionBlock:^{
//            enviromentReflectionEnabled = YES;
//        }];
//    }
//
//    [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
//    [alert showInfo:@"Reflexão Ambiente" subTitle:@"Quando a reflexão de ambiente estiver ligada e o objeto 3D possuir materiais reflectivos, é possível usar o ambiente capturado pela câmera nas texturas." closeButtonTitle:nil duration:0.0];
//}
//
//- (IBAction)actionExposureAdaptation:(id)sender
//{
//    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
//
//    if (self.arSceneView.pointOfView.camera.wantsExposureAdaptation){
//        [alert addButton:@"Desativar" withType:SCLAlertButtonType_Normal actionBlock:^{
//            [self.arSceneView.pointOfView.camera setWantsExposureAdaptation:NO];
//        }];
//    }else{
//        [alert addButton:@"Ativar" withType:SCLAlertButtonType_Normal actionBlock:^{
//            [self.arSceneView.pointOfView.camera setWantsExposureAdaptation:YES];
//        }];
//    }
//    [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
//    [alert showInfo:@"Iluminação" subTitle:@"É possível utilizar o recurso de Adaptação de Exposição na cena.\nEste recurso adapta a luminosidade da cena (câmera + objetos 3D) conforme ocorrem variações de intensidade na luz capitada pela lente, de forma semelhante ao olho humano." closeButtonTitle:nil duration:0.0];
//}

- (IBAction)actionSwitchChangeValue:(UISwitch*)sender
{
    useCustomDirectionalLight = sender.on;
    
    if (useCustomDirectionalLight){
        [directionalLightNode setHidden:NO];
        //
        for (SCNNode *node in additionalLightsList){
            [node setHidden:NO];
        }
        //
        [scrollLightControl setUserInteractionEnabled:YES];
        scrollLightControl.alpha = 1.0;
    }else{
        [directionalLightNode setHidden:YES];
        //
        for (SCNNode *node in additionalLightsList){
            [node setHidden:YES];
        }
        //
        [scrollLightControl setUserInteractionEnabled:NO];
        scrollLightControl.alpha = 0.3;
    }
}

- (IBAction)actionCloseLightControlView:(id)sender
{
    [self hideLightControlView];
}

- (IBAction)actionShare:(id)sender
{
    UIImage *snapshot = [arSceneView snapshot];
    //
    [self apllyPhotoEffect];
    //
    [self prepareAndShareModel3DPrintWithBackground:snapshot];
}

- (void)apllyPhotoEffect
{
    [AppD.soundManager playSound:SoundMediaNameCameraClick withVolume:0.85];
    //
    __block UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, arSceneView.frame.size.width, arSceneView.frame.size.height)];
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
            NSLog(@"activityController completed: %@", (completed ? @"YES" : @"NO"));
        }];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - UIGestureRecognizerDelegate

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//
//}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        return NO;
    }
    
    return YES;
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

#pragma mark - SCNSceneRendererDelegate

//- (void)renderer:(id <SCNSceneRenderer>)renderer willRenderScene:(SCNScene *)scene atTime:(NSTimeInterval)time
//{
//
//}

//- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor API_AVAILABLE(ios(11.0))
//{
//
//}

#pragma mark - ARSCNViewDelegate

- (void)session:(ARSession *)session didFailWithError:(NSError *)error  API_AVAILABLE(ios(11.0))
{
    // Mostra para o usuário o motivo do erro (da sessão AR).
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showError:self title:@"Erro" subTitle:[error localizedDescription] closeButtonTitle:@"OK" duration:0.0];
}

- (void)sessionWasInterrupted:(ARSession *)session  API_AVAILABLE(ios(11.0))
{
    // A sessão interrompida não é necessariamento um erro (pode ser uma pausa). Nos outros métodos ocorrem os controles necessários.
    NSLog(@"sessionWasInterrupted");
}

- (void)sessionInterruptionEnded:(ARSession *)session  API_AVAILABLE(ios(11.0))
{
    // Na prática não é obrigatório reconfigurar a sessão.
    // Este procedimento pode ser feito pois durante a interrupção o device pode ter sido deslocado e as posições do mundo não vão bater com as posições conhecidas anteriormente.
    
    [self setupARSession];
}

- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera API_AVAILABLE(ios(11.0)){
    switch (camera.trackingState) {
        case ARTrackingStateNotAvailable:{
            [self setInstructionsMessage:@"Rastreio indisponível."];
        }break;
            //
        case ARTrackingStateLimited:{
            
            switch (camera.trackingStateReason) {
                case ARTrackingStateReasonNone:{
                    [self setInstructionsMessage:[self ruleMessageForActualState]];
                }break;
                    //
                case ARTrackingStateReasonInitializing:{
                    [self setInstructionsMessage:@"Inicializando. Aguardando processamento da camera e/ou de movimento."];
                }break;
                    //
                case ARTrackingStateReasonExcessiveMotion:{
                    [self setInstructionsMessage:@"Excesso de movimento detectado. Mova-se um pouco mais devagar."];
                }break;
                    //
                case ARTrackingStateReasonInsufficientFeatures:{
                    [self setInstructionsMessage:@"Pontos de referência infuficientes. Mova-se pelo ambiente procurando uma área com melhor iluminação ou com mais detalhes visuais."];
                }break;
                    //
                case ARTrackingStateReasonRelocalizing:{
                    [self setInstructionsMessage:@"Realocando rastreamento, aguarde."];
                }break;
            }
            
        }break;
            //
        case ARTrackingStateNormal:{
            [self setInstructionsMessage:[self ruleMessageForActualState]];
        }break;
    }
}

#pragma mark - ARSessionDelegate

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    if (transformationNodeType == TransformationNodeType_Position && modelNode){
        CGFloat distance = simd_distance(modelNode.simdTransform.columns[3], (arSceneView.session.currentFrame.camera.transform.columns[3]));
        [self setTransformationInfo:[NSString stringWithFormat:@"Distância:\n%.2f m", distance]];
    }
}

//- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors;

//- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors API_AVAILABLE(ios(11.0))
//{
//
//}

//- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors;

#pragma mark - LightControlViewDelegate

- (NSString*)lightControlView:(LightControlView*)lcView textForUpdatedParameterValue:(LightControlParameter*)updatedParameter
{
    NSString *text = @"???";
    
    [SCNTransaction begin];
    switch (updatedParameter.type) {
        case LightControlParameterTypeGeneric:{
            //do nothing
        }break;
            
        case LightControlParameterTypeIntensity:{
            directionalLightNode.light.intensity = updatedParameter.currentValue;
            text = [NSString stringWithFormat:@"%.0f (lumens)", updatedParameter.currentValue];
        }break;
            
        case LightControlParameterTypeTemperature:{
            directionalLightNode.light.temperature = updatedParameter.currentValue;
            text = [NSString stringWithFormat:@"%.0f (K)", updatedParameter.currentValue];
        }break;
            
        case LightControlParameterTypeColor:{
            int index = round(updatedParameter.currentValue) - 1;
            NSDictionary *dic = [colorsList objectAtIndex:index];
            UIColor *color = [dic valueForKey:@"color"];
            directionalLightNode.light.color = color;
            //
            for (SCNNode *node in additionalLightsList){
                node.light.color = color;
            }
            //
            text = [NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]];
        }break;
            
        case LightControlParameterTypeShadowOpacity:{
            directionalLightNode.light.shadowColor = [UIColor colorWithWhite:0.0 alpha:updatedParameter.currentValue];
            text = [NSString stringWithFormat:@"%.1f %%", (updatedParameter.currentValue * 100.0)];
        }break;
            
        case LightControlParameterTypeShadowRadius:{
            directionalLightNode.light.shadowRadius = updatedParameter.currentValue;
            text = [NSString stringWithFormat:@"%.0f", updatedParameter.currentValue];
        }break;
            
            
        case LightControlParameterTypeEulerAngleX:{
            directionalLightNode.eulerAngles = SCNVector3Make([ToolBox converterHelper_DegreeToRadian:updatedParameter.currentValue], directionalLightNode.eulerAngles.y, directionalLightNode.eulerAngles.z);
            text = [NSString stringWithFormat:@"%.0f º (roll)", updatedParameter.currentValue];
        }break;
            
        case LightControlParameterTypeEulerAngleY:{
            directionalLightNode.eulerAngles = SCNVector3Make(directionalLightNode.eulerAngles.x, [ToolBox converterHelper_DegreeToRadian:updatedParameter.currentValue], directionalLightNode.eulerAngles.z);
            text = [NSString stringWithFormat:@"%.0f º (pitch)", updatedParameter.currentValue];
        }break;
            
        case LightControlParameterTypeEulerAngleZ:{
            directionalLightNode.eulerAngles = SCNVector3Make(directionalLightNode.eulerAngles.x, directionalLightNode.eulerAngles.y, [ToolBox converterHelper_DegreeToRadian:updatedParameter.currentValue]);
            text = [NSString stringWithFormat:@"%.0f º (yaw)", updatedParameter.currentValue];
        }break;
            
        case LightControlParameterTypeAdditionalLights:{
            
            for (SCNNode *node in additionalLightsList){
                node.light.intensity = updatedParameter.currentValue;
            }
            text = [NSString stringWithFormat:@"%.0f (lumens)", updatedParameter.currentValue];
            
        }break;
    }
    [SCNTransaction commit];
    
    return text;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat r = scrollView.contentOffset.x / scrollView.frame.size.width;
    int pageN = round(r);
    [pageControl setCurrentPage:pageN];
    //
    [self updateLightControlMessageForIndex:pageN];
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
    
    footerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    
    CGRect screen = [UIScreen mainScreen].bounds;
    [arSceneView setFrame:CGRectMake(0.0, 0.0, screen.size.width, screen.size.height)];
    [sceneContainerView addSubview:arSceneView];
    
    centerReticulePoint = CGPointMake(arSceneView.frame.size.width / 2.0, arSceneView.frame.size.height / 2.0);
    
    lblInstructions.backgroundColor = [UIColor clearColor];
    lblInstructions.textColor = [UIColor whiteColor];
    lblInstructions.text = @"";
    [lblInstructions setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    
    imvInstructions.backgroundColor = [UIColor clearColor];
    imvInstructions.image = [UIImage imageNamed:@"VirtualSceneInfoIcon"];
    
    lightControlView.backgroundColor = [UIColor darkGrayColor];
    lightControlView.alpha = 0.0;
    [lightControlView setClipsToBounds:YES];
    lightControlView.layer.cornerRadius = 5.0;
    
    lightControlHeaderView.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    
    lblLightControlTitle.backgroundColor = [UIColor clearColor];
    lblLightControlTitle.textColor = [UIColor whiteColor];
    lblLightControlTitle.text = @"Controle de Luz Direcional";
    [lblLightControlTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    
    swtLightControl.onTintColor = AppD.styleManager.colorPalette.primaryButtonNormal;
    swtLightControl.on = useCustomDirectionalLight;
    
    confirmButton.backgroundColor = [UIColor darkGrayColor];
    UIImage *bIcon = [[UIImage imageNamed:@"icon-webview-stop"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [confirmButton setImage:bIcon forState:UIControlStateNormal];
    [confirmButton setTintColor:[UIColor whiteColor]];
    [confirmButton setTitle:@"" forState:UIControlStateNormal];
    confirmButton.layer.cornerRadius = 5.0;
    [confirmButton setExclusiveTouch:YES];
    
    lblLightControlMessage.backgroundColor = [UIColor clearColor];
    lblLightControlMessage.textColor = [UIColor lightGrayColor];
    lblLightControlMessage.text = @"";
    [lblLightControlMessage setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    
    scrollLightControl.backgroundColor = [UIColor darkGrayColor];
    scrollLightControl.delegate = self;
    
    pageControl.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    
    [targetButton setExclusiveTouch:YES];
    [targetButton setEnabled:YES];
    
    //Transform Node Views
    
    transformNodeViewContainer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    [transformNodeViewContainer setClipsToBounds:YES];
    transformNodeViewContainer.layer.cornerRadius = 4.0;
    [transformNodeViewContainer.layer setMasksToBounds:YES];
    
    lblTransformationInfo.backgroundColor = [UIColor clearColor];
    lblTransformationInfo.textColor = [UIColor whiteColor];
    lblTransformationInfo.text = @"";
    [lblTransformationInfo setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    
    btnTransformNodeDelete.backgroundColor = COLOR_MA_RED;
    UIImage *bIcon2 = [[UIImage imageNamed:@"ActionModel3DIconPlaceableAR_Delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btnTransformNodeDelete setImage:bIcon2 forState:UIControlStateNormal];
    [btnTransformNodeDelete setTintColor:[UIColor whiteColor]];
    [btnTransformNodeDelete setTitle:@"" forState:UIControlStateNormal];
    btnTransformNodeDelete.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    btnTransformNodeDelete.layer.cornerRadius = 4.0;
    [btnTransformNodeDelete.layer setMasksToBounds:YES];
    [btnTransformNodeDelete setExclusiveTouch:YES];
    [btnTransformNodeDelete setClipsToBounds:YES];
    
    btnTransformNodeScale.backgroundColor = COLOR_MA_GRAY;
    UIImage *bIcon3 = [[UIImage imageNamed:@"ActionModel3DIconPlaceableAR_Scale"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btnTransformNodeScale setImage:bIcon3 forState:UIControlStateNormal];
    [btnTransformNodeScale setTintColor:[UIColor whiteColor]];
    [btnTransformNodeScale setTitle:@"" forState:UIControlStateNormal];
    btnTransformNodeScale.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    btnTransformNodeScale.layer.cornerRadius = 4.0;
    [btnTransformNodeScale.layer setMasksToBounds:YES];
    [btnTransformNodeScale setExclusiveTouch:YES];
    [btnTransformNodeScale setClipsToBounds:YES];
    
    btnTransformNodePosition.backgroundColor = COLOR_MA_GRAY;
    UIImage *bIcon4 = [[UIImage imageNamed:@"ActionModel3DIconPlaceableAR_Translation"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btnTransformNodePosition setImage:bIcon4 forState:UIControlStateNormal];
    [btnTransformNodePosition setTintColor:[UIColor whiteColor]];
    [btnTransformNodePosition setTitle:@"" forState:UIControlStateNormal];
    btnTransformNodePosition.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    btnTransformNodePosition.layer.cornerRadius = 4.0;
    [btnTransformNodePosition.layer setMasksToBounds:YES];
    [btnTransformNodePosition setExclusiveTouch:YES];
    [btnTransformNodePosition setClipsToBounds:YES];
    
    btnTransformNodeRotation.backgroundColor = COLOR_MA_GRAY;
    UIImage *bIcon5 = [[UIImage imageNamed:@"ActionModel3DIconPlaceableAR_Rotation"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btnTransformNodeRotation setImage:bIcon5 forState:UIControlStateNormal];
    [btnTransformNodeRotation setTintColor:[UIColor whiteColor]];
    [btnTransformNodeRotation setTitle:@"" forState:UIControlStateNormal];
    btnTransformNodeRotation.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    btnTransformNodeRotation.layer.cornerRadius = 4.0;
    [btnTransformNodeRotation.layer setMasksToBounds:YES];
    [btnTransformNodeRotation setExclusiveTouch:YES];
    [btnTransformNodeRotation setClipsToBounds:YES];
    
    [transformNodeViewContainer setAlpha:0.0];
    
    // Tap Gesture
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    tapGestureRecognizer.delegate = self;
    [sceneContainerView addGestureRecognizer:tapGestureRecognizer];
    
    // Single Pan Press Gesture
    UIPanGestureRecognizer *singlePanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionSinglePanGesture:)];
    [singlePanGestureRecognizer setMaximumNumberOfTouches:1];
    [singlePanGestureRecognizer setMinimumNumberOfTouches:1];
    singlePanGestureRecognizer.delegate = self;
    [sceneContainerView addGestureRecognizer:singlePanGestureRecognizer];
    
    // Double Pan Press Gesture
    UIPanGestureRecognizer *doublePanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionDoublePanGesture:)];
    [doublePanGestureRecognizer setMaximumNumberOfTouches:2];
    [doublePanGestureRecognizer setMinimumNumberOfTouches:2];
    doublePanGestureRecognizer.delegate = self;
    [sceneContainerView addGestureRecognizer:doublePanGestureRecognizer];
    
    //    [singlePanGestureRecognizer requireGestureRecognizerToFail:tapGestureRecognizer];
    //    [singlePanGestureRecognizer requireGestureRecognizerToFail:doublePanGestureRecognizer];
    //    [doublePanGestureRecognizer requireGestureRecognizerToFail:tapGestureRecognizer];
    
    [self configureLightControl];
    
}

- (void)setInstructionsMessage:(NSString*)message
{
    dispatch_async(dispatch_get_main_queue(),^{
        lblInstructions.text = message;
    });
}

- (void)setTransformationInfo:(NSString*)text
{
    dispatch_async(dispatch_get_main_queue(),^{
        lblTransformationInfo.text = text;
    });
}

- (NSString*)ruleMessageForActualState
{
    if (actionM3D.sceneSet.maxSimultaneousObjectsAllowed != 0 && (actionM3D.sceneSet.maxSimultaneousObjectsAllowed == objNodesList.count)){
        return @"Selecione um dos objetos inseridos na cena para modificar suas propriedades.";
    }else{
        return @"Posicione o dispositivo no local onde deseja posicionar o objeto.";
    }
}

- (void)updateTransformationInfoMessages
{
    [self setTransformationInfo:@""];
    
    switch (transformationNodeType) {
        case TransformationNodeType_None:{
            [self setInstructionsMessage:[self ruleMessageForActualState]];
            //
            [self setInstructionsMessage:@""];
        }break;
            
        case TransformationNodeType_Scale:{
            [self setInstructionsMessage:@"Passe o dedo pela cena, verticalmente, para modificar a escala do objeto."];
            //
            CGFloat originalReferenceScale = actionM3D.objSet.modelScale;
            CGFloat currentScale = (modelNode.scale.x / originalReferenceScale) * 100.0;
            [self setTransformationInfo:[NSString stringWithFormat:@"%.1f %%", currentScale]];
        }break;
            
        case TransformationNodeType_Rotation:{
            [self setInstructionsMessage:@"Passe o dedo pela cena, horizontalmente, para rotacionar o objeto selecionado em seu eixo."];
            //
            [self setTransformationInfo:[NSString stringWithFormat:@"%.1f º", [self normalizedAngleRadiansToDegree:modelNode.eulerAngles.y]]];
        }break;
            
        case TransformationNodeType_Position:{
            [self setInstructionsMessage:@"Com um dedo, desloque o objeto selecionado horizontalmente pelo plano atual. Com dois dedos, verticalmente."];
            //
            [self setTransformationInfo:@""];
        }break;
    }
}

- (void)updateLightControlMessageForIndex:(int)index
{
    LightControlView *lcv = [lightControlViewList objectAtIndex:index];
    NSString *message = nil;
    
    switch ([lcv currentParameterType]) {
        case LightControlParameterTypeGeneric:{
            message = @"";
        }break;
            
        case LightControlParameterTypeIntensity:{
            message = @"💡 Dica: A intensidade define o quanto da cor da luz é visível.";
        }break;
            
        case LightControlParameterTypeTemperature:{
            message = @"💡 Dica: 6500K equivale a temperatura neutra. Abaixo a imagem 'esquenta'. Acima a imagem 'esfria'.";
        }break;
            
        case LightControlParameterTypeColor:{
            message = @"💡 Dica: Defina a cor da luz que inside no objeto.";
        }break;
            
        case LightControlParameterTypeShadowOpacity:{
            message = @"💡 Dica: Escolha o quanto a sombra do objeto será visível.";
        }break;
            
        case LightControlParameterTypeShadowRadius:{
            message = @"💡 Dica: Defina um raio para o contorno da sombra. Quanto menor, mais nítida será.";
        }break;
            
        case LightControlParameterTypeEulerAngleX:{
            message = @"💡 Dica: Rotaciona a direção da luz no eixo X.";
        }break;
            
        case LightControlParameterTypeEulerAngleY:{
            message = @"💡 Dica: Rotaciona a diração da luz no eixo Y.";
        }break;
            
        case LightControlParameterTypeEulerAngleZ:{
            message = @"💡 Dica: Rotaciona a diração da luz no eixo Z.";
        }break;
            
        case LightControlParameterTypeAdditionalLights:{
            message = @"💡 Dica: Intensidade das luzes extras na cena (ao redor do objeto).";
        }break;
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        lblLightControlMessage.text = message;
    });
}

- (void)configureLightControl
{
    CGRect CommomFrame = CGRectMake(0.0, 0.0, scrollLightControl.frame.size.width, scrollLightControl.frame.size.height);
    lightControlViewList = [NSMutableArray new];
    
    //Intensidade ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeIntensity;
        parameter.name = @"INTENSIDADE";
        parameter.minValue = 0.0;
        parameter.maxValue = 2000.0;
        parameter.currentValue = 1000.0;
        parameter.color = nil;
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    //Temperatura ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeTemperature;
        parameter.name = @"TEMPERATURA";
        parameter.minValue = 100.0;
        parameter.maxValue = 40000.0;
        parameter.currentValue = 6500.0;
        parameter.color = nil;
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    //Cor ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeColor;
        parameter.name = @"COR";
        parameter.minValue = 1.0;
        parameter.maxValue = (double)colorsList.count;
        parameter.currentValue = 1.0;
        parameter.color = [UIColor whiteColor];
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    /*
     //Sombra (Opacidade) ===========================================================================
     {
     LightControlParameter *parameter = [LightControlParameter new];
     parameter.type = LightControlParameterTypeShadowOpacity;
     parameter.name = @"OPACIDADE DA SOMBRA";
     parameter.minValue = 0.0;
     parameter.maxValue = 1.0;
     parameter.currentValue = 0.5;
     parameter.color = nil;
     LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
     [lightControlViewList addObject:lightControlView];
     }
     
     //Sombra (Blur) ===========================================================================
     {
     LightControlParameter *parameter = [LightControlParameter new];
     parameter.type = LightControlParameterTypeShadowRadius;
     parameter.name = @"RAIO DA SOMBRA";
     parameter.minValue = 0.0;
     parameter.maxValue = 100.0;
     parameter.currentValue = 8;
     parameter.color = nil;
     LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
     [lightControlViewList addObject:lightControlView];
     }
     */
    
    //Angulo X ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeEulerAngleX;
        parameter.name = @"ROTAÇÃO EIXO - X";
        parameter.minValue = 0.0;
        parameter.maxValue = 359.9;
        parameter.currentValue = 250.0;
        parameter.color = nil;
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    //Angulo Y ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeEulerAngleY;
        parameter.name = @"ROTAÇÃO EIXO - Y";
        parameter.minValue = 0.0;
        parameter.maxValue = 359.9;
        parameter.currentValue = 0.0;
        parameter.color = nil;
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    //Angulo Z ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeEulerAngleZ;
        parameter.name = @"ROTAÇÃO EIXO - Z";
        parameter.minValue = 0.0;
        parameter.maxValue = 359.9;
        parameter.currentValue = 0.0;
        parameter.color = nil;
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    //Luzes Adicionais ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeAdditionalLights;
        parameter.name = @"LUZES ADICIONAIS";
        parameter.minValue = 0.0;
        parameter.maxValue = 2000.0;
        parameter.currentValue = 0.0;
        parameter.color = nil;
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    CGFloat totalWidth = (CGFloat)(lightControlViewList.count) * scrollLightControl.frame.size.width;
    [scrollLightControl setContentSize:CGSizeMake(totalWidth, scrollLightControl.frame.size.height)];
    
    for (int i=0; i<lightControlViewList.count; i++){
        LightControlView *lcv = [lightControlViewList objectAtIndex:i];
        [lcv setFrame:CGRectMake((CGFloat)(i) * scrollLightControl.frame.size.width, 0.0, lcv.frame.size.width, lcv.frame.size.height)];
        [scrollLightControl addSubview:lcv];
    }
    pageControl.numberOfPages = lightControlViewList.count;
    
    if (useCustomDirectionalLight){
        [scrollLightControl setUserInteractionEnabled:YES];
        scrollLightControl.alpha = 1.0;
    }else{
        [scrollLightControl setUserInteractionEnabled:NO];
        scrollLightControl.alpha = 0.3;
    }
    
    [self updateLightControlMessageForIndex:0];
}

- (void)configureAR
{
    //dispatch_async(dispatch_get_main_queue(),^{
    //    [AppD hideLoadingAnimation];
    //});
    
    BOOL saved = [modelManager saveActionModel3D:actionM3D];
    NSLog(@"configureAR >> saveActionModel3D >> %@", (saved ? @"YES" : @"NO"));
    
    objReferenceNode = [self createModelNode];
    
    additionalLightsList = [self createSurroundAdditionalLightsWithIntensity:0];
    
    if (objReferenceNode == nil){
        
        //Verificação de erros de carregamento:
        if (modelErrorMessage != nil){
            
            [self showProcessError:[NSString stringWithFormat:@"O visualizador 3D comunicou o seguinte erro:\n%@", modelErrorMessage]];
            
        }else{
            
            [self showProcessError:NSLocalizedString(@"LABEL_3DVIEWER_MESSAGE_MODEL_EMPTY_OBJ", @"")];
            
        }
    }else{
        
        //Verificação de disponibilidade da funcionalidade:
        BOOL showError = NO;
        if (@available(iOS 12.0, *)) {
            if (ARWorldTrackingConfiguration.isSupported){
                [self setupARSession];
                //
                if (self.actionM3D.screenSet.showLightControlOption){
                    
                    if (actionM3D.screenSet.showPhotoButton){
                        //with photo:
                        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(actionShare:)];
                        self.navigationItem.rightBarButtonItems = @[shareButton, [self createLightControlBarButton]];
                    }else{
                        //without photo:
                        self.navigationItem.rightBarButtonItems = @[[self createLightControlBarButton]];
                    }
                    
                }
                
            }else{
                showError = YES;
            }
            
        }else{
            showError = YES;
        }
        
        if (showError){
            
            [self showProcessError:@"A framework ARKit (image detection) só pode ser utiliza no iOS 12.0 (ou superior) e é necessário que o dispositivo utilize no mínimo o processador A9 (começando dos modelos: iPhone 6S/6S Plus, SE, iPad 2017)."];
            
        }else{
            sceneLoaded = YES;
        }
    }
    
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

- (CGFloat)normalizedAngleRadiansToDegree:(CGFloat)radians
{
    CGFloat angle = [ToolBox converterHelper_RadianToDegree:modelNode.eulerAngles.y];
    angle = fmodf(angle, 360.0);
    angle = angle < 0.0 ? (360.0 + angle) : angle;
    angle = fabs(angle);
    //
    return angle;
}

#pragma mark -

- (void)didRecieveWillResignActiveNotification:(NSNotification*)notification
{
    [self.arSceneView.session pause];
}

- (void)didRecieveDidBecomeActiveNotification:(NSNotification*)notification
{
    [self setupARSession];
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

#pragma mark -

- (void)showLightControlView
{
    lightControlView.tag = 1;
    
    modelNode = nil;
    for (SCNNode *node in objNodesList){
        [node setOpacity:1.0];
        [node removeAnimationForKey:@"fade_animation"];
    }
    //
    [SCNTransaction begin];
    [currentPlaneNode setHidden:YES];
    [SCNTransaction commit];
    //
    [targetButton setHidden:YES];
    [transformNodeViewContainer setHidden:YES];
    
    [sceneContainerView setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
        [lightControlView setAlpha:1.0];
    }];
}

- (void)hideLightControlView
{
    [targetButton setHidden:NO];
    [transformNodeViewContainer setHidden:NO];
    
    [sceneContainerView setUserInteractionEnabled:YES];
    
    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
        [lightControlView setAlpha:0.0];
    } completion:^(BOOL finished) {
        lightControlView.tag = 0;
    }];
}

//- (void)showTargetButtonToUser
//{
//    lightControlView.tag = 0;
//
//    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
//        [lightControlView setAlpha:0.0];
//        [targetButton setAlpha:1.0];
//    }];
//}

//- (void)hideTargetButtonToUser
//{
//    if (actionM3D.screenSet.showPhotoButton){
//        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
//            [targetButton setAlpha:0.0];
//        }];
//    }
//}

- (void)showTransformationNodeView
{
    [self updateTransformationInfoMessages];
    
    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
        [transformNodeViewContainer setAlpha:1.0];
        [targetButton setAlpha:0.0];
    } completion:^(BOOL finished) {
        [btnTransformNodeDelete setUserInteractionEnabled:YES];
        [btnTransformNodeScale setUserInteractionEnabled:YES];
        [btnTransformNodePosition setUserInteractionEnabled:YES];
        [btnTransformNodeRotation setUserInteractionEnabled:YES];
    }];
}

- (void)hideTransformationNodeView
{
    [self setInstructionsMessage:[self ruleMessageForActualState]];
    
    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
        [transformNodeViewContainer setAlpha:0.0];
        [targetButton setAlpha:1.0];
    } completion:^(BOOL finished) {
        [btnTransformNodeDelete setUserInteractionEnabled:NO];
        [btnTransformNodeScale setUserInteractionEnabled:NO];
        [btnTransformNodePosition setUserInteractionEnabled:NO];
        [btnTransformNodeRotation setUserInteractionEnabled:NO];
    }];
}

- (UIBarButtonItem*)createEnviromentReflectionButtom
{
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    UIImage *img = [[UIImage imageNamed:@"VirtualSceneEnviromentReflection"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    //
    [userButton setFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
    [userButton setClipsToBounds:YES];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(actionEnviromentReflection:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
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

- (UIBarButtonItem*)createExposureAdaptationButton
{
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    UIImage *img = [[UIImage imageNamed:@"VirtualSceneExposureAdaptation"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    //
    [userButton setFrame:CGRectMake(0.0, 0.0, 32.0, 32.0)];
    [userButton setClipsToBounds:YES];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(actionExposureAdaptation:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}

#pragma mark - Handle Screen Rotation

- (void) handleRotation:(UIInterfaceOrientation)interfaceOrientation
{
    return;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        //TODO
    //    });
}

#pragma mark - AR

- (void)setupSceneView
{
    self.arSceneView = [ARSCNView new];
    
    // Create a new scene
    SCNScene *scene = [SCNScene new];
    
    // Set the scene to the view
    self.arSceneView.scene = scene;
    
    // debug scene to see feature points and world's origin. Show statistics such as fps and timing information.
    self.arSceneView.debugOptions = SCNDebugOptionNone; //ARSCNDebugOptionShowWorldOrigin|ARSCNDebugOptionShowFeaturePoints;
    self.arSceneView.showsStatistics = NO;
    
    // Set the view's delegate
    self.arSceneView.delegate = self;
    
    self.arSceneView.autoenablesDefaultLighting = YES;
    self.arSceneView.automaticallyUpdatesLighting = YES;
    //
    [self.arSceneView.pointOfView.camera setWantsExposureAdaptation:NO];
    
    if (@available(iOS 11.0, *)) {
        if (ARWorldTrackingConfiguration.isSupported) {
            
            self.arSceneView.jitteringEnabled = YES;
            
            switch (self.actionM3D.sceneSet.sceneQuality) {
                case ActionModel3DViewerSceneQualityAuto:{
                    [self.arSceneView.pointOfView.camera setWantsHDR:NO];
                    [self.arSceneView setAntialiasingMode:SCNAntialiasingModeMultisampling2X];
                }break;
                case ActionModel3DViewerSceneQualityLow:{
                    [self.arSceneView.pointOfView.camera setWantsHDR:NO];
                    [self.arSceneView setAntialiasingMode:SCNAntialiasingModeNone];
                }break;
                case ActionModel3DViewerSceneQualityMedium:{
                    [self.arSceneView.pointOfView.camera setWantsHDR:YES];
                    [self.arSceneView setAntialiasingMode:SCNAntialiasingModeNone];
                }break;
                case ActionModel3DViewerSceneQualityHigh:{
                    [self.arSceneView.pointOfView.camera setWantsHDR:YES];
                    [self.arSceneView setAntialiasingMode:SCNAntialiasingModeMultisampling2X];
                }break;
                case ActionModel3DViewerSceneQualityUltra:{
                    [self.arSceneView.pointOfView.camera setWantsHDR:YES];
                    [self.arSceneView setAntialiasingMode:SCNAntialiasingModeMultisampling4X];
                }break;
            }
        }
    }
    
    if (useCustomDirectionalLight){
        [directionalLightNode setHidden:NO];
        //
        for (SCNNode *node in additionalLightsList){
            [node setHidden:NO];
        }
    }else{
        [directionalLightNode setHidden:YES];
        //
        for (SCNNode *node in additionalLightsList){
            [node setHidden:YES];
        }
    }
    
    [arSceneView.scene.rootNode addChildNode:directionalLightNode];
    
    for (SCNNode *n in additionalLightsList){
        [arSceneView.scene.rootNode addChildNode:n];
    }
    
    //plane node
    SCNPlane *plane = [SCNPlane planeWithWidth:100.0 height:100.0];
    plane.firstMaterial.diffuse.contents = [UIColor clearColor];
    //plane.firstMaterial.transparency = 1.0;
    //
    currentPlaneNode = [SCNNode nodeWithGeometry:plane];
    SCNBillboardConstraint *constaint = [SCNBillboardConstraint billboardConstraint];
    [constaint setFreeAxes:SCNBillboardAxisAll];
    [currentPlaneNode setConstraints:@[constaint]];
    currentPlaneNode.position = SCNVector3Zero;
    currentPlaneNode.name = @"currentPlaneNode";
    [currentPlaneNode setHidden:YES];
    //
    [arSceneView.scene.rootNode addChildNode:currentPlaneNode];
    
}

- (void)setupARSession
{
    // Create a session configuration
    if (@available(iOS 11.0, *)) {
        if (ARWorldTrackingConfiguration.isSupported) {
            ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
            configuration.planeDetection = ARPlaneDetectionNone;
            configuration.worldAlignment = ARWorldAlignmentGravity;
            
            //Caso a qualidade da cena não seja Ultra, será utilizada a segunda melhor configuração de vídeo disponível:
            if (@available(iOS 11.3, *)) {
                if (ARWorldTrackingConfiguration.supportedVideoFormats.count > 1){
                    if (actionM3D.sceneSet.sceneQuality != ActionModel3DViewerSceneQualityUltra){
                        configuration.videoFormat = [ARWorldTrackingConfiguration.supportedVideoFormats objectAtIndex:1];
                    }
                }
            }
            
            if (@available(iOS 12.0, *)) {
                configuration.environmentTexturing = AREnvironmentTexturingAutomatic;
            }
            
            //            if (@available(iOS 11.3, *)) {
            //                if (customAnchorImage){
            //                    configuration.detectionImages = [NSSet setWithObjects:customAnchorImage, nil];
            //                }
            //            }
            
            // Roda a sessão podendo ou não utilizar configurações adicionais.
            //if (reseting){
            [self.arSceneView.session runWithConfiguration:configuration options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
            //}else{
            //    [self.arSceneView.session runWithConfiguration:configuration];
            //}
            self.arSceneView.session.delegate = self;
            
            if (completeSceneNode == nil){
                completeSceneNode = [SCNNode new];
                [self.arSceneView.scene.rootNode addChildNode:completeSceneNode];
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD hideLoadingAnimation];
    });
}

#pragma mark - Nodes

- (SCNNode*)createModelNode
{
    NSURL *url = [NSURL URLWithString:actionM3D.objSet.objLocalURL];
    
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
    
    SCNNode *node = [SCNNode nodeWithMDLObject:object];
    
    for (SCNMaterial *material in node.geometry.materials){
        
        //[material setLightingModelName:SCNLightingModelPhong];
        //[material setLocksAmbientWithDiffuse:NO];
        
        VirtualObjectProperties *vop = nil;
        if ([[modelMaterialPropertiesDic allKeys] containsObject:material.name]){
            vop = [modelMaterialPropertiesDic objectForKey:material.name];
        }
        
        if (vop.reflectionMap){
            UIImage *refl = [UIImage imageWithData:[NSData dataWithContentsOfURL:vop.imageRef]];
            material.reflective.contents = refl;
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
    
    //[SCNTransaction begin];
    
    //pivot
    //[node setPivot:SCNMatrix4MakeTranslation(0.5, 0.0, 0.5)];
    
    //translation
    [node setPosition:SCNVector3Make(actionM3D.objSet.modelTranslationX, actionM3D.objSet.modelTranslationY, actionM3D.objSet.modelTranslationZ)];
    
    //rotation
    [node setEulerAngles:SCNVector3Make(actionM3D.objSet.modelRotationX, actionM3D.objSet.modelRotationY, actionM3D.objSet.modelRotationZ)];
    
    //scale
    [node setScale:SCNVector3Make(actionM3D.objSet.modelScale, actionM3D.objSet.modelScale, actionM3D.objSet.modelScale)];
    
    //[SCNTransaction commit];
    
    node.castsShadow = YES;
    node.categoryBitMask = 1;
    
    node.name = @"OBJNode";
    
    //[modelMaterialPropertiesList addObject:modelMaterialPropertiesDic];
    
    //[objNodesList addObject:node];
    
    return node;
}

- (SCNNode*)createDirectionalLightNode
{
    SCNNode *lightNode = [SCNNode new];
    lightNode.light = [SCNLight new];
    //
    lightNode.light.type = SCNLightTypeDirectional;
    lightNode.light.intensity = 1000;
    lightNode.light.temperature = 6500; //white default
    lightNode.light.color = [UIColor whiteColor];
    //
    lightNode.light.shadowMode = SCNShadowModeDeferred;
    lightNode.light.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    lightNode.light.shadowRadius = 8.0;
    lightNode.light.zFar = 10000;
    //Qualidade da sombra:
    switch (self.actionM3D.sceneSet.sceneQuality) {
        case ActionModel3DViewerSceneQualityAuto:{
            lightNode.light.shadowSampleCount = 4;
            lightNode.light.shadowMapSize = CGSizeZero; //será definido pelo sistema automaticamente
        }break;
        case ActionModel3DViewerSceneQualityLow:{
            lightNode.light.shadowSampleCount = 8;
            lightNode.light.shadowMapSize = CGSizeMake(128, 128); //128
        }break;
        case ActionModel3DViewerSceneQualityMedium:{
            lightNode.light.shadowSampleCount = 16;
            lightNode.light.shadowMapSize = CGSizeMake(256, 256); //512
        }break;
        case ActionModel3DViewerSceneQualityHigh:{
            lightNode.light.shadowSampleCount = 32;
            lightNode.light.shadowMapSize = CGSizeMake(512, 512); //1024
        }break;
        case ActionModel3DViewerSceneQualityUltra:{
            lightNode.light.shadowSampleCount = 64;
            lightNode.light.shadowMapSize = CGSizeMake(1024, 1024); //2048
        }break;
    }
    //
    lightNode.light.orthographicScale = 0.0;
    lightNode.light.castsShadow = YES;
    lightNode.light.categoryBitMask = 1;
    //
    lightNode.position = SCNVector3Zero;
    lightNode.eulerAngles = SCNVector3Make([ToolBox converterHelper_DegreeToRadian:240.0], 0.0, 0.0);
    //
    return lightNode;
    
}

- (NSMutableArray*)createSurroundAdditionalLightsWithIntensity:(long)intensity
{
    NSMutableArray *list = [NSMutableArray new];
    
    for (int i=0; i<5; i++){
        SCNNode *lightNode = [SCNNode new];
        lightNode.light = [SCNLight new];
        [lightNode.light setCategoryBitMask:1];
        lightNode.light.type = SCNLightTypeOmni;
        lightNode.light.color = [UIColor whiteColor];
        lightNode.light.intensity = intensity;
        lightNode.light.zFar = 10000;
        [lightNode.light setCastsShadow:NO]; //Para tipo 'SCNLightTypeOmni' é irrelevante. Apenas direcional e spot geram sombras.
        //
        CGFloat halfHeight = 2.5;
        //
        switch (i) {
            case 0:{ lightNode.position = SCNVector3Make(0.0, 20.0, 0.0); }break; //TOP
            case 1:{ lightNode.position = SCNVector3Make(-10.0, halfHeight, 0.0); }break; //LEFT
            case 2:{ lightNode.position = SCNVector3Make(10.0, halfHeight, 0.0); }break; //RIGHT
            case 3:{ lightNode.position = SCNVector3Make(0.0, halfHeight, 10.0); }break; //FRONT
            case 4:{ lightNode.position = SCNVector3Make(0.0, halfHeight, -10.0); }break; //BACK
        }
        
        //Para luz spot:
        /*
         lightNode.light.spotInnerAngle = 0.0;
         lightNode.light.spotOuterAngle = 45.0;
         //
         lightNode.light.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
         lightNode.light.shadowMode = SCNShadowModeDeferred;
         lightNode.light.shadowRadius = 8.0;
         //
         SCNLookAtConstraint *constraint = [SCNLookAtConstraint lookAtConstraintWithTarget:modelNode];
         constraint.gimbalLockEnabled = NO;
         lightNode.constraints = @[constraint];
         */
        
        [lightNode setHidden:YES];
        //
        [list addObject:lightNode];
    }
    
    return list;
}

#pragma mark - Load Data

- (void)loadActionContent
{
    actionM3D = [modelManager loadResourcesFromDiskUsingReference:actionM3D];
    
    [self fetchDownloadModelOBJ];
}

-(void)fetchDownloadModelOBJ
{
    if ([ToolBox textHelper_CheckRelevantContentInString:self.actionM3D.objSet.objLocalURL]){
        [self configureAR];
    }else{
        
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Downloading];
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
            for (NSString *path in directoryContents){
                NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                //
                if ([[fullPath lowercaseString] hasSuffix:@"obj"]){
                    currentOBJ = fullPath;
                    break;
                }
            }
            
            if (currentOBJ){
                
                actionM3D.objSet.objLocalURL = currentOBJ;
                
                [self configureAR];
                
            }else{
                [self showProcessError:@"Nenhum arquivo OBJ foi encontrado no zip baixado."];
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

@end

