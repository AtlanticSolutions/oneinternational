//
//  VirtualShowcaseTakePhotoVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "VirtualShowcaseGallery.h"
#import "ShowcaseDataSource.h"
#import "VIPhotoView.h"
#import "VirtualShowcaseMaskEditionVC.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VirtualShowcaseTakePhotoVC: UIViewController<VIPhotoViewDelegate, UIGestureRecognizerDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) VirtualShowcaseCategory *category;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
