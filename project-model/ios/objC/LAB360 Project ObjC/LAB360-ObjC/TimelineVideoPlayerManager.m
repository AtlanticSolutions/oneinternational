//
//  TimelineVideoPlayerManager.m
//  LAB360-ObjC
//
//  Created by Erico GT on 04/12/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "TimelineVideoPlayerManager.h"

@interface TimelineVideoPlayerManager()

@property(nonatomic, strong) NSMutableArray<TimelineVideoPlayerItem*> *itemsList;

@end

@implementation TimelineVideoPlayerManager

@synthesize itemsList;

- (instancetype)init
{
    self = [super init];
    if (self) {
        itemsList = [NSMutableArray new];
    }
    return self;
}

- (AVPlayer*)playerForReferenceObjectID:(long)objID
{
    AVPlayer *p = nil;
    for (TimelineVideoPlayerItem *item in itemsList){
        if (item.refObjID == objID){
            p = item.player;
            break;
        }
    }
    return p;
}

- (AVPlayerLayer*)playerLayerForReferenceObjectID:(long)objID
{
    AVPlayerLayer *l = nil;
    for (TimelineVideoPlayerItem *item in itemsList){
        if (item.refObjID == objID){
            l = item.playerLayer;
            break;
        }
    }
    return l;
}

- (void)addPlayerForReferenceObjectID:(long)objID andURL:(NSString*)midiaURL
{
    if ([self playerForReferenceObjectID:objID] != nil){
        return;
    }
    
    __block TimelineVideoPlayerItem *newItem = [TimelineVideoPlayerItem new];
    newItem.refObjID = objID;
    
    NSURL *url = nil;
    NSString *urlTest = [[midiaURL stringByExpandingTildeInPath] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet] ];
    if ([urlTest hasPrefix:@"/"] || [urlTest hasPrefix:@"file:"]){
        //Interno:
        url = [[NSURL alloc] initFileURLWithPath:urlTest isDirectory:NO];
    }else{
        //Externo:
        url = [[NSURL alloc] initWithString:urlTest];
    }
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    [asset loadValuesAsynchronouslyForKeys:@[@"playable"] completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus status = [asset statusOfValueForKey:@"playable" error:&error];
        
        if (error == nil && status == AVKeyValueStatusLoaded){
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
            newItem.player = [AVPlayer playerWithPlayerItem:playerItem];
            newItem.playerLayer = [AVPlayerLayer playerLayerWithPlayer:newItem.player];
            //
            [itemsList addObject:newItem];
        }
    }];
}

- (void)removePlayerForReferenceObjectID:(long)objID
{
    long indexToRemove = -1;
    for (int i=0; i<itemsList.count; i++){
        TimelineVideoPlayerItem *item = [itemsList objectAtIndex:i];
        if (item.refObjID == objID){
            [item.playerLayer removeFromSuperlayer];
            item.playerLayer = nil;
            //
            [item.player pause];
            item.player = nil;
            //
            indexToRemove = i;
        }
    }
    if (indexToRemove >= 0){
        [itemsList removeObjectAtIndex:indexToRemove];
    }
}

- (void)removeAllPlayers
{
    for (TimelineVideoPlayerItem *item in itemsList){
        [item.playerLayer removeFromSuperlayer];
        item.playerLayer = nil;
        //
        [item.player pause];
        item.player = nil;
    }
    [itemsList removeAllObjects];
}


@end
