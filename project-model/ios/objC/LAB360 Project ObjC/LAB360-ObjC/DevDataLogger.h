//
//  InternetConnectionLogger.h
//  LAB360-ObjC
//
//  Created by Erico GT on 17/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DevDataLoggerRequestTypeGET            = 1,
    DevDataLoggerRequestTypePOST           = 2,
    DevDataLoggerRequestTypePUT            = 3,
    DevDataLoggerRequestTypePATCH          = 4
} DevDataLoggerRequestType;

@interface DevDataLogger : NSObject

#pragma mark - CONTROL
+ (DevDataLogger* _Nonnull) createLoggerWithAgent:(NSString* _Nonnull)agentID andMaxLogLimiter:(int)limit;
- (BOOL) saveLoggerState;
- (BOOL) loadLoggerState;
- (void) pauseLogRegister;
- (void) resumeLogRegister;

#pragma mark - DATA
- (NSString* _Nonnull) logDeviceData;

#pragma mark - INTERNET CONNECTIONS
- (BOOL) newLogInternetConnectionForType:(DevDataLoggerRequestType)type
                                      ID:(NSString* _Nonnull)identifier
                                     url:(NSString* _Nonnull)url
                                 headers:(NSDictionary* _Nonnull)headers
                                    body:(NSDictionary* _Nullable)body
                          responseStatus:(int)rStatus
                            responseTime:(NSString* _Nullable) rTime
                            responseBody:(NSString* _Nullable) rBody
                               error:(NSString* _Nullable) error;
//
- (NSString* _Nonnull) logInternetConnections;
- (NSString* _Nonnull) logInternetConnectionsForType:(DevDataLoggerRequestType)type;

#pragma mark - EVENTS
- (BOOL) newLogEvent:(NSString* _Nonnull)title category:(NSString* _Nullable)category dicData:(NSDictionary* _Nonnull)data;
//
- (NSString* _Nonnull) logEvents;

@end
