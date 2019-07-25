//
//  VC_Chat.h
//  AHK-100anos
//
//  Created by Erico GT on 11/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "User.h"
#import "Event.h"
#import "GroupChat.h"
#import "ChatMessage.h"
#import "TVC_ChatMessage.h"
#import "SectionItemList.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES
typedef enum {eChatScreenType_Single, eChatScreenType_Group} enumChatScreenType;

#pragma mark - • INTERFACE
@interface VC_Chat : UIViewController<UITableViewDelegate, UITableViewDataSource, ConnectionManagerDelegate, UITextViewDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, assign) enumChatScreenType chatType;
@property(nonatomic, strong) User *outerUser;
@property(nonatomic, strong) GroupChat *receiverGroup;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
