//
//  NavigationControllerPushPopAnimators.m
//  LAB360-ObjC
//
//  Created by Erico GT on 31/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "NavigationControllerPushPopAnimators.h"

@implementation FadePushAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if ([transitionContext isAnimated]){
        UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [[transitionContext containerView] addSubview:toViewController.view];
        
        toViewController.view.alpha = 0.0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end

#pragma mark -

@implementation FadePopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if ([transitionContext isAnimated]){
        UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
