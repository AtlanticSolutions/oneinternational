//
//  VirtualShowcaseProduct.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "VirtualShowcaseProduct.h"
#import "ToolBox.h"

#define CLASS_PRODUCT_DEFAULT @"products"
#define CLASS_PRODUCT_ID @"id"
#define CLASS_PRODUCT_NAME @"name"
#define CLASS_PRODUCT_DETAIL @"detail"
#define CLASS_PRODUCT_PICTURE_URL @"picture_url"
#define CLASS_PRODUCT_MASK_URL @"mask_url"
#define CLASS_PRODUCT_EYES_POSITION @"eyes_position"
#define CLASS_PRODUCT_EYES_LEFTX @"left_eye_x"
#define CLASS_PRODUCT_EYES_LEFTY @"left_eye_y"
#define CLASS_PRODUCT_EYES_RIGHTX @"right_eye_x"
#define CLASS_PRODUCT_EYES_RIGHTY @"right_eye_y"

@implementation VirtualShowcaseProduct

@synthesize productID, name, detail, pictureURL, picture, maskURL, mask, combinedPhoto, leftEyePositionX, leftEyePositionY, rightEyePositionX, rightEyePositionY, selected;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    if (self) {
        productID = 0;
        name = @"";
        detail = @"";
        pictureURL = @"";
        picture = nil;
        maskURL=  @"";
        mask = nil;
        combinedPhoto = nil;
        leftEyePositionX = @"";
        leftEyePositionY = @"";
        rightEyePositionX = @"";
        rightEyePositionY = @"";
        selected = NO;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------

+ (VirtualShowcaseProduct*)newObject
{
    //TODO: ver classe 'BeaconShowroomItem' como exemplo.
    VirtualShowcaseProduct *vsp = [VirtualShowcaseProduct new];
    return vsp;
}

+ (VirtualShowcaseProduct*)createObjectFromDictionary:(NSDictionary*)dicData
{
    //TODO: ver classe 'BeaconShowroomItem' como exemplo.
    VirtualShowcaseProduct *vsp = [VirtualShowcaseProduct new];

    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];

    NSArray *keysList = [neoDic allKeys];

    if (keysList.count > 0)
    {
        vsp.productID = [keysList containsObject:CLASS_PRODUCT_ID] ? [[neoDic  valueForKey:CLASS_PRODUCT_ID] longValue] : vsp.productID;
        vsp.name = [keysList containsObject:CLASS_PRODUCT_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PRODUCT_NAME]] : vsp.name;
        vsp.detail = [keysList containsObject:CLASS_PRODUCT_DETAIL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PRODUCT_DETAIL]] : vsp.detail;
        vsp.pictureURL = [keysList containsObject:CLASS_PRODUCT_PICTURE_URL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PRODUCT_PICTURE_URL]] : vsp.pictureURL;
        vsp.maskURL = [keysList containsObject:CLASS_PRODUCT_MASK_URL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PRODUCT_MASK_URL]] : vsp.maskURL;
        //
        if ([keysList containsObject:CLASS_PRODUCT_EYES_POSITION]) {
            if ([[neoDic objectForKey:CLASS_PRODUCT_EYES_POSITION] isKindOfClass:[NSDictionary class]]){
                NSDictionary *eyesDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:[neoDic  objectForKey:CLASS_PRODUCT_EYES_POSITION] withString:@""];
                NSArray *eyesKeys = [eyesDic allKeys];
                vsp.leftEyePositionX = [eyesKeys containsObject:CLASS_PRODUCT_EYES_LEFTX] ? [NSString stringWithFormat:@"%@", [eyesDic valueForKey:CLASS_PRODUCT_EYES_LEFTX]] : vsp.leftEyePositionX;
                vsp.leftEyePositionY = [eyesKeys containsObject:CLASS_PRODUCT_EYES_LEFTY] ? [NSString stringWithFormat:@"%@", [eyesDic valueForKey:CLASS_PRODUCT_EYES_LEFTY]] : vsp.leftEyePositionY;
                vsp.rightEyePositionX = [eyesKeys containsObject:CLASS_PRODUCT_EYES_RIGHTX] ? [NSString stringWithFormat:@"%@", [eyesDic valueForKey:CLASS_PRODUCT_EYES_RIGHTX]] : vsp.rightEyePositionX;
                vsp.rightEyePositionY = [eyesKeys containsObject:CLASS_PRODUCT_EYES_RIGHTY] ? [NSString stringWithFormat:@"%@", [eyesDic valueForKey:CLASS_PRODUCT_EYES_RIGHTY]] : vsp.rightEyePositionY;
            }
        }
    }

    return vsp;
}

- (VirtualShowcaseProduct*)copyObject
{
    VirtualShowcaseProduct *copy = [VirtualShowcaseProduct new];
    copy.productID = productID;
    copy.name = name == nil ? nil : [NSString stringWithFormat:@"%@", name];
    copy.detail = detail == nil ? nil : [NSString stringWithFormat:@"%@", detail];
    copy.pictureURL = pictureURL == nil ? nil : [NSString stringWithFormat:@"%@", pictureURL];
    copy.picture = picture == nil ? nil : [UIImage imageWithCGImage:picture.CGImage];
    copy.maskURL = maskURL == nil ? nil : [NSString stringWithFormat:@"%@", maskURL];
    copy.mask = mask == nil ? nil : [UIImage imageWithCGImage:mask.CGImage];
    copy.combinedPhoto = combinedPhoto == nil ? nil : [UIImage imageWithCGImage:combinedPhoto.CGImage];
    copy.leftEyePositionX = leftEyePositionX == nil ? nil : [NSString stringWithFormat:@"%@", leftEyePositionX];
    copy.leftEyePositionY = leftEyePositionY == nil ? nil : [NSString stringWithFormat:@"%@", leftEyePositionY];
    copy.rightEyePositionX = rightEyePositionX == nil ? nil : [NSString stringWithFormat:@"%@", rightEyePositionX];
    copy.rightEyePositionY = rightEyePositionY == nil ? nil : [NSString stringWithFormat:@"%@", rightEyePositionY];
    copy.selected = selected;
    //
    return copy;
}

- (NSDictionary*)dictionaryJSON
{
    //TODO: ver classe 'BeaconShowroomItem' como exemplo.
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.productID) forKey:CLASS_PRODUCT_ID];
    [dicData setValue:(self.name ? self.name : @"") forKey:CLASS_PRODUCT_NAME];
    [dicData setValue:(self.detail ? self.detail : @"") forKey:CLASS_PRODUCT_DETAIL];
    [dicData setValue:(self.pictureURL ? self.pictureURL : @"") forKey:CLASS_PRODUCT_PICTURE_URL];
    [dicData setValue:(self.maskURL ? self.maskURL : @"") forKey:CLASS_PRODUCT_MASK_URL];
    //
    NSMutableArray *subE = [NSMutableArray new];
    [subE setValue:self.leftEyePositionX forKey:CLASS_PRODUCT_EYES_LEFTX];
    [subE setValue:self.leftEyePositionY forKey:CLASS_PRODUCT_EYES_LEFTY];
    [subE setValue:self.rightEyePositionX forKey:CLASS_PRODUCT_EYES_RIGHTX];
    [subE setValue:self.rightEyePositionY forKey:CLASS_PRODUCT_EYES_RIGHTY];

    [dicData setValue:subE forKey:CLASS_PRODUCT_EYES_POSITION];
    //
    return dicData;
}

@end
