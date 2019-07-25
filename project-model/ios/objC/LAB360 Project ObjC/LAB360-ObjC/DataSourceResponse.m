//
//  DataSourceResponse.m
//  LAB360-ObjC
//
//  Created by Erico GT on 23/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "DataSourceResponse.h"

@implementation DataSourceResponse

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.status = DataSourceResponseStatusNone;
        self.code = 0;
        self.message = @"";
        self.error = DataSourceResponseErrorTypeNone;
    }
    return self;
}

+ (DataSourceResponse*_Nonnull)newDataSourceResponse:(DataSourceResponseStatus)s code:(long)c message:( NSString*_Nonnull)m error:(DataSourceResponseErrorType)e
{
    DataSourceResponse *dsr = [DataSourceResponse new];
    dsr.status = s;
    dsr.code = c;
    dsr.message = [NSString stringWithFormat:@"%@", m];
    dsr.error = e;
    return dsr;
}

@end
