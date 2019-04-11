//
//  FloatingPickerElement.m
//  LAB360-ObjC
//
//  Created by Erico GT on 17/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "FloatingPickerElement.h"

@implementation FloatingPickerElement

@synthesize auxiliarData, title, selected, tagID, associatedEnum;

- (instancetype)init
{
    self = [super init];
    if (self) {
        auxiliarData = [NSMutableDictionary new];
        title = @"";
        selected = NO;
        tagID = 0;
        associatedEnum = 0;
    }
    return self;
}

+ (FloatingPickerElement*)newElementWithTitle:(NSString*)title selection:(BOOL)selected tagID:(NSInteger)tag enum:(NSInteger)aEnum andData:(NSMutableDictionary*)auxData;
{
    FloatingPickerElement* element = [FloatingPickerElement new];
    element.title = title;
    element.selected = selected;
    element.auxiliarData = auxData;
    element.tagID = tag;
    element.associatedEnum = aEnum;
    //
    return element;
}

@end
