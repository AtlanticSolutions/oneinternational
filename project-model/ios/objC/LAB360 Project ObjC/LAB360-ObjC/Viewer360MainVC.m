//
//  Viewer360MainVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 06/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "Viewer360MainVC.h"
#import "Video360VC.h"
#import "ZoneNavigatorVC.h"
#import "ActionModel3D_TargetImage_ViewerVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface Viewer360MainVC()

@property(nonatomic, weak) IBOutlet UIButton *btnRotational;
@property(nonatomic, weak) IBOutlet UIButton *btnPanorama;
@property(nonatomic, weak) IBOutlet UIButton *btnVideo360;
@property(nonatomic, weak) IBOutlet UIButton *btnZone;
@property(nonatomic, weak) IBOutlet UIButton *btn3D;
@property(nonatomic, weak) IBOutlet UIButton *btnUSDZ;

@end

#pragma mark - • IMPLEMENTATION
@implementation Viewer360MainVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize btnRotational, btnPanorama, btnVideo360, btnZone, btn3D, btnUSDZ;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout:@"Visualizadores 360"];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(actionTest:)];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToZoneNavigator"]){
        ZoneNavigatorVC *zoneVC = segue.destinationViewController;
        //
        NavigationZone *zone = [NavigationZone new];
        zone.zoneID = 1;
        zone.name = @"Sunset Prage";
        zone.urlImage = @"http://curiouslines.com/wp-content/uploads/2011/12/almost-Sunset-Prague-panorama.jpg";
        zone.image = [UIImage imageNamed:@"zone-navigator-sample.jpg"];
        //
        zoneVC.currentZone = zone;
    }
    
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • PRIVATE METHODS

- (void)launchVideoWithName/*:(NSString*)name*/ {
    //NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"m4v"];
    NSURL *url = [[NSURL alloc] initWithString:@"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/videos/video360.m4v"];
    Video360VC *videoController = [[Video360VC alloc] initWithNibName:@"Video360VC" bundle:nil url:url];
    
    if (![[self presentedViewController] isBeingDismissed]) {
        [self presentViewController:videoController animated:YES completion:nil];
    }
}

#pragma mark - • ACTION METHODS

//- (IBAction)actionTest:(id)sender
//{
//    //
//}

- (IBAction)actionRotacional:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToRotationalViewer" sender:nil];
}

- (IBAction)actionPanorama:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToPanoramaGallery" sender:nil];
}

- (IBAction)actionVideo360:(id)sender
{
    [self launchVideoWithName];
    //[self performSegueWithIdentifier:@"SegueToVideo360Viewer" sender:self];
}

- (IBAction)actionZoneNavigator:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToZoneNavigator" sender:nil];
}

- (IBAction)action3D:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToViewer3D" sender:nil];
}

- (IBAction)actionUSDZ:(id)sender
{
    if (@available(iOS 12.0, *)) {
        [self performSegueWithIdentifier:@"SegueToUSDZViewer" sender:nil];
    }else{
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"AR Quick Look" subTitle:@"É preciso ter um iPhone com iOS 12 ou superior para acessar esta funcionalidade." closeButtonTitle:@"OK" duration:0.0];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    btnRotational.backgroundColor = [UIColor clearColor];
    [btnRotational setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRotational.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnRotational setTitle:@"Rotacional (Produto)" forState:UIControlStateNormal];
    [btnRotational setExclusiveTouch:YES];
    [btnRotational setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnRotational.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnRotational setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnRotational.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnPanorama.backgroundColor = [UIColor clearColor];
    [btnPanorama setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPanorama.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnPanorama setTitle:@"Panorama (Ambiente)" forState:UIControlStateNormal];
    [btnPanorama setExclusiveTouch:YES];
    [btnPanorama setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnRotational.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnPanorama setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnRotational.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnVideo360.backgroundColor = [UIColor clearColor];
    [btnVideo360 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnVideo360.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnVideo360 setTitle:@"Video 360 (Ambiente)" forState:UIControlStateNormal];
    [btnVideo360 setExclusiveTouch:YES];
    [btnVideo360 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnRotational.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnVideo360 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnRotational.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnZone.backgroundColor = [UIColor clearColor];
    [btnZone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnZone.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnZone setTitle:@"Zona Interativa (Navegação)" forState:UIControlStateNormal];
    [btnZone setExclusiveTouch:YES];
    [btnZone setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnZone.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnZone setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnZone.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];

    btn3D.backgroundColor = [UIColor clearColor];
    [btn3D setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn3D.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btn3D setTitle:@"Viewer 3D" forState:UIControlStateNormal];
    [btn3D setExclusiveTouch:YES];
    [btn3D setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btn3D.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btn3D setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btn3D.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnUSDZ.backgroundColor = [UIColor clearColor];
    [btnUSDZ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnUSDZ.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnUSDZ setTitle:@"AR Quick Look (USDZ)" forState:UIControlStateNormal];
    [btnUSDZ setExclusiveTouch:YES];
    [btnUSDZ setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btn3D.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnUSDZ setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btn3D.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
}

@end
