//
//  CS_AnswerSpecialInput_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 08/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerSpecialInput_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol>

//properties
@property(nonatomic, weak) id<EditableComponentTableViewCellProtocol> vcDelegate;
//
@property(nonatomic, weak) IBOutlet UITextView *txtResultView;
@property(nonatomic, weak) IBOutlet UILabel *lblPlaceholder;
@property(nonatomic, weak) IBOutlet UIButton *btnInput;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
