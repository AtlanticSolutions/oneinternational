//
//  NavigationZone.m
//  LAB360-ObjC
//
//  Created by Erico GT on 03/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "NavigationZone.h"

@implementation NavigationZone

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zoneID = 0;
        self.name = nil;
        self.image = nil;
        self.urlImage = nil;
        self.actions = [NSMutableArray new];
        self.enterPosition = CGPointZero;
    }
    return self;
}

- (NavigationZone*)copyObject
{
    NavigationZone *zoneCopy = [NavigationZone new];
    zoneCopy.zoneID = self.zoneID;
    zoneCopy.name = self.name != nil ? [NSString stringWithFormat:@"%@", self.name] : nil;
    zoneCopy.image = self.image != nil ? [UIImage imageWithData:UIImagePNGRepresentation(self.image)] : nil;
    zoneCopy.urlImage = self.urlImage != nil ? [NSString stringWithFormat:@"%@", self.urlImage] : nil;
    zoneCopy.enterPosition = self.enterPosition;
    //
    for (ZoneAction *action in self.actions){
        [zoneCopy.actions addObject:[action copyObject]];
    }
    //
    return zoneCopy;
}

@end
