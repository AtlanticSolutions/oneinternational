//
//  PromotionInvoice.h
//  ShoppingBH
//
//  Created by Erico GT on 06/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultObjectModelProtocol.h"
#import "ToolBox.h"

@interface PromotionInvoice : NSObject<DefaultObjectModelProtocol>

@property (nonatomic, strong) NSString *cnpj;
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) double totalAmount;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSDate *statusDate;
@property (nonatomic, strong) NSDate *invoiceDate;
@property (nonatomic, strong) NSString *nf;
@property (nonatomic, strong) UIColor *statusColor;
@property (nonatomic, strong) NSString *statusText;
@property (nonatomic, strong) NSString *statusDisapprovalMessage;

//Protocol Methods
+ (PromotionInvoice*)newObject;
+ (PromotionInvoice*)createObjectFromDictionary:(NSDictionary*)dicData;
- (NSDictionary*)dictionaryJSON;
- (PromotionInvoice*)copyObject;

@end
