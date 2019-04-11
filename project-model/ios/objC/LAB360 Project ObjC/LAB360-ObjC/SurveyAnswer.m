//
//  SurveyQuestion.m
//  AdAlive
//
//  Created by Lab360 on 1/29/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import "SurveyAnswer.h"

@implementation SurveyAnswer

-(instancetype)initWithId:(NSNumber *)id
{
    self = [super init];
    
    if (self)
    {
        _id = id;
    }
    
    return self;
}

@end
