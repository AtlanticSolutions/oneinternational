//
//  CS_AnswerMultiSelection_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 14/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerMultiSelection_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol>

@property(nonatomic, weak) IBOutlet UILabel *lblText;
@property(nonatomic, weak) IBOutlet UIImageView *imvImage;
@property(nonatomic, weak) IBOutlet UIImageView *imvRadioButton;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *labelHeightConstraint;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
