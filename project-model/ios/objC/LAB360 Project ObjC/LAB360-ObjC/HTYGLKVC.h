//
//  HTYGLKVC.h
//  HTY360Player
//
//  Created by  on 11/8/15.
//  Copyright © 2015 Hanton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class Video360VC;

@interface HTYGLKVC : GLKViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic, readwrite) Video360VC* videoPlayerController;
@property (assign, nonatomic, readonly) BOOL isUsingMotion;

- (void)startDeviceMotion;
- (void)stopDeviceMotion;

@end
