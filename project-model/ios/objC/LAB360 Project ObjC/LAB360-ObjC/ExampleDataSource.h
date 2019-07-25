//
//  ExampleDataSource.h
//  LAB360-ObjC
//
//  Created by Erico GT on 23/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceResponse.h"

@interface ExampleDataSource : NSObject

//O método abaixo é um exemplo de como trabalhar com o modelo de classes DataSource
- (void)authenticateUserUsingEmail:(NSString* _Nonnull)userEmail password:(NSString*)userPassword withCompletionHandler:(void (^_Nullable)(NSDictionary* _Nullable data, DataSourceResponse* _Nonnull response)) handler;

@end
