//
//  CVC_SponsorLogo.m
//  AHK-100anos
//
//  Created by Erico GT on 11/3/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "CVC_SponsorLogo.h"

@implementation CVC_SponsorLogo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@synthesize imvLogo, indicator, lblName;

- (void)updateLayoutStartingDownloading
{
    self.backgroundColor = [UIColor clearColor];
    imvLogo.backgroundColor = [UIColor clearColor];
    imvLogo.image = nil;
    imvLogo.alpha = 1.0;
    //
    lblName.backgroundColor = nil;
    lblName.textColor = AppD.styleManager.colorCalendarSelected;
    lblName.alpha = 0;
    lblName.text = @"";
    //
    indicator.color = AppD.styleManager.colorCalendarSelected;
    indicator.hidesWhenStopped = YES;
    //indicator.hidden = NO;
    [indicator startAnimating];
}

- (void)updateLayoutFinishDownloadingWithImage:(UIImage*)image
{
    imvLogo.image = image;
    //
    lblName.backgroundColor = nil;
    lblName.textColor = AppD.styleManager.colorCalendarSelected;
    lblName.alpha = 0;
    lblName.text = @"";
    indicator.hidden = YES;
    //
    [indicator stopAnimating];
}

@end
