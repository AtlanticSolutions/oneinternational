//
//  VC_MA_About.m
//  GS&MD
//
//  Created by Erico GT on 05/12/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_About.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_About()

@property (nonatomic, weak) IBOutlet UIImageView *imvBackground;
@property (nonatomic, weak) IBOutlet UIScrollView *baseScrollView;
@property (nonatomic, weak) IBOutlet UIButton *btnLogo;
@property (nonatomic, weak) IBOutlet UILabel *lblDev;
@property (nonatomic, weak) IBOutlet UILabel *lblVersion;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_About
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize imvBackground, baseScrollView, btnLogo, lblDev, lblVersion;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //Button Profile Pic
    //self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_ABOUT", @"");
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //TODO:
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionLogoDev:(id)sender
{
    //TODO: verificar a URL correta
    //    NSURL *url = [NSURL URLWithString:@"http://atlanticsolutions.com.br"];
    //    if ([[UIApplication sharedApplication] canOpenURL:url]) {
    //        [[UIApplication sharedApplication] openURL:url];
    //    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Background Image
    imvBackground.backgroundColor = nil;
    //imvBackground.image = [UIImage imageNamed:@"ma-background-insurance-life.jpg"];
    
    //ScrollView
    baseScrollView.backgroundColor = [UIColor clearColor];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    baseScrollView.contentInset = contentInsets;
    baseScrollView.scrollIndicatorInsets = contentInsets;
    
    [btnLogo setBackgroundColor:[UIColor clearColor]];
    [btnLogo setTitle:@"" forState:UIControlStateNormal];
    [btnLogo.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnLogo setImage:[UIImage imageNamed:@"button-lab"] forState:UIControlStateNormal];
    //
    lblDev.textColor = [UIColor darkGrayColor];
    lblDev.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL];
    lblDev.text = NSLocalizedString(@"LABEL_APP_DEVELOPED_BY", @"");
    //
    lblVersion.textColor = [UIColor darkGrayColor];
    lblVersion.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL];
    NSString *sei = [AppD serverEnvironmentIdentifier];
    lblVersion.text = [NSString stringWithFormat:@"%@: %@ %@", NSLocalizedString(@"LABEL_APP_VERSION", @""),[ToolBox applicationHelper_VersionBundle], sei];
    
}

@end

