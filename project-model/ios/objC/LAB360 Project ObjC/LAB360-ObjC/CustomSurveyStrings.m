//
//  CustomSurveyStrings.m
//  LAB360-Dev
//
//  Created by Erico GT on 26/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyStrings.h"

#define CLASS_CUSTOMSURVEYSTRING_DEFAULT @"string_set"
//
#define CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INCOMPLETEQUESTIONS @"msg_incompletequestions"
#define CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_PASSEDDATE @"msg_passeddate"
#define CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_FUTUREDATE @"msg_futuredate"
#define CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INCOMPATIBLEVERSION @"msg_incompatibleversion"
#define CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_UNANSWERABLE @"msg_unanswerable"
#define CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_NOGROUPS @"msg_nogroups"
#define CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INTERRUPTEDBYUSER @"msg_interruptedbyuser"
#define CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_WITHDRAWALBYUSER @"msg_withdrawalbyuser"
#define CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_TIMEOUTEXIT @"msg_timeoutexit"
#define CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_TIMEOUTFINISH @"msg_timeoutfinish"
#define CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_SUCCESSFINISH @"msg_successfinish"
#define CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_INVALID @"msg_invalidgroup"
#define CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_QUESTIONSERROR @"msg_questionserror"
#define CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_INCOMPLETESTAGE @"msg_incompletestage"

@implementation CustomSurveyStrings

@synthesize MSG_INCOMPLETEQUESTIONS, MSG_FUTUREDATE, MSG_PASSEDDATE, MSG_INCOMPATIBLEVERSION, MSG_UNANSWERABLE, MSG_NOGROUPS, MSG_INTERRUPTEDBYUSER, MSG_WITHDRAWALBYUSER, MSG_TIMEOUTEXIT, MSG_TIMEOUTFINISH, MSG_SUCCESSFINISH;
@synthesize MSG_INVALIDGROUP, MSG_QUESTIONSERROR, MSG_INCOMPLETESTAGE;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        [self loadDefaultMessages];
    }
    return self;
}

- (void)loadDefaultMessages
{
    //SURVEY:
    MSG_INCOMPLETEQUESTIONS = @"Pelo menos umas das questões é obrigatória e não foi preenchida.\nPor favor, revise seu questionário antes de submetê-lo.";
    //
    MSG_FUTUREDATE = @"Este questionário estará disponível para preenchimento à partir de <DATE>.";
    //
    MSG_PASSEDDATE = @"Este questionário não está mais disponível para preenchimento (expirou dia <DATE>).";
    //
    MSG_INCOMPATIBLEVERSION = @"A versão deste questionário não é suportada por esta versão do aplicativo.\nPor favor, verifique se existem atualizações pendentes.";
    //
    MSG_UNANSWERABLE = @"Este questionário não está disponível para ser respondido no momento.";
    //
    MSG_NOGROUPS = @"Este questionário não possui nenhum grupo atribuído e não pode ser respondido no momento.";
    //
    MSG_INTERRUPTEDBYUSER = @"Você pode recomeçar este questionário a qualquer momento.\n\nDeseja sair agora?";
    //
    MSG_WITHDRAWALBYUSER = @"Este questionário não aceita interrupções/cancelamentos. Isto significa que se você sair agora a mesma não estará mais disponível para preenchimento futuro.\n\nTem certeza que deseja sair?";
    //
    MSG_TIMEOUTEXIT =  @"O tempo limite para este questionário já foi atingido.\nVocê ainda pode ver as questões mas não será mais possível submeter suas respostas.\n\nDeseja sair agora?";
    //
    MSG_TIMEOUTFINISH = @"O tempo limite para este questionário foi atingido e não é mais possível submeter suas respostas.\n\nAgradecemos sua participação!";
    //
    MSG_SUCCESSFINISH = @"Suas respostas foram submetidas com sucesso.\nObrigado por responder este questionário!";
    //
    MSG_INVALIDGROUP = @"Este questionário possui pelo menos um grupo inválido e não pode ser respondido no momento.";
    //
    MSG_QUESTIONSERROR = @"Este questionário possui pelo menos um grupo com questões inválidas e não pode ser respondido no momento.";
    //
    MSG_INCOMPLETESTAGE = @"Pelo menos umas das questões desta etapa é obrigatória e não foi preenchida.\nPor favor, verifique.";
    
}

#pragma mark - Support Data Methods

+ (CustomSurveyStrings*)newObject
{
    CustomSurveyStrings *css = [CustomSurveyStrings new];
    return css;
}

+ (CustomSurveyStrings*)createObjectFromDictionary:(NSDictionary*)dicData
{
    CustomSurveyStrings *css = [CustomSurveyStrings new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        //SURVEY:
        css.MSG_INCOMPLETEQUESTIONS = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INCOMPLETEQUESTIONS] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INCOMPLETEQUESTIONS]] : css.MSG_INCOMPLETEQUESTIONS;
        //
        css.MSG_PASSEDDATE = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_PASSEDDATE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_PASSEDDATE]] : css.MSG_PASSEDDATE;
        //
        css.MSG_FUTUREDATE = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_FUTUREDATE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_FUTUREDATE]] : css.MSG_FUTUREDATE;
        //
        css.MSG_INCOMPATIBLEVERSION = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INCOMPATIBLEVERSION] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INCOMPATIBLEVERSION]] : css.MSG_INCOMPATIBLEVERSION;
        //
        css.MSG_UNANSWERABLE = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_UNANSWERABLE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_UNANSWERABLE]] : css.MSG_UNANSWERABLE;
        //
        css.MSG_NOGROUPS = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_NOGROUPS] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_NOGROUPS]] : css.MSG_NOGROUPS;
        //
        css.MSG_INTERRUPTEDBYUSER = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INTERRUPTEDBYUSER] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INTERRUPTEDBYUSER]] : css.MSG_INTERRUPTEDBYUSER;
        //
        css.MSG_WITHDRAWALBYUSER = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_WITHDRAWALBYUSER] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_WITHDRAWALBYUSER]] : css.MSG_WITHDRAWALBYUSER;
        //
        css.MSG_TIMEOUTEXIT = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_TIMEOUTEXIT] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_TIMEOUTEXIT]] : css.MSG_TIMEOUTEXIT;
        //
        css.MSG_TIMEOUTFINISH = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_TIMEOUTFINISH] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_TIMEOUTFINISH]] : css.MSG_TIMEOUTFINISH;
        //
        css.MSG_SUCCESSFINISH = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_SUCCESSFINISH] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_SUCCESSFINISH]] : css.MSG_SUCCESSFINISH;
        
        //GROUPS:
        css.MSG_INVALIDGROUP = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_INVALID] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_INVALID]] : css.MSG_INVALIDGROUP;
        //
        css.MSG_QUESTIONSERROR = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_QUESTIONSERROR] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_QUESTIONSERROR]] : css.MSG_QUESTIONSERROR;
        //
        css.MSG_INCOMPLETESTAGE = [keysList containsObject:CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_INCOMPLETESTAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_INCOMPLETESTAGE]] : css.MSG_INCOMPLETESTAGE;
        
        //QUESTIONS:
        
        //ANSWERS:
        
    }
    
    return css;
}

- (CustomSurveyStrings*)copyObject
{
    CustomSurveyStrings *copy = [CustomSurveyStrings new];
    //
    copy.MSG_INCOMPLETEQUESTIONS = self.MSG_INCOMPLETEQUESTIONS ? [NSString stringWithFormat:@"%@", self.MSG_INCOMPLETEQUESTIONS] : nil;
    copy.MSG_PASSEDDATE = self.MSG_PASSEDDATE ? [NSString stringWithFormat:@"%@", self.MSG_PASSEDDATE] : nil;
    copy.MSG_FUTUREDATE = self.MSG_FUTUREDATE ? [NSString stringWithFormat:@"%@", self.MSG_FUTUREDATE] : nil;
    copy.MSG_INCOMPATIBLEVERSION = self.MSG_INCOMPATIBLEVERSION ? [NSString stringWithFormat:@"%@", self.MSG_INCOMPATIBLEVERSION] : nil;
    copy.MSG_UNANSWERABLE = self.MSG_UNANSWERABLE ? [NSString stringWithFormat:@"%@", self.MSG_UNANSWERABLE] : nil;
    copy.MSG_NOGROUPS = self.MSG_NOGROUPS ? [NSString stringWithFormat:@"%@", self.MSG_NOGROUPS] : nil;
    copy.MSG_INTERRUPTEDBYUSER = self.MSG_INTERRUPTEDBYUSER ? [NSString stringWithFormat:@"%@", self.MSG_INTERRUPTEDBYUSER] : nil;
    copy.MSG_WITHDRAWALBYUSER = self.MSG_WITHDRAWALBYUSER ? [NSString stringWithFormat:@"%@", self.MSG_WITHDRAWALBYUSER] : nil;
    copy.MSG_TIMEOUTEXIT = self.MSG_TIMEOUTEXIT ? [NSString stringWithFormat:@"%@", self.MSG_TIMEOUTEXIT] : nil;
    copy.MSG_TIMEOUTFINISH = self.MSG_TIMEOUTFINISH ? [NSString stringWithFormat:@"%@", self.MSG_TIMEOUTFINISH] : nil;
    copy.MSG_SUCCESSFINISH = self.MSG_SUCCESSFINISH ? [NSString stringWithFormat:@"%@", self.MSG_SUCCESSFINISH] : nil;
    //
    copy.MSG_INVALIDGROUP = self.MSG_INVALIDGROUP ? [NSString stringWithFormat:@"%@", self.MSG_INVALIDGROUP] : nil;
    copy.MSG_QUESTIONSERROR = self.MSG_QUESTIONSERROR ? [NSString stringWithFormat:@"%@", self.MSG_QUESTIONSERROR] : nil;
    copy.MSG_INCOMPLETESTAGE = self.MSG_INCOMPLETESTAGE ? [NSString stringWithFormat:@"%@", self.MSG_INCOMPLETESTAGE] : nil;
    //
    return copy;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:(self.MSG_INCOMPLETEQUESTIONS ? self.MSG_INCOMPLETEQUESTIONS : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INCOMPLETEQUESTIONS];
    [dicData setValue:(self.MSG_PASSEDDATE ? self.MSG_PASSEDDATE : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_PASSEDDATE];
    [dicData setValue:(self.MSG_FUTUREDATE ? self.MSG_FUTUREDATE : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_FUTUREDATE];
    [dicData setValue:(self.MSG_INCOMPATIBLEVERSION ? self.MSG_INCOMPATIBLEVERSION : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INCOMPATIBLEVERSION];
    [dicData setValue:(self.MSG_UNANSWERABLE ? self.MSG_UNANSWERABLE : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_UNANSWERABLE];
    [dicData setValue:(self.MSG_NOGROUPS ? self.MSG_NOGROUPS : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_NOGROUPS];
    [dicData setValue:(self.MSG_INTERRUPTEDBYUSER ? self.MSG_INTERRUPTEDBYUSER : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_INTERRUPTEDBYUSER];
    [dicData setValue:(self.MSG_WITHDRAWALBYUSER ? self.MSG_WITHDRAWALBYUSER : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_WITHDRAWALBYUSER];
    [dicData setValue:(self.MSG_TIMEOUTEXIT ? self.MSG_TIMEOUTEXIT : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_TIMEOUTEXIT];
    [dicData setValue:(self.MSG_TIMEOUTFINISH ? self.MSG_TIMEOUTFINISH : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_TIMEOUTFINISH];
    [dicData setValue:(self.MSG_SUCCESSFINISH ? self.MSG_SUCCESSFINISH : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_SURVEY_SUCCESSFINISH];
    //
    [dicData setValue:(self.MSG_INVALIDGROUP ? self.MSG_INVALIDGROUP : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_INVALID];
    [dicData setValue:(self.MSG_QUESTIONSERROR ? self.MSG_QUESTIONSERROR : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_QUESTIONSERROR];
    [dicData setValue:(self.MSG_INCOMPLETESTAGE ? self.MSG_INCOMPLETESTAGE : @"") forKey:CLASS_CUSTOMSURVEYSTRING_KEY_GROUP_INCOMPLETESTAGE];
    //
    return dicData;
}

@end
