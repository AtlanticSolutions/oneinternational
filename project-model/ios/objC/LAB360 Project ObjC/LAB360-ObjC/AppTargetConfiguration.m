//
//  AppRemoteConfiguration.m
//  GS&MD
//
//  Created by Erico GT on 30/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "AppTargetConfiguration.h"

@implementation AppTargetConfiguration

@synthesize checkoutPaymentURL;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        checkoutPaymentURL = @"";
    }
    
    return self;
}

@end
