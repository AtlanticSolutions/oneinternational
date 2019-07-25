//
//  ImprovedCircularRegion.m
//  Siga
//
//  Created by Erico GT on 28/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "ImprovedCircularRegion.h"

@implementation ImprovedCircularRegion

@synthesize regionID, minSpeed, maxSpeed, direction;

- (instancetype)init
{
    self = [super init];
    if (self) {
        regionID = 0;
        minSpeed = 0.0;
        maxSpeed = 0.0;
        direction = -1;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        regionID = 0;
        minSpeed = 0.0;
        maxSpeed = 0.0;
        direction = -1;
    }
    return self;
}

-(instancetype)initWithCenter:(CLLocationCoordinate2D)center radius:(CLLocationDistance)radius identifier:(NSString *)identifier
{
    self = [super initWithCenter:center radius:radius identifier:identifier];
    if (self) {
        regionID = 0;
        minSpeed = 0.0;
        maxSpeed = 0.0;
        direction = -1;
    }
    return self;
}

- (ImprovedCircularRegion*) copyRegion
{
    ImprovedCircularRegion *copy = [[ImprovedCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(self.center.latitude, self.center.longitude) radius:self.radius identifier:self.identifier];
    copy.regionID = self.regionID;
    copy.minSpeed = self.minSpeed;
    copy.maxSpeed = self.maxSpeed;
    copy.direction = self.direction;
    //
    return copy;
}

@end
