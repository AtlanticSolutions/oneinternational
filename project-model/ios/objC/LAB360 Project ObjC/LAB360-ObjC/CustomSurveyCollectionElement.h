//
//  CustomSurveyCollectionElement.h
//  LAB360-ObjC
//
//  Created by Erico GT on 09/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "CustomSurvey.h"

@interface CustomSurveyCollectionElement : NSObject

typedef enum {
    SurveyCollectionElementGeneric                  = 0,
    //
    SurveyCollectionElementTypeGroupTitle           = 101,
    SurveyCollectionElementTypeGroupHeader          = 102,
    SurveyCollectionElementTypeGroupImage           = 103,
    SurveyCollectionElementTypeGroupFooter          = 104,
    //
    SurveyCollectionElementTypeQuestionText         = 201,
    SurveyCollectionElementTypeQuestionImage        = 202,
    SurveyCollectionElementTypeQuestionWebContent   = 203,
    //
    SurveyCollectionElementTypeAnswerItem           = 301
} SurveyCollectionElementType;

@property(nonatomic, assign) SurveyCollectionElementType type;
@property(nonatomic, strong) CustomSurveyGroup *group;
@property(nonatomic, strong) CustomSurveyQuestion *question;
@property(nonatomic, strong) CustomSurveyAnswer *answer;
//
@property(nonatomic, strong) NSIndexPath *referenceIndexPath;

@end

