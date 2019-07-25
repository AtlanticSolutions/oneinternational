//
//  VirtualShowcasePhotoResultVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VirtualShowcasePhotoResultVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VirtualShowcasePhotoResultVC()

@property (nonatomic, weak) IBOutlet UILabel *lblInstructions;
@property (nonatomic, weak) IBOutlet UIImageView *imvPhoto;
@property (nonatomic, weak) IBOutlet UIButton *btnShare;
@property (nonatomic, weak) IBOutlet UIButton *btnSaveToCollection;
//
@property (nonatomic, assign) BOOL isLoaded;

@end

#pragma mark - • IMPLEMENTATION
@implementation VirtualShowcasePhotoResultVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize photo, isLoaded;
@synthesize lblInstructions, imvPhoto, btnShare, btnSaveToCollection;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isLoaded = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self.view layoutIfNeeded];
        [self setupLayout];
        isLoaded = YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionSharePhoto:(id)sender
{
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[photo] applicationActivities:nil];
    if (IDIOM == IPAD){
        activityController.popoverPresentationController.sourceView = sender;
    }
    [self presentViewController:activityController animated:YES completion:^{
        NSLog(@"activityController presented");
    }];
    
    //AdAliveLog:
    [AppD logAdAliveEventWithName:@"VitrineVirtualPhotoShared" data:[NSDictionary new]];
}

- (IBAction)actionSavePhotoToCollection:(id)sender
{
    ShowcaseDataSource *SDS = [ShowcaseDataSource new];
        
    if ([SDS savePhoto:photo forUser:AppD.loggedUser.userID]){
        [btnSaveToCollection setUserInteractionEnabled:NO];
        [btnSaveToCollection setImage:[UIImage imageNamed:@"heart_fill"] forState:UIControlStateNormal];
        [btnSaveToCollection setTintColor:[UIColor redColor]];
        [btnSaveToCollection setBackgroundImage:nil forState:UIControlStateNormal];
        [btnSaveToCollection setBackgroundImage:nil forState:UIControlStateHighlighted];
        //
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
            self.navigationItem.rightBarButtonItem = [self createUserCollectionButton];
        }];
        [alert showSuccess:NSLocalizedString(@"ALERT_TITLE_SHOWCASE_USER_COLLECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SHOWCASE_USER_COLLECTION_ADD_SUCCESS", @"") closeButtonTitle:nil duration:0.0];
        
        //AdAliveLog:
        [AppD logAdAliveEventWithName:@"VitrineVirtualPhotoSaved" data:[NSDictionary new]];
        
    }else{
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:NSLocalizedString(@"ALERT_TITLE_SHOWCASE_USER_COLLECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SHOWCASE_USER_COLLECTION_ADD_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (void)simpleTapInPostAction:(UITapGestureRecognizer*)sender
{
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:photo backgroundImage:nil andDelegate:self];
    photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    photoView.autoresizingMask = (1 << 6) -1;
    photoView.alpha = 0.0;
    //
    [AppD.window addSubview:photoView];
    [AppD.window bringSubviewToFront:photoView];
    //
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 1.0;
    }];
}

- (void)showUserCollection:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToUserCollection" sender:self];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)photoViewDidHide:(VIPhotoView *)photoView
{
    __block id pv = photoView;
    
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [pv removeFromSuperview];
        pv = nil;
    }];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"showcase-background-default.jpg"]];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = @"Compartilhe!";
    
    lblInstructions.backgroundColor = nil;
    [lblInstructions setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:12.0]];
    [lblInstructions setTextColor:[UIColor whiteColor]];
    [lblInstructions setText:NSLocalizedString(@"LABEL_SHOWCASE_INSTRUCTION", @"")];
    
    imvPhoto.backgroundColor = nil;
    imvPhoto.contentMode = UIViewContentModeScaleAspectFit;
    imvPhoto.image = photo;
    [imvPhoto setUserInteractionEnabled:YES];
    [ToolBox graphicHelper_ApplyShadowToView:imvPhoto withColor:[UIColor blackColor] offSet:CGSizeMake(3.0, 3.0) radius:4.0 opacity:0.7];
    
    btnShare.backgroundColor = nil;
    [btnShare setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnShare.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnShare setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnShare.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    [btnShare setTitleColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal forState:UIControlStateNormal];
    [btnShare setImage:[[UIImage imageNamed:@"SharePhotoMask"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnShare setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    [btnShare setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    btnShare.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnShare.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnShare setTitle:NSLocalizedString(@"ALERT_SHEET_OPTION_SHARE", @"") forState:UIControlStateNormal];
    [btnShare setExclusiveTouch:YES];
    [btnShare setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    
    btnSaveToCollection.backgroundColor = nil;
    [btnSaveToCollection setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSaveToCollection.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnSaveToCollection setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSaveToCollection.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    [btnSaveToCollection setImage:[[UIImage imageNamed:@"heart_outline"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnSaveToCollection setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    [btnSaveToCollection setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    btnSaveToCollection.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnSaveToCollection setExclusiveTouch:YES];
    [btnSaveToCollection setTitle:@"" forState:UIControlStateNormal];
    
    UITapGestureRecognizer *simpleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(simpleTapInPostAction:)];
    [simpleTapGesture setNumberOfTapsRequired:1];
    [simpleTapGesture setNumberOfTouchesRequired:1];
    //simpleTapGesture.delegate = self;
    [imvPhoto addGestureRecognizer:simpleTapGesture];
}

- (UIBarButtonItem*)createUserCollectionButton
{
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.backgroundColor = nil;
    collectionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *img = [[UIImage imageNamed:@"PhotoUserCollection"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [collectionButton setImage:img forState:UIControlStateNormal];
    //
    [collectionButton setFrame:CGRectMake(0, 0, 32, 32)];
    [collectionButton setClipsToBounds:YES];
    [collectionButton setExclusiveTouch:YES];
    [collectionButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [collectionButton addTarget:self action:@selector(showUserCollection:) forControlEvents:UIControlEventTouchUpInside];
    //
    [collectionButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    //
    [[collectionButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[collectionButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:collectionButton];
}

@end
