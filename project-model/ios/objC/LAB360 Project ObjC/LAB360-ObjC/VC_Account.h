//
//  VC_Account.h
//  AHK-100anos
//
//  Created by Erico GT on 10/5/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TVC_AccountBody.h"
#import "TVC_AccountFooter.h"
#import "TVC_AccountHeader.h"
#import "VC_ResetPassword.h"
#import "VC_DropList.h"
#import "TVC_FakeTextField.h"

@interface VC_Account : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ConnectionManagerDelegate>

@end
