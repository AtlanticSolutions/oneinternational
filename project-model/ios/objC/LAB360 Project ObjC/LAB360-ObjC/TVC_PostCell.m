//
//  TVC_PostCell.m
//  GS&MD
//
//  Created by Erico GT on 1/13/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_PostCell.h"

@interface TVC_PostCell()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewTextConstraintHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewPhotoConstraintHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *viewPhotoActionConstraintHeight;
//
@property (nonatomic, assign) BOOL isShowingVideoControls;
@property (nonatomic, assign) BOOL videoLoopingEnabled;

@end

@implementation TVC_PostCell

@synthesize viewTextConstraintHeight, viewPhotoConstraintHeight, viewPhotoActionConstraintHeight;
//
@synthesize viewBase, viewHeader, viewText, viewPhoto, viewFooter;
@synthesize imvHeader_UserPicture, lblHeader_UserName, lblHeader_PostDate, btnHeader_Options;
@synthesize lblText_PostText, btnPostTextViewMore;
@synthesize imvPhoto_PostImage, viewPhoto_Action, imvPhotoAction_Icon, lblPhotoAction_Title, btnPhotoAction_Activation, activityIndicator;
@synthesize viewVideo, progressVideo, viewVideoControls, btnVideoMute, btnVideoPlay, btnVideoFullScreen, lblVideoTime, isShowingVideoControls, videoLoopingEnabled, viewVideoContainer, viewVideoTimerBar;
@synthesize lblFooter_TotalComments, imvFooter_Line, imvFooter_Like, imvFooter_Comments, lblFooter_Like, lblFooter_Comments, btnFooter_Like, btnFooter_Comments;
@synthesize referenceObjectID;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_TIMELINE_VIDEO_PLAYER_START_RUNNING object:nil];
}

- (void)updateLayoutForPostType:(enumTVC_PostType)type andSponsor:(bool)sponsor;
{
    viewVideo.referenceObjectID = self.referenceObjectID;
    
    self.backgroundColor = nil;
    self.backgroundView.backgroundColor = nil;
    //
    [ToolBox graphicHelper_ApplyShadowToView:viewBase withColor:[UIColor blackColor] offSet:CGSizeMake(1.0, 1.0) radius:2.0 opacity:0.50];
    
    //ViewBase: *******************************************************************************
    viewBase.backgroundColor = [UIColor whiteColor];
    [viewBase.layer setCornerRadius:4.0];
    
    //ViewHeader: *******************************************************************************
    viewHeader.backgroundColor = nil;
    //
    imvHeader_UserPicture.backgroundColor = nil;
    [imvHeader_UserPicture.layer setCornerRadius:20.0];
    //
    lblHeader_UserName.backgroundColor = nil;
    lblHeader_UserName.textColor = [UIColor colorWithRed:16.0/255.0 green:81.0/255.0 blue:127.0/255.0 alpha:1.0];
    //
    lblHeader_PostDate.backgroundColor = nil;
    lblHeader_PostDate.textColor = [UIColor grayColor];
    //
    btnHeader_Options.backgroundColor = nil;
    [btnHeader_Options setTitle:@"" forState:UIControlStateNormal];
    [btnHeader_Options setTitle:@"" forState:UIControlStateHighlighted];
    [btnHeader_Options setImage:[[UIImage imageNamed:@"icon-three-dot"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnHeader_Options setImage:[[UIImage imageNamed:@"icon-three-dot"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    [btnHeader_Options setTintColor:[UIColor grayColor]];
    
    
    //ViewText: *******************************************************************************
    viewText.backgroundColor = nil;
    //
    lblText_PostText.backgroundColor = nil;
    lblText_PostText.textColor = [UIColor colorWithRed:16.0/255.0 green:81.0/255.0 blue:127.0/255.0 alpha:1.0];
    
    btnPostTextViewMore.backgroundColor = nil;
    [btnPostTextViewMore setTitle:@"" forState:UIControlStateNormal];
    [btnPostTextViewMore setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(btnPostTextViewMore.frame.size.width, btnPostTextViewMore.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(btnPostTextViewMore.frame.size.height / 2.0, btnPostTextViewMore.frame.size.height / 2.0) andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
    [btnPostTextViewMore setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(btnPostTextViewMore.frame.size.width, btnPostTextViewMore.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(btnPostTextViewMore.frame.size.height / 2.0, btnPostTextViewMore.frame.size.height / 2.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnPostTextViewMore.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
    [btnPostTextViewMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnPostTextViewMore setHidden:YES];
    
    //ViewPhoto: *******************************************************************************
    viewPhoto.backgroundColor = nil;
    //
    imvPhoto_PostImage.backgroundColor = nil;
    //
    viewPhoto_Action.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:166.0/255.0 blue:233.0/255.0 alpha:1.0];
    //
    imvPhotoAction_Icon.backgroundColor = nil;
    imvPhotoAction_Icon.image = [[UIImage imageNamed:@"icon-right-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imvPhotoAction_Icon.tintColor = [UIColor whiteColor];
    //
    lblPhotoAction_Title.backgroundColor = nil;
    lblPhotoAction_Title.textColor = [UIColor whiteColor];
    //
    btnPhotoAction_Activation.backgroundColor = nil;
    [btnPhotoAction_Activation setTitle:@"" forState:UIControlStateNormal];
    [btnPhotoAction_Activation setTitle:@"" forState:UIControlStateHighlighted];
    //
    activityIndicator.color = [UIColor colorWithRed:16.0/255.0 green:81.0/255.0 blue:127.0/255.0 alpha:1.0]; //[UIColor whiteColor];
    
    //ViewFooter: *******************************************************************************
    viewFooter.backgroundColor = nil;
    //
    lblFooter_TotalComments.backgroundColor = nil;
    lblFooter_TotalComments.textColor = [UIColor lightGrayColor];
    //
    imvFooter_Line.backgroundColor = nil;
    imvFooter_Line.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imvFooter_Line.tintColor = [UIColor lightGrayColor];
    //
    imvFooter_Like.backgroundColor = nil;
    imvFooter_Like.tintColor = [UIColor colorWithRed:194.0/255.0 green:62.0/255.0 blue:75.0/255.0 alpha:1.0];
    //
    lblFooter_Like.backgroundColor = nil;
    lblFooter_Like.textColor = [UIColor colorWithRed:16.0/255.0 green:81.0/255.0 blue:127.0/255.0 alpha:1.0];
    //
    imvFooter_Comments.backgroundColor = nil;
    imvFooter_Comments.image = [[UIImage imageNamed:@"icon-post-comment"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imvFooter_Comments.tintColor = [UIColor colorWithRed:16.0/255.0 green:81.0/255.0 blue:127.0/255.0 alpha:1.0];
    //
    lblFooter_Comments.backgroundColor = nil;
    lblFooter_Comments.textColor = [UIColor colorWithRed:16.0/255.0 green:81.0/255.0 blue:127.0/255.0 alpha:1.0];
    //
    btnFooter_Like.backgroundColor = nil;
    [btnFooter_Like setTitle:@"" forState:UIControlStateNormal];
    [btnFooter_Like setTitle:@"" forState:UIControlStateHighlighted];
    //
    btnFooter_Comments.backgroundColor = nil;
    [btnFooter_Comments setTitle:@"" forState:UIControlStateNormal];
    [btnFooter_Comments setTitle:@"" forState:UIControlStateHighlighted];
    
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    //
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    CGRect textRect = [lblText_PostText.text boundingRectWithSize:CGSizeMake(width - (28.0 * 2), CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName:font}
                                                 context:nil];
    
    imvPhoto_PostImage.alpha = 1.0;
    activityIndicator.alpha = 1.0;
    
    //Video:
    progressVideo.progress = 0.0;
    progressVideo.trackTintColor = UIColor.darkGrayColor;
    progressVideo.progressTintColor = [UIColor whiteColor];
    //
    viewVideoControls.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    [viewVideoControls setClipsToBounds:YES];
    viewVideoControls.layer.cornerRadius = 5.0;
    //
    viewVideoContainer.backgroundColor = nil;
    //
    viewVideoTimerBar.backgroundColor = [UIColor blackColor];
    //
    btnVideoMute.backgroundColor = [UIColor blackColor];
    [btnVideoMute setTitle:@"" forState:UIControlStateNormal];
    [btnVideoMute setTintColor:[UIColor whiteColor]];
    [btnVideoMute.imageView setContentMode:UIViewContentModeScaleAspectFit];
    btnVideoMute.layer.cornerRadius = 5.0;
    //
    btnVideoPlay.backgroundColor = [UIColor blackColor];
    [btnVideoPlay setTitle:@"" forState:UIControlStateNormal];
    [btnVideoPlay setTintColor:[UIColor whiteColor]];
    [btnVideoPlay.imageView setContentMode:UIViewContentModeScaleAspectFit];
    btnVideoPlay.layer.cornerRadius = 5.0;
    //
    btnVideoFullScreen.backgroundColor = [UIColor blackColor];
    [btnVideoFullScreen setTitle:@"" forState:UIControlStateNormal];
    [btnVideoFullScreen setTintColor:[UIColor whiteColor]];
    [btnVideoFullScreen.imageView setContentMode:UIViewContentModeScaleAspectFit];
    btnVideoFullScreen.layer.cornerRadius = 5.0;
    //
    lblVideoTime.backgroundColor = [UIColor blackColor];
    lblVideoTime.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    lblVideoTime.textColor = [UIColor whiteColor];
    lblVideoTime.text = @"0:00";
    //
    isShowingVideoControls = NO;
    videoLoopingEnabled = NO;
    viewVideoControls.alpha = 0.0;
    //
    [self updateVideoControls];
    //
    [viewVideo stopVideo];
    [viewVideoContainer setHidden:YES];
    
    //Controle: *******************************************************************************
    switch (type) {
            
        case eTVC_PostType_Empty:
        {
            //ViewText:
            lblText_PostText.alpha = 0.0;
            viewTextConstraintHeight.constant = 10.0;
            
            //ViewPhoto:
            viewPhotoConstraintHeight.constant = 1.0;
            if (sponsor){
                viewPhoto.alpha = 1.0;
                imvPhoto_PostImage.alpha = 0.0;
                activityIndicator.alpha = 0.0;
                //
                viewPhoto_Action.alpha = 1.0;
                viewPhotoConstraintHeight.constant += 40.0;
                viewPhotoActionConstraintHeight.constant = 40.0;
            }else{
                viewPhoto.alpha = 0.0;
            }
            
        }break;
            
        case eTVC_PostType_TextOnly:
        {
            //ViewText:
            viewText.alpha = 1.0;
            lblText_PostText.alpha = 1.0;
            if (textRect.size.height < 40.0){
                viewTextConstraintHeight.constant = 60.0;
            }else {
                viewTextConstraintHeight.constant = textRect.size.height + 20.0;
            }
            
            //ViewPhoto:
            viewPhotoConstraintHeight.constant = 1.0;
            if (sponsor){
                viewPhoto.alpha = 1.0;
                imvPhoto_PostImage.alpha = 0.0;
                activityIndicator.alpha = 0.0;
                //
                viewPhoto_Action.alpha = 1.0;
                viewPhotoConstraintHeight.constant += 40.0;
                viewPhotoActionConstraintHeight.constant = 40.0;
            }else{
                viewPhoto.alpha = 0.0;
            }
            
        }break;
            
        case eTVC_PostType_PhotoOnly:
        {
            //Esconder ViewText:
            //viewText.alpha = 0.0;
            lblText_PostText.alpha = 0.0;
            viewTextConstraintHeight.constant = 10.0;
            //
            viewPhoto.alpha = 1.0;
            CGSize size = CGSizeMake((width - 16.0), (width - 16.0) * 0.8);
            if (size.height < 100.0){
                viewPhotoConstraintHeight.constant = 100.0;
            }else {
                viewPhotoConstraintHeight.constant = size.height;
            }
            //
            if (sponsor){
                viewPhoto_Action.alpha = 1.0;
                viewPhotoConstraintHeight.constant += 40.0;
                viewPhotoActionConstraintHeight.constant = 40.0;
            }else{
                viewPhoto_Action.alpha = 0.0;
                viewPhotoConstraintHeight.constant += 1.0;
                viewPhotoActionConstraintHeight.constant = 1.0;
            }
        }break;
            
        case eTVC_PostType_VideoOnly:
        {
            //Esconder ViewText:
            //viewText.alpha = 0.0;
            lblText_PostText.alpha = 0.0;
            viewTextConstraintHeight.constant = 10.0;
            //
            viewPhoto.alpha = 1.0;
            [viewVideoContainer setHidden:NO];
            CGSize size = CGSizeMake((width - 16.0), (width - 16.0) * 0.8);
            if (size.height < 100.0){
                viewPhotoConstraintHeight.constant = 100.0;
            }else {
                viewPhotoConstraintHeight.constant = size.height;
            }
            //
            if (sponsor){
                viewPhoto_Action.alpha = 1.0;
                viewPhotoConstraintHeight.constant += 40.0;
                viewPhotoActionConstraintHeight.constant = 40.0;
            }else{
                viewPhoto_Action.alpha = 0.0;
                viewPhotoConstraintHeight.constant += 1.0;
                viewPhotoActionConstraintHeight.constant = 1.0;
            }
        }break;
            
        case eTVC_PostType_TextAndPhoto:
        {
            //Mostra Ambos:
            //viewText.alpha = 1.0;
            lblText_PostText.alpha = 1.0;
            /////////////////CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
            if (textRect.size.height < 40.0){
                viewTextConstraintHeight.constant = 60.0;
            }else {
                viewTextConstraintHeight.constant = textRect.size.height + 20.0;
            }
            //
            viewPhoto.alpha = 1.0;
            CGSize size2 = CGSizeMake((width - 16.0), (width - 16.0) * 0.8);
            if (size2.height < 100.0){
                viewPhotoConstraintHeight.constant = 100.0;
            }else {
                viewPhotoConstraintHeight.constant = size2.height;
            }
            //
            if (sponsor){
                viewPhoto_Action.alpha = 1.0;
                viewPhotoConstraintHeight.constant += 40.0;
                viewPhotoActionConstraintHeight.constant = 40.0;
            }else{
                viewPhoto_Action.alpha = 0.0;
                viewPhotoConstraintHeight.constant += 1.0;
                viewPhotoActionConstraintHeight.constant = 1.0;
            }
        }break;
            
        case eTVC_PostType_TextAndVideo:
        {
            //Mostra Ambos:
            //viewText.alpha = 1.0;
            lblText_PostText.alpha = 1.0;
            /////////////////CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
            if (textRect.size.height < 40.0){
                viewTextConstraintHeight.constant = 60.0;
            }else {
                viewTextConstraintHeight.constant = textRect.size.height + 20.0;
            }
            //
            viewPhoto.alpha = 1.0;
            [viewVideoContainer setHidden:NO];
            CGSize size2 = CGSizeMake((width - 16.0), (width - 16.0) * 0.8);
            if (size2.height < 100.0){
                viewPhotoConstraintHeight.constant = 100.0;
            }else {
                viewPhotoConstraintHeight.constant = size2.height;
            }
            //
            if (sponsor){
                viewPhoto_Action.alpha = 1.0;
                viewPhotoConstraintHeight.constant += 40.0;
                viewPhotoActionConstraintHeight.constant = 40.0;
            }else{
                viewPhoto_Action.alpha = 0.0;
                viewPhotoConstraintHeight.constant += 1.0;
                viewPhotoActionConstraintHeight.constant = 1.0;
            }
        }break;
    }
    //
    [viewBase setNeedsUpdateConstraints];
    
}

- (void)playVideoWithURL:(NSString*)videoURL muted:(BOOL)videoMuted looping:(BOOL)loopingEnabled
{
    if (videoURL != nil && ![videoURL isEqualToString:@""]){
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionNotification:) name:SYSNOT_TIMELINE_VIDEO_PLAYER_START_RUNNING object:nil];
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_TIMELINE_VIDEO_PLAYER_START_RUNNING object:self userInfo:nil];
        });
        
        videoLoopingEnabled = loopingEnabled;
        viewVideo.delegate = self;
        [viewVideo playVideoFrom:videoURL atTime:0.0 muted:videoMuted];
        //
        viewVideoControls.alpha = 0.0;
        [viewVideoContainer setHidden:NO];
        [imvPhoto_PostImage setHidden:YES];
    }
}

- (void)stopVideo
{
    [viewVideo stopVideo];
    viewVideo.delegate = nil;
    //
    [viewVideoContainer setHidden:YES];
    //
    [imvPhoto_PostImage setHidden:NO];
}

- (void)showOrHideVideoControls
{
    [self updateVideoControls];
    
    if (isShowingVideoControls){
        isShowingVideoControls = NO;
        [UIView animateWithDuration:0.2 animations:^{
            viewVideoControls.alpha = 0.0;
        }];
    }else{
        isShowingVideoControls = YES;
        [UIView animateWithDuration:0.2 animations:^{
            viewVideoControls.alpha = 1.0;
        }];
    }
}

+ (void)stopCurrentVideoPlayback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_TIMELINE_VIDEO_PLAYER_START_RUNNING object:nil userInfo:nil];
    });
}

- (void)updateVideoControls
{
    [viewVideo bringSubviewToFront:viewVideoControls];
    
    //Mute:
    if (viewVideo.isMuted){
        [btnVideoMute setImage:[[UIImage imageNamed:@"icon-videoplayer-muteoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }else{
        [btnVideoMute setImage:[[UIImage imageNamed:@"icon-videoplayer-muteon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    //Play:
    if (viewVideo.playerStatus == UIViewVideoPlayerReadyToPlay || viewVideo.playerStatus == UIViewVideoPlayerPlaying){
        [btnVideoPlay setImage:[[UIImage imageNamed:@"icon-videoplayer-pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }else{
        [btnVideoPlay setImage:[[UIImage imageNamed:@"icon-videoplayer-resume"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    //FullScreen:
    [btnVideoFullScreen setImage:[[UIImage imageNamed:@"icon-videoplayer-fullscreen"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

}

#pragma mark - Actions Functions

- (IBAction)actionMuteVideo:(id)sender
{
    [viewVideo setMute:!viewVideo.isMuted];
    //
    [self updateVideoControls];
    //
    if (self.videoDelegate){
        if ([self.videoDelegate respondsToSelector:@selector(postCellVideoDelegateDidChangeVideoMutedState:withIndex:)]){
            [self.videoDelegate postCellVideoDelegateDidChangeVideoMutedState:viewVideo.isMuted withIndex:self.imvPhoto_PostImage.tag];
        }
    }
}

- (IBAction)actionPlayPauseVideo:(id)sender
{
    if (viewVideo.playerStatus == UIViewVideoPlayerReadyToPlay || viewVideo.playerStatus == UIViewVideoPlayerPlaying){
        [viewVideo pauseVideo];
    }else if (viewVideo.playerStatus == UIViewVideoPlayerPaused){
        [viewVideo resumeVideo];
    }else if (viewVideo.playerStatus == UIViewVideoPlayerStoped || viewVideo.playerStatus == UIViewVideoPlayerUnknown){
        if (viewVideo.videoNSURL){
            [viewVideo playVideoFrom:viewVideo.videoNSURL.absoluteString atTime:0.0 muted:viewVideo.isMuted];
        }
    }
    
//    UIViewVideoPlayerUnknown           = 0,
//    UIViewVideoPlayerReadyToPlay       = 1,
//    UIViewVideoPlayerPlaying           = 2,
//    UIViewVideoPlayerPaused            = 3,
//    UIViewVideoPlayerStoped            = 4,
//    UIViewVideoPlayerError             = 5
    
    [self updateVideoControls];
}

- (IBAction)actionGoToFullscreenVideo:(id)sender
{
    if ([self.videoDelegate respondsToSelector:@selector(postCellVideoDelegateNeedEnterFullScreenWithIndex:)]){
        [self.videoDelegate postCellVideoDelegateNeedEnterFullScreenWithIndex:self.imvPhoto_PostImage.tag];
    }
}

- (void)actionNotification:(NSNotification*)notification
{
    if (notification.object != self){
        [self stopVideo];
    }
}

- (void)actionApplicationDidEnterBackground:(NSNotification*)notification
{
    if (viewVideo.playerStatus == UIViewVideoPlayerReadyToPlay || viewVideo.playerStatus == UIViewVideoPlayerPlaying){
        [viewVideo pauseVideo];
        //
        [self updateVideoControls];
    }
}

- (void)actionApplicationDidBecomeActive:(NSNotification*)notification
{
    if (viewVideo.playerStatus == UIViewVideoPlayerPaused){
        if (videoLoopingEnabled){
           [viewVideo resumeVideo];
        }
        //
        [self updateVideoControls];
    }
}

#pragma mark - UIViewVideoPlayerDelegate

- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView didChangeStatus:(UIViewVideoPlayerStatus)status
{
    if (status == UIViewVideoPlayerStoped){
        [viewVideoContainer setHidden:YES];
        [imvPhoto_PostImage setHidden:NO];
    }
    else if (status == UIViewVideoPlayerReachedEndOfVideo){
        
        if (videoLoopingEnabled){
            [playerView resumeVideo];
        }else{
            [self stopVideo];
        }
        
    }
}

- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView videoProgressUpdate:(CGFloat)progress timePlayed:(long)sPlayed timeRemaining:(long)sRemaining totalTime:(long)sTotal
{
    dispatch_async(dispatch_get_main_queue(), ^{
        progressVideo.progress = progress;
        //
        lblVideoTime.text = [self secondsToString:sRemaining];
    });
}

- (NSString*)secondsToString:(NSUInteger)seconds
{
    NSUInteger h = seconds / 3600;
    NSUInteger m = (seconds / 60) % 60;
    NSUInteger s = seconds % 60;
    //
    NSString *formattedTime;
    //
    if (h != 0){
        formattedTime = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", h, m, s];
    }else{
        formattedTime = [NSString stringWithFormat:@"%02lu:%02lu", m, s];
    }
    //
    return formattedTime;
}

@end
