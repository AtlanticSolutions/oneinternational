//
//  TVC_NewsItem.m
//  AHK-100anos
//
//  Created by Erico GT on 10/31/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_NewsItem.h"

@implementation TVC_NewsItem

@synthesize lblTitle, lblSummary, imvPhoto, imvLine, indicator;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void) updateLayout
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [lblTitle setTextColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    lblTitle.backgroundColor = [UIColor clearColor];
    //
    [lblSummary setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL]];
    [lblSummary setTextColor:AppD.styleManager.colorCalendarAvailable];
    lblSummary.backgroundColor = [UIColor clearColor];
    //
    imvPhoto.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
    //
    indicator.color = AppD.styleManager.colorCalendarSelected;
    //
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    
}

@end
