//
//  VirtualShowcaseGallery.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "VirtualShowcaseGallery.h"
#import "ToolBox.h"

#define CLASS_GALLERY_DEFAULT @"virtual_showcase_gallery"
#define CLASS_GALLERY_ID @"id"
#define CLASS_GALLERY_TITLE @"title"
#define CLASS_GALLERY_MESSAGE @"message"
#define CLASS_GALLERY_BANNERURL @"banner_url"
#define CLASS_GALLERY_CATEGORIES @"categories"
//

@implementation VirtualShowcaseGallery

@synthesize galleryID, title, message, bannerURL, bannerImage, categories;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        galleryID = 0;
        title = @"";
        message = @"";
        bannerURL = @"";
        bannerImage = nil;
        categories = [NSMutableArray new];;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------

+ (VirtualShowcaseGallery*)newObject
{
    //TODO: ver classe 'BeaconShowroomItem' como exemplo.
    VirtualShowcaseGallery *vsg = [VirtualShowcaseGallery new];
    return vsg;
}

+ (VirtualShowcaseGallery*)createObjectFromDictionary:(NSDictionary*)dicData
{
    //TODO: ver classe 'BeaconShowroomItem' como exemplo.
    VirtualShowcaseGallery *vsg = [VirtualShowcaseGallery new];

    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];

    NSArray *keysList = [neoDic allKeys];

    if (keysList.count > 0)
    {
        vsg.galleryID = [keysList containsObject:CLASS_GALLERY_ID] ? [[neoDic  valueForKey:CLASS_GALLERY_ID] longValue] : vsg.galleryID;
        vsg.title = [keysList containsObject:CLASS_GALLERY_TITLE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_GALLERY_TITLE]] : vsg.title;
        vsg.message = [keysList containsObject:CLASS_GALLERY_MESSAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_GALLERY_MESSAGE]] : vsg.message;
        vsg.bannerURL = [keysList containsObject:CLASS_GALLERY_BANNERURL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_GALLERY_BANNERURL]] : vsg.bannerURL;

    }
    //
    if ([keysList containsObject:CLASS_GALLERY_CATEGORIES]) {
        NSArray *categoryList = [[NSArray alloc] initWithArray:[neoDic  objectForKey:CLASS_GALLERY_CATEGORIES]];
        for (NSDictionary *dic in categoryList) {
            VirtualShowcaseCategory *categoryItem = [VirtualShowcaseCategory createObjectFromDictionary:dic];
            [vsg.categories addObject:categoryItem];
        }
        //
//        if (vsg.categories.count > 0){
//            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
//            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//            vsg.categories = [[NSMutableArray alloc] initWithArray:[vsg.categories sortedArrayUsingDescriptors:sortDescriptors]];
//        }
    }

    return vsg;
}

- (VirtualShowcaseGallery*)copyObject
{
    //TODO: ver classe 'BeaconShowroomItem' como exemplo.
    VirtualShowcaseGallery *vsg = [VirtualShowcaseGallery new];
    vsg.galleryID = self.galleryID;
    vsg.title = self.title ? [NSString stringWithFormat:@"%@", self.title] : nil;
    vsg.message = self.message ? [NSString stringWithFormat:@"%@", self.message] : nil;
    vsg.bannerURL = self.bannerURL ? [NSString stringWithFormat:@"%@", self.bannerURL] : nil;
    vsg.bannerImage = self.bannerImage ? [UIImage imageWithData:UIImagePNGRepresentation(self.bannerImage)] : nil;
    for (VirtualShowcaseCategory *c in self.categories){
        [vsg.categories addObject:[c copyObject]];
    }
    //
    return vsg;
}

- (NSDictionary*)dictionaryJSON
{
    //TODO: ver classe 'BeaconShowroomItem' como exemplo.
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.galleryID) forKey:CLASS_GALLERY_ID];
    [dicData setValue:(self.title ? self.title : @"") forKey:CLASS_GALLERY_TITLE];
    [dicData setValue:(self.message ? self.message : @"") forKey:CLASS_GALLERY_MESSAGE];
    [dicData setValue:(self.bannerURL ? self.bannerURL : @"") forKey:CLASS_GALLERY_BANNERURL];
    //
    NSMutableArray *categoryList = [NSMutableArray new];
    for (VirtualShowcaseCategory *c in self.categories){
        [categoryList addObject:[c dictionaryJSON]];
    }
    [dicData setValue:categoryList forKey:CLASS_GALLERY_CATEGORIES];
    //
    return dicData;
}

@end
