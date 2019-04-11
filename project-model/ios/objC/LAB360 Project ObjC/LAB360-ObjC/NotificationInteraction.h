//
//  NotificationInteraction.h
//  GS&MD
//
//  Created by Erico on 20/01/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationInteraction : NSObject

@property (nonatomic, assign) long notificationID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *userMessage;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, assign) bool isFeedback;

@end
