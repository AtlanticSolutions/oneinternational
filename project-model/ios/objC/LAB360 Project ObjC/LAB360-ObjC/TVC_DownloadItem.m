//
//  TVC_DownloadItem.m
//  AHK-100anos
//
//  Created by Erico GT on 10/17/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_DownloadItem.h"

@implementation TVC_DownloadItem

@synthesize lblTitle, lblInfo, imvLine, imvArrow;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)updateLayout
{
    self.contentView.backgroundColor = [UIColor clearColor];
    //
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor darkGrayColor];
    lblTitle.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    //
    lblInfo.backgroundColor = [UIColor clearColor];
    lblInfo.textColor = AppD.styleManager.colorCalendarAvailable;
    lblInfo.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS];
    //
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    //
    imvArrow.backgroundColor = [UIColor clearColor];
    imvArrow.image = [[UIImage imageNamed:@"icon-right-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvArrow setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
}

@end
