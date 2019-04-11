//
//  MaskViewController.h
//  AdAlive
//
//  Created by Lab360 on 4/8/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/ios.h>
#import <opencv2/opencv.hpp>

#import "RetroFilter.hpp"
#import "FaceAnimator.hpp"
#import "MyCamera.h"

@interface MaskViewController : UIViewController <CvVideoCameraDelegate>
{
    BOOL isCapturing;
    FaceAnimator::Parameters parameters;
    cv::Ptr<FaceAnimator> faceAnimator;
}

@property (nonatomic, strong) MyCamera* videoCamera;
@property (nonatomic, strong) NSArray *maskCollection;

@end
