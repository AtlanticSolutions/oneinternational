//
//  VC_PromotionsExtract.h
//  ShoppingBH
//
//  Created by Erico GT on 06/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "TVC_SurveyOptionPromotion.h"
#import "ShoppingPromotion.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_PromotionsExtract : UIViewController<UITableViewDelegate, UITableViewDataSource>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) ShoppingPromotion *promotion;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
