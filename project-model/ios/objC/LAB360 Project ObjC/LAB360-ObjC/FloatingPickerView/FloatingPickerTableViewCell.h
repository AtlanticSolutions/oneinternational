//
//  FloatingPickerTableViewCell.h
//  LAB360-ObjC
//
//  Created by Erico GT on 17/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatingPickerTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* lblText;
@property (nonatomic, weak) IBOutlet UIImageView* imvCheck;
@property (nonatomic, weak) IBOutlet UIView* containerView;
//
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

- (void) updateLayoutForSelectedElement:(BOOL)isSelected;

@end
