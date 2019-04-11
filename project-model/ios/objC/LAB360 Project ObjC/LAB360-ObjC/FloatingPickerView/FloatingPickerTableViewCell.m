//
//  FloatingPickerTableViewCell.m
//  LAB360-ObjC
//
//  Created by Erico GT on 17/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "FloatingPickerTableViewCell.h"
#import "AppDelegate.h"

@implementation FloatingPickerTableViewCell

@synthesize lblText, imvCheck, containerView, selectedBackgroundColor;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    selectedBackgroundColor = [UIColor groupTableViewBackgroundColor];
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void) updateLayoutForSelectedElement:(BOOL)isSelected
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [containerView setClipsToBounds:YES];
    containerView.layer.cornerRadius = 4.0;
    
    lblText.backgroundColor = [UIColor clearColor];
    lblText.text = @"";
    lblText.textColor = [UIColor darkTextColor];
    lblText.textAlignment = NSTextAlignmentLeft;
    
    imvCheck.backgroundColor = [UIColor clearColor];
    [imvCheck setContentMode:UIViewContentModeScaleAspectFit];
    
    if (isSelected){
        containerView.backgroundColor = selectedBackgroundColor;
        lblText.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
        imvCheck.image = [UIImage imageNamed:@"FPV_ElementChecked"];
    }else{
        containerView.backgroundColor = [UIColor whiteColor];
        lblText.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
        imvCheck.image = [UIImage imageNamed:@"FPV_ElementUnchecked"];
    }
}

@end
