//
//  VC_MapNewUser.h
//  GS&MD
//
//  Created by Erico GT on 25/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "TVC_DistributorMap.h"
#import "MapMarker.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_MapNewUser : UIViewController<UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) NSArray<MapMarker*> *markersList;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
