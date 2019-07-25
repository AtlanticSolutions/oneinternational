//
//  CS_AnswerStarRating_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 16/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerStarRating_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol>

@property(nonatomic, weak) id<EditableComponentTableViewCellProtocol> vcDelegate;
//
@property(nonatomic, weak) IBOutlet UIButton *btnStar1;
@property(nonatomic, weak) IBOutlet UIButton *btnStar2;
@property(nonatomic, weak) IBOutlet UIButton *btnStar3;
@property(nonatomic, weak) IBOutlet UIButton *btnStar4;
@property(nonatomic, weak) IBOutlet UIButton *btnStar5;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
