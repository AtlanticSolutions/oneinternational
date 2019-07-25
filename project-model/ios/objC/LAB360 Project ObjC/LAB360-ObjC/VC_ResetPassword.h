//
//  VC_ResetPassword.h
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 20/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "User.h"


@interface VC_ResetPassword : UIViewController <UITextFieldDelegate, ConnectionManagerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *txtOldPass;
@property (nonatomic, weak) IBOutlet UITextField *txtNewPass;
@property (nonatomic, weak) IBOutlet UITextField *txtNewPass2;
@property (nonatomic, weak) IBOutlet UIButton *btnSave;
@property (nonatomic, weak) IBOutlet UIImageView *imvBackground;

@property (nonatomic, strong) User* user;

@end
