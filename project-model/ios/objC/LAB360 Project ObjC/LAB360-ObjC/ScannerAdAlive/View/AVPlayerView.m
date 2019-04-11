//
//  AVPlayerView.m
//  LAB360-ObjC
//
//  Created by Erico GT on 01/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "AVPlayerView.h"
#import "ToolBox.h"

#define AVPLAYERVIEW_LAYER_NAME_LAB360 @"avplayerview_layer_name_lab360"

@interface AVPlayerView()

//Data:
@property(nonatomic, strong) UIImage *imageClose;
@property(nonatomic, strong) UIImage *imagePlay;
@property(nonatomic, strong) UIImage *imagePause;
@property(nonatomic, strong) UIImage *imageSoundOn;
@property(nonatomic, strong) UIImage *imageSoundOff;
//
@property(nonatomic, assign) BOOL isControlsViewVisible;

//View:
//@property(nonatomic, weak) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) UIView *viewControls;
@property(nonatomic, strong) UIButton *btnClose;
@property(nonatomic, strong) UIButton *btnPlay;
@property(nonatomic, strong) UIButton *btnSound;

@end

@implementation AVPlayerView

@synthesize delegate;
@synthesize imageClose, imagePlay, imagePause, imageSoundOn, imageSoundOff, isControlsViewVisible;
@synthesize viewControls, btnClose, btnPlay, btnSound;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commomConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commomConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commomConfig];
    }
    return self;
}

#pragma mark -

- (void)commomConfig
{
    self.opaque = NO;
    self.layer.opaque = NO;
    self.backgroundColor = [UIColor redColor]; //[UIColor clearColor];
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    self.clipsToBounds = YES;
    
    //playerLayer = nil;
    
    //images
    imageClose = [UIImage imageNamed:@"icon-videoplayer-close"];
    imagePlay = [UIImage imageNamed:@"icon-videoplayer-resume"];
    imagePause = [UIImage imageNamed:@"icon-videoplayer-pause"];
    imageSoundOn = [UIImage imageNamed:@"icon-videoplayer-muteon"];
    imageSoundOff = [UIImage imageNamed:@"icon-videoplayer-muteoff"];
    
    //controls
    viewControls = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 196.0, 44.0)];
    viewControls.backgroundColor = [UIColor darkGrayColor];
    viewControls.layer.cornerRadius = 5.0;
    
    btnClose = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnClose setFrame:CGRectMake(4.0, 4.0, 60.0, 36.0)];
    [btnClose setBackgroundColor:[UIColor blackColor]];
    [btnClose setTintColor:[UIColor whiteColor]];
    [btnClose setImage:imageClose forState:UIControlStateNormal];
    btnClose.layer.cornerRadius = 4.0;
    [btnClose setExclusiveTouch:YES];
    [btnClose addTarget:self action:@selector(actionClose:) forControlEvents:UIControlEventTouchUpInside];
    
    btnPlay = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnPlay setFrame:CGRectMake(4.0 + 60.0 + 4.0, 4.0, 60.0, 36.0)];
    [btnPlay setBackgroundColor:[UIColor blackColor]];
    [btnPlay setTintColor:[UIColor whiteColor]];
    [btnPlay setImage:imagePause forState:UIControlStateNormal];
    btnPlay.layer.cornerRadius = 4.0;
    [btnPlay setExclusiveTouch:YES];
    [btnPlay addTarget:self action:@selector(actionPlay:) forControlEvents:UIControlEventTouchUpInside];
    btnPlay.tag = 1;
    
    btnSound = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnSound setFrame:CGRectMake(4.0 + 60.0 + 4.0 + 60.0 + 4.0, 4.0, 60.0, 36.0)];
    [btnSound setBackgroundColor:[UIColor blackColor]];
    [btnSound setTintColor:[UIColor whiteColor]];
    [btnSound setImage:imageSoundOff forState:UIControlStateNormal];
    btnSound.layer.cornerRadius = 4.0;
    [btnSound setExclusiveTouch:YES];
    [btnSound addTarget:self action:@selector(actionSound:) forControlEvents:UIControlEventTouchUpInside];
    btnSound.tag = 1;
    
    [viewControls addSubview:btnClose];
    [viewControls addSubview:btnPlay];
    [viewControls addSubview:btnSound];
    
    [viewControls setAlpha:0.0];
    isControlsViewVisible = NO;
    [self addSubview:viewControls];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    
    [self setHidden:YES];
}

#pragma mark -

- (void)playVideoUsingExternalPlayer:(AVPlayer*)player
{
    BOOL needRestartControls = YES;
    
    AVPlayerLayer *currentPlayerLayer = [self currentAVPlayerLayer];
    if (currentPlayerLayer){
        
        if (currentPlayerLayer.player == player){
            needRestartControls = NO;
        }
        
        [currentPlayerLayer removeFromSuperlayer];
        currentPlayerLayer.player = nil;
        currentPlayerLayer = nil;
    }
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.opaque = NO;
    playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    playerLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    playerLayer.needsDisplayOnBoundsChange = YES;
    [playerLayer setPixelBufferAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@(kCVPixelFormatType_32BGRA), kCVPixelBufferPixelFormatTypeKey, nil]];
    playerLayer.name = AVPLAYERVIEW_LAYER_NAME_LAB360;
    
    [self orientationChanged:nil];
    
    [self.layer addSublayer:playerLayer];
    
    [self bringSubviewToFront:viewControls];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    if (needRestartControls){
        btnPlay.tag = 1;
        btnSound.tag = 1;
    }
    
    [self setHidden:NO];
}

- (void)stopVideo
{
    AVPlayerLayer *currentPlayerLayer = [self currentAVPlayerLayer];
    if (currentPlayerLayer){
        [currentPlayerLayer removeFromSuperlayer];
        currentPlayerLayer.player = nil;
        currentPlayerLayer = nil;
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self setHidden:YES];
}

#pragma mark -

- (IBAction)actionClose:(UIButton*)sender
{
    NSLog(@"actionClose:");
    
    if (self.delegate){
        if ([self.delegate respondsToSelector:@selector(avPlayerViewActionForCloseButton:)]){
            BOOL state = [self.delegate avPlayerViewActionForCloseButton:self];
            if (state){
                [self hideViewControls];
            }
        }
    }
}

- (IBAction)actionPlay:(UIButton*)sender
{
    NSLog(@"actionPlay:");
    
    if (self.delegate){
        if ([self.delegate respondsToSelector:@selector(avPlayerViewActionForPlayButton:)]){
            BOOL state = [self.delegate avPlayerViewActionForPlayButton:self];
            if (state){
                btnPlay.tag = 1;
                [btnPlay setImage:imagePause forState:UIControlStateNormal];
            }else{
                btnPlay.tag = 0;
                [btnPlay setImage:imagePlay forState:UIControlStateNormal];
            }
        }
    }
    
    [self hideViewControls];
}

- (IBAction)actionSound:(UIButton*)sender
{
    NSLog(@"actionSound:");
    
    if (self.delegate){
        if ([self.delegate respondsToSelector:@selector(avPlayerViewActionForMuteButton:)]){
            BOOL state = [self.delegate avPlayerViewActionForMuteButton:self];
            if (state){
                btnSound.tag = 1;
                [btnSound setImage:imageSoundOff forState:UIControlStateNormal];
            }else{
                btnSound.tag = 0;
                [btnSound setImage:imageSoundOn forState:UIControlStateNormal];
            }
        }
    }
    
    [self hideViewControls];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (isControlsViewVisible == NO){
            
            [self setUserInteractionEnabled:NO];
            
            //viewcontrol size:
            [viewControls setFrame:CGRectMake((self.frame.size.width - viewControls.frame.size.width) / 2.0, 20.0, viewControls.frame.size.width, viewControls.frame.size.height)];
            
            //buttons control
            [btnClose setImage:imageClose forState:UIControlStateNormal];
            //
            if (btnPlay.tag == 1){
                [btnPlay setImage:imagePause forState:UIControlStateNormal];
            }else{
                [btnPlay setImage:imagePlay forState:UIControlStateNormal];
            }
            //
            if (btnSound.tag == 1){
                [btnSound setImage:imageSoundOff forState:UIControlStateNormal];
            }else{
                [btnSound setImage:imageSoundOn forState:UIControlStateNormal];
            }
            
            //animation:
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [viewControls setAlpha:1.0];
            } completion:^(BOOL finished) {
                isControlsViewVisible = YES;
                [self setUserInteractionEnabled:YES];
            }];
            
        }else{
            
            [self setUserInteractionEnabled:NO];
            
            //animation:
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [viewControls setAlpha:0.0];
            } completion:^(BOOL finished) {
                isControlsViewVisible = NO;
                [self setUserInteractionEnabled:YES];
            }];
            
        }
    }
}

- (void)hideViewControls
{
    if (isControlsViewVisible == YES){
        [self setUserInteractionEnabled:NO];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [viewControls setAlpha:0.0];
        } completion:^(BOOL finished) {
            isControlsViewVisible = NO;
            [self setUserInteractionEnabled:YES];
        }];
    }
}

#pragma mark -

- (void)orientationChanged:(NSNotification *)notification
{
    AVPlayerLayer *playerLayer = [self currentAVPlayerLayer];
    if (playerLayer == nil){
        return;
    }
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    switch (orientation) {
            
        case UIDeviceOrientationLandscapeLeft:{
           // Device oriented horizontally, home button on the right
            playerLayer.frame = CGRectMake((self.frame.size.width - self.frame.size.height) / 2.0, (self.frame.size.height - self.frame.size.width) / 2.0, self.frame.size.height, self.frame.size.width);
            playerLayer.bounds = CGRectMake(0.0, 0.0, self.frame.size.height, self.frame.size.width);
            playerLayer.transform = CATransform3DRotate(CATransform3DIdentity, [ToolBox converterHelper_DegreeToRadian:90.0], 0.0, 0.0, 1.0);
        }break;
            
        case UIDeviceOrientationLandscapeRight:{
            // Device oriented horizontally, home button on the left
            playerLayer.frame = CGRectMake((self.frame.size.width - self.frame.size.height) / 2.0, (self.frame.size.height - self.frame.size.width) / 2.0, self.frame.size.height, self.frame.size.width);
            playerLayer.bounds = CGRectMake(0.0, 0.0, self.frame.size.height, self.frame.size.width);
            playerLayer.transform = CATransform3DRotate(CATransform3DIdentity, [ToolBox converterHelper_DegreeToRadian:-90.0], 0.0, 0.0, 1.0);
        }break;
            
        default:{
            //all others (UIDeviceOrientationUnknown, UIDeviceOrientationPortrait, UIDeviceOrientationPortraitUpsideDown, UIDeviceOrientationFaceUp, UIDeviceOrientationFaceDown)
            playerLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
            playerLayer.bounds = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
            playerLayer.transform = CATransform3DRotate(CATransform3DIdentity, [ToolBox converterHelper_DegreeToRadian:0.0], 0.0, 0.0, 1.0);
        }break;
            
    }
    
    [playerLayer setNeedsDisplay];
    
}

#pragma mark -

- (AVPlayerLayer*)currentAVPlayerLayer
{
    AVPlayerLayer *cP = nil;
    for (CALayer *layer in self.layer.sublayers){
        if ([layer isKindOfClass:[AVPlayerLayer class]]){
            if ([layer.name isEqualToString:AVPLAYERVIEW_LAYER_NAME_LAB360]){
                cP = (AVPlayerLayer*)layer;
                break;
            }
        }
    }
    return cP;
}

@end
