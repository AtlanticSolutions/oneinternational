//
//  VC_ContactList.h
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 24/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "TVC_AssociateItem.h"
#import "VC_ContactDetail.h"
#import "Contact.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_ContactList : UIViewController<UITableViewDelegate, UITableViewDataSource, ConnectionManagerDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) NSMutableArray *departmentList;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
