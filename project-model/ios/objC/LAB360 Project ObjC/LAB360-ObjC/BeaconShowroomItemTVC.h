//
//  BeaconShowroomItemTVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface BeaconShowroomItemTVC : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *imvItemImage;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, weak) IBOutlet UILabel *lblName;
@property(nonatomic, weak) IBOutlet UILabel *lblDetail;

- (void) updateLayoutUsingImage:(BOOL)showImage;

@end
