//
//  AdAliveView.h
//  testingLib
//
//  Created by Monique Trevisan on 21/09/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdAliveViewDelegate.h"
#import "ButtonActionDelegate.h"
#import "AdAliveCamera.h"
#import "AdAliveVideoEffects.h"

@interface AdAliveView : UIView

#pragma mark - Properties

@property(nonatomic, assign) id<AdAliveViewDelegate> delegate;
@property(nonatomic, assign) id<ButtonActionDelegate> buttonDelegate;

#pragma mark - Methods

//Init and Prepare
- (id) initWithFrame:(CGRect)frame viewController:(UIViewController *) viewController andCamera:(AdAliveCamera *)adAlive;
- (void) prepareWithVideoUrl:(NSString *)url;

//Render
- (void) renderFrame;
- (void) updateRenderingPrimitives;

//Video Control
- (void) playARVideoWithURL:(NSString *)videoUrl usingEffects:(AdAliveVideoEffects*)effects andButtons:(NSArray *)arrayButtons;
- (void) stopVideoAR;
- (void) pauseVideoAR;
- (void) resumeVideoAR;
- (bool) handleTouchPoint:(CGPoint) point;
//
- (float)getVolumeFromVideoAR;
- (void)setVolumeToVideoAR:(float)value;

//OpenGL
- (void) finishOpenGLESCommands;
- (void) freeOpenGLESResources;

@end

