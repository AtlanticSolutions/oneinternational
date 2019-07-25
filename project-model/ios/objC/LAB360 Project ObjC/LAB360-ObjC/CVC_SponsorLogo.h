//
//  CVC_SponsorLogo.h
//  AHK-100anos
//
//  Created by Erico GT on 11/3/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface CVC_SponsorLogo : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UIImageView *imvLogo;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic, weak) IBOutlet UILabel *lblName;

- (void)updateLayoutStartingDownloading;
- (void)updateLayoutFinishDownloadingWithImage:(UIImage*)image;

@end
