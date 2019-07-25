//
//  AppManager.m
//  LAB360-ObjC
//
//  Created by Alexandre on 28/05/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AppManager.h"
#import "ConstantsManager.h"

#define CLASS_APPMANAGER_DEFAULT @"app_manager"
#define CLASS_APPMANAGER_KEY_ID @"id"
#define CLASS_APPMANAGER_KEY_NAME @"name_app"
#define CLASS_APPMANAGER_KEY_VERSION @"version_app"
#define CLASS_APPMANAGER_KEY_BUILD @"build_app"
#define CLASS_APPMANAGER_KEY_DESCRIPTION @"description_app"
#define CLASS_APPMANAGER_KEY_URL @"url_app"
#define CLASS_APPMANAGER_KEY_IMAGE @"url_icon_app"

@implementation AppManager

@synthesize appID;
@synthesize appName, appVesion, appBuild, appDescription, appUrl, appUrlimgIcon;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    if (self) {
        appID = 0;

        //promotion
        appName = nil;
        appVesion = nil;
        appBuild = nil;
        appDescription = nil;

        //images urls
        appUrl = nil;

        //images
        appUrlimgIcon = nil;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------


+ (AppManager*)newObject {
    AppManager *am = [AppManager new];
    return am;
}

+ (AppManager*)createObjectFromDictionary:(NSDictionary*)dicData {
    AppManager *am = [AppManager new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        am.appID = [keysList containsObject:CLASS_APPMANAGER_KEY_ID] ? [[neoDic  valueForKey:CLASS_APPMANAGER_KEY_ID] longValue] : am.appID;
        //promotion
        am.appName = [keysList containsObject:CLASS_APPMANAGER_KEY_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_APPMANAGER_KEY_NAME]] : am.appName;
        am.appVesion = [keysList containsObject:CLASS_APPMANAGER_KEY_VERSION] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_APPMANAGER_KEY_VERSION]] : am.appVesion;
        am.appBuild = [keysList containsObject:CLASS_APPMANAGER_KEY_BUILD] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_APPMANAGER_KEY_BUILD]] : am.appBuild;
        am.appDescription = [keysList containsObject:CLASS_APPMANAGER_KEY_DESCRIPTION] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_APPMANAGER_KEY_DESCRIPTION]] : am.appDescription;
        //images urls
        am.appUrl = [keysList containsObject:CLASS_APPMANAGER_KEY_URL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_APPMANAGER_KEY_URL]] : am.appUrl;
        //images
        am.appUrlimgIcon = [keysList containsObject:CLASS_APPMANAGER_KEY_IMAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_APPMANAGER_KEY_IMAGE]] : am.appUrlimgIcon;

    }
    
    return am;
}

- (AppManager*)copyObject {
    AppManager *am = [AppManager new];
    am.appID = self.appID;
    //promotion
    am.appName = self.appName ? [NSString stringWithFormat:@"%@", self.appName] : nil;
    am.appVesion = self.appVesion ? [NSString stringWithFormat:@"%@", self.appVesion] : nil;
    am.appBuild = self.appBuild ? [NSString stringWithFormat:@"%@", self.appBuild] : nil;
    am.appDescription = self.appDescription ? [NSString stringWithFormat:@"%@", self.appDescription] : nil;
    //images urls
    am.appUrl = self.appUrl ? [NSString stringWithFormat:@"%@", self.appUrl] : nil;
    //images
    am.appUrlimgIcon = self.appUrlimgIcon ? [NSString stringWithFormat:@"%@", self.appUrlimgIcon] : nil;
    //
    return am;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.appID) forKey:CLASS_APPMANAGER_KEY_ID];
    [dicData setValue:(self.appName ? self.appName : @"") forKey:CLASS_APPMANAGER_KEY_NAME];
    [dicData setValue:(self.appVesion ? self.appVesion : @"") forKey:CLASS_APPMANAGER_KEY_VERSION];
    [dicData setValue:(self.appBuild ? self.appBuild : @"") forKey:CLASS_APPMANAGER_KEY_BUILD];
    [dicData setValue:(self.appDescription ? self.appDescription : @"") forKey:CLASS_APPMANAGER_KEY_DESCRIPTION];
    [dicData setValue:(self.appUrl ? self.appUrl : @"") forKey:CLASS_APPMANAGER_KEY_URL];
    [dicData setValue:(self.appUrlimgIcon ? self.appUrlimgIcon : @"") forKey:CLASS_APPMANAGER_KEY_IMAGE];    
    //
    return dicData;
}

@end

