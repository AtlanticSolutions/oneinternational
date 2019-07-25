//
//  DigitalCardReaderVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 18/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "DigitalCardReaderVC.h"
#import "BarcodeScanner.h"
#import "DigitalCardViewerVC.h"
#import "DigitalCardVideoRecorderVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface DigitalCardReaderVC()

@property (nonatomic, weak) IBOutlet UIView *previewView;
@property (nonatomic, weak) IBOutlet UIView *viewOfInterest;
//
@property(nonatomic, strong) UIButton *btnFlashButton;
//@property(nonatomic, strong) IBOutlet UIButton *btnCameraButton;

@property (nonatomic, strong) BarcodeScanner *scanner;
@property (nonatomic, strong) NSString *scannedCode;
@property (nonatomic, strong) NSString *prefixCode;
@property (nonatomic, assign) BOOL captureIsFrozen;
@property (nonatomic, assign) BOOL didShowCaptureWarning;
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

#pragma mark - • IMPLEMENTATION
@implementation DigitalCardReaderVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize scanner, captureIsFrozen, didShowCaptureWarning, scannedCode, prefixCode, serialQueue, screenType;
@synthesize btnFlashButton;
@synthesize previewView, viewOfInterest;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    serialQueue = dispatch_queue_create("br.com.lab360.digital.card.queue", DISPATCH_QUEUE_SERIAL);
    prefixCode = @"LAB360VIDEOCARD_";
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
    
    if (scanner == nil){
        scanner = [[BarcodeScanner alloc] initWithPreviewView:previewView];
        [self createInterestFrame];
    }
    
    if (![scanner isScanning]){
        [BarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
            if (success) {
                [self startScanning];
                self.captureIsFrozen = NO;
            } else {
                [self displayPermissionMissingAlert];
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanner stopScanning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToCardCreate"]){
        DigitalCardVideoRecorderVC *vc = segue.destinationViewController;
        vc.videoID = scannedCode;
    }else if ([segue.identifier isEqualToString:@"SegueToCardViewer"]){
        DigitalCardViewerVC *vc = segue.destinationViewController;
        vc.videoID = scannedCode;
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)cameraButtonTapped:(id)sender {
    [self.scanner flipCamera];
}

- (IBAction)flashButtonTapped:(id)sender {
    
    if (!captureIsFrozen && scanner.isScanning){
        if (scanner.torchMode == RSPTorchModeOff) {
            scanner.torchMode = RSPTorchModeOn;
            UIButton *button = (UIButton *)sender;
            [button setSelected:YES];
            
        } else {
            self.scanner.torchMode = RSPTorchModeOff;
            UIButton *button = (UIButton *)sender;
            [button setSelected:NO];
        }
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    
    self.navigationItem.title = @"Enquadre o QRCode";
    
    btnFlashButton.backgroundColor = [UIColor clearColor];
    btnFlashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFlashButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnFlashButton setImage:[ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal andImageTemplate:[UIImage imageNamed:@"flash-button"]] forState:UIControlStateNormal];
    [btnFlashButton setImage:[ToolBox graphicHelper_ImageWithTintColor:[UIColor orangeColor] andImageTemplate:[UIImage imageNamed:@"flash-button"]] forState:UIControlStateSelected];
    [btnFlashButton addTarget:self action:@selector(flashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnFlashButton setFrame:CGRectMake(0, 0, 30, 30)];
    [btnFlashButton setExclusiveTouch:YES];
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnFlashButton];
    
    previewView.backgroundColor = [UIColor blackColor];
    viewOfInterest.backgroundColor = nil;
}

-(void) createInterestFrame
{
    //BACKGROUND:
    CGFloat extHeight = previewView.frame.size.height;
    CGFloat extWidth = previewView.frame.size.width;
    CGFloat intHeight = viewOfInterest.frame.size.height;
    CGFloat intWidth = viewOfInterest.frame.size.width;
    
    UIBezierPath *externalPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-(extWidth-intWidth)/2.0, -(extHeight-intHeight)/2.0, extWidth, extHeight) cornerRadius:0];
    UIBezierPath *internalPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, intWidth, intHeight) cornerRadius:0];
    [externalPath appendPath:internalPath];
    [externalPath setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = externalPath.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.viewOfInterest.layer addSublayer:fillLayer];
    
    //BORDAS:
    UIBezierPath* borderPath = [UIBezierPath bezierPath];

    //TOP LEFT
    [borderPath moveToPoint:CGPointMake(1, 25)];
    [borderPath addLineToPoint:CGPointMake(1, 1)];
    [borderPath addLineToPoint:CGPointMake(25, 1)];
    //TOP RIGHT
    [borderPath moveToPoint:CGPointMake(intWidth - 26, 1)];
    [borderPath addLineToPoint:CGPointMake(intWidth - 1, 1)];
    [borderPath addLineToPoint:CGPointMake(intWidth - 1, 25)];
    //BOTTOM LEFT
    [borderPath moveToPoint:CGPointMake(1, intHeight - 26)];
    [borderPath addLineToPoint:CGPointMake(1, intHeight - 1)];
    [borderPath addLineToPoint:CGPointMake(25, intHeight - 1)];
    //BOTTOM RIGHT
    [borderPath moveToPoint:CGPointMake(intWidth - 26, intHeight - 1)];
    [borderPath addLineToPoint:CGPointMake(intWidth - 1, intHeight - 1)];
    [borderPath addLineToPoint:CGPointMake(intWidth - 1, intHeight - 26)];

    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = borderPath.CGPath;
    pathLayer.strokeColor = AppD.styleManager.colorPalette.backgroundNormal.CGColor;
    pathLayer.lineWidth = 5.0f;
    pathLayer.fillColor = nil;

    [self.viewOfInterest.layer addSublayer:pathLayer];
}

#pragma mark - Scanning

- (void)startScanning {
    scannedCode = nil;
    
    __weak DigitalCardReaderVC *weakSelf = self;
    scanner.didStartScanningBlock = ^{
        NSLog(@"The scanner started scanning!");
        
        // Optionally set a rectangle of interest to scan codes. Only codes within this rect will be scanned.
        weakSelf.scanner.scanRect = weakSelf.viewOfInterest.frame;
    };
    
//    scanner.didTapToFocusBlock = ^(CGPoint point){
//        NSLog(@"The user tapped the screen to focus. \
//              Here we could present a view at %@", NSStringFromCGPoint(point));
//
//        [weakSelf.scanner captureStillImage:^(UIImage *image, NSError *error) {
//            NSLog(@"Image captured. Add a breakpoint here to preview it!");
//        }];
//    };
    
    NSError *error = nil;
    [self.scanner startScanningWithResultBlock:^(NSArray *codes, UIImage *interestRectSnapshot) {
        
        if (!captureIsFrozen){
            AVMetadataMachineReadableCodeObject *metadataObj = codes.count > 0 ? [codes firstObject] : nil;
            
            if (metadataObj){
                if (metadataObj.type == AVMetadataObjectTypeQRCode){
                    
                    NSString *str = metadataObj.stringValue;
                    if ([str hasPrefix:prefixCode] && scannedCode == nil){
                        
                        dispatch_sync(serialQueue, ^{
                            captureIsFrozen = YES;
                            scannedCode = [str stringByReplacingOccurrencesOfString:prefixCode withString:@""];
                            
                            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                            [alert addButton:@"Utilizar Código" withType:SCLAlertButtonType_Normal actionBlock:^{
                                
                                if (screenType == DigitalCardReaderScreenTypeCreate){
                                    [self performSegueWithIdentifier:@"SegueToCardCreate" sender:nil];
                                }else{
                                    [self performSegueWithIdentifier:@"SegueToCardViewer" sender:nil];
                                }

                            }];
                            [alert addButton:@"Descartar" withType:SCLAlertButtonType_Neutral actionBlock:^{
                                scannedCode = nil;
                                captureIsFrozen = NO;
                            }];
                            [alert showInfo:@"QRCode" subTitle:[NSString stringWithFormat:@"Um código de cartão presente foi encontrado!\n\n[ %@ ]\n\nDeseja utilizá-lo?", scannedCode] closeButtonTitle:nil duration:0.0];
                            
                        });
                    }
                }
            }
        }
        
    } error:&error];
    
    if (error) {
        NSLog(@"An error occurred: %@", error.localizedDescription);
    }
}

- (void)stopScanning {
    [scanner stopScanning];
    captureIsFrozen = NO;
}

#pragma mark - Helper Methods

- (void)displayPermissionMissingAlert {
    
    if ([BarcodeScanner scanningIsProhibited]) {
        //Explica o motivo da requisição
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        //
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", "") withType:SCLAlertButtonType_Neutral actionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        //
        [alert showInfo:NSLocalizedString(@"ALERT_TITLE_CAMERA_PERMISSION", "") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CAMERA_PHOTO_PERMISSION_QRCODE_READER", "") closeButtonTitle:nil duration:0.0];
    }
}
@end
