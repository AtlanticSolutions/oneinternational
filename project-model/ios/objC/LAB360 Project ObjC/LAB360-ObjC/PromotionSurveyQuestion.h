//
//  SurveyQuestion.h
//  ShoppingBH
//
//  Created by lordesire on 02/11/2017.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultObjectModelProtocol.h"
#import "ToolBox.h"

@interface PromotionSurveyAnswer : NSObject<DefaultObjectModelProtocol>
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, assign) long order; //order to show in list
@property (nonatomic, assign) bool isSelected; //use this to multi-selection questions or correct answer.
//Protocol Methods
+ (PromotionSurveyAnswer*)newObject;
+ (PromotionSurveyAnswer*)createObjectFromDictionary:(NSDictionary*)dicData;
- (NSDictionary*)dictionaryJSON;
- (PromotionSurveyAnswer*)copyObject;
@end

//**************************************************************************

@interface PromotionSurveyQuestion : NSObject<DefaultObjectModelProtocol>
@property (nonatomic, strong) NSString *question;
@property (nonatomic, assign) long selectedAnswer;
@property (nonatomic, strong) NSMutableArray<PromotionSurveyAnswer*> *alternativesList;
-(void) addAnswer:(NSString*)text;
//Protocol Methods
+ (PromotionSurveyQuestion*)newObject;
+ (PromotionSurveyQuestion*)createObjectFromDictionary:(NSDictionary*)dicData;
- (NSDictionary*)dictionaryJSON;
- (PromotionSurveyQuestion*)copyObject;

@end


