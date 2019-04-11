//
//  TVC_DayEventItem.h
//  AHK-100anos
//
//  Created by Erico GT on 10/13/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_DayEventItem : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblHourStart;
@property (nonatomic, weak) IBOutlet UILabel *lblHourFinish;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIImageView *imvLine;
@property (nonatomic, weak) IBOutlet UIImageView *imvDivisor;
//@property (nonatomic, weak) IBOutlet UIImageView *imvIcon;
@property (nonatomic, weak) IBOutlet UILabel *lblStatus;

- (void)updateLayoutForRegistered:(bool)registered;

@end
