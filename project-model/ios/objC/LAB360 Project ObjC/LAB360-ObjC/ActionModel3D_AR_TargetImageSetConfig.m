//
//  ActionModel3D_AR_ImageSetConfig.m
//  LAB360-ObjC
//
//  Created by Erico GT on 23/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "ActionModel3D_AR_TargetImageSetConfig.h"
#import "ConstantsManager.h"
#import "ToolBox.h"

#define CLASS_ACTION3D_AR_IMAGESET_DEFAULT @"image_set"
#define CLASS_ACTION3D_AR_IMAGESET_KEY_ID @"id"
#define CLASS_ACTION3D_AR_IMAGESET_KEY_IMAGEURL @"image_url"
#define CLASS_ACTION3D_AR_IMAGESET_KEY_PHYSICALWIDTH @"physical_width"
#define CLASS_ACTION3D_AR_IMAGESET_KEY_IMAGE @"image"

@implementation ActionModel3D_AR_TargetImageSetConfig
@synthesize imageID, imageURL, physicalWidth, image;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        imageID = 0;
        imageURL = nil;
        physicalWidth = 0.0;
        image = nil;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Support Methods
//-------------------------------------------------------------------------------------------------------------

+ (ActionModel3D_AR_TargetImageSetConfig*)createObjectFromDictionary:(NSDictionary*)dicData
{
    ActionModel3D_AR_TargetImageSetConfig *is = [ActionModel3D_AR_TargetImageSetConfig new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        is.imageID = [keysList containsObject:CLASS_ACTION3D_AR_IMAGESET_KEY_ID] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_IMAGESET_KEY_ID] longValue] : is.imageID;
        
        is.imageURL = [keysList containsObject:CLASS_ACTION3D_AR_IMAGESET_KEY_IMAGEURL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ACTION3D_AR_IMAGESET_KEY_IMAGEURL]] : is.imageURL;
        
        is.physicalWidth = [keysList containsObject:CLASS_ACTION3D_AR_IMAGESET_KEY_PHYSICALWIDTH] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_IMAGESET_KEY_PHYSICALWIDTH] floatValue] : is.physicalWidth;
        
    }
    
    return is;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.imageID) forKey:CLASS_ACTION3D_AR_IMAGESET_KEY_ID];
    [dicData setValue:(self.imageURL ? [NSString stringWithFormat:@"%@", self.imageURL] : @"") forKey:CLASS_ACTION3D_AR_IMAGESET_KEY_IMAGEURL];
    [dicData setValue:@(physicalWidth) forKey:CLASS_ACTION3D_AR_IMAGESET_KEY_PHYSICALWIDTH];
    //
    return dicData;
    
}

- (ActionModel3D_AR_TargetImageSetConfig*)copyObject
{
    ActionModel3D_AR_TargetImageSetConfig *is = [ActionModel3D_AR_TargetImageSetConfig new];
    is.imageID = self.imageID;
    is.imageURL = self.imageURL ? [NSString stringWithFormat:@"%@", self.imageURL] : nil;
    is.physicalWidth = self.physicalWidth;
    is.image = self.image ? [UIImage imageWithData:UIImagePNGRepresentation(self.image)] : nil;
    //
    return is;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - NSCoding Methods
//-------------------------------------------------------------------------------------------------------------

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.imageID forKey:CLASS_ACTION3D_AR_IMAGESET_KEY_ID];
    [aCoder encodeObject:self.imageURL forKey:CLASS_ACTION3D_AR_IMAGESET_KEY_IMAGEURL];
    [aCoder encodeFloat:self.physicalWidth forKey:CLASS_ACTION3D_AR_IMAGESET_KEY_PHYSICALWIDTH];
    [aCoder encodeObject:self.image forKey:CLASS_ACTION3D_AR_IMAGESET_KEY_IMAGE];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self != nil ){
        self.imageID = [aDecoder decodeIntegerForKey:CLASS_ACTION3D_AR_IMAGESET_KEY_ID];
        self.imageURL = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_IMAGESET_KEY_IMAGEURL];
        self.physicalWidth = [aDecoder decodeFloatForKey:CLASS_ACTION3D_AR_IMAGESET_KEY_PHYSICALWIDTH];
        self.image = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_IMAGESET_KEY_IMAGE];
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - NSSecureCoding Methods
//-------------------------------------------------------------------------------------------------------------

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
