//
//  AdAliveConnectionManager.h
//  GS&MD
//
//  Created by Erico GT on 01/12/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "Reachability.h"
#import "ToolBox.h"

#pragma mark - DEFINES
#define BASE_APP_URL @"url_adalive"
#define PLISTKEY_ACCESS_TOKEN @"gsmd_access_token"
#define AUTHENTICATE_HTTP_HEADER_FIELD @"Authorization"

#pragma mark - PROTOCOL

@protocol AdAliveConnectionManagerDelegate <NSObject>

@optional
-(void)didFinishConnectionWithSuccess:(id)response;
-(void)didFinishConnectionWithFailure:(NSError *)error;
-(void)didFinishConnectionWithSuccessData:(NSData *)responseData;
-(void)downloadProgress:(float)dProgress;

@end

#pragma mark - CLASS

@interface AdAliveConnectionManager : NSObject<NSURLConnectionDelegate>

@property(nonatomic, assign) id<AdAliveConnectionManagerDelegate> delegate;


//Connection Methods: ************************************************************************************************
- (void) getRequestUsingParametersFromURL:(NSString*)url withDictionaryCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void) getRequestUsingParametersFromURL:(NSString*)url withArrayCompletionHandler:(void (^)(NSArray *response, NSInteger statusCode, NSError *error)) handler;
//
- (void) postRequestUsingParameters:(NSDictionary*)parameters fromURL:(NSString*)url withDictionaryCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
- (void) postRequestUsingParameters:(NSDictionary*)parameters fromURL:(NSString*)url withArrayCompletionHandler:(void (^)(NSArray *response, NSInteger statusCode, NSError *error)) handler;
//
- (void) downloadDataFromURL:(NSString*)url withCompletionHandler:(void (^)(NSData *response, NSError *error)) handler;

//Control Methods: ************************************************************************************************
- (BOOL)isProcessing;
- (void)cancelCurrentRequest;


//Utils Methods: ************************************************************************************************
- (BOOL)isConnectionActive;
- (NSString*)getServerPreference;


@end
