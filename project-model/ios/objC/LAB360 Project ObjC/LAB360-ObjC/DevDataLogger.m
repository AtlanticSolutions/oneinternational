//
//  InternetConnectionLogger.m
//  LAB360-ObjC
//
//  Created by Erico GT on 17/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "DevDataLogger.h"
#import "ToolBox.h"
#import "ConstantsManager.h"
#import "AppDelegate.h"

@interface DevDataLogger()

@property(nonatomic, strong) NSMutableArray<NSDictionary*> *icLogs;
@property(nonatomic, strong) NSMutableArray<NSDictionary*> *eventLogs;
@property(nonatomic, strong) NSString *agent;
@property(nonatomic, assign) int logLimit;
@property(nonatomic, assign) BOOL registerEnabled;

@end

@implementation DevDataLogger

@synthesize icLogs, eventLogs, agent, logLimit, registerEnabled;

- (instancetype)init
{
    self = [super init];
    if (self) {
        icLogs = [NSMutableArray new];
        eventLogs = [NSMutableArray new];
        agent = @"";
        logLimit = 100;
        registerEnabled = YES;
    }
    return self;
}

#pragma mark - CONTROL
+ (DevDataLogger* _Nonnull) createLoggerWithAgent:(NSString* _Nonnull)agentID andMaxLogLimiter:(int)limit
{
    DevDataLogger *logger = [DevDataLogger new];
    logger.agent = agentID;
    logger.logLimit = limit > 100 ? 100 : (limit <= 0 ? 100 : limit);
    //
    return logger;
}

- (BOOL) saveLoggerState
{
    NSMutableDictionary *loggerData = [NSMutableDictionary new];
    [loggerData setValue:icLogs forKey:@"internet_connections"];
    [loggerData setValue:eventLogs forKey:@"events"];
    [loggerData setValue:agent forKey:@"agent"];
    [loggerData setValue:@(logLimit) forKey:@"limit"];
    //
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:loggerData forKey:@"lab360_logger_data"];
    return [userDefaults synchronize];
}

- (BOOL) loadLoggerState
{
    NSMutableDictionary *loggerData = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    @try {
        loggerData = [[NSMutableDictionary alloc] initWithDictionary:[userDefaults valueForKey:@"lab360_logger_data"]];
        //
        if ([loggerData allKeys].count > 0) {
            self.icLogs = [[NSMutableArray alloc] initWithArray:[loggerData valueForKey:@"internet_connections"]];
            self.eventLogs = [[NSMutableArray alloc] initWithArray:[loggerData valueForKey:@"events"]];
            self.agent = [loggerData valueForKey:@"agent"];
            self.logLimit = [[loggerData valueForKey:@"limit"] intValue];
            //
            return YES;
        }else{
            return NO;
        }
    } @catch (NSException *exception) {
        return NO;
    } @finally {
        loggerData = nil;
        userDefaults = nil;
    }
}

- (void) pauseLogRegister
{
    registerEnabled = NO;
}

- (void) resumeLogRegister
{
    registerEnabled = YES;
}

#pragma mark - DATA
- (NSString* _Nonnull) logDeviceData
{
    NSMutableString *strLOG = [NSMutableString new];
    //header
    [strLOG appendString:@"\n\n=========================================================================\n"];
    [strLOG appendString:@"• DEV-DATA-LOGGER • DEVICE INFO •\n"];
    [strLOG appendString:@"=========================================================================\n"];
    //device info
    [strLOG appendFormat:@"Model: %@\n", [ToolBox deviceHelper_Model]];
    //
    [strLOG appendFormat:@"Name: %@\n", [ToolBox deviceHelper_Name]];
    //
    [strLOG appendFormat:@"iOS Version: %@\n", [ToolBox deviceHelper_SystemVersion]];
    //
    [strLOG appendFormat:@"App Version: %@\n", [ToolBox applicationHelper_VersionBundle]];
    //
    CGSize size = [ToolBox deviceHelper_ScreenSize];
    [strLOG appendFormat:@"Screen Size: %ix%ipt (%ix%ipx) @%ix\n", (int)size.width, (int)size.height, (int)(size.width * [UIScreen mainScreen].scale), (int)(size.height * [UIScreen mainScreen].scale), (int)[UIScreen mainScreen].scale];
    //
    [strLOG appendFormat:@"Storage Capacity: %@\n", [ToolBox deviceHelper_StorageCapacity]];
    //
    [strLOG appendFormat:@"Free Memory Space: %@\n", [ToolBox deviceHelper_FreeMemorySpace]];
    //
    NSString *userData = @"-";
    __block User *userL = nil;
    dispatch_sync(dispatch_get_main_queue(), ^{
        userL = AppD.loggedUser;
    });
    if (userL.userID != 0) {
        userData = [NSString stringWithFormat:@"[%i] %@ (%@)", userL.userID, userL.name, userL.email];
    }
    [strLOG appendFormat:@"* Actual Logged User: %@\n", userData];
    [strLOG appendFormat:@"* AppID: %s\n", VALUE_APP_ID(APP_ID)];
    [strLOG appendFormat:@"* UUID: %@\n", [ToolBox deviceHelper_IdentifierForVendor]];
    [strLOG appendFormat:@"* AgentLoggerID: %@\n", self.agent];
    [strLOG appendString:@"=========================================================================\n\n"];
    //
    return strLOG;
}

#pragma mark - INTERNET CONNECTIONS
- (BOOL) newLogInternetConnectionForType:(DevDataLoggerRequestType)type
                                      ID:(NSString* _Nonnull)identifier
                                     url:(NSString* _Nonnull)url
                                 headers:(NSDictionary* _Nonnull)headers
                                    body:(NSDictionary* _Nullable)body
                          responseStatus:(int)rStatus
                            responseTime:(NSString* _Nullable) rTime
                            responseBody:(NSString* _Nullable) rBody
                               error:(NSString* _Nullable) error
{
    if (registerEnabled) {
        
        NSMutableDictionary *log = [NSMutableDictionary new];
        //
        NSString *t = @"???";
        switch (type) {
            case DevDataLoggerRequestTypeGET:{t = @"GET";}break;
            case DevDataLoggerRequestTypePOST:{t = @"POST";}break;
            case DevDataLoggerRequestTypePUT:{t = @"PUT";}break;
            case DevDataLoggerRequestTypePATCH:{t = @"PATCH";}break;
        }
        [log setValue:t forKey:@"type"];
        //
        [log setValue:identifier forKey:@"identifier"];
        //
        [log setValue:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] forKey:@"date"];
        //
        [log setValue:url forKey:@"url"];
        //
        [log setValue:headers forKey:@"header"];
        //
        [log setValue:(body ? body : @"-") forKey:@"body"];
        //
        [log setValue:@(rStatus) forKey:@"response_status"];
        //
        [log setValue:(rTime ? rTime : @"-") forKey:@"response_time"];
        //
        [log setValue:(rBody ? rBody : @"-") forKey:@"response_body"];
        //
        [log setValue:(error ? error : @"-") forKey:@"error"];
        
        if (icLogs.count >= logLimit && logLimit != 0) {
            [icLogs removeObjectAtIndex:0];
        }
        
        [icLogs addObject:log];
        
        return YES;
        
    } else {
        
        return NO;
        
    }
}

- (NSString* _Nonnull) logInternetConnections
{
    NSString *strLOG = [self logInternetConnectionsForTextType:nil];
    //
    return strLOG;
}

- (NSString* _Nonnull) logInternetConnectionsForType:(DevDataLoggerRequestType)type
{
    NSString *t = @"???";
    switch (type) {
        case DevDataLoggerRequestTypeGET:{t = @"GET";}break;
        case DevDataLoggerRequestTypePOST:{t = @"POST";}break;
        case DevDataLoggerRequestTypePUT:{t = @"PUT";}break;
        case DevDataLoggerRequestTypePATCH:{t = @"PATCH";}break;
    }
    
    NSString *strLOG = [self logInternetConnectionsForTextType:t];
    //
    return strLOG;
}

- (NSString* _Nonnull) logInternetConnectionsForTextType:(NSString* _Nullable)requestType
{
    NSMutableString *strLOG = [NSMutableString new];
    //header
    [strLOG appendString:@"\n\n=========================================================================\n"];
    [strLOG appendString:@"• DEV-DATA-LOGGER • INTERNET CONNECTIONS •\n"];
    [strLOG appendString:@"=========================================================================\n"];
    //data
    if (icLogs.count == 0) {
        [strLOG appendString:@"\nNenhuma entrada registrada!\n\n"];
    }else{
        NSMutableString *internalLOG = [NSMutableString new];
        [internalLOG appendString:@""];
        
        //for (int i=0; i<icLogs.count; i++) {
        for (long i=(icLogs.count - 1); i>=0; i--) {
            NSDictionary *dic = [icLogs objectAtIndex:i];
            
            NSString *dicType = [dic valueForKey:@"type"];
            if (requestType == nil || [dicType isEqualToString:requestType]) {
                
                //linha
                [internalLOG appendFormat:@"\n#%li ------------------------------------------------------------------\n", (i + 1)];
                //type
                [internalLOG appendFormat:@"Request: %@\n", [dic valueForKey:@"type"]];
                //identifier
                [internalLOG appendFormat:@"Identifier: %@\n", [dic valueForKey:@"identifier"]];
                //date
                [internalLOG appendFormat:@"Date: %@\n", [dic valueForKey:@"date"]];
                //url
                [internalLOG appendFormat:@"URL: %@\n", [dic valueForKey:@"url"]];
                //header
                [internalLOG appendFormat:@"Headers: %@\n", [dic valueForKey:@"header"]];
                //body
                [internalLOG appendFormat:@"Body: %@\n", [dic valueForKey:@"body"]];
                //response status
                [internalLOG appendFormat:@"Response Status: %i\n", [[dic valueForKey:@"response_status"] intValue]];
                //response time
                [internalLOG appendFormat:@"Response Time: %@\n", [dic valueForKey:@"response_time"]];
                //response data
                [internalLOG appendFormat:@"Response Data: %@\n", [dic valueForKey:@"response_body"]];
                //exception
                [internalLOG appendFormat:@"Error: %@\n", [dic valueForKey:@"error"]];
                
            }
        }
        
        if ([internalLOG isEqualToString:@""]) {
            [strLOG appendString:@"\nNenhuma entrada registrada!\n\n"];
        }else{
            [strLOG appendFormat:@"%@\n", internalLOG];
        }
    }
    //footer
    [strLOG appendString:@"=========================================================================\n\n"];
    
    return strLOG;
}

#pragma mark - EVENTS
- (BOOL) newLogEvent:(NSString* _Nonnull)title category:(NSString* _Nullable)category dicData:(NSDictionary* _Nonnull)data
{
    if (registerEnabled) {
        
        NSMutableDictionary *log = [NSMutableDictionary new];
        //
        [log setValue:title forKey:@"title"];
        //
        [log setValue:(category == nil ? @"-" : category) forKey:@"category"];
        //
        [log setValue:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA] forKey:@"date"];
        //
        [log setValue:data forKey:@"data"];
        
        if (eventLogs.count >= logLimit && logLimit != 0) {
            [eventLogs removeObjectAtIndex:0];
        }
        
        [eventLogs addObject:log];
        
        return YES;
        
    } else {
        
        return NO;
    }
}

//
- (NSString* _Nonnull) logEvents
{
    NSMutableString *strLOG = [NSMutableString new];
    //header
    [strLOG appendString:@"\n\n=========================================================================\n"];
    [strLOG appendString:@"• DEV-DATA-LOGGER • EVENTS •\n"];
    [strLOG appendString:@"=========================================================================\n"];
    //data
    if (eventLogs.count == 0) {
        [strLOG appendString:@"\nNenhuma entrada registrada!\n\n"];
    }else{
        //for (int i=0; i<eventLogs.count; i++) {
        for (long i=(eventLogs.count - 1); i>=0; i--) {
            NSDictionary *dic = [eventLogs objectAtIndex:i];
            //linha
            [strLOG appendFormat:@"\n#%li ------------------------------------------------------------------\n", (i + 1)];
            //title
            [strLOG appendFormat:@"Title: %@\n", [dic valueForKey:@"title"]];
            //category
            [strLOG appendFormat:@"Category: %@\n", [dic valueForKey:@"category"]];
            //date
            [strLOG appendFormat:@"Date: %@\n", [dic valueForKey:@"date"]];
            //data
            [strLOG appendFormat:@"Data Info: %@\n", [dic valueForKey:@"data"]];
        }
    }
    //footer
    [strLOG appendString:@"=========================================================================\n\n"];
    
    return strLOG;
}

@end
