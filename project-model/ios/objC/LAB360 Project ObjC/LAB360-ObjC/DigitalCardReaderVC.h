//
//  DigitalCardReaderVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 18/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES
typedef enum {
    DigitalCardReaderScreenTypeCreate      = 1,
    DigitalCardReaderScreenTypeReader      = 2
} DigitalCardReaderScreenType;

#pragma mark - • INTERFACE
@interface DigitalCardReaderVC : UIViewController

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, assign) DigitalCardReaderScreenType screenType;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
