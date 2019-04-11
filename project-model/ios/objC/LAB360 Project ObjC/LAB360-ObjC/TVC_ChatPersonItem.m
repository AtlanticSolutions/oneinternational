//
//  TVC_ChatPersonItem.m
//  GS&MD
//
//  Created by Erico GT on 1/30/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_ChatPersonItem.h"
#import "AppDelegate.h"

@implementation TVC_ChatPersonItem

@synthesize lblTitle, lblNote, imvLine, imvArrow, lblLocal;

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
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [lblTitle setTextColor:AppD.styleManager.colorPalette.textDark];
    lblTitle.backgroundColor = [UIColor clearColor];
    //
    [lblNote setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL]];
    [lblNote setTextColor:[UIColor grayColor]];
    lblNote.backgroundColor = [UIColor clearColor];
	//
	[lblLocal setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL]];
	[lblLocal setTextColor:[UIColor grayColor]];
	lblLocal.backgroundColor = [UIColor clearColor];
    //
    imvArrow.backgroundColor = [UIColor clearColor];
    imvArrow.image = [[UIImage imageNamed:@"icon-right-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvArrow setTintColor:AppD.styleManager.colorPalette.textDark];
    //
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    
}

@end
