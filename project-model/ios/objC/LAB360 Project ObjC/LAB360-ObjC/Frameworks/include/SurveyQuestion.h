//
//  SurveyQuestion.h
//  SDK_FullProject
//
//  Created by Lab360 on 26/06/17.
//  Copyright © 2017 atlantic. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * \enum ActionTypes
 * \brief An enumeration with action types.
 */
typedef enum : NSUInteger
{
	MultipleType = 0,
	NumberType = 1,
	TextType = 2
	
} AnswerType;

@interface SurveyQuestion : NSObject

@property(nonatomic, strong) NSNumber *id;
@property(nonatomic, strong) NSString *answer;
@property(nonatomic, assign) AnswerType type;
@property BOOL required;

-(instancetype)initWithId:(NSNumber *)id;

@end
