//
//  MessageNotificationView.h
//  AHK-100anos
//
//  Created by Erico GT on 11/14/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ChatMessage.h"
#import "VC_Chat.h"
//
#import "ProductViewController.h"

@interface MessageNotificationView : UIView

@property(nonatomic, weak) IBOutlet UIView *contentView;
@property(nonatomic, weak) IBOutlet UIImageView *imvIcon;
@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UILabel *lblMessage;

- (void)configureLayout;
- (void)showMessageNotificationWithTitle:(NSString*)title andMessage:(NSString*)message object:(ChatMessage*)messageObject;

@end
