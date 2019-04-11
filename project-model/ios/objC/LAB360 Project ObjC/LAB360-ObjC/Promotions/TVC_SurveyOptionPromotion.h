//
//  TVC_SurveyOptionPromotion.h
//  ShoppingBH
//
//  Created by Erico GT on 01/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_SurveyOptionPromotion : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imvRadioOption;
@property (nonatomic, weak) IBOutlet UILabel *lblTitleOption;

- (void) updateLayout;

@end
