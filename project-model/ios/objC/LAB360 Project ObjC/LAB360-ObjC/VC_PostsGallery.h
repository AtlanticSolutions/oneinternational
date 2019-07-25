//
//  VC_PostsGallery.h
//  GS&MD
//
//  Created by Erico GT on 1/13/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "TVC_PostCell.h"
#import "AppDelegate.h"
#import "Post.h"
#import "ViewSectionPost.h"
#import "VC_Comments.h"
#import "VIPhotoView.h"
#import "BannerDisplayView.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

#pragma mark - • OTHERS IMPORTS
@protocol PostCellVideoDelegate;

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_PostsGallery : UIViewController<UIGestureRecognizerDelegate, VIPhotoViewDelegate, PostCellVideoDelegate, BannerDisplayViewDelegate, SideMenuDelegate>

#pragma mark - • PUBLIC PROPERTIES

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS
- (void)photoViewDidHide:(VIPhotoView *)photoView;

@end
