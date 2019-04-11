//
//  VirtualShowcaseTakePhotoVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VirtualShowcaseTakePhotoVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VirtualShowcaseTakePhotoVC()

//Basic
@property (nonatomic, weak) IBOutlet UIView *viewContainerCamera;
@property (nonatomic, weak) IBOutlet UIView *viewPhoto;
@property (nonatomic, weak) IBOutlet UIImageView *imvMaskModel;
@property (nonatomic, weak) IBOutlet UIButton *btnClick;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

//Camera
@property (nonatomic, strong) UIButton *btnCameraChange;
@property (nonatomic, strong) UIButton *btnFlashMode;
@property(nonatomic, weak) IBOutlet UIView *zoomLevelView;
@property(nonatomic, weak) IBOutlet UIImageView *zoomLevelImageView;
@property(nonatomic, weak) IBOutlet UILabel *zoomLevelLabel;
//
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *capturePreviewLayer;
@property (nonatomic, strong) NSOperationQueue *captureQueue;
@property (nonatomic, assign) UIImageOrientation imageOrientation;
@property (assign, nonatomic) AVCaptureFlashMode flashMode;
@property (assign, nonatomic) AVCaptureTorchMode torchMode;
@property (nonatomic, assign) CGFloat zoomScale;
//
@property (nonatomic, strong) UIImage *finalPhoto;
@property (nonatomic, assign) BOOL isLoaded;

@end

#pragma mark - • IMPLEMENTATION
@implementation VirtualShowcaseTakePhotoVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
//Layout:
@synthesize viewContainerCamera, viewPhoto, imvMaskModel, btnClick, btnCameraChange, btnFlashMode, activityIndicator, zoomLevelView, zoomLevelImageView, zoomLevelLabel;
//Data:
@synthesize category, session, capturePreviewLayer, captureQueue, imageOrientation, flashMode, torchMode, finalPhoto, isLoaded, zoomScale;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    finalPhoto = nil;
    isLoaded = NO;
    zoomScale = 1.0;
    
    //Initialise the capture queue
    self.captureQueue = [NSOperationQueue new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self.view layoutIfNeeded];
        [self setupLayout];
        
        //Tip:
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:@"%@%i", APP_OPTION_KEY_SHOWCASE_TIP_MASKUSER, AppD.loggedUser.userID];
        if (![userDefaults boolForKey:key]){
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert addButton:@"Entendi" withType:SCLAlertButtonType_Normal actionBlock:nil];
            [alert addButton:@"Não mostrar novamente" withType:SCLAlertButtonType_Neutral actionBlock:^{
                [userDefaults setBool:YES forKey:key];
                [userDefaults synchronize];
            }];
            [alert showInfo:@"Dica Foto" subTitle:@"Para iniciar, enquadre sua foto no modelo apresentado. Quanto mais preciso for o enquadramento, maior será a compatibilidade com o produto escolhido.\n\nVocê poderá alternar entre vários produtos compatíveis com o mesmo modelo." closeButtonTitle:nil duration:0.0];
        }
        
        [self enableCapture];
        
        isLoaded = YES;
    }else{
        [self restartPhotoView];
    }
    
    [self setMaskImage:category.maskModel tintColor:category.maskTintColor alpha:category.maskAlpha];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToMaskEdition"]){
        VirtualShowcaseMaskEditionVC *vcMaskEdition = segue.destinationViewController;
        vcMaskEdition.category = [category copyObject];
        vcMaskEdition.userPhoto = finalPhoto;
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionClickPhoto:(id)sender
{
    [self takePicture];
}

- (IBAction)actionFlash:(id)sender
{
    //AUTO >> NO >> OFF
    
    if ([self currentDevice].hasFlash){
        if (self.flashMode == AVCaptureFlashModeAuto){
            self.flashMode = AVCaptureFlashModeOn;
        }else if (self.flashMode == AVCaptureFlashModeOn){
            self.flashMode = AVCaptureFlashModeOff;
        }else{
            self.flashMode = AVCaptureFlashModeAuto;
        }
    }else if([self currentDevice].hasTorch){
        if (self.torchMode == AVCaptureTorchModeAuto){
            self.torchMode = AVCaptureTorchModeOn;
        }else if (self.torchMode == AVCaptureTorchModeOn){
            self.torchMode = AVCaptureTorchModeOff;
        }else{
            self.torchMode = AVCaptureTorchModeAuto;
        }
    }
    
    [self updateFlashlightState];
}

- (IBAction)actionCamera:(id)sender
{
    if (!self.session) return;
    [self.session stopRunning];
    
    // Input Switch
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        AVCaptureDeviceInput *input = self.session.inputs.firstObject;
        
        AVCaptureDevice *newCamera = nil;
        
        if (input.device.position == AVCaptureDevicePositionBack) {
            newCamera = [self frontCamera];
        } else {
            newCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }
        
        // Should the flash button still be displayed?
        dispatch_async(dispatch_get_main_queue(), ^{
            self.btnFlashMode.hidden = !(newCamera.isFlashAvailable || newCamera.isTorchAvailable);
        });
        
        // Remove previous camera, and add new
        [self.session removeInput:input];
        NSError *error = nil;
        
        input = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:&error];
        if (!input) return;
        [self.session addInput:input];
        
        AVCaptureDevice *device = [self currentDevice];
        if ([device lockForConfiguration:nil]){
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                device.focusPointOfInterest = CGPointMake(0.5,0.5);
                device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            }
            [device unlockForConfiguration];
        };
        
    }];
    operation.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.session) return;
            [self.session startRunning];
        });
    };
    operation.queuePriority = NSOperationQueuePriorityVeryHigh;
    
    // disable button to avoid crash if the user spams the button
    self.btnCameraChange.enabled = NO;
    
    [self.captureQueue addOperation:operation];
    
    // Flip Animation
    [UIView transitionWithView:viewPhoto
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowAnimatedContent
                    animations:nil
                    completion:^(BOOL finished) {
                        self.btnCameraChange.enabled = YES;
                        //[self.captureQueue addOperation:operation];
                    }];
}

- (void)actionPointFocus:(UITapGestureRecognizer*)tapRecognizer
{
    if (![self currentDevice]) return;

    AVCaptureDevice *device = [self currentDevice];
    NSError *error = nil;
    BOOL success = [device lockForConfiguration:&error];

    if (success) {
        
        CGPoint touchPoint = [tapRecognizer locationInView: tapRecognizer.view];
        CGPoint interestPoint = [capturePreviewLayer captureDevicePointOfInterestForPoint:touchPoint];
        if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            device.focusPointOfInterest = CGPointMake(interestPoint.x, interestPoint.y);
            device.focusMode = AVCaptureFocusModeAutoFocus;
            //Focus marker:
            UIView *view = [self.viewPhoto viewWithTag:987];
            if (!view){
                view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
                view.tag = 987;
            }else{
                [view setHidden:YES];
                [view.layer removeAllAnimations];
            }
            view.center = touchPoint;
            [view setHidden:NO];
            view.backgroundColor = nil;
            view.layer.borderColor = [UIColor greenColor].CGColor;
            view.layer.borderWidth = 1.5;
            [self.viewPhoto addSubview:view];
            [UIView animateWithDuration:0.2 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                view.alpha = 0.0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }
        if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
            device.exposureMode = AVCaptureExposureModeAutoExpose;
        }
        //
        [device unlockForConfiguration];
    }else{
        NSLog(@"actionFocus >> lockForConfiguration >> error: %@", [error localizedDescription]);
    }
}

- (void)actionZoom:(UIPinchGestureRecognizer*)zoomRecognizer
{
    if (![self currentDevice]) return;
    
    AVCaptureDevice *device = [self currentDevice];
    NSError *error = nil;
    BOOL success = [device lockForConfiguration:&error];
    
    float factor = 1.0;
    
    if (success) {
        if (zoomRecognizer.state == UIGestureRecognizerStateBegan){
            zoomScale = device.videoZoomFactor;
            factor = zoomScale;
        }else if (zoomRecognizer.state == UIGestureRecognizerStateChanged){
            factor = zoomScale * zoomRecognizer.scale;
            factor = MAX(1.0, MIN(factor, device.activeFormat.videoMaxZoomFactor));
            factor = (factor > 10.0 ? 10.0 : factor);
            device.videoZoomFactor = factor;
        }else if (zoomRecognizer.state == UIGestureRecognizerStateEnded){
            factor = zoomScale * zoomRecognizer.scale;
            factor = MAX(1.0, MIN(factor, device.activeFormat.videoMaxZoomFactor));
            factor = (factor > 10.0 ? 10.0 : factor);
            device.videoZoomFactor = factor;
            zoomScale = factor;
        }
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewPhoto bringSubviewToFront:zoomLevelView];
            zoomLevelView.alpha = 1.0;
            zoomLevelLabel.text = [NSString stringWithFormat:@"%.1f",factor];
            [UIView animateWithDuration:0.3 delay:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                zoomLevelView.alpha = 0.0;
            } completion:nil];
        });
        //
        [device unlockForConfiguration];
    }else{
        NSLog(@"actionFocus >> lockForConfiguration >> error: %@", [error localizedDescription]);
    }
}

//- (IBAction)actionClosePhotoView:(id)sender
//{
//    [self hidePhotoView];
//}
//
//- (IBAction)actionSharePhoto:(id)sender
//{
//    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[finalPhoto] applicationActivities:nil];
//    [self presentViewController:activityController animated:YES completion:^{
//        NSLog(@"activityController presented");
//    }];
//}

//- (IBAction)actionSavePhotoToCollection:(id)sender
//{
//    ShowcaseDataSource *SDS = [ShowcaseDataSource sharedInstance];
//
//    ShowcaseProduct *product = [ShowcaseProduct new];
//    product.name = [NSString stringWithFormat:@"photo_%@", [ToolBox dateHelper_TimeStampCompleteIOSfromDate:[NSDate date]]];
//    product.picture = finalPhoto;
//
//    if ([SDS savePhoto:product forUser:AppD.loggedUser.userID]){
//        [btnSaveToCollection setUserInteractionEnabled:NO];
//        [btnSaveToCollection setImage:[UIImage imageNamed:@"heart_fill"] forState:UIControlStateNormal];
//        [btnSaveToCollection setTintColor:[UIColor redColor]];
//        [btnSaveToCollection setBackgroundImage:nil forState:UIControlStateNormal];
//        [btnSaveToCollection setBackgroundImage:nil forState:UIControlStateHighlighted];
//        //
//        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
//        [alert showSuccess:NSLocalizedString(@"ALERT_TITLE_SHOWCASE_USER_COLLECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SHOWCASE_USER_COLLECTION_ADD_SUCCESS", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
//    }else{
//        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
//        [alert showError:NSLocalizedString(@"ALERT_TITLE_SHOWCASE_USER_COLLECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SHOWCASE_USER_COLLECTION_ADD_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
//    }
//}

#pragma mark - Manual Actions

- (void)showPhotoProcessScreen
{
    [session stopRunning];
    //
    [btnFlashMode setHidden:YES];
    [btnCameraChange setHidden:YES];
    [btnClick setHidden:YES];
    //
    [self setMaskImage:finalPhoto tintColor:nil alpha:1.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"SegueToMaskEdition" sender:self];
    });
}

- (void)restartPhotoView
{
    [session startRunning];
    //
    [self updateFlashlightState];
    //
    [btnCameraChange setHidden:NO];
    [btnClick setHidden:NO];
    //
    //[self setMaskImage:category.maskModel tintColor:category.maskTintColor alpha:category.maskAlpha];
}

//- (void)simpleTapInPostAction:(UITapGestureRecognizer*)sender
//{
//    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:finalPhoto backgroundImage:nil andDelegate:self];
//    photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
//    photoView.autoresizingMask = (1 << 6) -1;
//    photoView.alpha = 0.0;
//    //
//    [AppD.window addSubview:photoView];
//    [AppD.window bringSubviewToFront:photoView];
//    //
//    [UIView animateWithDuration:0.3 animations:^{
//        photoView.alpha = 1.0;
//    }];
//}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)photoViewDidHide:(VIPhotoView *)photoView
{
    __block id pv = photoView;
    
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [pv removeFromSuperview];
        pv = nil;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"showcase-background-default.jpg"]];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = @"Tire uma foto"; //category.name;
    
    viewContainerCamera.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"showcase-background-default.jpg"]];
    //
    viewPhoto.backgroundColor = [UIColor blackColor];
    viewPhoto.clipsToBounds = YES;
    viewPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
    viewPhoto.layer.borderWidth = 2.0;
    viewPhoto.layer.cornerRadius = 8.0;
    //
    imvMaskModel.backgroundColor = nil;
    imvMaskModel.image = nil;
    [imvMaskModel setUserInteractionEnabled:YES];
    
    btnFlashMode.backgroundColor = [UIColor clearColor];
    btnFlashMode = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFlashMode.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
    [btnFlashMode addTarget:self action:@selector(actionFlash:) forControlEvents:UIControlEventTouchUpInside];
    [btnFlashMode setFrame:CGRectMake(0, 0, 36, 36)];
    //
    btnCameraChange.backgroundColor = [UIColor clearColor];
    btnCameraChange = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCameraChange.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnCameraChange setImage:[UIImage imageNamed:@"PhotoCameraChange"] forState:UIControlStateNormal];
    [btnCameraChange addTarget:self action:@selector(actionCamera:) forControlEvents:UIControlEventTouchUpInside];
    [btnCameraChange setFrame:CGRectMake(0, 0, 36, 36)];
    //
    [btnFlashMode setExclusiveTouch:YES];
    [btnCameraChange setExclusiveTouch:YES];
    [btnClick setExclusiveTouch:YES];
    
    zoomLevelView.backgroundColor = nil;
    zoomLevelImageView.backgroundColor = nil;
    zoomLevelImageView.image = [UIImage imageNamed:@"CameraZoomLevel"];
    zoomLevelLabel.backgroundColor = nil;
    zoomLevelLabel.textColor = COLOR_MA_WHITE;
    zoomLevelLabel.text = @"1.0";
    zoomLevelView.alpha = 0.0;
    
    UIBarButtonItem *flashView = [[UIBarButtonItem alloc] initWithCustomView:btnFlashMode];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexibleItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cameraView = [[UIBarButtonItem alloc] initWithCustomView:btnCameraChange];
    self.navigationItem.rightBarButtonItems = @[cameraView , flexibleItem, flashView, flexibleItem2];
    
    activityIndicator.color = [UIColor whiteColor];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator stopAnimating];
    
    UITapGestureRecognizer *tapFocus = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionPointFocus:)];
    [tapFocus setNumberOfTouchesRequired:1];
    [tapFocus setNumberOfTapsRequired:1];
    tapFocus.delegate = self;
    [viewPhoto addGestureRecognizer:tapFocus];
    //
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(actionZoom:)];
    pinch.delegate = self;
    [viewPhoto addGestureRecognizer:pinch];
}

- (void)handleImage:(UIImage *)image
{
    finalPhoto = [self processPhoto:image];
    [self showPhotoProcessScreen];
}

- (UIImage*)processPhoto:(UIImage*)originalImage
{
    UIImage *newPhoto = [ToolBox graphicHelper_ResizeImage:originalImage toSize:category.maskModel.size];
    //UIImage *basePhoto = [ToolBox graphicHelper_MergeImage:[UIImage imageNamed:@"showcase-base-photo-watermark.jpg"] withImage:newPhoto position:CGPointMake(20, 20) blendMode:kCGBlendModeNormal alpha:1.0 scale:1.0];
    //UIImage *completePhoto = [ToolBox graphicHelper_MergeImage:basePhoto withImage:product.mask position:CGPointMake(20, 20) blendMode:kCGBlendModeNormal alpha:1.0 scale:1.0];
    return newPhoto;
}

- (void)avCaptureSessionStartRunning:(NSNotification*)notification
{
    [UIView transitionWithView:self.btnCameraChange
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowAnimatedContent
                    animations:nil
                    completion:^(BOOL finished) {
                        self.btnCameraChange.enabled = YES;
                    }];
}

- (void)enableCapture
{
    if (self.session) return;
    
    btnFlashMode.hidden = YES;
    btnCameraChange.hidden = YES;
    
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
        if (category.isFrontCameraPreferable){
            NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            for (AVCaptureDevice *d in devices) {
                if (d.position == AVCaptureDevicePositionFront) {
                    device = d;
                    break;
                }
            }
        }else{
            device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }
        
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.flashMode == AVCaptureFlashModeAuto || self.torchMode == AVCaptureTorchModeAuto){
                    //AUTO
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
                }else if (self.flashMode == AVCaptureFlashModeOn || self.torchMode == AVCaptureTorchModeOn){
                    //ON
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashON"] forState:UIControlStateNormal];
                }else{
                    //OFF
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashOFF"] forState:UIControlStateNormal];
                }
            });
            
        }
        [device unlockForConfiguration];
        
        self.capturePreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.capturePreviewLayer.frame = CGRectMake(0.0, 0.0, viewPhoto.frame.size.width, viewPhoto.frame.size.height);
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
#if TARGET_IPHONE_SIMULATOR
        self.viewPhoto.backgroundColor = [UIColor redColor];
#endif
        [viewPhoto.layer addSublayer:self.capturePreviewLayer];
        [viewPhoto bringSubviewToFront:imvMaskModel];
        [self.session startRunning];
        
        if ([self currentDevice].hasFlash || [self currentDevice].hasTorch) {
            [self updateFlashlightState];
            self.btnFlashMode.hidden = NO;
        }
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] &&
            [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            self.btnCameraChange.hidden = NO;
        }
    });
}

- (void)takePicture
{
    if (!btnClick.enabled) return;
    
    AVCaptureStillImageOutput *output = self.session.outputs.lastObject;
    AVCaptureConnection *videoConnection = output.connections.lastObject;
    if (!videoConnection) return;
    
    btnClick.enabled = NO;
    [AppD.soundManager playSound:SoundMediaNameCameraClick withVolume:1.0];
    [output captureStillImageAsynchronouslyFromConnection:videoConnection
                                        completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                            self.btnClick.enabled = YES;
                                            
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

- (void)updateFlashlightState
{
    AVCaptureDevice *device = [self currentDevice];
    
    if (!device) return;
    
    NSError *error = nil;
    BOOL success = [device lockForConfiguration:&error];
    if (success) {
        
        if (device.hasFlash){
            //FLASH
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.flashMode == AVCaptureFlashModeAuto){
                    //AUTO
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
                }else if (self.flashMode == AVCaptureFlashModeOn){
                    //ON
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashON"] forState:UIControlStateNormal];
                }else{
                    //OFF
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashOFF"] forState:UIControlStateNormal];
                }
            });
            device.flashMode = self.flashMode;
        }else if (device.hasTorch){
            //TORCH
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.torchMode == AVCaptureTorchModeAuto){
                    //AUTO
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashAUTO"] forState:UIControlStateNormal];
                }else if (self.torchMode == AVCaptureTorchModeOn){
                    //ON
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashON"] forState:UIControlStateNormal];
                }else{
                    //OFF
                    [btnFlashMode setImage:[UIImage imageNamed:@"PhotoFlashOFF"] forState:UIControlStateNormal];
                }
            });
            device.torchMode = self.torchMode;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.btnFlashMode.hidden = !(device.isFlashAvailable || device.isTorchAvailable);
        });
        
        [device unlockForConfiguration];
    }
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

- (void)setMaskImage:(UIImage*)mask tintColor:(UIColor*)color alpha:(CGFloat)alpha
{
    if (color != nil){
        imvMaskModel.image = [mask imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imvMaskModel.tintColor = color;
        imvMaskModel.alpha = alpha;
    }else{
        imvMaskModel.image = mask;
        imvMaskModel.tintColor = nil;
        imvMaskModel.alpha = 1.0;
    }
}

@end
