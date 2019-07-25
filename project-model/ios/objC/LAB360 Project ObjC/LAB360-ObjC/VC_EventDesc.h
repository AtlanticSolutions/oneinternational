//
//  VC_EventDesc.h
//  AHKHelper
//
//  Created by Lucas Correia on 12/10/16.
//  Copyright © 2016 Lucas Correia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TVC_EventSubscribe.h"
#import "TVC_EventFourOptions.h"
#import "TVC_EventDescription.h"
#import "TVC_SponsorsCollection.h"
#import "Event.h"
#import "VC_EventSubscribe.h"
#import "VC_DownloadsList.h"

@interface VC_EventDesc : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Event* event;
@end
