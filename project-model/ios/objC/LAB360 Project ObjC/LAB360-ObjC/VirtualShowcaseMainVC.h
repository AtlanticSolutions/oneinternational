//
//  VirtualShowcaseMainVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "UIScrollView+EmptyDataSet.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface VirtualShowcaseMainVC : ViewControllerModel<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

#pragma mark - • PUBLIC PROPERTIES

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
