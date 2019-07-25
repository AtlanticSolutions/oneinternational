//
//  VC_SideMenu.h
//  AHK-100anos
//
//  Created by Erico GT on 10/4/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "SideMenuConfig.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

@class VC_SideMenu;

#pragma mark - • PROTOCOL

@protocol SideMenuDelegate <NSObject>
@required
- (int)sideMenu:(VC_SideMenu*)menu dynamicBadgeValueForItem:(SideMenuItem*)item;
@optional
- (void)sideMenuDidShow:(VC_SideMenu*)menu;
- (void)sideMenuDidHide:(VC_SideMenu*)menu;
//
- (void)sideMenu:(VC_SideMenu*)menu barButtonsForRegisteredConfiguration:(NSArray<UIBarButtonItem*>*)items;
@end

#pragma mark - • INTERFACE
@interface VC_SideMenu : UIViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, weak) id<SideMenuDelegate> menuDelegate;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS
- (void)show;
- (void)registerConfiguration:(SideMenuConfig*)config;
- (void)updateConfigurationsFromServer;
//
- (void)createBarButtonsForRegisteredConfiguration;

//Para aplicativos cujo menu não seja dinâmico (verificar os items para exibição manualmente):
- (void)createCompleteMenu;

@end
