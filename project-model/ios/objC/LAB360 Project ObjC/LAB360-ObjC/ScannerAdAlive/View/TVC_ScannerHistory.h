//
//  TVC_ScannerHistory.h
//  AdAliveStore
//
//  Created by Erico GT on 9/19/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

typedef enum {
    eStoreDiscountType_Percentage = 1,
    eStoreDiscountType_Value = 2
} enumStoreDiscountType;

@interface TVC_ScannerHistory : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lbUserStoreName;
@property(nonatomic, weak) IBOutlet UILabel *lbUserStoreEmail;
@property(nonatomic, weak) IBOutlet UILabel *lbPromotionName;
@property(nonatomic, weak) IBOutlet UILabel *lbDiscount;
@property(nonatomic, weak) IBOutlet UILabel *lbScanDate;
@property(nonatomic, weak) IBOutlet UILabel *lbType;
@property(nonatomic, weak) IBOutlet UIImageView *ivIcon;
@property(nonatomic, weak) IBOutlet UIImageView *ivBackground;

- (void)updateLayout:(enumStoreDiscountType)typeCell withBackgroundImageSize:(CGSize)size;

@end
