//
//  Contact.h
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 24/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"

@interface Contact : NSObject<DefaultObjectModelProtocol>

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* department;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* role;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* departmentDescription;
@property (nonatomic, strong) NSString* facebook;
@property (nonatomic, strong) NSString* twitter;
@property (nonatomic, strong) NSString* linkedin;
@property (nonatomic, strong) NSString* urlProfileImage;
@property (nonatomic, strong) UIImage* imgProfile;

//Protocol Methods
+ (Contact*)newObject;
+ (NSString*)className;
+ (Contact*)createObjectFromDictionary:(NSDictionary*)dicData;
- (Contact*)copyObject;
- (NSDictionary*)dictionaryJSON;

@end
