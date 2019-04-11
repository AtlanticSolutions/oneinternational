//
//  ShoppingStore.h
//  ShoppingBH
//
//  Created by Erico GT on 06/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultObjectModelProtocol.h"
#import "ToolBox.h"

@interface ShoppingStore : NSObject<DefaultObjectModelProtocol>

@property (nonatomic, assign) long storeID;
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSString *cnpj;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *logoURL;
@property (nonatomic, strong) NSString *corridor;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *floor;
@property (nonatomic, strong) NSString *segment;
@property (nonatomic, strong) NSString *corporateName;
@property (nonatomic, assign) bool qrCode;


//Protocol Methods
+ (ShoppingStore*)newObject;
+ (ShoppingStore*)createObjectFromDictionary:(NSDictionary*)dicData;
- (NSDictionary*)dictionaryJSON;
- (ShoppingStore*)copyObject;

@end
