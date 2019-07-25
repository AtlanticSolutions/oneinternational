//
//  TVC_AccountFooter.h
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 10/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_AccountFooter : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *btnSave;

-(void) updateLayout;

@end
