//
//  AdAliveVideoPlayerManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <AVKit/AVKit.h>

@class LabVideoPlayerManager;

@protocol LabVideoPlayerManagerDelegate<NSObject>
@required
- (void)labVideoPlayerManagerDidShowVideoPlayer:(LabVideoPlayerManager* _Nonnull)videoVC;
- (void)labVideoPlayerManagerDidHideVideoPlayer:(LabVideoPlayerManager* _Nonnull)videoVC;
- (void)labVideoPlayerManager:(LabVideoPlayerManager* _Nonnull)vManager executionError:(NSError* _Nonnull)error;
@end

@interface LabVideoPlayerManager : NSObject

- (void)playLocalVideoFile:(NSString* _Nonnull)videoPath withViewControllerDelegate:(UIViewController<LabVideoPlayerManagerDelegate>* _Nonnull)vcDelegate;
- (void)playStreamingVideoFrom:(NSString* _Nonnull)videoURL withViewControllerDelegate:(UIViewController<LabVideoPlayerManagerDelegate>* _Nonnull)vcDelegate;
- (void)forceStopVideoPlayback;

@end
