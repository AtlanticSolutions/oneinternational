//
//  ChatMessage.h
//  AHK-100anos
//
//  Created by Erico GT on 11/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultObjectModelProtocol.h"
#import "AuxAlertMessage.h"
#import "ToolBox.h"

@interface ChatMessage : NSObject<DefaultObjectModelProtocol>

typedef enum {eChatMessageStatus_Undefined, eChatMessageStatus_Sending, eChatMessageStatus_OK, eChatMessageStatus_Error} enumChatMessageStatus;
typedef enum {eChatMessageType_Undefined, eChatMessageType_Single, eChatMessageType_Group} enumChatMessageType;

//Properties
@property (nonatomic, assign) int messageID;
@property (nonatomic, assign) int userID;
@property (nonatomic, assign) int outerUserID;
@property (nonatomic, assign) int outerGroupID;
@property (nonatomic, strong) NSString *chatName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) enumChatMessageStatus messageStatus;
@property (nonatomic, assign) enumChatMessageType messageType;
@property (nonatomic, strong) NSString *hash;
//
@property (nonatomic, strong) AuxAlertMessage *auxAlert;

//Protocol Methods
+(ChatMessage*)newObject;
+(NSString*)className;
+(ChatMessage*)createObjectFromDictionary:(NSDictionary*)dicData;
-(ChatMessage*)copyObject;
-(NSDictionary*)dictionaryJSON;

//Others
+ (NSString*)createHashForEvent:(int)eventID andUser:(int)userID;

@end


