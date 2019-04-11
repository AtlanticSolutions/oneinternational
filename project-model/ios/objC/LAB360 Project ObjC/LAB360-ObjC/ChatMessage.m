//
//  ChatMessage.m
//  AHK-100anos
//
//  Created by Erico GT on 11/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "ChatMessage.h"

#define CLASS_CHAT_DEFAULT @"chatMessage"
#define CLASS_CHAT_MESSAGE_ID @"id"
#define CLASS_CHAT_USER_ID @"senderId"
#define CLASS_CHAT_USER_NAME @"senderName"
//
#define CLASS_CHAT_RECEIVER_USER_ID @"receiverId"
#define CLASS_CHAT_RECEIVER_GROUP_ID @"groupChatId"
#define CLASS_CHAT_NAME @"groupName"
#define CLASS_CHAT_MESSAGE @"message"
#define CLASS_CHAT_DATE @"sendDate"
#define CLASS_CHAT_STATUS @"status"
#define CLASS_CHAT_MESSAGE_TYPE @"type"
#define CLASS_CHAT_HASH @"hash"

@implementation ChatMessage

@synthesize messageID, userID, outerUserID, outerGroupID, chatName, userName, message, date, messageStatus, hash, messageType;
@synthesize auxAlert;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        messageID = DOMP_OPD_INT;
        userID = DOMP_OPD_INT;
        outerUserID = DOMP_OPD_INT;
        outerGroupID = DOMP_OPD_INT;
        chatName = DOMP_OPD_STRING;
        userName = DOMP_OPD_STRING;
        message = DOMP_OPD_STRING;
        date = DOMP_OPD_DATE;
        messageStatus = eChatMessageStatus_Undefined;
        messageType = eChatMessageType_Undefined;
        hash = DOMP_OPD_STRING;
		auxAlert = nil;
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------


+(ChatMessage*)newObject
{
    ChatMessage *cm = [ChatMessage new];
    return cm;
}

+(NSString*)className
{
    return CLASS_CHAT_DEFAULT;
}

+(ChatMessage*)createObjectFromDictionary:(NSDictionary*)dicData
{
    ChatMessage *cm = [ChatMessage new];
    
    //NSDictionary *dic = [dicData valueForKey:[Event className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        cm.messageID = [keysList containsObject:CLASS_CHAT_MESSAGE_ID] ? [[neoDic valueForKey:CLASS_CHAT_MESSAGE_ID] intValue] : cm.messageID;
        cm.userID = [keysList containsObject:CLASS_CHAT_USER_ID] ? [[neoDic valueForKey:CLASS_CHAT_USER_ID] intValue] : cm.userID;
        cm.outerUserID = [keysList containsObject:CLASS_CHAT_RECEIVER_USER_ID] ? [[neoDic valueForKey:CLASS_CHAT_RECEIVER_USER_ID] intValue] : cm.outerUserID;
        cm.outerGroupID = [keysList containsObject:CLASS_CHAT_RECEIVER_GROUP_ID] ? [[neoDic valueForKey:CLASS_CHAT_RECEIVER_GROUP_ID] intValue] : cm.outerGroupID;
        cm.chatName = [keysList containsObject:CLASS_CHAT_NAME] ? [[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_CHAT_NAME]] stringByRemovingPercentEncoding] : cm.chatName;
        cm.userName = [keysList containsObject:CLASS_CHAT_USER_NAME] ? [[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_CHAT_USER_NAME]] stringByRemovingPercentEncoding] : cm.userName;
        cm.message = [keysList containsObject:CLASS_CHAT_MESSAGE] ? [[NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_CHAT_MESSAGE]] stringByRemovingPercentEncoding] : cm.message;
        //
        NSTimeInterval timeInterval = [keysList containsObject:CLASS_CHAT_DATE] ? [[neoDic valueForKey:CLASS_CHAT_DATE] doubleValue] : 0;
        cm.date = timeInterval > 0 ? [ToolBox dateHelper_DateFromTimeStamp:(timeInterval / 1000)] : nil;
        //
        cm.messageStatus = [keysList containsObject:CLASS_CHAT_STATUS] ? [[neoDic valueForKey:CLASS_CHAT_STATUS] intValue] : cm.messageStatus;
        cm.messageType = [keysList containsObject:CLASS_CHAT_MESSAGE_TYPE] ? [[neoDic valueForKey:CLASS_CHAT_MESSAGE_TYPE] intValue] : cm.messageType;
        cm.hash = [keysList containsObject:CLASS_CHAT_HASH] ? [NSString stringWithFormat:@"%@", [neoDic valueForKey:CLASS_CHAT_HASH]] : cm.hash;
        
        NSLog(@"%@", neoDic);
    }
    
    return cm;
}

-(ChatMessage*)copyObject
{
    ChatMessage *cm = [ChatMessage new];
    cm.messageID = messageID;
    cm.userID = userID;
    cm.outerUserID = outerUserID;
    cm.outerGroupID = outerGroupID;
    cm.chatName = [NSString stringWithFormat:@"%@", chatName];
    cm.userName = [NSString stringWithFormat:@"%@", userName];
    cm.message = [NSString stringWithFormat:@"%@", message];
    cm.date = (date==nil) ? nil : [[NSDate alloc] initWithTimeInterval:0 sinceDate:date];
    cm.messageStatus  = messageStatus;
    cm.messageType = messageType;
    cm.hash = [NSString stringWithFormat:@"%@", hash];
	//
	if (self.auxAlert != nil){
		cm.auxAlert = [AuxAlertMessage new];
		cm.auxAlert.showInScreen = self.auxAlert.showInScreen;
		cm.auxAlert.targetName = self.auxAlert.targetName != nil ? [NSString stringWithFormat:@"%@", self.auxAlert.targetName] : nil;
	}
    return cm;
}

-(NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setValue:@(messageID) forKey:CLASS_CHAT_MESSAGE_ID];
    [dic setValue:@(userID) forKey:CLASS_CHAT_USER_ID];
    [dic setValue:@(outerUserID) forKey:CLASS_CHAT_RECEIVER_USER_ID];
    [dic setValue:@(outerGroupID) forKey:CLASS_CHAT_RECEIVER_GROUP_ID];
    [dic setValue:chatName forKey:CLASS_CHAT_NAME];
    [dic setValue:userName forKey:CLASS_CHAT_USER_NAME];
    [dic setValue:message forKey:CLASS_CHAT_MESSAGE];
    [dic setValue:[ToolBox dateHelper_StringFromDate:date withFormat:TOOLBOX_DATA_AHK_yyyyMMdd_HHmmss] forKey:CLASS_CHAT_DATE];
    [dic setValue:@(messageStatus) forKey:CLASS_CHAT_STATUS];
    [dic setValue:@(messageType) forKey:CLASS_CHAT_STATUS];
    [dic setValue:hash forKey:CLASS_CHAT_HASH];
    //
    return dic;
}

+ (NSString*)createHashForEvent:(int)eventID andUser:(int)userID
{
    NSString *e = [NSString stringWithFormat:@"%i", eventID];
    NSString *u = [NSString stringWithFormat:@"%i", userID];
    NSString *d = [ToolBox deviceHelper_IdentifierForVendor];
    NSString *t = [ToolBox dateHelper_TimeStampCompleteIOSfromDate:[NSDate date]];
    //
    return [ToolBox textHelper_HashSHA512forText:[NSString stringWithFormat:@"%@%@%@%@", e, u, d, t]];
}

@end
