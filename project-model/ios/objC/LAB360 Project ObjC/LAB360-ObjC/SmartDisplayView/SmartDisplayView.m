//
//  SmartDisplayView.m
//  LAB360-ObjC
//
//  Created by Erico GT on 28/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "SmartDisplayView.h"

#define SMART_DISPLAY_VIEW_DEFAULT_ANIMATION_FRAME_RATE 60.0
#define SMART_DISPLAY_VIEW_ANIMATION_SPEED_PT_PER_SECOND 60.0

@interface SmartDisplayView()

@property (nonatomic, assign) SmartDisplayViewOrientation animationOrientation;

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) UIImageView *displayImageView;

@property (nonatomic, assign) CGFloat animationSpeed;
@property (nonatomic, assign) CGFloat animationUpdateInterval;
@property (nonatomic, assign) CGFloat animationRotationFactor;
//
@property (nonatomic, assign) CGFloat motionRate;
@property (nonatomic, assign) CGFloat minimumOffset;
@property (nonatomic, assign) CGFloat maximumOffset;
//
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) BOOL pauseAnimation;
@property (nonatomic, assign) BOOL reverseAnimation;

@end

@implementation SmartDisplayView

@synthesize displayImage, animationSpeed, animationOrientation, animationTransition, autoAdjustToDeviceOrientationChange;
@synthesize containerView, displayImageView;
@synthesize animationUpdateInterval, animationRotationFactor, motionRate, minimumOffset, maximumOffset, animationTimer, pauseAnimation, reverseAnimation;

#pragma mark - INIT

-(instancetype)init
{
    if (self = [super init]) {
        NSAssert(false, @"Inicializador inválido para este tipo de objeto.");
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        [self commonInit];
        return self;
    }
    
    return nil;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self){
        [self commonInit];
        return self;
    }
    
    return nil;
}

-(void)dealloc
{
    [animationTimer invalidate];
    animationTimer = nil;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor blackColor];
    //
    displayImage = nil;
    animationOrientation = SmartDisplayViewOrientationLeftToRight;
    animationTransition = SmartDisplayViewAnimationTransitionRestart;
    autoAdjustToDeviceOrientationChange = YES;
    //
    containerView = [[UIScrollView alloc] initWithFrame:self.frame];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView setUserInteractionEnabled:NO];
    [containerView setBounces:NO];
    [containerView setContentSize:CGSizeZero];
    [self addSubview:self.containerView];
    //
    displayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    displayImageView.backgroundColor = [UIColor clearColor];
    [displayImageView setUserInteractionEnabled:NO];
    displayImageView.clipsToBounds = YES;
    displayImageView.contentMode = UIViewContentModeScaleAspectFill;
    displayImageView.image = nil;
    [containerView addSubview:displayImageView];
    [containerView setContentSize:displayImageView.frame.size];
    
    //control:
    animationUpdateInterval = 1.0 / SMART_DISPLAY_VIEW_DEFAULT_ANIMATION_FRAME_RATE;
    animationRotationFactor = 1.0;
    //
    motionRate = 0.0;
    minimumOffset = 0.0;
    maximumOffset = 0.0;
    animationSpeed = 1.0;
    pauseAnimation = YES;
    reverseAnimation = NO;
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionDeviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - PUBLIC METHODS

+ (SmartDisplayView*)newSmartDisplayViewWithFrame:(CGRect)frame image:(UIImage *)image parentView:(UIView *)parentView
{
    SmartDisplayView *sdv = [[SmartDisplayView alloc] initWithFrame:frame];
    sdv.displayImage = image;
    sdv.displayImageView.image = sdv.displayImage;
    //
    if (parentView){
        [parentView addSubview:sdv];
        [sdv addConstraintToView:sdv andParent:parentView];
    }
    //
    [sdv updateContentLayout];
    //
    return sdv;
}

- (void) updateContentLayout
{
    pauseAnimation = YES;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    [self calculateOrientation];
    
    if (animationOrientation == SmartDisplayViewOrientationLeftToRight || animationOrientation == SmartDisplayViewOrientationRightToLeft){
        width = (displayImage.size.width / displayImage.size.height) * height;
    }else{
        height = width / (displayImage.size.width / displayImage.size.height);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [displayImageView setFrame:CGRectMake(0, 0, width, height)];
        [containerView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [containerView setContentSize:displayImageView.frame.size];
    }];
    
    [self layoutIfNeeded];
    
    [animationTimer invalidate];
}

- (void) startAnimating
{
    pauseAnimation = YES;
    reverseAnimation = NO;
    containerView.tag = 0;
    
    if (animationTimer){
        [animationTimer invalidate];
    }
    
    minimumOffset = 0.0;
    
    if (displayImage == nil){
        return;
    }else{
        
        [self calculateOrientation];
    }
    
    //NOTE: O código comentado abaixo deve ser usado quando se deseja que o display mostre todo seu conteúdo num determinado tempo.
//    if (animationOrientation == SmartDisplayViewOrientationLeftToRight || animationOrientation == SmartDisplayViewOrientationRightToLeft){
//        motionRate = (self.displayImageView.frame.size.width - self.frame.size.width) / (SMART_DISPLAY_VIEW_DEFAULT_ANIMATION_FRAME_RATE * animationSpeed);
//    }else{
//        motionRate = (self.displayImageView.frame.size.height - self.frame.size.height) / (SMART_DISPLAY_VIEW_DEFAULT_ANIMATION_FRAME_RATE * animationSpeed);
//    }
    
    //NOTE: Por padrão a velocidade da animação será de 60pt por segundo.
    motionRate = (SMART_DISPLAY_VIEW_DEFAULT_ANIMATION_FRAME_RATE / SMART_DISPLAY_VIEW_ANIMATION_SPEED_PT_PER_SECOND) * animationSpeed;
    
    switch (animationOrientation) {
        case SmartDisplayViewOrientationLeftToRight:{
            containerView.contentOffset = CGPointMake(0.0, 0.0);
            maximumOffset = (containerView.contentSize.width - containerView.frame.size.width);
        }break;
            
        case SmartDisplayViewOrientationRightToLeft:{
            containerView.contentOffset = CGPointMake((containerView.contentSize.width - containerView.frame.size.width), 0.0);
            maximumOffset = (containerView.contentSize.width - containerView.frame.size.width);
        }break;
            
        case SmartDisplayViewOrientationTopToBottom:{
            containerView.contentOffset = CGPointMake(0.0, 0.0);
            maximumOffset = (containerView.contentSize.height - containerView.frame.size.height);
        }break;
            
        case SmartDisplayViewOrientationBottomToTop:{
            containerView.contentOffset = CGPointMake(0.0, (containerView.contentSize.height - containerView.frame.size.height));
            maximumOffset = (containerView.contentSize.height - containerView.frame.size.height);
        }break;
    }
    
    animationTimer = [NSTimer timerWithTimeInterval:animationUpdateInterval target:self selector:@selector(transition) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:animationTimer forMode:NSRunLoopCommonModes];
    
    //[NSTimer scheduledTimerWithTimeInterval:beacon.adAliveAction.autoCloseTime target:self selector:@selector(hideCurrentMirrorScreenForBeaconProduct:) userInfo:nil repeats:NO];
    
    pauseAnimation = NO;
}

- (void) transition
{
    if (pauseAnimation || containerView.tag == 1){
        return;
    }
    
    //CGFloat rotationRate = 0.3;
    
    CGFloat offsetX = containerView.contentOffset.x;
    CGFloat offsetY = containerView.contentOffset.y;
    
    switch (animationOrientation) {
        case SmartDisplayViewOrientationLeftToRight:{
            if (reverseAnimation){
                //offsetX += motionRate;
                offsetX -= motionRate;
            }else{
                //offsetX -= motionRate;
                offsetX += motionRate;
            }
        }break;
            
        case SmartDisplayViewOrientationRightToLeft:{
            if (reverseAnimation){
                //offsetX -= motionRate;
                offsetX += motionRate;
            }else{
                //offsetX += motionRate;
                offsetX -= motionRate;
            }
        }break;
            
        case SmartDisplayViewOrientationTopToBottom:{
            
            if (reverseAnimation){
                offsetY -= motionRate;
            }else{
                offsetY += motionRate;
            }
        }break;
            
        case SmartDisplayViewOrientationBottomToTop:{
            if (reverseAnimation){
                offsetY += motionRate;
            }else{
                offsetY -= motionRate;
            }
        }break;
    }
    
    //*************************************************
    
    BOOL needRestartSmoothly = NO;
    BOOL needRevertSmoothly = NO;
    
    switch (animationTransition) {
            
        case SmartDisplayViewAnimationTransitionRestart:{
            //Recomeça o display:
            if (animationOrientation == SmartDisplayViewOrientationLeftToRight || animationOrientation == SmartDisplayViewOrientationRightToLeft){
                if (offsetX > maximumOffset) {
                    offsetX = minimumOffset;
                } else if (offsetX < minimumOffset) {
                    offsetX = maximumOffset;
                }
            }else{
                if (offsetY > maximumOffset) {
                    offsetY = minimumOffset;
                } else if (offsetY < minimumOffset) {
                    offsetY = maximumOffset;
                }
            }
        }break;
            
        case SmartDisplayViewAnimationTransitionRestartSmoothly:{
            //Recomeça o display:
            if (animationOrientation == SmartDisplayViewOrientationLeftToRight || animationOrientation == SmartDisplayViewOrientationRightToLeft){
                if (offsetX > maximumOffset) {
                    offsetX = minimumOffset;
                    needRestartSmoothly = YES;
                } else if (offsetX < minimumOffset) {
                    offsetX = maximumOffset;
                    needRestartSmoothly = YES;
                }
            }else{
                if (offsetY > maximumOffset) {
                    offsetY = minimumOffset;
                    needRestartSmoothly = YES;
                } else if (offsetY < minimumOffset) {
                    offsetY = maximumOffset;
                    needRestartSmoothly = YES;
                }
            }
        }break;
            
        case SmartDisplayViewAnimationTransitionRevert:{
            //Vai e volta o display:
            if (animationOrientation == SmartDisplayViewOrientationLeftToRight || animationOrientation == SmartDisplayViewOrientationRightToLeft){
                if (offsetX > maximumOffset) {
                    offsetX = maximumOffset;
                    reverseAnimation = !reverseAnimation;
                } else if (offsetX < minimumOffset) {
                    offsetX = minimumOffset;
                    reverseAnimation = !reverseAnimation;
                }
            }else{
                if (offsetY > maximumOffset) {
                    offsetY = maximumOffset;
                    reverseAnimation = !reverseAnimation;
                } else if (offsetY < minimumOffset) {
                    offsetY = minimumOffset;
                    reverseAnimation = !reverseAnimation;
                }
            }
        }break;
            
        case SmartDisplayViewAnimationTransitionRevertSmoothly:{
            //Vai e volta o display:
            if (animationOrientation == SmartDisplayViewOrientationLeftToRight || animationOrientation == SmartDisplayViewOrientationRightToLeft){
                if (offsetX > maximumOffset) {
                    offsetX = maximumOffset;
                    reverseAnimation = !reverseAnimation;
                    needRevertSmoothly = YES;
                } else if (offsetX < minimumOffset) {
                    offsetX = minimumOffset;
                    reverseAnimation = !reverseAnimation;
                    needRevertSmoothly = YES;
                }
            }else{
                if (offsetY > maximumOffset) {
                    offsetY = maximumOffset;
                    reverseAnimation = !reverseAnimation;
                    needRevertSmoothly = YES;
                } else if (offsetY < minimumOffset) {
                    offsetY = minimumOffset;
                    reverseAnimation = !reverseAnimation;
                    needRevertSmoothly = YES;
                }
            }
        }break;
            
    }
    
    //Animando:
    if (needRestartSmoothly){
        containerView.tag = 1;
        [UIView animateWithDuration:0.5 animations:^{
            containerView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [containerView setContentOffset:CGPointMake(offsetX, offsetY)];
            [UIView animateWithDuration:0.5 animations:^{
                containerView.alpha = 1.0;
            } completion:^(BOOL finished) {
                containerView.tag = 0;
            }];
        }];
    }else if (needRevertSmoothly){
        containerView.tag = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            containerView.tag = 0;
        });
    }else{
        [UIView animateWithDuration:animationUpdateInterval delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            [containerView setContentOffset:CGPointMake(offsetX, offsetY)];
        }completion:nil];
    }
}

- (void)calculateOrientation
{
    CGFloat viewRatio = self.frame.size.width / self.frame.size.height;
    CGFloat imageRatio = displayImage.size.width / displayImage.size.height;
    
    if (viewRatio > 1.0){
        //view horizontal
        if (imageRatio > 1.0){
            //image horizontal
            if (imageRatio > viewRatio){
                animationOrientation = SmartDisplayViewOrientationLeftToRight;
            }else{
                animationOrientation = SmartDisplayViewOrientationTopToBottom;
            }
        }else{
            //image vertical
            animationOrientation = SmartDisplayViewOrientationTopToBottom;
        }
    }else{
        //view vertical
        if (imageRatio > 1.0){
            //image horizontal
            animationOrientation = SmartDisplayViewOrientationLeftToRight;
        }else{
            //image vertical
            if (imageRatio > viewRatio){
                animationOrientation = SmartDisplayViewOrientationLeftToRight;
            }else{
                animationOrientation = SmartDisplayViewOrientationTopToBottom;
            }
        }
    }
}

- (void) pauseAnimation:(BOOL)pause
{
    self.pauseAnimation = pause;
}

- (void)stopAnimating
{
    [animationTimer invalidate];
    animationTimer = nil;
    pauseAnimation = YES;
    //
    [containerView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:NO];
}

#pragma mark - PRIVATE METHODS

- (void)actionDeviceOrientationDidChangeNotification:(NSNotification*)notification
{
    if (autoAdjustToDeviceOrientationChange){
        UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
        
        if (deviceOrientation != UIDeviceOrientationUnknown && deviceOrientation != UIDeviceOrientationFaceUp && deviceOrientation != UIDeviceOrientationFaceDown) {
            if (animationTimer){
                BOOL needRestart = !pauseAnimation;
                [self updateContentLayout];
                if (needRestart){
                    [self startAnimating];
                }
            }
        }
    }
}

- (void)addConstraintToView:(UIView*)subview andParent:(UIView*)parentView
{
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Leading
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:subview
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:parentView
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    
    //Trailing
    NSLayoutConstraint *trailing =[NSLayoutConstraint
                                   constraintWithItem:subview
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:parentView
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:0.f];
    
    //Top
    NSLayoutConstraint *top =[NSLayoutConstraint
                              constraintWithItem:subview
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:parentView
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0f
                              constant:0.f];
    
    //Bottom
    NSLayoutConstraint *bottom =[NSLayoutConstraint
                                 constraintWithItem:subview
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:parentView
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                 constant:0.f];
    
    for (NSLayoutConstraint *c in [parentView constraints]){
        [parentView removeConstraint:c];
    }
    
    [parentView addConstraint:trailing];
    [parentView addConstraint:leading];
    [parentView addConstraint:top];
    [parentView addConstraint:bottom];
    //
    [parentView setNeedsLayout];
    [parentView layoutIfNeeded];
}

@end
