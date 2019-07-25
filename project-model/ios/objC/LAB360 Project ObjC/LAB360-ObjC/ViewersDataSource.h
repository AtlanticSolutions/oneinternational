//
//  ViewersDataSource.h
//  aw_experience
//
//  Created by Erico GT on 13/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceResponse.h"
#import "PanoramaGallery.h"
#import "ImageTargetItem.h"

@interface ViewersDataSource : NSObject

- (void)getPanoramaGalleryForTargetName:(NSString*)targetName withCompletionHandler:(void (^_Nullable)(PanoramaGallery* _Nullable gallery, DataSourceResponse* _Nonnull response)) handler;

- (void)getTargetsFromServerWithCompletionHandler:(void (^_Nullable)(NSMutableArray<ImageTargetItem*>* _Nullable targets, DataSourceResponse* _Nonnull response)) handler;


@end
