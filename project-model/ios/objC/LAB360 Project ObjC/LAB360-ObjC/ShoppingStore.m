//
//  ShoppingStore.m
//  ShoppingBH
//
//  Created by Erico GT on 06/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "ShoppingStore.h"

#define CLASS_SHOPPING_STORE_DEFAULT @"stores"
#define CLASS_SHOPPING_STORE_ID @"store_id"
#define CLASS_SHOPPING_STORE_CNPJ @"cnpj"
#define CLASS_SHOPPING_STORE_NAME @"store_name"
#define CLASS_SHOPPING_STORE_PHONE_NUMBER @"phone_number"
#define CLASS_SHOPPING_STORE_LOGO_URL @"logo_url"
#define CLASS_SHOPPING_STORE_CORRIDOR @"corridor"
#define CLASS_SHOPPING_STORE_POSITION @"position"
#define CLASS_SHOPPING_STORE_CORPORATE_NAME @"corporate_name"
#define CLASS_SHOPPING_STORE_FLG_QR_CODE @"flg_qr_code"
#define CLASS_SHOPPING_STORE_FLOOR @"floor"
#define CLASS_SHOPPING_STORE_SEGMENT @"segment"

@implementation ShoppingStore

@synthesize storeID, storeName, cnpj, phoneNumber, logoURL, corridor, position, corporateName, floor, segment, qrCode;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        storeID = DOMP_OPD_INT;
        storeName = DOMP_OPD_STRING;
        cnpj = DOMP_OPD_STRING;
        phoneNumber = DOMP_OPD_STRING;
        logoURL = DOMP_OPD_STRING;
        corridor = DOMP_OPD_STRING;
        position = DOMP_OPD_STRING;
        corporateName = DOMP_OPD_STRING;
        floor = DOMP_OPD_STRING;
        segment = DOMP_OPD_STRING;
        qrCode = DOMP_OPD_BOOLEAN;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------
+(ShoppingStore*)newObject
{
    ShoppingStore *ss = [ShoppingStore new];
    return ss;
}

+ (ShoppingStore*)createObjectFromDictionary:(NSDictionary*)dicData
{
    ShoppingStore *ss = [ShoppingStore new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        ss.storeID = [keysList containsObject:CLASS_SHOPPING_STORE_ID] ? [[neoDic  valueForKey:CLASS_SHOPPING_STORE_ID] longValue] : ss.storeID;
        ss.storeName = [keysList containsObject:CLASS_SHOPPING_STORE_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_STORE_NAME]] : ss.storeName;
        ss.cnpj = [keysList containsObject:CLASS_SHOPPING_STORE_CNPJ] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_STORE_CNPJ]] : ss.cnpj;
        ss.phoneNumber = [keysList containsObject:CLASS_SHOPPING_STORE_PHONE_NUMBER] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_STORE_PHONE_NUMBER]] : ss.phoneNumber;
        ss.logoURL = [keysList containsObject:CLASS_SHOPPING_STORE_LOGO_URL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_STORE_LOGO_URL]] : ss.logoURL;
        ss.corridor = [keysList containsObject:CLASS_SHOPPING_STORE_CORRIDOR] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_STORE_CORRIDOR]] : ss.corridor;
        ss.position = [keysList containsObject:CLASS_SHOPPING_STORE_POSITION] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_STORE_POSITION]] : ss.position;
        ss.corporateName = [keysList containsObject:CLASS_SHOPPING_STORE_CORPORATE_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_STORE_CORPORATE_NAME]] : ss.corporateName;
        ss.floor = [keysList containsObject:CLASS_SHOPPING_STORE_FLOOR] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_STORE_FLOOR]] : ss.floor;
        ss.segment = [keysList containsObject:CLASS_SHOPPING_STORE_SEGMENT] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_STORE_SEGMENT]] : ss.segment;
        ss.qrCode = [keysList containsObject:CLASS_SHOPPING_STORE_FLG_QR_CODE] ? [[neoDic  valueForKey:CLASS_SHOPPING_STORE_FLG_QR_CODE] boolValue] : ss.qrCode;
    }
    return ss;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData  setValue:@(storeID) forKey:CLASS_SHOPPING_STORE_ID];
    [dicData  setValue:(self.storeName != nil ? self.storeName : @"") forKey:CLASS_SHOPPING_STORE_NAME];
    [dicData  setValue:(self.cnpj != nil ? self.cnpj : @"") forKey:CLASS_SHOPPING_STORE_CNPJ];
    [dicData  setValue:(self.phoneNumber != nil ? self.phoneNumber : @"") forKey:CLASS_SHOPPING_STORE_PHONE_NUMBER];
    [dicData  setValue:(self.logoURL != nil ? self.logoURL : @"") forKey:CLASS_SHOPPING_STORE_LOGO_URL];
    [dicData  setValue:(self.corridor != nil ? self.corridor : @"") forKey:CLASS_SHOPPING_STORE_CORRIDOR];
    [dicData  setValue:(self.position != nil ? self.position : @"") forKey:CLASS_SHOPPING_STORE_POSITION];
    [dicData  setValue:(self.corporateName != nil ? self.corporateName : @"") forKey:CLASS_SHOPPING_STORE_CORPORATE_NAME];
    [dicData  setValue:(self.floor != nil ? self.floor : @"") forKey:CLASS_SHOPPING_STORE_FLOOR];
    [dicData  setValue:(self.segment != nil ? self.segment : @"") forKey:CLASS_SHOPPING_STORE_SEGMENT];
    [dicData  setValue:@(self.qrCode) forKey:CLASS_SHOPPING_STORE_FLG_QR_CODE];
    //
    return dicData;
}

- (ShoppingStore*)copyObject
{
    ShoppingStore *ss = [ShoppingStore new];
    ss.storeID = self.storeID;
    ss.storeName = self.storeName != nil ? [NSString stringWithFormat:@"%@", self.storeName] : nil;
    ss.cnpj = self.cnpj != nil ? [NSString stringWithFormat:@"%@", self.cnpj] : nil;
    ss.phoneNumber = self.phoneNumber != nil ? [NSString stringWithFormat:@"%@", self.phoneNumber] : nil;
    ss.logoURL = self.logoURL != nil ? [NSString stringWithFormat:@"%@", self.logoURL] : nil;
    ss.corridor = self.corridor != nil ? [NSString stringWithFormat:@"%@", self.corridor] : nil;
    ss.position = self.position != nil ? [NSString stringWithFormat:@"%@", self.position] : nil;
    ss.corporateName = self.corporateName != nil ? [NSString stringWithFormat:@"%@", self.corporateName] : nil;
    ss.floor = self.floor != nil ? [NSString stringWithFormat:@"%@", self.floor] : nil;
    ss.segment = self.segment != nil ? [NSString stringWithFormat:@"%@", self.segment] : nil;
    ss.qrCode = self.qrCode;
    //
    return ss;
}

@end
