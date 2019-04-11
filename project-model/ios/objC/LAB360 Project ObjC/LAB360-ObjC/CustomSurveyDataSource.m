//
//  CustomSurveyDataSource.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyDataSource.h"
#import "InternetConnectionManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "ToolBox.h"

@implementation CustomSurveyDataSource

- (void)getCustomSurveyFromMockableioWithCompletionHandler:(void (^_Nullable)(CustomSurvey* _Nullable survey, DataSourceResponse* _Nonnull response)) handler
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        NSString *urlString = @"http://demo9255978.mockable.io/survey/example";
        
        [icm getFrom:urlString body:nil completionHandler:^(id  _Nullable responseObject, NSInteger statusCode, NSError * _Nullable error) {
            
            if (error){
                NSLog(@"%@", [error localizedDescription]);
                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeConnectionError errorIdentifier:nil] error:DataSourceResponseErrorTypeConnectionError];
                handler(nil, response);
            }else{
                
                if (responseObject){
                    if ([responseObject isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicResponse = (NSDictionary *)responseObject;
                        
                        if ([[dicResponse allKeys] containsObject:@"custom_survey"]) {
                            
                            CustomSurvey *survey = [CustomSurvey createObjectFromDictionary:[dicResponse valueForKey:@"custom_survey"]];
                            
                            DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:statusCode message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                            handler(survey, response);
                            
                        }else if ([[dicResponse allKeys] containsObject:@"message"]) {
                            NSString *message = [dicResponse valueForKey:@"message"];
                            DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:statusCode message:message error:DataSourceResponseErrorTypeInvalidData];
                            handler(nil, response);
                        }else{
                            DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:statusCode message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                            handler(nil, response);
                        }
                    }else{
                        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:statusCode message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                        handler(nil, response);
                    }
                }else{
                    DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:statusCode message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                    handler(nil, response);
                }
            }
            
        }];
        
    }else{
        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNoConnection errorIdentifier:nil] error:DataSourceResponseErrorTypeNoConnection];
        handler(nil, response);
    }
}

- (void)getCustomSurveyFromS3ForSample:(long)sampleID withCompletionHandler:(void (^_Nullable)(CustomSurvey* _Nullable survey, DataSourceResponse* _Nonnull response)) handler
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        NSString *urlString = @"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/customsurvey/custom_survey_file_<SAMPLEID>.json";
        urlString = [urlString stringByReplacingOccurrencesOfString:@"<SAMPLEID>" withString:[NSString stringWithFormat:@"%li", sampleID]];
        
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:urlString]];
        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"Custom Survey: %@", json);
        
        if (error == nil){
            if ([json isKindOfClass:[NSDictionary class]]){
                NSDictionary *dicResponse = (NSDictionary *)json;
                
                if ([[dicResponse allKeys] containsObject:@"custom_survey"]) {
                    
                    CustomSurvey *survey = [CustomSurvey createObjectFromDictionary:[dicResponse valueForKey:@"custom_survey"]];
                    
                    DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                    handler(survey, response);
                    
                }else{
                    DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                    handler(nil, response);
                }
            }else{
                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                handler(nil, response);
            }
        }else{
            DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[error localizedDescription] error:DataSourceResponseErrorTypeInvalidData];
            handler(nil, response);
        }
        
    }else{
        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNoConnection errorIdentifier:nil] error:DataSourceResponseErrorTypeNoConnection];
        handler(nil, response);
    }
}

#pragma mark - DELEGATE

- (NSString*_Nonnull)errorMessageForType:(DataSourceResponseErrorType)type errorIdentifier:(NSString*_Nullable)identifier
{
    switch (type) {
            
            //Quando a operação não encontrou erro algum.
        case DataSourceResponseErrorTypeNone:{
            return @"Dados recuperados com sucesso!";
        }break;
            
            //Os dados precisam de internet para serem resgatados mas não há conexão disponível.
        case DataSourceResponseErrorTypeNoConnection:{
            return @"Ops...\n\nParece que não há nenhuma conexão disponível no momento.\n\nVerifique sua internet e tente novamente!";
        }break;
            
            //Ocorreu um erro na conexão que impede o resgate dos dados.
        case DataSourceResponseErrorTypeConnectionError:{
            return @"Um problema na conexão impede que os dados sejam carregados no momento. Por favor, tente mais tarde.";
        }break;
            
            //Os dados encontrados não correspondem aos esperados (por tipo, qtd, formato, etc).
        case DataSourceResponseErrorTypeInvalidData:{
            return @"Nenhum dado válido foi encontrado!";
        }break;
            
            //Ocorreu um erro interno no processamento dos dados (parse por exemplo). Por padrão o 'identifier' já deve ser a descrição da exceção.
        case DataSourceResponseErrorTypeInternalException:{
            return (identifier == nil ? @"Erro desconhecido!" : identifier);
        }break;
            
            //Erro genérico, não categorizado.
        case DataSourceResponseErrorTypeGeneric:{
            return @"Não foi possível carregar os dados no momento. Por favor, tente mais tarde.";
        }break;
    }
}

@end
