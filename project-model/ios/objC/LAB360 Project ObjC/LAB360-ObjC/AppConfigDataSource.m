//
//  AppConfigDataSource.m
//  LAB360-ObjC
//
//  Created by Erico GT on 29/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AppConfigDataSource.h"
#import "InternetConnectionManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "ToolBox.h"
#import "AppDelegate.h"

@interface AppConfigDataSource()<DataSourceResponseProtocol>

@end

@implementation AppConfigDataSource

- (void)getSideMenuConfigurationFromServerWithCompletionHandler:(void (^_Nullable)(SideMenuConfig* _Nullable data, DataSourceResponse* _Nonnull response)) handler
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        //NSMutableDictionary *parameters = [NSMutableDictionary new];
        //
        NSString *urlString = [NSString stringWithFormat:@"%@%@", [icm serverPreference], SERVICE_URL_GET_SIDEMENU_CONFIG];
        NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"<APPID>" withString:[NSString stringWithFormat:@"%@", appID]];
        
        [icm getFrom:urlString body:nil completionHandler:^(id  _Nullable responseObject, NSInteger statusCode, NSError * _Nullable error) {
          
            if (error){
                NSLog(@"%@", [error localizedDescription]);
                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeConnectionError errorIdentifier:nil] error:DataSourceResponseErrorTypeConnectionError];
                handler(nil, response);
            }else{
                
                if (responseObject){
                    if ([responseObject isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicResponse = (NSDictionary *)responseObject;
                        
                        if ([[dicResponse allKeys] containsObject:@"app_menus"]) {
                            
                            SideMenuConfig *smConfig = [SideMenuConfig createObjectFromDictionary:[dicResponse valueForKey:@"app_menus"]];
                            
                            //validação de dados necessários:
                            BOOL completeData = YES;
                            BOOL hasHOME = NO;
                            BOOL hasEXIT = NO;
                            
                            if (smConfig.items.count == 0){
                                completeData = NO;
                            }
                            
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            for (SideMenuItem *item in smConfig.items){
                                
                                //item (nível 0)
                                item.showShortcut = [userDefaults boolForKey:[NSString stringWithFormat:@"SideMenuShortcutForItem%uUser%i", item.itemInternalCode, AppD.loggedUser.userID]];
                                
                                if (item.itemInternalCode == SideMenuItemCode_Exit){
                                    hasEXIT = YES;
                                }else if (item.itemInternalCode == SideMenuItemCode_Home){
                                    hasHOME = YES;
                                    item.showShortcut = NO;
                                }
                                
                                if (item.blocked){
                                    item.showShortcut = NO;
                                }
                                
                                //subItems (nível 1)
                                for (SideMenuItem *subItem in item.subItems){
                                    subItem.showShortcut = [userDefaults boolForKey:[NSString stringWithFormat:@"SideMenuShortcutForItem%uUser%i", subItem.itemInternalCode, AppD.loggedUser.userID]];
                                    
                                    if (subItem.itemInternalCode == SideMenuItemCode_Exit){
                                        hasEXIT = YES;
                                    }else if (item.itemInternalCode == SideMenuItemCode_Home){
                                        hasHOME = YES;
                                        subItem.showShortcut = NO;
                                    }
                                    
                                    if (subItem.blocked){
                                        subItem.showShortcut = NO;
                                    }
                                }
                                
                                    
                            }
                            
                            if (completeData && hasHOME && hasEXIT){
                                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                                handler(smConfig, response);
                            }else{
                                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                                handler(nil, response);
                            }
                            
                        }else{
                            DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                            handler(nil, response);
                        }
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

- (void)validateUserAuthenticationToken:(NSString* _Nonnull)token withCompletionHandler:(void (^_Nullable)(UserAuthenticationTokenStatus tokenStatus, DataSourceResponse* _Nonnull response)) handler
{
    //NOTE: enquanto o endpoint não estiver pronto o retorno é sempre sucesso
    DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
    handler(UserAuthenticationTokenStatusValid, response);
    
    //TODO:
    
    /*
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        //TODO:
        //NSString *urlString = [NSString stringWithFormat:@"%@%@", [icm serverPreference], SERVICE_URL_GET_SHOWROOMS];
        NSString *urlString = @"http://demo9255978.mockable.io/lab360/validation/token";
        
        [icm getFrom:urlString body:nil completionHandler:^(id  _Nullable responseObject, NSInteger statusCode, NSError * _Nullable error) {
            
            if (error){
                NSLog(@"%@", [error localizedDescription]);
                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeConnectionError errorIdentifier:nil] error:DataSourceResponseErrorTypeConnectionError];
                handler(UserAuthenticationTokenStatusUndefined, response);
            }else{
                
                if (responseObject){
                    if ([responseObject isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicResponse = (NSDictionary *)responseObject;
                        
                        if ([[dicResponse allKeys] containsObject:@"status"]) {
                            
                            NSString *status = [dicResponse valueForKey:@"status"];
                            
                            if ([status isEqualToString:@"SUCCESS"]){
                                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                                handler(UserAuthenticationTokenStatusValid, response);
                            }else{
                                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                                handler(UserAuthenticationTokenStatusInvalid, response);
                            }
                            
                        }else{
                            DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                            handler(UserAuthenticationTokenStatusUndefined, response);
                        }
                    }else{
                        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                        handler(UserAuthenticationTokenStatusUndefined, response);
                    }
                }else{
                    DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeInvalidData errorIdentifier:nil] error:DataSourceResponseErrorTypeInvalidData];
                    handler(UserAuthenticationTokenStatusUndefined, response);
                }
            }
            
        }];
        
    }else{
        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNoConnection errorIdentifier:nil] error:DataSourceResponseErrorTypeNoConnection];
        handler(UserAuthenticationTokenStatusUndefined, response);
    }
    */
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
