//
//  FloatingPickerElement.h
//  LAB360-ObjC
//
//  Created by Erico GT on 17/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloatingPickerElement : NSObject

//Properties
@property(nonatomic, strong) NSMutableDictionary *auxiliarData;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) BOOL selected;
@property(nonatomic, assign) NSInteger tagID;
@property(nonatomic, assign) NSInteger associatedEnum;

+ (FloatingPickerElement*)newElementWithTitle:(NSString*)title selection:(BOOL)selected tagID:(NSInteger)tag enum:(NSInteger)aEnum andData:(NSMutableDictionary*)auxData;

@end
