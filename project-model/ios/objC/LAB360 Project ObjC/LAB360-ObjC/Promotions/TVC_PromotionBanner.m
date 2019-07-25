//
//  TVC_PromotionBanner.m
//  ShoppingBH
//
//  Created by Erico GT on 01/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_PromotionBanner.h"

@implementation TVC_PromotionBanner

@synthesize baseView, imvBanner, btnRegister, btnTermsAndRules, activityIndicator, lblRegistered;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateLayout
{
    [self layoutIfNeeded];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    //Background:
    baseView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    imvBanner.backgroundColor = [UIColor darkGrayColor];
    btnRegister.backgroundColor = nil;
    btnTermsAndRules.backgroundColor = nil;
    lblRegistered.backgroundColor = COLOR_MA_BLUE;
    
    //Texts:
    [btnRegister setTitle:@"" forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnRegister setExclusiveTouch:YES];
    [btnRegister setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnRegister.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
    //
    [btnTermsAndRules setTitle:@"" forState:UIControlStateNormal];
    [btnTermsAndRules setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTermsAndRules.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:14.0];
    [btnTermsAndRules setExclusiveTouch:YES];
    [btnTermsAndRules setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnRegister.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:[UIColor grayColor]] forState:UIControlStateNormal];
    
    //Image:
    imvBanner.image = nil;
    
    //Label:
    lblRegistered.backgroundColor = COLOR_MA_GREEN;
    [lblRegistered setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:14.0]];
    [lblRegistered setTextColor:[UIColor whiteColor]];
    lblRegistered.text = NSLocalizedString(@"LABEL_PROMOTION_ALREADY_REGISTERED", @"");
    lblRegistered.layer.cornerRadius = lblRegistered.frame.size.height/2.0;
    lblRegistered.layer.borderColor = [UIColor whiteColor].CGColor;
    lblRegistered.layer.borderWidth = 1.0;
    lblRegistered.clipsToBounds = YES;
    
    activityIndicator.color = [UIColor whiteColor];
    [activityIndicator setHidesWhenStopped:YES];
    [activityIndicator stopAnimating];
    
    [ToolBox graphicHelper_ApplyShadowToView:baseView withColor:[UIColor blackColor] offSet:CGSizeMake(0.0, 1.0) radius:2.0 opacity:0.50];
}

@end
