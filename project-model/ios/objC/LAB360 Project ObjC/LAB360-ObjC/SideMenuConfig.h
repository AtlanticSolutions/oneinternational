//
//  SideMenuConfig.h
//  LAB360-ObjC
//
//  Created by Erico GT on 24/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"
//
#import "SideMenuItem.h"

@interface SideMenuConfig : NSObject<DefaultObjectModelProtocol>

//Properties
@property(nonatomic, assign) BOOL showReturnButtonInRootMenus;
@property(nonatomic, assign) BOOL showIcons;
@property(nonatomic, assign) BOOL showAppVersionInFooter;
@property(nonatomic, assign) BOOL showUserPhoto;
//
@property(nonatomic, strong) NSMutableArray<SideMenuItem*> *items;

//Protocol Methods
+ (SideMenuConfig*)newObject;
+ (SideMenuConfig*)createObjectFromDictionary:(NSDictionary*)dicData;
- (SideMenuConfig*)copyObject;
- (NSDictionary*)dictionaryJSON;

@end
