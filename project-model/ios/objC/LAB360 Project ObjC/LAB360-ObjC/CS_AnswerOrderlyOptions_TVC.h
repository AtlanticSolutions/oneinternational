//
//  CS_AnswerOrderlyOptions_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 04/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerOrderlyOptions_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol>

//properties
@property(nonatomic, weak) IBOutlet UILabel *lblOrder;
@property(nonatomic, weak) IBOutlet UILabel *lblOption;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
