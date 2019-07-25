//
//  PanoramaGallery.h
//  aw_experience
//
//  Created by Erico GT on 13/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanoramaGalleryItem.h"

@interface PanoramaGallery : NSObject

@property(nonatomic, assign) long galleryID;
@property(nonatomic, strong) NSString *galleryName;
@property(nonatomic, strong) NSMutableArray<PanoramaGalleryItem*> *photos;

+(PanoramaGallery*)newObject;
+(PanoramaGallery*)createObjectFromDictionary:(NSDictionary*)dicData;
-(PanoramaGallery*)copyObject;
-(NSDictionary*)dictionaryJSON;

@end

