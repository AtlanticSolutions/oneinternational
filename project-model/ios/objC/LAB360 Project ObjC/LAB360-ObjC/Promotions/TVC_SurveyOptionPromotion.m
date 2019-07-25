//
//  TVC_SurveyOptionPromotion.m
//  ShoppingBH
//
//  Created by Erico GT on 01/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_SurveyOptionPromotion.h"

@implementation TVC_SurveyOptionPromotion

@synthesize imvRadioOption, lblTitleOption;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateLayout
{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    //Image
    imvRadioOption.backgroundColor = nil;
    imvRadioOption.tintColor = [UIColor darkGrayColor];
    imvRadioOption.image = nil;
    
    //Text
    lblTitleOption.backgroundColor = nil;
    [lblTitleOption setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [lblTitleOption setTextColor:[UIColor darkGrayColor]];
    
}

@end
