//
//  TVC_InvoiceItem.m
//  ShoppingBH
//
//  Created by Erico GT on 03/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_InvoiceItem.h"

@implementation TVC_InvoiceItem

@synthesize lblTitle, lblPrice, lblDate, lblStatus, lblStatusDate, lblCOO, viewBackground, viewStatus, imvInvoice, spinner;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateLayout
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lblTitle.backgroundColor = nil;
    lblPrice.backgroundColor = nil;
    lblDate.backgroundColor = nil;
    lblCOO.backgroundColor = nil;
    lblStatus.backgroundColor = nil;
    lblStatusDate.backgroundColor = nil;
    viewStatus.backgroundColor = [UIColor grayColor];
    viewBackground.backgroundColor = [UIColor whiteColor];
    imvInvoice.backgroundColor = nil;
    spinner.backgroundColor = nil;
    //
    [ToolBox graphicHelper_ApplyShadowToView:viewBackground withColor:[UIColor blackColor] offSet:CGSizeMake(0.0, 1.0) radius:2.0 opacity:0.50];

    lblTitle.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_BOTTOM];
    lblTitle.textColor = [UIColor darkTextColor];
    //
    lblPrice.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:22.0];
    lblPrice.textColor = AppD.styleManager.colorPalette.backgroundNormal;
    //
    lblDate.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    lblDate.textColor = [UIColor darkTextColor];
    //
    lblCOO.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:14.0];
    lblCOO.textColor = [UIColor grayColor];
    //
    lblStatus.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    lblStatus.textColor = [UIColor whiteColor];
    //
    lblStatusDate.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    lblStatusDate.textColor = [UIColor whiteColor];
    
    lblTitle.text = @"";
    lblPrice.text = @"";
    lblDate.text = @"";
    lblCOO.text = @"";
    lblStatus.text = @"";
    lblStatusDate.text = @"";
    
    imvInvoice.image = nil;
    imvInvoice.alpha = 0.0;
    
    spinner.color = [UIColor lightGrayColor];
    [spinner setHidesWhenStopped:YES];
    [spinner stopAnimating];
}

@end
