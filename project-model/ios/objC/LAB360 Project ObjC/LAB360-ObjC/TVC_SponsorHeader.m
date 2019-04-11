//
//  TVC_SponsorHeader.m
//  GS&MD
//
//  Created by Lab360 on 01/09/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_SponsorHeader.h"
#import "ConstantsManager.h"
#import "AppDelegate.h"

@implementation TVC_SponsorHeader
@synthesize lblTitle;

- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
}

-(void) updateLayout
{
	self.backgroundColor = AppD.styleManager.colorPalette.backgroundLight;
	
	[lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_LARGE]];
	[lblTitle setTextColor:AppD.styleManager.colorPalette.backgroundNormal];
	lblTitle.backgroundColor = [UIColor clearColor];

}

@end
