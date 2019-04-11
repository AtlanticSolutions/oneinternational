//
//  AdAliveFile.m
//  LAB360-ObjC
//
//  Created by Erico GT on 16/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AdAliveFile.h"
#import "ToolBox.h"

#pragma mark - AdAliveFileData

@implementation AdAliveFileData

@synthesize type, action, content;

- (instancetype)init
{
    self = [super init];
    if (self) {
        type = @"";
        action = @"";
        content = [NSMutableDictionary new];
    }
    return self;
}

+(AdAliveFileData*)createObjectFromDictionary:(NSDictionary*)dicData
{
    AdAliveFileData *data = [AdAliveFileData new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        if ([keysList containsObject:@"type"]){
            data.type = [NSString stringWithFormat:@"%@", [neoDic valueForKey:@"type"]];
        }
        //
        if ([keysList containsObject:@"action"]){
            data.action = [NSString stringWithFormat:@"%@", [neoDic valueForKey:@"action"]];
        }
        //
        if ([keysList containsObject:@"content"]){
            if ([[neoDic objectForKey:@"content"] isKindOfClass:[NSDictionary class]]){
                data.content = [[NSMutableDictionary alloc] initWithDictionary:[neoDic objectForKey:@"content"]];
            }
        }
    }
    
    return data;
}

-(AdAliveFileData*)copyObject
{
    AdAliveFileData *copy = [AdAliveFileData new];
    //
    copy.type = self.type != nil ? [NSString stringWithFormat:@"%@", self.type] : nil;
    //
    copy.action = self.action != nil ? [NSString stringWithFormat:@"%@", self.action] : nil;
    //
    if (self.content != nil){
        NSData *buffer = [NSKeyedArchiver archivedDataWithRootObject: self.content];
        copy.content = [NSKeyedUnarchiver unarchiveObjectWithData: buffer];
    }else{
        copy.content = nil;
    }
    //
    return copy;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //
    [dic setValue:(self.type ? self.type : @"") forKey:@"type"];
    [dic setValue:(self.action ? self.action : @"") forKey:@"action"];
    [dic setValue:(self.content ? self.content : [NSDictionary new]) forKey:@"content"];
    //
    return dic;
}

@end

#pragma mark - AdAliveFileSystem

@implementation AdAliveFileSystem

@synthesize author, date, device, os, latitude, longitude;

- (instancetype)init
{
    self = [super init];
    if (self) {
        author = @"";
        date = @"";
        device = @"";
        os = @"";
        latitude = @"";
        longitude = @"";
    }
    return self;
}

+(AdAliveFileSystem*)createObjectFromDictionary:(NSDictionary*)dicData
{
    AdAliveFileSystem *system = [AdAliveFileSystem new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        if ([keysList containsObject:@"author"]){
            system.author = [NSString stringWithFormat:@"%@", [neoDic valueForKey:@"author"]];
        }
        //
        if ([keysList containsObject:@"date"]){
            system.date = [NSString stringWithFormat:@"%@", [neoDic valueForKey:@"date"]];
        }
        //
        if ([keysList containsObject:@"device"]){
            system.device = [NSString stringWithFormat:@"%@", [neoDic valueForKey:@"device"]];
        }
        //
        if ([keysList containsObject:@"os"]){
            system.os = [NSString stringWithFormat:@"%@", [neoDic valueForKey:@"os"]];
        }
        //
        if ([keysList containsObject:@"latitude"]){
            system.latitude = [NSString stringWithFormat:@"%@", [neoDic valueForKey:@"latitude"]];
        }
        //
        if ([keysList containsObject:@"longitude"]){
            system.longitude = [NSString stringWithFormat:@"%@", [neoDic valueForKey:@"longitude"]];
        }
    }
    
    return system;
}

-(AdAliveFileSystem*)copyObject
{
    AdAliveFileSystem *copy = [AdAliveFileSystem new];
    //
    copy.author = self.author != nil ? [NSString stringWithFormat:@"%@", self.author] : nil;
    //
    copy.date = self.date != nil ? [NSString stringWithFormat:@"%@", self.date] : nil;
    //
    copy.device = self.device != nil ? [NSString stringWithFormat:@"%@", self.device] : nil;
    //
    copy.os = self.os != nil ? [NSString stringWithFormat:@"%@", self.os] : nil;
    //
    copy.latitude = self.latitude != nil ? [NSString stringWithFormat:@"%@", self.latitude] : nil;
    //
    copy.longitude = self.longitude != nil ? [NSString stringWithFormat:@"%@", self.longitude] : nil;
    //
    return copy;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //
    [dic setValue:(self.author ? self.author : @"") forKey:@"author"];
    [dic setValue:(self.date ? self.date : [NSDictionary new]) forKey:@"date"];
    [dic setValue:(self.device ? self.device : [NSDictionary new]) forKey:@"device"];
    [dic setValue:(self.os ? self.os : [NSDictionary new]) forKey:@"os"];
    [dic setValue:(self.latitude ? self.latitude : [NSDictionary new]) forKey:@"latitude"];
    [dic setValue:(self.longitude ? self.longitude : [NSDictionary new]) forKey:@"longitude"];
    //
    return dic;
}

@end

#pragma mark - AdAliveFile

@implementation AdAliveFile

@synthesize data, system, version;

- (instancetype)init
{
    self = [super init];
    if (self) {
        data = [NSMutableArray new];
        system = [AdAliveFileSystem new];
        version = 1;
    }
    return self;
}

+(AdAliveFile*)createObjectFromDictionary:(NSDictionary*)dicData
{
    AdAliveFile *system = [AdAliveFile new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        if ([keysList containsObject:@"data"]){
            if ([[neoDic objectForKey:@"data"] isKindOfClass:[NSArray class]]){
                NSArray *temp = [[NSArray alloc] initWithArray:[neoDic valueForKey:@"data"]];
                for (NSDictionary *d in temp){
                    AdAliveFileData *item = [AdAliveFileData createObjectFromDictionary:d];
                    if (item){
                        [system.data addObject:item];
                    }
                }
            }
        }
        //
        if ([keysList containsObject:@"system"]){
            if ([[neoDic objectForKey:@"system"] isKindOfClass:[NSDictionary class]]){
                system.system = [AdAliveFileSystem createObjectFromDictionary:[neoDic objectForKey:@"system"]];
            }
        }
        //
        if ([keysList containsObject:@"version"]){
            system.version = [[neoDic valueForKey:@"version"] intValue];
        }
    }
    
    return system;
}

-(AdAliveFile*)copyObject
{
    AdAliveFile *copy = [AdAliveFile new];
    //
    if (self.data == nil){
        copy.data = nil;
    }else{
        for (AdAliveFileData *data in self.data){
            [copy.data addObject:[data copyObject]];
        }
    }
    //
    copy.system = self.system ? [self.system copyObject] : nil;
    //
    copy.version = self.version;
    //
    return copy;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //
    if (self.data){
        NSMutableArray *array = [NSMutableArray new];
        for (AdAliveFileData *d in self.data){
            [array addObject:[d dictionaryJSON]];
        }
        [dic setValue:array forKey:@"data"];
    }else{
        [dic setValue:[NSArray new] forKey:@"data"];
    }
    //
    [dic setValue:(self.system ? [self.system dictionaryJSON] : [NSDictionary new]) forKey:@"system"];
    //
    [dic setValue:@(self.version) forKey:@"version"];
    //
    return dic;
}

@end

