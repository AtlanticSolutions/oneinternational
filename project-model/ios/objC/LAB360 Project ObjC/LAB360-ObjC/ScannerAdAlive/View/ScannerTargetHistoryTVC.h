//
//  ScannerTargetHistoryTVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 07/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface ScannerTargetHistoryTVC : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *imvProductImage;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, weak) IBOutlet UILabel *lblName;
@property(nonatomic, weak) IBOutlet UILabel *lblDate;

- (void) updateLayout;

@end
