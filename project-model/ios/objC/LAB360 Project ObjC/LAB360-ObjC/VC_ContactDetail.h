//
//  VC_ContactDetail.h
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 25/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "AppDelegate.h"
#import "TVC_AssociateShare.h"
#import "TVC_EventDescription.h"
#import "TVC_ProfileImage.h"

@interface VC_ContactDetail : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tbvDetail;
@property (nonatomic, strong) Contact *selectedContact;

@end
