//
//  VC_PromotionRegister.h
//  ShoppingBH
//
//  Created by Erico GT on 01/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS
#import "AppDelegate.h"
#import "VC_DropList.h"
#import "User.h"
#import "VC_PostsGallery.h"
#import "ShoppingPromotion.h"

#pragma mark - • LOCAL DEFINES
@protocol DropListProtocol;

#pragma mark - • INTERFACE
@interface VC_PromotionRegister:UIViewController<DropListProtocol, UITextFieldDelegate, ConnectionManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, assign) BOOL fromFacebook;
@property (nonatomic, assign) BOOL emailAvailable;

@property (nonatomic, strong) ShoppingPromotion *promotion;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
