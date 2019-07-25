//
//  CustomSurveyGeralFormVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 09/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "ViewControllerModel.h"
#import "CustomSurveyCollectionElement.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE
@interface CustomSurveyGeralFormVC : ViewControllerModel

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) CustomSurvey *survey;
@property (nonatomic, assign) long groupIndex;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
