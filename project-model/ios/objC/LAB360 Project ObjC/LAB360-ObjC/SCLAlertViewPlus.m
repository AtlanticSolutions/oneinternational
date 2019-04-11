//
//  SCLAlertViewPlus.m
//  AHK-100anos
//
//  Created by Erico GT on 10/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "SCLAlertViewPlus.h"
#import "AppDelegate.h"

@implementation SCLAlertViewPlus

- (instancetype)initWithNewWindow
{
    self = [super initWithNewWindow];
    return self;
}

- (instancetype)init
{
    self = [super initWithNewWindow];
    return self;
}

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type actionBlock:(SCLActionBlock)action
{
    SCLButton *button = [super addButton:title actionBlock:action];
    
    if (type == SCLAlertButtonType_Neutral){
        button.defaultBackgroundColor = [UIColor grayColor];
    }else if(type == SCLAlertButtonType_Question){
        button.defaultBackgroundColor = [UIColor colorWithRed:1.0/255.0 green:55.0/255.0 blue:91.0/255.0 alpha:1.0];
    }else if(type == SCLAlertButtonType_Destructive){
        button.defaultBackgroundColor = UIColorFromHEX(0xC1272D);
    }
    
    return button;
}

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type  validationBlock:(SCLValidationBlock)validationBlock actionBlock:(SCLActionBlock)action
{
    SCLButton *button = [super addButton:title validationBlock:validationBlock actionBlock:action];
    
    if (type == SCLAlertButtonType_Neutral){
        button.defaultBackgroundColor = [UIColor grayColor];
    }else if(type == SCLAlertButtonType_Question){
        button.defaultBackgroundColor = [UIColor colorWithRed:1.0/255.0 green:55.0/255.0 blue:91.0/255.0 alpha:1.0];
    }else if(type == SCLAlertButtonType_Destructive){
        button.defaultBackgroundColor = UIColorFromHEX(0xC1272D);
    }
    
    return button;
}

- (SCLButton *)addButton:(NSString *)title withType:(enumSCLAlertButtonType)type  target:(id)target selector:(SEL)selector
{
    SCLButton *button = [super addButton:title target:target selector:selector];
    
    if (type == SCLAlertButtonType_Neutral){
        button.defaultBackgroundColor = [UIColor grayColor];
    }else if(type == SCLAlertButtonType_Question){
        button.defaultBackgroundColor = [UIColor colorWithRed:1.0/255.0 green:55.0/255.0 blue:91.0/255.0 alpha:1.0];
    }else if(type == SCLAlertButtonType_Destructive){
        button.defaultBackgroundColor = UIColorFromHEX(0xC1272D);
    }
    
    return button;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [AppD statusBarStyleForViewController:nil];
}

@end
