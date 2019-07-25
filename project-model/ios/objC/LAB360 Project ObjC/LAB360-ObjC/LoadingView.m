//
//  LoadingView.m
//  AdAliveStore
//
//  Created by Erico GT on 9/20/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

@synthesize activityIndicator, lblMessage, imvBackground, imvCenter, lblDownload, btnDownloadCancel;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)startWithMessage:(NSString*)message
{
    lblDownload.alpha = 0.0;
    //
    btnDownloadCancel.alpha = 0.0;
    lblMessage.text = message;
    //
    [activityIndicator startAnimating];
}

- (void)stop
{
    lblDownload.alpha = 0.0;
    btnDownloadCancel.alpha = 0.0;
    lblMessage.text = @"";
    //
    [activityIndicator stopAnimating];
}

- (void)updateMessage:(NSString*)message
{
    dispatch_async(dispatch_get_main_queue(),^{
        lblDownload.alpha = 1.0;
        //btnDownloadCancel.alpha = 1.0;
        lblDownload.text = message;
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
