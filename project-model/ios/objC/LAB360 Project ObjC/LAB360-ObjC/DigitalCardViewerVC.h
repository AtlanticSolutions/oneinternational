//
//  DigitalCardViewer.h
//  LAB360-ObjC
//
//  Created by Erico GT on 20/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface DigitalCardViewerVC : UIViewController<UIGestureRecognizerDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, strong) NSString *videoID;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
