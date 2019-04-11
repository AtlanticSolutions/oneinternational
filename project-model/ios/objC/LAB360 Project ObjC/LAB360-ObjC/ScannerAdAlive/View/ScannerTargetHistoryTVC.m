//
//  ScannerTargetHistoryTVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 07/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "ScannerTargetHistoryTVC.h"
#import "AppDelegate.h"

@implementation ScannerTargetHistoryTVC

@synthesize imvProductImage, activityIndicator, lblName, lblDate;

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
    self.backgroundColor = nil;
    
    [imvProductImage setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    imvProductImage.image = nil;
    imvProductImage.contentMode = UIViewContentModeScaleAspectFill;
    [imvProductImage cancelImageRequestOperation];
    //
    [lblName setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:18.0]];
    [lblName setTextColor:[UIColor darkTextColor]];
    [lblName setBackgroundColor:nil];
    //
    [lblDate setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:14.0]];
    [lblDate setTextColor:[UIColor grayColor]];
    [lblDate setBackgroundColor:nil];
    //
    activityIndicator.color = AppD.styleManager.colorPalette.backgroundNormal;
    [activityIndicator setHidesWhenStopped:YES];
    [activityIndicator stopAnimating];
}

@end
