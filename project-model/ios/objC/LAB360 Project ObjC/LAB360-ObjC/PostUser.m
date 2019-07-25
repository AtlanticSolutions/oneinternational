//
//  PostUser.m
//  GS&MD
//
//  Created by Erico GT on 1/17/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "PostUser.h"

#define CLASS_POST_USER_ID @"id"
#define CLASS_POST_USER_NAME @"name"
#define CLASS_POST_USER_PICTURE_URL @"image_url"

@implementation PostUser

@synthesize userID, name, pictureURL, picture;

- (PostUser*)init
{
    self = [super init];
    if (self) {
        userID = 0;
        name = @"";
        pictureURL = @"";
        picture = nil;
    }
    return self;
}

+(PostUser*)newObject
{
    PostUser *postUser = [PostUser new];
    return postUser;
}

+(PostUser*)createObjectFromDictionary:(NSDictionary*)dicData
{
    PostUser *postUser = [PostUser new];
    
    //NSDictionary *dic = [dicData valueForKey:[Event className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        postUser.userID = [keysList containsObject:CLASS_POST_USER_ID] ? [[neoDic valueForKey:CLASS_POST_USER_ID] longValue] : postUser.userID;
        postUser.name = [keysList containsObject:CLASS_POST_USER_NAME] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_POST_USER_NAME]] : postUser.name;
        postUser.pictureURL = [keysList containsObject:CLASS_POST_USER_PICTURE_URL] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_POST_USER_PICTURE_URL]] : postUser.pictureURL;
        //postUser.picture = nil;
    }
    
    return postUser;
}

-(PostUser*)copyObject
{
    PostUser* postUser = [PostUser new];
    //
    postUser.userID = self.userID;
    postUser.name = [NSString stringWithFormat:@"%@", self.name];
    postUser.pictureURL = [NSString stringWithFormat:@"%@", self.pictureURL];
    postUser.picture = (self.picture==nil) ? nil : [UIImage imageWithData:UIImagePNGRepresentation(self.picture)];
    //
    return postUser;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //
    [dic setValue:@(self.userID) forKey:CLASS_POST_USER_ID];
    [dic setValue:name forKey:CLASS_POST_USER_NAME];
    [dic setValue:pictureURL forKey:CLASS_POST_USER_PICTURE_URL];
    //
    return dic;
}

@end
