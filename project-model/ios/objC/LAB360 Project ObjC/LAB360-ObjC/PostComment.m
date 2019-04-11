//
//  PostComment.m
//  GS&MD
//
//  Created by Erico GT on 1/17/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "PostComment.h"

#define CLASS_POST_COMMENT_ID @"id"
#define CLASS_POST_COMMENT_DATE @"created_at"
#define CLASS_POST_COMMENT_MESSAGE @"message"
#define CLASS_POST_COMMENT_USER @"app_user"

@implementation PostComment

@synthesize commentID, date, message, user;

- (PostComment*)init
{
    self = [super init];
    if (self) {
        commentID = 0;
        message = @"";
        date = nil;
        user = [PostUser new];
    }
    return self;
}

+(PostComment*)newObject
{
    PostComment *postComment = [PostComment new];
    return postComment;
}

+(PostComment*)createObjectFromDictionary:(NSDictionary*)dicData
{
    PostComment *postComment = [PostComment new];
    
    //NSDictionary *dic = [dicData valueForKey:[Event className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        postComment.commentID = [keysList containsObject:CLASS_POST_COMMENT_ID] ? [[neoDic valueForKey:CLASS_POST_COMMENT_ID] longValue] : postComment.commentID;
        postComment.message = [keysList containsObject:CLASS_POST_COMMENT_MESSAGE] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_POST_COMMENT_MESSAGE]] : postComment.message;
        postComment.date = [keysList containsObject:CLASS_POST_COMMENT_DATE] ?  [ToolBox dateHelper_DateFromString:[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_POST_COMMENT_DATE]] withFormat:TOOLBOX_DATA_BARRA_COMPLETA_NORMAL] : postComment.date;
        postComment.user = [keysList containsObject:CLASS_POST_COMMENT_USER] ?  [PostUser createObjectFromDictionary:[neoDic valueForKey:CLASS_POST_COMMENT_USER]] : postComment.user;
    }
    
    return postComment;
}

-(PostComment*)copyObject
{
    PostComment* postComment = [PostComment new];
    //
    postComment.commentID = self.commentID;
    postComment.message = [NSString stringWithFormat:@"%@", self.message];
    postComment.date = (self.date==nil) ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:self.date];
    postComment.user = [self.user copyObject];
    //
    return postComment;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //
    [dic setValue:@(self.commentID) forKey:CLASS_POST_COMMENT_ID];
    [dic setValue:self.message forKey:CLASS_POST_COMMENT_MESSAGE];
    [dic setValue:[ToolBox dateHelper_StringFromDate:self.date withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] forKey:CLASS_POST_COMMENT_DATE];
    [dic setValue:[self.user dictionaryJSON] forKey:CLASS_POST_COMMENT_USER];
    //
    return dic;
}


@end
