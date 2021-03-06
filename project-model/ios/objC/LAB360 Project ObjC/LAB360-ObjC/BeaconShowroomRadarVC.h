//
//  BeaconShowroomRadarVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"
#import "BeaconShowroomItem.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE
@interface BeaconShowroomRadarVC:ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) BeaconShowroomItem *currentShelf;
@property (nonatomic, strong) NSString *pinToUnlock;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
