//
//  AdAliveFileManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 16/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdAliveFile.h"

@interface AdAliveFileManager : NSObject

//Methods:
+ (NSURL*)temporaryFileForData:(AdAliveFile*)fileData;
+ (BOOL)saveFile:(AdAliveFile*)fileData inDirectoryPath:(NSURL*)dirPath withName:(NSString*)fileName;
+ (AdAliveFile*)loadFileFromDirectoryPath:(NSURL*)dirPath withName:(NSString*)fileName;

@end
