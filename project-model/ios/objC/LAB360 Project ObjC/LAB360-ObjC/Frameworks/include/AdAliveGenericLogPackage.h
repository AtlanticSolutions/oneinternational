//
//  AdAliveGenericLogPackage.h
//  AdAliveSDK
//
//  Created by Erico GT on 19/06/18.
//  Copyright © 2018 atlantic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdAliveGenericLogPackage : NSObject

@property(nonatomic, strong) NSString *origin;
@property(nonatomic, strong) NSDictionary *request;
@property(nonatomic, strong) NSString *actionName;

+ (AdAliveGenericLogPackage*)newPackageWith:(NSString*)pOrigin request:(NSDictionary*)pRequest action:(NSString*)pAction;

@end
