//
//  CS_AsnwerImageItem_TVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveyTableViewCellProtocol.h"

@interface CS_AnswerImageItem_CVC : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UIImageView *imvPicture;

- (void)setupLayoutWithImage:(UIImage*)picture;

@end

