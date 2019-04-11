//
//  CustomSurvey.m
//  LAB360-ObjC
//
//  Created by Erico GT on 08/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurvey.h"

#define ADALIVE_CUSTOMSURVEY_START_TIME @"adalive_customsurvey_starttime_"
//
#define CLASS_CUSTOMSURVEY_DEFAULT @"custom_survey"
#define CLASS_CUSTOMSURVEY_KEY_ID @"id"
#define CLASS_CUSTOMSURVEY_KEY_NAME @"name"
#define CLASS_CUSTOMSURVEY_KEY_PRESENTATION @"presentation"
#define CLASS_CUSTOMSURVEY_KEY_URLBANNER @"url_banner"
#define CLASS_CUSTOMSURVEY_KEY_LINK @"link"
#define CLASS_CUSTOMSURVEY_KEY_LINKMESSAGE @"link_message"
#define CLASS_CUSTOMSURVEY_KEY_GROUPS @"groups"
#define CLASS_CUSTOMSURVEY_KEY_SECONDSTOFINISH @"seconds_to_finish"
#define CLASS_CUSTOMSURVEY_KEY_ACCEPTSINTERRUPTION @"accepts_interruption"
#define CLASS_CUSTOMSURVEY_KEY_FORMTYPE @"form_type"
#define CLASS_CUSTOMSURVEY_KEY_CONSUMPTIONTYPE @"consumption_type"
#define CLASS_CUSTOMSURVEY_KEY_SHAREABLECODE @"shareable_code"
#define CLASS_CUSTOMSURVEY_KEY_REQUIREDMEDIA @"required_media"
#define CLASS_CUSTOMSURVEY_KEY_ICR @"intermediate_check_requirement"
#define CLASS_CUSTOMSURVEY_KEY_STARTDATE @"available_from_date"
#define CLASS_CUSTOMSURVEY_KEY_ENDDATE @"valid_until_date"
#define CLASS_CUSTOMSURVEY_KEY_VERSION @"version"
#define CLASS_CUSTOMSURVEY_KEY_STRSET @"string_set"
//#define CLASS_CUSTOMSURVEY_KEY_

@interface CustomSurvey()

@property(nonatomic, strong) NSDate *startDate;

@end

@implementation CustomSurvey

@synthesize surveyID, name, presentation, urlBanner, link, linkMessage, groups, secondsToFinish, acceptsInterruption, bannerImage, formType, consumptionType, shareableCode, startDate, finishedTime, requiredMedia, intermediateCheckRequirement, availableFromDate, validUntilDate, version, STR;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        surveyID = 0;
        name = @"";
        presentation = @"";
        urlBanner = @"";
        link = @"";
        linkMessage = @"";
        groups = [NSMutableArray new];
        secondsToFinish = 0;
        acceptsInterruption = YES;
        bannerImage = nil;
        formType = SurveyFormTypeFullPage;
        consumptionType = SurveyConsumptionTypeUnique;
        shareableCode = nil;
        finishedTime = NO;
        requiredMedia = NO;
        intermediateCheckRequirement = NO;
        availableFromDate = nil;
        validUntilDate = nil;
        version = nil;
        STR = [CustomSurveyStrings newObject];
    }
    return self;
}

#pragma mark - Methods

- (BOOL)startSurvey
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *startKeyComplete = [NSString stringWithFormat:@"%@%li", ADALIVE_CUSTOMSURVEY_START_TIME, self.surveyID];

    NSDate *startTime = [ud valueForKey:startKeyComplete];
    
    if (startTime == nil){
        //O survey pode iniciar
        startDate = [NSDate date];
        [ud setValue:startDate forKey:startKeyComplete];
        return [ud synchronize];
    }else{
        //O survey já foi iniciado
        startDate = startTime;
        return YES;
    }
}

- (BOOL)finishSurvey
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *startKeyComplete = [NSString stringWithFormat:@"%@%li", ADALIVE_CUSTOMSURVEY_START_TIME, self.surveyID];
    
    startDate = nil;
    finishedTime = NO;
    
    [ud removeObjectForKey:startKeyComplete];
    return [ud synchronize];
}

- (NSString*)remainingTime
{
    if (secondsToFinish > 0){
        if (startDate){
            NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:startDate];
            long secondsRemaining = secondsToFinish - ((long)secondsBetween);
            
            if (secondsRemaining < 0){
                finishedTime = YES;
                return @"ESGOTADO";
            }else{
                 int seconds = (int) (secondsRemaining % 60);
                 int minutes = (int) ((secondsRemaining / 60) % 60);
                 int hours = (int) (secondsRemaining / 3600);
                 NSString *t = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
                 //
                 return t;
            }
            
        }else{
            return @"-";
        }
    }else{
        return @"-";
    }  
}

- (NSString*)surveyCompletion
{
    long total = 0;
    long answered = 0;
    
    for (CustomSurveyGroup *group in self.groups){
        for (CustomSurveyQuestion *question in group.questions){
            if (question.type != SurveyQuestionTypeUnanswerable){
                total += 1;
                if (question.userAnswers.count > 0){
                    answered += 1;
                }
            }
        }
    }
    
    NSString *completed = [NSString stringWithFormat:@"%li/%li", answered, total];
    return completed;
}

- (NSString*)calculateTimeToSurvey
{
    if (self.secondsToFinish > 0){
        int seconds = (int) (self.secondsToFinish % 60);
        int minutes = (int) ((self.secondsToFinish / 60) % 60);
        int hours = (int) (self.secondsToFinish / 3600);
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }else{
        return @"";
    }
}

- (BOOL)isRunning
{
    return startDate != nil;
}

- (NSString*)validateSurveyToActualCompletionData
{
    for (CustomSurveyGroup *group in self.groups){
        for (CustomSurveyQuestion *question in group.questions){
            if (question.required && (question.type != SurveyQuestionTypeUnanswerable) && question.activeForUser){
                if (question.userAnswers.count == 0){
                    return STR.MSG_INCOMPLETEQUESTIONS;
                }
            }
        }
    }  
    
    return nil;
}

-(NSString*)validateSurveyBeforeStart
{
    //Data início:
    if ([ToolBox textHelper_CheckRelevantContentInString:self.availableFromDate]){
        NSDate *d1 = [NSDate date];
        NSDate *d2 = [ToolBox dateHelper_DateFromString:self.availableFromDate withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA];
        if ([ToolBox dateHelper_CompareDate:d1 withDate:d2 usingRule:tbComparationRule_Less]){
            if ([STR.MSG_FUTUREDATE rangeOfString:@"<DATE>"].location == NSNotFound) {
                return STR.MSG_FUTUREDATE;
            }else{
                NSString *dateSTR = [STR.MSG_FUTUREDATE stringByReplacingOccurrencesOfString:@"<DATE>" withString:[ToolBox dateHelper_StringFromDate:d2 withFormat:TOOLBOX_DATA_BARRA_LONGA_NORMAL]];
                return dateSTR;
            }
        }
    }
    
    
    //Data término:
    if ([ToolBox textHelper_CheckRelevantContentInString:self.validUntilDate]){
        NSDate *d1 = [NSDate date];
        NSDate *d2 = [ToolBox dateHelper_DateFromString:self.validUntilDate withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA];
        if ([ToolBox dateHelper_CompareDate:d1 withDate:d2 usingRule:tbComparationRule_Greater]){
            if ([STR.MSG_PASSEDDATE rangeOfString:@"<DATE>"].location == NSNotFound) {
                return STR.MSG_PASSEDDATE;
            }else{
                NSString *dateSTR = [STR.MSG_PASSEDDATE stringByReplacingOccurrencesOfString:@"<DATE>" withString:[ToolBox dateHelper_StringFromDate:d2 withFormat:TOOLBOX_DATA_BARRA_LONGA_NORMAL]];
                return dateSTR;
            }
        }
    }
    
    //Versão:
    if (![self checkLocalVersusRemoteVersion]){
        return STR.MSG_INCOMPATIBLEVERSION;
    }else{
        //Status:
        if (self.formType == SurveyFormTypeUnanswerable){
            return STR.MSG_UNANSWERABLE;
        }else{
            //Qtd de grupos:
            if (self.groups.count == 0){
                return STR.MSG_NOGROUPS;
            }else{
                for (CustomSurveyGroup *group in self.groups){
                    //Qtd de questões:
                    if (group.questions.count == 0){
                        return STR.MSG_INVALIDGROUP;
                    }else{
                        BOOL validQuestion = NO;
                        for (CustomSurveyQuestion *question in group.questions){
                            //Pelo menos uma questão respondível no grupo:
                            if (question.type != SurveyQuestionTypeUnanswerable){
                                validQuestion = YES;
                                break;
                            }else{
                                if (question.required){
                                    break;
                                }
                            }

                        }
                        if (!validQuestion){
                            return STR.MSG_QUESTIONSERROR;
                        }
                    }
                }
            }
        }
    }
    
    return nil;
}

- (BOOL)checkValidUntilDate
{
    if ([ToolBox textHelper_CheckRelevantContentInString:self.validUntilDate]){
        
        NSDate *d1 = [NSDate date];
        NSDate *d2 = [ToolBox dateHelper_DateFromString:self.validUntilDate withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA];
        
        if ([ToolBox dateHelper_CompareDate:d1 withDate:d2 usingRule:tbComparationRule_LessOrEqual]){
            return YES;
        }else{
            return NO;
        }
        
    }else{
        //Se não possui data término determinada pode continuar
        return YES;
    }
}

- (BOOL)checkLocalVersusRemoteVersion
{
    if ([ToolBox textHelper_CheckRelevantContentInString:self.version]){
        
        NSArray *localVersion = [QUESTIONNAIRE_CURRENT_VERSION componentsSeparatedByString:@"."];
        NSArray *remoteVersion = [self.version componentsSeparatedByString:@"."];
        
        long localMajorVersion = [[localVersion firstObject] integerValue];
        long localMinorVersion = [[localVersion lastObject] integerValue];
        
        long remoteMajorVersion = [[remoteVersion firstObject] integerValue];
        long remoteMinorVersion = 0;
        if (remoteVersion.count > 1){
            remoteMinorVersion = [[remoteVersion objectAtIndex:1] integerValue];
        }
                                  
        //Verificação:
        if (localMajorVersion < remoteMajorVersion){
            return NO;
        }else{
            if (localMinorVersion < remoteMinorVersion){
                return NO;
            }
        }
        return YES;
        
    }else{
        
        //Se o questionário não possui versão, ele deve ser um modelo anterior ao versionamento.
        return YES;
    }
}

#pragma mark - Support Data Methods
+ (CustomSurvey*)newObject
{
    CustomSurvey *cs = [CustomSurvey new];
    return cs;
}

+ (CustomSurvey*)createObjectFromDictionary:(NSDictionary*)dicData
{
    CustomSurvey *cs = [CustomSurvey new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        //surveyID
        cs.surveyID = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_ID] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_ID] longValue] : cs.surveyID;
        
        //name
        cs.name = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_NAME]] : cs.name;
        
        //presentation
        cs.presentation = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_PRESENTATION] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_PRESENTATION]] : cs.presentation;
        
        //urlBanner
        cs.urlBanner = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_URLBANNER] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_URLBANNER]] : cs.urlBanner;
        
        //link
        cs.link = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_LINK] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_LINK]] : cs.link;
        
        //linkMessage
        cs.linkMessage = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_LINKMESSAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_LINKMESSAGE]] : cs.linkMessage;
        
        //groups
        cs.groups = [NSMutableArray new];
        if ([keysList containsObject:CLASS_CUSTOMSURVEY_KEY_GROUPS]){
            if ([[neoDic objectForKey:CLASS_CUSTOMSURVEY_KEY_GROUPS] isKindOfClass:[NSArray class]]){
                NSArray *a = [neoDic objectForKey:CLASS_CUSTOMSURVEY_KEY_GROUPS];
                for (NSDictionary *dic in a){
                    [cs.groups addObject:[CustomSurveyGroup createObjectFromDictionary:dic]];
                }
            }
            //order:
            if (cs.groups.count > 0){
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                cs.groups = [[NSMutableArray alloc] initWithArray:[cs.groups sortedArrayUsingDescriptors:sortDescriptors]];
            }
        }
        
        //secondsToFinish
        cs.secondsToFinish = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_SECONDSTOFINISH] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_SECONDSTOFINISH] longValue] : cs.secondsToFinish;
        
        //acceptsInterruption
        cs.acceptsInterruption = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_ACCEPTSINTERRUPTION] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_ACCEPTSINTERRUPTION] boolValue] : cs.acceptsInterruption;
        
        //formType
        cs.formType = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_FORMTYPE] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_FORMTYPE] intValue] : cs.formType;
        
        //consumptionType
        cs.consumptionType = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_CONSUMPTIONTYPE] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_CONSUMPTIONTYPE] intValue] : cs.consumptionType;
        
        //shareableCode
        cs.shareableCode = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_SHAREABLECODE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_SHAREABLECODE]] : cs.shareableCode;
        
        //requiredMedia
        cs.requiredMedia = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_REQUIREDMEDIA] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_REQUIREDMEDIA] boolValue] : cs.requiredMedia;
        
        //intermediateCheckRequirement
        cs.intermediateCheckRequirement = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_ICR] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_ICR] boolValue] : cs.intermediateCheckRequirement;
        
        //availableFromDate
        cs.availableFromDate = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_STARTDATE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_STARTDATE]] : cs.availableFromDate;
        
        //validUntilDate
        cs.validUntilDate = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_ENDDATE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_ENDDATE]] : cs.validUntilDate;
    
        //version
        cs.version = [keysList containsObject:CLASS_CUSTOMSURVEY_KEY_VERSION] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_VERSION]] : cs.version;
        
        //msg_config
        if ([keysList containsObject:CLASS_CUSTOMSURVEY_KEY_STRSET]){
            id dicSTR = [neoDic  valueForKey:CLASS_CUSTOMSURVEY_KEY_STRSET];
            if ([dicSTR isKindOfClass:[NSDictionary class]]){
                CustomSurveyStrings *str = [CustomSurveyStrings createObjectFromDictionary:(NSDictionary*)dicSTR];
                cs.STR = str;
            }
        }
        
        //bannerImage
        //carregado depois...
    }
    
    return cs;
}

- (CustomSurvey*)copyObject
{
    CustomSurvey *copy = [CustomSurvey new];
    
    
    copy.surveyID = self.surveyID;
    copy.name = self.name ? [NSString stringWithFormat:@"%@", self.name] : nil;
    copy.presentation = self.presentation ? [NSString stringWithFormat:@"%@", self.presentation] : nil;
    copy.urlBanner = self.urlBanner ? [NSString stringWithFormat:@"%@", self.urlBanner] : nil;
    copy.link = self.link ? [NSString stringWithFormat:@"%@", self.link] : nil;
    copy.linkMessage = self.linkMessage ? [NSString stringWithFormat:@"%@", self.linkMessage] : nil;
    //
    if (self.groups != nil){
        for (CustomSurveyGroup *group in self.groups){
            [copy.groups addObject:[group copyObject]];
        }
    }else{
        copy.groups = nil;
    }
    //
    copy.secondsToFinish = self.secondsToFinish;
    copy.acceptsInterruption = self.acceptsInterruption;
    copy.formType = self.formType;
    copy.consumptionType = self.consumptionType;
    copy.shareableCode = self.shareableCode ? [NSString stringWithFormat:@"%@", self.shareableCode] : nil;
    copy.bannerImage = self.bannerImage ? [UIImage imageWithData:UIImagePNGRepresentation(self.bannerImage)] : nil;
    copy.finishedTime = self.finishedTime;
    copy.requiredMedia = self.requiredMedia;
    copy.intermediateCheckRequirement = self.intermediateCheckRequirement;
    copy.availableFromDate = self.availableFromDate ? [NSString stringWithFormat:@"%@", self.availableFromDate] : nil;
    copy.validUntilDate = self.validUntilDate ? [NSString stringWithFormat:@"%@", self.validUntilDate] : nil;
    copy.version = self.version ? [NSString stringWithFormat:@"%@", self.version] : nil;
    copy.STR = self.STR ? [self.STR copyObject] : nil;
    
    return copy;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.surveyID) forKey:CLASS_CUSTOMSURVEY_KEY_ID];
    [dicData setValue:(self.name ? self.name : @"") forKey:CLASS_CUSTOMSURVEY_KEY_NAME];
    [dicData setValue:(self.presentation ? self.presentation : @"") forKey:CLASS_CUSTOMSURVEY_KEY_PRESENTATION];
    [dicData setValue:(self.urlBanner ? self.urlBanner : @"") forKey:CLASS_CUSTOMSURVEY_KEY_URLBANNER];
    [dicData setValue:(self.link ? self.link : @"") forKey:CLASS_CUSTOMSURVEY_KEY_LINK];
    [dicData setValue:(self.linkMessage ? self.linkMessage : @"") forKey:CLASS_CUSTOMSURVEY_KEY_LINKMESSAGE];
    //
    if (self.groups != nil){
        NSMutableArray *list = [NSMutableArray new];
        for (CustomSurveyGroup *group in self.groups){
            [list addObject:[group dictionaryJSON]];
        }
        [dicData setValue:list forKey:CLASS_CUSTOMSURVEY_KEY_GROUPS];
    }else{
        [dicData setValue:[NSArray new] forKey:CLASS_CUSTOMSURVEY_KEY_GROUPS];
    }
    //
    [dicData setValue:@(self.secondsToFinish) forKey:CLASS_CUSTOMSURVEY_KEY_SECONDSTOFINISH];
    [dicData setValue:@(self.acceptsInterruption) forKey:CLASS_CUSTOMSURVEY_KEY_ACCEPTSINTERRUPTION];
    //
    [dicData setValue:@(self.formType) forKey:CLASS_CUSTOMSURVEY_KEY_FORMTYPE];
    [dicData setValue:@(self.consumptionType) forKey:CLASS_CUSTOMSURVEY_KEY_CONSUMPTIONTYPE];
    [dicData setValue:(self.shareableCode ? self.shareableCode : @"") forKey:CLASS_CUSTOMSURVEY_KEY_SHAREABLECODE];
    [dicData setValue:@(self.requiredMedia) forKey:CLASS_CUSTOMSURVEY_KEY_REQUIREDMEDIA];
    [dicData setValue:@(self.intermediateCheckRequirement) forKey:CLASS_CUSTOMSURVEY_KEY_ICR];
    [dicData setValue:(self.availableFromDate ? self.availableFromDate : @"") forKey:CLASS_CUSTOMSURVEY_KEY_STARTDATE];
    [dicData setValue:(self.validUntilDate ? self.validUntilDate : @"") forKey:CLASS_CUSTOMSURVEY_KEY_ENDDATE];
    [dicData setValue:(self.version ? self.version : @"") forKey:CLASS_CUSTOMSURVEY_KEY_VERSION];
    [dicData setValue:(self.STR ? [self.STR dictionaryJSON] : [NSDictionary new]) forKey:CLASS_CUSTOMSURVEY_KEY_STRSET];
    //
    return dicData;
}

- (NSDictionary*)reducedJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.surveyID) forKey:CLASS_CUSTOMSURVEY_KEY_ID];
    if (self.groups != nil){
        NSMutableArray *list = [NSMutableArray new];
        for (CustomSurveyGroup *group in self.groups){
            [list addObject:[group reducedJSON]];
        }
        [dicData setValue:list forKey:CLASS_CUSTOMSURVEY_KEY_GROUPS];
    }
    //
    return dicData;
}

#pragma mark -

- (NSString*)formTypeStringFor:(SurveyFormType)type
{
    switch (type) {
        case SurveyFormTypeUnanswerable:{ return @""; }break;
        case SurveyFormTypeFullPage:{ return @"fullpage"; }break;
        case SurveyFormTypeGroups:{ return @"groups"; }break;
        case SurveyFormTypeStages:{ return @"stages"; }break;
    }
}

- (SurveyFormType)formTypeEnumFor:(NSString*)string
{
    if ([[string lowercaseString] isEqualToString:@"fullpage"]){
        return SurveyFormTypeFullPage;
    }
    
    if ([[string lowercaseString] isEqualToString:@"groups"]){
        return SurveyFormTypeGroups;
    }
    
    if ([[string lowercaseString] isEqualToString:@"stages"]){
        return SurveyFormTypeStages;
    }
    
    return SurveyFormTypeUnanswerable;
}

@end
