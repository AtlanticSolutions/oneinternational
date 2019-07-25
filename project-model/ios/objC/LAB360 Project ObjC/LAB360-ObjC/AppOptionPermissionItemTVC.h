//
//  AppOptionPermissionItemTVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 16/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppOptionPermissionItemTVC : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UILabel *lblDescription;
@property(nonatomic, weak) IBOutlet UIImageView *imvStatus;
@property(nonatomic, weak) IBOutlet UILabel *lblStatus;

- (void)setupLayout;

@end
