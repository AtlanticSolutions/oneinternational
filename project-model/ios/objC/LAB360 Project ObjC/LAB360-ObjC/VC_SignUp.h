//
//  VC_SignUp.h
//  AHK-100anos
//
//  Created by Lucas Correia on 06/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//


#pragma mark - • INTERFACE HEADERS

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS
#import "AppDelegate.h"
#import "VC_DropList.h"
#import "User.h"
#import "VC_PostsGallery.h"

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_SignUp : UIViewController<UITextFieldDelegate, ConnectionManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) BOOL fromFacebook;
@property (nonatomic, assign) BOOL emailAvailable;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end

