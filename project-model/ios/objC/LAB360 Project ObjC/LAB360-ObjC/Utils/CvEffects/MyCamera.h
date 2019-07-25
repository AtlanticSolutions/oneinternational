//
//  MyCamera.h
//  AdAlive
//
//  Created by Jader Bruno Pereira Lima on 5/2/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#ifndef MyCamera_h
#define MyCamera_h


#import <opencv2/highgui/cap_ios.h>

@interface MyCamera : CvVideoCamera

- (void)updateOrientation;
- (void)layoutPreviewLayer;

@property (nonatomic, retain) CALayer *customPreviewLayer;

@end

#endif /* MyCamera_h */
