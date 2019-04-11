//
//  BiometricAuthentication.h
//  LAB360-ObjC
//
//  Created by Erico GT on 31/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BiometricType) {
    BiometricTypeNone = 0,
    BiometricTypeTouchID = 1,
    BiometricTypeFaceID = 2
};

@interface BiometricAuthentication : NSObject

/* Recupera o status da proteção, para um dado identificador de usuário. */
+ (BOOL)getAppProtectionStatusForUserIdentifier:(NSString* _Nonnull)userID;

/* Registra um novo status de proteção, para um dado identificador de usuário. */
+ (BOOL)setAppProtectionStatus:(BOOL)newStatus forUserIdentifier:(NSString*)userID;

/* Verifica o tipo de biometria disponível para o dispositivo. */
+ (BiometricType)biometricTypeAvailable;

/* Esta chamada solicita ao sistema que autentique o usuário utilizando o método (TouchID ou FaceID) disponível. */
+ (void)authenticateUserWithCompletionHandler:(void (^_Nullable)(BOOL success, NSString* _Nullable errorMessage)) handler;

@end

