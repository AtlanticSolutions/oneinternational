
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
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
//
@property(nonatomic, strong) UIImage *previewImage;
@property(nonatomic, strong) NSMutableArray *maskImages;
@property(nonatomic, strong) NSNumber *selectedMaskId;
@property(nonatomic, assign) BOOL allImagesLoaded;
@property(nonatomic, assign) int selectedMask;

@end

@implementation MaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO: verificar se é necessário mostrar esse logo
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavBarQuiz"]]; //NavBarAdAlive...
    //UIBarButtonItem *logoView = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    //self.navigationItem.rightBarButtonItem = logoView;
    
    self.selectedMask = -1;
    
    // Init frames to 0 and start timer to refresh the frames each second
//    totalFrames = 0;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(computeFPS) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    self.allImagesLoaded = NO;
    self.maskImages = [NSMutableArray array];
    [self configureScrollView];
    
    [self.indicatorView startAnimating];
    
//    if (!isCapturing && faceAnimator) {
//        [self performSelector:@selector(loadCamera) withObject:nil afterDelay:0.5];
//    }
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
                                        bitmapInfo,                 //bitmap info
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
        AVCaptureSessionPreset352x288; //AVCaptureSessionPreset1280x720
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
        UIImage *backgroundImage = [UIImage imageNamed:@"wanted"];
        parameters.hasFixedBackground = false;
        UIImage *fixedBackgroundImage = [UIImage imageNamed:@"wanted"];
        
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
    NSMutableArray *ivList = [NSMutableArray new];
    
    for (int i = 0; i < [self.maskCollection count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i * 90) + 10, 10, 80, 80)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 5.0;
        imageView.userInteractionEnabled = YES;
        imageView.image = nil;
        imageView.tag = -1;
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activity setHidesWhenStopped:YES];
        [activity setCenter:imageView.center];
        [activity startAnimating];
        activity.tag = 999; //tanto faz esse número...
        
        [imageView addSubview:activity];
        [self.scrollView addSubview:imageView];
        [self.scrollView bringSubviewToFront:activity];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskImage:)];
        [imageView addGestureRecognizer:tapGesture];
        
        [ivList addObject:imageView];
    }
    
    [self.scrollView setContentSize:CGSizeMake(90 * [self.maskCollection count], self.scrollView.frame.size.height)];
    
    [self loadImageUsingComponents:ivList forIndex:0];
}

- (void)loadImageUsingComponents:(NSArray<UIImageView*>*)imageViews forIndex:(int)index
{
    NSDictionary *dicMask = [self.maskCollection objectAtIndex:index];
    NSString *imageHref = [dicMask objectForKey:@"image_href"];
    
    UIImageView *originalImageView = [imageViews objectAtIndex:index];
    __weak UIImageView *weakImageView = originalImageView;
    
    [originalImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageHref]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        UIActivityIndicatorView *activity = (UIActivityIndicatorView*)[weakImageView viewWithTag:999];
        [activity stopAnimating];
        [activity removeFromSuperview];
        
        weakImageView.tag = index;
        [weakImageView setImage:image];
        
        if (index == 0){
            self.selectedMask = 0;
            weakImageView.layer.borderWidth = 3.0;
            weakImageView.layer.borderColor = AppD.styleManager.colorPalette.primaryButtonNormal.CGColor;
        }
        
        NSDictionary *dicImage = [NSDictionary dictionaryWithObjectsAndKeys:[dicMask objectForKey:@"id"], @"id", image, @"image", nil];
        [self.maskImages addObject:dicImage];
        
        if ([self.maskCollection count] == (index + 1)){
            //Chegou ao fim da lista:
            self.allImagesLoaded = YES;
            [self setupCameraWithImageKey:[dicMask objectForKey:@"id"] andIndex:0]; //index
            [self loadCamera];
            //
            [self.indicatorView stopAnimating];
        }else{
            //Carrega próxima imagem recursivamente:
            [self loadImageUsingComponents:imageViews forIndex:(index + 1)];
        }
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        UIActivityIndicatorView *activity = (UIActivityIndicatorView*)[weakImageView viewWithTag:999];
        [activity stopAnimating];
        [activity removeFromSuperview];
        
        UIImage *placeholderImage = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
        
        weakImageView.tag = index;
        [weakImageView setImage:placeholderImage];
        
        if (index == 0){
            self.selectedMask = 0;
            weakImageView.layer.borderWidth = 3.0;
            weakImageView.layer.borderColor = AppD.styleManager.colorPalette.primaryButtonNormal.CGColor;
        }
        
        NSDictionary *dicImage = [NSDictionary dictionaryWithObjectsAndKeys:[dicMask objectForKey:@"id"], @"id", placeholderImage, @"image", nil];
        [self.maskImages addObject:dicImage];
        
        if ([self.maskCollection count] == (index + 1)){
            //Chegou ao fim da lista:
            self.allImagesLoaded = YES;
            [self setupCameraWithImageKey:[dicMask objectForKey:@"id"] andIndex:0]; //index
            [self loadCamera];
            //
            [self.indicatorView stopAnimating];
        }else{
            //Carrega próxima imagem recursivamente:
            [self loadImageUsingComponents:imageViews forIndex:(index + 1)];
        }
        
    }];
}

- (void)tapMaskImage:(UITapGestureRecognizer *)tapGesture
{
    if(self.allImagesLoaded && tapGesture.view.tag != -1)
    {
        UIImageView *imageView = (UIImageView *)tapGesture.view;
        
        if (imageView.tag != self.selectedMask){
            
            for (UIImageView *imgView in self.scrollView.subviews){
                imgView.layer.borderWidth = 0.0;
            }
            
            imageView.layer.borderWidth = 3.0;
            imageView.layer.borderColor = AppD.styleManager.colorPalette.primaryButtonNormal.CGColor;
            
            int i = (int)imageView.tag;
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



#pragma mark - Private Methods

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor blackColor];
    
    //Navigation Controller
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = @"Mask";
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
}

@end
