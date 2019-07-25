//
//  AppOptionGeofenceMapVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 23/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import <CoreLocation/CoreLocation.h>
//
#import "ViewControllerModel.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE
@interface AppOptionGeofenceMapVC : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, strong) NSString *screenName;
@property(nonatomic, strong) NSArray<CLCircularRegion*>* regionsToShow;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
