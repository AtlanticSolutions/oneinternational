//
//  VC_DownloadsList.h
//  AHK-100anos
//
//  Created by Erico GT on 10/17/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "Event.h"
#import "ViewControllerModel.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES
typedef enum {eDownloadListType_Undefined=0, eDownloadListType_UserFiles=1, eDownloadListType_EventFiles=2, eDownloadListType_MasterEventFiles=3} enumDownloadListType;

#pragma mark - • INTERFACE
@interface VC_DownloadsList : ViewControllerModel<UITableViewDelegate, UITableViewDataSource, ConnectionManagerDelegate, QLPreviewControllerDataSource>

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, assign) enumDownloadListType menuType;
@property(nonatomic, strong) Event *event;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
