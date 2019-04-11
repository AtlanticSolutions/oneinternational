//
//  CustomSurveyAnswer.m
//  LAB360-ObjC
//
//  Created by Erico GT on 08/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyAnswer.h"

#define CLASS_CUSTOMSURVEYANSWER_DEFAULT @"answer"
#define CLASS_CUSTOMSURVEYANSWER_KEY_ID @"id"
#define CLASS_CUSTOMSURVEYANSWER_KEY_ORDER @"order"
#define CLASS_CUSTOMSURVEYANSWER_KEY_TEXT @"text"
#define CLASS_CUSTOMSURVEYANSWER_KEY_IMAGEURL @"url_image"
#define CLASS_CUSTOMSURVEYANSWER_KEY_MINVALUE @"min_value"
#define CLASS_CUSTOMSURVEYANSWER_KEY_MAXVALUE @"max_value"
#define CLASS_CUSTOMSURVEYANSWER_KEY_DEFAULTVALUE @"default_value"
#define CLASS_CUSTOMSURVEYANSWER_KEY_COMPLEXVALUE @"complex_value"
#define CLASS_CUSTOMSURVEYANSWER_KEY_NOTE @"note"
#define CLASS_CUSTOMSURVEYANSWER_KEY_BASE64IMAGE @"base_64_image"

@implementation CustomSurveyAnswer

@synthesize answerID, order, text, imageURL, minValue, maxValue, defaultValue, complexValue, note, image, referenceIndex, auxImage;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        answerID = 0;
        order = 0;
        text = nil;
        imageURL = nil;
        minValue = nil;
        maxValue = nil;
        defaultValue = nil;
        complexValue = nil;
        note = nil;
        image = nil;
        referenceIndex = 0;
        auxImage = nil;
    }
    return self;
}

#pragma mark - Support Data Methods
+ (CustomSurveyAnswer*)newObject
{
    CustomSurveyAnswer *csa = [CustomSurveyAnswer new];
    return csa;
}

+ (CustomSurveyAnswer*)createObjectFromDictionary:(NSDictionary*)dicData
{
    CustomSurveyAnswer *csa = [CustomSurveyAnswer new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        //answerID
        csa.answerID = [keysList containsObject:CLASS_CUSTOMSURVEYANSWER_KEY_ID] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYANSWER_KEY_ID] longValue] : csa.answerID;
        
        //order
        csa.order = [keysList containsObject:CLASS_CUSTOMSURVEYANSWER_KEY_ORDER] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYANSWER_KEY_ORDER] longValue] : csa.order;
        
        //text
        csa.text = [keysList containsObject:CLASS_CUSTOMSURVEYANSWER_KEY_TEXT] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYANSWER_KEY_TEXT]] : csa.text;
        
        //imageURL
        csa.imageURL = [keysList containsObject:CLASS_CUSTOMSURVEYANSWER_KEY_IMAGEURL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYANSWER_KEY_IMAGEURL]] : csa.imageURL;
        
        //minValue
        csa.minValue = [keysList containsObject:CLASS_CUSTOMSURVEYANSWER_KEY_MINVALUE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYANSWER_KEY_MINVALUE]] : csa.minValue;
        
        //maxValue
        csa.maxValue = [keysList containsObject:CLASS_CUSTOMSURVEYANSWER_KEY_MAXVALUE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYANSWER_KEY_MAXVALUE]] : csa.maxValue;
        
        //defaultValue
        csa.defaultValue = [keysList containsObject:CLASS_CUSTOMSURVEYANSWER_KEY_DEFAULTVALUE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYANSWER_KEY_DEFAULTVALUE]] : csa.defaultValue;
        
        //note
        csa.note = [keysList containsObject:CLASS_CUSTOMSURVEYANSWER_KEY_NOTE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYANSWER_KEY_NOTE]] : csa.note;
        
        //complexValue
        if ([keysList containsObject:CLASS_CUSTOMSURVEYANSWER_KEY_COMPLEXVALUE]){
            id cValue = [neoDic valueForKey:CLASS_CUSTOMSURVEYANSWER_KEY_COMPLEXVALUE];
            if ([cValue isKindOfClass:[NSDictionary class]]){
                csa.complexValue = (NSDictionary*)cValue;
            }
        }
        
    }
    
    return csa;
}

- (CustomSurveyAnswer*)copyObject
{
    CustomSurveyAnswer *copy = [CustomSurveyAnswer new];
    copy.answerID = self.answerID;
    copy.order = self.order;
    copy.text = self.text ? [NSString stringWithFormat:@"%@", self.text] : nil;
    copy.imageURL = self.imageURL ? [NSString stringWithFormat:@"%@", self.imageURL] : nil;
    copy.minValue = self.minValue ? [NSString stringWithFormat:@"%@", self.minValue] : nil;
    copy.maxValue = self.maxValue ? [NSString stringWithFormat:@"%@", self.maxValue] : nil;
    copy.defaultValue = self.defaultValue ? [NSString stringWithFormat:@"%@", self.defaultValue] : nil;
    copy.note = self.note ? [NSString stringWithFormat:@"%@", self.note] : nil;
    copy.image = self.image ? [UIImage imageWithData:UIImagePNGRepresentation(self.image)] : nil;
    copy.auxImage = self.auxImage ? [UIImage imageWithData:UIImagePNGRepresentation(self.auxImage)] : nil;
    copy.referenceIndex = self.referenceIndex;
    //Deep Copy (version A)
    if (self.complexValue){
        NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:self.complexValue];
        copy.complexValue = [[NSDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:dicData]];
    }
    //Deep Copy (version B)
    //if (self.complexValue){
    //    CFPropertyListRef ref = CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (__bridge CFPropertyListRef)(self.complexValue), kCFPropertyListMutableContainers);
    //    copy.complexValue = CFBridgingRelease(ref);
    //}

    return copy;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.answerID) forKey:CLASS_CUSTOMSURVEYANSWER_KEY_ID];
    [dicData setValue:@(self.order) forKey:CLASS_CUSTOMSURVEYANSWER_KEY_ORDER];
    [dicData setValue:(self.text ? self.text : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_TEXT];
    [dicData setValue:(self.imageURL ? self.imageURL : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_IMAGEURL];
    [dicData setValue:(self.minValue ? self.minValue : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_MINVALUE];
    [dicData setValue:(self.maxValue ? self.maxValue : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_MAXVALUE];
    [dicData setValue:(self.defaultValue ? self.defaultValue : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_DEFAULTVALUE];
    [dicData setValue:(self.note ? self.note : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_NOTE];
    [dicData setValue:(self.complexValue ? self.complexValue : [NSDictionary new]) forKey:CLASS_CUSTOMSURVEYANSWER_KEY_COMPLEXVALUE];
    //
    return dicData;
}

- (NSDictionary*)dictionaryJSONWithImage
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.answerID) forKey:CLASS_CUSTOMSURVEYANSWER_KEY_ID];
    [dicData setValue:@(self.order) forKey:CLASS_CUSTOMSURVEYANSWER_KEY_ORDER];
    [dicData setValue:(self.text ? self.text : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_TEXT];
    [dicData setValue:(self.imageURL ? self.imageURL : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_IMAGEURL];
    [dicData setValue:(self.minValue ? self.minValue : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_MINVALUE];
    [dicData setValue:(self.maxValue ? self.maxValue : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_MAXVALUE];
    [dicData setValue:(self.defaultValue ? self.defaultValue : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_DEFAULTVALUE];
    [dicData setValue:(self.image ? [ToolBox graphicHelper_EncodeToBase64String:self.image] : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_BASE64IMAGE];
    [dicData setValue:(self.note ? self.note : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_NOTE];
    [dicData setValue:(self.complexValue ? self.complexValue : [NSDictionary new]) forKey:CLASS_CUSTOMSURVEYANSWER_KEY_COMPLEXVALUE];
    //
    return dicData;
}

- (NSDictionary*)reducedJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    if (self.answerID != 0){
        [dicData setValue:@(self.answerID) forKey:CLASS_CUSTOMSURVEYANSWER_KEY_ID];
    }
    [dicData setValue:(self.text ? self.text : @"") forKey:CLASS_CUSTOMSURVEYANSWER_KEY_TEXT];
    if (self.image){
        [dicData setValue:[ToolBox graphicHelper_EncodeToBase64String:self.image] forKey:CLASS_CUSTOMSURVEYANSWER_KEY_BASE64IMAGE];
    }
    if (self.complexValue){
        [dicData setValue:self.complexValue forKey:CLASS_CUSTOMSURVEYANSWER_KEY_COMPLEXVALUE];
    }
    //
    return dicData;
}

@end
