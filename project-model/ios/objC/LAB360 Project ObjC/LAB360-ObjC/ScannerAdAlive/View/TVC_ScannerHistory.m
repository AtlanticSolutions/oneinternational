//
//  TVC_ScannerHistory.m
//  AdAliveStore
//
//  Created by Erico GT on 9/19/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_ScannerHistory.h"

@implementation TVC_ScannerHistory

@synthesize lbUserStoreName, lbUserStoreEmail, lbPromotionName, lbDiscount, lbScanDate, ivIcon, ivBackground, lbType;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateLayout:(enumStoreDiscountType)typeCell withBackgroundImageSize:(CGSize)size
{
    //Text
    lbUserStoreName.textColor = [UIColor darkGrayColor];
    lbUserStoreEmail.textColor = [UIColor darkGrayColor];
    lbPromotionName.textColor = [UIColor darkTextColor];
    lbScanDate.textColor = [UIColor grayColor];
    lbType.textColor = [UIColor grayColor];
    
    //ivIcon.tintColor = [UIColor darkTextColor];
    //ivIcon.image = [[UIImage imageNamed:@"CouponScannerIcon_Coupon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ivIcon.alpha = 0.0;
    //Font
    lbPromotionName.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:14];
    lbUserStoreName.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:18];
    lbUserStoreEmail.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:12];
    lbScanDate.font = [UIFont fontWithName:FONT_DEFAULT_ITALIC size:12];
    lbDiscount.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:20];
    lbType.font = [UIFont fontWithName:FONT_DEFAULT_ITALIC size:14];
    
    //Icon
    if (typeCell == eStoreDiscountType_Percentage){
        //ivIcon.alpha = 1.0;
        lbDiscount.textColor = [UIColor blueColor];
    }else if(typeCell == eStoreDiscountType_Value){
        //ivIcon.alpha = 0.0;
        lbDiscount.textColor = [UIColor darkTextColor];
    }
    ivBackground.image = [ToolBox graphicHelper_CreateFlatImageWithSize:size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:[AppD.styleManager.colorPalette.backgroundNormal colorWithAlphaComponent:0.15]];
    
    //Background
    self.backgroundColor = [UIColor whiteColor];
    ivBackground.backgroundColor = [UIColor clearColor];
    lbUserStoreName.backgroundColor = [UIColor clearColor];
    lbUserStoreEmail.backgroundColor = [UIColor clearColor];
    lbPromotionName.backgroundColor = [UIColor clearColor];
    lbScanDate.backgroundColor = [UIColor clearColor];
    lbDiscount.backgroundColor = [UIColor clearColor];
    lbType.backgroundColor = [UIColor clearColor];
    ivIcon.backgroundColor = [UIColor clearColor];
}

@end
