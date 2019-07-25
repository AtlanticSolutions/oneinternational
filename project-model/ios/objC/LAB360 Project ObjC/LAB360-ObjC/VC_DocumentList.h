//
//  VC_DocumentList.h
//  CozinhaTudo
//
//  Created by lucas on 18/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "DocVidCategory.h"
#import "TVC_DocumentItem.h"
#import "VC_WebFileShareViewer.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_DocumentList : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property(nonatomic, strong) DocVidCategory *selectedCateogry;
@property (nonatomic, assign) BOOL showSearchBar;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end

