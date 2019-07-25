//
//  VC_ChatList.h
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 05/12/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "ViewControllerModel.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_ContactsChat : ViewControllerModel<UITableViewDelegate, UITableViewDataSource>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, weak) IBOutlet UITableView *tbvChatList;
@property (nonatomic, strong) NSMutableArray *chatSpeaker;
@property (nonatomic, strong) NSMutableArray *chatGroup;
@property (nonatomic, strong) NSMutableArray *chatPerson;
@property BOOL isMenuSelection;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
