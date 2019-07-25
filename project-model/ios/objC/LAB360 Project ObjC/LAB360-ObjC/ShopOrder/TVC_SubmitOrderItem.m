//
//  TVC_SubmitOrderItem.m
//  GS&MD
//
//  Created by Erico GT on 18/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_SubmitOrderItem.h"

@implementation TVC_SubmitOrderItem

@synthesize lblProductTitle, lblProductSize, lblProductAmount, lblTotalItem;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) updateLayout
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    //Background:
    lblProductTitle.backgroundColor = nil;
    lblProductSize.backgroundColor = nil;
    lblProductAmount.backgroundColor = nil;
    lblTotalItem.backgroundColor = nil;
    
    //Texts:
    [lblProductTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    [lblProductTitle setTextColor:[UIColor darkGrayColor]];
    lblProductTitle.text = @"";
    //
    [lblProductSize setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [lblProductSize setTextColor:[UIColor darkGrayColor]];
    lblProductSize.text = @"";
    //
    [lblProductAmount setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [lblProductAmount setTextColor:[UIColor darkGrayColor]];
    lblProductAmount.text = @"";
    //
    [lblTotalItem setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:18.0]];
    [lblTotalItem setTextColor:[UIColor darkGrayColor]];
    lblTotalItem.text = @"";
    
}

@end
