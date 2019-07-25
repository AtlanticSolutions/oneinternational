//
//  TVC_SpeakerCell.m
//  GS&MD
//
//  Created by Lab360 on 29/08/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_SpeakerCell.h"

@implementation TVC_SpeakerCell

@synthesize speakerPhoto, imvLine, lblSpeakerName, lblSpeakerTitle, lblSpeakerDescription;

- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

-(void) updateLayout
{
	self.backgroundColor = [UIColor clearColor];
	
	[speakerPhoto setBackgroundColor:[UIColor clearColor]];
	speakerPhoto.layer.borderColor = [UIColor grayColor].CGColor;
	speakerPhoto.layer.borderWidth = 1.0;
	speakerPhoto.layer.cornerRadius = speakerPhoto.bounds.size.width/2;
	[speakerPhoto setClipsToBounds:YES];
	[speakerPhoto setContentMode:UIViewContentModeScaleAspectFit];
	
	lblSpeakerName.backgroundColor = [UIColor clearColor];
	[lblSpeakerName setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
	[lblSpeakerName setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
	
	[lblSpeakerTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_SMALL]];
	[lblSpeakerTitle setTextColor:AppD.styleManager.colorCalendarAvailable];
	lblSpeakerTitle.backgroundColor = [UIColor clearColor];
	
	[lblSpeakerDescription setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
	[lblSpeakerDescription setTextColor: [UIColor blackColor]];
	lblSpeakerDescription.backgroundColor = [UIColor clearColor];
	
	imvLine.backgroundColor = [UIColor clearColor];
	imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[imvLine setTintColor:[UIColor lightGrayColor]];
}

@end
