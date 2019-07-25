//
//  PanoramaGalleryItem.m
//  aw_experience
//
//  Created by Erico GT on 12/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "PanoramaGalleryItem.h"
#import "ToolBox.h"

#define CLASS_PANORAMA_GALLERY_ID @"ambient_id"
#define CLASS_PANORAMA_GALLERY_NAME @"ambient_name"
#define CLASS_PANORAMA_GALLERY_THUMB_URL @"thumb_url"
#define CLASS_PANORAMA_GALLERY_ORIGINAL_URL @"original_url"

@implementation PanoramaGalleryItem

@synthesize itemID, itemName, thumbImage, thumbURL, originalImage, originalURL, localPackageURL;

- (PanoramaGalleryItem*)init
{
    self = [super init];
    if (self) {
        itemID = 0;
        itemName = nil;
        thumbImage = nil;
        thumbURL = nil;
        originalImage = nil;
        originalURL = nil;
        localPackageURL = nil;
    }
    return self;
}

//************************************************************************************************************************

+(PanoramaGalleryItem*)newObject
{
    return [PanoramaGalleryItem new];
}

+(PanoramaGalleryItem*)createObjectFromDictionary:(NSDictionary*)dicData
{
    PanoramaGalleryItem *item = [PanoramaGalleryItem new];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        item.itemID = [keysList containsObject:CLASS_PANORAMA_GALLERY_ID] ? [[neoDic valueForKey:CLASS_PANORAMA_GALLERY_ID] longValue] : item.itemID;
        //
        item.itemName = [keysList containsObject:CLASS_PANORAMA_GALLERY_NAME] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_PANORAMA_GALLERY_NAME]] : item.itemName;
        //
        item.thumbURL = [keysList containsObject:CLASS_PANORAMA_GALLERY_THUMB_URL] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_PANORAMA_GALLERY_THUMB_URL]] : item.thumbURL;
        //
        item.originalURL = [keysList containsObject:CLASS_PANORAMA_GALLERY_ORIGINAL_URL] ?  [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_PANORAMA_GALLERY_ORIGINAL_URL]] : item.originalURL;
    }
    return item;
}

-(PanoramaGalleryItem*)copyObject
{
    PanoramaGalleryItem *copy = [PanoramaGalleryItem new];
    copy.itemID = self.itemID;
    copy.itemName = self.itemName ? [NSString stringWithFormat:@"%@", self.itemName] : nil;
    copy.thumbImage = self.thumbImage ? [UIImage imageWithData:UIImagePNGRepresentation(self.thumbImage)] : nil;
    copy.thumbURL = self.itemName ? [NSString stringWithFormat:@"%@", self.thumbURL] : nil;
    copy.originalImage = self.originalImage ? [UIImage imageWithData:UIImagePNGRepresentation(self.originalImage)] : nil;
    copy.originalURL = self.itemName ? [NSString stringWithFormat:@"%@", self.originalURL] : nil;
    copy.localPackageURL = self.localPackageURL ? [self.localPackageURL copy] : nil;
    //
    return copy;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //
    [dic setValue:@(self.itemID) forKey:CLASS_PANORAMA_GALLERY_ID];
    [dic setValue:(self.itemName ? self.itemName : @"") forKey:CLASS_PANORAMA_GALLERY_NAME];
    [dic setValue:(self.thumbURL ? self.thumbURL : @"") forKey:CLASS_PANORAMA_GALLERY_THUMB_URL];
    [dic setValue:(self.originalURL ? self.originalURL : @"") forKey:CLASS_PANORAMA_GALLERY_ORIGINAL_URL];
    //
    return dic;
}

- (NSString*)createImageIdentifierForThumb
{
    if (itemID != 0){
        NSString *code = [NSString stringWithFormat:@"thumb_image_%li", itemID];
        return code;
    }else{
        if ([ToolBox textHelper_CheckRelevantContentInString:thumbURL]){
            NSString *code = [ToolBox textHelper_HashMD5forText:thumbURL];
            return code;
        }
        return @"thumb_image";
    }
}

- (NSString*)createImageIdentifierForOriginal
{
    if (itemID != 0){
        NSString *code = [NSString stringWithFormat:@"original_image_%li", itemID];
        return code;
    }else{
        if ([ToolBox textHelper_CheckRelevantContentInString:originalURL]){
            NSString *code = [ToolBox textHelper_HashMD5forText:originalURL];
            return code;
        }
        return @"original_image";
    }
}

@end
