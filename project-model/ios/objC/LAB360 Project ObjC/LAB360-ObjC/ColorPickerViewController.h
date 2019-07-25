//
//  ColorPickerViewController.h
//  LAB360-ObjC
//
//  Created by Erico GT on 25/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"
#import "HRColorPickerView.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#define COLOR_PICKER_RESULT_NOTIFICATION_KEY @"color_picker_result_notification_key"

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE
@interface ColorPickerViewController : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES

/** Texto para o navigation bar. */
@property(nonatomic, strong) NSString* titleScreen;

@property(nonatomic, strong) UIColor *selectedColor;

#pragma mark - • CLASS METHODS
+ (NSString*)colorNameForHex:(NSString*)hexColor;

#pragma mark - • PUBLIC INSTANCE METHODS

@end
