//
//  TVC_EventSubscribe.h
//  AHKHelper
//
//  Created by Lucas Correia on 12/10/16.
//  Copyright © 2016 Lucas Correia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_EventSubscribe : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton* btnSubscribe;
@property (nonatomic, weak) IBOutlet UIButton* btnDownloads;
@property (nonatomic, weak) IBOutlet UIImageView* imvLine;

- (void) updateLayout;

@end
