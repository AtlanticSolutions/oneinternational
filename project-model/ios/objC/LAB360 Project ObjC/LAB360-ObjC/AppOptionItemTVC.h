//
//  AppOptionItemTVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppOptionItemTVC : UITableViewCell

typedef enum {
    AppOptionItemCellTypeNone         = 0,
    AppOptionItemCellTypeSwitch       = 1,
    AppOptionItemCellTypeArrow        = 2
}AppOptionItemCellType;

@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UILabel *lblDescription;
@property(nonatomic, weak) IBOutlet UISwitch *swtOption;
@property(nonatomic, weak) IBOutlet UIImageView *imvArrow;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *leftLabelConstraint;

- (void)setupLayoutForType:(AppOptionItemCellType)type;

@end
