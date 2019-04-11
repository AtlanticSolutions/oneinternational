//
//  DataSourceRequest.h
//  LAB360-ObjC
//
//  Created by Erico GT on 28/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface DataSourceRequest : NSObject

//NOTE: Através de um objeto 'DataSourceRequest' é possível cancelar uma requisição.

#pragma mark - Properties

/** A propriedade 'ignoreSuccessCompletionBlock' é utilizada apenas para requisições que utilizam 'block callback'. */
@property(nonatomic, assign) BOOL ignoreSuccessCompletionBlock;

/** A propriedade 'ignoreFailCompletionBlock' é utilizada apenas para requisições que utilizam 'block callback'. */
@property(nonatomic, assign) BOOL ignoreFailCompletionBlock;

/** A propriedade 'ignoreRequestDelegate' é utilizada apenas para requisições que utilizam delegate. */
@property(nonatomic, assign) BOOL ignoreRequestDelegate;

#pragma mark - Methods
+ (DataSourceRequest*)newRequestWithOperation:(AFHTTPRequestOperation*)requestOperation;
- (void)cancelRequest;

@end
