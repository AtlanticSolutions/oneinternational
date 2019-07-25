//
//  AppOptionPermissionItem.h
//  LAB360-ObjC
//
//  Created by Erico GT on 16/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppOptionPermissionItem : NSObject

typedef enum {
    AppOptionPermissionItemStatusNotUsed      = 0,
    AppOptionPermissionItemStatusUndefined    = 1, //Representa a permissão nunca solicitada
    AppOptionPermissionItemStatusDenied       = 2, //Permissão pronta para uso
    AppOptionPermissionItemStatusGuaranteed   = 3  //Permissão negada
}AppOptionPermissionItemStatus;

//Properties
@property (nonatomic, strong) NSString *systemKey;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userDescription;
@property (nonatomic, assign) AppOptionPermissionItemStatus status;
@property (nonatomic, strong) NSString *statusMessage;

//Methods:
- (AppOptionPermissionItem*)copyObject;

@end
