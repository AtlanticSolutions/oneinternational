//
//  ActionModel3D_SamplesVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 25/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "ActionModel3D_SamplesVC.h"
#import "AppDelegate.h"
#import "ActionModel3D_AR.h"
#import "ActionModel3D_AR_ViewerVC.h"
#import "ActionModel3D_TargetImage_ViewerVC.h"
#import "ActionModel3D_Scene_ViewerVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface ActionModel3D_SamplesVC()
//Data:

//Layout:

@end

#pragma mark - • IMPLEMENTATION
@implementation ActionModel3D_SamplesVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
//@synthesize

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODO: ...
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:@"ActionModel3D"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];

    if ([segue.identifier isEqualToString:@"SegueToTargetImage"]){
        
        ActionModel3D_TargetImage_ViewerVC *vc = segue.destinationViewController;
        
        ActionModel3D_AR *ar = [ActionModel3D_AR new];
        
        ar.actionID = 1;
        ar.type = ActionModel3DViewerTypeImageTarget;
        ar.cachePolicy = ActionModel3DDataCachePolicyPermanent;
        ar.cacheOwnerID = AppD.loggedUser.userID;
        
        //        ActionModel3D_AR_ImageSetConfig *iSet1 = [ActionModel3D_AR_ImageSetConfig new];
        //        iSet1.imageID = 1000;
        //        iSet1.imageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/resources/images/image_targets/lab360_vuforia_local_target_marker.jpg";
        //        iSet1.physicalWidth = 0.12f;
        //        //
        //        ActionModel3D_AR_ImageSetConfig *iSet2 = [ActionModel3D_AR_ImageSetConfig new];
        //        iSet2.imageID = 2000;
        //        iSet2.imageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/resources/images/image_targets/natura.jpg";
        //        iSet2.physicalWidth = 0.195f;
        
        ar.targetImageSet.imageID = 1000;
        ar.targetImageSet.imageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/resources/images/image_targets/lab360_vuforia_local_target_marker.jpg";
        ar.targetImageSet.physicalWidth = 0.12f;
        
        ar.screenSet.showPhotoButton = NO;
        ar.screenSet.showLightControlOption = NO;
        ar.screenSet.screenTitle = @"Image Target";
        
        ar.sceneSet.backgroundColor = [ToolBox graphicHelper_colorWithHexString:@"#ff033e"];
        ar.sceneSet.backgroundURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/resources/images/cube_map/virtual-skybox-enviroment-scene-1.jpg";
        ar.sceneSet.sceneQuality = ActionModel3DViewerSceneQualityUltra;
        
        ar.objSet.objID = 10;
        ar.objSet.objRemoteURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/obj2.zip";
        ar.objSet.objLocalURL = nil;
        ar.objSet.enableMaterialAutoIllumination = NO;
        //
        ar.objSet.modelRotationX = 0.0 * (M_PI / 180.0);
        ar.objSet.modelRotationY = 0.0 * (M_PI / 180.0);
        ar.objSet.modelRotationZ = 0.0 * (M_PI / 180.0);
        //
        ar.objSet.modelTranslationX = 0.0;
        ar.objSet.modelTranslationY = 0.0;
        ar.objSet.modelTranslationZ = 0.0;
        //
        ar.objSet.modelScale = 0.1;
        //
        ar.objSet.autoShadow = YES;
        ar.objSet.autoSizeFit = NO;
        
        ar.targetID = @"target";
        ar.productID = 100;
        ar.productData = [AppD.loggedUser dictionaryJSON_NoImage];
        
        vc.actionM3D = ar;
        
    }
    
    if ([segue.identifier isEqualToString:@"SegueToAR"]){
        
        ActionModel3D_TargetImage_ViewerVC *vc = segue.destinationViewController;
        
        ActionModel3D_AR *ar = [ActionModel3D_AR new];
        
        ar.actionID = 2;
        ar.type = ActionModel3DViewerTypeAR;
        ar.cachePolicy = ActionModel3DDataCachePolicySession;
        ar.cacheOwnerID = AppD.loggedUser.userID;
        
//        ar.targetImageSet.imageID = 1000;
//        ar.targetImageSet.imageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/resources/images/image_targets/lab360_vuforia_local_target_marker.jpg";
//        ar.targetImageSet.physicalWidth = 0.12f;
        
        ar.screenSet.showPhotoButton = YES;
        ar.screenSet.showLightControlOption = YES;
        ar.screenSet.screenTitle = @"Teste AR";
        
        ar.sceneSet.backgroundColor = [ToolBox graphicHelper_colorWithHexString:@"#ff033e"];
        ar.sceneSet.backgroundURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/resources/images/cube_map/virtual-skybox-enviroment-scene-1.jpg";
        ar.sceneSet.sceneQuality = ActionModel3DViewerSceneQualityUltra;
        
        ar.objSet.objID = 21;
        ar.objSet.objRemoteURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/obj5.zip";
        ar.objSet.objLocalURL = nil;
        ar.objSet.enableMaterialAutoIllumination = NO;
        //
        ar.objSet.modelRotationX = 0.0 * (M_PI / 180.0);
        ar.objSet.modelRotationY = 0.0 * (M_PI / 180.0);
        ar.objSet.modelRotationZ = 0.0 * (M_PI / 180.0);
        //
        ar.objSet.modelTranslationX = 0.0;
        ar.objSet.modelTranslationY = 0.1;
        ar.objSet.modelTranslationZ = 0.0;
        //
        ar.objSet.modelScale = 1.0;
        //
        ar.objSet.autoShadow = YES;
        ar.objSet.autoSizeFit = NO;
        
        ar.targetID = @"target1";
        ar.productID = 101;
        ar.productData = [AppD.loggedUser dictionaryJSON_NoImage];
        
        vc.actionM3D = ar;
        
    }
    
    if ([segue.identifier isEqualToString:@"SegueToScene"]){
        
        ActionModel3D_Scene_ViewerVC *vc = segue.destinationViewController;
        
        ActionModel3D_AR *ar = [ActionModel3D_AR new];
        
        ar.actionID = 5;
        ar.type = ActionModel3DViewerTypeScene;
        ar.cachePolicy = ActionModel3DDataCachePolicyLimited;
        ar.cacheOwnerID = AppD.loggedUser.userID;
        
        //        ar.targetImageSet.imageID = 1000;
        //        ar.targetImageSet.imageURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/resources/images/image_targets/lab360_vuforia_local_target_marker.jpg";
        //        ar.targetImageSet.physicalWidth = 0.12f;
        
        ar.screenSet.showPhotoButton = NO;
        ar.screenSet.showLightControlOption = YES;
        ar.screenSet.screenTitle = @"Scene View";
        
        ar.sceneSet.backgroundColor = [ToolBox graphicHelper_colorWithHexString:@"#ffffff"];
        ar.sceneSet.backgroundURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/resources/images/cube_map/virtual-skybox-enviroment-scene-1.jpg";
        ar.sceneSet.sceneQuality = ActionModel3DViewerSceneQualityUltra;
        
        ar.sceneSet.rotationMode = ActionModel3DViewerSceneRotationModeFree;
        ar.sceneSet.backgroundStyle = ActionModel3DViewerSceneBackgroundStyleEnviroment;
        ar.sceneSet.HDRState = ActionModel3DViewerSceneHDRStateON;
        
        ar.sceneSet.maximumHorizontalAngle = 0.0;
        ar.sceneSet.minimumHorizontalAngle = 0.0;
        ar.sceneSet.maximumVerticalAngle = 0.0;
        ar.sceneSet.minimumVerticalAngle = -0.0;
        
        ar.objSet.objID = 50;
        ar.objSet.objRemoteURL = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/objects3D/obj2.zip";
        ar.objSet.objLocalURL = nil;
        ar.objSet.enableMaterialAutoIllumination = YES;
        //
        ar.objSet.modelRotationX = 0.0 * (M_PI / 180.0);
        ar.objSet.modelRotationY = 0.0 * (M_PI / 180.0);
        ar.objSet.modelRotationZ = 0.0 * (M_PI / 180.0);
        //
        ar.objSet.modelTranslationX = 0.0;
        ar.objSet.modelTranslationY = 0.0;
        ar.objSet.modelTranslationZ = 0.0;
        //
        ar.objSet.modelScale = 1.0;
        //
        ar.objSet.autoShadow = YES;
        ar.objSet.autoSizeFit = NO;
        
        ar.targetID = @"target";
        ar.productID = 500;
        ar.productData = [AppD.loggedUser dictionaryJSON_NoImage];
        
        vc.actionM3D = ar;
        
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionTargetImage:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToTargetImage" sender:nil];
}

- (IBAction)actionAR:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToAR" sender:nil];
}

- (IBAction)actionSceneStatic:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToScene" sender:nil];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

#pragma mark - UTILS (General Use)

@end
