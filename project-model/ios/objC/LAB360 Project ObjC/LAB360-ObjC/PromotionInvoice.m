//
//  PromotionInvoice.m
//  ShoppingBH
//
//  Created by Erico GT on 06/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "PromotionInvoice.h"

#define CLASS_SHOPPING_INVOICE_DEFAULT @"nfs"
#define CLASS_SHOPPING_INVOICE_CNPJ @"cnpj"
#define CLASS_SHOPPING_INVOICE_STORE_NAME @"store_name"
#define CLASS_SHOPPING_INVOICE_IMAGE_URL @"image_url"
#define CLASS_SHOPPING_INVOICE_TOTAL_AMOUNT @"total_amount"
#define CLASS_SHOPPING_INVOICE_STATUS @"status"
#define CLASS_SHOPPING_INVOICE_STATUS_DATE @"status_date"
#define CLASS_SHOPPING_INVOICE_DATE @"date"
#define CLASS_SHOPPING_INVOICE_NF @"nf"
#define CLASS_SHOPPING_INVOICE_STATUS_TEXT @"status_text"
#define CLASS_SHOPPING_INVOICE_STATUS_COLOR @"status_color"
#define CLASS_SHOPPING_INVOICE_STATUS_DISAPPROVAL_MSG @"reason_disapproval="

@implementation PromotionInvoice

@synthesize cnpj, storeName, imageURL, totalAmount, status, statusDate, invoiceDate, nf, statusColor, statusText, statusDisapprovalMessage;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        cnpj = DOMP_OPD_STRING;
        storeName = DOMP_OPD_STRING;
        imageURL = DOMP_OPD_STRING;
        totalAmount = DOMP_OPD_DOUBLE;
        status = DOMP_OPD_STRING;
        statusDate = DOMP_OPD_DATE;
        invoiceDate = DOMP_OPD_DATE;
        nf = DOMP_OPD_STRING;
        statusColor = nil;
        statusText = DOMP_OPD_STRING;
        statusDisapprovalMessage = DOMP_OPD_STRING;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------
+(PromotionInvoice*)newObject
{
    PromotionInvoice *pi = [PromotionInvoice new];
    return pi;
}

+ (PromotionInvoice*)createObjectFromDictionary:(NSDictionary*)dicData
{
    PromotionInvoice *p = [PromotionInvoice new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        p.cnpj = [keysList containsObject:CLASS_SHOPPING_INVOICE_CNPJ] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_INVOICE_CNPJ]] : p.cnpj;
        p.storeName = [keysList containsObject:CLASS_SHOPPING_INVOICE_STORE_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_INVOICE_STORE_NAME]] : p.storeName;
        p.imageURL = [keysList containsObject:CLASS_SHOPPING_INVOICE_IMAGE_URL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_INVOICE_IMAGE_URL]] : p.imageURL;
        p.totalAmount = [keysList containsObject:CLASS_SHOPPING_INVOICE_TOTAL_AMOUNT] ? [[neoDic  valueForKey:CLASS_SHOPPING_INVOICE_TOTAL_AMOUNT] doubleValue] : p.totalAmount;
        p.status = [keysList containsObject:CLASS_SHOPPING_INVOICE_STATUS] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_INVOICE_STATUS]] : p.status;
        p.statusDate = [keysList containsObject:CLASS_SHOPPING_INVOICE_STATUS_DATE] ? [ToolBox dateHelper_DateFromString:[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_SHOPPING_INVOICE_STATUS_DATE]] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] : p.statusDate;
        p.invoiceDate = [keysList containsObject:CLASS_SHOPPING_INVOICE_DATE] ? [ToolBox dateHelper_DateFromString:[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_SHOPPING_INVOICE_DATE]] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] : p.invoiceDate;
        p.nf = [keysList containsObject:CLASS_SHOPPING_INVOICE_NF] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_INVOICE_NF]] : p.nf;
        p.statusText = [keysList containsObject:CLASS_SHOPPING_INVOICE_STATUS_TEXT] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_INVOICE_STATUS_TEXT]] : p.statusText;
        p.statusColor = [keysList containsObject:CLASS_SHOPPING_INVOICE_STATUS_COLOR] ? [ToolBox graphicHelper_colorWithHexString:[neoDic  valueForKey:CLASS_SHOPPING_INVOICE_STATUS_COLOR]] : p.statusColor;
        p.statusDisapprovalMessage = [keysList containsObject:CLASS_SHOPPING_INVOICE_STATUS_DISAPPROVAL_MSG] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SHOPPING_INVOICE_STATUS_DISAPPROVAL_MSG]] : p.statusDisapprovalMessage;
    }
    return p;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData  setValue:(self.cnpj != nil ? self.cnpj : @"") forKey:CLASS_SHOPPING_INVOICE_CNPJ];
    [dicData  setValue:(self.storeName != nil ? self.storeName : @"") forKey:CLASS_SHOPPING_INVOICE_STORE_NAME];
    [dicData  setValue:(self.imageURL != nil ? self.imageURL : @"") forKey:CLASS_SHOPPING_INVOICE_IMAGE_URL];
    [dicData  setValue:@(self.totalAmount) forKey:CLASS_SHOPPING_INVOICE_TOTAL_AMOUNT];
    [dicData  setValue:(self.status != nil ? self.status : @"") forKey:CLASS_SHOPPING_INVOICE_STATUS];
    [dicData  setValue:(self.statusDate != nil ? [ToolBox dateHelper_StringFromDate:self.statusDate withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] : @"") forKey:CLASS_SHOPPING_INVOICE_STATUS_DATE];
    [dicData  setValue:(self.invoiceDate != nil ? [ToolBox dateHelper_StringFromDate:self.invoiceDate withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] : @"") forKey:CLASS_SHOPPING_INVOICE_STATUS_DATE];
    [dicData  setValue:(self.nf != nil ? self.nf : @"") forKey:CLASS_SHOPPING_INVOICE_NF];
    [dicData  setValue:(self.statusText != nil ? self.statusText : @"") forKey:CLASS_SHOPPING_INVOICE_STATUS_TEXT];
    [dicData  setValue:[ToolBox graphicHelper_hexStringFromUIColor:self.statusColor] forKey:CLASS_SHOPPING_INVOICE_STATUS_COLOR];
    [dicData  setValue:(self.statusDisapprovalMessage != nil ? self.statusDisapprovalMessage : @"") forKey:CLASS_SHOPPING_INVOICE_STATUS_DISAPPROVAL_MSG];
    //
    return dicData;
}

- (PromotionInvoice*)copyObject
{
    PromotionInvoice *pi = [PromotionInvoice new];
    pi.cnpj = self.cnpj != nil ? [NSString stringWithFormat:@"%@", self.cnpj] : nil;
    pi.storeName = self.storeName != nil ? [NSString stringWithFormat:@"%@", self.storeName] : nil;
    pi.imageURL = self.imageURL != nil ? [NSString stringWithFormat:@"%@", self.imageURL] : nil;
    pi.totalAmount = self.totalAmount;
    pi.status = self.status != nil ? [NSString stringWithFormat:@"%@", self.status] : nil;
    pi.statusDate = (self.statusDate == nil) ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:self.statusDate];
    pi.invoiceDate = (self.invoiceDate == nil) ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:self.invoiceDate];
    pi.nf = self.nf != nil ? [NSString stringWithFormat:@"%@", self.nf] : nil;
    pi.statusText = self.statusText != nil ? [NSString stringWithFormat:@"%@", self.statusText] : nil;
    pi.statusColor = self.statusColor != nil ? [[UIColor alloc] initWithCGColor:self.statusColor.CGColor] : nil;
    pi.statusDisapprovalMessage = self.statusDisapprovalMessage != nil ? [NSString stringWithFormat:@"%@", self.statusDisapprovalMessage] : nil;
    //
    return pi;
}

@end
