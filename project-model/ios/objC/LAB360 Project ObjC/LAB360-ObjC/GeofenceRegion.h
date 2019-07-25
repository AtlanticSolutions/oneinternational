//
//  GeofenceRegion.h
//  LAB360-ObjC
//
//  Created by Erico GT on 22/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//
#import "ToolBox.h"

@interface GeofenceRegion : NSObject

//Properties:
@property(nonatomic, assign) long regionID;
@property(nonatomic, strong) CLLocation *location;
@property(nonatomic, strong) NSString *latitude;
@property(nonatomic, strong) NSString *longitude;
@property(nonatomic, assign) CLLocationDistance radius;
@property(nonatomic, assign) BOOL isGoal;
@property(nonatomic, assign) BOOL notifyOnEnter;
@property(nonatomic, assign) BOOL notifyOnExit;
@property(nonatomic, strong) NSString *identifier;
//
@property(nonatomic, strong) NSString *enterMessage;
@property(nonatomic, strong) NSString *exitMessage;

//Methods:
- (GeofenceRegion*)copyObject;

@end
