//
//  AdAliveAction.h
//  GS&MD
//
//  Created by Erico GT on 29/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"

@interface AdAliveAction : NSObject<DefaultObjectModelProtocol>

//Properties
@property (nonatomic, assign) long actionID;
@property (nonatomic, strong) NSString *actionName;
@property (nonatomic, strong) NSString *actionURL;
@property (nonatomic, strong) NSString *type;
//
@property (nonatomic, strong) NSString *verticalURL;
@property (nonatomic, strong) NSString *horizontalURL;
//
@property (nonatomic, assign) long autoCloseTime;
//
@property (nonatomic, assign) long productID;
@property (nonatomic, strong) NSString *productSKU;

//Protocol Methods
+ (AdAliveAction*)newObject;
+ (AdAliveAction*)createObjectFromDictionary:(NSDictionary*)dicData;
- (NSDictionary*)dictionaryJSON;
- (AdAliveAction*)copyObject;

@end
