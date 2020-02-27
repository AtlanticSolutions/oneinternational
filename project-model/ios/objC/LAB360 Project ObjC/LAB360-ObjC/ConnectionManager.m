//
//  ConnectionManager.m
//  AdAlive
//
//  Created by Monique Trevisan on 11/25/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import "ConnectionManager.h"
#import "ConstantsManager.h"

@interface ConnectionManager()

@property(nonatomic, strong) NSString *serverPreference;
@property(nonatomic, strong) NSString *serverAHKPreference;
@property(nonatomic, strong) NSString *serverChatPreference;
//Download Control
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) long long downloadSize;
@property (nonatomic, copy) void (^downloadCompletionHandler)(NSData *response, NSError *error);
@property (nonatomic, assign) bool downloadingFile;
@property (nonatomic, strong) NSURLConnection *downloadConnection;

@end

@implementation ConnectionManager

@synthesize receivedData, downloadSize, downloadCompletionHandler, serverPreference, serverAHKPreference, serverChatPreference, downloadingFile, downloadConnection;

//+ (id)sharedInstance {
//    static ConnectionManager *sharedConnectionManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedConnectionManager = [[self alloc] init];
//    });
//    return sharedConnectionManager;
//}

- (ConnectionManager*)init
{
    self = [super init];
    if (self) {
        serverPreference = @"";
        serverAHKPreference = @"";
        serverChatPreference = @"";
        receivedData = nil;
        //
        downloadSize = 0;
        downloadCompletionHandler = nil;
        downloadingFile = false;
        downloadConnection = nil;
    }
    return self;
}

-(NSString *)serverPreference
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	serverPreference = [defaults objectForKey:BASE_APP_URL];
    return serverPreference;
}

-(NSString *)serverAHKPreference
{
    
#ifdef SERVER_AHK_URL
    serverAHKPreference = [NSString stringWithFormat:@"https://%s", VALUE_SERVER_URL(SERVER_AHK_URL)];
#else
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    serverAHKPreference = [defaults stringForKey:PLISTKEY_SERVER_AHK_PREFERENCES];
#endif
	
    return serverAHKPreference;
}

-(NSString *)serverChatPreference
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	serverChatPreference = [defaults stringForKey:BASE_CHAT_URL];
    return serverChatPreference;
}

- (NSString*)getServerPreference
{
    return [self serverPreference];
}
- (NSString*)getServerAHKPreference
{
    return [self serverAHKPreference];
}

-(AFJSONRequestSerializer *)getHeaderParametersForServiceAHK:(bool)serviceAHK
{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    
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
    
    if (serviceAHK){
        [requestSerializer setValue:AUTHENTICATE_AHK_SUBSCRIPTION_VALUE forHTTPHeaderField:AUTHENTICATE_AHK_SUBSCRIPTION_KEY];
    }

    return requestSerializer;
}

-(BOOL)isConnectionActive
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return networkStatus != NotReachable;
}

#pragma mark - Exemplos

- (void)getRemoteDataFromMasterServerUsingURLParameters:(NSString *)urlParameters withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    [manager GET:urlParameters parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicResponse = (responseObject == nil || responseObject == [NSNull null]) ? nil : (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicResponse];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getAppConfig:(long)appId andRole:(NSString *)role withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_APP_CONFIG];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_id>" withString:[NSString stringWithFormat:@"%li", appId]];
	
	////
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 NSDictionary *dicUser = (NSDictionary *)responseObject;
		 
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:dicUser];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
	
}

- (void)authenticateUserUsingParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_AUTHENTICATE_STORE];
    
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         [[NSUserDefaults standardUserDefaults] setValue:[dicUser objectForKey:AUTHENTICATE_ACCESS_TOKEN] forKey:PLISTKEY_ACCESS_TOKEN];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)resetUserPassword:(NSString *)email withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:email, AUTHENTICATE_EMAIL_KEY, nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_RESET_PASSWORD];
    
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         [[NSUserDefaults standardUserDefaults] setValue:[dicUser objectForKey:AUTHENTICATE_ACCESS_TOKEN] forKey:PLISTKEY_ACCESS_TOKEN];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getAllEventsAvailableForMasterEventID:(long)masterEventID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];

    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }

    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_ALL_EVENTS];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<master_events_id>" withString:[NSString stringWithFormat:@"%li", masterEventID]];

    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)createUserUsingParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_CREATE_USER];
    
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}


 //metodo nao passa na url o parametro  id do usuario e sim no body

- (void)updateUserUsingParameters:(NSDictionary *)dicParameters withUserID:(int)ID withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i", self.serverPreference, SERVICE_URL_CREATE_USER, ID];
    
    ////
    [manager PUT:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];

}


- (void)updateUserUsingParametersWithoudID :(NSDictionary *)dicParameters   withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.serverPreference, SERVICE_URL_UPDATE_USER];
    
    ////
    [manager PUT:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
    
}

- (void)subscribeToEventUsingParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverAHKPreference, SERVICE_URL_AHK_POST_EVENT_SUBSCRIBE];
    
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)sendEventInfoToServerForMasterEventID:(long)masterEventID withParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_SUBSCRIBED_EVENT];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<master_event_id>" withString:[NSString stringWithFormat:@"%li", masterEventID]];
    
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)removeEventInfoFromServerForMasterEventID:(long)masterEventID withParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_DELETE_SUBSCRIBED_EVENT];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<master_event_id>" withString:[NSString stringWithFormat:@"%li", masterEventID]];
    
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getEventsForUser:(long)userId andMasterEventID:(long)masterEventID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    ///api/v1/<master_event_id>/events/app_user/<app_user_id>
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_SUBSCRIBED_EVENT];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_user_id>" withString:[NSString stringWithFormat:@"%li", userId]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<master_event_id>" withString:[NSString stringWithFormat:@"%li", masterEventID]];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
    
}

- (void)getContactsListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_CONTACT_LIST];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getTimelineListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_TIMELINE_LIST];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

-(void)createPostWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler{
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_CREATE_POST];
	
	////
	[manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 NSDictionary *dicUser = (NSDictionary *)responseObject;
		 
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:dicUser];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
	
	
}

- (void)getPortalNewsCategoriesWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverAHKPreference, SERVICE_URL_AHK_PORTAL_NEWS_CATEGORIES];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getPortalNewsUsingPostURL:(NSString*)urlNews WithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    [manager GET:urlNews parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)downloadFileFromURL:(NSURL*)fileURL WithCompletionHandler:(void (^)(NSData *response, NSError *error)) handler
{
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    //
    receivedData = [[NSMutableData alloc] initWithLength:0];
    downloadCompletionHandler = [handler copy];
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
    if ([self.delegate respondsToSelector:@selector(downloadProgress:)]){
        [self.delegate downloadProgress:downloadProgress];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (downloadCompletionHandler){
        downloadCompletionHandler(nil, error);
    }else{
        if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
        {
            [self.delegate didConnectWithFailure:error];
        }
    }
    //
    downloadSize = 0;
    downloadCompletionHandler = nil;
    downloadingFile = false;
    downloadConnection = nil;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (downloadCompletionHandler){
        downloadCompletionHandler(receivedData, nil);
    }else{
        if ([self.delegate respondsToSelector:@selector(didConnectWithSuccessData:)])
        {
            [self.delegate didConnectWithSuccessData:receivedData];
        }
    }
    //
    downloadSize = 0;
    downloadCompletionHandler = nil;
    downloadingFile = false;
    downloadConnection = nil;
}

- (void) cancelCurrentDownload
{
    if (downloadConnection){
        [downloadConnection cancel];
        //
        downloadSize = 0;
        downloadCompletionHandler = nil;
        downloadingFile = false;
        downloadConnection = nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)getDownloadsForEvent:(long)eventID andMasterEventID:(long)masterEventID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [[NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_EVENTS_DOWNLOADS] stringByReplacingOccurrencesOfString:@"<master_event_id>" withString:[NSString stringWithFormat:@"%li", masterEventID]];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<event_id>" withString:[NSString stringWithFormat:@"%ld", eventID]];
	
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:responseObject];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 {
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
}

- (void)getDownloadsForMasterEvent:(long)masterEventID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [[NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_MASTER_EVENTS_DOWNLOADS] stringByReplacingOccurrencesOfString:@"<master_event_id>" withString:[NSString stringWithFormat:@"%li", masterEventID]];
	NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_id>" withString:appID];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getHiveOfActivitiesListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverAHKPreference, SERVICE_URL_AHK_GET_HIVE_OF_ACTIVITIES];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)sendPhoto100YearsWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_PHOTO_100];
    
//    NSString *urlFab = @"http://488d3360.ngrok.io/api/v1/ftp/upload";
//    NSString *urlString = [NSString stringWithFormat:@"%@", urlFab];
    
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getFeedVideoWithAppID:(long)masterEventID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_FEED_VIDEOS];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<master_event_id>" withString:[NSString stringWithFormat:@"%ld", masterEventID]];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

-(void)getInitialConfigurationsWithUserID:(long)userID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler{
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_DATA_FOR_USER];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<user_id>" withString:[NSString stringWithFormat:@"%ld", userID]];
	
	////
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:responseObject];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
	
	
}

-(void)getPointsStatementWithUserID:(long)userID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler{
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_POINTS_STATEMENT];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<user_id>" withString:[NSString stringWithFormat:@"%ld", userID]];
	NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_id>" withString:appID];
	
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:responseObject];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];

}

- (void)getParticipantsWithMasterEventID:(long)masterEventID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_PARTICIPANTS];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<master_event_id>" withString:[NSString stringWithFormat:@"%ld", masterEventID]];
	
	////
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:responseObject];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
}

- (void)getMessagesFromEventWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *jsonString = [ToolBox converterHelper_StringJsonFromDictionary:dicParameters];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverChatPreference, [SERVICE_URL_GET_MESSAGES_CHAT stringByReplacingOccurrencesOfString:@"<dic_parameters>" withString:jsonString]];
    //Precisa 'escapar' a string para receber no servidor java:
    urlString = [urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ////
    [manager GET:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getMessagesFromSingleChatWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *jsonString = [ToolBox converterHelper_StringJsonFromDictionary:dicParameters];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverChatPreference, [SERVICE_URL_GET_MESSAGES_CHAT stringByReplacingOccurrencesOfString:@"<dic_parameters>" withString:jsonString]];
    //Precisa 'escapar' a string para receber no servidor java:
    urlString = [urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ////
    [manager GET:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)registerAPSTokenWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *jsonString = [ToolBox converterHelper_StringJsonFromDictionary:dicParameters];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverChatPreference, [SERVICE_URL_REGISTER_APS_TOKEN stringByReplacingOccurrencesOfString:@"<dic_parameters>" withString:jsonString]];
    //Precisa 'escapar' a string para receber no servidor java:
    urlString = [urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ////
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)unregisterAPSTokenWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *jsonString = [ToolBox converterHelper_StringJsonFromDictionary:dicParameters];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverChatPreference, [SERVICE_URL_REMOVE_APS_TOKEN stringByReplacingOccurrencesOfString:@"<dic_parameters>" withString:jsonString]];
    //Precisa 'escapar' a string para receber no servidor java:
    urlString = [urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postMessageToSingleChatWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *jsonString = [ToolBox converterHelper_StringJsonFromDictionary:dicParameters];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverChatPreference, [SERVICE_URL_POST_MESSAGE_CHAT stringByReplacingOccurrencesOfString:@"<dic_parameters>" withString:jsonString]];
    //Precisa 'escapar' a string para receber no servidor java:
    urlString = [urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ////
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postMessageToGroupChatWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *jsonString = [ToolBox converterHelper_StringJsonFromDictionary:dicParameters];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverChatPreference, [SERVICE_URL_POST_MESSAGE_CHAT stringByReplacingOccurrencesOfString:@"<dic_parameters>" withString:jsonString]];
    //Precisa 'escapar' a string para receber no servidor java:
    urlString = [urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ////
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postMessageInChatWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *jsonString = [ToolBox converterHelper_StringJsonFromDictionary:dicParameters];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverChatPreference, [SERVICE_URL_POST_MESSAGE_CHAT stringByReplacingOccurrencesOfString:@"<dic_parameters>" withString:jsonString]];
    //Precisa 'escapar' a string para receber no servidor java:
    urlString = [urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ////
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

-(void)getJobRolesListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler{
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_JOB_ROLES];
	NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_id>" withString:appID];
	
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 NSDictionary *dicUser = (NSDictionary *)responseObject;
		 
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:dicUser];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
}
//SERVICE_URL_GET_JOB_ROLES

- (void)getSectorsListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_SECTOR_LIST];
	
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getCategoryListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_CATEGORY_LIST];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)authenticateUserByFacebookWithParameters:(NSDictionary*)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICR_URL_POST_LOGIN_FACEBOOK];
    
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         [[NSUserDefaults standardUserDefaults] setValue:[dicUser objectForKey:AUTHENTICATE_ACCESS_TOKEN] forKey:PLISTKEY_ACCESS_TOKEN];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getLayoutDefinitions:(int)appId masterEventId:(long)masterEventId WithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_LAYOUT_DEFINITIONS];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<master_event_id>" withString:[NSString stringWithFormat:@"%li", masterEventId]];
	NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_id>" withString:appID];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getSponsorForMasterEventID:(long)masterEventID ListWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_SPONSOR_LIST];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<master_events_id>" withString:[NSString stringWithFormat:@"%li", masterEventID]];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getSponsorsPlansWithCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_SPONSORS_PLANS];
	NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_id>" withString:appID];
	
	////
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 NSDictionary *dicUser = (NSDictionary *)responseObject;
		 
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:dicUser];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
}

//about
- (void)getMessageAboutAccountID:(int)accountID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //Tipos disponíveis
    //0 - Português
    //1 - Inglês
    //2- Alemão
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_ABOUT_MESSAGE];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<account_id>" withString:[NSString stringWithFormat:@"%i", accountID]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<language>" withString:NSLocalizedString(@"LANGUAGE_TYPE", @"")];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getGroupsListForUserID:(int)userID fromAccountID:(int)accountID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i/%i", self.serverPreference, SERVICE_URL_GET_GROUP_LIST_FOR_USER, userID, accountID];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getPersonalChatListForUserID:(int)userID fromAccountID:(int)accountID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [[NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_PERSONAL_LIST_FOR_USER] stringByReplacingOccurrencesOfString:@"<app_user_id>" withString:[NSString stringWithFormat:@"%i", userID]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<account_id>" withString:[NSString stringWithFormat:@"%i", accountID]];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getSpeakersChatListForUserID:(int)userID fromAccountID:(int)accountID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [[NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_SPEAKER_LIST] stringByReplacingOccurrencesOfString:@"<app_user_id>" withString:[NSString stringWithFormat:@"%i", userID]];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<account_id>" withString:[NSString stringWithFormat:@"%i", accountID]];
	
	////
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:responseObject];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
}

- (void)getNotificationsWithUserID:(int)userID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [[NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_NOTIFICATIONS] stringByReplacingOccurrencesOfString:@"<app_user_id>" withString:[NSString stringWithFormat:@"%i", userID]];
	
	////
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:responseObject];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
}


- (void)getAllGroupsFromAccountID:(int)accountID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%i", self.serverPreference, SERVICE_URL_GET_ALL_GROUPS, accountID];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getAllUsersFromAccountID:(int)accountID forUser:(int)userID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_ALL_USERS];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<account_id>" withString:[NSString stringWithFormat:@"%i", accountID]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_user_id>" withString:[NSString stringWithFormat:@"%i", userID]];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)addUserToGroupWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_ADD_USER_TO_GROUP];
    
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
    
}

- (void)removeUserFromGroupWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_REMOVE_USER_TO_GROUP];
    
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
    
}

- (void)blockOrUnblockUserWithParamters:(NSDictionary *)dicParameters FromUser:(int)userID blocking:(bool)blocking withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString;
    
    if (blocking){
        
        urlString = [[NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_BLOCK_USER_CHAT] stringByReplacingOccurrencesOfString:@"<requester_id>" withString:[NSString stringWithFormat:@"%i", userID]];
    }else{
        urlString = [[NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_UNBLOCK_USER_CHAT] stringByReplacingOccurrencesOfString:@"<requester_id>" withString:[NSString stringWithFormat:@"%i", userID]];
    }
    
    //
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)authenticateUserCode:(NSString *)code withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_VALIDATE_CODE];
	NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_id>" withString:appID];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<code>" withString:code];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         [[NSUserDefaults standardUserDefaults] setValue:[dicUser objectForKey:AUTHENTICATE_ACCESS_TOKEN] forKey:PLISTKEY_ACCESS_TOKEN];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getTicketDiscountInfo:(NSString*)ticketCode consumerID:(int)consumerID withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?coupon_code=%@&app_user_id=%i", self.serverPreference, SERVICE_URL_PROMOTION_GETCOUPONDATA, ticketCode, consumerID];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (handler != nil){
             handler(nil, operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)consumeTicketDiscount:(NSDictionary*)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_PROMOTION_CONSUMECOUPON];
    
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getAddressByCEP:(NSString *)cep withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_ADDRESS_BY_CEP];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<cep>" withString:cep];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         } else {
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)findAddressByCEP:(NSString*)cep withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://viacep.com.br/ws/%@/json/", cep];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

#pragma mark - POST Methods
- (void)postDistributorSignup:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *, NSError *))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_DISTRIBUTOR_SIGNUP];
    
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicResponse = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicResponse];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postCreatePostWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_CREATE_POST];
    
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicResponse = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicResponse];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getPostsFromMasterEventID:(long)masterEventID postID:(long)postID andType:(NSString *)type withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_POSTS];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<master_event_id>" withString:[NSString stringWithFormat:@"%li", masterEventID]];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<post_id>" withString:[NSString stringWithFormat:@"%li", postID]];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<type>" withString:type];
	
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:responseObject];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
}

- (void)getPostsWithLimit:(long)limit fromMasterEventID:(long)masterEventID withCompletionHandler:(void (^)(NSArray *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_FIRST_POSTS];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<master_event_id>" withString:[NSString stringWithFormat:@"%li", masterEventID]];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<limit>" withString:[NSString stringWithFormat:@"%li", limit]];

    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:responseObject];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postRemovePostWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_REMOVE_POST];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<master_event_id>" withString:[NSString stringWithFormat:@"%li", [[dicParameters valueForKey:@"master_event_id"] longValue]]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_user_id>" withString:[NSString stringWithFormat:@"%li", [[dicParameters valueForKey:@"app_user_id"] longValue]]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<post_id>" withString:[NSString stringWithFormat:@"%li", [[dicParameters valueForKey:@"id"] longValue]]];
    
    ////
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicResponse = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicResponse];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postAddLikeForPost:(long)postID user:(long)userID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_ADD_LIKE];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<post_id>" withString:[NSString stringWithFormat:@"%li", postID]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_user_id>" withString:[NSString stringWithFormat:@"%li", userID]];
    
    ////
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicResponse = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicResponse];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postReadPersonalChat:(long)chatID user:(long)userID senderUserID:(long)senderUserID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	//api/v1/posts/<post_id>/remove_like/<app_user_id>"
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_READ_CHAT];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<chat_id>" withString:[NSString stringWithFormat:@"%li", chatID]];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<user_id>" withString:[NSString stringWithFormat:@"%li", userID]];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"<sent_user_id>" withString:[NSString stringWithFormat:@"%li", senderUserID]];
	
	////
	[manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 NSDictionary *dicResponse = (NSDictionary *)responseObject;
		 
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:dicResponse];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
}

- (void)postRemoveLikeForPost:(long)postID user:(long)userID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //api/v1/posts/<post_id>/remove_like/<app_user_id>"
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_REMOVE_LIKE];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<post_id>" withString:[NSString stringWithFormat:@"%li", postID]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_user_id>" withString:[NSString stringWithFormat:@"%li", userID]];
    
    ////
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicResponse = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicResponse];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postAddCommentForPost:(long)postID userID:(long)userID message:(NSString*)commentMessage withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //@"/api/v1/posts/<post_id>/add_comment/<app_user_id>"
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_ADD_COMMENT];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<post_id>" withString:[NSString stringWithFormat:@"%li", postID]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_user_id>" withString:[NSString stringWithFormat:@"%li", userID]];
    //
    NSDictionary *dicMessage = [[NSDictionary alloc] initWithObjectsAndKeys:commentMessage, @"message", nil];
    NSDictionary *dicComment = [[NSDictionary alloc] initWithObjectsAndKeys:dicMessage, @"comment", nil];
    ////
    [manager POST:urlString parameters:dicComment success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicResponse = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicResponse];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postUpdateCommentForPost:(long)postID userID:(long)userID commentID:(long)commentID message:(NSString*)commentMessage withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //@"/api/v1/posts/<post_id>/update_comment/<app_user_id>/<comment_post_id>"
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_UPDATE_COMMENT];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<post_id>" withString:[NSString stringWithFormat:@"%li", postID]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_user_id>" withString:[NSString stringWithFormat:@"%li", userID]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<comment_post_id>" withString:[NSString stringWithFormat:@"%li", commentID]];
    //
    NSDictionary *dicMessage = [[NSDictionary alloc] initWithObjectsAndKeys:commentMessage, @"message", nil];
    NSDictionary *dicComment = [[NSDictionary alloc] initWithObjectsAndKeys:dicMessage, @"comment", nil];
    
    ////
    [manager POST:urlString parameters:dicComment success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicResponse = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicResponse];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postRemoveCommentForPost:(long)postID userID:(long)userID commentID:(long)commentID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //@"/api/v1/:app_user_id/posts/:post_id/remove_comment/:comment_post_id"
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_REMOVE_COMMENT];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_user_id>" withString:[NSString stringWithFormat:@"%li", userID]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<post_id>" withString:[NSString stringWithFormat:@"%li", postID]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<comment_post_id>" withString:[NSString stringWithFormat:@"%li", commentID]];
    
    ////
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicResponse = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicResponse];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)pushNotificationInteractionFeedbackFor:(long)notificationID user:(long)userID action:(NSString*)actionChosen withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //@"/api/v1/notification/confirm"
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_POST_NOTIFICATION_CONFIRM];
    
    NSMutableDictionary *dicParameters = [NSMutableDictionary new];
    [dicParameters setValue:@(notificationID) forKey:@"notification_id"];
    [dicParameters setValue:@(userID) forKey:@"app_user_id"];
    //[dicParameters setValue:actionChosen forKey:@"notification_action"];
    
    ////
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicResponse = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicResponse];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

#pragma mark - Survey Methods

-(void)loadSurveyWithId:(NSString *)idSurvey withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", self.serverPreference ,SERVICE_URL_SURVEY, idSurvey];
	
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:responseObject];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
}

- (void)surveyLogWithParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference ,SERVICE_URL_SURVEY_LOG];
	[manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 NSDictionary *dicResponse = (NSDictionary *)responseObject;
		 dicResponse = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicResponse withString:@""];
         
		 if (handler != nil){
			 handler(dicResponse, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:dicResponse];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
}

#pragma mark - Product

-(void)loadProductWithId:(NSString *)idString withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
	
	if (requestSerializer) {
		[manager setRequestSerializer:requestSerializer];
	}
	
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@", self.serverPreference, SERVICE_URL_GET_PRODUCT_ID, idString];
	
	[manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 if (handler != nil){
			 handler(responseObject, nil);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
			 {
				 [self.delegate didConnectWithSuccess:responseObject];
			 }
		 }
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		 
		 if (handler != nil){
			 handler(nil, error);
		 }else{
			 if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
			 {
				 [self.delegate didConnectWithFailure:error];
			 }
		 }
	 }];
}

#pragma mark - Products
- (void)MA_getUpdatedProducts:(NSString*)localDate withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_MA_GET_PRODUCTS];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<date>" withString:localDate];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)MA_getAllCatalogsWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_MA_GET_ALL_CATALOGS];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)MA_getAllCategoriesWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_MA_GET_ALL_CATEGORIES];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)MA_getPrePaymentOrderWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_MA_GET_PREPAYMENT_ORDER];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)MA_sendShopOrderUsingParameters:(NSDictionary *)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_MA_POST_SEND_SHOP_ORDER];
    //
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
       {
           NSDictionary *dicUser = (NSDictionary *)responseObject;
           
           if (handler != nil){
               handler(responseObject,operation.response.statusCode, nil);
           }else{
               if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
               {
                   [self.delegate didConnectWithSuccess:dicUser];
               }
           }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
           if (handler != nil){
               handler(nil,operation.response.statusCode, error);
           }else{
               if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
               {
                   [self.delegate didConnectWithFailure:error];
               }
           }
       }];
}

- (void)MA_validateCoupon:(NSString*)coupon withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = @"http://maisamigas.ad-alive.com/api/v1/ma_valid_coupon/<coupon>";
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<coupon>" withString:coupon];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

#pragma mark - Orders

/** Gets a list of orders. */
- (void)getOrdersWithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //@"/api/v1/ma_list_order"
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_ORDERS_LIST];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

/** Gets an order history. */
- (void)getOrderHistoryFor:(NSString*)orderID withCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //@"/api/v1/ma_order_status/@%", orderID
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", self.serverPreference, SERVICE_URL_GET_ORDER_HISTORY, orderID];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
    
}

- (void)MA_getOrderItemsDetailFor:(long)orderID withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_MA_GET_ORDER_ITEMS_DETAIL];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<order_id>" withString:[NSString stringWithFormat:@"%li", orderID]];
    //
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

#pragma mark - Catalogs

/** Gets a list of catalogs. */
- (void)getCatalogsWithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //@"/api/v1/ma_catalogs"
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_CATALOGS_LIST];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

#pragma mark - Points

/** Gets points statement. */
- (void)MA_getPointsStatementWithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //@"/api/v1/ma_extract_score"
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_MA_POINTS_STATEMENT];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

#pragma mark - Categories

/** Gets a list of categories. */
- (void)getCategoriesWithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //@"/api/v1/ma_categories"
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_CATEGORIES_LIST];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

#pragma mark - MA_Profile

/** Gets profile infos. */
- (void)getProfileInfosWithCompletionHandler:(void (^)(NSDictionary *response, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:true];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    //@"/api/v1/info_profile"
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_PROFILE_INFOS];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

//Promotions
- (void)getAvailablePromotionsWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_SHOPPING_GET_PROMOTIONS];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_id>" withString:appID];
    //
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postRegisterUserInPromotionUsingParameters:(NSDictionary*)dicParameters withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_SHOPPING_POST_REGISTER_PROMOTION];
    //
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getMyInvoicesWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_SHOPPING_GET_MY_INVOICES];
    //urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_id>" withString:appID];
    //
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postInvoicePhotoUsingParameters:(NSDictionary*)dicParameters WithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_SHOPPING_POST_INVOICE_PHOTO];
    //
    [manager POST:urlString parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getShoppingStoresWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_SHOPPING_GET_STORES];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<app_id>" withString:appID];
    //
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getCostumerWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_SHOPPING_GET_COSTUMER];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getCostumerDataUsingCPF:(NSString*)cpf withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_SHOPPING_GET_COSTUMER_CPF];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<cpf>" withString:cpf];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getExtractsForPromotion:(long)promotionID withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_SHOPPING_GET_EXTRACT_PROMOTION];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<promotion_id>" withString:[NSString stringWithFormat:@"%li", promotionID]];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)postConsumeExtractBalanceForPromotion:(long)promotionID andUserCPF:(NSString*)cpf withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_SHOPPING_POST_EXTRACT_PROMOTION];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<promotion_id>" withString:[NSString stringWithFormat:@"%li", promotionID]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<cpf>" withString:cpf];
    //
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
    
}

- (void)getAboutPageWithCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_ABOUT];
    NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<APPID>" withString:appID];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getDocumentsWithLimit:(NSString*)limit offset:(NSString*)offset documentId:(NSString*)videoId category_id:(NSString*)catId subcategory_id:(NSString*)subcatId tag:(NSString*)tag withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_DOCUMENTS];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<limit>" withString:limit];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<offset>" withString:offset];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<id>" withString:videoId];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<cat>" withString:catId];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<subcat>" withString:subcatId];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<tag>" withString:tag];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getVideosWithLimit:(NSString*)limit offset:(NSString*)offset videoId:(NSString*)videoId category_id:(NSString*)catId subcategory_id:(NSString*)subcatId tag:(NSString*)tag withCompletionHandler:(void (^)(NSDictionary *response, NSInteger statusCode, NSError *error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_VIDEOS];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<limit>" withString:limit];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<offset>" withString:offset];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<id>" withString:videoId];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<cat>" withString:catId];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<subcat>" withString:subcatId];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<tag>" withString:tag];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getCategories:(NSString*)type limit:(NSString*)limit offset:(NSString*)offset category_id:(NSString*)catId withCompletionHandler:(void (^)(NSDictionary * response, NSInteger statusCode, NSError * error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.serverPreference, SERVICE_URL_GET_CATEGORIES];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<limit>" withString:limit];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<offset>" withString:offset];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<id>" withString:catId];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"<type>" withString:type];
    
    ////
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}

- (void)getUrlForSMWebViewWithUrl:(NSString *)url withCompletionHandler:(void (^)(NSDictionary * response, NSInteger statusCode, NSError * error)) handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [self getHeaderParametersForServiceAHK:false];
    
    if (requestSerializer) {
        [manager setRequestSerializer:requestSerializer];
    }
    
    ////
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dicUser = (NSDictionary *)responseObject;
         
         if (handler != nil){
             handler(responseObject,operation.response.statusCode, nil);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithSuccess:)])
             {
                 [self.delegate didConnectWithSuccess:dicUser];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (handler != nil){
             handler(nil,operation.response.statusCode, error);
         }else{
             if ([self.delegate respondsToSelector:@selector(didConnectWithFailure:)])
             {
                 [self.delegate didConnectWithFailure:error];
             }
         }
     }];
}


@end
