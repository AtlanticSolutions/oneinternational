//
//  OnlineDocumentViewerController.h
//  LAB360-ObjC
//
//  Created by Erico GT on 27/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "AsyncImageDownloader.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface OnlineDocumentViewerController : UIViewController

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) NSString *documentURL;
@property (nonatomic, strong) NSString *documentName;
@property (nonatomic, assign) BOOL allowsShareDoc;
@property (nonatomic, assign) BOOL useSimpleReturnButton;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
