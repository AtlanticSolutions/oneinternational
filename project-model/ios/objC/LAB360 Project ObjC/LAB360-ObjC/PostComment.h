//
//  PostComment.h
//  GS&MD
//
//  Created by Erico GT on 1/17/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
//
#import "PostUser.h"
#import "ToolBox.h"

@interface PostComment : NSObject

@property (nonatomic, assign) long commentID;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) PostUser *user;

//Facilitadores:
+(PostComment*)newObject;
+(PostComment*)createObjectFromDictionary:(NSDictionary*)dicData;
-(PostComment*)copyObject;
-(NSDictionary*)dictionaryJSON;

@end
