//
//  LoadingView.h
//  AdAliveStore
//
//  Created by Erico GT on 9/20/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConstantsManager.h"

@interface LoadingView : UIView

@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, weak) IBOutlet UIImageView *imvBackground;
@property(nonatomic, weak) IBOutlet UIImageView *imvCenter;
@property(nonatomic, weak) IBOutlet UILabel *lblMessage;
@property(nonatomic, weak) IBOutlet UILabel *lblDownload;
@property(nonatomic, weak) IBOutlet UIButton *btnDownloadCancel;

typedef enum {eActivityIndicatorType_Loading, eActivityIndicatorType_Processing, eActivityIndicatorType_Downloading, eActivityIndicatorType_Updating, eActivityIndicatorType_Publishing} enumActivityIndicator;

- (void)startWithMessage:(NSString*)message;
- (void)stop;
- (void)updateMessage:(NSString*)message;

@end
