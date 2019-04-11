//
//  AdAliveScannerTargetManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 07/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdAliveIdentifiedProduct.h"

@interface AdAliveScannerTargetManager : NSObject

@property(nonatomic, strong) NSMutableDictionary<NSString*, AdAliveIdentifiedProduct*> *productsFound;

- (BOOL)saveIdentifiedProductsToUser:(long)userID;
- (BOOL)loadIdentifiedProductsToUser:(long)userID;

@end
