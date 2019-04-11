//
//  AppOptionLanguageItemTVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 05/09/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AppOptionLanguageItemTVC.h"

#import "AppOptionLanguageItemTVC.h"
#import "ConstantsManager.h"

@implementation AppOptionLanguageItemTVC

@synthesize lblTitle, imvFlag, imvCheck;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)setupLayoutForSelectedItem:(BOOL)selected
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor darkGrayColor];
    lblTitle.text = @"";
    
    imvFlag.backgroundColor = [UIColor clearColor];
    imvFlag.image = nil;
    imvFlag.contentMode = UIViewContentModeScaleAspectFit;
    
    imvCheck.backgroundColor = [UIColor clearColor];
    imvCheck.contentMode = UIViewContentModeScaleAspectFit;
    
    if (selected){
        [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
        imvCheck.image = [UIImage imageNamed:@"icon-checkmark"];
    }else{
        [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
        imvCheck.image = nil;
    }
}

@end
