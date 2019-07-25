//
//  CustomSurvey.h
//  LAB360-ObjC
//
//  Created by Erico GT on 08/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"
#import "CustomSurveyGroup.h"
#import "CustomSurveyStrings.h"

#define QUESTIONNAIRE_CURRENT_VERSION @"3.0"

@interface CustomSurvey : NSObject<DefaultObjectModelProtocol>

typedef enum {
    SurveyFormTypeUnanswerable    = 0,
    SurveyFormTypeFullPage        = 1,
    SurveyFormTypeGroups          = 2,
    SurveyFormTypeStages          = 3
} SurveyFormType;

typedef enum {
    SurveyConsumptionTypeUnique                 = 1,
    SurveyConsumptionTypeMultipleKeepFirst      = 2,
    SurveyConsumptionTypeMultipleKeepLast       = 3,
    SurveyConsumptionTypeMultipleKeepAll        = 4,
    SurveyConsumptionTypeDisposable             = 5
} SurveyConsumptionType;

#pragma mark - Properties
@property (nonatomic, assign) long surveyID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *presentation;
@property (nonatomic, strong) NSString *urlBanner;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *linkMessage;
@property (nonatomic, strong) NSMutableArray<CustomSurveyGroup*> *groups;
@property (nonatomic, assign) long secondsToFinish;
@property (nonatomic, assign) BOOL acceptsInterruption;
@property (nonatomic, assign) SurveyFormType formType;
@property (nonatomic, assign) SurveyConsumptionType consumptionType;
@property (nonatomic, strong) NSString *shareableCode;
@property (nonatomic, assign) BOOL requiredMedia;
@property (nonatomic, assign) BOOL intermediateCheckRequirement;

@property (nonatomic, strong) NSString *availableFromDate;
@property (nonatomic, strong) NSString *validUntilDate;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) CustomSurveyStrings *STR;
//
@property (nonatomic, strong) UIImage *bannerImage;
@property (nonatomic, assign) BOOL finishedTime;

#pragma mark - Methods

/* Registra no userDefualts o início do survey e começa a contar o tempo para respondê-lo, quando existir. */
- (BOOL)startSurvey;

/* Remove do userDefaults todos os dados referentes ao survey. Atenção, sem este registro o survey pode ser reiniciado. */
- (BOOL)finishSurvey;

/* Quando houver tempo máximo estipulado, retorna o tempo restante formatado. */
- (NSString*)remainingTime;

/* Total respondido da pesquisa. */
- (NSString*)surveyCompletion;

/* Total de tempo dado pela pesquisa, já formatado. */
- (NSString*)calculateTimeToSurvey;

/* Verifica se a pesquisa já foi iniciada pelo usuário. */
- (BOOL)isRunning;

/* Analisa as validade das respostas fornecidas, incluindo preenchimento das requeridas. */
- (NSString*)validateSurveyToActualCompletionData;

/* Analisa as parâmetros do questionário em relação ao seu conteúdo. */
- (NSString*)validateSurveyBeforeStart;

#pragma mark - Support Data Methods
+ (CustomSurvey*)newObject;
+ (CustomSurvey*)createObjectFromDictionary:(NSDictionary*)dicData;
- (CustomSurvey*)copyObject;
- (NSDictionary*)dictionaryJSON;
- (NSDictionary*)reducedJSON;

@end
