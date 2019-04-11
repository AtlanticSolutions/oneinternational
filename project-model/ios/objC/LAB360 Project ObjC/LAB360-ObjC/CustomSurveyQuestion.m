//
//  CustomSurveyQuestion.m
//  LAB360-ObjC
//
//  Created by Erico GT on 08/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyQuestion.h"

#define CLASS_CUSTOMSURVEYQUESTION_DEFAULT @"answer"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_ID @"id"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_ORDER @"order"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_PARENTQUESTIONID @"parent_question_id"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_PARENTANSWERID @"parent_answer_id"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_TEXT @"text"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEURL @"url_image"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_WCURL @"web_content_url"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_WCAR @"web_content_aspect_ratio"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_REQUIRED @"required"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_ANSWERS @"answers"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_USERANSWERS @"user_answers"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_TYPE @"type"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_MAXTEXTLENGHT @"max_text_lenght"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_SELECTABLEITEMS @"selectable_items"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_TEXTMASK @"mask_text"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_REGEXVALIDATOR @"regex_validator"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEMAXDIMENSION @"image_max_dimension"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEQUALITY @"image_quality"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_HINT @"hint"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_UNITIDENTIFIER @"unit_identifier"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_MAXBARRATINGMSG @"max_bar_rating_message"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_MINBARRATINGMSG @"min_bar_rating_message"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALPRECISION @"decimal_precision"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALLEFTSYMBOL @"decimal_left_symbol"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALRIGHTSYMBOL @"decimal_right_symbol"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_DISPLAYCOLUMNS @"display_columns"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_DISCRETEDISPLAY @"discrete_display"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_SPECIALINPUTTYPE @"special_input_type"
#define CLASS_CUSTOMSURVEYQUESTION_KEY_SPECIALINPUTMESSAGE @"special_input_message"

@implementation CustomSurveyQuestion

@synthesize questionID, order, parentQuestionID, parentAnswerID, activeForUser, text, imageURL, webContentURL, webContentAspectRatio, required, answers, userAnswers, selectableItems, image, type, maxTextLenght, textMask, regexValidator, maxImageDimension, imageQuality, hint, minBarRatingMessage, maxBarRatingMessage, decimalPrecision, unitIdentifier, decimalLeftSymbol, decimalRightSymbol, displayColumns, discreteDisplay, specialInputType, specialInputFriendlyMessage;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
self = [super init];
if (self)
{
    questionID = 0;
    order = 0;
    parentQuestionID = 0;
    parentAnswerID = 0;
    text = nil;
    imageURL = nil;
    webContentURL = nil;
    webContentAspectRatio = 1.0;
    required = NO;
    answers = [NSMutableArray new];
    userAnswers = [NSMutableArray new];
    image = nil;
    type = SurveyQuestionTypeUnanswerable;
    selectableItems = 0;
    maxTextLenght = 1024;
    textMask = nil;
    regexValidator = nil;
    maxImageDimension = -1;
    imageQuality = 1.0;
    hint = nil;
    unitIdentifier = nil;
    minBarRatingMessage = nil;
    maxBarRatingMessage = nil;
    decimalPrecision = -1;
    decimalLeftSymbol = nil;
    decimalRightSymbol = nil;
    displayColumns = 5;
    discreteDisplay = NO;
    specialInputType = SurveySpecialInputTypeNormal;
    specialInputFriendlyMessage = nil;
    activeForUser = NO;
}
return self;
}

#pragma mark - Support Data Methods
+ (CustomSurveyQuestion*)newObject
{
    CustomSurveyQuestion *csq = [CustomSurveyQuestion new];
    return csq;
}

+ (CustomSurveyQuestion*)createObjectFromDictionary:(NSDictionary*)dicData
{
    CustomSurveyQuestion *csq = [CustomSurveyQuestion new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        //questionID
        csq.questionID = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_ID] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_ID] longValue] : csq.questionID;
        
        //order
        csq.order = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_ORDER] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_ORDER] longValue] : csq.order;
        
        //parentQuestionID
        csq.parentQuestionID = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_PARENTQUESTIONID] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_PARENTQUESTIONID] longValue] : csq.parentQuestionID;
        
        //parentAnswerID
        csq.parentAnswerID = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_PARENTANSWERID] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_PARENTANSWERID] longValue] : csq.parentAnswerID;
        
        //selectableItems
        csq.selectableItems = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_SELECTABLEITEMS] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_SELECTABLEITEMS] intValue] : csq.selectableItems;
        
        //text
        csq.text = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_TEXT] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_TEXT]] : csq.text;
        
        //imageURL
        csq.imageURL = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEURL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEURL]] : csq.imageURL;
        
        //webContentURL
        csq.webContentURL = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_WCURL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_WCURL]] : csq.webContentURL;
        
        //webContentAspectRatio
        csq.webContentAspectRatio = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_WCAR] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_WCAR] floatValue] : csq.webContentAspectRatio;
        
        //required
        csq.required = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_REQUIRED] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_REQUIRED] boolValue] : csq.required;
        
        //answers
        csq.answers = [NSMutableArray new];
        if ([keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_ANSWERS]){
            if ([[neoDic objectForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_ANSWERS] isKindOfClass:[NSArray class]]){
                NSArray *a = [neoDic objectForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_ANSWERS];
                for (NSDictionary *dic in a){
                    [csq.answers addObject:[CustomSurveyAnswer createObjectFromDictionary:dic]];
                }
            }
            //order:
            if (csq.answers.count > 0){
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                csq.answers = [[NSMutableArray alloc] initWithArray:[csq.answers sortedArrayUsingDescriptors:sortDescriptors]];
            }
        }
        
        //userAnswers
        csq.userAnswers = [NSMutableArray new];
        
        //image
        
        //type (verificar texto no retorno)
        csq.type = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_TYPE] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_TYPE] intValue] : csq.type;
        
        //maxTextLenght
        csq.maxTextLenght = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_MAXTEXTLENGHT] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_MAXTEXTLENGHT] intValue] : csq.maxTextLenght;
        
        //textMask
        csq.textMask = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_TEXTMASK] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_TEXTMASK]] : csq.textMask;
        
        //regexValidator
        csq.regexValidator = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_REGEXVALIDATOR] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_REGEXVALIDATOR]] : csq.regexValidator;
        
        //maxImageDimension
        csq.maxImageDimension = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEMAXDIMENSION] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEMAXDIMENSION] intValue] : csq.maxImageDimension;
        
        //imageQuality
        csq.imageQuality = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEQUALITY] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEQUALITY] floatValue] : csq.imageQuality;
        
        //hint
        csq.hint = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_HINT] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_HINT]] : csq.hint;
        
        //unit_identifier
        csq.unitIdentifier = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_UNITIDENTIFIER] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_UNITIDENTIFIER]] : csq.unitIdentifier;
        
        //minBarRatingMessage
        csq.minBarRatingMessage = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_MINBARRATINGMSG] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_MINBARRATINGMSG]] : csq.minBarRatingMessage;
        
        //maxBarRatingMessage
        csq.maxBarRatingMessage = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_MAXBARRATINGMSG] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_MAXBARRATINGMSG]] : csq.maxBarRatingMessage;
        
        //decimalPrecision
        csq.decimalPrecision = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALPRECISION] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALPRECISION] intValue] : csq.decimalPrecision;
    
        //decimal_left_symbol
        csq.decimalLeftSymbol = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALLEFTSYMBOL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALLEFTSYMBOL]] : csq.decimalLeftSymbol;
        
        //decimal_right_symbol
        csq.decimalRightSymbol = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALRIGHTSYMBOL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALRIGHTSYMBOL]] : csq.decimalRightSymbol;
        
        //displayColumns
        csq.displayColumns = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_DISPLAYCOLUMNS] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_DISPLAYCOLUMNS] intValue] : csq.displayColumns;
        
        //discreteDisplay
        csq.discreteDisplay = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_DISCRETEDISPLAY] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_DISCRETEDISPLAY] boolValue] : csq.discreteDisplay;
        
        //specialInputType
        csq.specialInputType = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_SPECIALINPUTTYPE] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_SPECIALINPUTTYPE] intValue] : csq.specialInputType;
        
        //specialInputFriendlyMessage
        csq.specialInputFriendlyMessage = [keysList containsObject:CLASS_CUSTOMSURVEYQUESTION_KEY_SPECIALINPUTMESSAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYQUESTION_KEY_SPECIALINPUTMESSAGE]] : csq.specialInputFriendlyMessage;
    }
    
    //validations:
    csq.selectableItems = csq.selectableItems < 0 ? 0 : csq.selectableItems;
    csq.displayColumns =  csq.displayColumns < 1 ? 5 : (csq.displayColumns > 5 ? 5 : csq.displayColumns);
    csq.specialInputType = (csq.specialInputType < SurveySpecialInputTypeNormal ? SurveySpecialInputTypeNormal : (csq.specialInputType > SurveySpecialInputTypeColor ? SurveySpecialInputTypeColor : csq.specialInputType));
    
    csq.webContentAspectRatio = csq.webContentAspectRatio < 0.2 ? 0.2 : (csq.webContentAspectRatio > 2.0 ? 2.0 : csq.webContentAspectRatio);
    
    //caso não exista nenhuma resposta cadastrada, a uma questão padrão será criada, dependendo do tipo:
    if (csq.answers.count == 0){
        CustomSurveyAnswer *answer = [csq defaultAnswerForType:csq.type];
        if (answer){
            [csq.answers addObject:answer];
        }else{
            csq.type = SurveyQuestionTypeUnanswerable;
        }
    }
    
    //caso não exista texto ou imagem na questão ela será discreta automaticamente:
    if (![ToolBox textHelper_CheckRelevantContentInString:csq.text] && ![ToolBox textHelper_CheckRelevantContentInString:csq.imageURL]){
        csq.discreteDisplay = YES;
    }
    
    //image quality
    csq.imageQuality = csq.imageQuality < 0.0 ? 1.0 : (csq.imageQuality > 1.0 ? 1.0 : csq.imageQuality);
    
    return csq;
}

- (CustomSurveyQuestion*)copyObject
{
    CustomSurveyQuestion *copy = [CustomSurveyQuestion new];
    copy.questionID = self.questionID;
    copy.order = self.order;
    copy.parentQuestionID = self.parentQuestionID;
    copy.parentAnswerID = self.parentAnswerID;
    copy.selectableItems = self.selectableItems;
    copy.required = self.required;
    copy.text = self.text ? [NSString stringWithFormat:@"%@", self.text] : nil;
    copy.imageURL = self.imageURL ? [NSString stringWithFormat:@"%@", self.imageURL] : nil;
    copy.webContentURL = self.webContentURL ? [NSString stringWithFormat:@"%@", self.webContentURL] : nil;
    copy.webContentAspectRatio = self.webContentAspectRatio;
    //
    if (self.answers != nil){
        for (CustomSurveyAnswer *answer in self.answers){
            [copy.answers addObject:[answer copyObject]];
        }
    }else{
        copy.answers = nil;
    }
    //
    if (self.userAnswers != nil){
        for (CustomSurveyAnswer *answer in self.userAnswers){
            [copy.userAnswers addObject:[answer copyObject]];
        }
    }else{
        copy.userAnswers = nil;
    }
    //
    copy.image = self.image ? [UIImage imageWithData:UIImagePNGRepresentation(self.image)] : nil;
    copy.type = self.type;
    copy.maxTextLenght = self.maxTextLenght;
    copy.textMask = self.textMask ? [NSString stringWithFormat:@"%@", self.textMask] : nil;
    copy.regexValidator = self.regexValidator ? [NSString stringWithFormat:@"%@", self.regexValidator] : nil;
    copy.maxImageDimension = self.maxImageDimension;
    copy.imageQuality = self.imageQuality;
    copy.hint = self.hint ? [NSString stringWithFormat:@"%@", self.hint] : nil;
    copy.unitIdentifier = self.unitIdentifier ? [NSString stringWithFormat:@"%@", self.unitIdentifier] : nil;
    copy.minBarRatingMessage = self.minBarRatingMessage ? [NSString stringWithFormat:@"%@", self.minBarRatingMessage] : nil;
    copy.maxBarRatingMessage = self.maxBarRatingMessage ? [NSString stringWithFormat:@"%@", self.maxBarRatingMessage] : nil;
    copy.decimalPrecision = self.decimalPrecision;
    copy.decimalLeftSymbol = self.decimalLeftSymbol ? [NSString stringWithFormat:@"%@", self.decimalLeftSymbol] : nil;
    copy.decimalRightSymbol = self.decimalRightSymbol ? [NSString stringWithFormat:@"%@", self.decimalRightSymbol] : nil;
    copy.displayColumns = self.displayColumns;
    copy.discreteDisplay = self.discreteDisplay;
    copy.specialInputType = self.specialInputType;
    copy.specialInputFriendlyMessage = self.specialInputFriendlyMessage ? [NSString stringWithFormat:@"%@", self.specialInputFriendlyMessage] : nil;
    copy.activeForUser = self.activeForUser;
    
    return copy;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(questionID) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_ID];
    [dicData setValue:@(order) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_ORDER];
    [dicData setValue:@(parentQuestionID) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_PARENTQUESTIONID];
    [dicData setValue:@(parentAnswerID) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_PARENTANSWERID];
    [dicData setValue:@(selectableItems) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_SELECTABLEITEMS];
    [dicData setValue:(self.text ? self.text : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_TEXT];
    [dicData setValue:(self.imageURL ? self.imageURL : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEURL];
    [dicData setValue:(self.webContentURL ? self.webContentURL : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_WCURL];
    [dicData setValue:@(self.webContentAspectRatio) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_WCAR];
    [dicData setValue:(self.imageURL ? self.imageURL : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEURL];
    [dicData setValue:@(required) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_REQUIRED];
    //
    if (self.answers != nil){
        NSMutableArray *list = [NSMutableArray new];
        for (CustomSurveyAnswer *answer in self.answers){
            [list addObject:[answer dictionaryJSON]];
        }
        [dicData setValue:list forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_ANSWERS];
    }else{
        [dicData setValue:[NSArray new] forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_ANSWERS];
    }
    //
    if (self.userAnswers != nil){
        NSMutableArray *list = [NSMutableArray new];
        for (CustomSurveyAnswer *answer in self.userAnswers){
            [list addObject:[answer dictionaryJSON]];
        }
        [dicData setValue:list forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_USERANSWERS];
    }else{
        [dicData setValue:[NSArray new] forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_USERANSWERS];
    }
    //
    [dicData setValue:@(type) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_TYPE];
    [dicData setValue:@(maxTextLenght) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_MAXTEXTLENGHT];
    [dicData setValue:(self.textMask ? self.textMask : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_TEXTMASK];
    [dicData setValue:(self.regexValidator ? self.regexValidator : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_REGEXVALIDATOR];
    [dicData setValue:@(maxImageDimension) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEMAXDIMENSION];
    [dicData setValue:@(imageQuality) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_IMAGEQUALITY];
    [dicData setValue:(self.hint ? self.hint : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_HINT];
    [dicData setValue:(self.unitIdentifier ? self.unitIdentifier : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_UNITIDENTIFIER];
    [dicData setValue:(self.minBarRatingMessage ? self.minBarRatingMessage : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_MAXBARRATINGMSG];
    [dicData setValue:(self.maxBarRatingMessage ? self.maxBarRatingMessage : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_MINBARRATINGMSG];
    [dicData setValue:@(decimalPrecision) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALPRECISION];
    [dicData setValue:(self.decimalLeftSymbol ? self.decimalLeftSymbol : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALLEFTSYMBOL];
    [dicData setValue:(self.decimalRightSymbol ? self.decimalRightSymbol : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_DECIMALRIGHTSYMBOL];
    [dicData setValue:@(displayColumns) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_DISPLAYCOLUMNS];
    [dicData setValue:@(discreteDisplay) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_DISCRETEDISPLAY];
    [dicData setValue:@(specialInputType) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_SPECIALINPUTTYPE];
    [dicData setValue:(self.specialInputFriendlyMessage ? self.specialInputFriendlyMessage : @"") forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_SPECIALINPUTMESSAGE];
    //
    return dicData;
}

- (NSDictionary*)reducedJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(questionID) forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_ID];
    if (self.userAnswers != nil){
        NSMutableArray *list = [NSMutableArray new];
        for (CustomSurveyAnswer *answer in self.userAnswers){
            [list addObject:[answer reducedJSON]];
        }
        [dicData setValue:list forKey:CLASS_CUSTOMSURVEYQUESTION_KEY_ANSWERS]; // CLASS_CUSTOMSURVEYQUESTION_KEY_USERANSWERS - Fábio espera nome diferente
    }
    //
    return dicData;
}

#pragma mark -

- (CustomSurveyAnswer*)defaultAnswerForType:(SurveyQuestionType)type
{
    CustomSurveyAnswer *answer = nil;
    
    if (type == SurveyQuestionTypeSingleSelection ||
        type == SurveyQuestionTypeMultiSelection ||
        type == SurveyQuestionTypeOptions ||
        type == SurveyQuestionTypeCollectionView ||
        type == SurveyQuestionTypeOrderlyOptions ||
        type == SurveyQuestionTypeOptionRating)
    {
        return answer;
    }
    
    answer = [CustomSurveyAnswer new];
    answer.answerID = 0;
    answer.text = @"";
    answer.imageURL = @"";
    answer.minValue = @"";
    answer.maxValue = @"";
    answer.defaultValue = @"";
    answer.complexValue = nil;
    answer.note = @"";
    answer.image = nil;
    answer.referenceIndex = 0;
    answer.auxImage = nil;
    
    return answer;
}

@end
