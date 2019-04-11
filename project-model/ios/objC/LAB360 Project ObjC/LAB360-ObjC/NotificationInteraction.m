//
//  NotificationInteraction.m
//  GS&MD
//
//  Created by Erico on 20/01/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "NotificationInteraction.h"

@implementation NotificationInteraction

@synthesize notificationID, title, userMessage, category, action, isFeedback;

- (NotificationInteraction*)init
{
    self = [super init];
    if (self)
    {
        notificationID = 0;
        title = nil;
        userMessage = nil;
        category = nil;
        action = nil;
        isFeedback = false;
    }
    return self;
}

@end
