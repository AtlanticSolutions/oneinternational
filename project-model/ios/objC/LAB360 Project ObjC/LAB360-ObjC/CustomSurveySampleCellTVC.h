//
//  CustomSurveySampleCellTVC.h
//  LAB360-ObjC
//
//  Created by lordesire on 21/01/2019.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSurveySampleCellTVC : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UILabel *lblDescription;
@property(nonatomic, weak) IBOutlet UILabel *lblNote;
@property(nonatomic, weak) IBOutlet UIImageView *imvArrow;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *noteWidthConstraint;

- (void)setupLayout;
- (void)updateNoteLabelWithText:(NSString*)newNote;

@end
