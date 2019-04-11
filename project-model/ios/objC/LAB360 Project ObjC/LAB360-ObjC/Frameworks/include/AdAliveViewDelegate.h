//
//  AdAliveViewDelegate.h
//  testingLib
//
//  Created by Monique Trevisan on 22/09/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <AVKit/AVKit.h>

#ifndef AdAliveViewDelegate_h
#define AdAliveViewDelegate_h

typedef enum {
    AdAliveViewStatusVideoAR_Unknown              = 0,
    AdAliveViewStatusVideoAR_ReachedEnd           = 1,
    AdAliveViewStatusVideoAR_Paused               = 2,
    AdAliveViewStatusVideoAR_Stopped              = 3,
    AdAliveViewStatusVideoAR_Playing              = 4,
    AdAliveViewStatusVideoAR_Ready                = 5,
    AdAliveViewStatusVideoAR_PlayingFullscreen    = 6,
    AdAliveViewStatusVideoAR_NotReady             = 7,
    AdAliveViewStatusVideoAR_Error                = 8
} AdAliveViewStatusVideoAR;

@protocol AdAliveViewDelegate <NSObject>

/**
 *  Returns the target name from image.
 */
-(void)willRecognizeTargetWithName:(NSString *)targetName;

/**
 *  Video player did finish playing state.
 */
-(void)didFinishVideoAR;

@optional

/**
 *  Called after player change state of playback.
 */
-(void)didChangePlaybackStateVideoAR:(AdAliveViewStatusVideoAR)videoStatus;

/**
 *  Verify if video need continue execution after image target get lost.
 */
-(BOOL)continuePlayingAfterLostImageTargetWithVideoPlayer:(AVPlayer*)player;

@end

#endif /* AdAliveViewDelegate_h */
