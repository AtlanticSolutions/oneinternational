//
//  Video360VC.h
//  LAB360-ObjC
//
//  Created by Rodrigo Baroni on 16/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Video360VC : UIViewController

@property (strong, nonatomic) NSURL *videoURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL*)url;
- (CVPixelBufferRef)retrievePixelBufferToDraw;
- (void)toggleControls;

@end
