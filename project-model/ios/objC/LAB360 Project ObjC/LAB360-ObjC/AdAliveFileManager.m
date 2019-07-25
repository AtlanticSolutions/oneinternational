//
//  AdAliveFileManager.m
//  LAB360-ObjC
//
//  Created by Erico GT on 16/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AdAliveFileManager.h"
#import "ToolBox.h"

@implementation AdAliveFileManager

+ (NSURL*)temporaryFileForData:(AdAliveFile*)fileData
{
    if (fileData == nil){
        return nil;
    }
    
    NSDictionary *dic = [fileData dictionaryJSON];
    
    if (dic == nil || [dic allKeys].count == 0){
        return nil;
    }
    
    NSMutableDictionary *finalDic = [NSMutableDictionary new];
    [finalDic setValue:dic forKey:@"file"];
    
    NSString *stringFile = [ToolBox converterHelper_StringJsonFromDictionary:finalDic];
    
    //compressão:
    NSData *gzipData = [ToolBox dataHelper_GZipData:[stringFile dataUsingEncoding:NSUTF8StringEncoding] withCompressionLevel:1.0];
    
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *fileURL = [[tmpDirURL URLByAppendingPathComponent:[ToolBox dateHelper_TimeStampCompleteIOSfromDate:[NSDate date]]] URLByAppendingPathExtension:@"adAlive"];
    NSLog(@"fileURL: %@", [fileURL path]);
    
    if ([gzipData writeToFile:[fileURL path] atomically:YES]){
        return fileURL;
    }else{
        return nil;
    }
}

+ (BOOL)saveFile:(AdAliveFile*)fileData inDirectoryPath:(NSURL*)dirPath withName:(NSString*)fileName
{
    if (fileData == nil || dirPath == nil || fileName == nil){
        return NO;
    }
    
    NSDictionary *dic = [fileData dictionaryJSON];
    
    if (dic == nil || [dic allKeys].count == 0){
        return NO;
    }
    
    NSMutableDictionary *finalDic = [NSMutableDictionary new];
    [finalDic setValue:dic forKey:@"file"];
    
    NSString *stringFile = [ToolBox converterHelper_StringJsonFromDictionary:finalDic];
    
    //compressão:
    NSData *gzipData = [ToolBox dataHelper_GZipData:[stringFile dataUsingEncoding:NSUTF8StringEncoding] withCompressionLevel:1.0];
    
    NSURL *fileURL = [[dirPath URLByAppendingPathComponent:fileName] URLByAppendingPathExtension:@"adalive"];
    NSLog(@"fileURL: %@", [fileURL path]);
    
    return [gzipData writeToFile:[fileURL path] atomically:YES];
}

+ (AdAliveFile*)loadFileFromDirectoryPath:(NSURL*)dirPath withName:(NSString*)fileName
{
    if (dirPath == nil){
        return nil;
    }
    
    NSURL *fileURL = dirPath;
    if(fileName != nil){
        fileURL = [[dirPath URLByAppendingPathComponent:fileName] URLByAppendingPathExtension:@"adalive"];
    }
    NSLog(@"fileURL: %@", [fileURL path]);
    
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    
    if (data == nil){
        return nil;
    }
    
    //descompressão:
    NSString *stringFile = [[NSString alloc] initWithData:[ToolBox dataHelper_GUnzipDataFromData:data] encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [ToolBox converterHelper_DictionaryFromStringJson:stringFile];
    
    AdAliveFile *file = nil;
    
    if ([[dic allKeys] containsObject:@"file"]){
        if ([[dic objectForKey:@"file"] isKindOfClass:[NSDictionary class]]){
            file = [AdAliveFile createObjectFromDictionary:[dic objectForKey:@"file"]];
        }
    }
    
    return file;
}

@end
