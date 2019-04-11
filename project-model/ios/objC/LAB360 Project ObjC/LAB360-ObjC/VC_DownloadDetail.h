//
//  VC_DownloadDetail.h
//  AHK-100anos
//
//  Created by Erico GT on 10/19/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "DownloadItem.h"
#import "TVC_EventDescription.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_DownloadDetail : UIViewController<UITableViewDelegate, UITableViewDataSource, ConnectionManagerDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) DownloadItem *fileSelected;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
