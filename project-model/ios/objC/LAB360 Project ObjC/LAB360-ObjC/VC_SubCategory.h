//
//  VC_SubCategory.h
//  CozinhaTudo
//
//  Created by lucas on 12/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "DocVidCategory.h"
#import "TVC_DocVidCategory.h"
#import "VC_VideoPreviewList.h"
#import "VC_DocumentList.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VC_SubCategory : UIViewController <UITableViewDelegate, UITableViewDataSource>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, assign) enumCategoryType categoryType;
@property (nonatomic, strong) DocVidCategory *selectedCategory;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
