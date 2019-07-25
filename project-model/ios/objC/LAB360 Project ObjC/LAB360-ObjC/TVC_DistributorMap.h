//
//  TVC_DistributorMap.h
//  GS&MD
//
//  Created by Erico GT on 25/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_DistributorMap : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* lblDistributorName;
@property (nonatomic, weak) IBOutlet UILabel* lblDistributorContact;
@property (nonatomic, weak) IBOutlet UIImageView* imvPinMarker;

- (void)updateLayout;

@end
