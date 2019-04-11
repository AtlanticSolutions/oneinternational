//
//  InternetConnectionManager.m
//  LAB360-ObjC
//
//  Created by Erico GT on 23/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "InternetConnectionManager.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "ToolBox.h"

@interface InternetConnectionManager()

//Download Control
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) long long downloadSize;
@property (nonatomic, copy) void (^downloadCompletionHandler)(NSData *response, NSError *error);
@property (nonatomic, assign) bool downloadingFile;
@property (nonatomic, strong) NSURLConnection *downloadConnection;
@property (nonatomic, weak) id<InternetConnectionManagerDelegate> downloadConnectionDelegate;
//
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSURLSession *downloadSession;
//
@property (nonatomic, weak) DevDataLogger *logger;

@end

@implementation InternetConnectionManager

@synthesize receivedData, downloadSize, downloadCompletionHandler, downloadingFile, downloadConnection, downloadConnectionDelegate, downloadTask, downloadSession;
@synthesize logger;

- (InternetConnectionManager*)init
{
    self = [super init];
    if (self) {
        receivedData = nil;
        downloadSize = 0;
        downloadCompletionHandler = nil;
        downloadingFile = false;
        downloadConnection = nil;
        downloadConnectionDelegate = nil;
        //
        downloadTask = nil;
        downloadSession = nil;
        //
        logger = ((AppDelegate*)[UIApplication sharedApplication].delegate).devLogger;
    }
    return self;
}

- (void)registerLogger:(DevDataLogger* _Nonnull)devLogger
{
    logger = devLogger;
}

- (InternetActiveConnectionType)activeConnectionType
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    switch (networkStatus) {
        case NotReachable:{
            return  InternetActiveConnectionTypeNone;
        }break;
        //
        case ReachableViaWiFi:{
            return  InternetActiveConnectionTypeWiFi;
        }break;
        //
        case ReachableViaWWAN:{
            return  InternetActiveConnectionTypeCellData;
        }break;
        //
        default:{
            return InternetActiveConnectionTypeUnknown;
        }break;
    }
}

- (NSString*_Nonnull)serverPreference
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* sp = [defaults objectForKey:BASE_APP_URL];
    return (sp == nil ? @"" : sp);
}

//GET:
- (DataSourceRequest*)getFrom:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic completionHandler:(void (^_Nullable)(id _Nullable responseObject, NSInteger statusCode, NSError*_Nullable error)) handler
{
//    NSURL *finalURL = [[NSURL alloc] initWithString:url];
//
//    if (finalURL){
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForExternalService:nil];
        
        if (requestSerializer) {
            [manager setRequestSerializer:requestSerializer];
        }
        
        DataSourceRequest *dsRequest = [DataSourceRequest newRequestWithOperation: [manager GET:url parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //LOGGER
             [logger newLogInternetConnectionForType:DevDataLoggerRequestTypeGET
                                                  ID:@"InternetConnectionManager_GET_Success"
                                                 url:url
                                             headers:operation.request.allHTTPHeaderFields
                                                body:bodyDic
                                      responseStatus:(int)operation.response.statusCode
                                        responseTime:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA]
                                        responseBody:[NSString stringWithFormat:@"%@", responseObject]
                                               error:@"-"];
             
             if (handler != nil){
                 handler(responseObject,operation.response.statusCode, nil);
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             //LOGGER
             [logger newLogInternetConnectionForType:DevDataLoggerRequestTypeGET
                                                  ID:@"InternetConnectionManager_GET_Error"
                                                 url:url
                                             headers:operation.request.allHTTPHeaderFields
                                                body:bodyDic
                                      responseStatus:(int)operation.response.statusCode
                                        responseTime:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA]
                                        responseBody:@"-"
                                               error:[NSString stringWithFormat:@"Exception: %@ - %@", [error domain], [error localizedDescription]]];
             
             if (handler != nil){
                 handler(operation.responseObject, operation.response.statusCode, error);
             }
         }]];
        
        return dsRequest;
        
//    }else{
//        NSError *error = [NSError errorWithDomain:@"br.com.lab360.error" code:NSURLErrorBadURL userInfo:nil];
//        handler(nil, NSURLErrorBadURL, error);
//        //
//        return nil;
//    }
}

- (DataSourceRequest*)getFrom:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic delegate:(id<InternetConnectionManagerDelegate>_Nullable)connectionDelegate
{
//    NSURL *finalURL = [[NSURL alloc] initWithString:url];
//
//    if (finalURL){
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForExternalService:nil];
        
        if (requestSerializer) {
            [manager setRequestSerializer:requestSerializer];
        }
        
        DataSourceRequest *dsRequest = [DataSourceRequest newRequestWithOperation: [manager GET:url parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             if (connectionDelegate != nil){
                 [connectionDelegate internetConnectionManager:self didConnectWithSuccess:responseObject];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             if (connectionDelegate != nil){
                 [connectionDelegate internetConnectionManager:self didConnectWithFailure:error];
             }
         }]];
        
        return dsRequest;
        
//    }else{
//        NSError *error = [NSError errorWithDomain:@"br.com.lab360.error" code:NSURLErrorBadURL userInfo:nil];
//        [connectionDelegate internetConnectionManager:self didConnectWithFailure:error];
//        //
//        return nil;
//    }
}

//POST:
- (DataSourceRequest*)postTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic completionHandler:(void (^_Nullable)(id _Nullable responseObject, NSInteger statusCode, NSError*_Nullable error)) handler
{
//    NSURL *finalURL = [[NSURL alloc] initWithString:url];
//
//    if (finalURL){
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForExternalService:nil];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
        
    DataSourceRequest *dsRequest = [DataSourceRequest newRequestWithOperation: [manager POST:url parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject)
      {
          //LOGGER
          [logger newLogInternetConnectionForType:DevDataLoggerRequestTypePOST
                                               ID:@"InternetConnectionManager_POST_Success"
                                              url:url
                                          headers:operation.request.allHTTPHeaderFields
                                             body:bodyDic
                                   responseStatus:(int)operation.response.statusCode
                                     responseTime:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA]
                                     responseBody:[NSString stringWithFormat:@"%@", responseObject]
                                            error:@"-"];
          
          if (handler != nil){
              handler(responseObject,operation.response.statusCode, nil);
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
          //LOGGER
          [logger newLogInternetConnectionForType:DevDataLoggerRequestTypePOST
                                               ID:@"InternetConnectionManager_POST_Error"
                                              url:url
                                          headers:operation.request.allHTTPHeaderFields
                                             body:bodyDic
                                   responseStatus:(int)operation.response.statusCode
                                     responseTime:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA]
                                     responseBody:@"-"
                                            error:[NSString stringWithFormat:@"Exception: %@ - %@", [error domain], [error localizedDescription]]];
          
          if (handler != nil){
              handler(operation.responseObject, operation.response.statusCode, error);
          }
          
      }]];
    
    return dsRequest;
        
//    }else{
//        NSError *error = [NSError errorWithDomain:@"br.com.lab360.error" code:NSURLErrorBadURL userInfo:nil];
//        handler(nil, NSURLErrorBadURL, error);
//    }
}

- (DataSourceRequest*)postTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic delegate:(id<InternetConnectionManagerDelegate>_Nullable)connectionDelegate
{
//    NSURL *finalURL = [[NSURL alloc] initWithString:url];
//
//    if (finalURL){
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForExternalService:nil];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    DataSourceRequest *dsRequest = [DataSourceRequest newRequestWithOperation: [manager POST:url parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (connectionDelegate != nil){
             [connectionDelegate internetConnectionManager:self didConnectWithSuccess:responseObject];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (connectionDelegate != nil){
             [connectionDelegate internetConnectionManager:self didConnectWithFailure:error];
         }
     }]];
    
    return dsRequest;
        
//    }else{
//        NSError *error = [NSError errorWithDomain:@"br.com.lab360.error" code:NSURLErrorBadURL userInfo:nil];
//        [connectionDelegate internetConnectionManager:self didConnectWithFailure:error];
//    }
}

//PUT:
- (DataSourceRequest*)putTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic completionHandler:(void (^_Nullable)(id _Nullable responseObject, NSInteger statusCode, NSError*_Nullable error)) handler
{
//    NSURL *finalURL = [[NSURL alloc] initWithString:url];
//
//    if (finalURL){
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForExternalService:nil];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    DataSourceRequest *dsRequest = [DataSourceRequest newRequestWithOperation: [manager PUT:url parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //LOGGER
         [logger newLogInternetConnectionForType:DevDataLoggerRequestTypePUT
                                              ID:@"InternetConnectionManager_PUT_Success"
                                             url:url
                                         headers:operation.request.allHTTPHeaderFields
                                            body:bodyDic
                                  responseStatus:(int)operation.response.statusCode
                                    responseTime:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA]
                                    responseBody:[NSString stringWithFormat:@"%@", responseObject]
                                           error:@"-"];
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         //LOGGER
         [logger newLogInternetConnectionForType:DevDataLoggerRequestTypePUT
                                              ID:@"InternetConnectionManager_PUT_Error"
                                             url:url
                                         headers:operation.request.allHTTPHeaderFields
                                            body:bodyDic
                                  responseStatus:(int)operation.response.statusCode
                                    responseTime:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA]
                                    responseBody:@"-"
                                           error:[NSString stringWithFormat:@"Exception: %@ - %@", [error domain], [error localizedDescription]]];
         
         if (handler != nil){
             handler(operation.responseObject, operation.response.statusCode, error);
         }
         
     }]];
    
    return dsRequest;
    
//    }else{
//        NSError *error = [NSError errorWithDomain:@"br.com.lab360.error" code:NSURLErrorBadURL userInfo:nil];
//        handler(nil, NSURLErrorBadURL, error);
//    }
}

- (DataSourceRequest*)putTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic delegate:(id<InternetConnectionManagerDelegate>_Nullable)connectionDelegate
{
//    NSURL *finalURL = [[NSURL alloc] initWithString:url];
//
//    if (finalURL){
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForExternalService:nil];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    DataSourceRequest *dsRequest = [DataSourceRequest newRequestWithOperation: [manager PUT:url parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (connectionDelegate != nil){
             [connectionDelegate internetConnectionManager:self didConnectWithSuccess:responseObject];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (connectionDelegate != nil){
             [connectionDelegate internetConnectionManager:self didConnectWithFailure:error];
         }
     }]];
    
    return dsRequest;
    
//    }else{
//        NSError *error = [NSError errorWithDomain:@"br.com.lab360.error" code:NSURLErrorBadURL userInfo:nil];
//        [connectionDelegate internetConnectionManager:self didConnectWithFailure:error];
//    }
}

- (DataSourceRequest* _Nullable)patchTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic completionHandler:(void (^_Nullable)(id _Nullable responseObject, NSInteger statusCode, NSError*_Nullable error)) handler
{
    //    NSURL *finalURL = [[NSURL alloc] initWithString:url];
    //
    //    if (finalURL){
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForExternalService:nil];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    DataSourceRequest *dsRequest = [DataSourceRequest newRequestWithOperation: [manager PATCH:url parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //LOGGER
        [logger newLogInternetConnectionForType:DevDataLoggerRequestTypePATCH
                                             ID:@"InternetConnectionManager_PATCH_Success"
                                            url:url
                                        headers:operation.request.allHTTPHeaderFields
                                           body:bodyDic
                                 responseStatus:(int)operation.response.statusCode
                                   responseTime:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA]
                                   responseBody:[NSString stringWithFormat:@"%@", responseObject]
                                          error:@"-"];
        
        if (handler != nil){
            handler(responseObject,operation.response.statusCode, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //LOGGER
        [logger newLogInternetConnectionForType:DevDataLoggerRequestTypePATCH
                                             ID:@"InternetConnectionManager_PATCH_Error"
                                            url:url
                                        headers:operation.request.allHTTPHeaderFields
                                           body:bodyDic
                                 responseStatus:(int)operation.response.statusCode
                                   responseTime:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA]
                                   responseBody:@"-"
                                          error:[NSString stringWithFormat:@"Exception: %@ - %@", [error domain], [error localizedDescription]]];
        
        if (handler != nil){
            handler(operation.responseObject, operation.response.statusCode, error);
        }
        
    }]];
    
    return dsRequest;
    
    //    }else{
    //        NSError *error = [NSError errorWithDomain:@"br.com.lab360.error" code:NSURLErrorBadURL userInfo:nil];
    //        handler(nil, NSURLErrorBadURL, error);
    //    }
}

- (DataSourceRequest* _Nullable)patchTo:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic delegate:(id<InternetConnectionManagerDelegate>_Nullable)connectionDelegate
{
    //    NSURL *finalURL = [[NSURL alloc] initWithString:url];
    //
    //    if (finalURL){
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForExternalService:nil];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    DataSourceRequest *dsRequest = [DataSourceRequest newRequestWithOperation: [manager PATCH:url parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (connectionDelegate != nil){
            [connectionDelegate internetConnectionManager:self didConnectWithSuccess:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (connectionDelegate != nil){
            [connectionDelegate internetConnectionManager:self didConnectWithFailure:error];
        }
    }]];
    
    return dsRequest;
    
    //    }else{
    //        NSError *error = [NSError errorWithDomain:@"br.com.lab360.error" code:NSURLErrorBadURL userInfo:nil];
    //        [connectionDelegate internetConnectionManager:self didConnectWithFailure:error];
    //    }
}

//DELETE:
- (DataSourceRequest* _Nullable)deleteFrom:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic completionHandler:(void (^_Nullable)(id _Nullable responseObject, NSInteger statusCode, NSError*_Nullable error)) handler
{
    //    NSURL *finalURL = [[NSURL alloc] initWithString:url];
    //
    //    if (finalURL){
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForExternalService:nil];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    DataSourceRequest *dsRequest = [DataSourceRequest newRequestWithOperation: [manager DELETE:url parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //LOGGER
        [logger newLogInternetConnectionForType:DevDataLoggerRequestTypePATCH
                                             ID:@"InternetConnectionManager_PATCH_Success"
                                            url:url
                                        headers:operation.request.allHTTPHeaderFields
                                           body:bodyDic
                                 responseStatus:(int)operation.response.statusCode
                                   responseTime:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA]
                                   responseBody:[NSString stringWithFormat:@"%@", responseObject]
                                          error:@"-"];
        
        if (handler != nil){
            handler(responseObject,operation.response.statusCode, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //LOGGER
        [logger newLogInternetConnectionForType:DevDataLoggerRequestTypePATCH
                                             ID:@"InternetConnectionManager_PATCH_Error"
                                            url:url
                                        headers:operation.request.allHTTPHeaderFields
                                           body:bodyDic
                                 responseStatus:(int)operation.response.statusCode
                                   responseTime:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA]
                                   responseBody:@"-"
                                          error:[NSString stringWithFormat:@"Exception: %@ - %@", [error domain], [error localizedDescription]]];
        
        if (handler != nil){
            handler(operation.responseObject, operation.response.statusCode, error);
        }
        
    }]];
    
    return dsRequest;
    
    //    }else{
    //        NSError *error = [NSError errorWithDomain:@"br.com.lab360.error" code:NSURLErrorBadURL userInfo:nil];
    //        handler(nil, NSURLErrorBadURL, error);
    //    }
}

- (DataSourceRequest* _Nullable)deleteFrom:(NSString*_Nonnull)url body:(NSDictionary*_Nullable)bodyDic delegate:(id<InternetConnectionManagerDelegate>_Nullable)connectionDelegate
{
    //    NSURL *finalURL = [[NSURL alloc] initWithString:url];
    //
    //    if (finalURL){
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForExternalService:nil];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    DataSourceRequest *dsRequest = [DataSourceRequest newRequestWithOperation: [manager DELETE:url parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (connectionDelegate != nil){
            [connectionDelegate internetConnectionManager:self didConnectWithSuccess:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (connectionDelegate != nil){
            [connectionDelegate internetConnectionManager:self didConnectWithFailure:error];
        }
    }]];
    
    return dsRequest;
    
    //    }else{
    //        NSError *error = [NSError errorWithDomain:@"br.com.lab360.error" code:NSURLErrorBadURL userInfo:nil];
    //        [connectionDelegate internetConnectionManager:self didConnectWithFailure:error];
    //    }
}


#pragma mark - DOWNLOAD CONTROL

- (void)downloadFileFrom:(NSString*_Nonnull)url withDelegate:(NSObject<InternetConnectionManagerDelegate>*_Nullable)downloadDelegate andCompletionHandler:(void (^_Nullable)(NSData*_Nullable response, NSError*_Nullable error)) handler
{
    [self cancelCurrentDownload];
    //
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    //
    receivedData = [[NSMutableData alloc] initWithLength:0];
    downloadCompletionHandler = [handler copy];
    downloadConnectionDelegate = downloadDelegate;
    downloadConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    //
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
    if (statusCode == 200) {
        downloadSize = [response expectedContentLength];
        [receivedData setLength:0];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
    float downloadProgress = ((float) [receivedData length] / (float) downloadSize);
    downloadProgress = downloadProgress > 1.0 ? 1.0 : downloadProgress;
    //
    if (downloadConnectionDelegate){
        [downloadConnectionDelegate internetConnectionManager:self downloadProgress:downloadProgress];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (downloadCompletionHandler){
        downloadCompletionHandler(nil, error);
    }else{
        if (downloadConnectionDelegate)
        {
            [downloadConnectionDelegate internetConnectionManager:self didConnectWithFailure:error];
        }
    }
    //
    [self clearDownloadData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (downloadCompletionHandler){
        downloadCompletionHandler(receivedData, nil);
    }else{
        if (downloadConnectionDelegate)
        {
            [downloadConnectionDelegate internetConnectionManager:self didConnectWithSuccessData:receivedData];
        }
    }
    //
    [self clearDownloadData];
}

- (void) cancelCurrentDownload
{
    if (downloadConnection){
        [downloadConnection cancel];
        //
        [self clearDownloadData];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)clearDownloadData
{
    downloadSize = 0;
    downloadCompletionHandler = nil;
    downloadingFile = false;
    downloadConnection = nil;
    downloadConnectionDelegate = nil;
    //
    downloadTask = nil;
    if (downloadSession){
        [downloadSession finishTasksAndInvalidate];
        downloadSession = nil;
    }
}

- (void)downloadDataFrom:(NSString*_Nonnull)url withDelegate:(id<InternetConnectionManagerDelegate>_Nullable)downloadDelegate andCompletionHandler:(void (^_Nullable)(NSData*_Nullable response, NSError*_Nullable error)) handler
{
    downloadConnectionDelegate = downloadDelegate;
    downloadCompletionHandler = handler;
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"br.com.lab360.download.task"];
    if (downloadSession){
        [downloadSession finishTasksAndInvalidate];
        downloadSession = nil;
    }
    downloadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    downloadTask = [downloadSession downloadTaskWithRequest:request];
    [downloadTask resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float downloadProgress = ((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
    downloadProgress = downloadProgress > 1.0 ? 1.0 : downloadProgress;
    
    if (downloadConnectionDelegate){
        [downloadConnectionDelegate internetConnectionManager:self downloadProgress:downloadProgress];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (downloadCompletionHandler){
        downloadCompletionHandler(nil, error);
    }else{
        if (downloadConnectionDelegate)
        {
            [downloadConnectionDelegate internetConnectionManager:self didConnectWithFailure:error];
        }
    }
    //
    [self clearDownloadData];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:location];
    
    if (downloadCompletionHandler){
        downloadCompletionHandler(data, nil);
    }else{
        if (downloadConnectionDelegate){
            [downloadConnectionDelegate internetConnectionManager:self didConnectWithSuccessData:data];
        }
    }
    //
    [self clearDownloadData];
}

- (void)cancelDownload
{
    if (downloadTask){
        [downloadTask cancel];
        //
        [self clearDownloadData];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - PRIVATE METHODS:

-(AFJSONRequestSerializer *)getHeaderParametersForExternalService:(NSString*_Nullable)externalServiceIdentifier
{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:PLISTKEY_ACCESS_TOKEN];
    
    if (token){
        NSString *authHeader = [NSString stringWithFormat:@"Token token=\"%@\"", token];
        [requestSerializer setValue:authHeader forHTTPHeaderField:AUTHENTICATE_HTTP_HEADER_FIELD];
    }else{
        [requestSerializer setValue:@"" forHTTPHeaderField:AUTHENTICATE_HTTP_HEADER_FIELD];
    }
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //
    NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    [requestSerializer setValue:appID forHTTPHeaderField:@"x_app_id"];
    
    if (externalServiceIdentifier){
        
        //Adicione parâmetros adicionais ao cabeçalho da requisição conforme a necessidade da requisição
        //[requestSerializer setValue:??? forHTTPHeaderField:???];
        NSLog(@"%@", externalServiceIdentifier);
    }
    
    return requestSerializer;
}

@end
