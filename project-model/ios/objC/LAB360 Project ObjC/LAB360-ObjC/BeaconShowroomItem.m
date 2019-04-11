//
//  BeaconShowroomItem.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "BeaconShowroomItem.h"
#import "ConstantsManager.h"

#define CLASS_BEACONSHOWROOM_DEFAULT @"showrooms"
#define CLASS_BEACONSHOWROOM_ID @"id"
#define CLASS_BEACONSHOWROOM_NAME @"name"
#define CLASS_BEACONSHOWROOM_DETAIL @"description"
#define CLASS_BEACONSHOWROOM_URLIMAGE @"image_url"
#define CLASS_BEACONSHOWROOM_ORDER @"order"
#define CLASS_BEACONSHOWROOM_SUBITEMS @"shelves"
//
#define CLASS_BEACONSHOWROOM_MEDIA_ISVIDEO @"media_video"
#define CLASS_BEACONSHOWROOM_MEDIA_URL @"media_href"

@implementation BeaconShowroomItem

@synthesize itemID, parentItemID, name, detail, imageURL, order, image, subItems, isMediaAdvertisingVideo, mediaAdvertisingURL;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        itemID = 0;
        parentItemID = 0;
        name = nil;
        detail = nil;
        imageURL = nil;
        order = 0;
        image = nil;
        subItems = [NSMutableArray new];
        //
        isMediaAdvertisingVideo = NO;
        mediaAdvertisingURL = nil;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------

+ (BeaconShowroomItem*)newObject
{
    BeaconShowroomItem *bs = [BeaconShowroomItem new];
    return bs;
}

+ (BeaconShowroomItem*)createObjectFromDictionary:(NSDictionary*)dicData
{
    BeaconShowroomItem *bs = [BeaconShowroomItem new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        bs.itemID = [keysList containsObject:CLASS_BEACONSHOWROOM_ID] ? [[neoDic  valueForKey:CLASS_BEACONSHOWROOM_ID] longValue] : bs.itemID;
        bs.name = [keysList containsObject:CLASS_BEACONSHOWROOM_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_BEACONSHOWROOM_NAME]] : bs.name;
        bs.detail = [keysList containsObject:CLASS_BEACONSHOWROOM_DETAIL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_BEACONSHOWROOM_DETAIL]] : bs.detail;
        bs.imageURL = [keysList containsObject:CLASS_BEACONSHOWROOM_URLIMAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_BEACONSHOWROOM_URLIMAGE]] : bs.imageURL;
        //
        if ([[neoDic valueForKey:CLASS_BEACONSHOWROOM_ORDER] isKindOfClass:[NSString class]]){
            bs.order = (long)[((NSString*)[neoDic valueForKey:CLASS_BEACONSHOWROOM_ORDER]) longLongValue];
        }else{
            bs.order = [keysList containsObject:CLASS_BEACONSHOWROOM_ORDER] ? [[neoDic  valueForKey:CLASS_BEACONSHOWROOM_ORDER] longValue] : bs.order;
        }
        //
        if ([keysList containsObject:CLASS_BEACONSHOWROOM_SUBITEMS]) {
            NSArray *subList = [[NSArray alloc] initWithArray:[neoDic  objectForKey:CLASS_BEACONSHOWROOM_SUBITEMS]];
            for (NSDictionary *dic in subList) {
                BeaconShowroomItem *subI = [BeaconShowroomItem createObjectFromDictionary:dic];
                subI.parentItemID = bs.itemID;
                [bs.subItems addObject:subI];
            }
            //
            if (bs.subItems.count > 0){
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                bs.subItems = [[NSMutableArray alloc] initWithArray:[bs.subItems sortedArrayUsingDescriptors:sortDescriptors]];
            }
        }
        //
        bs.isMediaAdvertisingVideo = [keysList containsObject:CLASS_BEACONSHOWROOM_MEDIA_ISVIDEO] ? [[neoDic  valueForKey:CLASS_BEACONSHOWROOM_MEDIA_ISVIDEO] boolValue] : bs.isMediaAdvertisingVideo;
        bs.mediaAdvertisingURL = [keysList containsObject:CLASS_BEACONSHOWROOM_MEDIA_URL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_BEACONSHOWROOM_MEDIA_URL]] : bs.mediaAdvertisingURL;
    }
    
    //Validações
    //code here...
    
    return bs;
}

- (BeaconShowroomItem*)copyObject
{
    BeaconShowroomItem *bs = [BeaconShowroomItem new];
    bs.itemID = self.itemID;
    bs.parentItemID = self.parentItemID;
    bs.name = self.name ? [NSString stringWithFormat:@"%@", self.name] : nil;
    bs.detail = self.detail ? [NSString stringWithFormat:@"%@", self.detail] : nil;
    bs.imageURL = self.imageURL ? [NSString stringWithFormat:@"%@", self.imageURL] : nil;
    bs.image = self.image ? [UIImage imageWithData:UIImagePNGRepresentation(self.image)] : nil;
    bs.order = self.order;
    for (BeaconShowroomItem *b in self.subItems){
        [bs.subItems addObject:[b copyObject]];
    }
    //
    bs.isMediaAdvertisingVideo = self.isMediaAdvertisingVideo;
    bs.mediaAdvertisingURL = self.mediaAdvertisingURL ? [NSString stringWithFormat:@"%@", self.mediaAdvertisingURL] : nil;
    //
    return bs;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.itemID) forKey:CLASS_BEACONSHOWROOM_ID];
    [dicData setValue:(self.name ? self.name : @"") forKey:CLASS_BEACONSHOWROOM_NAME];
    [dicData setValue:(self.detail ? self.detail : @"") forKey:CLASS_BEACONSHOWROOM_DETAIL];
    [dicData setValue:(self.imageURL ? self.imageURL : @"") forKey:CLASS_BEACONSHOWROOM_URLIMAGE];
    [dicData setValue:@(self.order) forKey:CLASS_BEACONSHOWROOM_ORDER];
    //
    NSMutableArray *subI = [NSMutableArray new];
    for (BeaconShowroomItem *b in self.subItems){
        [subI addObject:[b dictionaryJSON]];
    }
    [dicData setValue:subI forKey:CLASS_BEACONSHOWROOM_SUBITEMS];
    //
    [dicData setValue:@(self.isMediaAdvertisingVideo) forKey:CLASS_BEACONSHOWROOM_MEDIA_ISVIDEO];
    [dicData setValue:(self.mediaAdvertisingURL ? self.mediaAdvertisingURL : @"") forKey:CLASS_BEACONSHOWROOM_MEDIA_URL];
    //
    return dicData;
}

@end

