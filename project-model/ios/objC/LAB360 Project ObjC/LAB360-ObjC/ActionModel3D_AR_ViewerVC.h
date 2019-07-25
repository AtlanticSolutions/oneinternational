//
//  ActionModel3D_AR_ViewerVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 25/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"
#import "ActionModel3D_AR.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE

API_AVAILABLE(ios(11.0))
@interface ActionModel3D_AR_ViewerVC : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, strong) ActionModel3D_AR *actionM3D;

#pragma mark - • CLASS METHODS
+ (BOOL) ARSupportedForDevice;

#pragma mark - • PUBLIC INSTANCE METHODS

@end
