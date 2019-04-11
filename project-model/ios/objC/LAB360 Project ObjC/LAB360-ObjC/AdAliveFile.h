//
//  AdAliveFile.h
//  LAB360-ObjC
//
//  Created by Erico GT on 16/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - AdAliveFileData

@interface AdAliveFileData : NSObject

@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *action;
@property(nonatomic, strong) NSMutableDictionary *content;
//
+(AdAliveFileData*)createObjectFromDictionary:(NSDictionary*)dicData;
-(AdAliveFileData*)copyObject;
-(NSDictionary*)dictionaryJSON;

@end

#pragma mark - AdAliveFileSystem

@interface AdAliveFileSystem : NSObject

@property(nonatomic, strong) NSString *author;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *device;
@property(nonatomic, strong) NSString *os;
@property(nonatomic, strong) NSString *latitude;
@property(nonatomic, strong) NSString *longitude;
//
+(AdAliveFileSystem*)createObjectFromDictionary:(NSDictionary*)dicData;
-(AdAliveFileSystem*)copyObject;
-(NSDictionary*)dictionaryJSON;

@end

#pragma mark - AdAliveFile

@interface AdAliveFile : NSObject

@property(nonatomic, strong) NSMutableArray<AdAliveFileData*> *data;
@property(nonatomic, strong) AdAliveFileSystem *system;
@property(nonatomic, assign) int version;
//
+(AdAliveFile*)createObjectFromDictionary:(NSDictionary*)dicData;
-(AdAliveFile*)copyObject;
-(NSDictionary*)dictionaryJSON;

@end

//NOTE: Para saber mais sobre Document Types: https://stackoverflow.com/questions/24958021/document-types-vs-exported-and-imported-utis

/*
 
 file : {
    data : [
        {
            type : "user",
            action : "show",
            content : {
                user : "Erico GT"
            }
        },
        {
            type : "decimal",
            action : "save",
            content : {
                value : "1.0"
            }
        }
    ],
    system : {
        author : "Erico Gimenes",
        date : "01/01/2019 18:00:00 +0000",
        device : "AKJSHGFEHBEKJBKJWDWKBDGWVWNWLKSMWLKMS",
        os : "iOS 12.1",
        latitude : "-23.123456",
        longitude : "-47.123456"
    },
    version : 1.0
 }
 
 */
