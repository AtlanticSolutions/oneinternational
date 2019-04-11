//
//  ExampleDataSource.m
//  LAB360-ObjC
//
//  Created by Erico GT on 23/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "ExampleDataSource.h"
#import "InternetConnectionManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "ToolBox.h"

@interface ExampleDataSource()<DataSourceResponseProtocol>

@end

@implementation ExampleDataSource

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        //
//    }
//    return self;
//}

- (void)authenticateUserUsingEmail:(NSString* _Nonnull)userEmail password:(NSString*)userPassword withCompletionHandler:(void (^_Nullable)(NSDictionary* _Nullable data, DataSourceResponse* _Nonnull response)) handler
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:userEmail forKey:@"email"];
        [parameters setValue:userPassword forKey:@"password"];
        //
        NSString *urlString = [NSString stringWithFormat:@"%@%@", [icm serverPreference], SERVICE_URL_AUTHENTICATE_STORE];
        
        [icm postTo:urlString body:parameters completionHandler:^(id  _Nullable responseObject, NSInteger statusCode, NSError * _Nullable error) {
            
            if (error){
                NSLog(@"%@", [error localizedDescription]);
                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeConnectionError errorIdentifier:nil] error:DataSourceResponseErrorTypeConnectionError];
                handler(nil, response);
            }else{
                
                if (responseObject){
                    if ([responseObject isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicUser = (NSDictionary *)responseObject;
                        [[NSUserDefaults standardUserDefaults] setValue:[dicUser objectForKey:AUTHENTICATE_ACCESS_TOKEN] forKey:PLISTKEY_ACCESS_TOKEN];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        //
                        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                        handler(dicUser, response);
                    }else{
                        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                        handler(nil, response);
                    }
                }else{
                    DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                    handler(nil, response);
                }
            }
            
        }];
        
    }else{
        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNoConnection errorIdentifier:nil] error:DataSourceResponseErrorTypeNoConnection];
        handler(nil, response);
    }
}

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
