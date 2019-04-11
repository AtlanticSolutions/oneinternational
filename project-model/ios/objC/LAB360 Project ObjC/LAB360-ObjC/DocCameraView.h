//
// IRLCameraView.h
//
//  Modified by Denis Martin on 12/07/2015
//  Based on IPDFCameraViewController: https://github.com/mmackh/IPDFCameraViewController/tree/master/IPDFCameraViewController
//  Copyright (c) 2015 mackh ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <GLKit/GLKit.h>

#import "DocScannerViewController.h"

@protocol DocCameraViewProtocol;

@interface DocCameraView : UIView

- (void)setupCameraView;
- (void)start;
- (void)stop;

@property (weak)    id<DocCameraViewProtocol>  delegate;

@property (nonatomic, readwrite)    NSUInteger      minimumConfidenceForFullDetection;  // Default 80
@property (nonatomic, readonly)     NSUInteger      maximumConfidenceForFullDetection;  // Default 100

@property (readwrite, strong, nonatomic)   UIColor *overlayColor;

- (UIImage*)latestCorrectedUIImage;

@property (nonatomic,assign,    getter=isBorderDetectionEnabled)    BOOL enableBorderDetection;
@property (nonatomic,assign,    getter=isTorchEnabled)              BOOL enableTorch;
@property (nonatomic,readonly,  getter=hasFlash)                    BOOL flash;

@property (nonatomic,assign)    DocScannerViewType                   cameraViewType;
@property (nonatomic,assign)    DocScannerDetectorType               detectorType;         // Default IRLScannerDetectorTypeAccuracy

@property (nonatomic,assign,    getter=isDrawCenterEnabled)         BOOL enableDrawCenter;
@property (nonatomic,assign,    getter=isShowAutoFocusEnabled)      BOOL enableShowAutoFocus;

- (void)focusAtPoint:(CGPoint)point completionHandler:(void(^)(void))completionHandler;

- (void)captureImageWithCompletionHander:(void(^)(UIImage* image))completionHandler;

@end


@protocol DocCameraViewProtocol <NSObject>

@optional
/**
 @brief this optional delegation method will notify the Delegate of the confidence we detected a Rectangle
 
 @param view            The IRLCameraView calling the delegate
 @param confidence      A value between 0 .. 100% indicating the confidence of the detection
 */
-(void)didDetectRectangle:(DocCameraView*)view withConfidence:(NSUInteger)confidence;

-(void)didGainFullDetectionConfidence:(DocCameraView*)view;

-(void)didLostConfidence:(DocCameraView*)view;

@end
