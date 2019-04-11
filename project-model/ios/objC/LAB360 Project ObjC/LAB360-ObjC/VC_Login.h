//
//  VC_Login.h
//  AHK-100anos
//
//  Created by Erico GT on 10/5/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS
#import "AppDelegate.h"
#import "VC_SignUp.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_Login : UIViewController<UITextFieldDelegate, ConnectionManagerDelegate, FBSDKLoginButtonDelegate>

#pragma mark - • PUBLIC PROPERTIES

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
