//
//  BeaconShowroomLiveCamVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 21/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "BeaconShowroomLiveCamVC.h"
#import "UIImageView+AFNetworking.h"
#import "AsyncImageDownloader.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface BeaconShowroomLiveCamVC()

//Banner
@property(nonatomic, strong) UIImageView *imvBanner;
//Camera
@property(nonatomic, strong) UIBarButtonItem *btnClose;
@property(nonatomic, strong) UIBarButtonItem *btnShare;
@property(nonatomic, weak) IBOutlet UIView *viewCamera;
//Camera Control
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *capturePreviewLayer;
@property (nonatomic, strong) NSOperationQueue *captureQueue;
@property (nonatomic, assign) UIImageOrientation imageOrientation;
@property (assign, nonatomic) AVCaptureFlashMode flashMode;
@property (assign, nonatomic) AVCaptureTorchMode torchMode;
//Screen Control
@property (nonatomic, strong) UIImage *userPhoto;
@property (nonatomic, assign) BOOL isLoaded;
//Size and Position Control
@property (nonatomic, assign) CGFloat bottomScreenInsets;
@property (nonatomic, assign) CGFloat topScreenInsets;
@property (nonatomic, assign) CGFloat leftScreenInsets;
@property (nonatomic, assign) CGFloat rightScreenInsets;
//
@property(nonatomic, strong) UIImage* verticalBannerImage;
@property(nonatomic, strong) UIImage* horizontalBannerImage;

@end

#pragma mark - • IMPLEMENTATION
@implementation BeaconShowroomLiveCamVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
//Layout:
@synthesize btnClose, btnShare, viewCamera, imvBanner;
//Data:
@synthesize beaconTagID, productSKU, verticalBannerURL, verticalBannerImage, horizontalBannerURL, horizontalBannerImage, session, capturePreviewLayer, captureQueue, imageOrientation, flashMode, torchMode, userPhoto, isLoaded;
@synthesize inheritedOrientation, bottomScreenInsets, topScreenInsets, leftScreenInsets, rightScreenInsets;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userPhoto = nil;
    isLoaded = NO;
    
    //Initialise the capture queue
    captureQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self.view layoutIfNeeded];
        [self setupLayout:@""];
        
        [self enableCapture];
        
        isLoaded = YES;
    }else{
        [self restartPhotoView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        bottomScreenInsets = AppD.window.safeAreaInsets.bottom;
        topScreenInsets = AppD.window.safeAreaInsets.top;
        leftScreenInsets = AppD.window.safeAreaInsets.left;
        rightScreenInsets = AppD.window.safeAreaInsets.right;
    }else{
        bottomScreenInsets = 0.0;
        topScreenInsets = 0.0;
        leftScreenInsets = 0.0;
        rightScreenInsets = 0.0;
    }
    
    [self updateBannerViewLayout];
    
    //Log
//    NSMutableDictionary *logDic = [NSMutableDictionary new];
//    [logDic setValue:beaconTagID forKey:@"beacon_tag_id"];
//    [logDic setValue:productSKU forKey:@"product_sku"];
//    [logDic setValue:verticalBannerURL forKey:@"vertical_hef"];
//    [logDic setValue:horizontalBannerURL forKey:@"horizontal_href"];
//    [AppD logAdAliveEventWithName:@"ShowBeaconBanner" data:logDic];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [session stopRunning];
}

#pragma mark -

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (void)actionDeviceOrientationDidChange:(NSNotification*)notification
{
    [self updateBannerViewLayout];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString*)screenName
{
    [super setupLayout:screenName];
    
    self.view.backgroundColor = [UIColor clearColor];
    viewCamera.backgroundColor = [UIColor clearColor];
    
    imvBanner = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    imvBanner.backgroundColor = [UIColor clearColor];
    imvBanner.image = nil;
    [imvBanner setContentMode:UIViewContentModeScaleAspectFill];
    [imvBanner setClipsToBounds:YES];
    //
    [self.view addSubview:imvBanner];
}

- (void)restartPhotoView
{
    [session startRunning];
}

- (void)enableCapture
{
    if (self.session) return;
    
    NSBlockOperation *operation = [self captureOperation];
    operation.completionBlock = ^{
        [self operationCompleted];
    };
    operation.queuePriority = NSOperationQueuePriorityVeryHigh;
    [self.captureQueue addOperation:operation];
}

- (NSBlockOperation *)captureOperation
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
        
        AVCaptureDevice *device = nil;
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *d in devices) {
            if (d.position == AVCaptureDevicePositionFront) {
                device = d;
                break;
            }
        }
        
        if (!device) return;
        
        NSError *error = nil;
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        
        if (!input) return;
        
        [self.session addInput:input];
        
        // Turn on point autofocus for middle of view
        [device lockForConfiguration:&error];
        if (!error) {
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                device.focusPointOfInterest = CGPointMake(0.5,0.5);
                device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            }
            
            //Flash ou Torch
            if (device.hasFlash){
                if ([device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                    device.flashMode = AVCaptureFlashModeAuto;
                } else {
                    device.flashMode = AVCaptureFlashModeOff;
                }
                self.flashMode = device.flashMode;
                self.torchMode = AVCaptureTorchModeOff;
            }else if(device.hasTorch){
                if ([device isTorchModeSupported:AVCaptureTorchModeAuto]){
                    device.torchMode = AVCaptureTorchModeAuto;
                }else{
                    device.torchMode = AVCaptureTorchModeOff;
                }
                self.torchMode = device.torchMode;
                self.flashMode = AVCaptureFlashModeOff;
            }
            
        }
        [device unlockForConfiguration];
        
        self.capturePreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.capturePreviewLayer.frame = CGRectMake(0.0, 0.0, viewCamera.frame.size.width, viewCamera.frame.size.height);
        });
        self.capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        // Still Image Output
        AVCaptureStillImageOutput *stillOutput = [[AVCaptureStillImageOutput alloc] init];
        stillOutput.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
        [self.session addOutput:stillOutput];
    }];
    return operation;
}

- (void)operationCompleted
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.session) return;
        
        [viewCamera.layer addSublayer:self.capturePreviewLayer];
        [self.session startRunning];
        
    });
}

- (AVCaptureDevice *)currentDevice
{
    return [(AVCaptureDeviceInput *)self.session.inputs.firstObject device];
}

- (AVCaptureDevice *)frontCamera
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

- (UIImageOrientation)currentImageOrientation
{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    UIImageOrientation imageOrientation;
    
    AVCaptureDeviceInput *input = self.session.inputs.firstObject;
    if (input.device.position == AVCaptureDevicePositionBack) {
        switch (deviceOrientation) {
            case UIDeviceOrientationLandscapeLeft:
                imageOrientation = UIImageOrientationUp;
                break;
                
            case UIDeviceOrientationLandscapeRight:
                imageOrientation = UIImageOrientationDown;
                break;
                
            case UIDeviceOrientationPortraitUpsideDown:
                imageOrientation = UIImageOrientationLeft;
                break;
                
            default:
                imageOrientation = UIImageOrientationRight;
                break;
        }
    } else {
        switch (deviceOrientation) {
            case UIDeviceOrientationLandscapeLeft:
                imageOrientation = UIImageOrientationDownMirrored;
                break;
                
            case UIDeviceOrientationLandscapeRight:
                imageOrientation = UIImageOrientationUpMirrored;
                break;
                
            case UIDeviceOrientationPortraitUpsideDown:
                imageOrientation = UIImageOrientationRightMirrored;
                break;
                
            default:
                imageOrientation = UIImageOrientationLeftMirrored;
                break;
        }
    }
    
    return imageOrientation;
}

- (void)takePicture
{
    if (!btnShare.enabled) return;
    
    AVCaptureStillImageOutput *output = self.session.outputs.lastObject;
    AVCaptureConnection *videoConnection = output.connections.lastObject;
    if (!videoConnection) return;
    
    btnShare.enabled = NO;
    [AppD.soundManager playSound:SoundMediaNameCameraClick withVolume:1.0];
    [output captureStillImageAsynchronouslyFromConnection:videoConnection
                                        completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                            self.btnShare.enabled = YES;
                                            
                                            if (!imageDataSampleBuffer || error) return;
                                            
                                            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                            
                                            UIImage *image = [UIImage imageWithCGImage:[[[UIImage alloc] initWithData:imageData] CGImage]
                                                                                 scale:1.0f
                                                                           orientation:[self currentImageOrientation]];
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.session stopRunning];
                                                [self handleImage:image];
                                            });
                                            
                                        }];
    
}

- (void)handleImage:(UIImage *)image
{
    userPhoto = image;
    
    //TODO: share photo here:
}

- (void)updateBannerViewLayout
{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    BOOL useVertical = NO;
    BOOL useHorizontal = NO;
    BOOL invertedPosition = NO;
    BOOL hideBanner = NO;
    
    if (deviceOrientation == UIDeviceOrientationFaceUp) {
        deviceOrientation = inheritedOrientation;
    }else{
        inheritedOrientation = deviceOrientation;
    }
    
    switch (deviceOrientation) {
        case UIDeviceOrientationUnknown: {
            hideBanner = YES;
            break;
        }
        case UIDeviceOrientationPortrait:{
            useHorizontal = YES;
        } break;
        case UIDeviceOrientationPortraitUpsideDown: {
            useHorizontal = YES;
            invertedPosition = YES;
            break;
        }
        case UIDeviceOrientationLandscapeLeft: {
            useVertical = YES;
            break;
        }
        case UIDeviceOrientationLandscapeRight: {
            useVertical = YES;
            invertedPosition = YES;
            break;
        }
        case UIDeviceOrientationFaceUp: {
            //Na prática não vai cair aqui...
            useHorizontal = YES;
            break;
        }
        case UIDeviceOrientationFaceDown: {
            hideBanner = YES;
            break;
        }
    }
    
    if (hideBanner){
        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
            imvBanner.alpha = 0.0;
        }];
    }else{
        
        imvBanner.transform = CGAffineTransformIdentity;
        
        if (useHorizontal){ //HORIZONTAL BANNER ************************************************************
            
            if (horizontalBannerImage){
                
                if (imvBanner.alpha == 0.0){
                    imvBanner.image = horizontalBannerImage;
                    CGSize imvSize = [self createViewSizeForImage:horizontalBannerImage];
                    //
                    if (invertedPosition){
                        imvBanner.frame = CGRectMake(0.0 + leftScreenInsets, 0.0 + topScreenInsets, imvSize.width, imvSize.height);
                        imvBanner.transform = CGAffineTransformRotate(imvBanner.transform, M_PI);
                    }else{
                        imvBanner.frame = CGRectMake(0.0 + leftScreenInsets, (viewCamera.frame.size.height - imvSize.height - bottomScreenInsets), imvSize.width, imvSize.height);
                    }
                    //
                    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                        imvBanner.alpha = 1.0;
                    }];
                }else{
                    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                        imvBanner.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        imvBanner.image = horizontalBannerImage;
                        CGSize imvSize = [self createViewSizeForImage:horizontalBannerImage];
                        //
                        if (invertedPosition){
                            imvBanner.frame = CGRectMake(0.0 + leftScreenInsets, 0.0 + topScreenInsets, imvSize.width, imvSize.height);
                            imvBanner.transform = CGAffineTransformRotate(imvBanner.transform, M_PI);
                        }else{
                            imvBanner.frame = CGRectMake(0.0 + leftScreenInsets, (viewCamera.frame.size.height - imvSize.height - bottomScreenInsets), imvSize.width, imvSize.height);
                        }
                        //
                        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                            imvBanner.alpha = 1.0;
                        }];
                    }];
                }

            }else{
                
                if (horizontalBannerURL == nil || [horizontalBannerURL isEqualToString:@""]){
                    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                        imvBanner.alpha = 0.0;
                    }];
                }else{
                    __weak typeof(self) weakSelf = self;
                    
                    //Versão que suporta GIF:
                    [[[AsyncImageDownloader alloc] initWithFileURL:horizontalBannerURL successBlock:^(NSData *data) {
                        if (data != nil){
                            if ([horizontalBannerURL hasSuffix:@"GIF"] || [horizontalBannerURL hasSuffix:@"gif"]) {
                                horizontalBannerImage = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:[NSData dataWithData:data]];
                            }else{
                                horizontalBannerImage = [self normalizeBannerImage:[UIImage imageWithData:data]];
                            }
                            [weakSelf updateBannerViewLayout];
                        }else{
                            horizontalBannerURL = nil;
                            [weakSelf updateBannerViewLayout];
                        }
                    } failBlock:^(NSError *error) {
                        horizontalBannerURL = nil;
                        [weakSelf updateBannerViewLayout];
                    }] startDownload];
                    
                    //Versão para imagem normal:
//                    [imvBanner setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:horizontalBannerURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//                        horizontalBannerImage = [self normalizeBannerImage:image];
//                        [weakSelf updateBannerViewLayout];
//                    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//                        horizontalBannerURL = nil;
//                        [weakSelf updateBannerViewLayout];
//                    }];
                }
            }
            
        }else if (useVertical){ //VERTICAL BANNER ************************************************************
            
            if (verticalBannerImage){
                
                if (imvBanner.alpha == 0.0){
                    imvBanner.image = verticalBannerImage;
                    CGSize imvSize = [self createViewSizeForImage:verticalBannerImage];
                    //
                    if (invertedPosition){
                        imvBanner.frame = CGRectMake(0.0 + leftScreenInsets, 0.0 + topScreenInsets, imvSize.width, imvSize.height);
                        imvBanner.transform = CGAffineTransformRotate(imvBanner.transform, M_PI);
                    }else{
                        imvBanner.frame = CGRectMake(0.0 + leftScreenInsets, (viewCamera.frame.size.height - imvSize.height - bottomScreenInsets), imvSize.width, imvSize.height);
                    }
                    //
                    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                        imvBanner.alpha = 1.0;
                    }];
                }else{
                    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                        imvBanner.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        imvBanner.image = verticalBannerImage;
                        CGSize imvSize = [self createViewSizeForImage:verticalBannerImage];
                        //
                        if (invertedPosition){
                            imvBanner.frame = CGRectMake(0.0 + leftScreenInsets, 0.0 + topScreenInsets, imvSize.width, imvSize.height);
                            imvBanner.transform = CGAffineTransformRotate(imvBanner.transform, M_PI);
                        }else{
                            imvBanner.frame = CGRectMake(0.0 + leftScreenInsets, (viewCamera.frame.size.height - imvSize.height - bottomScreenInsets), imvSize.width, imvSize.height);
                        }
                        //
                        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                            imvBanner.alpha = 1.0;
                        }];
                    }];
                }
                
            }else{
                
                if (verticalBannerURL == nil || [verticalBannerURL isEqualToString:@""]){
                    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                        imvBanner.alpha = 0.0;
                    }];
                }else{
                    __weak typeof(self) weakSelf = self;
                    
                    //Versão que suporta GIF:
                    [[[AsyncImageDownloader alloc] initWithFileURL:verticalBannerURL successBlock:^(NSData *data) {
                        if (data != nil){
                            if ([verticalBannerURL hasSuffix:@"GIF"] || [verticalBannerURL hasSuffix:@"gif"]) {
                                verticalBannerImage = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:[NSData dataWithData:data]];
                            }else{
                                verticalBannerImage = [self normalizeBannerImage:[UIImage imageWithData:data]];
                            }
                            [weakSelf updateBannerViewLayout];
                        }else{
                            verticalBannerImage = nil;
                            [weakSelf updateBannerViewLayout];
                        }
                    } failBlock:^(NSError *error) {
                        verticalBannerImage = nil;
                        [weakSelf updateBannerViewLayout];
                    }] startDownload];
                    
                    //Versão para imagem normal:
//                    [imvBanner setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:verticalBannerURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//                        verticalBannerImage = [self normalizeBannerImage:image];
//                        [weakSelf updateBannerViewLayout];
//                    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//                        verticalBannerURL = nil;
//                        [weakSelf updateBannerViewLayout];
//                    }];
                }
            }
            
        }else{
            [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                imvBanner.alpha = 0.0;
            }];
        }
    }
}

- (CGSize)createViewSizeForImage:(UIImage*)referenceImage
{
    CGFloat ratio = referenceImage.size.width / referenceImage.size.height;
    CGFloat height = viewCamera.frame.size.width / ratio;
    return CGSizeMake(viewCamera.frame.size.width, height);
}

- (UIImage*)normalizeBannerImage:(UIImage*)imageIn
{
    if (imageIn){
        if (imageIn.size.height > imageIn.size.width){
            //Se a altura da imagem for maior que a largura, a imagem é "tombada" para a direita.
            if (imageIn.CGImage != nil){
                
                // Create the bitmap context
                CGImageRef imgRef = imageIn.CGImage;
                CGSize originalSize = CGSizeMake( CGImageGetWidth(imgRef), CGImageGetHeight(imgRef) );
                CGSize rotatedSize = CGSizeMake( CGImageGetHeight(imgRef), CGImageGetWidth(imgRef) );
                UIGraphicsBeginImageContext(rotatedSize);
                CGContextRef bitmap = UIGraphicsGetCurrentContext();
                
                // Move the origin to the middle of the image so we will rotate and scale around the center.
                CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
                
                // Rotate the image context
                CGContextRotateCTM(bitmap, (M_PI / 2.0));
                
                // Now, draw the rotated/scaled image into the context
                CGContextScaleCTM(bitmap, 1.0, -1.0);
                CGContextDrawImage(bitmap, CGRectMake(-originalSize.width / 2, -originalSize.height / 2, originalSize.width, originalSize.height), imageIn.CGImage);
                
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                return newImage;
            }
        }
    }
    
    return imageIn;
}

@end
