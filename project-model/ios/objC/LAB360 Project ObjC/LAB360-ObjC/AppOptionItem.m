//
//  AppOptionItem.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AppOptionItem.h"

@implementation AppOptionItem

@synthesize status, identification, title, selectionDescription, destinationDescription, switchableONDescription, switchableOFFDescription, on, blocked;

- (instancetype)init
{
    self = [super init];
    if (self) {
        status = AppOptionItemStatusSelection;
        identification = AppOptionItemIdentificationGeneric;
        title = @"";
        selectionDescription = @"";
        destinationDescription = @"";
        switchableONDescription = @"";
        switchableOFFDescription = @"";
        blocked = NO;
        on = NO;
    }
    return self;
}

//Methods:
- (AppOptionItem*)copyObject
{
    AppOptionItem *copyItem = [AppOptionItem new];
    copyItem.status = self.status;
    copyItem.identification = self.identification;
    copyItem.title = self.title ? [NSString stringWithFormat:@"%@", self.title] : nil;
    copyItem.selectionDescription = self.selectionDescription ? [NSString stringWithFormat:@"%@", self.selectionDescription] : nil;
    copyItem.destinationDescription = self.destinationDescription ? [NSString stringWithFormat:@"%@", self.destinationDescription] : nil;
    copyItem.switchableONDescription = self.switchableONDescription ? [NSString stringWithFormat:@"%@", self.switchableONDescription] : nil;
    copyItem.switchableOFFDescription = self.switchableOFFDescription ? [NSString stringWithFormat:@"%@", self.switchableOFFDescription] : nil;
    copyItem.blocked = self.blocked;
    copyItem.on = self.on;
    //
    return copyItem;
}

@end
