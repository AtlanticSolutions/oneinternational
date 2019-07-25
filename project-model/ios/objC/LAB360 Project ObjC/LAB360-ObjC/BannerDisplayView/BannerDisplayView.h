//
//  BannerDisplayView.h
//  LAB360-ObjC
//
//  Created by Erico GT on 13/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerDisplayViewDelegate;

#pragma mark - BannerDisplayView

@interface BannerDisplayView : UIView
+ (BannerDisplayView*)createBannerDisplayViewWithFrame:(CGRect)frame imagesURLs:(NSArray<NSString*>*)urlList fixedImageSlots:(signed int)slots andDelegate:(id<BannerDisplayViewDelegate>)delegate;
- (void)setPageControlVisible:(BOOL)visible;
- (void)setAutoRotationBannerWithTime:(NSTimeInterval)timeToRotate;
- (void)setCurrentPageAtIndex:(long)pageIndex;
@end

#pragma mark - BannerDisplayViewDelegate
@protocol BannerDisplayViewDelegate <NSObject>
@required
- (void)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView didChangePage:(long)currentPage;
- (void)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView didTapPageAtIndex:(long)pageIndex;
- (void)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView didTouchInShareAtIndex:(long)pageIndex;
- (BOOL)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView showShareButtonAtIndex:(long)pageIndex;
- (UIColor*)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView backgroundColorForItemAtIndex:(long)pageIndex;
- (UIImage*)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView imageForItemAtIndex:(long)pageIndex;
@end
