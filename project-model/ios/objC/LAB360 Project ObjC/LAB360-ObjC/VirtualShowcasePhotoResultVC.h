//
//  VirtualShowcasePhotoResultVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "ShowcaseDataSource.h"
#import "VIPhotoView.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VirtualShowcasePhotoResultVC : UIViewController<VIPhotoViewDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) UIImage *photo;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
