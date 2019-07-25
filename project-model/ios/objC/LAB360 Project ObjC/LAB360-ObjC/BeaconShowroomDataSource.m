//
//  BeaconShowroomDataSource.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "BeaconShowroomDataSource.h"
#import "InternetConnectionManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "ToolBox.h"

@interface BeaconShowroomDataSource()<DataSourceResponseProtocol>

@end

@implementation BeaconShowroomDataSource

- (void)getShowroomsFromServerWithCompletionHandler:(void (^_Nullable)(NSMutableArray<BeaconShowroomItem*>* _Nullable data, DataSourceResponse* _Nonnull response)) handler
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        //NSMutableDictionary *parameters = [NSMutableDictionary new];
        //
        NSString *urlString = [NSString stringWithFormat:@"%@%@", [icm serverPreference], SERVICE_URL_GET_SHOWROOMS];
        //NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
        //urlString = [urlString stringByReplacingOccurrencesOfString:@"<APPID>" withString:[NSString stringWithFormat:@"%@", appID]];
        
        [icm getFrom:urlString body:nil completionHandler:^(id  _Nullable responseObject, NSInteger statusCode, NSError * _Nullable error) {
            
            if (error){
                NSLog(@"%@", [error localizedDescription]);
                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeConnectionError errorIdentifier:nil] error:DataSourceResponseErrorTypeConnectionError];
                handler(nil, response);
            }else{
                
                if (responseObject){
                    if ([responseObject isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicResponse = (NSDictionary *)responseObject;
                        
                        if ([[dicResponse allKeys] containsObject:@"showrooms"]) {
                            
                            NSArray *list = [[NSArray alloc] initWithArray:[dicResponse objectForKey:@"showrooms"]];
                            
                            NSMutableArray *showroomsList = [NSMutableArray new];
                            
                            for (NSDictionary *dic in list){
                                [showroomsList addObject:[BeaconShowroomItem createObjectFromDictionary:dic]];
                            }
                            
                            if (showroomsList.count > 0){
                                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
                                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                showroomsList = [[NSMutableArray alloc] initWithArray:[showroomsList sortedArrayUsingDescriptors:sortDescriptors]];
                            }
                            
                            DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                            handler(showroomsList, response);
                            
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

- (void)getShelfsForShowroom:(long)showroomID withCompletionHandler:(void (^_Nullable)(NSMutableArray<BeaconShowroomItem*>* _Nullable data, DataSourceResponse* _Nonnull response)) handler
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        //NSMutableDictionary *parameters = [NSMutableDictionary new];
        //
        NSString *urlString = [NSString stringWithFormat:@"%@%@", [icm serverPreference], SERVICE_URL_GET_SHELFS];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"<SHOWROOMID>" withString:[NSString stringWithFormat:@"%li", showroomID]];
        
        [icm getFrom:urlString body:nil completionHandler:^(id  _Nullable responseObject, NSInteger statusCode, NSError * _Nullable error) {
            
            if (error){
                NSLog(@"%@", [error localizedDescription]);
                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeConnectionError errorIdentifier:nil] error:DataSourceResponseErrorTypeConnectionError];
                handler(nil, response);
            }else{
                
                if (responseObject){
                    if ([responseObject isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicResponse = (NSDictionary *)responseObject;
                        
                        if ([[dicResponse allKeys] containsObject:@"shelves"]) {
                            
                            NSArray *list = [[NSArray alloc] initWithArray:[dicResponse objectForKey:@"shelves"]];
                            
                            NSMutableArray *showroomsList = [NSMutableArray new];
                            
                            for (NSDictionary *dic in list){
                                [showroomsList addObject:[BeaconShowroomItem createObjectFromDictionary:dic]];
                            }
                            
                            if (showroomsList.count > 0){
                                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
                                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                showroomsList = [[NSMutableArray alloc] initWithArray:[showroomsList sortedArrayUsingDescriptors:sortDescriptors]];
                            }
                            
                            DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                            handler(showroomsList, response);
                            
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

- (void)getBeaconsForShowroom:(long)showroomID shelf:(long)shelfID withCompletionHandler:(void (^_Nullable)(NSMutableArray<LaBeacon*>* _Nullable data, DataSourceResponse* _Nonnull response)) handler
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        //NSMutableDictionary *parameters = [NSMutableDictionary new];
        //
        NSString *urlString = [NSString stringWithFormat:@"%@%@", [icm serverPreference], SERVICE_URL_GET_BEACONS_SHOWROOM_SHELF];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"<SHOWROOMID>" withString:[NSString stringWithFormat:@"%li", showroomID]];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"<SHELFID>" withString:[NSString stringWithFormat:@"%li", shelfID]];
        
        [icm getFrom:urlString body:nil completionHandler:^(id  _Nullable responseObject, NSInteger statusCode, NSError * _Nullable error) {
            
            if (error){
                NSLog(@"%@", [error localizedDescription]);
                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeConnectionError errorIdentifier:nil] error:DataSourceResponseErrorTypeConnectionError];
                handler(nil, response);
            }else{
                
                if (responseObject){
                    if ([responseObject isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicResponse = (NSDictionary *)responseObject;
                        
                        if ([[dicResponse allKeys] containsObject:@"beacons"]) {
                            
                            NSArray *list = [[NSArray alloc] initWithArray:[dicResponse objectForKey:@"beacons"]];
                            
                            NSMutableArray *beaconsList = [NSMutableArray new];
                            
                            for (NSDictionary *dic in list){
                                [beaconsList addObject:[LaBeacon createObjectFromDictionary:dic]];
                            }
                            
                            DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                            handler(beaconsList, response);
                            
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

- (void)getProductInfoUsingSKU:(NSString* _Nonnull)sku withCompletionHandler:(void (^_Nullable)(NSDictionary* _Nullable data, DataSourceResponse* _Nonnull response)) handler
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        //NSMutableDictionary *parameters = [NSMutableDictionary new];
        //
        NSString *urlString = [NSString stringWithFormat:@"%@%@", [icm serverPreference], SERVICE_URL_GET_PRODUCTINFO_SKU];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"<PRODUCTSKU>" withString:sku];
        
        [icm getFrom:urlString body:nil completionHandler:^(id  _Nullable responseObject, NSInteger statusCode, NSError * _Nullable error) {
            
            if (error){
                NSLog(@"%@", [error localizedDescription]);
                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusError code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeConnectionError errorIdentifier:nil] error:DataSourceResponseErrorTypeConnectionError];
                handler(nil, response);
            }else{
                
                if (responseObject){
                    if ([responseObject isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicResponse = (NSDictionary *)responseObject;
                        
                        DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                        handler(dicResponse, response);
                       
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
