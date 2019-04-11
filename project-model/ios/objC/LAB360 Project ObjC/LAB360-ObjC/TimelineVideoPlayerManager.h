//
//  TimelineVideoPlayerManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 04/12/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimelineVideoPlayerItem.h"

@interface TimelineVideoPlayerManager : NSObject

- (AVPlayer*)playerForReferenceObjectID:(long)objID;
- (AVPlayerLayer*)playerLayerForReferenceObjectID:(long)objID;
- (void)addPlayerForReferenceObjectID:(long)objID andURL:(NSString*)midiaURL;
- (void)removePlayerForReferenceObjectID:(long)objID;
- (void)removeAllPlayers;

@end
