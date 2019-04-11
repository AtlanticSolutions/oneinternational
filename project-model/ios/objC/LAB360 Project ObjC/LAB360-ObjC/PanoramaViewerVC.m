//
//  PanoramaViewerVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 09/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "PanoramaViewerVC.h"
#import "CTPanoramaView-Swift.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface PanoramaViewerVC()<UINavigationControllerDelegate>

//Layout:
@property(nonatomic, weak) IBOutlet CTPanoramaView *panoramaView;
@property(nonatomic, strong) UIBarButtonItem *btnControlMethod;

//Data:

@end

#pragma mark - • IMPLEMENTATION
@implementation PanoramaViewerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize panoramaItem;
@synthesize panoramaView, btnControlMethod;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionChangeOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        return NO;
    }else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        return YES;
    }
    return NO;
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionChangeControlMethod:(id)sender
{
    if (panoramaView.controlMethod == CTPanoramaControlMethodTouch) {
        panoramaView.controlMethod = CTPanoramaControlMethodMotion;
    }
    else {
        panoramaView.controlMethod = CTPanoramaControlMethodTouch;
    }
    
    [self updateControlMethodButton];
}

- (void)actionChangeOrientation:(NSNotification*)notification
{    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self setNeedsStatusBarAppearanceUpdate];
    }else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    //
    self.navigationItem.title = panoramaItem.itemName;
    
    panoramaView.backgroundColor = [UIColor blackColor];
    panoramaView.image = panoramaItem.originalImage;
    panoramaView.controlMethod = CTPanoramaControlMethodTouch;
    
    [self updateControlMethodButton];
}

- (void)updateControlMethodButton;
{
    UIImage *image = nil;
    if (panoramaView.controlMethod == CTPanoramaControlMethodTouch) {
        image = [UIImage imageNamed:@"PanoramaGalleryControlMotion"];
    }else{
        image = [UIImage imageNamed:@"PanoramaGalleryControlTouch"];
    }
    //
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    UIImage *img = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    [userButton setFrame:CGRectMake(0, 0, 32, 32)];
    [userButton setClipsToBounds:YES];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(actionChangeControlMethod:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    self.navigationItem.rightBarButtonItem = b;
}

@end
