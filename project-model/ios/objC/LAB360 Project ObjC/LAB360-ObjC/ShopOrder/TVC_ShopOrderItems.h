//
//  TVC_ShopOrderItems.h
//  GS&MD
//
//  Created by Erico GT on 17/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_ShopOrderItems : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* lblProductTitle;
@property (nonatomic, weak) IBOutlet UILabel* lblProductSize;
@property (nonatomic, weak) IBOutlet UILabel* lblSubTotal;
@property (nonatomic, weak) IBOutlet UILabel* lblAmount;
@property (nonatomic, weak) IBOutlet UIButton* btnPlus;
@property (nonatomic, weak) IBOutlet UIButton* btnMinus;
@property (nonatomic, weak) IBOutlet UIButton* btnDelete;

- (void) updateLayoutWithIndex:(long)index;

@end
