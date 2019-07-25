//
//  TVC_SideMenuFooter.h
//  AHK-100anos
//
//  Created by Erico GT on 10/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_SideMenuFooter : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UILabel *lblDev;
@property (nonatomic, weak) IBOutlet UILabel *lblVersion;

- (void)updateLayout;

@end
