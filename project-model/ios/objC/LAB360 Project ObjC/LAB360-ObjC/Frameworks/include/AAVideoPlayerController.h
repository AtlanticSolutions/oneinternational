//
//  AAVideoPlayerController.h
//  testingLib
//
//  Created by Lab360 on 8/22/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class CloudRecoViewController;

@protocol AAVideoPlayerDelegate <NSObject>

/**
 *  Returns when video did finish.
 *
 */
-(void)didFinishVideo;

@end

@interface AAVideoPlayerController : MPMoviePlayerViewController


@property(nonatomic, assign) id<AAVideoPlayerDelegate> delegate;
/**
 *  Returns the AAVideoPlayerController object for the process.
 *
 *  \param videoUrl Url of video in .m3u8 extension. 
 *  \param viewController ViewController that will present the video;
 *
 *  \return The AdAlive object or nil if videoUrl and viewController is null.
 */
- (id)initWithUrl:(NSString *)videoUrl andViewController:(UIViewController *)viewController;
/**
 *  Plays the video.
 */
- (void)play;

@end




