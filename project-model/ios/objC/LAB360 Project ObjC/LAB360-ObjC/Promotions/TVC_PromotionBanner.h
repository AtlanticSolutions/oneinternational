//
//  TVC_PromotionBanner.h
//  ShoppingBH
//
//  Created by Erico GT on 01/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"

@interface TVC_PromotionBanner : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *baseView;
@property (nonatomic, weak) IBOutlet UIImageView *imvBanner;
@property (nonatomic, weak) IBOutlet UIButton *btnRegister;
@property (nonatomic, weak) IBOutlet UIButton *btnTermsAndRules;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (nonatomic, weak) IBOutlet UILabel *lblRegistered;

- (void) updateLayout;

@end
