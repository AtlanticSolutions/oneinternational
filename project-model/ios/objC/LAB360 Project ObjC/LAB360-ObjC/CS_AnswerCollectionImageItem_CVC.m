//
//  CS_AnswerCollectionImageItem_CVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 04/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerCollectionImageItem_CVC.h"
#import "ToolBox.h"
#import "VIPhotoView.h"

@interface CS_AnswerCollectionImageItem_CVC()<VIPhotoViewDelegate>

@property(nonatomic, strong) CAShapeLayer *borderLineLayer;

@end

@implementation CS_AnswerCollectionImageItem_CVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

@synthesize imvPicture, indicatorView, borderLineLayer;

- (void)setupLayoutSelected:(BOOL)selected
{
    self.backgroundColor = [UIColor clearColor];
    
    imvPicture.backgroundColor = [UIColor clearColor];
    [imvPicture setContentMode:UIViewContentModeScaleAspectFill];
    [imvPicture setClipsToBounds:YES];
    imvPicture.image = nil;
    //
    imvPicture.layer.cornerRadius = 4.0;
    //
    [imvPicture setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [longPressGesture setNumberOfTouchesRequired:1];
    [longPressGesture setMinimumPressDuration:0.75];
    longPressGesture.allowableMovement = 20.0;
    longPressGesture.delaysTouchesBegan = NO;
    [imvPicture addGestureRecognizer:longPressGesture];
    
    if (selected){
        imvPicture.layer.borderColor = [UIColor orangeColor].CGColor;
        imvPicture.layer.borderWidth = 3.0;
        //
        [self animateBorder];
    }else{
        imvPicture.layer.borderColor = [UIColor clearColor].CGColor;
        imvPicture.layer.borderWidth = 0.0;
    }

    indicatorView.color = [UIColor grayColor];
    [indicatorView setHidesWhenStopped:YES];
    [indicatorView stopAnimating];
    
    [self layoutIfNeeded];
}

- (void)animateBorder
{
    //solidLine
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    animation.fromValue = (id)[UIColor orangeColor].CGColor;
    animation.toValue = (id)[UIColor clearColor].CGColor;
    animation.duration = ANIMA_TIME_NORMAL;
    animation.autoreverses = YES;
    animation.repeatCount = CGFLOAT_MAX;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [imvPicture.layer addAnimation:animation forKey:@"LayerOpacity"];
    
}

- (void)didRecieveDidBecomeActiveNotification:(NSNotification*)notification
{
    if (borderLineLayer){
        [self animateBorder];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        UIImageView *imv = (UIImageView*)recognizer.view;

        if (imv.image != nil){
            VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:imv.image backgroundImage:nil andDelegate:self];
            photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
            photoView.autoresizingMask = (1 << 6) -1;
            photoView.alpha = 0.0;
            //
            [AppD.window addSubview:photoView];
            [AppD.window bringSubviewToFront:photoView];
            //
            [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
                photoView.alpha = 1.0;
            }];
        }
        
    }
}

#pragma mark - VIPhotoViewDelegate

- (void)photoViewDidHide:(VIPhotoView *)photoView
{
    __block id pv = photoView;
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        photoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [pv removeFromSuperview];
        pv = nil;
    }];
}

@end
