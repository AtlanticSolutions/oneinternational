//
//  VC_Scanner.m
//  AHK-100anos
//
//  Created by Erico GT on 10/27/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_QRCodeScanner.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_QRCodeScanner()

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UIImageView *imvTargetPreview;
//
@property(nonatomic, weak) IBOutlet UIView *viewBackground;
@property(nonatomic, weak) IBOutlet UIButton *btnFlashButton;
@property(nonatomic, weak) IBOutlet UIButton *btnCameraButton;
@property(nonatomic, weak) IBOutlet UIButton *btnInfoButton;
//
@property (nonatomic) BOOL isReading;
@property (nonatomic) UIImage *imageQRCode;
@property (nonatomic) UIImage *imageTarget;
@property (nonatomic, assign) enum CAMERA_ADALIVE cameraPosition;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) CGRect originalRect;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_QRCodeScanner
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES

@synthesize viewPreview, viewBackground, imvTargetPreview, btnFlashButton, btnCameraButton, btnInfoButton;
@synthesize isReading, imageQRCode, imageTarget, cameraPosition, captureSession, videoPreviewLayer, captureDevice, audioPlayer, originalRect;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //Button Profile Pic
    self.navigationItem.rightBarButtonItem = [AppD createProfileButton];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorTextNormal, NSFontAttributeName:[UIFont fontWithName:FONT_MYRIAD_PRO_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_SCANNER", @"");
    
    [self enableCapture];
    captureSession = nil;
    captureDevice = nil;
    [self loadBeepSound];
    
    [self defaultDeviceVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    if (cameraPosition == eCAMERA_TYPE_BACK || cameraPosition == eCAMERA_TYPE_DEFAULT){
        [btnCameraButton setTintColor:AppD.styleManager.colorButtonIcon];
    }
    else{
        [btnCameraButton setTintColor:AppD.styleManager.colorButtonBackgroundNormal];
    }
    
    originalRect = viewPreview.frame;
    
    [self startReading];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [Answers logCustomEventWithName:@"Acesso a tela Scanner AdAlive" customAttributes:@{}];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)flashButtonTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (captureDevice){
        if ([captureDevice hasFlash] && [captureDevice hasTorch]){
            BOOL value = !button.isSelected;
            //
            if ([captureDevice lockForConfiguration:nil]){
                if(value){
                    [captureDevice setFlashMode:AVCaptureFlashModeOn];
                    [captureDevice setTorchMode:AVCaptureTorchModeOn];
                }else{
                    [captureDevice setFlashMode:AVCaptureFlashModeOff];
                    [captureDevice setTorchMode:AVCaptureTorchModeOff];
                }
                [captureDevice unlockForConfiguration];
                [button setSelected:value];
            }
        }
    }
}

-(IBAction)cameraButtonTapped:(id)sender
{
    [self stopReading];
    
    [btnFlashButton setSelected:NO];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        
        if ([device position] == AVCaptureDevicePositionBack) {
            if (cameraPosition == eCAMERA_TYPE_FRONT){
                cameraPosition = eCAMERA_TYPE_BACK;
                break;
            }
        }else if ([device position] == AVCaptureDevicePositionFront) {
            if (cameraPosition == eCAMERA_TYPE_BACK){
                cameraPosition = eCAMERA_TYPE_FRONT;
                break;
            }
        }
    }
    
    [self startReading];
}

-(IBAction)infoButtonTapped:(id)sender
{
    
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor blackColor];
    viewBackground.backgroundColor = AppD.styleManager.colorBackground;
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[AppD.styleManager createFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorBackground] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[AppD.styleManager createFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorBackground]];
    
    self.navigationController.toolbar.translucent = YES;
    self.navigationController.toolbar.barTintColor = AppD.styleManager.colorBackground;
    
    //Target
    imvTargetPreview.backgroundColor = [UIColor clearColor];
    imvTargetPreview.image = [[UIImage imageNamed:@"target"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imvTargetPreview.tintColor = [UIColor whiteColor];
    
    //Buttons
    btnFlashButton.backgroundColor = [UIColor clearColor];
    btnCameraButton.backgroundColor = [UIColor clearColor];
    btnInfoButton.backgroundColor = [UIColor clearColor];
    //
    [btnFlashButton setImage:[AppD.styleManager imageWithTintColor:AppD.styleManager.colorButtonIcon andImageTemplate:[UIImage imageNamed:@"flash-button.png"]] forState:UIControlStateNormal];
    [btnFlashButton setImage:[AppD.styleManager imageWithTintColor:AppD.styleManager.colorButtonBackgroundNormal andImageTemplate:[UIImage imageNamed:@"flash-button.png"]] forState:UIControlStateSelected];
    [btnCameraButton setTintColor:AppD.styleManager.colorButtonIcon];
    [btnInfoButton setTintColor:AppD.styleManager.colorButtonIcon];
    //
    [btnFlashButton setExclusiveTouch:YES];
    [btnCameraButton setExclusiveTouch:YES];
    [btnInfoButton setExclusiveTouch:YES];
}

- (void)enableCapture
{
    isReading = NO;
}

- (void)disableCapture
{
    isReading = YES;
}

- (BOOL)startReading
{
    [self disableCapture];
    
    NSError *error;
    
    [self deviceForPosition:cameraPosition];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    captureSession = [[AVCaptureSession alloc] init];
    [captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    viewPreview.frame = originalRect;
    [videoPreviewLayer setFrame:viewPreview.layer.bounds];
    [viewPreview.layer addSublayer:videoPreviewLayer];
    
    [captureSession startRunning];
    
    return YES;
}

-(void)stopReading
{
    [self enableCapture];
    
    [captureSession stopRunning];
    captureSession = nil;
    captureDevice = nil;
    [videoPreviewLayer removeFromSuperlayer];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            if (audioPlayer) {
                [audioPlayer play];
            }
            
            NSLog(@"Scan result: %@", [metadataObj stringValue]);
            
            NSString *resultMessage = [metadataObj stringValue];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            [self processScanResultWithMessage:resultMessage];
        }
    }
}

- (void)processScanResultWithMessage:(NSString*)resultString
{
   NSDictionary *dicMessage = [ToolBox converterHelper_DictionaryFromStringJson:resultString];
    
    bool messageError = false;
    
    if (dicMessage){
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
            [self performSelectorOnMainThread:@selector(startReading) withObject:nil waitUntilDone:NO];
        }];
        
        [alert showWarning:self title:@"Scan" subTitle:[NSString stringWithFormat:@"%@", resultString] closeButtonTitle:nil duration:0.0];
        
    }else{
        messageError = true;
    }
    
    if (messageError){
        //O qrcode lido não corresponde ao esperado:
        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT_TITLE_ERROR_QRCODE", @"") message:NSLocalizedString(@"ALERT_MESSAGE_ERROR_QRCODE", @"") preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAct1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"Alert Options") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
//                                 {
//                                     [self performSelectorOnMainThread:@selector(startReading) withObject:nil waitUntilDone:NO];
//                                 }];
//        [alert addAction:okAct1];
//        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)loadBeepSound
{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [audioPlayer prepareToPlay];
    }
}

- (void)defaultDeviceVideo
{
    captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (captureDevice.position == AVCaptureDevicePositionBack){
        cameraPosition = eCAMERA_TYPE_BACK;
    }else if (captureDevice.position == AVCaptureDevicePositionFront){
        cameraPosition = eCAMERA_TYPE_FRONT;
    }else{
        cameraPosition = eCAMERA_TYPE_DEFAULT;
    }
    
    captureDevice = nil;
}

- (void)deviceForPosition:(enum CAMERA)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        
        if ([device position] == AVCaptureDevicePositionBack) {
            if (position == eCAMERA_TYPE_BACK){
                captureDevice = device;
                break;
            }
        }else if ([device position] == AVCaptureDevicePositionFront) {
            if (position == eCAMERA_TYPE_FRONT){
                captureDevice = device;
                break;
            }
        }else if ([device position] == AVCaptureDevicePositionUnspecified) {
            if (position == eCAMERA_TYPE_DEFAULT){
                captureDevice = device;
                break;
            }
        }
    }
}

@end
