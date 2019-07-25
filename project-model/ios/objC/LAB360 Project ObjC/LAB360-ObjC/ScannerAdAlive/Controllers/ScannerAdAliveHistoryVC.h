//
//  ScannerAdAliveHistoryVC.h
//  
//
//  Created by Erico GT on 07/06/18.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "ViewControllerModel.h"
#import "AdAliveScannerTargetManager.h"
#import "ScannerTargetHistoryTVC.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • PROTOCOLS

#pragma mark - • INTERFACE
@interface ScannerAdAliveHistoryVC : ViewControllerModel<UITableViewDelegate, UITableViewDataSource>

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, strong) AdAliveScannerTargetManager *targetManager;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
