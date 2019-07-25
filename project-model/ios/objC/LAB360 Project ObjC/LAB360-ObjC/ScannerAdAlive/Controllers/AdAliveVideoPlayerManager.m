//
//  AdAliveVideoPlayerManager.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "LabVideoPlayerManager.h"

@interface LabVideoPlayerManager ()

@property(nonatomic, strong) UIViewController<AdAliveVideoPlayerManagerDelegate> *viewControllerDelegate;
@property(nonatomic, strong) AVPlayerViewController *playerVC;

@end

@implementation LabVideoPlayerManager

@synthesize viewControllerDelegate, playerVC;

- (void)playLocalVideoFile:(NSString* _Nonnull)videoURL withViewControllerDelegate:(UIViewController<AdAliveVideoPlayerManagerDelegate>* _Nonnull)vcDelegate
{
    
}

- (void)playStreamingVideoFrom:(NSString* _Nonnull)videoURL withViewControllerDelegate:(UIViewController<AdAliveVideoPlayerManagerDelegate>* _Nonnull)vcDelegate
{
    if (videoURL != nil && vcDelegate != nil) {
        
        viewControllerDelegate = vcDelegate;
        
        BOOL error = NO;
        NSURL *videoNSURL = nil;
        AVPlayer *player = nil;
        
        @try {
            videoNSURL = [NSURL URLWithString:videoURL];
            player = [AVPlayer playerWithURL:videoNSURL];
        } @catch (NSException *exception) {
            error = YES;
            //
            NSMutableDictionary * info = [NSMutableDictionary dictionary];
            [info setValue:exception.name forKey:@"ExceptionName"];
            [info setValue:exception.reason forKey:@"ExceptionReason"];
            [info setValue:exception.callStackReturnAddresses forKey:@"ExceptionCallStackReturnAddresses"];
            [info setValue:exception.callStackSymbols forKey:@"ExceptionCallStackSymbols"];
            [info setValue:exception.userInfo forKey:@"ExceptionUserInfo"];
            NSError *error = [[NSError alloc] initWithDomain:@"br.com.lab360.adalive.error" code:0 userInfo:info];
            //
            if ([viewControllerDelegate respondsToSelector:@selector(adAliveVideoPlayerManager:executionError:)]) {
                [viewControllerDelegate adAliveVideoPlayerManager:self executionError:error];
            }
        }

        if (!error){
            playerVC = [AVPlayerViewController new];
            playerVC.view.frame = vcDelegate.view.bounds;
            playerVC.showsPlaybackControls = YES;
            playerVC.player = player;
            if (@available(iOS 11.0, *)) {
                playerVC.entersFullScreenWhenPlaybackBegins = YES;
                playerVC.exitsFullScreenWhenPlaybackEnds = YES;
            }
            //
            [vcDelegate presentViewController:playerVC animated:YES completion:^{
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionFinishVideo:) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionPlayError:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:player.currentItem];
                [player play];
                //
                if ([viewControllerDelegate respondsToSelector:@selector(adAliveVideoPlayerManagerDidShowVideoPlayer:)]) {
                    [viewControllerDelegate adAliveVideoPlayerManagerDidShowVideoPlayer:self];
                }
            }];
        }
        
    }else{
        NSAssert(false, @"AdAliveVideoPlayerManager >> Exception >> Um dos parâmetros obrigatórios é nulo.");
    }
}

- (void)forceStopVideoPlayback
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    
    if (playerVC) {
        [playerVC.player pause];
        [playerVC dismissViewControllerAnimated:YES completion:^{
            playerVC = nil;
            //
            if ([viewControllerDelegate respondsToSelector:@selector(adAliveVideoPlayerManagerDidHideVideoPlayer:)]) {
                [viewControllerDelegate adAliveVideoPlayerManagerDidHideVideoPlayer:self];
            }
        }];
    }
}

//

- (void)actionFinishVideo:(NSNotification*)notification
{
    [self forceStopVideoPlayback];
}

- (void)actionPlayError:(NSNotification*)notification
{
    NSError *error = notification.userInfo[AVPlayerItemFailedToPlayToEndTimeErrorKey];
    if ([viewControllerDelegate respondsToSelector:@selector(adAliveVideoPlayerManager:executionError:)]) {
        [viewControllerDelegate adAliveVideoPlayerManager:self executionError:error];
    }
    //
    [self forceStopVideoPlayback];
}

@end
