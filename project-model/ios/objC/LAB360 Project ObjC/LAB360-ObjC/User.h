//
//  User.h
//  AHK-100anos
//
//  Created by Erico GT on 10/5/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"

@interface User : NSObject<DefaultObjectModelProtocol>

//Properties
@property (nonatomic, assign) int userID;
@property (nonatomic, assign) int accountID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *CPF;
@property (nonatomic, strong) NSString *RG;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSNumber *jobRole;
@property (nonatomic, strong) NSString *jobRoleDescription;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *CNPJ;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSMutableArray *category;
@property (nonatomic, strong) NSString *sectorName;
@property (nonatomic, assign) int sectorID;
@property (nonatomic, strong) UIImage *profilePic;
@property (nonatomic, strong) NSString *urlProfilePic;
@property (nonatomic, assign) bool chatBlocked;
@property (nonatomic, assign) NSInteger notReadCount;
@property (nonatomic, strong) NSDate *birthdate;
@property (nonatomic, strong) NSString *addressNumber;
@property (nonatomic, strong) NSString *complement;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *mobilePhoneDDD;
@property (nonatomic, strong) NSString *phoneDDD;
//@property (nonatomic, strong) NSMutableArray *authorizedEventsList;

//- (bool)checkAuthorizationForEvent:(int)eventID;

//Protocol Methods
+ (User*)newObject;
+ (NSString*)className;
+ (User*)createObjectFromDictionary:(NSDictionary*)dicData;
- (User*)copyObject;
- (NSDictionary*)dictionaryJSON;
- (NSDictionary*)dictionaryJSON_NoImage;
- (bool)isEqualToObject:(User *)object;

@end
