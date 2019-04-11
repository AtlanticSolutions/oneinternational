//
//  TVC_StoreItem.h
//  ShoppingBH
//
//  Created by Erico GT on 06/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"

@interface TVC_StoreItem : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblDescription1;
@property (nonatomic, weak) IBOutlet UILabel *lblDescription2;
@property (nonatomic, weak) IBOutlet UILabel *lblDescription3;
@property (nonatomic, weak) IBOutlet UIImageView *imvLogo;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

- (void) updateLayout;

@end
