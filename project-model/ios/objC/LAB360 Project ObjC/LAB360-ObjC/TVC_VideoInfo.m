//
//  TVC_VideoInfo.m
//  GS&MD
//
//  Created by Erico GT on 12/2/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_VideoInfo.h"

@implementation TVC_VideoInfo

@synthesize lblTitle, lblTime, imvLine, imvThumbnail, activityIndicator;

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
    
    [lblTitle setBackgroundColor:nil];
    [lblTime setBackgroundColor:nil];
    [imvLine setBackgroundColor:nil];
    [imvThumbnail setBackgroundColor:nil];
    //
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [lblTitle setTextColor:AppD.styleManager.colorPalette.backgroundNormal];
    //
    [lblTime setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [lblTime setTextColor: [UIColor lightGrayColor]];
    //
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    //
    imvThumbnail.image = nil;
    //
    activityIndicator.color = AppD.styleManager.colorPalette.backgroundNormal;
    [activityIndicator setHidesWhenStopped:YES];
    [activityIndicator stopAnimating];
}
@end
