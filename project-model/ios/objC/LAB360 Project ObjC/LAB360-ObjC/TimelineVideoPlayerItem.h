//
//  TimelineVideoPlayerItem.h
//  LAB360-ObjC
//
//  Created by Erico GT on 04/12/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@interface TimelineVideoPlayerItem : NSObject

@property(nonatomic, assign) long refObjID;
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) AVPlayerLayer *playerLayer;

@end
