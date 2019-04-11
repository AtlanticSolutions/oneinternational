//
//  CS_AnswerItemList_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 06/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerItemList_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol>

//properties
@property(nonatomic, weak) id<EditableItemComponentTableViewCellProtocol> vcDelegate;
@property(nonatomic, weak) IBOutlet UILabel *lblItems;
@property(nonatomic, weak) IBOutlet UIButton *btnInsert;
@property(nonatomic, weak) IBOutlet UIView *viewItemsContainer;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
