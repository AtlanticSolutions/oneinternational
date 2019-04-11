//
//  ShowcaseProductsHeaderReusableView.h
//  LAB360-ObjC
//
//  Created by Erico GT on 06/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface ShowcaseProductsHeaderReusableView : UICollectionReusableView

@property (nonatomic, weak) IBOutlet UIImageView* _Nullable imvBanner;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* _Nullable activityIndicator;

+ (CGFloat)heightForImage:(UIImage*_Nullable)refImage containedInWidth:(CGFloat)width;
- (void)setupLayout;

@end
