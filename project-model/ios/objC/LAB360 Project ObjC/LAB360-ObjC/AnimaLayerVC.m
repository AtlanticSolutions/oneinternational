//
//  AnimaLayerVC.m
//  LAB360-Dev
//
//  Created by Erico GT on 28/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "AnimaLayerVC.h"
#import "AppDelegate.h"
#import "LoadingViewLAB360.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AnimaLayerVC()

//Data:

//Layout:
@property (nonatomic, weak) IBOutlet LoadingViewLAB360 *logoView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) LoadingViewLAB360 *manualLogoView;

@end

#pragma mark - • IMPLEMENTATION
@implementation AnimaLayerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize logoView, containerView, manualLogoView;

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
    
    [self setupLayout:@"Anima Layer"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    manualLogoView = [LoadingViewLAB360 newLoadingViewWithFrame:CGRectMake(0.0, 0.0, containerView.frame.size.width, containerView.frame.size.height) primaryColor:[UIColor blackColor] andSecondaryColor:[UIColor purpleColor]];
    [containerView addSubview:manualLogoView];
    [manualLogoView startAnimating];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    if ([segue.identifier isEqualToString:@"???"]){
//        AppOptionsVC *vc = segue.destinationViewController;
//    }
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionAnimateOnce:(id)sender
{
    [logoView setBackgroundColor:[UIColor clearColor]];
    [logoView setLogoBackgroundColor:[UIColor blueColor]];
    [logoView setLogoBackgroundImage:nil];
    logoView.logoPrimaryColor = [UIColor yellowColor];
    logoView.logoSecondaryColor = [UIColor redColor];
    //
    [logoView startOnceAnimation];
}

- (IBAction)actionAnimateForever:(id)sender
{
    [logoView setBackgroundColor:[UIColor clearColor]];
    [logoView setLogoBackgroundColor:[UIColor clearColor]];
    [logoView setLogoBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(logoView.frame.size.height, logoView.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(logoView.frame.size.height / 2.0, logoView.frame.size.height / 2.0) andColor:[UIColor colorWithWhite:0.0 alpha:0.15]]];
    logoView.logoPrimaryColor = [UIColor whiteColor];
    logoView.logoSecondaryColor = [UIColor blackColor];
    //
    [logoView startAnimating];
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
