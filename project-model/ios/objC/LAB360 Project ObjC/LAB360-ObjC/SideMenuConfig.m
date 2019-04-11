//
//  SideMenuConfig.m
//  LAB360-ObjC
//
//  Created by Erico GT on 24/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "SideMenuConfig.h"
#import "ConstantsManager.h"

#define CLASS_SIDEMENU_CONFIG_DEFAULT @"sidemenu_config"
#define CLASS_SIDEMENU_CONFIG_SHOW_RETURN @"flg_return_button"
#define CLASS_SIDEMENU_CONFIG_SHOW_ICONS @"flg_icons"
#define CLASS_SIDEMENU_CONFIG_SHOW_APP_VERSION @"flg_app_version"
#define CLASS_SIDEMENU_CONFIG_SHOW_USER_PHOTO @"flg_user_photo"
#define CLASS_SIDEMENU_CONFIG_ITEMS @"app_menu_items"

@implementation SideMenuConfig

@synthesize showReturnButtonInRootMenus, showIcons, showAppVersionInFooter, showUserPhoto, items;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        showReturnButtonInRootMenus = NO;
        showIcons = YES;
        showAppVersionInFooter = YES;
        showUserPhoto = YES;
        items = [NSMutableArray new];
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------

+ (SideMenuConfig*)newObject
{
    SideMenuConfig *sm = [SideMenuConfig new];
    return sm;
}

+ (SideMenuConfig*)createObjectFromDictionary:(NSDictionary*)dicData
{
    SideMenuConfig *sm = [SideMenuConfig new];
    
    //NSDictionary *dic = [dicData valueForKey:[SideMenuConfig className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        sm.showReturnButtonInRootMenus = [keysList containsObject:CLASS_SIDEMENU_CONFIG_SHOW_RETURN] ? [[neoDic  valueForKey:CLASS_SIDEMENU_CONFIG_SHOW_RETURN] boolValue] : sm.showReturnButtonInRootMenus;
        //
        sm.showIcons = [keysList containsObject:CLASS_SIDEMENU_CONFIG_SHOW_ICONS] ? [[neoDic  valueForKey:CLASS_SIDEMENU_CONFIG_SHOW_ICONS] boolValue] : sm.showIcons;
        //
        sm.showAppVersionInFooter = [keysList containsObject:CLASS_SIDEMENU_CONFIG_SHOW_APP_VERSION] ? [[neoDic  valueForKey:CLASS_SIDEMENU_CONFIG_SHOW_APP_VERSION] boolValue] : sm.showAppVersionInFooter;
        //
        sm.showUserPhoto = [keysList containsObject:CLASS_SIDEMENU_CONFIG_SHOW_USER_PHOTO] ? [[neoDic  valueForKey:CLASS_SIDEMENU_CONFIG_SHOW_USER_PHOTO] boolValue] : sm.showUserPhoto;
        //
        if ([keysList containsObject:CLASS_SIDEMENU_CONFIG_ITEMS]){
            NSArray *itemsL = nil;
            @try {
                itemsL = [[NSArray alloc] initWithArray:[neoDic  valueForKey:CLASS_SIDEMENU_CONFIG_ITEMS]];
            } @catch (NSException *exception) {
                NSLog(@"createObjectFromDictionary >> Error >> %@", [exception reason]);
            }
            if (itemsL != nil && itemsL.count > 0) {
                NSMutableArray *allItems = [NSMutableArray new];
                for (NSDictionary *dic in itemsL) {
                    [allItems addObject:[SideMenuItem createObjectFromDictionary:dic]];
                }
                //order
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                sm.items = [[NSMutableArray alloc] initWithArray:[allItems sortedArrayUsingDescriptors:sortDescriptors]];
            }
        }
    }
    
    return sm;
}

- (SideMenuConfig*)copyObject
{
    SideMenuConfig *sm = [SideMenuConfig new];
    sm.showReturnButtonInRootMenus = self.showReturnButtonInRootMenus;
    sm.showIcons = self.showIcons;
    sm.showAppVersionInFooter = self.showAppVersionInFooter;
    sm.showUserPhoto = self.showUserPhoto;
    sm.items = [NSMutableArray new];
    for (SideMenuItem *item in self.items) {
        [sm.items addObject:[item copyObject]];
    }
    //
    return sm;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData  setValue:@(self.showReturnButtonInRootMenus) forKey:CLASS_SIDEMENU_CONFIG_SHOW_RETURN];
    [dicData  setValue:@(self.showIcons) forKey:CLASS_SIDEMENU_CONFIG_SHOW_ICONS];
    [dicData  setValue:@(self.showAppVersionInFooter) forKey:CLASS_SIDEMENU_CONFIG_SHOW_APP_VERSION];
    [dicData  setValue:@(self.showUserPhoto) forKey:CLASS_SIDEMENU_CONFIG_SHOW_USER_PHOTO];
    //
    NSMutableArray *itemsL = [NSMutableArray new];
    for (SideMenuItem *item in self.items) {
        [itemsL addObject:[item dictionaryJSON]];
    }
    [dicData setValue:itemsL forKey:CLASS_SIDEMENU_CONFIG_ITEMS];
    //
    return dicData;
}


@end
