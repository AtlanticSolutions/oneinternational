//
//  ShoppingPromotion.h
//  ShoppingBH
//
//  Created by Erico GT on 03/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PromotionSurveyQuestion.h"
#import "DefaultObjectModelProtocol.h"
#import "ToolBox.h"

@interface ShoppingPromotion : NSObject<DefaultObjectModelProtocol>

@property (nonatomic, assign) long promotionID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *urlImage;
@property (nonatomic, strong) NSString *urlTerms;
@property (nonatomic, assign) bool isUserRegistered;
@property (nonatomic, assign) bool isInvoiceScanPermited;
@property (nonatomic, assign) double minValueToGenerateCoupons;
@property (nonatomic, strong) PromotionSurveyQuestion *question;

//Protocol Methods
+ (ShoppingPromotion*)newObject;
+ (ShoppingPromotion*)createObjectFromDictionary:(NSDictionary*)dicData;
- (NSDictionary*)dictionaryJSON;
- (ShoppingPromotion*)copyObject;

@end
