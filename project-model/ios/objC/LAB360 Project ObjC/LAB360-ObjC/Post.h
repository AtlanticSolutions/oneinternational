//
//  Post.h
//  GS&MD
//
//  Created by Erico GT on 1/17/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//
#import "PostUser.h"
#import "PostLike.h"
#import "PostComment.h"
//
#import "ToolBox.h"

typedef enum {
    TimelinePostTypeMessage       = 1,
    TimelinePostTypePhoto         = 2,
    TimelinePostTypeVideo         = 3
} TimelinePostType;

@interface Post : NSObject

//Propriedades:
@property (nonatomic, assign) long postID;
@property (nonatomic, assign) long accountID; //fixo para o app
@property (nonatomic, assign) long masterEventID; //vem junto ao enviar o código no login
//
@property (nonatomic, assign) TimelinePostType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, assign) bool sponsored;
@property (nonatomic, strong) NSString *sponsorURL;
@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) NSString *videoURL;
@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, strong) NSMutableArray<PostLike*> *likeList;
@property (nonatomic, strong) NSMutableArray<PostComment*> *commentsList;
@property (nonatomic, strong) PostUser *user;
@property (nonatomic, assign) BOOL expandedView;
//
@property (nonatomic, assign) bool likeBlocked;

//Métodos:
- (bool)checkLikeForUser:(long)userID;
- (bool)checkCommentForUser:(long)userID;

//Facilitadores:
+(Post*)newObject;
+(Post*)createObjectFromDictionary:(NSDictionary*)dicData;
-(Post*)copyObject;
-(NSDictionary*)dictionaryJSON;

@end
