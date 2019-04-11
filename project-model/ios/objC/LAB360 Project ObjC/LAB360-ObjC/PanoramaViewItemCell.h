//
//  PanoramaViewItemCell.h
//  aw_experience
//
//  Created by Erico GT on 12/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface PanoramaViewItemCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imvItem;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)setupLayout;

@end
