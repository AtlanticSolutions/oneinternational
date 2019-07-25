//
//  GenericFormItemTVC.m
//  Siga
//
//  Created by Erico GT on 29/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "GenericFormItemTVC.h"
#import "ConstantsManager.h"

@implementation GenericFormItemTVC

@synthesize lblParameterName, txtParameterValue, imvPicture, imvIcon, leftIconConstraint;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)setupLayoutWithInputAccessoryView:(UIView*)iav usingIcon:(UIImage*)icon
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lblParameterName.backgroundColor = [UIColor clearColor];
    lblParameterName.textColor = [UIColor grayColor];
    [lblParameterName setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblParameterName.text = @"";
    
    txtParameterValue.backgroundColor = [UIColor clearColor];
    [txtParameterValue setTextAlignment:NSTextAlignmentRight];
    [txtParameterValue setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [txtParameterValue setAdjustsFontSizeToFitWidth:YES];
    [txtParameterValue setMinimumFontSize:9];
    [txtParameterValue setClearButtonMode:UITextFieldViewModeWhileEditing];
    [txtParameterValue setKeyboardType:UIKeyboardTypeDefault];
    [txtParameterValue setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [txtParameterValue setInputAccessoryView:iav];
    [txtParameterValue setEnabled:YES];
    [txtParameterValue setHidden:NO];
    
    imvIcon.backgroundColor = [UIColor clearColor];
    imvIcon.contentMode = UIViewContentModeScaleAspectFit;
    
    if (icon){
        [imvIcon setHidden:NO];
        leftIconConstraint.constant = 10.0 + imvIcon.frame.size.width;
        imvIcon.image = icon;
    }else{
        [imvIcon setHidden:YES];
        leftIconConstraint.constant = 10.0;
        imvIcon.image = nil;
    }
    
    imvPicture.backgroundColor = [UIColor clearColor];
    imvPicture.image = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
    imvPicture.contentMode = UIViewContentModeScaleAspectFill;
    //
    [imvPicture setClipsToBounds:YES];
    imvPicture.layer.cornerRadius = imvPicture.frame.size.height / 2.0;
    [imvPicture setHidden:YES];
    
    [self layoutIfNeeded];
}

@end

