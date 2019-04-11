//
//  DataSourceResponse.h
//  LAB360-ObjC
//
//  Created by Erico GT on 23/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DataSourceResponseStatusNone              = 0,
    DataSourceResponseStatusSuccess           = 1,
    DataSourceResponseStatusError             = 2,
    DataSourceResponseStatusProcessing        = 3,
   DataSourceResponseStatusCancelled         = 4
} DataSourceResponseStatus;

typedef enum {
    DataSourceResponseErrorTypeNone                   = 0,
    DataSourceResponseErrorTypeNoConnection           = 1,
    DataSourceResponseErrorTypeConnectionError        = 2,
    DataSourceResponseErrorTypeInvalidData            = 3,
    DataSourceResponseErrorTypeInternalException      = 4,
    DataSourceResponseErrorTypeGeneric                = 5
} DataSourceResponseErrorType;

@interface DataSourceResponse : NSObject

//Properties:
@property(nonatomic, assign) DataSourceResponseStatus status;
@property(nonatomic, assign) long code;
@property(nonatomic, strong) NSString*_Nonnull message;
@property(nonatomic, assign) DataSourceResponseErrorType error;
//@property(nonatomic, assign) BOOL notifyUserInError;

//Methods:
+ (DataSourceResponse*_Nonnull)newDataSourceResponse:(DataSourceResponseStatus)s code:(long)c message:( NSString*_Nonnull)m error:(DataSourceResponseErrorType)e;

@end

//**************************************************************************************************************

@protocol DataSourceResponseProtocol <NSObject>

@required
- (NSString*_Nonnull)errorMessageForType:(DataSourceResponseErrorType)type errorIdentifier:(NSString*_Nullable)identifier;

@end
