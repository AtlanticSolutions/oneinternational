//
//  TVC_Notifications.m
//  GS&MD
//
//  Created by Lab360 on 06/09/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_Notifications.h"
#import "AppDelegate.h"

@interface TVC_Notifications()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintLeftPadding;

@end

@implementation TVC_Notifications

@synthesize lblDescription, imvLine, imvArrow, constraintLeftPadding;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) updateLayoutWithArrowVisible:(bool)arrowVisible;
{
	self.backgroundColor = [UIColor clearColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	//
	lblDescription.backgroundColor = [UIColor clearColor];
	[lblDescription setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NORMAL]];
	[lblDescription setTextColor:[UIColor grayColor]];
	//
	imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[imvLine setTintColor:[UIColor lightGrayColor]];
	//
	imvArrow.backgroundColor = nil;
	imvArrow.image = [[UIImage imageNamed:@"icon-right-arrow-light.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	imvArrow.tintColor = [UIColor darkGrayColor];
	//
	if (arrowVisible){
		imvArrow.alpha = 1.0;
		constraintLeftPadding.constant = 30.0;
	}else{
		imvArrow.alpha = 0.0;
		constraintLeftPadding.constant = 8.0;
	}
	[self layoutIfNeeded];
}

@end
