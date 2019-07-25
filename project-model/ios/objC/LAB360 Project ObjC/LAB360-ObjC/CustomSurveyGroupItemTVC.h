//
//  CustomSurveyGroupItemTVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 09/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSurveyGroupItemTVC : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UILabel *lblComplete;
@property(nonatomic, weak) IBOutlet UIImageView *imvBackground;

- (void)setupLayout;

@end
