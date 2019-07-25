//
//  CustomSurveyAnswer.h
//  LAB360-ObjC
//
//  Created by Erico GT on 08/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"

@interface CustomSurveyAnswer : NSObject<DefaultObjectModelProtocol>

#pragma mark - Properties
@property(nonatomic, assign) long answerID;
@property(nonatomic, assign) long order;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSString *imageURL;
@property(nonatomic, strong) NSString *minValue;
@property(nonatomic, strong) NSString *maxValue;
@property(nonatomic, strong) NSDictionary *complexValue;
@property(nonatomic, strong) NSString *note;
//
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) long referenceIndex;
//
@property(nonatomic, strong) UIImage *auxImage;
@property(nonatomic, strong) NSString *defaultValue;

#pragma mark - Support Data Methods
+ (CustomSurveyAnswer*)newObject;
+ (CustomSurveyAnswer*)createObjectFromDictionary:(NSDictionary*)dicData;
- (CustomSurveyAnswer*)copyObject;
- (NSDictionary*)dictionaryJSON;
- (NSDictionary*)dictionaryJSONWithImage;
- (NSDictionary*)reducedJSON;

@end


