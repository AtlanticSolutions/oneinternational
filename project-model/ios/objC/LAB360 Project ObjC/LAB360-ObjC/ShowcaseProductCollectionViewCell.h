//
//  ShowcaseProductCollectionViewCell.h
//  LAB360-ObjC
//
//  Created by Erico GT on 06/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface ShowcaseProductCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imvProduct;
@property (nonatomic, weak) IBOutlet UILabel *lblProduct;
@property (nonatomic, weak) IBOutlet UIView *viewProductNameContainer;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UIImageView *imvSelectionIndicator;

- (void)setupLayout;

@end
