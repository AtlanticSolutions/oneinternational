//
//  AVPlayerView.h
//  LAB360-ObjC
//
//  Created by Erico GT on 01/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@class AVPlayerView;

@protocol AVPlayerViewDelegate<NSObject>
@optional
- (BOOL)avPlayerViewActionForCloseButton:(AVPlayerView*)view;
- (BOOL)avPlayerViewActionForPlayButton:(AVPlayerView*)view;
- (BOOL)avPlayerViewActionForMuteButton:(AVPlayerView*)view;

@end

@interface AVPlayerView : UIView

@property(nonatomic, weak) id<AVPlayerViewDelegate> delegate;
//
- (void)playVideoUsingExternalPlayer:(AVPlayer*)player;
- (void)stopVideo;

@end

