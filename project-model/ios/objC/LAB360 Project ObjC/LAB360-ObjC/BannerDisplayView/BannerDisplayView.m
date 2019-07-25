//
//  BannerDisplayView.m
//  LAB360-ObjC
//
//  Created by Erico GT on 13/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "BannerDisplayView.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "ToolBox.h"
#import "SMPageControl.h"

@interface BannerDisplayView()<UIScrollViewDelegate>

@property (nonatomic, weak) id<BannerDisplayViewDelegate>bannerDelegate;
@property (nonatomic, assign) BOOL pageControlVisible;
@property (nonatomic, assign) long currentPage;
@property (nonatomic, assign) NSTimeInterval autoRotationTime;
@property (nonatomic, strong) NSTimer* autoRotationTimer;
@property (nonatomic, assign) BOOL autoRotationEnabled;
@property (nonatomic, assign) int totalItemsInBanner;
//
@property (nonatomic, strong) NSMutableArray<NSString*>* imagesList;
@property (nonatomic, strong) NSMutableArray<UIImageView*>* imvList;
//
@property (nonatomic, weak) IBOutlet UIScrollView *bannerScroll;
@property (nonatomic, weak) IBOutlet UIButton *btnShare;
//
@property (nonatomic, weak) IBOutlet SMPageControl *customPageControl;

@end

@implementation BannerDisplayView

@synthesize bannerDelegate, pageControlVisible, autoRotationTimer, currentPage, autoRotationTime, autoRotationEnabled, totalItemsInBanner;
@synthesize imagesList, imvList;
@synthesize bannerScroll, btnShare, customPageControl;

+ (BannerDisplayView*)createBannerDisplayViewWithFrame:(CGRect)frame imagesURLs:(NSArray<NSString*>*)urlList fixedImageSlots:(signed int)slots andDelegate:(id<BannerDisplayViewDelegate>)delegate
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"BannerDisplayView" owner:self options:nil];
    BannerDisplayView *banner = (BannerDisplayView *)[nibArray objectAtIndex:0];
    [banner awakeFromNib];
    [banner layoutIfNeeded];
    
    if (!banner){
        NSAssert(false, @"Erro ao criar componente.");
    }
    
    if (frame.size.width < 40.0 || frame.size.height < 40.0){
        NSAssert(false, @"O frame do BannerDisplayView não pode ter dimensões menores que 40.0 pt.");
    }
    
    if (slots <= 0){
        if (urlList == nil || urlList.count == 0){
            NSAssert(false, @"A lista de urls não pode ser nula e precisa ter pelo menos um elemento.");
        }
        banner.totalItemsInBanner = (int)urlList.count;
    }else{
        banner.totalItemsInBanner = slots;
    }
    
    banner.bannerDelegate = delegate;
    
    //Banner configuration:
    
    banner.imagesList = [NSMutableArray new];
    for (NSString *strURL in urlList){
        [banner.imagesList addObject:[NSString stringWithFormat:@"%@", strURL]];
    }
    
    banner.pageControlVisible = YES;
    banner.autoRotationTime = 0.0;
    banner.autoRotationEnabled = NO;
    banner.currentPage = 0;
    banner.autoRotationTimer = nil;
    
    [banner setFrame:frame];
    
    banner.backgroundColor = nil;
    
    banner.bannerScroll.backgroundColor = nil;
    [banner.bannerScroll setContentSize:CGSizeMake((banner.frame.size.width * (CGFloat)(banner.totalItemsInBanner)), banner.frame.size.height)];
    banner.bannerScroll.delegate = banner;
    [banner.bannerScroll setScrollsToTop:NO];
    
    banner.imvList = [NSMutableArray new];
    
    UIImage *placeholderImage = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
    
    for (int i = 0; i < banner.totalItemsInBanner; i++){
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(banner.frame.size.width * (CGFloat)i, 0.0, banner.frame.size.width, banner.frame.size.height)];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        if (delegate){
            imageView.backgroundColor = [delegate bannerDisplayViewDelegate:banner backgroundColorForItemAtIndex:i];
        }else{
            imageView.backgroundColor = [UIColor blackColor];
        }
        
        //Tap Gesture
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:banner action:@selector(tapInBannerAction:)];
        [tapGesture setNumberOfTapsRequired:1];
        [tapGesture setNumberOfTouchesRequired:1];
        //simpleTapGesture.delegate = self;
        [imageView addGestureRecognizer:tapGesture];
        
        [banner.imvList addObject:imageView];
        
        //Images:
        if (slots > 0){
            if (banner.bannerDelegate){
                imageView.image = [banner.bannerDelegate bannerDisplayViewDelegate:banner imageForItemAtIndex:i];
            }else{
                imageView.image = placeholderImage;
            }
        }else{
            NSString *str = [banner.imagesList objectAtIndex:i];
            __weak UIImageView *weakImageView = imageView;
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]] placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                weakImageView.image = image;
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                weakImageView.image = placeholderImage;
            }];
        }
        
        [banner.bannerScroll addSubview:imageView];
    }
    
    //Custom Page Control
    UIImage *dotImage = [[UIImage imageNamed:@"CustomUIPageControlDot"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    banner.customPageControl.backgroundColor = [UIColor clearColor];
    banner.customPageControl.pageIndicatorImage = dotImage;
    banner.customPageControl.currentPageIndicatorImage = dotImage;
    banner.customPageControl.numberOfPages = banner.totalItemsInBanner;
    banner.customPageControl.pageIndicatorTintColor = [UIColor grayColor];
    banner.customPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [banner.customPageControl setUserInteractionEnabled:NO];
    
    //Share Button
    banner.btnShare.backgroundColor = nil;
    [banner.btnShare setTintColor:AppD.styleManager.colorPalette.primaryButtonSelected];
    banner.btnShare.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [banner.btnShare setImageEdgeInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)];
    [banner.btnShare setImage:[[UIImage imageNamed:@"SharePhotoMask"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [banner.btnShare setTitle:@"" forState:UIControlStateNormal];
    [banner.btnShare setExclusiveTouch:YES];
    
    if (banner.bannerDelegate){
        banner.btnShare.alpha = ([banner.bannerDelegate bannerDisplayViewDelegate:banner showShareButtonAtIndex:0] ? 1.0 : 0.0);
    }
    
    [banner.bannerScroll scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:NO];
    
    return banner;
}

- (void)dealloc
{
    [autoRotationTimer invalidate];
    autoRotationTimer = nil;
}

- (void)setPageControlVisible:(BOOL)visible
{
    pageControlVisible = visible;
    [customPageControl setHidden:!pageControlVisible];
}

- (void)setAutoRotationBannerWithTime:(NSTimeInterval)timeToRotate
{
    autoRotationTime = timeToRotate;
    
    if (autoRotationTimer){
        [autoRotationTimer invalidate];
        autoRotationTimer = nil;
    }
    
    if (autoRotationTime != 0.0){
        autoRotationTimer = [NSTimer scheduledTimerWithTimeInterval:autoRotationTime target:self selector:@selector(finishTic:) userInfo:nil repeats:YES];
    }
}

- (void)setCurrentPageAtIndex:(long)pageIndex
{
    currentPage = pageIndex < 0 ? 0 : (pageIndex > (imagesList.count-1) ? (imagesList.count-1) : pageIndex);
    
    [bannerScroll scrollRectToVisible:CGRectMake((currentPage * self.frame.size.width), 0.0, self.frame.size.width, self.frame.size.height) animated:YES];
    //
    if (bannerDelegate){
        [bannerDelegate bannerDisplayViewDelegate:self didChangePage:currentPage];
    }
    //
    [self verifyComponents];
}

//- (void)reloadData
//{
//    if (bannerDelegate){
//        
//        //share:
//        self.btnShare.alpha = ([self.bannerDelegate bannerDisplayViewDelegate:self showShareButtonAtIndex:0] ? 1.0 : 0.0);
//        
//        //background color:
//        UIImageView *imageView = [self.imvList objectAtIndex:currentPage];
//        imageView.backgroundColor = [self.bannerDelegate bannerDisplayViewDelegate:self backgroundColorForItemAtIndex:currentPage];
//        
//        //image:
//        imageView.image = [self.bannerDelegate bannerDisplayViewDelegate:self imageForItemAtIndex:currentPage];
//    }
//}

#pragma mark - Private Methods

- (void)tapInBannerAction:(UIGestureRecognizer*)gestureRecognizer
{
    if (bannerDelegate){
        [bannerDelegate bannerDisplayViewDelegate:self didTapPageAtIndex:currentPage];
    }
}

- (IBAction)actionShare:(id)sender
{
    if (bannerDelegate){
        [bannerDelegate bannerDisplayViewDelegate:self didTouchInShareAtIndex:currentPage];
    }
}

- (void)finishTic:(id)sender
{
    if (currentPage == (totalItemsInBanner - 1)){
        [self setCurrentPageAtIndex:0];
    }else{
        [self setCurrentPageAtIndex:(currentPage + 1)];
    }
}

- (void)verifyComponents
{
    if (bannerDelegate){
        BOOL show = [bannerDelegate bannerDisplayViewDelegate:self showShareButtonAtIndex:currentPage];
        if (show){
            [UIView animateWithDuration:0.2 animations:^{
                btnShare.alpha = 1.0;
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                btnShare.alpha = 0.0;
            }];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    long page = (long)(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1.0);
    //
    if (page != currentPage){
        currentPage = page;
        customPageControl.currentPage = currentPage;
        if (bannerDelegate){
            [bannerDelegate bannerDisplayViewDelegate:self didChangePage:currentPage];
        }
        [self verifyComponents];
    }
}

@end
