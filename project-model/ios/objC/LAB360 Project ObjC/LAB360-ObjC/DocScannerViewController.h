//
//  DocScannerViewController.h
//  LAB360-ObjC
//
//  Created by Erico GT on 02/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DocScannerViewController;

typedef NS_ENUM(NSInteger,DocScannerViewType)
{
    DocScannerViewTypeNormal,
    DocScannerViewTypeBlackAndWhite,
    DocScannerViewTypeUltraContrast
};

typedef NS_ENUM(NSInteger,DocScannerDetectorType)
{
    DocScannerDetectorTypeAccuracy,
    DocScannerDetectorTypePerformance
};

@protocol DocScannerViewControllerDelegate <NSObject>

@required
-(void)pageSnapped:(UIImage *)image from:(DocScannerViewController*)cameraView;

@optional
//-(NSString*)cameraViewWillUpdateTitleLabel:(DocScannerViewController*)cameraView;

@end

@interface DocScannerViewController : UIViewController

-(instancetype)init NS_UNAVAILABLE;

+ (instancetype)cameraViewWithDefaultType:(DocScannerViewType)type defaultDetectorType:(DocScannerDetectorType)detector withDelegate:(id<DocScannerViewControllerDelegate>)delegate;

@property (readwrite, nonatomic) UIColor* detectionOverlayColor;
@property (readonly, nonatomic) DocScannerViewType cameraViewType;
@property (readonly, nonatomic) DocScannerDetectorType detectorType;
//@property (readwrite, nonatomic) BOOL showAutoFocusWhiteRectangle;
//
@property (nonatomic, strong) NSString *screenTitle;

@end
