//
//  TVC_EventItem.m
//  AHK-100anos
//
//  Created by Erico GT on 10/11/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_EventItem.h"

@implementation TVC_EventItem

@synthesize lblTitle, lblDate, lblPeriod, imvLine, imvIcon, lblStatus;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)updateLayoutForRegistered:(bool)registered;
{
    self.contentView.backgroundColor = [UIColor clearColor];
    //
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textColor = AppD.styleManager.colorPalette.textDark;
    lblDate.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    //
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = AppD.styleManager.colorPalette.primaryButtonSelected;
    lblTitle.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    //
    lblPeriod.backgroundColor = [UIColor clearColor];
    lblPeriod.textColor = [UIColor grayColor];
    lblPeriod.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS];
    //
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    //
    imvIcon.backgroundColor = [UIColor clearColor];
    //
    lblStatus.backgroundColor = [UIColor clearColor];
    lblStatus.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL];
    //
    if (registered){
        lblStatus.textColor = AppD.styleManager.colorCalendarRegistered;
        imvIcon.image = [UIImage imageNamed:@"icon-checkmark"];
        [imvIcon setTintColor:[UIColor clearColor]];
    }else{
        lblStatus.textColor = AppD.styleManager.colorCalendarAvailable;
        imvIcon.image = [[UIImage imageNamed:@"icon-pencil"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [imvIcon setTintColor:AppD.styleManager.colorPalette.primaryButtonSelected];
    }
}

@end
