//
//  BiometricAuthentication.m
//  LAB360-ObjC
//
//  Created by Erico GT on 31/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "BiometricAuthentication.h"
#import "ToolBox.h"

@implementation BiometricAuthentication

+ (BOOL)getAppProtectionStatusForUserIdentifier:(NSString*)userID
{
    if ([ToolBox textHelper_CheckRelevantContentInString:userID]){
        NSString *key = [NSString stringWithFormat:@"%@BiometricAuthentication", userID];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        return [ud boolForKey:key];
    }
    return NO;
}

+ (BOOL)setAppProtectionStatus:(BOOL)newStatus forUserIdentifier:(NSString*)userID
{
    if ([ToolBox textHelper_CheckRelevantContentInString:userID]){
        NSString *key = [NSString stringWithFormat:@"%@BiometricAuthentication", userID];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:newStatus forKey:key];
        return [ud synchronize];
    }
    return NO;
}

+ (BiometricType)biometricTypeAvailable
{
    if (@available(iOS 11.0, *)) {
        
        LAContext* context = [LAContext new];
        NSError *error;
        
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
            if (context.biometryType == LABiometryTypeTouchID){
                return BiometricTypeTouchID;
            }else if (context.biometryType == LABiometryTypeFaceID){
                return BiometricTypeFaceID;
            }
        }else{
            NSLog(@"biometricTypeAvailable >> Error >> %@", [error localizedDescription]);
        }
    }
    
    return BiometricTypeNone;
}

+ (void)authenticateUserWithCompletionHandler:(void (^_Nullable)(BOOL success, NSString* _Nullable errorMessage)) handler
{
    BiometricType availableType = [BiometricAuthentication biometricTypeAvailable];
    
    if (availableType == BiometricTypeNone){
        handler(NO, @"Autenticação biométrica não disponível!");
    }else{
        LAContext* context = [LAContext new];
        NSString* authReason = @"Autentique-se para desbloquear o aplicativo!";
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:authReason reply:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success){
                    handler(YES, nil);
                }else{
                    handler(NO, [error localizedDescription]);
                }
            });
        }];
    }
}

@end
