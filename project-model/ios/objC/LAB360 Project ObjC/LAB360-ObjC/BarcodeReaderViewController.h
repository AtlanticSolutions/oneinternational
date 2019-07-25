//
//  BarcodeReaderViewController.h
//  LAB360-ObjC
//
//  Created by Erico GT on 03/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>
#import <AVFoundation/AVBase.h>
#import <Foundation/Foundation.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#define BARCODE_READER_RESULT_NOTIFICATION_KEY @"barcode_reader_result_notification_key"

typedef enum {
    ScannableAreaFormatTypeDefinedByUser        = 0,
    ScannableAreaFormatTypeSmallSquare          = 1,
    ScannableAreaFormatTypeLargeSquare          = 2,
    ScannableAreaFormatTypeHorizontalStripe     = 3,
    ScannableAreaFormatTypeVerticalStripe       = 4,
    ScannableAreaFormatTypeFullScreen           = 5
} ScannableAreaFormatType;

typedef enum {
    BarcodeReaderResultTypeNotifyAndAlert       = 0,
    BarcodeReaderResultTypeNotifyAndClose       = 1,
    BarcodeReaderResultTypeAlertNotifyAndClose  = 2,
    BarcodeReaderResultTypeDisplayOnly          = 3
} BarcodeReaderResultType;

typedef NSString * AVMetadataObjectSubtype NS_STRING_ENUM API_AVAILABLE(macos(10.10), ios(6.0)) __WATCHOS_PROHIBITED __TVOS_PROHIBITED;

AVF_EXPORT AVMetadataObjectSubtype const AVMetadataObjectSubtypeGeneric API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(macos) __WATCHOS_PROHIBITED __TVOS_PROHIBITED;
AVF_EXPORT AVMetadataObjectSubtype const AVMetadataObjectSubtypeBoleto API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(macos) __WATCHOS_PROHIBITED __TVOS_PROHIBITED;
AVF_EXPORT AVMetadataObjectSubtype const AVMetadataObjectSubtypeConvenio API_AVAILABLE(ios(7.0)) API_UNAVAILABLE(macos) __WATCHOS_PROHIBITED __TVOS_PROHIBITED;

#pragma mark - • INTERFACE
@interface BarcodeReaderViewController : UIViewController

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, strong) NSArray<AVMetadataObjectType>* typesToRead;
@property(nonatomic, strong) NSArray<AVMetadataObjectSubtype>* subtypesToRead;
@property(nonatomic, assign) ScannableAreaFormatType rectScanType;
@property(nonatomic, assign) BarcodeReaderResultType resultType;
@property(nonatomic, strong) NSString* titleScreen;
@property(nonatomic, strong) NSString* instructionText;
//
@property(nonatomic, strong) NSString* validationKey;
@property(nonatomic, strong) NSString* validationValue;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
