
//
//  MaskViewController.m
//  AdAlive
//
//  Created by Lab360 on 4/8/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import "MaskViewController.h"
#import "PreviewMaskViewController.h"

@interface MaskViewController()

@property(nonatomic, weak) IBOutlet UIButton *btnTakePicture;
@property(nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) UIImage *previewImage;
@property(nonatomic, strong) NSMutableArray *maskImages;
@property(nonatomic, strong) NSNumber *selectedMaskId;
@property BOOL allImagesLoaded;

@end

@implementation MaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView;
    
#ifdef WILVALE
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-navbar3"]];
#elif NATURA
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-navbar-natura"]];
#elif ETNA
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
#elif IPIRANGA
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
#elif HINODE
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
#endif
    
    UIBarButtonItem *logoView = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.rightBarButtonItem = logoView;
    
    self.allImagesLoaded = NO;
    self.maskImages = [NSMutableArray array];
    [self configureScrollView];
    
    // Init frames to 0 and start timer to refresh the frames each second
//    totalFrames = 0;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(computeFPS) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isCapturing && faceAnimator) {
        [self performSelector:@selector(loadCamera) withObject:nil afterDelay:0.5];
    }
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    
    CGColorSpaceRef colorSpace;
    CGBitmapInfo bitmapInfo;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
        bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        bitmapInfo = kCGBitmapByteOrder32Little | (
                                                   cvMat.elemSize() == 3? kCGImageAlphaNone : kCGImageAlphaNoneSkipFirst
                                                   );
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(
                                        cvMat.cols,                 //width
                                        cvMat.rows,                 //height
                                        8,                          //bits per component
                                        8 * cvMat.elemSize(),       //bits per pixel
                                        cvMat.step[0],              //bytesPerRow
                                        colorSpace,                 //colorspace
                                        bitmapInfo,                 // bitmap info
                                        provider,                   //CGDataProviderRef
                                        NULL,                       //decode
                                        false,                      //should interpolate
                                        kCGRenderingIntentDefault   //intent
                                        );
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

// Macros for time measurements
#if 0
#define TS(name) int64 t_##name = cv::getTickCount()
#define TE(name) printf("TIMER_" #name ": %.2fms\n", \
1000.*((cv::getTickCount() - t_##name) / cv::getTickFrequency()))
#else
#define TS(name)
#define TE(name)
#endif

- (void)processImage:(cv::Mat&)image
{
    TS(DetectAndAnimateFaces);
    faceAnimator->detectAndAnimateFaces(image);
    TE(DetectAndAnimateFaces);
    self.previewImage = [self UIImageFromCVMat:image];
//    totalFrames++;
}

//Function called every second to update the frames and update the FPS label
//- (void)        computeFPS {
//    NSLog(@"%d fps", totalFrames);
//    totalFrames = 0;
//}

#pragma mark - Interface Methods

-(void)setupCameraWithImageKey:(NSString *)imageKey andIndex:(int)index
{
    if (!self.videoCamera)
    {
        self.videoCamera = [[MyCamera alloc]
                            initWithParentView:_imageView];
        self.videoCamera.delegate = self;
        self.videoCamera.defaultAVCaptureDevicePosition =
        AVCaptureDevicePositionFront;
        self.videoCamera.defaultAVCaptureSessionPreset =
        AVCaptureSessionPreset352x288;
        self.videoCamera.defaultAVCaptureVideoOrientation =
        AVCaptureVideoOrientationPortrait;
        self.videoCamera.defaultFPS = 30;
        [self.videoCamera adjustLayoutToInterfaceOrientation:UIInterfaceOrientationPortrait];
        [self.videoCamera setRotateVideo:NO];
    }
    
    isCapturing = NO;
    
    NSDictionary *dicMask = [self.maskCollection objectAtIndex:0];
    self.selectedMaskId = [dicMask objectForKey:@"id"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", self.selectedMaskId];
    NSArray *filtered = [self.maskImages filteredArrayUsingPredicate:predicate];
    UIImage *resImage;
    
    if ([filtered count] > 0)
    {
        resImage = [[filtered objectAtIndex:0] objectForKey:@"image"];
        
        float scale = [[dicMask objectForKey:@"scale"] floatValue];
        float shift = [[dicMask objectForKey:@"shift"] floatValue];
        
        // Load images and attributes
        parameters.scale = scale;
        parameters.shift = shift;
        
        parameters.hasBackground = false;
        UIImage *backgroundImage = [UIImage imageNamed:@"Wanted.png"];
        parameters.hasFixedBackground = false;
        UIImage *fixedBackgroundImage = [UIImage imageNamed:@"Wanted.png"];
        
        UIImageToMat(resImage, parameters.maskImage, true);
        cvtColor(parameters.maskImage, parameters.maskImage, CV_BGRA2RGBA);
        
        UIImageToMat(backgroundImage, parameters.backgroundImage, true);
        cvtColor(parameters.backgroundImage, parameters.backgroundImage, CV_BGRA2RGBA);
        
        UIImageToMat(fixedBackgroundImage, parameters.fixedBackgroundImage, true);
        cvtColor(parameters.fixedBackgroundImage, parameters.fixedBackgroundImage, CV_BGRA2RGBA);
        
        
        // Load Cascade Classisiers
        NSString* filename = [[NSBundle mainBundle]
                              pathForResource:@"haarcascade_frontalface_default"
                              ofType:@"xml"];
        parameters.faceCascade.load([filename UTF8String]);
        
        filename = [[NSBundle mainBundle]
                    pathForResource:@"haarcascade_mcs_eyepair_big"
                    ofType:@"xml"];
        parameters.eyesCascade.load([filename UTF8String]);
    }
}

-(void)loadCamera
{
    if(!faceAnimator)
        faceAnimator = new FaceAnimator(parameters);
    
    [self.videoCamera start];
    isCapturing = YES;
    [self.view bringSubviewToFront:self.btnTakePicture];
}

-(void)configureScrollView
{
    for (int i = 0; i < [self.maskCollection count]; i++)
    {
        NSDictionary *dicMask = [self.maskCollection objectAtIndex:i];
        NSString *imageHref = [dicMask objectForKey:@"image_href"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i * 90) + 10, 10, 80, 80)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 15.0;
        imageView.userInteractionEnabled = YES;
        imageView.hidden = YES;
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activity setCenter:imageView.center];
        [activity startAnimating];
        [self.scrollView addSubview:activity];
        [self.scrollView addSubview:imageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskImage:)];
        [imageView addGestureRecognizer:tapGesture];
        
        [self downloadImageWithURL:[NSURL URLWithString:imageHref] completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 NSDictionary *dicImage = [NSDictionary dictionaryWithObjectsAndKeys:[dicMask objectForKey:@"id"], @"id", image, @"image", nil];
                 [self.maskImages addObject:dicImage];
                 imageView.tag = i;
                 [imageView setImage:image];
                 imageView.hidden = NO;
                 
                 if(i == 0)
                 {
                     imageView.layer.borderWidth = 3.0;
                     imageView.layer.borderColor = [[UIColor orangeColor] CGColor];
                 }
                 
                 if ([self.maskImages count] == [self.maskCollection count])
                 {
                     self.allImagesLoaded = YES;
                     [self setupCameraWithImageKey:[dicMask objectForKey:@"id"] andIndex:i];
                     [self loadCamera];
                 }
             }
        }];
    }
    [self.scrollView setContentSize:CGSizeMake(90 * [self.maskCollection count], self.scrollView.frame.size.height)];
}

- (void)tapMaskImage:(UITapGestureRecognizer *)tapGesture
{
    if(self.allImagesLoaded)
    {
        UIImageView *imageView = (UIImageView *)tapGesture.view;
        
        if(imageView.layer.borderWidth != 3.0)
        {
            imageView.layer.borderWidth = 3.0;
            imageView.layer.borderColor = [[UIColor orangeColor] CGColor];
            
            for (UIImageView *imgView in self.scrollView.subviews)
            {
                if ([imgView isKindOfClass:[UIImageView class]] && imgView != imageView)
                {
                    imgView.layer.borderWidth = 0.0;
                }
            }
            
            int i = imageView.tag;
            NSDictionary *dicMask = [self.maskCollection objectAtIndex:i];
            self.selectedMaskId = [dicMask objectForKey:@"id"];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", self.selectedMaskId];
            NSArray *filtered = [self.maskImages filteredArrayUsingPredicate:predicate];
            UIImage *resImage;
            
            if ([filtered count] > 0)
            {
                resImage = [[filtered objectAtIndex:0] objectForKey:@"image"];
                
                float scale = [[dicMask objectForKey:@"scale"] floatValue];
                float shift = [[dicMask objectForKey:@"shift"] floatValue];
                parameters.scale = scale;
                parameters.shift = shift;
                
                UIImageToMat(resImage, parameters.maskImage, true);
                cvtColor(parameters.maskImage, parameters.maskImage, CV_BGRA2RGBA);
                
                faceAnimator->changeMask(parameters);
            }
        }
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)didTapPhotoButton:(id)sender {
    
    [self.videoCamera stop];
    isCapturing = NO;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PreviewMaskViewController *viewController = (PreviewMaskViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PreviewMaskViewController"];
    viewController.previewImage = self.previewImage;
    viewController.maskId = self.selectedMaskId;
    [self presentViewController:viewController animated:YES completion:nil];
}

//Download Images

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isCapturing)
    {
        [_videoCamera stop];
    }
}

- (void)dealloc
{
    self.videoCamera.delegate = nil;
}

@end
