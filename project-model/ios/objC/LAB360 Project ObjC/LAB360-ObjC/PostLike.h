//
//  PostLike.h
//  GS&MD
//
//  Created by Erico GT on 1/17/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
//
#import "PostUser.h"

@interface PostLike : NSObject

@property (nonatomic, assign) long likeID;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) PostUser *user;

//Facilitadores:
+(PostLike*)newObject;
+(PostLike*)createObjectFromDictionary:(NSDictionary*)dicData;
-(PostLike*)copyObject;
-(NSDictionary*)dictionaryJSON;

@end
