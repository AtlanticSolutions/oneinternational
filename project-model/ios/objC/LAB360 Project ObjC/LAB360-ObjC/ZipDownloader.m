//
//  ZipDownloader.m
//  LAB360-ObjC
//
//  Created by Erico GT on 09/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "ZipDownloader.h"
//
#import "ToolBox.h"
#import "InternetConnectionManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "SSZipArchive.h"

@interface ZipDownloader()<InternetConnectionManagerDelegate>

typedef void (^ZipCompletionHandler)(BOOL success, NSError* _Nullable error);
typedef void (^ZipProgressHandler)(float progress);
//
@property(nonatomic, strong) NSString* zipURL;
@property(nonatomic, strong) NSString* zipDestinyFolder;
@property(nonatomic, strong) NSString* zipFileName;
@property(nonatomic, assign) BOOL needUnzip;
@property(nonatomic, assign) BOOL needDeleteOriginalFile;
@property(nonatomic, copy) ZipCompletionHandler completionBlock;
@property(nonatomic, copy) ZipProgressHandler progressBlock;
//
@property(nonatomic, strong)InternetConnectionManager *conection;

@end

@implementation ZipDownloader

- (void)downloadZipFileFrom:(NSString* _Nonnull)fileURL toFolderPath:(NSString* _Nonnull)destinyFolderPath fileName:(NSString*)fileName unzipping:(BOOL)unzipFile deletingOriginalFile:(BOOL)deleteOriginal usingProgressHandler:(void (^_Nullable)(float progress))progressHandler andCompletionHandler:(void (^_Nullable)(BOOL success, NSError* _Nullable error)) completionHandler
{
    self.zipURL = fileURL;
    self.zipDestinyFolder = destinyFolderPath;
    self.zipFileName = fileName;
    self.needUnzip = unzipFile;
    self.needDeleteOriginalFile = deleteOriginal;
    self.progressBlock = progressHandler;
    self.completionBlock = completionHandler;
    
    [self startDownloadZipFile];
}

- (void)startDownloadZipFile
{
    if (self.conection){
        [self.conection cancelDownload];
        [self.conection cancelCurrentDownload];
    }
    
    self.conection = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [self.conection activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        [self.conection downloadDataFrom:self.zipURL withDelegate:self andCompletionHandler:nil];
        
    }else{
        if (self.completionBlock){
            self.completionBlock(NO, [self errorWithDescription:@"Não há uma conexão com a internet disponível."]);
        }
    }
}

- (void)processData:(NSData*)fileData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *completePath = [self.zipDestinyFolder stringByAppendingString:[NSString stringWithFormat:@"/%@", self.zipFileName]];
    
    //Controle de diretórios ******************************************************************************************************
    
    if (![self directoryExists:self.zipDestinyFolder])
    {
        if (![self createDirectoryAtPath:self.zipDestinyFolder]) {
            if (self.completionBlock){
                self.completionBlock(NO, [self errorWithDescription:@"Não foi possível criar o diretório para salvar o arquivo."]);
                return;
            }
        }
    }else{
        
        //Remoção dos arquivos antigos:
        NSError *error;
        NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:self.zipDestinyFolder error:&error];
        if (directoryContents != nil){
            for (NSString *path in directoryContents){
                NSString *fullPath = [self.zipDestinyFolder stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                //OBS: remover os arquivos já existentes não é uma operação restritiva (pode dar certo ou não...)
                [fileManager removeItemAtPath:fullPath error:&error];
            }
        }
    }
    
    if (![self fileExists:completePath])
    {
        if (![self createFileAtPath:completePath])
        {
            if (self.completionBlock){
                self.completionBlock(NO, [self errorWithDescription:@"Não foi possível salvar o arquivo baixado no diretório especificado."]);
            }
            return;
        }
    }
    
    //Salvando o arquivo:
    if (![fileData writeToFile:completePath atomically:NO]){
        if (self.completionBlock){
            self.completionBlock(NO, [self errorWithDescription:@"Não foi possível salvar o arquivo baixado no diretório especificado."]);
        }
    }
    
    if (self.needUnzip){
        
        //Unzip do arquivo ******************************************************************************************************
        if ([SSZipArchive unzipFileAtPath:completePath toDestination:self.zipDestinyFolder]){
            NSError *zipError;
            NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:self.zipDestinyFolder error:&zipError];
            if (directoryContents != nil && directoryContents.count > 0){
                
                if (self.needDeleteOriginalFile){
                    if (![self deleteFileAtPath:completePath]){
                        if (self.completionBlock){
                            self.completionBlock(NO, [self errorWithDescription:@"Não foi possível remover o arquivo original."]);
                        }
                        return;
                    }
                }
                
                if (self.completionBlock){
                    self.completionBlock(YES, nil);
                }
                return;
                
            }else{
                if (self.completionBlock){
                    self.completionBlock(NO, [self errorWithDescription:@"O arquivo zip não possui conteúdo."]);
                }
                return;
            }
        }else{
            if (self.completionBlock){
                self.completionBlock(NO, [self errorWithDescription:@"Não foi possível descompactar o arquivo baixado."]);
            }
            return;
        }
        
    }else{
        if (self.completionBlock){
            self.completionBlock(YES, nil);
        }
        return;
    }
    
}

#pragma mark - InternetConnectionManagerDelegate

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithSuccess:(id _Nullable)responseObject
{
    return;
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithFailure:(NSError * _Nullable)error
{
    if (self.completionBlock){
        self.completionBlock(NO, error);
    }
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithSuccessData:(id _Nullable)responseObject
{
    [self processData:(NSData*)responseObject];
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager downloadProgress:(float)dProgress
{
    if (self.progressBlock){
        dProgress = dProgress < 0.0 ? 0.0 : (dProgress > 1.0 ? 1.0 : dProgress);
        self.progressBlock(dProgress);
    }
}

#pragma mark - NSError

- (NSError*)errorWithDescription:(NSString*)description
{
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    [userInfo setValue:nil forKey:NSURLErrorKey]; //The corresponding value is an NSURL object.
    [userInfo setValue:nil forKey:NSFilePathErrorKey]; //Contains the file path of the error.
    [userInfo setValue:nil forKey:NSHelpAnchorErrorKey]; //The corresponding value is an NSString containing the localized help corresponding to the help button. See helpAnchor for more information.
    [userInfo setValue:description forKey:NSLocalizedDescriptionKey]; //The corresponding value is a localized string representation of the error that, if present, will be returned by localizedDescription.
    //[userInfo setValue:nil forKey:NSLocalizedFailureErrorKey];
    [userInfo setValue:nil forKey:NSLocalizedFailureReasonErrorKey]; //The corresponding value is a localized string representation containing the reason for the failure that, if present, will be returned by localizedFailureReason.
    [userInfo setValue:nil forKey:NSLocalizedRecoveryOptionsErrorKey]; //The corresponding value is an array containing the localized titles of buttons appropriate for displaying in an alert panel.
    [userInfo setValue:nil forKey:NSLocalizedRecoverySuggestionErrorKey]; //The corresponding value is a string containing the localized recovery suggestion for the error.
    [userInfo setValue:nil forKey:NSRecoveryAttempterErrorKey]; //The corresponding value is an object that conforms to the NSErrorRecoveryAttempting informal protocol.
    [userInfo setValue:nil forKey:NSStringEncodingErrorKey]; //The corresponding value is an NSNumber object containing the NSStringEncoding value.
    [userInfo setValue:nil forKey:NSUnderlyingErrorKey]; //The corresponding value is an error that was encountered in an underlying implementation and caused the error that the receiver represents to occur.
    [userInfo setValue:nil forKey:NSDebugDescriptionErrorKey];
    
    NSError *error = [NSError errorWithDomain:@"br.com.lab360.app.error" code:0 userInfo:userInfo];
    
    return error;
}

#pragma mark - General Methods

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

-(BOOL)deleteFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:nil];
}


@end
