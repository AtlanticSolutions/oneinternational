//
//  VC_DropList.h
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 07/11/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "HiveOfActivityCompany.h"
#import "User.h"
#import "TVC_AssociateItem.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES
@protocol DropListProtocol <NSObject>
@optional
- (void)dropListProtocolDidSelectItem:(NSString*)itemText atIndex:(long)itemIndex;
@end

#pragma mark - • INTERFACE
@interface VC_DropList : UIViewController<UITableViewDelegate, UITableViewDataSource>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, weak) IBOutlet UITableView *tbvDrop;
@property (nonatomic, strong) NSArray<NSString*>* dropList;
@property (nonatomic, strong) NSArray<NSDictionary*>* userDropList;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) Boolean isState;
@property (nonatomic, strong) NSString *screenTitle;
//
@property (nonatomic, weak) UIViewController<DropListProtocol> *dropListDelegate;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
