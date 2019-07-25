//
//  Post.m
//  GS&MD
//
//  Created by Erico GT on 1/17/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "Post.h"

#define CLASS_POST_ID @"id"
#define CLASS_POST_ACCOUNT_ID @"account_id"
#define CLASS_POST_MASTER_EVENT_ID @"master_event_id"
//
#define CLASS_POST_TITLE @"title"
#define CLASS_POST_MESSAGE @"message"
#define CLASS_POST_CREATED_AT @"created_at" // "10/01/2017 07:21:42UTC"
#define CLASS_POST_SPONSOR @"sponsor"
#define CLASS_POST_SPONSOR_URL @"sponsor_url"
#define CLASS_POST_PICTURE_URL @"picture_url"
#define CLASS_POST_VIDEO_URL @"href_video" // NOTE: ericogt >> estava como 'video_url' até o dia 03/07/2018.
#define CLASS_POST_PICTURE_BASE64 @"base64_picture"
#define CLASS_POST_LIKES @"like"
#define CLASS_POST_COMMENTS @"comment"
#define CLASS_POST_USER @"app_user"

@implementation Post

@synthesize postID, accountID, masterEventID, type, title, message, createdDate, sponsored, sponsorURL, pictureURL, videoURL, picture, likeList, commentsList, user, likeBlocked, expandedView;

- (Post*)init
{
    self = [super init];
    if (self) {
        postID = 0;
        accountID = 1; //fixo
        masterEventID = 0; //vem na validação do code
        //
        title = @"";
        message = @"";
        createdDate = nil;
        sponsored = false;
        sponsorURL = @"";
        pictureURL = @"";
        videoURL = @"";
        likeList = [NSMutableArray new];
        commentsList = [NSMutableArray new];
        user = [PostUser new];
        likeBlocked = false;
        expandedView = NO;
    }
    return self;
}

//************************************************************************************************************************

+(Post*)newObject
{
    Post *post = [Post new];
    return post;
}

+(Post*)createObjectFromDictionary:(NSDictionary*)dicData
{
    Post *post = [Post new];
    
    //NSDictionary *dic = [dicData valueForKey:[Event className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        post.postID = [keysList containsObject:CLASS_POST_ID] ? [[neoDic valueForKey:CLASS_POST_ID] longValue] : post.postID;
        post.accountID = 1; //fixo
        post.masterEventID = [keysList containsObject:CLASS_POST_MASTER_EVENT_ID] ? [[neoDic valueForKey:CLASS_POST_MASTER_EVENT_ID] longValue] : post.masterEventID;
        //
        post.title = [keysList containsObject:CLASS_POST_TITLE] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_POST_TITLE]] : post.title;
        post.message = [keysList containsObject:CLASS_POST_MESSAGE] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_POST_MESSAGE]] : post.title;
        post.createdDate = [keysList containsObject:CLASS_POST_CREATED_AT] ?  [ToolBox dateHelper_DateFromString:[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_POST_CREATED_AT]] withFormat:TOOLBOX_DATA_BARRA_COMPLETA_NORMAL] : post.createdDate;
        post.sponsored = [keysList containsObject:CLASS_POST_SPONSOR] ? [[neoDic valueForKey:CLASS_POST_SPONSOR] boolValue] : post.sponsored;
        post.sponsorURL = [keysList containsObject:CLASS_POST_SPONSOR_URL] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_POST_SPONSOR_URL]] : post.sponsorURL;
        post.pictureURL = [keysList containsObject:CLASS_POST_PICTURE_URL] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_POST_PICTURE_URL]] : post.pictureURL;
        post.videoURL = [keysList containsObject:CLASS_POST_VIDEO_URL] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_POST_VIDEO_URL]] : post.videoURL;
        //
        if ([keysList containsObject:CLASS_POST_LIKES]){
            NSArray *likes = [neoDic valueForKey:CLASS_POST_LIKES];
            for (NSDictionary *dic in likes){
                [post.likeList addObject:[PostLike createObjectFromDictionary:dic]];
            }
        }
        //
        if ([keysList containsObject:CLASS_POST_COMMENTS]){
            NSArray *comments = [neoDic valueForKey:CLASS_POST_COMMENTS];
            for (NSDictionary *dic in comments){
                [post.commentsList addObject:[PostComment createObjectFromDictionary:dic]];
            }
        }
        //
        post.user = [keysList containsObject:CLASS_POST_USER] ? [PostUser createObjectFromDictionary:[neoDic valueForKey:CLASS_POST_USER]] : post.user;
        
        //Exemplos de posts com vídeos:
        //post.videoURL = @"https://www.rmp-streaming.com/media/bbb-720p.mp4";
        //post.videoURL = @"https://www.youtube.com/watch?v=bDWPcV3rmOo";
        
        //Type:
        if (post.videoURL == nil || [post.videoURL isEqualToString:@""]){
            if (post.pictureURL == nil || [post.pictureURL isEqualToString:@""]){
                post.type = TimelinePostTypeMessage;
            }else{
                post.type = TimelinePostTypePhoto;
            }
        }else{
            post.type = TimelinePostTypeVideo;
        }
    }
    
    return post;
}

-(Post*)copyObject
{
    Post* post = [Post new];
    //
    post.postID = self.postID;
    post.accountID = self.accountID; //fixo
    post.masterEventID = self.masterEventID;
    //
    post.type = self.type;
    post.title = [NSString stringWithFormat:@"%@", self.title];
    post.message = [NSString stringWithFormat:@"%@", self.message];
    post.createdDate = (self.createdDate==nil) ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:self.createdDate];
    post.sponsored = self.sponsored;
    post.sponsorURL = [NSString stringWithFormat:@"%@", self.sponsorURL];
    post.pictureURL = [NSString stringWithFormat:@"%@", self.pictureURL];
    post.videoURL = [NSString stringWithFormat:@"%@", self.videoURL];
    //
    if (self.likeList == nil){
        post.likeList = nil;
    }else{
        for (PostLike *like in self.likeList){
            [post.likeList addObject:[like copyObject]];
        }
    }
    //
    if (self.commentsList == nil){
        post.commentsList = nil;
    }else{
        for (PostComment *comment in self.commentsList){
            [post.commentsList addObject:[comment copyObject]];
        }
    }
    //
    if (self.user == nil){
        post.user = nil;
    }else{
        post.user = [self.user copyObject];
    }
    //
    post.expandedView = expandedView;
    post.likeBlocked = likeBlocked;
    //
    return post;
}

-(NSDictionary*)dictionaryJSON
{
//    "title": "Teste",
//    "message": "Bom noite",
//    "account_id": "1",
//    "app_user_id": "2"
//    "base64_picture": ""
//    "app_id": "1"
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //
    [dic setValue:@(self.postID) forKey:CLASS_POST_ID];
    [dic setValue:@(self.accountID) forKey:CLASS_POST_ACCOUNT_ID];
    [dic setValue:@(self.masterEventID) forKey:CLASS_POST_MASTER_EVENT_ID];
    //
    [dic setValue:self.title forKey:CLASS_POST_TITLE];
    [dic setValue:self.message forKey:CLASS_POST_MESSAGE];
    //[dic setValue:[ToolBox dateHelper_StringFromDate:createdDate withFormat:TOOLBOX_DATA_GSMD_ddMMyyyy_HHmmssZ] forKey:CLASS_POST_CREATED_AT];
    //[dic setValue:@(self.sponsored) forKey:CLASS_POST_SPONSOR];
    //[dic setValue:self.pictureURL forKey:CLASS_POST_PICTURE_URL];
    NSString *base64 = [ToolBox graphicHelper_EncodeToBase64String:self.picture];
    [dic setValue: (base64 ? base64 : @"") forKey:CLASS_POST_PICTURE_BASE64];
    //[dic setValue:self.likeList forKey:CLASS_POST_LIKES];
    //[dic setValue:self.commentsList forKey:CLASS_POST_COMMENTS];
    [dic setValue:@(self.user.userID) forKey:@"app_user_id"];
    //
    return dic;
}


- (bool)checkLikeForUser:(long)userID
{
    for (PostLike *like in likeList){
        if (like.user.userID == userID){
            return true;
        }
    }
    //
    return false;
}

- (bool)checkCommentForUser:(long)userID
{
    for (PostComment *comment in commentsList){
        if (comment.user.userID == userID){
            return true;
        }
    }
    //
    return false;
}

@end
