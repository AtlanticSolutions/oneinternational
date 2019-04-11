//
//  VC_MyEvents.h
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 24/11/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "ViewControllerModel.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_MyEvents : ViewControllerModel<UITableViewDelegate, UITableViewDataSource, JTCalendarDelegate, ConnectionManagerDelegate>

#pragma mark - • PUBLIC PROPERTIES

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
