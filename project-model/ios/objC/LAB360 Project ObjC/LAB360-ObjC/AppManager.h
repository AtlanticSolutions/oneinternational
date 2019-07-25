//
//  AppManager.h
//  LAB360-ObjC
//
//  Created by Alexandre on 28/05/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"

@interface AppManager : NSObject<DefaultObjectModelProtocol>

//Properties:

//basic
@property (nonatomic, assign) long appID;
//promotion
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appVesion;
@property (nonatomic, strong) NSString *appBuild;
@property (nonatomic, strong) NSString *appDescription;

//images urls
@property (nonatomic, strong) NSString *appUrl;
//images
@property (nonatomic, strong) NSString *appUrlimgIcon;

//Protocol Methods:
+ (AppManager*)newObject;
+ (AppManager*)createObjectFromDictionary:(NSDictionary*)dicData;
- (AppManager*)copyObject;
- (NSDictionary*)dictionaryJSON;

@end
