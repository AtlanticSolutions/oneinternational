//
//  AdAliveIdentifiedProduct.h
//  LAB360-ObjC
//
//  Created by Erico GT on 07/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdAliveIdentifiedProduct : NSObject

@property(nonatomic, strong) NSString* targetID;
@property(nonatomic, strong) NSString* identificationDate;
@property(nonatomic, strong) NSDictionary* productData;
//
@property(nonatomic, strong) UIImage* productImage;
@property(nonatomic, strong) NSDate* objDate;

@end
