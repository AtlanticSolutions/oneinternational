//
//  VideoPlayerPresenter.h
//  GS&MD
//
//  Created by Erico GT on 12/5/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VideoData.h"
#import "AppDelegate.h"

typedef enum {VPPP_RequestResult_OK = 1, VPPP_RequestResult_ERROR = 2,} VPPP_RequestResult;

//Protocol
@class VideoPlayerPresenter;

@protocol VideoPlayerPresenterProtocol <NSObject>

@required

@property (nonatomic, strong) VideoPlayerPresenter * _Nullable presenter;
@property (nonatomic, strong) NSArray<VideoData*> * _Nullable videoList; //específico

- (void)presenterDidFinishVideoInfoRequestWithResult:(VPPP_RequestResult)result error:(nullable NSError*)error;

@end

//Presenter

@interface VideoPlayerPresenter : NSObject

+ (nonnull VideoPlayerPresenter*)newVideoPlayerPresenterForViewController:(nonnull UIViewController<VideoPlayerPresenterProtocol>*)viewController;
//
- (void)initWithViewController:(nonnull UIViewController<VideoPlayerPresenterProtocol>*)viewController;
- (void)presenterDidSelectItemFromList:(nonnull VideoData*)itemSelected; //específico
- (void)presenterUpdateLayout; //específico

@end
