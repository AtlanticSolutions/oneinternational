//
//  Viewer3DSceneRendererVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 23/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE
@interface Viewer3DSceneRendererVC : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, strong) NSString *screenTitle;
//
@property(nonatomic, strong) NSString *xmlDataSetFileURL;
@property(nonatomic, strong) NSString *objectModelURL;
//
@property(nonatomic, assign) float lightPositionX;
@property(nonatomic, assign) float lightPositionY;
@property(nonatomic, assign) float lightPositionZ;
@property(nonatomic, assign) float modelPositionX;
@property(nonatomic, assign) float modelPositionY;
@property(nonatomic, assign) float modelPositionZ;
@property(nonatomic, assign) float modelRotationX;
@property(nonatomic, assign) float modelRotationY;
@property(nonatomic, assign) float modelRotationZ;
@property(nonatomic, assign) float modelRotationW;
@property(nonatomic, assign) float modelScale;
//
@property(nonatomic, assign) BOOL showShareButton;
@property(nonatomic, assign) BOOL showTargetHintButton;
@property(nonatomic, strong) UIImage *hintImage;
//
@property(nonatomic, assign) BOOL enableMaterialAutoIlumination;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
