//
//  PostLike.m
//  GS&MD
//
//  Created by Erico GT on 1/17/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "PostLike.h"

#define CLASS_POST_LIKE_ID @"id"
#define CLASS_POST_LIKE_DATE @"date"
#define CLASS_POST_LIKE_USER @"app_user"

@implementation PostLike

@synthesize likeID, date, user;

- (PostLike*)init
{
    self = [super init];
    if (self) {
        likeID = 0;
        date = nil;
        user = [PostUser new];
    }
    return self;
}

+(PostLike*)newObject
{
    PostLike *postLike = [PostLike new];
    return postLike;
}

+(PostLike*)createObjectFromDictionary:(NSDictionary*)dicData
{
    PostLike *postLike = [PostLike new];
    
    //NSDictionary *dic = [dicData valueForKey:[Event className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        postLike.likeID = [keysList containsObject:CLASS_POST_LIKE_ID] ? [[neoDic valueForKey:CLASS_POST_LIKE_ID] longValue] : postLike.likeID;
        postLike.date = [keysList containsObject:CLASS_POST_LIKE_DATE] ?  [ToolBox dateHelper_DateFromString:[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_POST_LIKE_DATE]] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] : postLike.date;
        postLike.user = [keysList containsObject:CLASS_POST_LIKE_USER] ?  [PostUser createObjectFromDictionary:[neoDic valueForKey:CLASS_POST_LIKE_USER]] : postLike.user;
    }
    
    return postLike;
}

-(PostLike*)copyObject
{
    PostLike* postLike = [PostLike new];
    //
    postLike.likeID = self.likeID;
    postLike.date = (self.date==nil) ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:self.date];
    postLike.user = [self.user copyObject];
    //
    return postLike;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //
    [dic setValue:@(self.likeID) forKey:CLASS_POST_LIKE_ID];
    [dic setValue:[ToolBox dateHelper_StringFromDate:self.date withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] forKey:CLASS_POST_LIKE_DATE];
    [dic setValue:[self.user dictionaryJSON] forKey:CLASS_POST_LIKE_USER];
    //
    return dic;
}

@end
