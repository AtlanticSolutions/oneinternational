//
//  CS_GroupImage_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 11/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_GroupImage_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol>

@property(nonatomic, weak) IBOutlet UIImageView *imvImage;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
