//
//  Event.m
//  AHKHelper
//
//  Created by Lucas Correia on 06/10/16.
//  Copyright © 2016 Lucas Correia. All rights reserved.
//

#import "Event.h"

#define CLASS_EVENT_DEFAULT @"event"
#define CLASS_EVENT_KEY_ID @"id"
#define CLASS_EVENT_KEY_TITLE @"name"
#define CLASS_EVENT_KEY_TYPE @"event_type"
#define CLASS_EVENT_KEY_SYNOPSIS @"description"
#define CLASS_EVENT_KEY_SCHEDULE @"schedule"
#define CLASS_EVENT_KEY_NAME_SPEAKER @"name_speacker"
#define CLASS_EVENT_KEY_DESC_SPEAKER @"description_speacker"
#define CLASS_EVENT_KEY_IMAGE_URL @"image_url"
#define CLASS_EVENT_KEY_SCHEDULE @"schedule"
#define CLASS_EVENT_KEY_LOCAL @"local"
#define CLASS_EVENT_KEY_LANGUAGE @"language"

@implementation Event

@synthesize eventID, title, type, synopsis, schedule, local, language, userRegistrationStatus, speakerDescription, speakerName, speakerPhotoURL;


//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {        
        eventID = DOMP_OPD_INT;
        title = DOMP_OPD_STRING;
        type = DOMP_OPD_STRING;
        synopsis = DOMP_OPD_STRING;
        schedule = DOMP_OPD_DATE;
        local = DOMP_OPD_STRING;
        language = DOMP_OPD_STRING;
		speakerPhotoURL = DOMP_OPD_STRING;
		speakerName = DOMP_OPD_STRING;
		speakerDescription = DOMP_OPD_STRING;
        userRegistrationStatus = eUserRegistrationStatus_Undefined;
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------


+(Event*)newObject
{
    Event *e = [Event new];
    return e;
}

+(NSString*)className
{
    return CLASS_EVENT_DEFAULT;
}

+(Event*)createObjectFromDictionary:(NSDictionary*)dicData
{
    Event *e = [Event new];
    
    //NSDictionary *dic = [dicData valueForKey:[Event className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        e.eventID = [keysList containsObject:CLASS_EVENT_KEY_ID] ? [[neoDic valueForKey:CLASS_EVENT_KEY_ID] intValue] : e.eventID;
        e.title = [keysList containsObject:CLASS_EVENT_KEY_TITLE] ? [ToolBox converterHelper_PlainStringFromHTMLString:[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_EVENT_KEY_TITLE]]] : e.title;
        e.type = [keysList containsObject:CLASS_EVENT_KEY_TYPE] ? [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_EVENT_KEY_TYPE]] : e.type;
        e.synopsis = [keysList containsObject:CLASS_EVENT_KEY_SYNOPSIS] ? [ToolBox converterHelper_PlainStringFromHTMLString:[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_EVENT_KEY_SYNOPSIS]]] : e.synopsis;
        e.schedule = [keysList containsObject:CLASS_EVENT_KEY_SCHEDULE] ? [ToolBox dateHelper_DateFromString:[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_EVENT_KEY_SCHEDULE]] withFormat:TOOLBOX_DATA_GSMD_yyyyMMdd_HHmmssSSS] : e.schedule;
        e.local = [keysList containsObject:CLASS_EVENT_KEY_LOCAL] ? [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_EVENT_KEY_LOCAL]] : e.local;
		e.speakerDescription = [keysList containsObject:CLASS_EVENT_KEY_DESC_SPEAKER] ? [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_EVENT_KEY_DESC_SPEAKER]] : e.speakerDescription;
		e.speakerName = [keysList containsObject:CLASS_EVENT_KEY_NAME_SPEAKER] ? [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_EVENT_KEY_NAME_SPEAKER]] : e.speakerName;
		e.speakerPhotoURL = [keysList containsObject:CLASS_EVENT_KEY_IMAGE_URL] ? [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_EVENT_KEY_IMAGE_URL]] : e.speakerPhotoURL;
        e.language = [keysList containsObject:CLASS_EVENT_KEY_LANGUAGE] ? [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_EVENT_KEY_LANGUAGE]] : e.language;
        //
        e.userRegistrationStatus = eUserRegistrationStatus_Undefined;
        
    }
    
    return e;
}

-(Event*)copyObject
{
    Event *e = [Event new];
    e.eventID = eventID;
    e.title = [NSString stringWithFormat:@"%@", title];
    e.type = [NSString stringWithFormat:@"%@", type];
    e.synopsis = [NSString stringWithFormat:@"%@", synopsis];
    e.schedule = (schedule==nil) ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:schedule];
    e.local = [NSString stringWithFormat:@"%@", local];
	e.speakerName = [NSString stringWithFormat:@"%@", speakerName];
	e.speakerDescription = [NSString stringWithFormat:@"%@", speakerDescription];
	e.speakerPhotoURL = [NSString stringWithFormat:@"%@", speakerPhotoURL];
    e.language = [NSString stringWithFormat:@"%@", language];
    e.userRegistrationStatus = userRegistrationStatus;
    return e;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setValue:@(eventID) forKey:CLASS_EVENT_KEY_ID];
    [dic setValue:title forKey:CLASS_EVENT_KEY_TITLE];
    [dic setValue:type forKey:CLASS_EVENT_KEY_TYPE];
	[dic setValue:speakerDescription forKey:CLASS_EVENT_KEY_NAME_SPEAKER];
	[dic setValue:speakerName forKey:CLASS_EVENT_KEY_DESC_SPEAKER];
	[dic setValue:speakerPhotoURL forKey:CLASS_EVENT_KEY_IMAGE_URL];
    [dic setValue:synopsis forKey:CLASS_EVENT_KEY_SYNOPSIS];
    [dic setValue:[ToolBox dateHelper_StringFromDate:schedule withFormat:TOOLBOX_DATA_AHK_yyyyMMdd_HHmmss] forKey:CLASS_EVENT_KEY_SCHEDULE];
    [dic setValue:local forKey:CLASS_EVENT_KEY_LOCAL];
    [dic setValue:language forKey:CLASS_EVENT_KEY_LANGUAGE];//
    //userRegistrationStatus ignorado.
    
    return dic;
}



@end
