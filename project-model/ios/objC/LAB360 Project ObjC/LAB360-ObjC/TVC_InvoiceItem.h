//
//  TVC_InvoiceItem.h
//  ShoppingBH
//
//  Created by Erico GT on 03/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface TVC_InvoiceItem : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCOO;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblStatusDate;
@property (weak, nonatomic) IBOutlet UIImageView *imvInvoice;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
//
@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIView *viewStatus;

- (void)updateLayout;

@end
