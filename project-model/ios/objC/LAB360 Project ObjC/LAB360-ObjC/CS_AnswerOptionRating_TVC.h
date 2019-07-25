//
//  CS_AnswerOptionRating_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 06/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"
#import "iCarousel.h"

@interface CS_AnswerOptionRating_TVC : UITableViewCell<CustomSurveyTableViewCellProtocol, iCarouselDataSource, iCarouselDelegate>

@property(nonatomic, weak) id<SelectableComponentTableViewCellProtocol> vcDelegate;
//
@property(nonatomic, weak) IBOutlet iCarousel *optCarousel;
@property(nonatomic, weak) IBOutlet UIImageView *imvArrow;
@property(nonatomic, weak) IBOutlet UIImageView *imvNoteBackground;
@property(nonatomic, weak) IBOutlet UILabel *lblNote;

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath;
+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData;

@end
