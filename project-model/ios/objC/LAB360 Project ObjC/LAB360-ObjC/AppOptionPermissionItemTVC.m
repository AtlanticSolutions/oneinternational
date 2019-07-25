//
//  AppOptionPermissionItemTVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 16/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AppOptionPermissionItemTVC.h"
#import "ConstantsManager.h"

@implementation AppOptionPermissionItemTVC

@synthesize lblTitle, lblDescription, imvStatus, lblStatus;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)setupLayout
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor darkGrayColor];
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblTitle.text = @"";
    
    lblDescription.backgroundColor = [UIColor clearColor];
    lblDescription.textColor = [UIColor grayColor];
    [lblDescription setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    lblDescription.text = @"";
    
    imvStatus.backgroundColor = [UIColor clearColor];
    imvStatus.image = nil;
    
    lblStatus.backgroundColor = [UIColor clearColor];
    lblStatus.textColor = [UIColor darkGrayColor];
    [lblStatus setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    lblStatus.text = @"";
    
    [self layoutIfNeeded];
}

@end
