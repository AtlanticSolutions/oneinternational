//
//  CS_AnswerBarRating_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 16/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerBarRating_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol>

@property(nonatomic, weak) id<EditableComponentTableViewCellProtocol> vcDelegate;
//
@property(nonatomic, weak) IBOutlet UILabel *lblMinMessage;
@property(nonatomic, weak) IBOutlet UILabel *lblMaxMessage;
@property(nonatomic, weak) IBOutlet UISegmentedControl *segControl;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
