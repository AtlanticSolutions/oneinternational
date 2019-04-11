//
//  CouponTableViewCell.h
//  AdAlive
//
//  Created by Lab360 on 1/19/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"

@interface CouponTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *imvBackground;
@property(nonatomic, weak) IBOutlet UIImageView *logoImage;
@property(nonatomic, weak) IBOutlet UILabel *value;
@property(nonatomic, weak) IBOutlet UILabel *endDate;
@property(nonatomic, weak) IBOutlet UILabel *type;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;

- (void)setupLayout;

@end
