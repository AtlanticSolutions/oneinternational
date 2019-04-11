//
//  LoadingViewLAB360.m
//  LAB360-ObjC
//
//  Created by Erico GT on 01/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#import "LoadingViewLAB360.h"
#import "ToolBox.h"

@interface LoadingViewLAB360()<CAAnimationDelegate>

//data
@property (nonatomic, strong) CAShapeLayer *containerDrawLayer;
@property (nonatomic, strong) CAShapeLayer *verticalDrawLayer;
@property (nonatomic, strong) CAShapeLayer *arcDrawLayer;
@property (nonatomic, strong) CAShapeLayer *detailDrawLayer;
//
@property (nonatomic, assign) BOOL loopActive;

//layout
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation LoadingViewLAB360

@synthesize logoBackgroundImage, logoBackgroundColor, logoPrimaryColor, logoSecondaryColor;
@synthesize containerDrawLayer, verticalDrawLayer, arcDrawLayer, detailDrawLayer, loopActive;
@synthesize backgroundImageView;

#pragma mark - Private

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    logoBackgroundImage = nil;
    logoBackgroundColor = [UIColor clearColor];
    logoPrimaryColor = [UIColor whiteColor];
    logoSecondaryColor = [UIColor clearColor];
    loopActive = NO;
    //
    backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    [backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
    [backgroundImageView setClipsToBounds:YES];
    [backgroundImageView setAlpha:0.0];
    [self addSubview:backgroundImageView];
    //
    [self.layer setMasksToBounds:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect mainFrame = self.frame;
    //
    CGFloat referenceFrameSide = fmin(mainFrame.size.width, mainFrame.size.height);
    CGFloat xMargin = (self.frame.size.width - referenceFrameSide) / 2.0;
    CGFloat yMargin = (self.frame.size.height - referenceFrameSide) / 2.0;
    //
    backgroundImageView.frame = CGRectMake(xMargin, yMargin, referenceFrameSide, referenceFrameSide);
}

#pragma mark -

- (void)didRecieveDidBecomeActiveNotification:(NSNotification*)notification
{
    if (loopActive && containerDrawLayer){
        [self startAnimating];
    }
}

#pragma mark - CAAnimationDelegate

//- (void)animationDidStart:(CAAnimation *)anim
//{
//
//}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(flag){
        
        CABasicAnimation *animatioVD = [verticalDrawLayer animationForKey:@"VerticalDestruction"];
        if (anim == animatioVD){
            [verticalDrawLayer removeFromSuperlayer];
            verticalDrawLayer = nil;
            return;
        }
        //
        CABasicAnimation *animationG = [containerDrawLayer animationForKey:@"AnimationGroup"];
        if (anim == animationG){
            if (loopActive){
                [self animateLogoRepeating:YES];
            }else{
                
                [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionAllowUserInteraction animations:^{
                    [backgroundImageView setAlpha:0.0];
                } completion:^(BOOL finished) {
                    [self clearLayers];
                    loopActive = NO;
                }];
                
            }
            
            return;
        }
    }
    
}


#pragma mark - Sets

- (void)setLogoBackgroundImage:(UIImage *)newLogoBackgroundImage
{
    logoBackgroundImage = newLogoBackgroundImage;
    backgroundImageView.image = logoBackgroundImage;
}

- (void)setLogoBackgroundColor:(UIColor *)newLogoBackgroundColor
{
    logoBackgroundColor = newLogoBackgroundColor;
    backgroundImageView.backgroundColor = logoBackgroundColor;
}

#pragma mark - Methods
+ (LoadingViewLAB360*) newLoadingViewWithFrame:(CGRect)frame primaryColor:(UIColor*)pColor andSecondaryColor:(UIColor*)sColor
{
    LoadingViewLAB360 *lv = [[LoadingViewLAB360 alloc] initWithFrame:frame];
    lv.logoPrimaryColor = pColor;
    lv.logoSecondaryColor = sColor;
    //
    return lv;
}

- (void)startOnceAnimation
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionAllowUserInteraction animations:^{
        [backgroundImageView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self animateLogoRepeating:NO];
    }];
}

- (void)startAnimating
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionAllowUserInteraction animations:^{
        [backgroundImageView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self animateLogoRepeating:YES];
    }];
}

- (void)stopAnimating
{
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionAllowUserInteraction animations:^{
        [backgroundImageView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self clearLayers];
        loopActive = NO;
    }];
}

- (void)clearLayers
{
    if (verticalDrawLayer){
        [verticalDrawLayer removeFromSuperlayer];
        verticalDrawLayer = nil;
    }
    //
    if (arcDrawLayer){
        [arcDrawLayer removeFromSuperlayer];
        arcDrawLayer = nil;
    }
    //
    if (detailDrawLayer){
        [detailDrawLayer removeFromSuperlayer];
        detailDrawLayer = nil;
    }
    //
    if (containerDrawLayer){
        [containerDrawLayer removeFromSuperlayer];
        containerDrawLayer = nil;
    }
}

- (void)animateLogoRepeating:(BOOL)repeating
{
    loopActive = repeating;
    
    //----------------------------------------------------------------------
    //GERAL
    //----------------------------------------------------------------------
    
    CGFloat referenceSide = fmin(self.frame.size.width, self.frame.size.height);
    CGFloat lineWidth = referenceSide * 0.095082; // referenceSide * 0.095082;
    
    CGFloat xMargin = (self.frame.size.width - referenceSide) / 2.0;
    CGFloat yMargin = (self.frame.size.height - referenceSide) / 2.0;
    
    [self clearLayers];
    
    containerDrawLayer = [[CAShapeLayer alloc] init];
    containerDrawLayer.frame = CGRectMake(xMargin, yMargin, referenceSide, referenceSide);
    [containerDrawLayer setOpaque:NO];
    [containerDrawLayer setBackgroundColor:[UIColor clearColor].CGColor];
    
    verticalDrawLayer = [[CAShapeLayer alloc] init];
    verticalDrawLayer.frame = CGRectMake(0.0, 0.0, referenceSide, referenceSide);
    [verticalDrawLayer setOpaque:NO];
    [verticalDrawLayer setBackgroundColor:[UIColor clearColor].CGColor];
    //
    [containerDrawLayer addSublayer:verticalDrawLayer];
    
    arcDrawLayer = [[CAShapeLayer alloc] init];
    arcDrawLayer.frame = CGRectMake(0.0, 0.0, referenceSide, referenceSide);
    [arcDrawLayer setOpaque:NO];
    [arcDrawLayer setBackgroundColor:[UIColor clearColor].CGColor];
    //
    [containerDrawLayer addSublayer:arcDrawLayer];
    
    detailDrawLayer = [[CAShapeLayer alloc] init];
    detailDrawLayer.frame = CGRectMake(0.0, 0.0, referenceSide, referenceSide);
    [detailDrawLayer setOpaque:NO];
    [detailDrawLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [containerDrawLayer addSublayer:detailDrawLayer];
    
    //----------------------------------------------------------------------
    //VERTICAL
    //----------------------------------------------------------------------
    
    CGFloat verticalHeight = referenceSide * 0.2;
    
    CGFloat borderY = (referenceSide / 2.0) - (referenceSide * (3.0 / 5.0) / 2.0);
    
    CGPoint verticalStartPoint = CGPointMake((referenceSide / 2.0), borderY - (verticalHeight * 0.25));
    CGPoint verticalEndPoint = CGPointMake((referenceSide / 2.0), verticalStartPoint.y + (verticalHeight - (lineWidth / 2.0)));
    
    UIBezierPath *verticalPath = [[UIBezierPath alloc] init];
    [verticalPath moveToPoint:verticalStartPoint];
    [verticalPath addLineToPoint:verticalEndPoint];
    
    verticalDrawLayer.path = verticalPath.CGPath;
    verticalDrawLayer.strokeColor = logoPrimaryColor.CGColor;
    verticalDrawLayer.lineWidth = lineWidth;
    verticalDrawLayer.lineCap = kCALineCapRound;
    verticalDrawLayer.lineJoin = kCALineJoinRound;
    verticalDrawLayer.fillColor = [UIColor clearColor].CGColor;
    verticalDrawLayer.strokeStart = 0.0f;
    verticalDrawLayer.strokeEnd = 0.0f;
    
    //----------------------------------------------------------------------
    //ARC
    //----------------------------------------------------------------------
    
    //reference angle offset = 34º
    CGFloat initArcAngle = [ToolBox converterHelper_DegreeToRadian:-56.0];
    CGFloat finalArcAngle = [ToolBox converterHelper_DegreeToRadian:236.0];
    
    CGPoint arcCenterPoint = CGPointMake(referenceSide / 2.0, referenceSide / 2.0);
    
    CGFloat arcRadius =  referenceSide * (3.0 / 5.0) / 2.0; //verticalHeight + (lineWidth / 2.0);
    
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:arcCenterPoint radius:arcRadius startAngle:initArcAngle endAngle:finalArcAngle clockwise:YES];
    arcDrawLayer.path = arcPath.CGPath;
    arcDrawLayer.strokeColor = logoPrimaryColor.CGColor;
    arcDrawLayer.lineWidth = lineWidth;
    arcDrawLayer.lineCap = kCALineCapRound;
    arcDrawLayer.lineJoin = kCALineJoinRound;
    arcDrawLayer.fillColor = [UIColor clearColor].CGColor;
    arcDrawLayer.strokeStart = 0.0f;
    arcDrawLayer.strokeEnd = 0.0f;
    
    //----------------------------------------------------------------------
    //DETAIL
    //----------------------------------------------------------------------
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(164.5 * (referenceSide / 612.0), 330.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(176.5 * (referenceSide / 612.0), 367.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(165.5 * (referenceSide / 612.0), 336.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(168.5 * (referenceSide / 612.0), 350.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(207.5 * (referenceSide / 612.0), 410.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(184.5 * (referenceSide / 612.0), 384.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(194.5 * (referenceSide / 612.0), 399.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(251.5 * (referenceSide / 612.0), 437.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(220.5 * (referenceSide / 612.0), 421.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(230.5 * (referenceSide / 612.0), 429.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(300.5 * (referenceSide / 612.0), 448.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(272.5 * (referenceSide / 612.0), 445.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(288.5 * (referenceSide / 612.0), 448.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(356.5 * (referenceSide / 612.0), 439.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(312.5 * (referenceSide / 612.0), 448.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(336.5 * (referenceSide / 612.0), 448.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(385.5 * (referenceSide / 612.0), 424.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(376.5 * (referenceSide / 612.0), 430.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(372.5 * (referenceSide / 612.0), 432.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(416.5 * (referenceSide / 612.0), 396.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(398.5 * (referenceSide / 612.0), 416.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(416.5 * (referenceSide / 612.0), 396.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(434.5 * (referenceSide / 612.0), 367.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(416.5 * (referenceSide / 612.0), 396.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(422.5 * (referenceSide / 612.0), 390.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(446.5 * (referenceSide / 612.0), 330.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(446.5 * (referenceSide / 612.0), 344.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(446.5 * (referenceSide / 612.0), 330.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(443.5 * (referenceSide / 612.0), 308.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(446.5 * (referenceSide / 612.0), 330.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(449.5 * (referenceSide / 612.0), 311.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(421.5 * (referenceSide / 612.0), 290.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(437.5 * (referenceSide / 612.0), 305.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(426.5 * (referenceSide / 612.0), 296.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(411.5 * (referenceSide / 612.0), 277.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(416.5 * (referenceSide / 612.0), 284.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(415.5 * (referenceSide / 612.0), 284.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(405.5 * (referenceSide / 612.0), 268.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(407.5 * (referenceSide / 612.0), 270.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(405.5 * (referenceSide / 612.0), 268.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(396.5 * (referenceSide / 612.0), 265.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(405.5 * (referenceSide / 612.0), 268.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(403.5 * (referenceSide / 612.0), 265.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(382.5 * (referenceSide / 612.0), 273.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(389.5 * (referenceSide / 612.0), 265.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(387.5 * (referenceSide / 612.0), 267.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(368.5 * (referenceSide / 612.0), 289.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(377.5 * (referenceSide / 612.0), 279.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(377.5 * (referenceSide / 612.0), 280.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(337.5 * (referenceSide / 612.0), 312.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(359.5 * (referenceSide / 612.0), 298.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(337.5 * (referenceSide / 612.0), 312.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(299.5 * (referenceSide / 612.0), 327.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(337.5 * (referenceSide / 612.0), 312.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(326.5 * (referenceSide / 612.0), 319.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(235.5 * (referenceSide / 612.0), 331.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(272.5 * (referenceSide / 612.0), 335.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(235.5 * (referenceSide / 612.0), 331.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(218.5 * (referenceSide / 612.0), 327.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(235.5 * (referenceSide / 612.0), 331.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(227.5 * (referenceSide / 612.0), 330.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(204.5 * (referenceSide / 612.0), 322.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(209.5 * (referenceSide / 612.0), 324.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(204.5 * (referenceSide / 612.0), 322.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(193.5 * (referenceSide / 612.0), 317.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(204.5 * (referenceSide / 612.0), 322.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(198.5 * (referenceSide / 612.0), 320.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(187.5 * (referenceSide / 612.0), 313.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(188.5 * (referenceSide / 612.0), 314.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(187.5 * (referenceSide / 612.0), 313.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(176.5 * (referenceSide / 612.0), 309.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(187.5 * (referenceSide / 612.0), 313.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(182.5 * (referenceSide / 612.0), 308.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(165.5 * (referenceSide / 612.0), 318.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(170.5 * (referenceSide / 612.0), 310.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(167.5 * (referenceSide / 612.0), 313.5 * (referenceSide / 612.0))];
    [bezierPath addCurveToPoint: CGPointMake(164.5 * (referenceSide / 612.0), 330.5 * (referenceSide / 612.0)) controlPoint1: CGPointMake(163.5 * (referenceSide / 612.0), 323.5 * (referenceSide / 612.0)) controlPoint2: CGPointMake(163.5 * (referenceSide / 612.0), 324.5 * (referenceSide / 612.0))];
    [bezierPath closePath];
    //
    detailDrawLayer.path = bezierPath.CGPath;
    detailDrawLayer.fillColor = logoSecondaryColor.CGColor;
    [detailDrawLayer setOpacity:0.0];
    
    [self applyAnimationsInLogoLayers];
    
    [self.layer addSublayer:containerDrawLayer];
}

#pragma mark - Animations

- (void)applyAnimationsInLogoLayers
{
    NSMutableArray *animations = [NSMutableArray array];
    CGFloat totalDuration = 0.0;
    
    //Vertical Creation
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = (id)[NSNumber numberWithFloat:0.000];
        animation.toValue = (id)[NSNumber numberWithFloat:1.f];
        animation.duration = 0.5f;
        animation.beginTime = CACurrentMediaTime() + totalDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [verticalDrawLayer addAnimation:animation forKey:@"VerticalCreation"];
        //
        [animations addObject:animation];
        //
        totalDuration += animation.duration;
    }
    
    //Detail Show
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = (id)[NSNumber numberWithFloat:0.000];
        animation.toValue = (id)[NSNumber numberWithFloat:1.f];
        animation.duration = 1.f;
        animation.beginTime = CACurrentMediaTime() + totalDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [detailDrawLayer addAnimation:animation forKey:@"DetailShowOpacity"];
        //
        [animations addObject:animation];
        //
        //totalDuration += animation.duration; (não soma tempo pois ocorre em paralelo)
    }
    
    //Arc Creation
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = (id)[NSNumber numberWithFloat:0.000];
        animation.toValue = (id)[NSNumber numberWithFloat:1.f];
        animation.duration = 1.f;
        animation.beginTime = CACurrentMediaTime() + totalDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [arcDrawLayer addAnimation:animation forKey:@"ArcCreation"];
        //
        [animations addObject:animation];
        //
        totalDuration += animation.duration;
    }
    
    //Extra Time
    totalDuration += 0.5;
    
    //Container Rotation
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue = (id)[NSNumber numberWithFloat:[ToolBox converterHelper_DegreeToRadian:0.0]];
        animation.toValue = (id)[NSNumber numberWithFloat:[ToolBox converterHelper_DegreeToRadian:360.0]];
        animation.duration = 1.f;
        animation.beginTime = CACurrentMediaTime() + totalDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [containerDrawLayer addAnimation:animation forKey:@"ContainerRotation"];
        //
        [animations addObject:animation];
        //
        totalDuration += animation.duration;
    }
    
    //Extra Time
    totalDuration += 0.5;
    
    //Detail Hide
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = (id)[NSNumber numberWithFloat:1.000];
        animation.toValue = (id)[NSNumber numberWithFloat:0.f];
        animation.duration = 1.f;
        animation.beginTime = CACurrentMediaTime() + totalDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [detailDrawLayer addAnimation:animation forKey:@"DetailHideOpacity"];
        //
        [animations addObject:animation];
        //
        //totalDuration += animation.duration; (não soma tempo pois ocorre em paralelo)
    }
    
    //Arc Destruction
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        animation.fromValue = (id)[NSNumber numberWithFloat:0.0f];
        animation.toValue = (id)[NSNumber numberWithFloat:1.f];
        animation.duration = 1.f;
        animation.beginTime = CACurrentMediaTime() + totalDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [arcDrawLayer addAnimation:animation forKey:@"ArcDestruction"];
        //
        [animations addObject:animation];
        //
        totalDuration += animation.duration;
    }
    
    //Vertical Destruction
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = (id)[NSNumber numberWithFloat:1.0f];
        animation.toValue = (id)[NSNumber numberWithFloat:0.0f];
        animation.duration = 0.5f;
        animation.beginTime = CACurrentMediaTime() + totalDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.delegate = self;
        [verticalDrawLayer addAnimation:animation forKey:@"VerticalDestruction"];
        //
        [animations addObject:animation];
        //
        totalDuration += animation.duration;
    }
    
    //Animation Group
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = animations;
    animationGroup.duration = totalDuration + 0.5f;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    animationGroup.repeatCount = 0;
    animationGroup.delegate = self;
    //
    [containerDrawLayer addAnimation:animationGroup forKey:@"AnimationGroup"];
    
}

#pragma mark - Utils

-(void)setAnchorPoint:(CGPoint)anchorPoint forCAShapeLayer:(CAShapeLayer *)shapeLayer
{
    CGPoint newPoint = CGPointMake(shapeLayer.bounds.size.width * anchorPoint.x, shapeLayer.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(shapeLayer.bounds.size.width * shapeLayer.anchorPoint.x, shapeLayer.bounds.size.height * shapeLayer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, CGAffineTransformMake(shapeLayer.transform.m11, shapeLayer.transform.m12, shapeLayer.transform.m21, shapeLayer.transform.m22, shapeLayer.transform.m41, shapeLayer.transform.m42));
    oldPoint = CGPointApplyAffineTransform(oldPoint, CGAffineTransformMake(shapeLayer.transform.m11, shapeLayer.transform.m12, shapeLayer.transform.m21, shapeLayer.transform.m22, shapeLayer.transform.m41, shapeLayer.transform.m42));
    
    CGPoint position = shapeLayer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    shapeLayer.position = position;
    shapeLayer.anchorPoint = anchorPoint;
}

@end
