//
//  PanoramaGalleryItem.h
//  aw_experience
//
//  Created by Erico GT on 12/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanoramaGalleryItem : NSObject

@property(nonatomic, assign) long itemID;
@property(nonatomic, strong) NSString *itemName;
@property(nonatomic, strong) UIImage *thumbImage;
@property(nonatomic, strong) NSString *thumbURL;
@property(nonatomic, strong) UIImage *originalImage;
@property(nonatomic, strong) NSString *originalURL;
//
@property(nonatomic, strong) NSURL *localPackageURL;

- (NSString*)createImageIdentifierForThumb;
- (NSString*)createImageIdentifierForOriginal;
//
+(PanoramaGalleryItem*)newObject;
+(PanoramaGalleryItem*)createObjectFromDictionary:(NSDictionary*)dicData;
-(PanoramaGalleryItem*)copyObject;
-(NSDictionary*)dictionaryJSON;

@end

