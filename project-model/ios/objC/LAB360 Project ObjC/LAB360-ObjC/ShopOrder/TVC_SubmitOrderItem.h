//
//  TVC_SubmitOrderItem.h
//  GS&MD
//
//  Created by Erico GT on 18/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_SubmitOrderItem : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* lblProductTitle;
@property (nonatomic, weak) IBOutlet UILabel* lblProductSize;
@property (nonatomic, weak) IBOutlet UILabel* lblProductAmount;
@property (nonatomic, weak) IBOutlet UILabel* lblTotalItem;

- (void) updateLayout;

@end
