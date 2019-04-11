//
//  TimelineVideoCacheManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 03/12/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimelineVideoCacheManager : NSObject

//methods
+ (TimelineVideoCacheManager* _Nonnull)newVideoCache;
//
- (NSString* _Nullable)loadVideoURLforID:(NSString* _Nonnull)postID andRemotelURL:(NSString* _Nonnull)remoteURL;
- (void)saveVideoWithID:(NSString* _Nonnull)postID andRemoteURL:(NSString* _Nonnull)remoteURL withCompletionHandler:(void (^_Nullable)(BOOL success, NSString* _Nullable localVideoURL , NSError* _Nullable error)) handler;
- (int)clearAllCachedVideoData;

@end
