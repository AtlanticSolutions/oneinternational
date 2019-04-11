//
//  TVC_SideMenuFooter.m
//  AHK-100anos
//
//  Created by Erico GT on 10/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_SideMenuFooter.h"

@implementation TVC_SideMenuFooter

@synthesize button1, lblDev, lblVersion;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateLayout
{
    self.backgroundColor = [UIColor clearColor];
    //
    [button1 setBackgroundColor:[UIColor clearColor]];
    //
    [button1 setTitle:@"" forState:UIControlStateNormal];
    [button1 setTitle:@"" forState:UIControlStateHighlighted];
    [button1.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //
	lblDev.textColor = [UIColor darkGrayColor]; //AppD.styleManager.colorTextNormal;
    lblDev.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL];
    //
    lblVersion.textColor = [UIColor lightGrayColor];
    lblVersion.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL];
}
@end
