//
//  TVC_ShopOrderItems.m
//  GS&MD
//
//  Created by Erico GT on 17/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_ShopOrderItems.h"

@implementation TVC_ShopOrderItems

@synthesize lblProductTitle, lblProductSize, lblSubTotal, lblAmount, btnPlus, btnMinus, btnDelete;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) updateLayoutWithIndex:(long)index
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    //Background:
    lblProductTitle.backgroundColor = nil;
    lblProductSize.backgroundColor = nil;
    lblSubTotal.backgroundColor = nil;
    lblAmount.backgroundColor = nil;
    btnPlus.backgroundColor = nil;
    btnMinus.backgroundColor = nil;
    btnDelete.backgroundColor = nil;
    
    //Texts:
    [lblProductTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:18.0]];
    [lblProductTitle setTextColor:[UIColor darkGrayColor]];
    lblProductTitle.text = @"";
    //
    [lblProductSize setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [lblProductSize setTextColor:[UIColor darkGrayColor]];
    lblProductSize.text = @"";
    //
    [lblSubTotal setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [lblSubTotal setTextColor:[UIColor darkGrayColor]];
    lblSubTotal.text = @"";
    //
    [lblAmount setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:28.0]];
    [lblAmount setTextColor:[UIColor darkGrayColor]];
    lblAmount.text = @"";
    
    [btnPlus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPlus.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:30.0];
    [btnPlus setTitle:@"+" forState:UIControlStateNormal];
    [btnPlus setExclusiveTouch:YES];
    [btnPlus setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnPlus.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(btnPlus.frame.size.width / 2.0, btnPlus.frame.size.width / 2.0) andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
    
    [btnMinus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnMinus.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:30.0];
    [btnMinus setTitle:@"-" forState:UIControlStateNormal];
    [btnMinus setExclusiveTouch:YES];
    [btnMinus setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnMinus.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(btnMinus.frame.size.width / 2.0, btnMinus.frame.size.width / 2.0) andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
    
    [btnDelete setTitle:@"" forState:UIControlStateNormal];
    [btnDelete setImage:[[UIImage imageNamed:@"icon-order-trash.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnDelete setTintColor: COLOR_MA_RED];
    [btnDelete setExclusiveTouch:YES];
    
    btnPlus.tag = index;
    btnMinus.tag = index;
    btnDelete.tag = index;
    
}

@end
