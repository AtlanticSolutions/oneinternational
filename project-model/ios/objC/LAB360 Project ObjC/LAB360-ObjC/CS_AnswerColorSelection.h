//
//  CS_AnswerColorSelection.h
//  LAB360-ObjC
//
//  Created by Erico GT on 25/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerColorSelection_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol>

//properties
@property(nonatomic, weak) IBOutlet UIButton *btnOptions;
@property(nonatomic, weak) UIViewController<OptionsComponentTableViewCellProtocol> *vcDelegate;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
