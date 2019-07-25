//
//  TVC_ChatMessage.h
//  AHK-100anos
//
//  Created by Erico GT on 11/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_ChatMessage : UITableViewCell

typedef enum {eChatMessageSender_Self, eChatMessageSender_Other} enumChatMessageSender;

@property(nonatomic, weak) IBOutlet UIImageView *imvBackground;
@property(nonatomic, weak) IBOutlet UIImageView *imvBackName;
@property(nonatomic, weak) IBOutlet UIImageView *imvIcon;
@property(nonatomic, weak) IBOutlet UILabel *lblDate;
@property(nonatomic, weak) IBOutlet UILabel *lblUser;
@property(nonatomic, weak) IBOutlet UILabel *lblMessage;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;

- (void)updateLayoutForSender:(enumChatMessageSender)sender withActivity:(enumChatMessageStatus)messageStatus;

@end
