//
//  StoreReviewHelper.h
//  ARC360
//
//  Created by Erico GT on 26/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreReviewHelper : NSObject

+ (void)incrementAppOpenedCount;
+ (void)checkAndAskForReview;

@end
