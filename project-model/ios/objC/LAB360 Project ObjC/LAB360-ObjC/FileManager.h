//
//  FileManager.h
//  AdAlive
//
//  Created by Monique Trevisan on 11/12/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

#import "ConstantsManager.h"
#import "ToolBox.h"

@interface FileManager : NSObject

+(id)sharedInstance;

//Beacons
-(NSArray *)getBeaconData;
-(BOOL)saveBeaconData:(NSArray *)arrayBeacon;

//User Profile
-(BOOL)saveProfileData:(NSDictionary *)dicUser;
-(BOOL)deleteProfileData;
-(NSDictionary *)getProfileData;

//Downloads Data
-(BOOL)saveDownloadsData:(NSDictionary *)dicDownloads;
-(BOOL)deleteDownloadsData;
-(NSDictionary*)getDownloadsData;

//Scanner History
-(BOOL)saveScannerAdAliveHistory:(NSDictionary*)historyData toUser:(long)userID;
-(NSDictionary*)loadScannerAdAliveHistoryToUser:(long)userID;

//Métodos para o ScannerAdAlive (tratamaneto das actions)
-(NSString*)getOrderDirectory;
-(NSArray*)getOrderData;
-(BOOL)saveOrderData:(NSArray*)arrayOrderData;
-(BOOL)removeOrderData;

//Zip
-(void)unzipFileAtPath:(NSString* _Nonnull)filePath toPath:(NSString* _Nonnull)destinationPath withCompletionHandler:(void (^_Nullable)(BOOL succeeded, NSError* _Nullable error))handler;

#pragma mark - Exemplos:
//- (bool)saveUserScans:(NSArray*)scanList withUserIdentifier:(NSString*)userIdentifier;
//- (NSArray*)loadUserScans:(NSString*)userIdentifier;

@end
