//
//  VC_EventSubscribe.h
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 17/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "User.h"
#import "SubscribedUser.h"
#import "AppDelegate.h"
#import "TVC_AccountBody.h"
#import "TVC_AccountFooter.h"

@interface VC_EventSubscribe : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ConnectionManagerDelegate>

@property (nonatomic, strong) Event *event;

@end
