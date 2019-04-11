//
//  TVC_AssociateShare.m
//  AHK-100anos
//
//  Created by Erico GT on 10/24/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_AssociateShare.h"

@implementation TVC_AssociateShare

@synthesize btnLinkedin, btnFacebook, btnTwitter, btnShare, imvLine, imvLogo, activityIndicator;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateLayout
{
    self.backgroundColor = [UIColor clearColor];
    
    btnLinkedin.backgroundColor = [UIColor clearColor];
    [btnLinkedin setImage:[UIImage imageNamed:@"icon-share-linkedin"] forState:UIControlStateNormal];
    [btnLinkedin setImage:[UIImage imageNamed:@"icon-share-linkedin"] forState:UIControlStateHighlighted];
    [btnLinkedin setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    //
    btnFacebook.backgroundColor = [UIColor clearColor];
    [btnFacebook setImage:[UIImage imageNamed:@"icon-share-facebook"] forState:UIControlStateNormal];
    [btnFacebook setImage:[UIImage imageNamed:@"icon-share-facebook"] forState:UIControlStateHighlighted];
    [btnFacebook setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    //
    btnTwitter.backgroundColor = [UIColor clearColor];
    [btnTwitter setImage:[UIImage imageNamed:@"icon-share-twitter"] forState:UIControlStateNormal];
    [btnTwitter setImage:[UIImage imageNamed:@"icon-share-twitter"] forState:UIControlStateHighlighted];
    [btnTwitter setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    //
    btnShare.backgroundColor = [UIColor clearColor];
    [btnShare setImage:[UIImage imageNamed:@"icon-share-generic"] forState:UIControlStateNormal];
    [btnShare setImage:[UIImage imageNamed:@"icon-share-generic"] forState:UIControlStateHighlighted];
    [btnShare setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    //
    imvLogo.backgroundColor = [UIColor clearColor];
    //
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    //
    activityIndicator.color = AppD.styleManager.colorPalette.backgroundNormal;
    activityIndicator.hidden = true;
}

@end
