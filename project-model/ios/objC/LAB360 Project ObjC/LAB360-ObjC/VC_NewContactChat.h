//
//  VC_NewChat.h
//  GS&MD
//
//  Created by Lucas Correia on 05/12/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_NewContactChat : UIViewController<UITableViewDelegate, UITableViewDataSource>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) NSMutableArray *chatList;
@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, strong) NSMutableArray *paramList;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
