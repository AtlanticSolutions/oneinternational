//
//  Error.m
//  AdAlive
//
//  Created by Lab360 on 1/15/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import "Error.h"

@interface Error ()

@property(nonatomic, strong) NSDictionary *dicErrors;

@end
@implementation Error

-(instancetype)initWithDictionary:(NSDictionary *)dicErrors
{
    self = [super init];
    if (self)
    {
        _dicErrors = dicErrors;
    }
    
    return self;
}

-(NSString *)formatCompleteErrorMessage
{
    NSArray *arraysErrors = [self.dicErrors objectForKey:ERROR_ARRAY_KEY];
    NSString *completeMessage = @"";
    
    for (NSDictionary *dicError in arraysErrors)
    {
        NSDictionary *dicData = [dicError objectForKey:ERROR_OBJECT_KEY];
        NSString *eachError = [NSString stringWithFormat:@"%@ - %@",[dicData objectForKey:ERROR_ID_KEY], [dicData objectForKey:ERROR_TITLE_KEY]];
        completeMessage = [completeMessage stringByAppendingString:[NSString stringWithFormat:@"%@ \n", eachError]];
    }
    
    return completeMessage;
}

@end
