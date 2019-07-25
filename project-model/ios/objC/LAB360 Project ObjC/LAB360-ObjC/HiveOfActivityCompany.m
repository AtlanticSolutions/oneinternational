//
//  RamoAtividadeEmpresa.m
//  AHK-100anos
//
//  Created by Erico GT on 10/24/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "HiveOfActivityCompany.h"



@implementation HiveOfActivityCompany

@synthesize code, name, selected;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        code = DOMP_OPD_INT;
        name = DOMP_OPD_STRING;
        selected = DOMP_OPD_BOOLEAN;
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------


+(HiveOfActivityCompany*)newObject
{
    HiveOfActivityCompany *ha = [HiveOfActivityCompany new];
    return ha;
}

+(NSString*)className
{
    return CLASS_HIVEOFACTIVITY_DEFAULT;
}

+(HiveOfActivityCompany*)createObjectFromDictionary:(NSDictionary*)dicData
{
    HiveOfActivityCompany *ha = [HiveOfActivityCompany new];
    
    //NSDictionary *dic = [dicData valueForKey:[HiveOfActivityCompany className]];
    
    NSArray *keysList = [dicData allKeys];
    
    if (keysList.count > 0)
    {
        ha.code = [keysList containsObject:CLASS_HIVEOFACTIVITY_CODE] ? [[dicData valueForKey:CLASS_HIVEOFACTIVITY_CODE] intValue] : ha.code;
        ha.name = [keysList containsObject:CLASS_HIVEOFACTIVITY_NAME] ? [NSString stringWithFormat:@"%@", [dicData valueForKey:CLASS_HIVEOFACTIVITY_NAME]] : ha.name;
    }
    
    return ha;
}

-(HiveOfActivityCompany*)copyObject
{
    HiveOfActivityCompany *ha = [HiveOfActivityCompany new];
    ha.code = code;
    ha.name = [NSString stringWithFormat:@"%@", name];
    return ha;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setValue:@(code) forKey:CLASS_HIVEOFACTIVITY_CODE];
    [dic setValue:name forKey:CLASS_HIVEOFACTIVITY_NAME];
    return dic;
}



@end




