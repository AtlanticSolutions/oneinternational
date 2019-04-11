//
//  VideoPlayerPresenter.m
//  GS&MD
//
//  Created by Erico GT on 12/5/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "VideoPlayerPresenter.h"

@interface VideoPlayerPresenter()

@property (nonatomic, strong) UIViewController<VideoPlayerPresenterProtocol> *baseViewController;

@end

@implementation VideoPlayerPresenter

@synthesize baseViewController;

+ (nonnull VideoPlayerPresenter*)newVideoPlayerPresenterForViewController:(nonnull UIViewController<VideoPlayerPresenterProtocol>*)viewController
{
    if ([viewController conformsToProtocol:@protocol(VideoPlayerPresenterProtocol)]){
        VideoPlayerPresenter *vpp = [VideoPlayerPresenter new];
        vpp.baseViewController = viewController;
        return vpp;
    }else{
        NSAssert(false, @"Parâmetro 'viewController' deve implementar o protocolo <VideoPlayerPresenterProtocol>.");
    }
    
    return [VideoPlayerPresenter new];
}

- (void)initWithViewController:(UIViewController<VideoPlayerPresenterProtocol>*)viewController
{
    if ([viewController conformsToProtocol:@protocol(VideoPlayerPresenterProtocol)]){
        baseViewController = viewController;
        baseViewController.presenter = self;
    }else{
        NSAssert(false, @"Parâmetro 'viewController' deve implementar o protocolo <VideoPlayerPresenterProtocol>.");
    }
}

- (void)getVideoInfo
{
    if ([baseViewController respondsToSelector:@selector(presenterDidFinishVideoInfoRequestWithResult:error:)]){
        
        if (true){
            //bla bla bla
            baseViewController.videoList = [NSArray new];
            [baseViewController presenterDidFinishVideoInfoRequestWithResult:VPPP_RequestResult_OK error:nil];
        }else{
            [baseViewController presenterDidFinishVideoInfoRequestWithResult:VPPP_RequestResult_ERROR error:nil];
        }
        
    }else{
        NSAssert(false, @"UIViewController<VideoPlayerPresenterProtocol> não responde ao método 'presenterDidFinishVideoInfoRequestWithResult:error:'.");
    }
}

- (void)presenterDidSelectItemFromList:(nonnull VideoData*)itemSelected
{
    
}

- (void)presenterUpdateLayout
{
    baseViewController.automaticallyAdjustsScrollViewInsets = false;
    
    //Button Profile Pic
    baseViewController.navigationItem.rightBarButtonItem = [AppD createProfileButton];
    
    //Title
    [baseViewController.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    baseViewController.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_VIDEO", @"");
    
    //Background
    baseViewController.view.backgroundColor = [UIColor whiteColor];
    
    //Navigation Controller
    baseViewController.navigationController.navigationBar.translucent = NO;
    [baseViewController.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:baseViewController.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [baseViewController.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(baseViewController.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    baseViewController.navigationController.toolbar.translucent = YES;
    baseViewController.navigationController.toolbar.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
    
}

@end
