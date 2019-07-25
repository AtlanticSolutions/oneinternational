//
//  ActionModel3D_Scene_ViewerVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 28/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"
#import "VirtualObjectProperties.h"
#import "ActionModel3D_AR.h"

#pragma mark - • FRAMEWORK HEADERS

#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

@class VirtualSceneViewerVC;

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE

API_AVAILABLE(ios(11.0))
@interface ActionModel3D_Scene_ViewerVC : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES

@property(nonatomic, strong) ActionModel3D_AR *actionM3D;
@property(nonatomic, strong) UIImage *backgroundPreviewImage;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
