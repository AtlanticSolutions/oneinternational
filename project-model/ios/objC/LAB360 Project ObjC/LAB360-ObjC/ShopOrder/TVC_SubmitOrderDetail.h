//
//  TVC_SubmitOrderDetail.h
//  GS&MD
//
//  Created by Erico GT on 18/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_SubmitOrderDetail : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *viewPoints;
@property (nonatomic, weak) IBOutlet UILabel *lblTitlePoints;
@property (nonatomic, weak) IBOutlet UILabel *lblTotalPoints;
//
@property (nonatomic, weak) IBOutlet UILabel *lblTitleCoupon;
@property (nonatomic, weak) IBOutlet UITextField *txtCoupon;
//
@property (nonatomic, weak) IBOutlet UILabel *lblTitleReferenceProduct;
@property (nonatomic, weak) IBOutlet UITextField *txtReferenceProduct;
//
@property (nonatomic, weak) IBOutlet UIView *viewFooter;
@property (nonatomic, weak) IBOutlet UIButton *btnSubmitOrder;

- (void) updateLayout;

@end
