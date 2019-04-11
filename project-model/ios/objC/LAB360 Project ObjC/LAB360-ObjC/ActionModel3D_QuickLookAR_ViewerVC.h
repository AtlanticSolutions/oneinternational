//
//  ActionModel3D_QuickLookAR_ViewerVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/19.
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

@interface ActionModel3D_QuickLookAR_ViewerVC : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, strong) ActionModel3D_AR *actionM3D;
@property(nonatomic, strong) UIImage *backgroundPreviewImage;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
