//
//  CS_GroupHeader_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 11/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_GroupHeader_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol>

@property(nonatomic, weak) IBOutlet UILabel *lblMessage;
@property(nonatomic, weak) IBOutlet UIImageView *imvBackground;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
