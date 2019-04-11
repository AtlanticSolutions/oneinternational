//
//  SubscribedUser.h
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 17/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"

@interface SubscribedUser : NSObject<DefaultObjectModelProtocol>

//Properties
@property (nonatomic, assign) int eventID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *CPF;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *CNPJ;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *adjunct;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *homePage;


//Protocol Methods
+ (SubscribedUser*)newObject;
+ (NSString*)className;
+ (SubscribedUser*)createObjectFromDictionary:(NSDictionary*)dicData;
- (SubscribedUser*)copyObject;
- (NSDictionary*)dictionaryJSON;

@end
