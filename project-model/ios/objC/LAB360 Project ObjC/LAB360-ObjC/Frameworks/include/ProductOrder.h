//
//  ProductOrder.h
//  SDK_FullProject
//
//  Created by Lab360 on 27/06/17.
//  Copyright © 2017 atlantic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductOrder : NSObject

@property(nonatomic, strong) NSNumber *productID;
@property(nonatomic, strong) NSString *quantity;
@property(nonatomic, strong) NSString *colour_code;

-(instancetype)initWithId:(NSNumber *)productID;

@end
