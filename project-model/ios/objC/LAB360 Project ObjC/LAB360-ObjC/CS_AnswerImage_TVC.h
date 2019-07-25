//
//  CS_AnswerImage_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerImage_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//properties
@property(nonatomic, weak) IBOutlet UICollectionView *cvImages;
@property(nonatomic, weak) UIViewController<SelectableComponentTableViewCellProtocol> *vcDelegate;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
