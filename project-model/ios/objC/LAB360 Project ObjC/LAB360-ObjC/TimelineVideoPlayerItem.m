//
//  TimelineVideoPlayerItem.m
//  LAB360-ObjC
//
//  Created by Erico GT on 04/12/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "TimelineVideoPlayerItem.h"

@implementation TimelineVideoPlayerItem

@synthesize refObjID, player, playerLayer;

- (instancetype)init
{
    self = [super init];
    if (self) {
        refObjID = 0;
        player = nil;
        playerLayer = nil;
    }
    return self;
}

@end
