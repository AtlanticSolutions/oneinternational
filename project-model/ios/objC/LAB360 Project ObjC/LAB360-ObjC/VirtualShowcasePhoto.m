//
//  VirtualShowcasePhoto.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "VirtualShowcasePhoto.h"

@implementation VirtualShowcasePhoto

@synthesize name, image, message, selected, fileURL;

- (instancetype)init
{
    self = [super init];
    if (self) {
        name = @"";
        message = @"";
        image = nil;
        selected = NO;
        fileURL = @"";
    }
    return self;
}

@end
