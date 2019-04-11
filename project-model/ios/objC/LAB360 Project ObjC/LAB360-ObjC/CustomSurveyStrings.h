//
//  CustomSurveyStrings.h
//  LAB360-Dev
//
//  Created by Erico GT on 26/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"

@interface CustomSurveyStrings : NSObject<DefaultObjectModelProtocol>

#pragma mark - Properties

@property (nonatomic, strong) NSString *MSG_INCOMPLETEQUESTIONS;
@property (nonatomic, strong) NSString *MSG_INCOMPATIBLEVERSION;
@property (nonatomic, strong) NSString *MSG_PASSEDDATE;
@property (nonatomic, strong) NSString *MSG_FUTUREDATE;
@property (nonatomic, strong) NSString *MSG_UNANSWERABLE;
@property (nonatomic, strong) NSString *MSG_NOGROUPS;
@property (nonatomic, strong) NSString *MSG_INTERRUPTEDBYUSER;
@property (nonatomic, strong) NSString *MSG_WITHDRAWALBYUSER;
@property (nonatomic, strong) NSString *MSG_TIMEOUTEXIT;
@property (nonatomic, strong) NSString *MSG_TIMEOUTFINISH;
@property (nonatomic, strong) NSString *MSG_SUCCESSFINISH;
@property (nonatomic, strong) NSString *MSG_INVALIDGROUP;
@property (nonatomic, strong) NSString *MSG_QUESTIONSERROR;
@property (nonatomic, strong) NSString *MSG_INCOMPLETESTAGE;


#pragma mark - Support Data Methods
+ (CustomSurveyStrings*)newObject;
+ (CustomSurveyStrings*)createObjectFromDictionary:(NSDictionary*)dicData;
- (CustomSurveyStrings*)copyObject;
- (NSDictionary*)dictionaryJSON;

@end
