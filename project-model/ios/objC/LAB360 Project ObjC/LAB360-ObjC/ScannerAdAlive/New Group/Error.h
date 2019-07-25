//
//  Error.h
//  AdAlive
//
//  Created by Lab360 on 1/15/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantsManager.h"

@interface Error : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)dicError;
-(NSString *)formatCompleteErrorMessage;

@end
