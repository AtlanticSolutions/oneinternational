//
//  UIViewVideoPlayer.h
//  LAB360-ObjC
//
//  Created by Erico GT on 27/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

typedef enum {
    UIViewVideoPlayerUnknown           = 0,
    UIViewVideoPlayerReadyToPlay       = 1,
    UIViewVideoPlayerPlaying           = 2,
    UIViewVideoPlayerPaused            = 3,
    UIViewVideoPlayerStoped            = 4,
    UIViewVideoPlayerReachedEndOfVideo = 5,
    UIViewVideoPlayerError             = 6
} UIViewVideoPlayerStatus;

@protocol UIViewVideoPlayerDelegate;

@interface UIViewVideoPlayer : UIView

@property (nonatomic, weak) id<UIViewVideoPlayerDelegate>_Nullable delegate;
@property (nonatomic, assign) long referenceObjectID;
@property (nonatomic, assign) CGFloat videoProgress;
@property (nonatomic, strong, readonly) NSURL* _Nullable videoNSURL;
@property (nonatomic, assign, readonly) BOOL isMuted;
@property (nonatomic, assign, readonly) BOOL reachedEndOfVideo;
//
- (void)playVideoFrom:(NSString*_Nonnull)videoURL atTime:(CGFloat)progress muted:(BOOL)videoMuted;
- (void)pauseVideo;
- (void)resumeVideo;
- (void)stopVideo;
- (void)setVolume:(float)volume;
- (void)setMute:(BOOL)mute;
- (UIViewVideoPlayerStatus)playerStatus;
//
- (void)updateVideoFrame;

@end

#pragma mark - Protocol
@protocol UIViewVideoPlayerDelegate <NSObject>
@required
- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView didChangeStatus:(UIViewVideoPlayerStatus)status;
- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView videoProgressUpdate:(CGFloat)progress timePlayed:(long)sPlayed timeRemaining:(long)sRemaining totalTime:(long)sTotal;
@optional
- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView waitingBufferToContinue:(BOOL)isWaiting;
- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView didChangeVideoMutedState:(BOOL)isMuted;

@end
