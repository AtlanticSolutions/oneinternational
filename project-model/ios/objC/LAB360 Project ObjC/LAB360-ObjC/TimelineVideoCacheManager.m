//
//  TimelineVideoCacheManager.m
//  LAB360-ObjC
//
//  Created by Erico GT on 03/12/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "TimelineVideoCacheManager.h"
#import "AsyncImageDownloader.h"
#import "AFURLSessionManager.h"

#define TIMELINE_VIDEO_CACHE_KEY @"TIMELINEVIDEOCACHEPLISTKEY"
#define TIMELINE_VIDEO_MAX_SIZE_FOLDER_CACHE_MB 512.0

@interface TimelineVideoCacheManager()

@property(nonatomic, strong) NSMutableDictionary *videoData;

@end

@implementation TimelineVideoCacheManager

@synthesize videoData;

- (TimelineVideoCacheManager*)init
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
    NSDictionary *vD = [uD objectForKey:TIMELINE_VIDEO_CACHE_KEY];
    
    if (vD && [vD isKindOfClass:[NSDictionary class]]){
        videoData = [[NSMutableDictionary alloc] initWithDictionary:vD];
    }else{
        videoData = [NSMutableDictionary new];
    }
}

+ (TimelineVideoCacheManager*)newVideoCache
{
    TimelineVideoCacheManager *vCache = [TimelineVideoCacheManager new];
    //
    return vCache;
}

- (NSString* _Nullable)loadVideoURLforID:(NSString* _Nonnull)postID andRemotelURL:(NSString* _Nonnull)remoteURL
{
    NSArray *allKeys = [videoData allKeys];
    NSString *localURL = nil;
    for (NSString *vID in allKeys){
        if ([vID isEqualToString:postID]){
            NSDictionary *dic = [videoData objectForKey:postID];
            NSString *fileName = [dic valueForKey:@"file_name"];
            NSString *storedRemoteURL = [dic valueForKey:@"remote_url"];
            //
            if ([remoteURL isEqualToString:storedRemoteURL]){
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *videoCacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"/TimelineVideoCache"];
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

- (void)saveVideoWithID:(NSString* _Nonnull)postID andRemoteURL:(NSString* _Nonnull)remoteURL withCompletionHandler:(void (^_Nullable)(BOOL success, NSString* _Nullable localVideoURL , NSError* _Nullable error)) handler
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
            NSString *videoCacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"/TimelineVideoCache"];
            //
            if (![self directoryExists:videoCacheDirectory]){
                [self createDirectoryAtPath:videoCacheDirectory];
            }
            //
            NSString *fileName = [NSString stringWithFormat:@"video%@.%@", postID, [remoteURL pathExtension]];
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
            [videoData setValue:vD forKey:postID];
            //
            NSUserDefaults *uD = [NSUserDefaults standardUserDefaults];
            [uD setObject:videoData forKey:TIMELINE_VIDEO_CACHE_KEY];
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

- (int)clearAllCachedVideoData
{
    int deletedFiles = 0;
    
    //removendo arquivos da pasta:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *videoCacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"/TimelineVideoCache"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:videoCacheDirectory error:&error];
    
    if (error == nil){
        
        //limpando o controle:
        videoData = [NSMutableDictionary new];
        NSUserDefaults *uD = [NSUserDefaults standardUserDefaults];
        [uD setObject:videoData forKey:TIMELINE_VIDEO_CACHE_KEY];
        [uD synchronize];
        
        for (NSString *filePath in directoryContents){
            if ([fileManager isDeletableFileAtPath:filePath]){
                NSError *fileError;
                if ([fileManager removeItemAtPath:filePath error:&fileError]){
                    deletedFiles += 1;
                }
                //
                if (fileError){
                    NSLog(@"clearAllCachedVideoData >> Error >> %@", [fileError localizedDescription]);
                }else{
                    NSLog(@"clearAllCachedVideoData >> File Deleted >> %@", filePath);
                }
            }
        }
    }else{
        NSLog(@"clearAllCachedVideoData >> Error >> %@", [error localizedDescription]);
    }
    
    return deletedFiles;
}

#pragma mark -

- (void)verifyCacheSize
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *videoCacheDirectory = [documentsDirectory stringByAppendingPathComponent:@"/TimelineVideoCache"];
    
    long double folderSizeInBytes = (long double)[self folderSize:videoCacheDirectory];
    
    long double folderSizeInMega = folderSizeInBytes / 1024.0 / 1024.0;
    
    if (folderSizeInMega > TIMELINE_VIDEO_MAX_SIZE_FOLDER_CACHE_MB){
        [self clearAllCachedVideoData];
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
