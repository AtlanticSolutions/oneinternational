//
//  TVC_DistributorMap.m
//  GS&MD
//
//  Created by Erico GT on 25/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_DistributorMap.h"

@implementation TVC_DistributorMap

@synthesize lblDistributorName, lblDistributorContact, imvPinMarker;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) updateLayout
{
    self.backgroundColor = nil;
    
    [lblDistributorName setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:18.0]];
    [lblDistributorName setTextColor:[UIColor darkTextColor]];
    [lblDistributorName setBackgroundColor:nil];
    //
    [lblDistributorContact setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:14.0]];
    [lblDistributorContact setTextColor:[UIColor grayColor]];
    [lblDistributorContact setBackgroundColor:nil];
    //
    imvPinMarker.backgroundColor = nil;
    
    lblDistributorName.text = @"";
    lblDistributorContact.text = @"";
    imvPinMarker.image = nil;
    
}

@end
