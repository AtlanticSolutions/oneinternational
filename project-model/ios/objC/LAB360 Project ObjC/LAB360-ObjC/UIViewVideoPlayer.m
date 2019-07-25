//
//  UIViewVideoPlayer.m
//  LAB360-ObjC
//
//  Created by Erico GT on 27/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "UIViewVideoPlayer.h"
#import "AppDelegate.h"

@interface UIViewVideoPlayer()

@property (nonatomic, strong) NSURL* videoNSURL;
@property (nonatomic, assign) BOOL isMuted;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) UIViewVideoPlayerStatus currentStatus;

@end

@implementation UIViewVideoPlayer

@synthesize delegate, videoNSURL, isMuted, player, playerLayer, currentStatus, videoProgress;

//-(void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    //
//    if (playerLayer){
//        playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    }
//}

- (void)playVideoFrom:(NSString*_Nonnull)videoURL atTime:(CGFloat)progress muted:(BOOL)videoMuted
{
    self.clipsToBounds = YES;
    
    CGFloat vProgress = progress < 0 ? 0 : (progress > 1.0 ? 1.0 : progress);
    
    if (player && [videoURL isEqualToString:[videoNSURL absoluteString]] && (player.status != AVPlayerStatusFailed)){
        long long value = player.currentItem.asset.duration.value;
        int32_t timeScale = player.currentItem.asset.duration.timescale;
        int32_t timeSeconds = (int32_t)(value / timeScale);
        CMTime seektime = CMTimeMakeWithSeconds((int32_t)((CGFloat) timeSeconds * vProgress), timeScale);
        [player seekToTime:seektime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        //
        return;
    }
    
    //CachedPlayer **********************************************************************************
    AVPlayer *cachedPlayer = [AppD.timelineVideoPlayerManager playerForReferenceObjectID:self.referenceObjectID];
    if (cachedPlayer){
        player = cachedPlayer;
        videoProgress = 0.0;
        //
        long long value = player.currentItem.asset.duration.value;
        int32_t timeScale = player.currentItem.asset.duration.timescale;
        int32_t timeSeconds = (int32_t)(value / timeScale);
        CMTime seektime = CMTimeMakeWithSeconds((int32_t)((CGFloat) timeSeconds * vProgress), timeScale);
        [player seekToTime:seektime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        //
        AVPlayerLayer *cachedPlayerLayer = [AppD.timelineVideoPlayerManager playerLayerForReferenceObjectID:self.referenceObjectID];
        if (cachedPlayerLayer){
            playerLayer = cachedPlayerLayer;
        }else{
            playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        }
        playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        //NSLog(@"\n playerLayer >> frame >> %@", NSStringFromCGRect(playerLayer.frame));//ericogt
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer setContentsGravity:kCAGravityResizeAspect]; //@"resizeAspect"
        for (AVPlayerLayer *subLayer in self.layer.sublayers){
            [subLayer removeFromSuperlayer];
        }
        [self.layer addSublayer:playerLayer];
        
        [player play];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[player currentItem]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        [player setMuted:videoMuted];
        isMuted = videoMuted;
        //
        CMTime time = CMTimeMakeWithSeconds(0.1f, NSEC_PER_SEC) ;
        __weak UIViewVideoPlayer *weakSelf = self;
        [player addPeriodicTimeObserverForInterval:time queue:NULL usingBlock:^(CMTime time) {
            [weakSelf updateVideoProgress];
        }];
        //
        if (player.error == nil){
            currentStatus = UIViewVideoPlayerPlaying;
            if (delegate){
                [delegate UIViewVideoPlayer:self didChangeStatus:UIViewVideoPlayerPlaying];
            }
        }else{
            currentStatus = UIViewVideoPlayerError;
            if (delegate){
                [delegate UIViewVideoPlayer:self didChangeStatus:UIViewVideoPlayerError];
            }
        }
    }else{
        [self loadVideoDataFrom:videoURL atTime:vProgress muted:videoMuted];
    }
}

- (void)loadVideoDataFrom:(NSString*_Nonnull)videoURL atTime:(CGFloat)progress muted:(BOOL)videoMuted
{
    NSString *urlTest = [videoURL stringByExpandingTildeInPath];
    if ([urlTest hasPrefix:@"/"] || [urlTest hasPrefix:@"file:"]){
        //Interno:
        videoNSURL = [[NSURL alloc] initFileURLWithPath:videoURL isDirectory:NO]; //[NSURL fileURLWithPath:videoURL];
    }else{
        //Externo:
        videoNSURL = [[NSURL alloc] initWithString:videoURL]; //[NSURL URLWithString:videoURL];
    }
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoNSURL options:nil];
    [asset loadValuesAsynchronouslyForKeys:@[@"playable"] completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus status = [asset statusOfValueForKey:@"playable" error:&error];
        
        dispatch_async(dispatch_get_main_queue(),^{
            if (error){
                currentStatus = UIViewVideoPlayerError;
                if (delegate){
                    [delegate UIViewVideoPlayer:self didChangeStatus:UIViewVideoPlayerError];
                }
            }else{
                if (status == AVKeyValueStatusLoaded){
                    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
                    player = [AVPlayer playerWithPlayerItem:playerItem];
                    videoProgress = 0.0;
                    //self.clipsToBounds = YES;
                    
                    long long value = player.currentItem.asset.duration.value;
                    int32_t timeScale = player.currentItem.asset.duration.timescale;
                    int32_t timeSeconds = (int32_t)(value / timeScale);
                    CMTime seektime = CMTimeMakeWithSeconds((int32_t)((CGFloat) timeSeconds * progress), timeScale);
                    [player seekToTime:seektime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
                    
                    if (playerLayer){
                        [playerLayer removeFromSuperlayer];
                        playerLayer = nil;
                    }
                    
                    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
                    playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                    //NSLog(@"\n playerLayer >> frame >> %@", NSStringFromCGRect(playerLayer.frame));//ericogt
                    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                    [self.layer setContentsGravity:kCAGravityResizeAspect]; //@"resizeAspect"
                    for (AVPlayerLayer *subLayer in self.layer.sublayers){
                        [subLayer removeFromSuperlayer];
                    }
                    [self.layer addSublayer:playerLayer];
                    
                    [player play];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[player currentItem]];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
                    
                    [player setMuted:videoMuted];
                    isMuted = videoMuted;
                    //
                    CMTime time = CMTimeMakeWithSeconds(0.1f, NSEC_PER_SEC) ;
                    __weak UIViewVideoPlayer *weakSelf = self;
                    [player addPeriodicTimeObserverForInterval:time queue:NULL usingBlock:^(CMTime time) {
                        [weakSelf updateVideoProgress];
                    }];
                    //
                    if (player.error == nil){
                        currentStatus = UIViewVideoPlayerPlaying;
                        if (delegate){
                            [delegate UIViewVideoPlayer:self didChangeStatus:UIViewVideoPlayerPlaying];
                        }
                    }else{
                        currentStatus = UIViewVideoPlayerError;
                        if (delegate){
                            [delegate UIViewVideoPlayer:self didChangeStatus:UIViewVideoPlayerError];
                        }
                    }
                }else{
                    currentStatus = UIViewVideoPlayerError;
                    if (delegate){
                        [delegate UIViewVideoPlayer:self didChangeStatus:UIViewVideoPlayerError];
                    }
                }
            }
        });
    }];
}

- (void)pauseVideo
{
    if (player){
        [player pause];
        //
        currentStatus = UIViewVideoPlayerPaused;
        if (delegate){
            [delegate UIViewVideoPlayer:self didChangeStatus:UIViewVideoPlayerPaused];
        }
    }
}

- (void)resumeVideo
{
    if (player){
        [player play];
        //
        currentStatus = UIViewVideoPlayerPlaying;
        if (delegate){
            [delegate UIViewVideoPlayer:self didChangeStatus:UIViewVideoPlayerPlaying];
        }
    }
}

- (void)stopVideo
{
    if (player){
        [player pause];
        //[player replaceCurrentItemWithPlayerItem:nil];  //TODO:descomentar caso o cache de players não seja utilizado (AppD.timelineVideoPlayerManager).
        //player = nil;  //TODO:descomentar caso o cache de players não seja utilizado (AppD.timelineVideoPlayerManager).
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        //
        [playerLayer removeFromSuperlayer];
        //playerLayer = nil;  //TODO:descomentar caso o cache de players não seja utilizado (AppD.timelineVideoPlayerManager).
        //
        videoProgress = 0.0;
        currentStatus = UIViewVideoPlayerStoped;
        if (delegate){
            [delegate UIViewVideoPlayer:self didChangeStatus:UIViewVideoPlayerStoped];
        }
    }
}

- (void)setVolume:(float)volume
{
    if (player){
        [player setVolume:volume];
    }
}

- (void)setMute:(BOOL)mute
{
    if (player){
        [player setMuted:mute];
        //
        isMuted = mute;
    }
}

- (UIViewVideoPlayerStatus)playerStatus;
{
    return currentStatus;
}

- (void)updateVideoFrame
{
    if (playerLayer){
        playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
}

#pragma mark - Private Methods

- (CMTime)playerItemDuration
{
    AVPlayerItem *thePlayerItem = [player currentItem];
    if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        return([thePlayerItem duration]);
    }
    return(kCMTimeInvalid);
}

- (void)updateVideoProgress
{
    AVPlayerItem *playerItem = [player currentItem];
    double duration = CMTimeGetSeconds(playerItem.duration);
    double time = CMTimeGetSeconds(player.currentTime);
    videoProgress = (CGFloat) (time / duration);
    videoProgress = (videoProgress < 0.0 ? 0.0 : (videoProgress > 1.0 ? 1.0 : videoProgress));
    //
    if (delegate){
        [delegate UIViewVideoPlayer:self videoProgressUpdate:videoProgress timePlayed:(long)time timeRemaining:(long)(duration - time) totalTime:(long)(duration)];
        
        //buffer:
        //NSLog(@"\nisPlaybackBufferFull: %i", [playerItem isPlaybackBufferFull]);
        //NSLog(@"\nisPlaybackBufferEmpty: %i", [playerItem isPlaybackBufferEmpty]);
        if ([delegate respondsToSelector:@selector(UIViewVideoPlayer:waitingBufferToContinue:)]){
            [delegate UIViewVideoPlayer:self waitingBufferToContinue:[playerItem isPlaybackBufferEmpty]];
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    //
    [player pause];
    //
    currentStatus = UIViewVideoPlayerReachedEndOfVideo;
    if (delegate){
        [delegate UIViewVideoPlayer:self didChangeStatus:UIViewVideoPlayerReachedEndOfVideo];
    }
}

- (void)actionDeviceOrientationDidChange:(NSNotification*)notification
{
    if (playerLayer){
        playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    //NSLog(@"playerLayer >> size >> width:%.1f, height:%.1f", self.frame.size.width, self.frame.size.height);
}

@end
