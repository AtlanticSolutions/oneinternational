//
//  CustomSurveyGroupItemTVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 09/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyGroupItemTVC.h"
#import "ConstantsManager.h"

@implementation CustomSurveyGroupItemTVC

@synthesize lblTitle, lblComplete, imvBackground;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor whiteColor];
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblTitle.text = @"";
    
    lblComplete.backgroundColor = [UIColor clearColor];
    lblComplete.textColor = [UIColor lightGrayColor];
    [lblComplete setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    lblComplete.text = @"";
    
    imvBackground.backgroundColor = [UIColor darkGrayColor];
    imvBackground.layer.cornerRadius = 5.0;
}

@end
