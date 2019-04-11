//
//  TVC_Comment.m
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 18/01/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_Comment.h"

@implementation TVC_Comment

@synthesize lblDate, lblName, lblComment, imvProfile, imvLine;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateLayout
{
    self.backgroundColor = [UIColor clearColor];
    
    lblComment.backgroundColor = [UIColor clearColor];
    lblName.backgroundColor = [UIColor clearColor];
    lblDate.backgroundColor = [UIColor clearColor];
    
    lblName.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:FONT_SIZE_TITLE_NAVBAR];
    lblDate.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL];
    lblComment.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NORMAL];
    
    lblComment.textColor = AppD.styleManager.colorPalette.textDark;
    lblName.textColor = AppD.styleManager.colorPalette.primaryButtonSelected;
    lblDate.textColor = AppD.styleManager.colorCalendarAvailable;
    
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    
    imvProfile.layer.cornerRadius = imvProfile.bounds.size.width/2;
    [imvProfile setClipsToBounds:YES];
    
    lblComment.numberOfLines = 0;
}

@end
