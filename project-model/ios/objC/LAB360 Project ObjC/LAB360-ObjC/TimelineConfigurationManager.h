//
//  TimelineConfigurationManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 04/09/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TIMELINE_POSTS_EXPANDABLE_SIZE 200

@interface TimelineConfigurationManager : NSObject

@property(nonatomic, assign, readonly) BOOL autoPlayVideos;
@property(nonatomic, assign, readonly) BOOL startVideoMuted;
@property(nonatomic, assign, readonly) BOOL autoExpandLongPosts;
@property(nonatomic, assign, readonly) BOOL useVideoCache;

//METHODS:
+(TimelineConfigurationManager*)newManagerLoadingConfiguration;
//
- (void)loadConfiguration;
//
- (void)setStateToAutoPlayVideo:(BOOL)value;
- (void)setStateToStartVideoMuted:(BOOL)value;
- (void)setStateToAutoExpandLongPosts:(BOOL)value;
- (void)setStateToVideoCache:(BOOL)value;

@end
