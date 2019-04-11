//
//  CustomSurveyGroup.h
//  LAB360-ObjC
//
//  Created by Erico GT on 08/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"
#import "CustomSurveyQuestion.h"

@interface CustomSurveyGroup : NSObject<DefaultObjectModelProtocol>

#pragma mark - Properties
@property(nonatomic, assign) long groupID;
@property(nonatomic, assign) long order;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *imageURL;
@property(nonatomic, strong) NSString *headerMessage;
@property(nonatomic, strong) NSString *footerMessage;
@property(nonatomic, strong) NSMutableArray<CustomSurveyQuestion*> *questions;
//
@property(nonatomic, strong) UIImage *image;

#pragma mark - Methods
- (NSString*)groupCompletion;

#pragma mark - DefaultObjectModelProtocol
+ (CustomSurveyGroup*)newObject;
+ (CustomSurveyGroup*)createObjectFromDictionary:(NSDictionary*)dicData;
- (CustomSurveyGroup*)copyObject;
- (NSDictionary*)dictionaryJSON;
- (NSDictionary*)reducedJSON;

@end
