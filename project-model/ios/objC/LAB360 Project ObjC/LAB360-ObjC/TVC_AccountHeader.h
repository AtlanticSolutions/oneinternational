//
//  TVC_AccountHeader.h
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 10/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_AccountHeader : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *btnPhoto;

- (void)updateLayout;

@end
