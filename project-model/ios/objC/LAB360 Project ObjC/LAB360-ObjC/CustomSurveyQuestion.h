//
//  CustomSurveyQuestion.h
//  LAB360-ObjC
//
//  Created by Erico GT on 08/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"
#import "CustomSurveyAnswer.h"

@interface CustomSurveyQuestion : NSObject<DefaultObjectModelProtocol>

typedef enum {
    SurveyQuestionTypeUnanswerable    = 0,
    //
    SurveyQuestionTypeSingleSelection = 1,
    SurveyQuestionTypeMultiSelection = 2,
    SurveyQuestionTypeSingleLineText = 3,
    SurveyQuestionTypeMultiLineText = 4,
    SurveyQuestionTypeMaskedText = 5,
    SurveyQuestionTypeImage = 6,
    SurveyQuestionTypeOptions = 7,
    SurveyQuestionTypeStarRating = 8,
    SurveyQuestionTypeBarRating = 9,
    SurveyQuestionTypeLikeRating = 10,
    SurveyQuestionTypeUnitRating = 11,
    SurveyQuestionTypeDecimal = 12,
    SurveyQuestionTypeCollectionView = 13,
    SurveyQuestionTypeOrderlyOptions = 14,
    SurveyQuestionTypeItemList = 15,
    SurveyQuestionTypeSpecialInput = 16,
    SurveyQuestionTypeOptionRating = 17
} SurveyQuestionType;

typedef enum {
    SurveySpecialInputTypeNormal                = 0,
    SurveySpecialInputTypeGeolocation           = 1,
    SurveySpecialInputTypeQRCode                = 2,
    SurveySpecialInputTypeBarcode               = 3,
    SurveySpecialInputTypePDF417                = 4,
    SurveySpecialInputTypeBoleto                = 5,
    SurveySpecialInputTypeColor                 = 6
} SurveySpecialInputType;

#pragma mark - Properties

@property(nonatomic, assign) long questionID;
@property(nonatomic, assign) long order;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSString *imageURL;
@property(nonatomic, strong) NSString *webContentURL;
@property(nonatomic, assign) BOOL required;
@property(nonatomic, strong) NSMutableArray<CustomSurveyAnswer*> *answers;
@property(nonatomic, strong) NSMutableArray<CustomSurveyAnswer*> *userAnswers;
@property(nonatomic, assign) BOOL discreteDisplay;
@property(nonatomic, assign) long parentQuestionID;
@property(nonatomic, assign) long parentAnswerID;
@property(nonatomic, assign) float webContentAspectRatio;
//
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) BOOL activeForUser;

//Definições para SurveyQuestionType:
@property(nonatomic, assign) SurveyQuestionType type;

//SurveyQuestionTypeSingleSelection

//SurveyQuestionTypeMultiSelection | SurveyQuestionTypeCollectionView | SurveyQuestionTypeItemList
@property(nonatomic, assign) int selectableItems;

//SurveyQuestionTypeSingleLineText | SurveyQuestionTypeMultiLineText | SurveyQuestionTypeItemList
@property(nonatomic, assign) int maxTextLenght;

//SurveyQuestionTypeMaskedText
@property(nonatomic, strong) NSString *textMask;

//SurveyQuestionTypeSingleLineText | SurveyQuestionTypeItemList
@property(nonatomic, strong) NSString *regexValidator;

//SurveyQuestionTypeImage
@property(nonatomic, assign) int maxImageDimension;
@property(nonatomic, assign) float imageQuality;

//SurveyQuestionTypeSingleLineText | SurveyQuestionTypeMultiLineText | SurveyQuestionTypeMaskedText | SurveyQuestionTypeDecimal | SurveyQuestionTypeOptions | SurveyQuestionTypeItemList
@property(nonatomic, strong) NSString *hint;

//SurveyQuestionTypeStarRating

//SurveyQuestionTypeBarRating
@property(nonatomic, strong) NSString *minBarRatingMessage;
@property(nonatomic, strong) NSString *maxBarRatingMessage;

//SurveyQuestionTypeUnitRating
@property(nonatomic, strong) NSString *unitIdentifier;

//SurveyQuestionTypeDecimal
@property(nonatomic, assign) int decimalPrecision;
@property(nonatomic, strong) NSString *decimalLeftSymbol;
@property(nonatomic, strong) NSString *decimalRightSymbol;

//SurveyQuestionTypeCollectionView
@property(nonatomic, assign) int displayColumns;

//SurveyQuestionTypeSpecialInput
@property(nonatomic, assign) SurveySpecialInputType specialInputType;
@property(nonatomic, strong) NSString *specialInputFriendlyMessage;

#pragma mark - Support Data Methods
+ (CustomSurveyQuestion*)newObject;
+ (CustomSurveyQuestion*)createObjectFromDictionary:(NSDictionary*)dicData;
- (CustomSurveyQuestion*)copyObject;
- (NSDictionary*)dictionaryJSON;
- (NSDictionary*)reducedJSON;

@end


