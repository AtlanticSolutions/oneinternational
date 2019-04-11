//
//  CustomSegueSurprise.m
//  LAB360-ObjC
//
//  Created by Erico GT on 29/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSegueSurprise.h"

@implementation CustomSegueSurprise

-(void)perform
{
    
    
//    UIView *firstVCView = self.sourceViewController.view;
//    UIView *secondVCView = self.destinationViewController.view;
//
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//
//    secondVCView.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
//
//    secondVCView.alpha = 0.0;
//
//    [firstVCView addSubview:secondVCView];
//
//    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowAnimatedContent animations:^{
//        secondVCView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//        [secondVCView removeFromSuperview];
//        [self.sourceViewController.navigationController pushViewController:self.destinationViewController animated:NO];
//    }];
    

    
}

- (UIView *)sourceViewSnapshot
{
    UIViewController *sourceViewController = self.sourceViewController;
    return [sourceViewController.view snapshotViewAfterScreenUpdates:NO];
}

- (UIView *)destinationViewSnapshot
{
    UIViewController *destinationViewController = self.destinationViewController;
    UIGraphicsBeginImageContextWithOptions(destinationViewController.view.bounds.size, NO, 0);
    [destinationViewController.view drawViewHierarchyInRect:destinationViewController.view.bounds
                                         afterScreenUpdates:YES];
    UIImage *destinationViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [[UIImageView alloc] initWithImage:destinationViewImage];
}

//- (void)showDestinationViewController:(void (^)())completion
//{
//    if (self.type == MBSegueTypeDismiss) {
//        [self.destinationViewController dismissViewControllerAnimated:NO
//                                                           completion:completion];
//    } else {
//        [self.sourceViewController presentViewController:self.destinationViewController
//                                                animated:NO
//                                              completion:completion];
//    }
//}

@end
