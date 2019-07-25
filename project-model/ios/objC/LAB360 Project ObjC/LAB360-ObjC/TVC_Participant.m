//
//  TVC_VideoInfo.m
//  GS&MD
//
//  Created by Erico GT on 12/2/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_Participant.h"

@implementation TVC_Participant

@synthesize lblTitle, lblTime, imvLine, lblRole, imvThumbnail, activityIndicator;

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

    [imvLine setBackgroundColor:nil];
    [imvThumbnail setBackgroundColor:nil];
    //
	
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [lblTitle setTextColor:AppD.styleManager.colorPalette.backgroundNormal];
	[lblTitle setBackgroundColor:nil];
    //
    [lblTime setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [lblTime setTextColor: [UIColor lightGrayColor]];
	[lblTime setBackgroundColor:nil];
	
	[lblRole setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
	[lblRole setTextColor: [UIColor lightGrayColor]];
	[lblRole setBackgroundColor:nil];
    //
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    //
    imvThumbnail.image = nil;
	[imvThumbnail setBackgroundColor:[UIColor clearColor]];
	imvThumbnail.layer.borderColor = [UIColor grayColor].CGColor;
	imvThumbnail.layer.borderWidth = 1.0;
	imvThumbnail.layer.cornerRadius = imvThumbnail.bounds.size.width/2;
	[imvThumbnail setClipsToBounds:YES];
	[imvThumbnail setContentMode:UIViewContentModeScaleAspectFit];

	
	
	
    //
    activityIndicator.color = AppD.styleManager.colorPalette.backgroundNormal;
    [activityIndicator setHidesWhenStopped:YES];
    [activityIndicator stopAnimating];
}
@end
