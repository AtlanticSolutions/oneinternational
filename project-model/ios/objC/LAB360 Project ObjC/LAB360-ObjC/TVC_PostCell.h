//
//  TVC_PostCell.h
//  GS&MD
//
//  Created by Erico GT on 1/13/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "ToolBox.h"
#import "UIViewVideoPlayer.h"

@protocol PostCellVideoDelegate <NSObject>
@required
- (void)postCellVideoDelegateNeedEnterFullScreenWithIndex:(long)cellIndex;
@optional
- (void)postCellVideoDelegateDidChangeVideoMutedState:(BOOL)newState withIndex:(long)cellIndex;
@end

@interface TVC_PostCell : UITableViewCell<UIViewVideoPlayerDelegate>

typedef enum {
    eTVC_PostType_Empty         =0,
    eTVC_PostType_TextOnly      =1,
    eTVC_PostType_PhotoOnly     =2,
    eTVC_PostType_VideoOnly     =3,
    eTVC_PostType_TextAndPhoto  =4,
    eTVC_PostType_TextAndVideo  =5
} enumTVC_PostType;

//Views de composição
@property (nonatomic, weak) IBOutlet UIView *viewBase;
@property (nonatomic, weak) IBOutlet UIView *viewHeader;
@property (nonatomic, weak) IBOutlet UIView *viewText;
@property (nonatomic, weak) IBOutlet UIView *viewPhoto;
@property (nonatomic, weak) IBOutlet UIView *viewFooter;

//View Header
@property (nonatomic, weak) IBOutlet UIImageView *imvHeader_UserPicture;
@property (nonatomic, weak) IBOutlet UILabel *lblHeader_UserName;
@property (nonatomic, weak) IBOutlet UILabel *lblHeader_PostDate;
@property (nonatomic, weak) IBOutlet UIButton *btnHeader_Options;
@property (nonatomic, weak) IBOutlet UIView *viewLike;
@property (nonatomic, weak) IBOutlet UIView *viewComments;

//View Text
@property (nonatomic, weak) IBOutlet UILabel *lblText_PostText;
@property (nonatomic, weak) IBOutlet UIButton *btnPostTextViewMore;

//View Photo
@property (nonatomic, weak) IBOutlet UIImageView *imvPhoto_PostImage;
@property (nonatomic, weak) IBOutlet UIView *viewPhoto_Action;
@property (nonatomic, weak) IBOutlet UIImageView *imvPhotoAction_Icon;
@property (nonatomic, weak) IBOutlet UILabel *lblPhotoAction_Title;
@property (nonatomic, weak) IBOutlet UIButton *btnPhotoAction_Activation;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UIViewVideoPlayer *viewVideo;
@property (nonatomic, weak) IBOutlet UIView *viewVideoControls;
@property (nonatomic, weak) IBOutlet UIView *viewVideoContainer;
@property (nonatomic, weak) IBOutlet UIView *viewVideoTimerBar;
@property (nonatomic, weak) IBOutlet UIButton *btnVideoMute;
@property (nonatomic, weak) IBOutlet UIButton *btnVideoPlay;
@property (nonatomic, weak) IBOutlet UIButton *btnVideoFullScreen;
@property (nonatomic, weak) IBOutlet UILabel *lblVideoTime;
@property (nonatomic, weak) IBOutlet UIProgressView *progressVideo;

//View Footer
@property (nonatomic, weak) IBOutlet UILabel *lblFooter_TotalComments;
@property (nonatomic, weak) IBOutlet UIImageView *imvFooter_Line;
@property (nonatomic, weak) IBOutlet UIImageView *imvFooter_Like;
@property (nonatomic, weak) IBOutlet UIImageView *imvFooter_Comments;
@property (nonatomic, weak) IBOutlet UILabel *lblFooter_Like;
@property (nonatomic, weak) IBOutlet UILabel *lblFooter_Comments;
@property (nonatomic, weak) IBOutlet UIButton *btnFooter_Like;
@property (nonatomic, weak) IBOutlet UIButton *btnFooter_Comments;

@property (nonatomic, assign) long referenceObjectID;

//Delegate
@property (nonatomic, weak) id<PostCellVideoDelegate> videoDelegate;

//Methods:
- (void)updateLayoutForPostType:(enumTVC_PostType)type andSponsor:(bool)sponsor;
- (void)playVideoWithURL:(NSString*)videoURL muted:(BOOL)videoMuted looping:(BOOL)loopingEnabled;
- (void)stopVideo;
//
- (void)showOrHideVideoControls;
//
+ (void)stopCurrentVideoPlayback;

@end
