//
//  RamoAtividadeEmpresa.h
//  AHK-100anos
//
//  Created by Erico GT on 10/24/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultObjectModelProtocol.h"
#import "ToolBox.h"

#define CLASS_HIVEOFACTIVITY_DEFAULT @"RamoAtividade"
#define CLASS_HIVEOFACTIVITY_CODE @"id"
#define CLASS_HIVEOFACTIVITY_NAME @"name"

@interface HiveOfActivityCompany : NSObject<DefaultObjectModelProtocol>

@property (nonatomic, assign) int code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL selected;

//Protocol Methods
+(HiveOfActivityCompany*)newObject;
+(NSString*)className;
+(HiveOfActivityCompany*)createObjectFromDictionary:(NSDictionary*)dicData;
-(HiveOfActivityCompany*)copyObject;
-(NSDictionary*)dictionaryJSON;

@end
