//
//  VirtualShowcaseGallery.h
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultObjectModelProtocol.h"
//
#import "VirtualShowcaseCategory.h"

@interface VirtualShowcaseGallery : NSObject<DefaultObjectModelProtocol>

@property (nonatomic, assign) long galleryID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *bannerURL;
@property (nonatomic, strong) NSMutableArray<VirtualShowcaseCategory*> *categories;
//
@property (nonatomic, strong) UIImage *bannerImage;

//Protocol Methods:
+ (VirtualShowcaseGallery*)newObject;
+ (VirtualShowcaseGallery*)createObjectFromDictionary:(NSDictionary*)dicData;
- (VirtualShowcaseGallery*)copyObject;
- (NSDictionary*)dictionaryJSON;

@end
