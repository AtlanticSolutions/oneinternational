//
//  CustomSurveyCollectionElement.m
//  LAB360-ObjC
//
//  Created by Erico GT on 09/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyCollectionElement.h"

@implementation CustomSurveyCollectionElement

@synthesize type, group, question, answer, referenceIndexPath;

- (instancetype)init
{
    self = [super init];
    if (self) {
        type = SurveyCollectionElementGeneric;
        group = nil;
        question = nil;
        answer = nil;
        //
        referenceIndexPath = nil;
    }
    return self;
}

@end
