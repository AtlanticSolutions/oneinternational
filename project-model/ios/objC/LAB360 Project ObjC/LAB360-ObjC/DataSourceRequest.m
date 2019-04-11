//
//  DataSourceRequest.m
//  LAB360-ObjC
//
//  Created by Erico GT on 28/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "DataSourceRequest.h"

@interface DataSourceRequest()

@property(nonatomic, strong) AFHTTPRequestOperation *afhttpRequestOperation;

@end

@implementation DataSourceRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ignoreSuccessCompletionBlock = NO;
        self.ignoreFailCompletionBlock = NO;
        self.ignoreRequestDelegate = NO;
    }
    return self;
}

+ (DataSourceRequest*)newRequestWithOperation:(AFHTTPRequestOperation*)requestOperation
{
    DataSourceRequest *dsr = [DataSourceRequest new];
    dsr.afhttpRequestOperation = requestOperation;
    //
    return dsr;
}

- (void)cancelRequest
{
    if (self.afhttpRequestOperation){
        [self.afhttpRequestOperation cancel];
    }
}

@end
