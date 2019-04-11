//
//  CS_AnswerSingleLineText_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 14/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerSingleLineText_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol, UITextFieldDelegate>

@property(nonatomic, weak) id<EditableComponentTableViewCellProtocol> cellEditorDelegate;
//
@property(nonatomic, weak) IBOutlet UITextField *txtResult;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
