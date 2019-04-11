//
//  InternetConnectionManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 23/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
//
#import "DevDataLogger.h"
#import "DataSourceRequest.h"

typedef enum {
    InternetActiveConnectionTypeUnknown       = 0,
    InternetActiveConnectionTypeNone          = 1,
    InternetActiveConnectionTypeWiFi          = 2,
    InternetActiveConnectionTypeCellData      = 3
} InternetActiveConnectionType;

@protocol InternetConnectionManagerDelegate;

@interface InternetConnectionManager : NSObject<NSURLConnectionDelegate, NSURLSessionDelegate>

//Verificação de conexão:
- (InternetActiveConnectionType)activeConnectionType;

//Server Preference (produção/homologação/dev/etc...)
- (NSString*_Nonnull)serverPreference;

//GET:
- (DataSourceRequest* _Nullable)getFrom:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic completionHandler:(void (^_Nullable)(id _Nullable responseObject, NSInteger statusCode, NSError*_Nullable error)) handler;
- (DataSourceRequest* _Nullable)getFrom:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic delegate:(id<InternetConnectionManagerDelegate>_Nullable)connectionDelegate;

//POST:
- (DataSourceRequest* _Nullable)postTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic completionHandler:(void (^_Nullable)(id _Nullable responseObject, NSInteger statusCode, NSError*_Nullable error)) handler;
- (DataSourceRequest* _Nullable)postTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic delegate:(id<InternetConnectionManagerDelegate>_Nullable)connectionDelegate;

//PUT:
- (DataSourceRequest* _Nullable)putTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic completionHandler:(void (^_Nullable)(id _Nullable responseObject, NSInteger statusCode, NSError*_Nullable error)) handler;
- (DataSourceRequest* _Nullable)putTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic delegate:(id<InternetConnectionManagerDelegate>_Nullable)connectionDelegate;

//PATCH:
- (DataSourceRequest* _Nullable)patchTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic completionHandler:(void (^_Nullable)(id _Nullable responseObject, NSInteger statusCode, NSError*_Nullable error)) handler;
- (DataSourceRequest* _Nullable)patchTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic delegate:(id<InternetConnectionManagerDelegate>_Nullable)connectionDelegate;

//DELETE:
- (DataSourceRequest* _Nullable)deleteFrom:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic completionHandler:(void (^_Nullable)(id _Nullable responseObject, NSInteger statusCode, NSError*_Nullable error)) handler;
- (DataSourceRequest* _Nullable)deleteFrom:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic delegate:(id<InternetConnectionManagerDelegate>_Nullable)connectionDelegate;

//File Downloads:
- (void)downloadFileFrom:(NSString*_Nonnull)url withDelegate:(id<InternetConnectionManagerDelegate>_Nullable)downloadDelegate andCompletionHandler:(void (^_Nullable)(NSData*_Nullable response, NSError*_Nullable error)) handler;
- (void)cancelCurrentDownload;

//Data Downloads:
- (void)downloadDataFrom:(NSString*_Nonnull)url withDelegate:(id<InternetConnectionManagerDelegate>_Nullable)downloadDelegate andCompletionHandler:(void (^_Nullable)(NSData*_Nullable response, NSError*_Nullable error)) handler;
- (void)cancelDownload;

//Logs
- (void)registerLogger:(DevDataLogger* _Nonnull)devLogger;

@end

//**************************************************************************************************************

@protocol InternetConnectionManagerDelegate <NSObject>

@required
-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithSuccess:(id _Nullable)responseObject;
-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithFailure:(NSError * _Nullable)error;
-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithSuccessData:(id _Nullable)responseObject;
-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager downloadProgress:(float)dProgress;

@end
