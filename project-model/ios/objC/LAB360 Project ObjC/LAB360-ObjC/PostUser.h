//
//  PostUser.h
//  GS&MD
//
//  Created by Erico GT on 1/17/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//
#import "ToolBox.h"

@interface PostUser : NSObject

//Propriedades:
@property (nonatomic, assign) long userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) UIImage *picture;

//Facilitadores:
+(PostUser*)newObject;
+(PostUser*)createObjectFromDictionary:(NSDictionary*)dicData;
-(PostUser*)copyObject;
-(NSDictionary*)dictionaryJSON;

@end
