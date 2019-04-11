//
//  ShowcaseUserCollection.h
//  LAB360-ObjC
//
//  Created by Erico GT on 09/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "VirtualShowcasePhoto.h"
#import "ShowcaseProductCollectionViewCell.h"
#import "ShowcaseDataSource.h"
#import "VIPhotoView.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface ShowcaseUserCollectionViewController : UIViewController<VIPhotoViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

#pragma mark - • PUBLIC PROPERTIES

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
