//
//  TVC_DownloadItem.h
//  AHK-100anos
//
//  Created by Erico GT on 10/17/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_DownloadItem : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblInfo;
@property (nonatomic, weak) IBOutlet UIImageView *imvLine;
@property (nonatomic, weak) IBOutlet UIImageView *imvArrow;

- (void)updateLayout;

@end
