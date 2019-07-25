//
//  AdAliveConnectionManager.m
//  GS&MD
//
//  Created by Erico GT on 01/12/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "AdAliveConnectionManager.h"
#import "ConstantsManager.h"

@interface AdAliveConnectionManager()

@property(nonatomic, strong) NSString *serverPreference;
//Download Control
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) long long downloadSize;
@property (nonatomic, copy) void (^downloadCompletionHandler)(NSData *response, NSError *error);
@property (nonatomic, assign) bool downloadingFile;
@property (nonatomic, strong) NSURLConnection *downloadConnection;
@property (nonatomic, strong) AFHTTPRequestOperation *requestConnection;
//
@property (nonatomic, assign) BOOL isProcessingRequest;

@end

@implementation AdAliveConnectionManager

@synthesize delegate, serverPreference, receivedData, downloadSize, downloadCompletionHandler, downloadingFile, downloadConnection, requestConnection, isProcessingRequest;

//Init ************************************************************************************************

- (AdAliveConnectionManager*)init
{
    self = [super init];
    if (self) {
        receivedData = nil;
        downloadSize = 0;
        downloadCompletionHandler = nil;
        downloadingFile = false;
        downloadConnection = nil;
        requestConnection = nil;
        isProcessingRequest = NO;
        delegate = nil;
        //
        [self getServerPreference];
    }
    return self;
}

//Connection Methods: ************************************************************************************************
- (void) getRequestUsingParametersFromURL:(NSString*)url withDictionaryCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    if (requestConnection){
        [requestConnection cancel];
        requestConnection = nil;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParameters];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    isProcessingRequest = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, url];
    
    requestConnection = [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         isProcessingRequest = NO;
         
         NSDictionary *dicResult = [NSDictionary new];
         
         if ([responseObject isKindOfClass:[NSDictionary class]]){
             dicResult = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:responseObject withString:@""];
         }
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didFinishConnectionWithSuccess:)])
             {
                 [self.delegate didFinishConnectionWithSuccess:dicResult];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         isProcessingRequest = NO;
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didFinishConnectionWithFailure:)])
             {
                 [self.delegate didFinishConnectionWithFailure:error];
             }
         }
     }];
}

- (void) getRequestUsingParametersFromURL:(NSString*)url withArrayCompletionHandler:(void (^)(NSArray *response, NSInteger statusCode, NSError *error)) handler
{
    if (requestConnection){
        [requestConnection cancel];
        requestConnection = nil;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParameters];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    isProcessingRequest = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, url];
    
    requestConnection = [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        isProcessingRequest = NO;
        
        NSArray *arrayResult = [NSArray new];
         
         if ([responseObject isKindOfClass:[NSArray class]]){
             arrayResult = [[NSArray alloc] initWithArray:responseObject];
         }
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didFinishConnectionWithSuccess:)])
             {
                 [self.delegate didFinishConnectionWithSuccess:arrayResult];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         isProcessingRequest = NO;
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didFinishConnectionWithFailure:)])
             {
                 [self.delegate didFinishConnectionWithFailure:error];
             }
         }
     }];
}

- (void) postRequestUsingParameters:(NSDictionary*)parameters fromURL:(NSString*)url withDictionaryCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParameters];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    isProcessingRequest = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, url];
    
    requestConnection = [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         isProcessingRequest = NO;
         
         NSDictionary *dicResult = [NSDictionary new];
         
         if ([responseObject isKindOfClass:[NSDictionary class]]){
             dicResult = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:responseObject withString:@""];
         }
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didFinishConnectionWithSuccess:)])
             {
                 [self.delegate didFinishConnectionWithSuccess:dicResult];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         isProcessingRequest = NO;
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didFinishConnectionWithFailure:)])
             {
                 [self.delegate didFinishConnectionWithFailure:error];
             }
         }
     }];
}

- (void) postRequestUsingParameters:(NSDictionary*)parameters fromURL:(NSString*)url withArrayCompletionHandler:(void (^)(NSArray *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParameters];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    isProcessingRequest = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, url];
    
    requestConnection = [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         isProcessingRequest = NO;
         
         NSArray *arrayResult = [NSArray new];
         
         if ([responseObject isKindOfClass:[NSArray class]]){
             arrayResult = [[NSArray alloc] initWithArray:responseObject];
         }
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didFinishConnectionWithSuccess:)])
             {
                 [self.delegate didFinishConnectionWithSuccess:arrayResult];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         isProcessingRequest = NO;
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didFinishConnectionWithFailure:)])
             {
                 [self.delegate didFinishConnectionWithFailure:error];
             }
         }
     }];
}

#pragma mark -

- (void) downloadDataFromURL:(NSString*)url withCompletionHandler:(void (^)(NSData *response, NSError *error)) handler
{
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    //
    receivedData = [[NSMutableData alloc] initWithLength:0];
    downloadCompletionHandler = [handler copy];
    downloadConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    //
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    isProcessingRequest = YES;
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
    if ([self.delegate respondsToSelector:@selector(downloadProgress:)]){
        [self.delegate downloadProgress:downloadProgress];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (downloadCompletionHandler){
        downloadCompletionHandler(nil, error);
    }else{
        if ([self.delegate respondsToSelector:@selector(didFinishConnectionWithFailure:)])
        {
            [self.delegate didFinishConnectionWithFailure:error];
        }
    }
    //
    downloadSize = 0;
    downloadCompletionHandler = nil;
    downloadingFile = false;
    downloadConnection = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    isProcessingRequest = NO;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (downloadCompletionHandler){
        downloadCompletionHandler(receivedData, nil);
    }else{
        if ([self.delegate respondsToSelector:@selector(didFinishConnectionWithSuccessData:)])
        {
            [self.delegate didFinishConnectionWithSuccessData:receivedData];
        }
    }
    //
    downloadSize = 0;
    downloadCompletionHandler = nil;
    downloadingFile = false;
    downloadConnection = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    isProcessingRequest = NO;
}

//Control Methods: ************************************************************************************************
- (BOOL)isProcessing
{
    return isProcessingRequest;
}

- (void)cancelCurrentRequest
{
    if (downloadConnection){
        [downloadConnection cancel];
        //
        downloadSize = 0;
        downloadCompletionHandler = nil;
        downloadingFile = false;
        downloadConnection = nil;
    }
    
    if (requestConnection){
        [requestConnection cancel];
    }
    
    isProcessingRequest = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


//Utils Methods: ************************************************************************************************
- (BOOL)isConnectionActive
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (NSString*)getServerPreference
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    serverPreference = [defaults objectForKey:BASE_APP_URL];
    return serverPreference;
}

//Local Methods ************************************************************************************************

-(AFJSONRequestSerializer *)getHeaderParameters
{
    NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:PLISTKEY_ACCESS_TOKEN])
    {
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:PLISTKEY_ACCESS_TOKEN];
        
        if(token)
        {
            NSString *authHeader = [NSString stringWithFormat:@"Token token=\"%@\"", token];
            [requestSerializer setValue:authHeader forHTTPHeaderField:AUTHENTICATE_HTTP_HEADER_FIELD];
        }
    }
    else
    {
        [requestSerializer setValue:@"" forHTTPHeaderField:AUTHENTICATE_HTTP_HEADER_FIELD];
    }
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:appID forHTTPHeaderField:@"x_app_id"];
    
    return requestSerializer;
}

@end
