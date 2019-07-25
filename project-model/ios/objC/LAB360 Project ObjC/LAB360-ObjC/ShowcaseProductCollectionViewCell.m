//
//  ShowcaseProductCollectionViewCell.m
//  LAB360-ObjC
//
//  Created by Erico GT on 06/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "ShowcaseProductCollectionViewCell.h"

@implementation ShowcaseProductCollectionViewCell

@synthesize imvProduct, lblProduct, viewProductNameContainer, activityIndicator, imvSelectionIndicator;

- (void)setupLayout
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = nil;
    //
    imvProduct.backgroundColor = nil;
    imvProduct.contentMode = UIViewContentModeScaleAspectFit;
    imvProduct.image = nil;
    [imvProduct cancelImageRequestOperation];
    //
    lblProduct.backgroundColor = nil;
    [lblProduct setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15]];
    [lblProduct setTextColor:[UIColor whiteColor]];
    lblProduct.text = @"";        
    //
    viewProductNameContainer.backgroundColor = [AppD.styleManager.colorPalette.backgroundNormal colorWithAlphaComponent:0.75];
    //
    activityIndicator.backgroundColor = nil;
    activityIndicator.color = AppD.styleManager.colorPalette.backgroundNormal; //[UIColor whiteColor];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator stopAnimating];
    //
    imvSelectionIndicator.backgroundColor = nil;
    imvSelectionIndicator.image = nil;
    [imvSelectionIndicator setHidden:YES];
    //
    self.layer.cornerRadius = 5.0;
    self.layer.borderWidth = 0.0;
    self.layer.borderColor = nil;
    
//    self.clipsToBounds = NO;
//    [ToolBox graphicHelper_ApplyShadowToView:self withColor:[UIColor blackColor] offSet:CGSizeMake(3.0, 3.0) radius:3.0 opacity:.75];
    
}

@end
