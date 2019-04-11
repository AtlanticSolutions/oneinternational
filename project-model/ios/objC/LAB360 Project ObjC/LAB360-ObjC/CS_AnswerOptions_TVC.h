//
//  CS_AnswerOptions_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerOptions_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol>

//properties
@property(nonatomic, weak) IBOutlet UIButton *btnOptions;
@property(nonatomic, weak) UIViewController<OptionsComponentTableViewCellProtocol> *vcDelegate;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
