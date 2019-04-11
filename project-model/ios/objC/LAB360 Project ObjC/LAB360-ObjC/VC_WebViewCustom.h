//
//  VC_WebViewCustom.h
//  LAB360-ObjC
//
//  Created by Rodrigo Baroni on 24/05/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ViewControllerModel.h"
#import "WebItemToShow.h"

@interface VC_WebViewCustom : ViewControllerModel

@property (nonatomic, strong) NSString *fileURL;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *titleNav;
@property (nonatomic, assign) BOOL hideViewButtons;
@property (nonatomic, assign) BOOL showShareButton;

@end
