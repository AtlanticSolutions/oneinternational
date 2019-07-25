//
//  TVC_VideoPlayerListItem.m
//  CozinhaTudo
//
//  Created by lucas on 13/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "TVC_VideoPlayerListItem.h"

@implementation TVC_VideoPlayerListItem

@synthesize viewVideo, progressVideo, viewVideoControls, btnVideoMute, btnVideoPlay, btnVideoFullScreen, lblVideoTime, isShowingVideoControls, viewVideoContainer, viewVideoTimerBar;
@synthesize lblTitle, imvThumb, btnPlay;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateLayout {
    //Video:
    viewVideoContainer.layer.shadowColor = [[UIColor blackColor] CGColor];
    viewVideoContainer.layer.shadowOpacity = 0.7;
    viewVideoContainer.layer.shadowRadius = 3.0;
    viewVideoContainer.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    //
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
    viewVideoControls.alpha = 0.0;
    //
    [self updateVideoControls];
    //
    [viewVideo stopVideo];
    [viewVideoContainer setHidden:YES];
    //
    //
    btnPlay.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    lblTitle.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
    lblTitle.textColor = AppD.styleManager.colorPalette.textDark;
    btnPlay.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)playVideoWithURL:(NSString*)videoURL
{
    if (videoURL != nil && ![videoURL isEqualToString:@""]){
        
        viewVideo.delegate = self;
        [viewVideo playVideoFrom:videoURL atTime:0.0 muted:NO];
        //
        viewVideoControls.alpha = 0.0;
        [viewVideoContainer setHidden:NO];
        [imvThumb setHidden:YES];
        [btnPlay setHidden:YES];
    }
}

- (void)stopVideo
{
    [viewVideo stopVideo];
    viewVideo.delegate = nil;
    //
    [viewVideoContainer setHidden:YES];
    //
    [imvThumb setHidden:NO];
    [btnPlay setHidden:NO];
}

- (void)showOrHideVideoControls
{
    if (isShowingVideoControls){
        isShowingVideoControls = NO;
        [UIView animateWithDuration:0.2 animations:^{
            viewVideoControls.alpha = 0.0;
        }];
    }else{
        isShowingVideoControls = YES;
        //[viewVideo pauseVideo];
        [self updateVideoControls];
        [UIView animateWithDuration:0.2 animations:^{
            viewVideoControls.alpha = 1.0;
        }];
    }
}

- (void)updateVideoControls
{
    [viewVideo bringSubviewToFront:viewVideoControls];
    
    //Mute:
    if (viewVideo.isMuted){
        [btnVideoMute setImage:[[UIImage imageNamed:@"icon-videoplayer-muteon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }else{
        [btnVideoMute setImage:[[UIImage imageNamed:@"icon-videoplayer-muteoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
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
}

- (IBAction)actionPlayPauseVideo:(id)sender
{
    if (viewVideo.playerStatus == UIViewVideoPlayerReadyToPlay || viewVideo.playerStatus == UIViewVideoPlayerPlaying){
        [viewVideo pauseVideo];
    }else if (viewVideo.playerStatus == UIViewVideoPlayerPaused){
        [viewVideo resumeVideo];
    }else if (viewVideo.playerStatus == UIViewVideoPlayerStoped || viewVideo.playerStatus == UIViewVideoPlayerUnknown){
        if (viewVideo.videoNSURL){
            [viewVideo playVideoFrom:viewVideo.videoNSURL.absoluteString atTime:0.0 muted:NO];
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
    if ([self.videoDelegate respondsToSelector:@selector(cellVideoDelegateNeedEnterFullScreenWithIndex:)]){
        [self.videoDelegate cellVideoDelegateNeedEnterFullScreenWithIndex:self.imvThumb.tag];
    }
}

#pragma mark - UIViewVideoPlayerDelegate

- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView didChangeStatus:(UIViewVideoPlayerStatus)status
{
    if (status == UIViewVideoPlayerStoped){
        [viewVideoContainer setHidden:YES];
        [imvThumb setHidden:NO];
        [btnPlay setHidden:NO];
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
