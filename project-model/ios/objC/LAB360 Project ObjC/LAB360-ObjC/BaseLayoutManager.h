//
//  BaseLayoutApp.h
//  GS&MD
//
//  Created by Erico GT on 11/30/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AsyncImageDownloader.h"
#import "ConstantsManager.h"

@interface BaseLayoutManager : NSObject

//Properties:
@property (nonatomic, strong) NSString *urlBackground;
@property (nonatomic, strong) NSString *urlLogo;
@property (nonatomic, strong) NSString *urlBanner;
//
@property (nonatomic, strong) UIImage *imageBackground;
@property (nonatomic, strong) UIImage *imageLogo;
@property (nonatomic, strong) UIImage *imageBanner;
//
@property (nonatomic, strong) UIImage *defaultBackground;
@property (nonatomic, strong) UIImage *defaultLogo;
@property (nonatomic, strong) UIImage *defaultBanner;
//
@property (nonatomic, assign) bool isImageBackgroundLoaded;
@property (nonatomic, assign) bool isImageLogoLoaded;
@property (nonatomic, assign) bool isImageBannerLoaded;

//Methods:
+ (BaseLayoutManager*)createNewBaseLayoutAppUsingStoredValues;
//
- (void)saveConfiguration;
- (void)loadConfiguration;
- (void)updateImagesFromURLs:(bool)needsForce;

@end
