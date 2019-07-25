//
//  AdAliveAction.m
//  GS&MD
//
//  Created by Erico GT on 29/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "AdAliveAction.h"

#define CLASS_ADALIVE_ACTION_CLASS @"action"
#define CLASS_ADALIVE_ACTION_ID @"id"
#define CLASS_ADALIVE_ACTION_NAME @"name"
#define CLASS_ADALIVE_ACTION_URL @"href"
#define CLASS_ADALIVE_ACTION_VERTICAL_HREF @"href_vertical_url"
#define CLASS_ADALIVE_ACTION_HORIZONTAL_HREF @"href_horizontal_url"
#define CLASS_ADALIVE_ACTION_TYPE @"type"
#define CLASS_ADALIVE_ACTION_PRODUCT_ID @"product_id"
#define CLASS_ADALIVE_ACTION_PRODUCT_SKU @"product_sku"
#define CLASS_ADALIVE_ACTION_TIME @"time"

@implementation AdAliveAction

@synthesize actionID, actionName, actionURL, type, verticalURL, horizontalURL, productID, productSKU, autoCloseTime;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        actionID = 0;
        actionName = @"";
        actionURL = @"";
        type = @"";
        verticalURL = @"";
        horizontalURL = @"";
        productID = 0;
        productSKU = @"";
        autoCloseTime = 0;
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------
+(AdAliveAction*)newObject
{
    AdAliveAction *action = [AdAliveAction new];
    return action;
}

+(AdAliveAction*)createObjectFromDictionary:(NSDictionary*)dicData
{
    AdAliveAction *a = [AdAliveAction new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        a.actionID = [keysList containsObject:CLASS_ADALIVE_ACTION_ID] ? [[neoDic  valueForKey:CLASS_ADALIVE_ACTION_ID] longValue] : a.actionID;
        a.actionName = [keysList containsObject:CLASS_ADALIVE_ACTION_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ADALIVE_ACTION_NAME]] : a.actionName;
        a.actionURL = [keysList containsObject:CLASS_ADALIVE_ACTION_URL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ADALIVE_ACTION_URL]] : a.actionURL;
        a.type = [keysList containsObject:CLASS_ADALIVE_ACTION_TYPE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ADALIVE_ACTION_TYPE]] : a.type;
        a.verticalURL = [keysList containsObject:CLASS_ADALIVE_ACTION_VERTICAL_HREF] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ADALIVE_ACTION_VERTICAL_HREF]] : a.verticalURL;
        a.horizontalURL = [keysList containsObject:CLASS_ADALIVE_ACTION_HORIZONTAL_HREF] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ADALIVE_ACTION_HORIZONTAL_HREF]] : a.horizontalURL;
        a.productID = [keysList containsObject:CLASS_ADALIVE_ACTION_PRODUCT_ID] ? [[neoDic  valueForKey:CLASS_ADALIVE_ACTION_PRODUCT_ID] longValue] : a.productID;
        a.productSKU = [keysList containsObject:CLASS_ADALIVE_ACTION_PRODUCT_SKU] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ADALIVE_ACTION_PRODUCT_SKU]] : a.productSKU;
        a.autoCloseTime = [keysList containsObject:CLASS_ADALIVE_ACTION_TIME] ? [[neoDic  valueForKey:CLASS_ADALIVE_ACTION_TIME] longValue] : a.autoCloseTime;
    }
    
    return a;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(actionID) forKey:CLASS_ADALIVE_ACTION_ID];
    [dicData setValue:(actionName != nil ? actionName : @"") forKey:CLASS_ADALIVE_ACTION_NAME];
    [dicData setValue:(actionURL != nil ? actionURL : @"") forKey:CLASS_ADALIVE_ACTION_URL];
    [dicData setValue:(type != nil ? type : @"") forKey:CLASS_ADALIVE_ACTION_TYPE];
    [dicData setValue:(verticalURL != nil ? verticalURL : @"") forKey:CLASS_ADALIVE_ACTION_VERTICAL_HREF];
    [dicData setValue:(horizontalURL != nil ? horizontalURL : @"") forKey:CLASS_ADALIVE_ACTION_HORIZONTAL_HREF];
    [dicData setValue:@(productID) forKey:CLASS_ADALIVE_ACTION_PRODUCT_ID];
    [dicData setValue:(productSKU != nil ? productSKU : @"") forKey:CLASS_ADALIVE_ACTION_PRODUCT_SKU];
    [dicData setValue:@(autoCloseTime) forKey:CLASS_ADALIVE_ACTION_TIME];
    
    return dicData;
}

- (AdAliveAction *) copyObject
{
    AdAliveAction *a = [AdAliveAction new];
    //
    a.actionID = self.actionID;
    a.actionName = self.actionName ? [NSString stringWithFormat:@"%@", self.actionName] : self.actionName;
    a.actionURL = self.actionURL ? [NSString stringWithFormat:@"%@", self.actionURL] : self.actionURL;
    a.type = self.type ? [NSString stringWithFormat:@"%@", self.type] : self.type;
    a.verticalURL = self.verticalURL ? [NSString stringWithFormat:@"%@", self.verticalURL] : self.verticalURL;
    a.horizontalURL = self.horizontalURL ? [NSString stringWithFormat:@"%@", self.horizontalURL] : self.horizontalURL;
    a.productID = self.productID;
    a.productSKU = self.productSKU ? [NSString stringWithFormat:@"%@", self.productSKU] : self.productSKU;
    a.autoCloseTime = self.autoCloseTime;
    
    return a;
}

@end
