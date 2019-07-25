//
//  VC_VideoPreviewList.h
//  CozinhaTudo
//
//  Created by lucas on 16/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "VideoData.h"
#import "DocVidCategory.h"
#import "TVC_VideoPlayerListItem.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_VideoPreviewList : UIViewController <UITableViewDelegate, UITableViewDataSource, VideoCellDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) DocVidCategory *selectedCategory;
@property (nonatomic, assign) BOOL showSearchBar;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
