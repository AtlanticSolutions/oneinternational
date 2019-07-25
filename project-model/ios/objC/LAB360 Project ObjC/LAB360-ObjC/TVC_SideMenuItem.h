//
//  TVC_SideMenuItem.h
//  AHK-100anos
//
//  Created by Erico GT on 10/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_SideMenuItem : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblItem;
@property (nonatomic, weak) IBOutlet UILabel *lblFeature;
@property (nonatomic, weak) IBOutlet UILabel *lblBadge;
@property (nonatomic, weak) IBOutlet UIImageView *imvFlag;
@property (nonatomic, weak) IBOutlet UIImageView *imvLine;
@property (nonatomic, weak) IBOutlet UIImageView *imvIcon;
//
@property (nonatomic, weak) IBOutlet UIImageView *imvShortcut;

- (void)updateLayoutWithImage:(UIImage*)iconImage highlighted:(BOOL)highlighted;

@end
