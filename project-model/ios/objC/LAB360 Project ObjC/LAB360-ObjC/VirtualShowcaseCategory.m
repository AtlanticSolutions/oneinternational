//
//  VirtualShowcaseCategory.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "VirtualShowcaseCategory.h"
#import "ToolBox.h"

#define CLASS_CATEGORY_DEFAULT @"showrooms"
#define CLASS_CATEGORY_ID @"id"
#define CLASS_CATEGORY_NAME @"name"
#define CLASS_CATEGORY_DETAIL @"detail"
#define CLASS_CATEGORY_PICTUREURL @"picture_url"
#define CLASS_CATEGORY_MASKMODELURL @"mask_model_url"
#define CLASS_CATEGORY_FRONT_CAMERA_PREFERABLE @"front_camera_preferable"
#define CLASS_CATEGORY_PRODUCTS @"products"

@implementation VirtualShowcaseCategory

@synthesize categoryID, name, detail, pictureURL, picture, maskModelURL, maskModel, products, selected, isFrontCameraPreferable, maskAlpha, maskTintColor;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    if (self) {
        categoryID = 0;
        name = @"";
        detail = @"";
        pictureURL = @"";
        picture = nil;
        maskModelURL = @"";
        maskModel = nil;
        products = [NSMutableArray new];
        selected = NO;
        maskAlpha = 0.75;
        isFrontCameraPreferable = NO;
        maskTintColor = nil;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------

+ (VirtualShowcaseCategory*)newObject
{
    //TODO: ver classe 'BeaconShowroomItem' como exemplo.
    VirtualShowcaseCategory *vsc = [VirtualShowcaseCategory new];
    return vsc;
}

+ (VirtualShowcaseCategory*)createObjectFromDictionary:(NSDictionary*)dicData
{
    //TODO: ver classe 'BeaconShowroomItem' como exemplo.
    VirtualShowcaseCategory *vsc = [VirtualShowcaseCategory new];

    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];

    NSArray *keysList = [neoDic allKeys];

    if (keysList.count > 0)
    {
        vsc.categoryID = [keysList containsObject:CLASS_CATEGORY_ID] ? [[neoDic  valueForKey:CLASS_CATEGORY_ID] longValue] : vsc.categoryID;
        vsc.name = [keysList containsObject:CLASS_CATEGORY_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CATEGORY_NAME]] : vsc.name;
        vsc.detail = [keysList containsObject:CLASS_CATEGORY_DETAIL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CATEGORY_DETAIL]] : vsc.detail;
        vsc.pictureURL = [keysList containsObject:CLASS_CATEGORY_PICTUREURL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CATEGORY_PICTUREURL]] : vsc.pictureURL;
        vsc.maskModelURL = [keysList containsObject:CLASS_CATEGORY_MASKMODELURL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CATEGORY_MASKMODELURL]] : vsc.maskModelURL;
        //
        if ([keysList containsObject:CLASS_CATEGORY_PRODUCTS]) {
            NSArray *productList = [[NSArray alloc] initWithArray:[neoDic  objectForKey:CLASS_CATEGORY_PRODUCTS]];
            for (NSDictionary *dic in productList) {
                VirtualShowcaseProduct *productItem = [VirtualShowcaseProduct createObjectFromDictionary:dic];                
                [vsc.products addObject:productItem];
            }
            //
            if (vsc.products.count > 0){
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                vsc.products = [[NSMutableArray alloc] initWithArray:[vsc.products sortedArrayUsingDescriptors:sortDescriptors]];
            }
        }

        vsc.selected = vsc.selected;
        vsc.maskAlpha = vsc.maskAlpha;
        vsc.isFrontCameraPreferable = [keysList containsObject:CLASS_CATEGORY_FRONT_CAMERA_PREFERABLE] ? [[neoDic  valueForKey:CLASS_CATEGORY_FRONT_CAMERA_PREFERABLE] boolValue] : vsc.isFrontCameraPreferable;

    }

    return vsc;
}

- (VirtualShowcaseCategory*)copyObject
{
    VirtualShowcaseCategory *copy = [VirtualShowcaseCategory new];
    copy.categoryID = categoryID;
    copy.name = name == nil ? nil : [NSString stringWithFormat:@"%@", name];
    copy.detail = detail == nil ? nil : [NSString stringWithFormat:@"%@", detail];
    copy.pictureURL = pictureURL == nil ? nil : [NSString stringWithFormat:@"%@", pictureURL];
    copy.picture = picture == nil ? nil : [UIImage imageWithCGImage:picture.CGImage];
    copy.maskModelURL = maskModelURL == nil ? nil : [NSString stringWithFormat:@"%@", maskModelURL];
    copy.maskModel = maskModel == nil ? nil : [UIImage imageWithCGImage:maskModel.CGImage];
    //
    if (products == nil){
        copy.products = nil;
    }else{
        copy.products = [NSMutableArray new];
        for (VirtualShowcaseProduct *product in products){
            [copy.products addObject:[product copyObject]];
        }
    }
    //
    copy.selected = selected;
    copy.isFrontCameraPreferable = isFrontCameraPreferable;
    //
    copy.maskAlpha = maskAlpha;
    copy.maskTintColor = [UIColor colorWithCGColor:maskTintColor.CGColor];
    return copy;
}

- (NSDictionary*)dictionaryJSON
{
    //TODO: ver classe 'BeaconShowroomItem' como exemplo.
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.categoryID) forKey:CLASS_CATEGORY_ID];
    [dicData setValue:(self.name ? self.name : @"") forKey:CLASS_CATEGORY_NAME];
    [dicData setValue:(self.detail ? self.detail : @"") forKey:CLASS_CATEGORY_DETAIL];
    [dicData setValue:(self.pictureURL ? self.pictureURL : @"") forKey:CLASS_CATEGORY_PICTUREURL];
    [dicData setValue:(self.maskModelURL ? self.maskModelURL : @"") forKey:CLASS_CATEGORY_MASKMODELURL];

    //
    NSMutableArray *subP = [NSMutableArray new];
    for (VirtualShowcaseProduct *p in self.products){
        [subP addObject:[p dictionaryJSON]];
    }
    [dicData setValue:subP forKey:CLASS_CATEGORY_PRODUCTS];
    //
    [dicData setValue:@(self.isFrontCameraPreferable) forKey:CLASS_CATEGORY_FRONT_CAMERA_PREFERABLE];
    //
    return dicData;
}

@end
