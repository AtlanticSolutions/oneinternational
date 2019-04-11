//
//  TVC_DayEventItem.m
//  AHK-100anos
//
//  Created by Erico GT on 10/13/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_DayEventItem.h"

@implementation TVC_DayEventItem

@synthesize lblHourStart, lblHourFinish, lblTitle, imvLine, imvDivisor, lblStatus;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateLayoutForRegistered:(bool)registered;
{
    self.contentView.backgroundColor = [UIColor clearColor];
    //
    lblHourStart.backgroundColor = [UIColor clearColor];
    lblHourStart.textColor = AppD.styleManager.colorPalette.textDark;
    lblHourStart.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
    //
    lblHourFinish.backgroundColor = [UIColor clearColor];
    lblHourFinish.textColor = AppD.styleManager.colorCalendarAvailable;
    lblHourFinish.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS];
    //
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = AppD.styleManager.colorPalette.textDark;
    lblTitle.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
    //
    lblStatus.backgroundColor = [UIColor clearColor];
    lblStatus.textColor = AppD.styleManager.colorCalendarAvailable;
    lblStatus.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL];
    //
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    //
    if (registered){
        lblStatus.textColor = AppD.styleManager.colorCalendarRegistered;
        //imvIcon.image = [[UIImage imageNamed:@"icon-check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[imvIcon setTintColor:AppD.styleManager.colorCalendarRegistered];
        imvDivisor.backgroundColor = AppD.styleManager.colorCalendarRegistered;
    }else{
        lblStatus.textColor = AppD.styleManager.colorCalendarAvailable;
        //imvIcon.image = [[UIImage imageNamed:@"icon-pencil"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[imvIcon setTintColor:AppD.styleManager.colorCalendarAvailable];
        imvDivisor.backgroundColor = AppD.styleManager.colorCalendarAvailable;
    }
}

@end
