//
//  AdAliveImageCacheManager.h
//  aw_experience
//
//  Created by Erico GT on 13/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdAliveImageCacheManager : NSObject

//methods
+ (AdAliveImageCacheManager* _Nonnull)newImageCache;
//
- (NSString* _Nullable)loadImageURLforID:(NSString* _Nonnull)imageID andRemotelURL:(NSString* _Nonnull)remoteURL;
- (void)saveImageWithID:(NSString* _Nonnull)imageID andRemoteURL:(NSString* _Nonnull)remoteURL withCompletionHandler:(void (^_Nullable)(BOOL success, NSString* _Nullable localImageURL , NSError* _Nullable error)) handler;
- (void)saveImageWithID:(NSString* _Nonnull)imageID data:(NSData* _Nonnull)iData andRemoteURL:(NSString* _Nonnull)remoteURL withCompletionHandler:(void (^_Nullable)(BOOL success, NSString* _Nullable localImageURL , NSError* _Nullable error)) handler;
- (int)clearAllCachedImageData;

@end
