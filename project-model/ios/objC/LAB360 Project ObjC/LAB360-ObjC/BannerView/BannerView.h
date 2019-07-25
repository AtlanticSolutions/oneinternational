//
//  BannerView.h
//  AdAlive
//
//  Created by Lab360 on 2/16/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerView;

@protocol BannerViewDelegate <NSObject>

-(void)didTapOnBannerView:(BannerView *)bannerView withLink:(NSString *)bannerUrl;

@end

@interface BannerView : UIImageView

@property(nonatomic, assign) IBOutlet id<BannerViewDelegate> delegate;

@end
