//
//  AdAliveVideoPlayerManager.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "LabVideoPlayerManager.h"

@interface LabVideoPlayerManager ()

@property(nonatomic, strong) UIViewController<LabVideoPlayerManagerDelegate> *viewControllerDelegate;
@property(nonatomic, strong) AVPlayerViewController *playerVC;
@property(nonatomic, strong) NSURL *videoNSURL;

@end

@implementation LabVideoPlayerManager

@synthesize viewControllerDelegate, playerVC, videoNSURL;

- (void)playLocalVideoFile:(NSString* _Nonnull)videoPath withViewControllerDelegate:(UIViewController<LabVideoPlayerManagerDelegate>* _Nonnull)vcDelegate
{
    if (videoPath != nil && vcDelegate != nil) {
        
        viewControllerDelegate = vcDelegate;
        
        BOOL error = NO;
        videoNSURL = nil;
        
        @try {
            videoNSURL = [NSURL fileURLWithPath:videoPath];
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
            if ([viewControllerDelegate respondsToSelector:@selector(labVideoPlayerManager:executionError:)]) {
                [viewControllerDelegate labVideoPlayerManager:self executionError:error];
            }
        }
        
        if (!error){
            [self playVideo];
        }
        
    }
}

- (void)playStreamingVideoFrom:(NSString* _Nonnull)videoURL withViewControllerDelegate:(UIViewController<LabVideoPlayerManagerDelegate>* _Nonnull)vcDelegate
{
    if (videoURL != nil && vcDelegate != nil) {
        
        viewControllerDelegate = vcDelegate;
        
        BOOL error = NO;
        videoNSURL = nil;
        
        @try {
            videoNSURL = [NSURL URLWithString:videoURL];
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
            if ([viewControllerDelegate respondsToSelector:@selector(labVideoPlayerManager:executionError:)]) {
                [viewControllerDelegate labVideoPlayerManager:self executionError:error];
            }
        }

        if (!error){
            [self playVideo];
        }
        
    }
}

- (void)playVideo
{
    AVPlayer *player =  [AVPlayer playerWithURL:videoNSURL];
    //
    playerVC = [AVPlayerViewController new];
    //NOTE: ericogt >> no console pode aparecer um warning [LayoutConstraints]. Este alerta é um bug da apple. Ao criar o AVPlayerViewController e depois modificar o tamanho da view.
    //Até 19/06/2018 ainda não havia sido solucionado. Não é para crashar o app (se isso ocorrer o problema é em outro ponto).
    playerVC.showsPlaybackControls = YES;
    playerVC.player = player;
    if (@available(iOS 11.0, *)) {
        playerVC.entersFullScreenWhenPlaybackBegins = YES;
        playerVC.exitsFullScreenWhenPlaybackEnds = YES;
    }
    //
    [viewControllerDelegate presentViewController:playerVC animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionFinishVideo:) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionPlayError:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:player.currentItem];
        [player play];
        //
        if ([viewControllerDelegate respondsToSelector:@selector(labVideoPlayerManagerDidShowVideoPlayer:)]) {
            [viewControllerDelegate labVideoPlayerManagerDidShowVideoPlayer:self];
        }
    }];
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
            if ([viewControllerDelegate respondsToSelector:@selector(labVideoPlayerManagerDidHideVideoPlayer:)]) {
                [viewControllerDelegate labVideoPlayerManagerDidHideVideoPlayer:self];
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
    if ([viewControllerDelegate respondsToSelector:@selector(labVideoPlayerManager:executionError:)]) {
        [viewControllerDelegate labVideoPlayerManager:self executionError:error];
    }
    //
    [self forceStopVideoPlayback];
}



@end
