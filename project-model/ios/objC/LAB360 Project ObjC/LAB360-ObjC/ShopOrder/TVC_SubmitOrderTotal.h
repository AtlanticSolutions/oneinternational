//
//  TVC_SubmitOrderTotal.h
//  GS&MD
//
//  Created by Erico GT on 18/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_SubmitOrderTotal : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblTotalTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblTotalValue;

- (void) updateLayout;

@end
