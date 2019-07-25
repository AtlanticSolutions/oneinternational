//
//  MyCamera.m
//  AdAlive
//
//  Created by Jader Bruno Pereira Lima on 5/2/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import "MyCamera.h"

@implementation MyCamera

- (void)updateOrientation;
{
    // nop
}
- (void)layoutPreviewLayer;
{
    if (self.parentView != nil) {
        CALayer* layer = self.customPreviewLayer;
        CGRect bounds = self.customPreviewLayer.bounds;
        layer.position = CGPointMake(self.parentView.frame.size.width/2., self.parentView.frame.size.height/2.);
        layer.bounds = bounds;
    }
}
@end
