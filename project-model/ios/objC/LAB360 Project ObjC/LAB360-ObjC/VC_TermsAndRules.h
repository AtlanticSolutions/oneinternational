//
//  VC_PromotionTerms.h
//  ShoppingBH
//
//  Created by Erico GT on 03/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "WebItemToShow.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

typedef enum {
    eTermsAndRulesScreenType_Promotion = 1,
    eTermsAndRulesScreenType_Store = 2
} enumTermsAndRulesScreenType;

#pragma mark - • INTERFACE
@interface VC_TermsAndRules : UIViewController<UIWebViewDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, assign) enumTermsAndRulesScreenType screenType;
@property (nonatomic, strong) WebItemToShow *webItem;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
