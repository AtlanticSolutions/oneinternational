//
//  LocationPickerViewController.h
//  LAB360-ObjC
//
//  Created by Erico GT on 08/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#define LOCATION_PICKER_RESULT_NOTIFICATION_KEY @"location_picker_result_notification_key"

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE
@interface LocationPickerViewController : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES

/** Texto para o navigation bar. */
@property(nonatomic, strong) NSString* titleScreen;

@property(nonatomic, strong) CLLocation *startLocation;

@property(nonatomic, assign) BOOL showUserLocation;

@property(nonatomic, assign) BOOL snapShotMapView;

/** Determina se o PIN (marquer) será exibido sempre no centro do mapa (YES) ou será arrastável (NO).  */
//@property(nonatomic, assign) BOOL keepPinInCenterMap;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
