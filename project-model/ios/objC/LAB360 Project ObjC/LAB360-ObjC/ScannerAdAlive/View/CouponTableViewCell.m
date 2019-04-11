//
//  CouponTableViewCell.m
//  AdAlive
//
//  Created by Lab360 on 1/19/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import "CouponTableViewCell.h"
#import "AppDelegate.h"

@interface CouponTableViewCell()

@property(nonatomic, weak) IBOutlet UIView *highlightedView;

@end

@implementation CouponTableViewCell

@synthesize logoImage, value, endDate, type, indicator, highlightedView, imvBackground;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupLayout
{
    self.backgroundColor = nil;
    
    highlightedView.backgroundColor = nil;
    [highlightedView setClipsToBounds:YES];
    
    imvBackground.backgroundColor = nil;
    imvBackground.image = nil;
    
    [logoImage setBackgroundColor:[UIColor clearColor]];
    logoImage.image = nil;
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    //
    [endDate setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [endDate setTextColor:[UIColor whiteColor]];
    [endDate setBackgroundColor:nil];
    //
    [value setFont:[UIFont fontWithName:FONT_DEFAULT_BOLD size:20.0]];
    [value setTextColor:[UIColor whiteColor]];
    [value setBackgroundColor:nil];
    //
    [type setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [type setTextColor:[UIColor whiteColor]];
    [type setBackgroundColor:nil];
    //
    indicator.color = [UIColor whiteColor];
    [indicator setHidesWhenStopped:YES];
    [indicator stopAnimating];
    
    [highlightedView.layer setCornerRadius:4.0];
}

@end
