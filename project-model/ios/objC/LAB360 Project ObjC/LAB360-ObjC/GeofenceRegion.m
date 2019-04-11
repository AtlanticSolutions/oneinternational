//
//  GeofenceRegion.m
//  LAB360-ObjC
//
//  Created by Erico GT on 22/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "GeofenceRegion.h"

@implementation GeofenceRegion

@synthesize regionID, location, latitude, longitude, radius, isGoal, notifyOnEnter, notifyOnExit, enterMessage, exitMessage, identifier;


- (instancetype)init
{
    self = [super init];
    if (self) {
        regionID = 0;
        location = nil;
        latitude = nil;
        longitude = nil;
        radius = 0;
        isGoal = NO;
        notifyOnEnter = YES;
        notifyOnExit = YES;
        identifier = nil;
        //
        enterMessage = nil;
        exitMessage = nil;
    }
    return self;
}

- (GeofenceRegion*)copyObject
{
    GeofenceRegion *copyRegion = [GeofenceRegion new];
    copyRegion.regionID = regionID;
    copyRegion.location = location ? [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude] : nil;
    copyRegion.latitude = latitude ? [NSString stringWithFormat:@"%@", latitude] : nil;
    copyRegion.longitude = latitude ? [NSString stringWithFormat:@"%@", longitude] : nil;
    copyRegion.radius = radius;
    copyRegion.isGoal = isGoal;
    copyRegion.notifyOnEnter = notifyOnEnter;
    copyRegion.notifyOnExit = notifyOnExit;
    copyRegion.identifier = identifier ? [NSString stringWithFormat:@"%@", identifier] : nil;
    copyRegion.enterMessage = enterMessage ? [NSString stringWithFormat:@"%@", enterMessage] : nil;
    copyRegion.exitMessage = exitMessage ? [NSString stringWithFormat:@"%@", exitMessage] : nil;
    //
    return copyRegion;
}

@end
