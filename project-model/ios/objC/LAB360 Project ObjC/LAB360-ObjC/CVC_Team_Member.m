//
//  CVC_Team_Member.m
//  GS&MD
//
//  Created by Erico GT on 11/29/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "CVC_Team_Member.h"

@implementation CVC_Team_Member

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@synthesize imvPerson, indicator, lblName, imvFooter;

- (void)updateLayout
{
    self.backgroundColor = [UIColor clearColor];
    imvPerson.backgroundColor = [UIColor clearColor];
    imvPerson.image = nil;
    //
    indicator.color = AppD.styleManager.colorPalette.backgroundNormal;
    indicator.hidden = NO;
    [indicator startAnimating];
    //
    imvFooter.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //
    lblName.backgroundColor = [UIColor clearColor];
    lblName.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:14.0];
    lblName.numberOfLines = 3;
    lblName.minimumScaleFactor = 0.5;
    lblName.textColor = [UIColor whiteColor];
}

@end
