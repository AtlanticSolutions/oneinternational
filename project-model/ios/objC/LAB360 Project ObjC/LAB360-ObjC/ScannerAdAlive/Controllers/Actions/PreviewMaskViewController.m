//
//  PreviewMaskViewController.m
//  AdAlive
//
//  Created by macbook on 30/04/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <Social/Social.h>
#import "PreviewMaskViewController.h"

@interface PreviewMaskViewController ()

@property(nonatomic, weak) IBOutlet UIImageView *previewImageView;
@property(nonatomic, weak) IBOutlet UIButton *btnSave;
@property(nonatomic, weak) IBOutlet UIButton *btnShare;

@end

@implementation PreviewMaskViewController

@synthesize previewImage, previewImageView, btnSave, btnShare;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    self.previewImageView.image = self.previewImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Methods

-(IBAction)tapCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-(IBAction)tapSaveButton:(id)sender
//{
//    UIImageWriteToSavedPhotosAlbum(self.previewImage, nil, nil, nil);
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Salvo", @"Message") message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
//}

-(IBAction)tapShareButton:(id)sender
{
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[previewImageView.image] applicationActivities:nil];
    if (IDIOM == IPAD){
        activityController.popoverPresentationController.sourceView = sender;
    }
    [self presentViewController:activityController animated:YES completion:^{
        NSLog(@"activityController presented");
    }];
}

- (void)setupLayout
{
    //Background
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
    
    previewImageView.backgroundColor = nil;
    
    //Salvar
//    btnSave.backgroundColor = nil;
//    [btnSave setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSave.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
//    [btnSave setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSave.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
//    [btnSave setTitleColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal forState:UIControlStateNormal];
//    [btnSave setImage:[[UIImage imageNamed:@"SavePhotoMask"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//    [btnSave setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
//    [btnSave setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 15)];
//    btnSave.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    btnSave.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:12.0];
//    [btnSave setTitle:NSLocalizedString(@"BUTTON_TITLE_100_PHOTO_SAVE", @"") forState:UIControlStateNormal];
//    [btnSave setExclusiveTouch:YES];
//    [btnSave setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    
    //Compartilhar
    btnShare.backgroundColor = nil;
    [btnShare setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnShare.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnShare setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnShare.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    [btnShare setTitleColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal forState:UIControlStateNormal];
    [btnShare setImage:[[UIImage imageNamed:@"SharePhotoMask"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnShare setTintColor:AppD.styleManager.colorPalette.secondaryButtonTitleNormal];
    [btnShare setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    btnShare.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnShare.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:12.0];
    [btnShare setTitle:NSLocalizedString(@"ALERT_SHEET_OPTION_SHARE", @"") forState:UIControlStateNormal];
    [btnShare setExclusiveTouch:YES];
    [btnShare setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];

    
    //Navigation Controller
//    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
//    self.navigationItem.title = @"Mask";
//
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
}

@end
