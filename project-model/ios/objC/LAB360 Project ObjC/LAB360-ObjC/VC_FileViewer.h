//
//  VC_FileViewer.h
//  AHK-100anos
//
//  Created by Erico GT on 10/17/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

#import "AppDelegate.h"
#import "DownloadItem.h"

@interface VC_FileViewer : QLPreviewController

@property (nonatomic, strong) DownloadItem *fileToShow;

@end
