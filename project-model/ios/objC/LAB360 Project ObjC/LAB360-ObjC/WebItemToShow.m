//
//  WebItemToShow.m
//  AHK-100anos
//
//  Created by Erico GT on 11/18/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "WebItemToShow.h"

@implementation WebItemToShow

@synthesize urlString, titleMenu;

- (WebItemToShow*)init
{
    self = [super init];
    if (self) {
        urlString = @"";
        titleMenu = @"";
    }
    return self;
}

@end
