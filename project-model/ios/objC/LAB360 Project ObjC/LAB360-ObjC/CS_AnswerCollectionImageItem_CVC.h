//
//  CS_AnswerCollectionImageItem_CVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 04/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerCollectionImageItem_CVC : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UIImageView *imvPicture;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

- (void)setupLayoutSelected:(BOOL)selected;

@end


