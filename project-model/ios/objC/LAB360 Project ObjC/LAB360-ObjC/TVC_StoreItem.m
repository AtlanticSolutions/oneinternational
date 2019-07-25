//
//  TVC_StoreItem.m
//  ShoppingBH
//
//  Created by Erico GT on 06/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_StoreItem.h"

@implementation TVC_StoreItem

@synthesize lblTitle, lblDescription1, lblDescription2, lblDescription3, imvLogo, spinner;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateLayout
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Background:
    lblTitle.backgroundColor = nil;
    lblDescription1.backgroundColor = nil;
    lblDescription2.backgroundColor = nil;
    lblDescription3.backgroundColor = nil;
    imvLogo.backgroundColor = nil;
    spinner.backgroundColor = nil;
    
    //Labels:
    lblTitle.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:22.0];
    lblTitle.textColor = AppD.styleManager.colorPalette.backgroundNormal;
    //
    lblDescription1.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    lblDescription1.textColor = [UIColor darkTextColor];
    lblDescription2.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    lblDescription2.textColor = [UIColor darkTextColor];
    lblDescription3.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    lblDescription3.textColor = [UIColor darkTextColor];
    
    //Image:
    imvLogo.image = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
    [imvLogo cancelImageRequestOperation];
    
    spinner.color = AppD.styleManager.colorPalette.backgroundNormal;
    [spinner setHidesWhenStopped:YES];
    [spinner stopAnimating];
    
    
}

@end
