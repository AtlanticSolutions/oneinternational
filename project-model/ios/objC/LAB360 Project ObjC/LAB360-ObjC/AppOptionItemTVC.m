//
//  AppOptionItemTVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AppOptionItemTVC.h"
#import "ConstantsManager.h"

@implementation AppOptionItemTVC

@synthesize lblTitle, lblDescription, swtOption, imvArrow, leftLabelConstraint;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)setupLayoutForType:(AppOptionItemCellType)type
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
    
    swtOption.onTintColor = COLOR_MA_BLUE;
    
    imvArrow.backgroundColor = [UIColor clearColor];
    imvArrow.image = [[UIImage imageNamed:@"RightPaddingArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imvArrow.tintColor = [UIColor grayColor];
    imvArrow.contentMode = UIViewContentModeScaleAspectFit;
    
    [swtOption setHidden:YES];
    [imvArrow setHidden:YES];
    
    switch (type) {
        case AppOptionItemCellTypeNone:{
            leftLabelConstraint.constant = 10.0;
        }break;
            
        case AppOptionItemCellTypeSwitch:{
            leftLabelConstraint.constant = 10.0 + 5.0 + swtOption.frame.size.width;
            [swtOption setHidden:NO];
        }break;
            
        case AppOptionItemCellTypeArrow:{
            leftLabelConstraint.constant = 10.0 + 5.0 + imvArrow.frame.size.width;
            [imvArrow setHidden:NO];
        }break;
    }
    
    [self.lblDescription setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}

@end
