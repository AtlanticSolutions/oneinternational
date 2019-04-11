//
//  CVC_CustomIconButton.h
//  AHK-100anos
//
//  Created by Erico GT on 10/4/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantsManager.h"

@interface CVC_CustomIconButton : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UIImageView *imvIcon;
@property(nonatomic, weak) IBOutlet UIImageView *imvBackground;

- (void)updateLayoutForMultilineLabel:(bool)isMultiline;

@end
