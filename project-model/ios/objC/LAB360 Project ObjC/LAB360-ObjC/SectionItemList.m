//
//  SectionItemList.m
//  AHK-100anos
//
//  Created by Erico GT on 11/8/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "SectionItemList.h"

@implementation SectionItemList

@synthesize keyString, valueArray;

- (SectionItemList*)init
{
    self = [super init];
    if (self) {
        keyString = @"";
        valueArray = [NSMutableArray new];
    }
    return self;
}

@end
