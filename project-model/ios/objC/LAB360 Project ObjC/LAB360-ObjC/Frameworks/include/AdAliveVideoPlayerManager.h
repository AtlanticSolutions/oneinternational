//
//  AdAliveVideoPlayerManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <AVKit/AVKit.h>

@class AdAliveVideoPlayerManager;

@protocol AdAliveVideoPlayerManagerDelegate<NSObject>
@required
- (void)adAliveVideoPlayerManagerDidShowVideoPlayer:(AdAliveVideoPlayerManager* _Nonnull)videoVC;
- (void)adAliveVideoPlayerManagerDidHideVideoPlayer:(AdAliveVideoPlayerManager* _Nonnull)videoVC;
- (void)adAliveVideoPlayerManager:(AdAliveVideoPlayerManager* _Nonnull)vManager executionError:(NSError* _Nonnull)error;
@end

@interface AdAliveVideoPlayerManager : NSObject

- (void)playLocalVideoFile:(NSString* _Nonnull)videoPath withViewControllerDelegate:(UIViewController<AdAliveVideoPlayerManagerDelegate>* _Nonnull)vcDelegate;
- (void)playStreamingVideoFrom:(NSString* _Nonnull)videoURL withViewControllerDelegate:(UIViewController<AdAliveVideoPlayerManagerDelegate>* _Nonnull)vcDelegate;
- (void)forceStopVideoPlayback;

@end
