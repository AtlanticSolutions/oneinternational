//
//  QuestionnaireDataSource.h
//  LAB360-ObjC
//
//  Created by Erico GT on 20/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceResponse.h"
#import "DataSourceRequest.h"
#import "CustomSurvey.h"

@interface QuestionnaireDataSource : NSObject

/** Busca os questionário disponíveis no servidor. */
- (DataSourceRequest*)getAvailableQuestionnairesFromServerWithCompletionHandler:(void (^_Nullable)(NSArray<CustomSurvey*>* _Nullable questionnaries, DataSourceResponse* _Nonnull response)) handler;

/** Envia o questionário respondido para o servidor. */
- (DataSourceRequest*)postQuestionnaireToServer:(NSDictionary* _Nonnull)questionnaireDic withCompletionHandler:(void (^_Nullable)(DataSourceResponse* _Nonnull response)) handler;

@end
