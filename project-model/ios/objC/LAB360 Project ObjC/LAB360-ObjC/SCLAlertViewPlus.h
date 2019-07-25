//
//  SCLAlertViewPlus.h
//  AHK-100anos
//
//  Created by Erico GT on 10/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "SCLAlertView.h"
#import "ConstantsManager.h"

@interface SCLAlertViewPlus : SCLAlertView

@property (nonatomic, strong) UITextField *defaultTextField;

typedef enum {SCLAlertButtonType_Neutral, SCLAlertButtonType_Normal, SCLAlertButtonType_Question, SCLAlertButtonType_Destructive} enumSCLAlertButtonType;

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type actionBlock:(SCLActionBlock)action;

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type  validationBlock:(SCLValidationBlock)validationBlock actionBlock:(SCLActionBlock)action;

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type  target:(id)target selector:(SEL)selector;

@end
