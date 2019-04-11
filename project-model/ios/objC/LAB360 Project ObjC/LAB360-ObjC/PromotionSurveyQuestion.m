//
//  SurveyQuestion.m
//  ShoppingBH
//
//  Created by lordesire on 02/11/2017.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "PromotionSurveyQuestion.h"

#define CLASS_PROMOTION_SURVEY_QUESTION_DEFAULT @"question"
#define CLASS_PROMOTION_SURVEY_QUESTION_TEXT @"text"
#define CLASS_PROMOTION_SURVEY_QUESTION_ANSWERS @"answers"
//
#define CLASS_PROMOTION_SURVEY_ANSWER_DEFAULT @"answers"
#define CLASS_PROMOTION_SURVEY_ANSWER_TEXT @"text"
#define CLASS_PROMOTION_SURVEY_ANSWER_ANSWER @"answer"
#define CLASS_PROMOTION_SURVEY_ANSWER_ORDER @"order"

@implementation PromotionSurveyAnswer
@synthesize answer, order, isSelected;
- (instancetype)init
{
    self = [super init];
    if (self) {
        answer = @"";
        order = 0;
        isSelected = false;
    }
    return self;
}

+ (PromotionSurveyAnswer*)newObject
{
    PromotionSurveyAnswer *psa = [PromotionSurveyAnswer new];
    return psa;
}

+ (PromotionSurveyAnswer*)createObjectFromDictionary:(NSDictionary*)dicData
{
    PromotionSurveyAnswer *p = [PromotionSurveyAnswer new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        p.answer = [keysList containsObject:CLASS_PROMOTION_SURVEY_ANSWER_TEXT] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTION_SURVEY_ANSWER_TEXT]] : p.answer;
        p.order = [keysList containsObject:CLASS_PROMOTION_SURVEY_ANSWER_ORDER] ? [[neoDic  valueForKey:CLASS_PROMOTION_SURVEY_ANSWER_ORDER] intValue] : p.order;
        p.isSelected = [keysList containsObject:CLASS_PROMOTION_SURVEY_ANSWER_ANSWER] ? [[neoDic  valueForKey:CLASS_PROMOTION_SURVEY_ANSWER_ANSWER] boolValue] : p.isSelected;
    }
    return p;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData  setValue:(self.answer != nil ? self.answer : @"") forKey:CLASS_PROMOTION_SURVEY_ANSWER_TEXT];
    [dicData  setValue:@(self.order) forKey:CLASS_PROMOTION_SURVEY_ANSWER_ORDER];
    [dicData  setValue:@(self.isSelected) forKey:CLASS_PROMOTION_SURVEY_ANSWER_ANSWER];
    //
    return dicData;
}

- (PromotionSurveyAnswer*)copyObject
{
    PromotionSurveyAnswer *p = [PromotionSurveyAnswer new];
    p.answer = self.answer != nil ? [NSString stringWithFormat:@"%@", self.answer] : nil;
    p.order = self.order;
    p.isSelected = self.isSelected;
    //
    return p;
}

@end

//*************************************************************************************

@implementation PromotionSurveyQuestion
@synthesize question, selectedAnswer, alternativesList;

- (instancetype)init
{
    self = [super init];
    if (self) {
        question = @"";
        selectedAnswer = -1;
        alternativesList = [NSMutableArray new];
    }
    return self;
}

-(void) addAnswer:(NSString*)text
{
    if (alternativesList == nil){
        alternativesList = [NSMutableArray new];
    }
    
    PromotionSurveyAnswer *alternative = [PromotionSurveyAnswer new];
    alternative.answer = (text != nil ? text : @"");
    
    [alternativesList addObject:alternative];
}

+ (PromotionSurveyQuestion*)newObject
{
    PromotionSurveyQuestion *psq = [PromotionSurveyQuestion new];
    return psq;
}

+ (PromotionSurveyQuestion*)createObjectFromDictionary:(NSDictionary*)dicData
{
    PromotionSurveyQuestion *p = [PromotionSurveyQuestion new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        p.question = [keysList containsObject:CLASS_PROMOTION_SURVEY_QUESTION_TEXT] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTION_SURVEY_QUESTION_TEXT]] : p.question;
        if ([keysList containsObject:CLASS_PROMOTION_SURVEY_QUESTION_ANSWERS]){
            if ([[neoDic valueForKey:CLASS_PROMOTION_SURVEY_QUESTION_ANSWERS] isKindOfClass:[NSArray class]]){
                NSArray *list = [[NSArray alloc] initWithArray:[neoDic valueForKey:CLASS_PROMOTION_SURVEY_QUESTION_ANSWERS]];
                for (NSDictionary *dic in list){
                    PromotionSurveyAnswer *psa = [PromotionSurveyAnswer createObjectFromDictionary:dic];
                    [p.alternativesList addObject:psa];
                }
            }
        }
    }
    return p;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData  setValue:(self.question != nil ? self.question : @"") forKey:CLASS_PROMOTION_SURVEY_QUESTION_TEXT];
    NSMutableArray *alter = [NSMutableArray new];
    for (PromotionSurveyAnswer *answer in self.alternativesList){
        [alter addObject:[answer dictionaryJSON]];
    }
    [dicData  setValue:alter forKey:CLASS_PROMOTION_SURVEY_QUESTION_ANSWERS];
    //
    return dicData;
}

- (PromotionSurveyQuestion*)copyObject
{
    PromotionSurveyQuestion *p = [PromotionSurveyQuestion new];
    p.question = self.question != nil ? [NSString stringWithFormat:@"%@", self.question] : nil;
    for (PromotionSurveyAnswer *answer in self.alternativesList){
        [p.alternativesList addObject:[answer copyObject]];
    }
    p.selectedAnswer = self.selectedAnswer;
    //
    return p;
}

@end
