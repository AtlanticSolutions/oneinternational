//
//  StoreReviewHelper.m
//  ARC360
//
//  Created by Erico GT on 26/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "StoreReviewHelper.h"
#import <StoreKit/StoreKit.h>

#define APP_OPENED_COUNT @"ADALIVE_APP_OPENED_COUNT"

@implementation StoreReviewHelper

+ (void)incrementAppOpenedCount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *count = [userDefaults valueForKey:APP_OPENED_COUNT];
    
    if (count == nil){
        [userDefaults setInteger:1 forKey:APP_OPENED_COUNT];
    }else{
        [userDefaults setInteger:([count integerValue] + 1) forKey:APP_OPENED_COUNT];
    }
    [userDefaults synchronize];
}

+ (void)checkAndAskForReview
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *count = [userDefaults valueForKey:APP_OPENED_COUNT];
    
    if (count == nil){
        count = @(1);
    }
    
    switch ([count integerValue]) {
        case 5:{
            [self requestReview];
        }break;
        //
        case 10:{
            [self requestReview];
        }break;
        //
        default:{
            NSLog(@"App run count is: %li", [count integerValue]);
        }break;
    }
}

+ (void)requestReview
{
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    }
}

@end
