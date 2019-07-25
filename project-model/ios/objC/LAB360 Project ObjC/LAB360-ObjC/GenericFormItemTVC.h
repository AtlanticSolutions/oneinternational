//
//  GenericFormItemTVC.h
//  Siga
//
//  Created by Erico GT on 29/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface GenericFormItemTVC : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblParameterName;
@property(nonatomic, weak) IBOutlet UITextField *txtParameterValue;
@property(nonatomic, weak) IBOutlet UIImageView *imvPicture;
@property(nonatomic, weak) IBOutlet UIImageView *imvIcon;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *leftIconConstraint;

- (void)setupLayoutWithInputAccessoryView:(UIView*)iav usingIcon:(UIImage*)icon;

@end

