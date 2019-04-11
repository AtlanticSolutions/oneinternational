//
//  AppOptionLanguageItemTVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 05/09/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppOptionLanguageItemTVC : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UIImageView *imvFlag;
@property(nonatomic, weak) IBOutlet UIImageView *imvCheck;

- (void)setupLayoutForSelectedItem:(BOOL)selected;

@end
