//
//  ShoppingPromotion.m
//  ShoppingBH
//
//  Created by Erico GT on 03/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "ShoppingPromotion.h"

#define CLASS_SHOPPING_PROMOTION_DEFAULT @"promotions"
#define CLASS_SHOPPING_PROMOTION_ID @"promotion_id"
#define CLASS_SHOPPING_PROMOTION_NAME @"name"
#define CLASS_SHOPPING_PROMOTION_URL_IMAGE @"url_image"
#define CLASS_SHOPPING_PROMOTION_URL_TERMS @"url_term"
#define CLASS_SHOPPING_PROMOTION_USER_REGISTERED @"present"
#define CLASS_SHOPPING_PROMOTION_INVOICE_SCAN_PERMITED @"flg_camara"
#define CLASS_SHOPPING_PROMOTION_MIN_NUMBER_LUCKY_VALUE @"min_number_luck_value"
#define CLASS_SHOPPING_PROMOTION_QUESTION @"question"

@implementation ShoppingPromotion

@synthesize promotionID, name, urlImage, urlTerms, isUserRegistered, isInvoiceScanPermited, minValueToGenerateCoupons, question;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        promotionID = DOMP_OPD_INT;
        name = DOMP_OPD_STRING;
        urlImage = DOMP_OPD_STRING;
        urlTerms = DOMP_OPD_STRING;
        isUserRegistered = DOMP_OPD_BOOLEAN;
        isInvoiceScanPermited = DOMP_OPD_BOOLEAN;
        minValueToGenerateCoupons = DOMP_OPD_FLOAT;
        question = nil;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------
+(ShoppingPromotion*)newObject
{
    ShoppingPromotion *sp = [ShoppingPromotion new];
    return sp;
}

+ (ShoppingPromotion*)createObjectFromDictionary:(NSDictionary*)dicData
{
    ShoppingPromotion *p = [ShoppingPromotion new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        p.promotionID = [keysList containsObject:CLASS_SHOPPING_PROMOTION_ID] ? [[neoDic  valueForKey:CLASS_SHOPPING_PROMOTION_ID] intValue] : p.promotionID;
        p.name = [keysList containsObject:CLASS_SHOPPING_PROMOTION_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_PROMOTION_NAME]] : p.name;
        p.urlImage = [keysList containsObject:CLASS_SHOPPING_PROMOTION_URL_IMAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_PROMOTION_URL_IMAGE]] : p.urlImage;
        p.urlTerms = [keysList containsObject:CLASS_SHOPPING_PROMOTION_URL_TERMS] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_PROMOTION_URL_TERMS]] : p.urlTerms;
        p.isUserRegistered = [keysList containsObject:CLASS_SHOPPING_PROMOTION_USER_REGISTERED] ? [[neoDic  valueForKey:CLASS_SHOPPING_PROMOTION_USER_REGISTERED] boolValue] : p.isUserRegistered;
        p.isInvoiceScanPermited = [keysList containsObject:CLASS_SHOPPING_PROMOTION_INVOICE_SCAN_PERMITED] ? [[neoDic  valueForKey:CLASS_SHOPPING_PROMOTION_INVOICE_SCAN_PERMITED] boolValue] : p.isInvoiceScanPermited;
        p.minValueToGenerateCoupons = [keysList containsObject:CLASS_SHOPPING_PROMOTION_MIN_NUMBER_LUCKY_VALUE] ? [[neoDic valueForKey:CLASS_SHOPPING_PROMOTION_MIN_NUMBER_LUCKY_VALUE] doubleValue] : p.minValueToGenerateCoupons;
        //
        p.question = [keysList containsObject:CLASS_SHOPPING_PROMOTION_QUESTION] ? [PromotionSurveyQuestion createObjectFromDictionary:[neoDic  valueForKey:CLASS_SHOPPING_PROMOTION_QUESTION]] : p.question;
    }
    return p;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData  setValue:@(self.promotionID) forKey:CLASS_SHOPPING_PROMOTION_ID];
    [dicData  setValue:(self.name != nil ? self.name : @"") forKey:CLASS_SHOPPING_PROMOTION_NAME];
    [dicData  setValue:(self.urlImage != nil ? self.urlImage : @"") forKey:CLASS_SHOPPING_PROMOTION_URL_IMAGE];
    [dicData  setValue:(self.urlTerms != nil ? self.urlTerms : @"") forKey:CLASS_SHOPPING_PROMOTION_URL_TERMS];
    [dicData  setValue:@(self.isUserRegistered) forKey:CLASS_SHOPPING_PROMOTION_USER_REGISTERED];
    [dicData  setValue:@(self.isInvoiceScanPermited) forKey:CLASS_SHOPPING_PROMOTION_INVOICE_SCAN_PERMITED];
    [dicData  setValue:@(self.minValueToGenerateCoupons) forKey:CLASS_SHOPPING_PROMOTION_MIN_NUMBER_LUCKY_VALUE];
    [dicData setValue:[self.question dictionaryJSON] forKey:CLASS_SHOPPING_PROMOTION_QUESTION];
    //
    return dicData;
}

- (ShoppingPromotion*)copyObject
{
    ShoppingPromotion *sp = [ShoppingPromotion new];
    sp.promotionID = self.promotionID;
    sp.name = self.name != nil ? [NSString stringWithFormat:@"%@", self.name] : nil;
    sp.urlImage = self.urlImage != nil ? [NSString stringWithFormat:@"%@", self.urlImage] : nil;
    sp.urlTerms = self.urlTerms != nil ? [NSString stringWithFormat:@"%@", self.urlTerms] : nil;
    sp.isUserRegistered = self.isUserRegistered;
    sp.isInvoiceScanPermited = self.isInvoiceScanPermited;
    sp.minValueToGenerateCoupons = self.minValueToGenerateCoupons;
    sp.question = [self.question copyObject];
    //
    return sp;
}



@end
