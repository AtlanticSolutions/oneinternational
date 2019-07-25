//
//  AdAliveImageCacheManager.m
//  aw_experience
//
//  Created by Erico GT on 13/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AdAliveImageCacheManager.h"
#import "AsyncImageDownloader.h"
#import "AFURLSessionManager.h"

#define ADALIVE_IMAGE_CACHE_KEY @"ADALIVEIMAGECACHEPLISTKEY"
#define ADALIVE_IMAGE_MAX_SIZE_FOLDER_CACHE_MB 512.0

@interface AdAliveImageCacheManager()

@property(nonatomic, strong) NSMutableDictionary *imageData;

@end

@implementation AdAliveImageCacheManager

@synthesize imageData;

- (AdAliveImageCacheManager*)init
{
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    NSUserDefaults *uD = [NSUserDefaults standardUserDefaults];
    NSDictionary *vD = [uD objectForKey:ADALIVE_IMAGE_CACHE_KEY];
    
    if (vD && [vD isKindOfClass:[NSDictionary class]]){
        imageData = [[NSMutableDictionary alloc] initWithDictionary:vD];
    }else{
        imageData = [NSMutableDictionary new];
    }
}

+ (AdAliveImageCacheManager*)newImageCache
{
    AdAliveImageCacheManager *iCache = [AdAliveImageCacheManager new];
    //
    return iCache;
}

- (NSString*)loadImageURLforID:(NSString* _Nonnull)imageID andRemotelURL:(NSString* _Nonnull)remoteURL
{
    NSArray *allKeys = [imageData allKeys];
    NSString *localURL = nil;
    for (NSString *vID in allKeys){
        if ([vID isEqualToString:imageID]){
            NSDictionary *dic = [imageData objectForKey:imageID];
            NSString *fileName = [dic valueForKey:@"file_name"];
            NSString *storedRemoteURL = [dic valueForKey:@"remote_url"];
            //
            if ([remoteURL isEqualToString:storedRemoteURL]){
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *videoCacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"/AdAliveImageCache"];
                localURL = [videoCacheDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", fileName]];
                break;
            }
        }
    }
    
    if (localURL != nil){
        return localURL;
    }
    
    return nil;
}

- (void)saveImageWithID:(NSString* _Nonnull)imageID andRemoteURL:(NSString* _Nonnull)remoteURL withCompletionHandler:(void (^_Nullable)(BOOL success, NSString* _Nullable localImageURL , NSError* _Nullable error)) handler
{
    __block NSString *remoteAddress = [NSString stringWithString:remoteURL];
    __block NSString *localAddress = nil;
    
    [[[AsyncImageDownloader alloc] initWithFileURL:remoteURL successBlock:^(NSData *data) {
        
        if (data != nil){
            
            //verify cache size: *******************************************************************************************
            [self verifyCacheSize];
            
            //local url for file: *******************************************************************************************
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *videoCacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"/AdAliveImageCache"];
            //
            if (![self directoryExists:videoCacheDirectory]){
                [self createDirectoryAtPath:videoCacheDirectory];
            }
            //
            NSString *fileName = [NSString stringWithFormat:@"image%@.%@", imageID, [remoteURL pathExtension]];
            NSString *finalLocalURL = [videoCacheDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", fileName]];
            //
            if (![self fileExists:finalLocalURL]){
                [self createFileAtPath:finalLocalURL];
            }
            //
            [data writeToFile:finalLocalURL atomically:YES];
            
            //result report for file *******************************************************************************************
            localAddress = finalLocalURL;
            //
            NSMutableDictionary *vD = [NSMutableDictionary new];
            [vD setValue:fileName forKey:@"file_name"];
            [vD setValue:remoteAddress forKey:@"remote_url"];
            //
            [imageData setValue:vD forKey:imageID];
            //
            NSUserDefaults *uD = [NSUserDefaults standardUserDefaults];
            [uD setObject:imageData forKey:ADALIVE_IMAGE_CACHE_KEY];
            [uD synchronize];
            //
            handler(YES, localAddress, nil);
            
        }else{
            handler(NO, nil, nil);
        }
        
    } failBlock:^(NSError *error) {
        handler(NO, nil, error);
    }] startDownload];
}

- (void)saveImageWithID:(NSString* _Nonnull)imageID data:(NSData*)iData andRemoteURL:(NSString* _Nonnull)remoteURL withCompletionHandler:(void (^_Nullable)(BOOL success, NSString* _Nullable localImageURL , NSError* _Nullable error)) handler
{
    __block NSString *remoteAddress = [NSString stringWithString:remoteURL];
    __block NSString *localAddress = nil;
    
    if (iData != nil){
        
        //verify cache size: *******************************************************************************************
        [self verifyCacheSize];
        
        //local url for file: *******************************************************************************************
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *videoCacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"/AdAliveImageCache"];
        //
        if (![self directoryExists:videoCacheDirectory]){
            [self createDirectoryAtPath:videoCacheDirectory];
        }
        //
        NSString *fileName = [NSString stringWithFormat:@"image%@.%@", imageID, [remoteURL pathExtension]];
        NSString *finalLocalURL = [videoCacheDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", fileName]];
        //
        if (![self fileExists:finalLocalURL]){
            [self createFileAtPath:finalLocalURL];
        }
        //
        [iData writeToFile:finalLocalURL atomically:YES];
        
        //result report for file *******************************************************************************************
        localAddress = finalLocalURL;
        //
        NSMutableDictionary *vD = [NSMutableDictionary new];
        [vD setValue:fileName forKey:@"file_name"];
        [vD setValue:remoteAddress forKey:@"remote_url"];
        //
        [imageData setValue:vD forKey:imageID];
        //
        NSUserDefaults *uD = [NSUserDefaults standardUserDefaults];
        [uD setObject:imageData forKey:ADALIVE_IMAGE_CACHE_KEY];
        [uD synchronize];
        //
        handler(YES, localAddress, nil);
        
    }else{
        handler(NO, nil, nil);
    }
}

- (int)clearAllCachedImageData
{
    int deletedFiles = 0;
    
    //removendo arquivos da pasta:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *videoCacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"/AdAliveImageCache"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:videoCacheDirectory error:&error];
    
    if (error == nil){
        
        //limpando o controle:
        imageData = [NSMutableDictionary new];
        NSUserDefaults *uD = [NSUserDefaults standardUserDefaults];
        [uD setObject:imageData forKey:ADALIVE_IMAGE_CACHE_KEY];
        [uD synchronize];
        
        for (NSString *filePath in directoryContents){
            if ([fileManager isDeletableFileAtPath:filePath]){
                NSError *fileError;
                if ([fileManager removeItemAtPath:filePath error:&fileError]){
                    deletedFiles += 1;
                }
                //
                if (fileError){
                    NSLog(@"clearAllCachedImageData >> Error >> %@", [fileError localizedDescription]);
                }else{
                    NSLog(@"clearAllCachedImageData >> File Deleted >> %@", filePath);
                }
            }
        }
    }else{
        NSLog(@"clearAllCachedImageData >> Error >> %@", [error localizedDescription]);
    }
    
    return deletedFiles;
}

#pragma mark -

- (void)verifyCacheSize
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *videoCacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"/AdAliveImageCache"];
    
    long double folderSizeInBytes = (long double)[self folderSize:videoCacheDirectory];
    
    long double folderSizeInMega = folderSizeInBytes / 1024.0 / 1024.0;
    
    if (folderSizeInMega > ADALIVE_IMAGE_MAX_SIZE_FOLDER_CACHE_MB){
        [self clearAllCachedImageData];
    }
}

- (unsigned long long int)folderSize:(NSString *)folderPath
{
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
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

@end
