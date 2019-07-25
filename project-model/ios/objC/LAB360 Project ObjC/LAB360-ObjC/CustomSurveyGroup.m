//
//  CustomSurveyGroup.m
//  LAB360-ObjC
//
//  Created by Erico GT on 08/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyGroup.h"

#define CLASS_CUSTOMSURVEYGROUP_DEFAULT @"group"
#define CLASS_CUSTOMSURVEYGROUP_KEY_ID @"id"
#define CLASS_CUSTOMSURVEYGROUP_KEY_ORDER @"order"
#define CLASS_CUSTOMSURVEYGROUP_KEY_NAME @"name"
#define CLASS_CUSTOMSURVEYGROUP_KEY_IMAGEURL @"url_image"
#define CLASS_CUSTOMSURVEYGROUP_KEY_HEADER @"header_message"
#define CLASS_CUSTOMSURVEYGROUP_KEY_FOOTER @"footer_message"
#define CLASS_CUSTOMSURVEYGROUP_KEY_QUESTIONS @"questions" //intermediateCheckRequirement

@implementation CustomSurveyGroup

@synthesize groupID, order, name, imageURL, headerMessage, footerMessage, questions, image;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        groupID = 0;
        order = 0;
        name = nil;
        imageURL = nil;
        headerMessage = nil;
        footerMessage = nil;
        questions = [NSMutableArray new];
        image = nil;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Methods
//-------------------------------------------------------------------------------------------------------------

- (NSString*)groupCompletion
{
    long total = 0;
    long answered = 0;
    
    for (CustomSurveyQuestion *question in self.questions){
        if (question.type != SurveyQuestionTypeUnanswerable){
            total += 1;
            if (question.userAnswers.count > 0){
                answered += 1;
            }
        }
    }
    
    NSString *completed = [NSString stringWithFormat:@"%li/%li", answered, total];
    return completed;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------

+ (CustomSurveyGroup*)newObject
{
    CustomSurveyGroup *csg = [CustomSurveyGroup new];
    return csg;
}

+ (CustomSurveyGroup*)createObjectFromDictionary:(NSDictionary*)dicData
{
    CustomSurveyGroup *csg = [CustomSurveyGroup new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        //groupID
        csg.groupID = [keysList containsObject:CLASS_CUSTOMSURVEYGROUP_KEY_ID] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYGROUP_KEY_ID] longValue] : csg.groupID;
        
        //order
        csg.order = [keysList containsObject:CLASS_CUSTOMSURVEYGROUP_KEY_ORDER] ? [[neoDic  valueForKey:CLASS_CUSTOMSURVEYGROUP_KEY_ORDER] longValue] : csg.order;
        
        //name
        csg.name = [keysList containsObject:CLASS_CUSTOMSURVEYGROUP_KEY_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYGROUP_KEY_NAME]] : csg.name;
        
        //imageURL
        csg.imageURL = [keysList containsObject:CLASS_CUSTOMSURVEYGROUP_KEY_IMAGEURL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYGROUP_KEY_IMAGEURL]] : csg.imageURL;
        
        //headerMessage
        csg.headerMessage = [keysList containsObject:CLASS_CUSTOMSURVEYGROUP_KEY_HEADER] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYGROUP_KEY_HEADER]] : csg.headerMessage;
        
        //footerMessage
        csg.footerMessage = [keysList containsObject:CLASS_CUSTOMSURVEYGROUP_KEY_FOOTER] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_CUSTOMSURVEYGROUP_KEY_FOOTER]] : csg.footerMessage;
        
        //questions
        csg.questions = [NSMutableArray new];
        if ([keysList containsObject:CLASS_CUSTOMSURVEYGROUP_KEY_QUESTIONS]){
            if ([[neoDic objectForKey:CLASS_CUSTOMSURVEYGROUP_KEY_QUESTIONS] isKindOfClass:[NSArray class]]){
                NSArray *a = [neoDic objectForKey:CLASS_CUSTOMSURVEYGROUP_KEY_QUESTIONS];
                for (NSDictionary *dic in a){
                    [csg.questions addObject:[CustomSurveyQuestion createObjectFromDictionary:dic]];
                }
            }
            //order:
            if (csg.questions.count > 0){
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                csg.questions = [[NSMutableArray alloc] initWithArray:[csg.questions sortedArrayUsingDescriptors:sortDescriptors]];
            }
        }
        
        //image
    }
    
    return csg;
}

- (CustomSurveyGroup*)copyObject
{
    CustomSurveyGroup *copy = [CustomSurveyGroup new];
    //
    copy.groupID = self.groupID;
    copy.order = self.order;
    copy.name = self.name ? [NSString stringWithFormat:@"%@", self.name] : nil;
    copy.imageURL = self.imageURL ? [NSString stringWithFormat:@"%@", self.imageURL] : nil;
    copy.headerMessage = self.headerMessage ? [NSString stringWithFormat:@"%@", self.headerMessage] : nil;
    copy.footerMessage = self.footerMessage ? [NSString stringWithFormat:@"%@", self.footerMessage] : nil;
    copy.questions = [NSMutableArray new];
    copy.image = self.image ? [UIImage imageWithData:UIImagePNGRepresentation(self.image)] : nil;
    //
    if (self.questions != nil){
        for (CustomSurveyQuestion *question in self.questions){
            [copy.questions addObject:[question copyObject]];
        }
    }else{
        copy.questions = nil;
    }
    //
    return copy;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(groupID) forKey:CLASS_CUSTOMSURVEYGROUP_KEY_ID];
    [dicData setValue:@(order) forKey:CLASS_CUSTOMSURVEYGROUP_KEY_ORDER];
    [dicData setValue:(self.name ? self.name : @"") forKey:CLASS_CUSTOMSURVEYGROUP_KEY_NAME];
    [dicData setValue:(self.imageURL ? self.imageURL : @"") forKey:CLASS_CUSTOMSURVEYGROUP_KEY_IMAGEURL];
    [dicData setValue:(self.headerMessage ? self.headerMessage : @"") forKey:CLASS_CUSTOMSURVEYGROUP_KEY_HEADER];
    [dicData setValue:(self.footerMessage ? self.footerMessage : @"") forKey:CLASS_CUSTOMSURVEYGROUP_KEY_FOOTER];
    //
    if (self.questions != nil){
        NSMutableArray *list = [NSMutableArray new];
        for (CustomSurveyQuestion *question in self.questions){
            [list addObject:[question dictionaryJSON]];
        }
        [dicData setValue:list forKey:CLASS_CUSTOMSURVEYGROUP_KEY_QUESTIONS];
    }else{
        [dicData setValue:[NSArray new] forKey:CLASS_CUSTOMSURVEYGROUP_KEY_QUESTIONS];
    }
    //
    return dicData;
}

- (NSDictionary*)reducedJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(groupID) forKey:CLASS_CUSTOMSURVEYGROUP_KEY_ID];
    if (self.questions != nil){
        NSMutableArray *list = [NSMutableArray new];
        for (CustomSurveyQuestion *question in self.questions){
            [list addObject:[question reducedJSON]];
        }
        [dicData setValue:list forKey:CLASS_CUSTOMSURVEYGROUP_KEY_QUESTIONS];
    }
    //
    return dicData;
}

@end
