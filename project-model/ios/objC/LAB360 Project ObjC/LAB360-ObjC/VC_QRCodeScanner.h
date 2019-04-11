//
//  VC_Scanner.h
//  AHK-100anos
//
//  Created by Erico GT on 10/27/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES
enum enumCAMERA{eCAMERA_TYPE_DEFAULT, eCAMERA_TYPE_BACK, eCAMERA_TYPE_FRONT};

#pragma mark - • INTERFACE
@interface VC_QRCodeScanner : UIViewController<AVCaptureMetadataOutputObjectsDelegate, ConnectionManagerDelegate>

#pragma mark - • PUBLIC PROPERTIES

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
