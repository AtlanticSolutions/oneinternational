//
//  CVC_CustomIconButton.m
//  AHK-100anos
//
//  Created by Erico GT on 10/4/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "CVC_CustomIconButton.h"

@implementation CVC_CustomIconButton

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@synthesize lblTitle, imvIcon, imvBackground;

- (void)updateLayoutForMultilineLabel:(bool)isMultiline
{
    self.backgroundColor = [UIColor clearColor];
    lblTitle.backgroundColor = [UIColor clearColor];
    imvIcon.backgroundColor = [UIColor clearColor];
    imvBackground.backgroundColor = [UIColor clearColor];
    //
    lblTitle.textColor = [UIColor whiteColor];
    imvIcon.tintColor = [UIColor whiteColor];
    //
    lblTitle.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS];
    lblTitle.numberOfLines = 0;
    lblTitle.minimumScaleFactor = 0.5;
    //
    imvBackground.alpha = 0.9;
}

@end
