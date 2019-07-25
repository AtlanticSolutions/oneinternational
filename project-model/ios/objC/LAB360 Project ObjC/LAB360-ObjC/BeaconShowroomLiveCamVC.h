//
//  BeaconShowroomLiveCamVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 21/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"
#import "AppDelegate.h"
#import "UIImage+animatedGIF.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE
@interface BeaconShowroomLiveCamVC:ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, strong) NSString* beaconTagID;
@property(nonatomic, strong) NSString* productSKU;
@property(nonatomic, strong) NSString* verticalBannerURL;
@property(nonatomic, strong) NSString* horizontalBannerURL;
@property(nonatomic, assign) UIDeviceOrientation inheritedOrientation;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
