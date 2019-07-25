//
//  AppOptionPermissionItem.m
//  LAB360-ObjC
//
//  Created by Erico GT on 16/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AppOptionPermissionItem.h"

@implementation AppOptionPermissionItem

@synthesize systemKey, name, userDescription, status, statusMessage;

- (instancetype)init
{
    self = [super init];
    if (self) {
        systemKey = @"";
        name = @"";
        userDescription = @"";
        status = AppOptionPermissionItemStatusNotUsed;
        statusMessage = @"";
    }
    return self;
}

//Methods:
- (AppOptionPermissionItem*)copyObject
{
    AppOptionPermissionItem *copyItem = [AppOptionPermissionItem new];
    copyItem.systemKey = self.systemKey ? [NSString stringWithFormat:@"%@", self.systemKey] : nil;
    copyItem.name = self.name ? [NSString stringWithFormat:@"%@", self.name] : nil;
    copyItem.userDescription = self.userDescription ? [NSString stringWithFormat:@"%@", self.userDescription] : nil;
    copyItem.status = self.status;
    copyItem.statusMessage = self.statusMessage ? [NSString stringWithFormat:@"%@", self.statusMessage] : nil;
    //
    return copyItem;
}

@end
