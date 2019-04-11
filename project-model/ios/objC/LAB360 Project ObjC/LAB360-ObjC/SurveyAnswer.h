//
//  SurveyQuestion.h
//  AdAlive
//
//  Created by Lab360 on 1/29/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyAnswer : NSObject

@property(nonatomic, strong) NSNumber *id;
@property(nonatomic, strong) NSNumber *answer;
@property(nonatomic, strong) NSString *type;
@property BOOL required;

-(instancetype)initWithId:(NSNumber *)id;


@end
