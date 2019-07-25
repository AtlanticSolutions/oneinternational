//
//  PanoramaGallery.m
//  aw_experience
//
//  Created by Erico GT on 13/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "PanoramaGallery.h"
#import "ToolBox.h"

#define CLASS_PANORAMA_GALLERY_NAME @"gallery_name"
#define CLASS_PANORAMA_GALLERY_PHOTOS @"photos"
#define CLASS_PANORAMA_GALLERY_ID @"id"

@implementation PanoramaGallery

@synthesize galleryID, galleryName, photos;

- (PanoramaGallery*)init
{
    self = [super init];
    if (self) {
        galleryID = 0;
        galleryName = @"";
        photos = [NSMutableArray new];
    }
    return self;
}

//************************************************************************************************************************

+(PanoramaGallery*)newObject
{
    return [PanoramaGallery new];
}

+(PanoramaGallery*)createObjectFromDictionary:(NSDictionary*)dicData
{
    PanoramaGallery *g = [PanoramaGallery new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        g.galleryID = [keysList containsObject:CLASS_PANORAMA_GALLERY_ID] ?  [[neoDic valueForKey:CLASS_PANORAMA_GALLERY_ID] longValue] : g.galleryID;
        //
        g.galleryName = [keysList containsObject:CLASS_PANORAMA_GALLERY_NAME] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_PANORAMA_GALLERY_NAME]] : g.galleryName;
        //
        if ([keysList containsObject:CLASS_PANORAMA_GALLERY_PHOTOS]){
            NSArray *p = [[NSArray alloc] initWithArray:[neoDic valueForKey:CLASS_PANORAMA_GALLERY_PHOTOS]];
            for (NSDictionary *dic in p){
                PanoramaGalleryItem *item = [PanoramaGalleryItem createObjectFromDictionary:dic];
                [g.photos addObject:item];
            }
        }
    }
    
    return g;
}

-(PanoramaGallery*)copyObject
{
    PanoramaGallery *copy = [PanoramaGallery new];
    copy.galleryID = self.galleryID;
    copy.galleryName = self.galleryName ? [NSString stringWithFormat:@"%@", self.galleryName] : nil;
    if (self.photos != nil){
        for (PanoramaGalleryItem *item in self.photos){
            [copy.photos addObject:[item copyObject]];
        }
    }else{
        copy.photos = nil;
    }
    //
    return copy;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //
    [dic setValue:(self.galleryName ? self.galleryName : @"") forKey:CLASS_PANORAMA_GALLERY_NAME];
    [dic setValue:@(self.galleryID) forKey:CLASS_PANORAMA_GALLERY_ID];
    if (self.photos != nil){
        NSMutableArray *dics = [NSMutableArray new];
        for (PanoramaGalleryItem *item in self.photos){
            [dics addObject:[item dictionaryJSON]];
        }
        [dic setValue:dics forKey:CLASS_PANORAMA_GALLERY_PHOTOS];
    }else{
        [dic setValue:[NSArray new] forKey:CLASS_PANORAMA_GALLERY_PHOTOS];
    }
    //
    return dic;
}

@end

