//
//  TimelineConfigurationManager.m
//  LAB360-ObjC
//
//  Created by Erico GT on 04/09/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "TimelineConfigurationManager.h"
#import "ConstantsManager.h"
#import "AppDelegate.h"

@interface TimelineConfigurationManager()

@property(nonatomic, assign) BOOL autoPlayVideos;
@property(nonatomic, assign) BOOL startVideoMuted;
@property(nonatomic, assign) BOOL autoExpandLongPosts;
@property(nonatomic, assign) BOOL useVideoCache;

@end

@implementation TimelineConfigurationManager

@synthesize autoPlayVideos, startVideoMuted, autoExpandLongPosts, useVideoCache;


- (instancetype)init
{
    self = [super init];
    if (self) {
        autoPlayVideos = YES;
        autoExpandLongPosts = NO;
        startVideoMuted = NO;
        useVideoCache = YES;
    }
    return self;
}

+(TimelineConfigurationManager*)newManagerLoadingConfiguration
{
    TimelineConfigurationManager *manager = [TimelineConfigurationManager new];
    [manager loadConfiguration];
    return manager;
}

- (void)loadConfiguration
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *keySound1 = APP_OPTION_KEY_TIMELINE_AUTO_PLAYVIDEOS;
    if ([userDefault objectForKey:keySound1] != nil){
        self.autoPlayVideos = [userDefault boolForKey:APP_OPTION_KEY_TIMELINE_AUTO_PLAYVIDEOS];
    }
    
    NSString *keySound2 = APP_OPTION_KEY_TIMELINE_AUTO_EXPANDPOSTS;
    if ([userDefault objectForKey:keySound2] != nil){
        self.autoExpandLongPosts = [userDefault boolForKey:APP_OPTION_KEY_TIMELINE_AUTO_EXPANDPOSTS];
    }
    
    NSString *keySound3 = APP_OPTION_KEY_TIMELINE_START_VIDEO_MUTED;
    if ([userDefault objectForKey:keySound3] != nil){
        self.startVideoMuted = [userDefault boolForKey:APP_OPTION_KEY_TIMELINE_START_VIDEO_MUTED];
    }
    
    NSString *keySound4 = APP_OPTION_KEY_TIMELINE_USE_VIDEO_CACHE;
    if ([userDefault objectForKey:keySound4] != nil){
        self.useVideoCache = [userDefault boolForKey:APP_OPTION_KEY_TIMELINE_USE_VIDEO_CACHE];
    }
}

- (void)setStateToAutoPlayVideo:(BOOL)value
{
    self.autoPlayVideos = value;
    //
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:self.autoPlayVideos forKey:APP_OPTION_KEY_TIMELINE_AUTO_PLAYVIDEOS];
    [userDefault synchronize];
}

- (void)setStateToStartVideoMuted:(BOOL)value
{
    self.startVideoMuted = value;
    //
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:self.startVideoMuted forKey:APP_OPTION_KEY_TIMELINE_START_VIDEO_MUTED];
    [userDefault synchronize];
}

- (void)setStateToAutoExpandLongPosts:(BOOL)value
{
    self.autoExpandLongPosts = value;
    //
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:self.autoExpandLongPosts forKey:APP_OPTION_KEY_TIMELINE_AUTO_EXPANDPOSTS];
    [userDefault synchronize];
}

- (void)setStateToVideoCache:(BOOL)value
{
    self.useVideoCache = value;
    //
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:self.useVideoCache forKey:APP_OPTION_KEY_TIMELINE_USE_VIDEO_CACHE];
    [userDefault synchronize];
}

@end
