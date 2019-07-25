//
//  CouponViewController.h
//  AdAlive
//
//  Created by Lab360 on 1/12/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CouponViewController : UIViewController

@property(nonatomic, strong) NSDictionary *couponData;
@property(nonatomic, strong) NSString *promotionId;
@property(nonatomic, strong) NSString *promotionName;
@property(nonatomic, strong) NSString *promotionType;

@end
