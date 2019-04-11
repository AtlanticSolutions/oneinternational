//
//  LabBeacon.m
//  LAB360-ObjC
//
//  Created by Erico GT on 09/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "LaBeacon.h"

#define CLASS_LABBEACON_DEFAULT @"beacon"
#define CLASS_LABBEACON_ID @"id"
#define CLASS_LABBEACON_NAME @"name"
#define CLASS_LABBEACON_PROXIMITY_UUID @"proximity_uuid"
#define CLASS_LABBEACON_MINOR @"minor"
#define CLASS_LABBEACON_MAJOR @"major"
#define CLASS_LABBEACON_CURRENT_MOTION_STATE @"current_motion_state"
#define CLASS_LABBEACON_SKU @"sku"
#define CLASS_LABBEACON_TAGID @"tag_id"
#define CLASS_LABBEACON_TRACKING_DISTANCE @"tracking_distance"
#define CLASS_LABBEACON_TYPE @"type_beacon"
#define CLASS_LABBEACON_ESTIMOTE_TYPE @"estimote_type"
#define CLASS_LABBEACON_ENTRY_MESSAGE @"entry_message"
#define CLASS_LABBEACON_LEAVE_MESSAGE @"leave_message"
//
#define CLASS_LABBEACON_ALERT_ENTER @"enter_region_notification_enabled"
#define CLASS_LABBEACON_ALERT_EXIT @"exit_region_notification_enabled"
//
#define CLASS_LABBEACON_SHOWROOMID @"showroom_id"
#define CLASS_LABBEACON_SHELFID @"shelf_id"

//"app_id" = 1000012;
//"current_motion_state" = 10;
//"entry_message" = "Bem Vindo a LAB360!!!! Beacon 04.";
//id = 1;
//"leave_message" = " ";
//major = 19018;
//minor = 63363;
//name = "Beacon 04";
//"proximity_uuid" = "F5EE50F5-DF25-4EA9-9949-B45E7D9B0CB6";
//sku = "<null>";
//"tag_id" = "<null>";
//"tracking_distance" = "7.0";
//"type_beacon" = 1;


@implementation LaBeacon

@synthesize name, proximityUUID, major, minor, beaconID, entryMessage, leaveMessage, lastEntryReportDate, lastExitReportDate, currentMotionState, sku, tagID, trackingDistance, type, estimoteType, adAliveAction, estimoteBeaconData;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        beaconID = DOMP_OPD_INT;
        name = DOMP_OPD_STRING;
        proximityUUID = DOMP_OPD_STRING;
        major = DOMP_OPD_STRING;
        minor = DOMP_OPD_STRING;
        currentMotionState = DOMP_OPD_INT;
        entryMessage = DOMP_OPD_STRING;
        leaveMessage = DOMP_OPD_STRING;
        lastEntryReportDate = nil;
        lastExitReportDate = nil;
        sku = DOMP_OPD_STRING;
        tagID = DOMP_OPD_STRING;
        trackingDistance = DOMP_OPD_STRING;
        type = DOMP_OPD_STRING;
        estimoteType = DOMP_OPD_STRING;
        //
        adAliveAction = nil;
        estimoteBeaconData = nil;
    }
    
    return self;
}

-(NSUUID* _Nullable) nsuuid
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:proximityUUID];
    return uuid;
}

-(NSString* _Nonnull) codificator
{
    return [NSString stringWithFormat:@"beacon%li", self.beaconID];
}

#pragma mark - Delegate

+ (LaBeacon* _Nullable)newObject
{
    LaBeacon *b = [LaBeacon new];
    return b;
}

+ (NSString* _Nonnull)className
{
    return CLASS_LABBEACON_DEFAULT;
}

+ (LaBeacon* _Nonnull)createObjectFromDictionary:(NSDictionary* _Nonnull)dicData
{
    LaBeacon *b = [LaBeacon new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        b.beaconID = [keysList containsObject:CLASS_LABBEACON_ID] ? [[neoDic  valueForKey:CLASS_LABBEACON_ID] longValue] : b.beaconID;
        b.name = [keysList containsObject:CLASS_LABBEACON_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_LABBEACON_NAME]] : b.name;
        b.proximityUUID = [keysList containsObject:CLASS_LABBEACON_PROXIMITY_UUID] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_LABBEACON_PROXIMITY_UUID]] : b.proximityUUID;
        b.major = [keysList containsObject:CLASS_LABBEACON_MAJOR] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_LABBEACON_MAJOR]] : b.major;
        b.minor = [keysList containsObject:CLASS_LABBEACON_MINOR] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_LABBEACON_MINOR]] : b.minor;
        b.currentMotionState = [keysList containsObject:CLASS_LABBEACON_CURRENT_MOTION_STATE] ? [[neoDic  valueForKey:CLASS_LABBEACON_CURRENT_MOTION_STATE] longValue] : b.currentMotionState;
        b.sku = [keysList containsObject:CLASS_LABBEACON_SKU] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_LABBEACON_SKU]] : b.sku;
        b.tagID = [keysList containsObject:CLASS_LABBEACON_TAGID] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_LABBEACON_TAGID]] : b.tagID;
        b.trackingDistance = [keysList containsObject:CLASS_LABBEACON_TRACKING_DISTANCE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_LABBEACON_TRACKING_DISTANCE]] : b.trackingDistance;
        b.type = [keysList containsObject:CLASS_LABBEACON_TYPE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_LABBEACON_TYPE]] : b.type;
        b.estimoteType = [keysList containsObject:CLASS_LABBEACON_ESTIMOTE_TYPE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_LABBEACON_ESTIMOTE_TYPE]] : b.estimoteType;
        b.entryMessage = [keysList containsObject:CLASS_LABBEACON_ENTRY_MESSAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_LABBEACON_ENTRY_MESSAGE]] : b.entryMessage;
        b.leaveMessage = [keysList containsObject:CLASS_LABBEACON_LEAVE_MESSAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_LABBEACON_LEAVE_MESSAGE]] : b.leaveMessage;
    }
    return b;
}

- (LaBeacon* _Nonnull)copyObject
{
    LaBeacon *b = [LaBeacon new];
    b.beaconID = beaconID;
    b.name = proximityUUID == nil ? nil : [NSString stringWithFormat:@"%@", name];
    b.proximityUUID = proximityUUID == nil ? nil : [NSString stringWithFormat:@"%@", proximityUUID];
    b.major = major == nil ? nil : [NSString stringWithFormat:@"%@", major];
    b.minor = minor == nil ? nil : [NSString stringWithFormat:@"%@", minor];
    b.currentMotionState = currentMotionState;
    b.sku = sku == nil ? nil : [NSString stringWithFormat:@"%@", sku];
    b.tagID = tagID == nil ? nil : [NSString stringWithFormat:@"%@", tagID];
    b.trackingDistance = trackingDistance == nil ? nil : [NSString stringWithFormat:@"%@", trackingDistance];
    b.type = type == nil ? nil : [NSString stringWithFormat:@"%@", type];
    b.estimoteType = estimoteType == nil ? nil : [NSString stringWithFormat:@"%@", estimoteType];
    b.entryMessage = entryMessage == nil ? nil : [NSString stringWithFormat:@"%@", entryMessage];
    b.leaveMessage = leaveMessage == nil ? nil : [NSString stringWithFormat:@"%@", leaveMessage];
    b.lastEntryReportDate = lastEntryReportDate == nil ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:lastEntryReportDate];
    b.lastExitReportDate = lastExitReportDate == nil ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:lastExitReportDate];
    //
    b.adAliveAction = adAliveAction == nil ? nil : [self.adAliveAction copyObject];
    //
    if (estimoteBeaconData){
        NSData* archivedData = [NSKeyedArchiver archivedDataWithRootObject:estimoteBeaconData];
        b.estimoteBeaconData = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:archivedData]];
    }
    return b;
}

- (NSDictionary* _Nonnull)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData setValue:@(beaconID) forKey:CLASS_LABBEACON_ID];
    [dicData setValue:(name == nil ? @"" : name) forKey:CLASS_LABBEACON_NAME];
    [dicData setValue:(proximityUUID == nil ? @"" : proximityUUID) forKey:CLASS_LABBEACON_PROXIMITY_UUID];
    [dicData setValue:(major == nil ? @"" : major) forKey:CLASS_LABBEACON_MAJOR];
    [dicData setValue:(minor == nil ? @"" : minor) forKey:CLASS_LABBEACON_MINOR];
    [dicData setValue:@(currentMotionState) forKey:CLASS_LABBEACON_CURRENT_MOTION_STATE];
    [dicData setValue:(sku == nil ? @"" : sku) forKey:CLASS_LABBEACON_SKU];
    [dicData setValue:(tagID == nil ? @"" : tagID) forKey:CLASS_LABBEACON_TAGID];
    [dicData setValue:(trackingDistance == nil ? @"" : trackingDistance) forKey:CLASS_LABBEACON_TRACKING_DISTANCE];
    [dicData setValue:(type == nil ? @"" : type) forKey:CLASS_LABBEACON_TYPE];
    [dicData setValue:(estimoteType == nil ? @"" : estimoteType) forKey:CLASS_LABBEACON_ESTIMOTE_TYPE];
    [dicData setValue:(entryMessage == nil ? @"" : entryMessage) forKey:CLASS_LABBEACON_ENTRY_MESSAGE];
    [dicData setValue:(leaveMessage == nil ? @"" : leaveMessage) forKey:CLASS_LABBEACON_LEAVE_MESSAGE];
    //
    return dicData;
}

- (bool)isEqualToObject:(LaBeacon* _Nullable)object
{
    //TODO:
    return false;
}

@end
