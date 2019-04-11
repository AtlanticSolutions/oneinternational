//
//  AdAliveVideoCacheManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 23/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdAliveVideoCacheManager : NSObject

//methods
+ (AdAliveVideoCacheManager* _Nonnull)newVideoCache;
//
- (NSString* _Nullable)loadVideoURLforID:(NSString* _Nonnull)videoID andRemotelURL:(NSString* _Nonnull)remoteURL;
- (void)saveVideoWithID:(NSString* _Nonnull)videoID andRemoteURL:(NSString* _Nonnull)remoteURL withCompletionHandler:(void (^_Nullable)(BOOL success, NSString* _Nullable localVideoURL , NSError* _Nullable error)) handler;
- (int)clearAllCachedVideoData;

@end
