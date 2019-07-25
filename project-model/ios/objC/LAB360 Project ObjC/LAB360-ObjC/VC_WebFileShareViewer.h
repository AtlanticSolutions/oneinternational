//
//  VC_WebFileShareViewer.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/01/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageDownloader.h"

@interface VC_WebFileShareViewer : UIViewController

@property (nonatomic, strong) NSString *fileURL;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, strong) NSString *fileTitle;
//
@property (nonatomic, strong) NSString *titleScreen;

@end
