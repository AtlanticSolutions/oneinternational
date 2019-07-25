//
// GroupChat.h
// GS&MD
//
// Created by Lucas Correia on 2016/12/05 19:03:45 -0200.
// Copyright (c) Atlantic Solutions. All rights reserved.
//
// Note: Classe para representação do objeto de dados do Grupo de Chat do projeto GSMD.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DefaultObjectModelProtocol.h"

@interface GroupChat : NSObject<DefaultObjectModelProtocol>

//Properties
@property(nonatomic, assign) int groupId;
@property(nonatomic, strong) NSString* groupName;

//Protocol Methods
//@required
+(GroupChat*)newObject;
+(NSString*)className;
+(GroupChat*)createObjectFromDictionary:(NSDictionary*)dicData;
-(NSDictionary*)dictionaryJSON;

//@optional
-(GroupChat*)copyObject;
-(bool)isEqualToObject:(id)object;
-(void)defaultObject;
-(void)updateObjectFromJSON:(NSDictionary*)dictionaryData reseting:(bool)reset;
@end
