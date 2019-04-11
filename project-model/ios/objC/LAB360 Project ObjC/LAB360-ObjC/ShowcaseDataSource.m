//
//  ShowcaseDataSource.m
//  LAB360-ObjC
//
//  Created by Erico GT on 09/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "ShowcaseDataSource.h"
//
#import "AppDelegate.h"
#import "ConstantsManager.h"
#import "ToolBox.h"
#import "InternetConnectionManager.h"

@interface ShowcaseDataSource()<DataSourceResponseProtocol>

@end

@implementation ShowcaseDataSource

#pragma mark - Public Methods

- (void)getVirtualShowcaseFromServerWithCompletionHandler:(void (^_Nullable)(VirtualShowcaseGallery* _Nullable data, DataSourceResponse* _Nonnull response)) handler
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        //NSMutableDictionary *parameters = [NSMutableDictionary new];
        //
        NSString *urlString = [NSString stringWithFormat:@"%@%@", [icm serverPreference], SERVICE_URL_GET_VIRTUAL_SHOWCASE];
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
                        
                        if ([[dicResponse allKeys] containsObject:@"virtual_showcase_gallery"] && [[dicResponse objectForKey:@"virtual_showcase_gallery"] isKindOfClass:[NSDictionary class]]) {
                            
                            VirtualShowcaseGallery *gallery = [VirtualShowcaseGallery createObjectFromDictionary:[dicResponse objectForKey:@"virtual_showcase_gallery"]];
                            
                            //Não existir uma vitrine cadastrada não está sendo considerado um erro neste módulo.
                            if (gallery.galleryID != 0){
                                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
                                handler(gallery, response);
                            }else{
                                DataSourceResponse *response =  [DataSourceResponse newDataSourceResponse:DataSourceResponseStatusSuccess code:0 message:[self errorMessageForType:DataSourceResponseErrorTypeNone errorIdentifier:nil] error:DataSourceResponseErrorTypeNone];
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

#pragma mark -

- (void)loadSavedPhotosForUser:(long)userID withCompletionHandler:(void (^ _Nullable)(NSArray<VirtualShowcasePhoto*>* _Nullable photos, NSError* _Nullable error)) handler
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *collectionDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@%li", SHOWCASE_LOCAL_DATA_DIRECTORY, SHOWCASE_USER_COLLECTION_DATA_DIRECTORY, userID]];
    
    if ([self directoryExists:collectionDataDir])
    {
        NSError *readError;
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:collectionDataDir error:&readError];
        if (directoryContent){
            if (directoryContent.count == 0){
                handler([NSMutableArray new], nil);
            }else{
                NSMutableArray *finalList = [NSMutableArray new];
                for (NSString *localURL in directoryContent){
                    NSArray *parts = [localURL componentsSeparatedByString:@"/"];
                    NSString *filename = [parts lastObject];
                    if ([filename hasSuffix:@".jpg"]){
                        VirtualShowcasePhoto *photo = [VirtualShowcasePhoto new];
                        photo.name = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
                        photo.message = @"";
                        photo.selected = NO;
                        NSString *photoDataFile = [collectionDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", filename]];
                        photo.fileURL = photoDataFile;
                        photo.image = [UIImage imageWithContentsOfFile:photoDataFile];
                        [finalList addObject:photo];
                    }
                }
                handler(finalList, nil);
            }
        }else{
            handler(nil, readError);
        }
    }else{
        handler([NSMutableArray new], nil);
    }
}

- (BOOL)savePhoto:(UIImage* _Nonnull)photo forUser:(long)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *collectionDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@%li", SHOWCASE_LOCAL_DATA_DIRECTORY, SHOWCASE_USER_COLLECTION_DATA_DIRECTORY, userID]];
    
    if (![self directoryExists:collectionDataDir])
    {
        if (![self createDirectoryAtPath:collectionDataDir]) {
            return NO;
        }
    }
    
    NSString *fileName = [NSString stringWithFormat:@"PHOTO_%@", [ToolBox dateHelper_TimeStampCompleteIOSfromDate:[NSDate date]]];
    NSString *photoDataFile = [collectionDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@.jpg", fileName]];
    
    if (![self fileExists:photoDataFile])
    {
        if (![self createFileAtPath:photoDataFile])
        {
            return NO;
        }
    }
    
    NSData* photoData = UIImageJPEGRepresentation(photo, 1.0);
    return [photoData writeToFile:photoDataFile atomically:YES];
}

- (BOOL)deletePhoto:(NSString* _Nonnull)photoName forUser:(long)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *collectionDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@%li", SHOWCASE_LOCAL_DATA_DIRECTORY, SHOWCASE_USER_COLLECTION_DATA_DIRECTORY, userID]];
    
    NSString *photoDataFile = [collectionDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@.jpg", photoName]];
    
    if ([self fileExists:photoDataFile])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        return [fileManager removeItemAtPath:photoDataFile error:nil];
    }

    return YES;
}

#pragma mark - Private Methods

-(BOOL)directoryExists:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:directoryPath];
}

-(BOOL)fileExists:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

-(BOOL)createDirectoryAtPath:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
}

-(BOOL)createFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
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
