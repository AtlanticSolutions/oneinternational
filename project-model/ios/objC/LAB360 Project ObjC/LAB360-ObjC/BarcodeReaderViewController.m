//
//  BarcodeReaderViewController.m
//  LAB360-ObjC
//
//  Created by Erico GT on 03/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "BarcodeReaderViewController.h"
#import "BarcodeScanner.h"
#import "UIImage+fixOrientation.h"

NSString *const AVMetadataObjectSubtypeGeneric = @"AVMetadataObjectSubtypeGeneric";
NSString *const AVMetadataObjectSubtypeBoleto = @"AVMetadataObjectSubtypeBoleto";
NSString *const AVMetadataObjectSubtypeConvenio = @"AVMetadataObjectSubtypeConvenio";

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface BarcodeReaderViewController()

//Layout:
@property (nonatomic, weak) IBOutlet UIView *previewView;
@property (nonatomic, weak) IBOutlet UIView *viewOfInterest;
@property (nonatomic, strong) UIButton *btnFlashButton;
@property (nonatomic, strong) UIButton *btnRectInterestArea;
@property (nonatomic, weak) IBOutlet UILabel *lblInstructions;
@property (nonatomic, weak) IBOutlet UILabel *lblResult;
//
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rectScanSizeWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rectScanSizeHeightConstraint;

//Data:
@property (nonatomic, strong) BarcodeScanner *scanner;
@property (nonatomic, strong) NSString *scannedCode;
@property (nonatomic, assign) BOOL captureIsFrozen;
@property (nonatomic, assign) BOOL didShowCaptureWarning;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
//
@property (nonatomic, strong) UIImage *snapshot;
@property (nonatomic, strong) NSDictionary *bankData;

@end

#pragma mark - • IMPLEMENTATION
@implementation BarcodeReaderViewController
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize rectScanType, scanner, typesToRead, subtypesToRead, captureIsFrozen, didShowCaptureWarning, scannedCode, serialQueue, titleScreen, resultType, instructionText, validationKey, validationValue, snapshot, bankData;
@synthesize btnFlashButton, btnRectInterestArea, lblInstructions, rectScanSizeWidthConstraint, rectScanSizeHeightConstraint, lblResult;
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
    
    serialQueue = dispatch_queue_create("br.com.lab360.barcode.scanner", DISPATCH_QUEUE_SERIAL);
    
    NSData *bData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"barcode_bank_list" ofType:@"json"]];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:bData options:kNilOptions error:nil];
    
    if (dataDic){
        bankData = [[NSDictionary alloc] initWithDictionary:[dataDic objectForKey:@"data"]];
    }else{
        bankData = [NSDictionary new];
    }
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
        
        if (typesToRead == nil || typesToRead.count == 0){
            scanner = [[BarcodeScanner alloc] initWithPreviewView:previewView];
        }else{
            scanner = [[BarcodeScanner alloc] initWithMetadataObjectTypes:typesToRead previewView:previewView];
        }
        
        if (subtypesToRead == nil || subtypesToRead.count == 0){
            subtypesToRead = @[AVMetadataObjectSubtypeGeneric];
        }

        [self updateInterestFrame];
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

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    if ([segue.identifier isEqualToString:@"???"]){
//        //TODO
//    }
//}

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

- (IBAction)actionAspectInterestAreaChange:(id)sender
{
    switch (rectScanType) {
        case ScannableAreaFormatTypeDefinedByUser:{
            //NOTE: pode cair neste caso apenas na primeira vez. Considerá-se o mesmo tipo 'ScannableAreaFormatTypeSmallSquare'.
            rectScanType = ScannableAreaFormatTypeLargeSquare;
        }break;
        //
        case ScannableAreaFormatTypeSmallSquare:{
            rectScanType = ScannableAreaFormatTypeLargeSquare;
        }break;
            //
        case ScannableAreaFormatTypeLargeSquare:{
            rectScanType = ScannableAreaFormatTypeHorizontalStripe;
        }break;
        //
        case ScannableAreaFormatTypeHorizontalStripe:{
            rectScanType = ScannableAreaFormatTypeVerticalStripe;
        }break;
        //
        case ScannableAreaFormatTypeVerticalStripe:{
            rectScanType = ScannableAreaFormatTypeFullScreen;
        }break;
        //
        case ScannableAreaFormatTypeFullScreen:{
            rectScanType = ScannableAreaFormatTypeSmallSquare;
        }break;
    }
    
    [self updateInterestFrame];
    //
    scanner.scanRect = viewOfInterest.frame;
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
    
    self.navigationItem.title = titleScreen;
    
    lblInstructions.backgroundColor = [UIColor clearColor];
    [lblInstructions setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL]];
    [lblInstructions setTextColor:[UIColor whiteColor]];
    lblInstructions.text = instructionText;
    
    lblResult.backgroundColor = [UIColor clearColor];
    [lblResult setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [lblResult setTextColor:[UIColor yellowColor]];
    lblResult.text = @"";
    [ToolBox graphicHelper_ApplyShadowToView:lblResult withColor:[UIColor blackColor] offSet:CGSizeMake(1.0, 1.0) radius:2.0 opacity:0.75];
    lblResult.alpha = 0.0;
    
    btnFlashButton.backgroundColor = [UIColor clearColor];
    btnFlashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFlashButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnFlashButton setImage:[ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal andImageTemplate:[UIImage imageNamed:@"flash-button"]] forState:UIControlStateNormal];
    [btnFlashButton setImage:[ToolBox graphicHelper_ImageWithTintColor:[UIColor orangeColor] andImageTemplate:[UIImage imageNamed:@"flash-button"]] forState:UIControlStateSelected];
    [btnFlashButton addTarget:self action:@selector(flashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnFlashButton setFrame:CGRectMake(0, 0, 30, 30)];
    [btnFlashButton setExclusiveTouch:YES];
    
    btnRectInterestArea.backgroundColor = [UIColor clearColor];
    btnRectInterestArea = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRectInterestArea.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnRectInterestArea setImage:[ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:[UIImage imageNamed:@"camera-rect-area"]] forState:UIControlStateNormal];
    [btnRectInterestArea setExclusiveTouch:YES];
    [btnRectInterestArea setClipsToBounds:YES];
    [btnRectInterestArea setTitle:@"" forState:UIControlStateNormal];
    [btnRectInterestArea addTarget:self action:@selector(actionAspectInterestAreaChange:) forControlEvents:UIControlEventTouchUpInside];
    [btnRectInterestArea setFrame:CGRectMake(0, 0, 30, 30)];
    
    if (rectScanType != ScannableAreaFormatTypeDefinedByUser){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnFlashButton];
    }else{
        self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:btnFlashButton], [[UIBarButtonItem alloc] initWithCustomView:btnRectInterestArea]];
    }
    
    previewView.backgroundColor = [UIColor blackColor];
    viewOfInterest.backgroundColor = nil;
}

-(void) updateInterestFrame
{
    CGFloat height = 0.0;
    CGFloat width = 0.0;
    
    switch (rectScanType) {
        case ScannableAreaFormatTypeDefinedByUser:{
            width = previewView.frame.size.width * 0.8;
            height = width;
        }break;
        //
        case ScannableAreaFormatTypeSmallSquare:{
            width = previewView.frame.size.width * 0.45;
            height = width;
        }break;
        //
        case ScannableAreaFormatTypeLargeSquare:{
            width = previewView.frame.size.width * 0.8;
            height = width;
        }break;
        //
        case ScannableAreaFormatTypeHorizontalStripe:{
            width = previewView.frame.size.width - 20.0;
            height = previewView.frame.size.width * 0.25;
            
//            width = previewView.frame.size.width * 0.25;
//            height = previewView.frame.size.height - 20.0;
        }break;
        //
        case ScannableAreaFormatTypeVerticalStripe:{
            width = previewView.frame.size.width * 0.25;
            height = previewView.frame.size.height - 40.0;
            
//            width = previewView.frame.size.width - 20.0;
//            height = previewView.frame.size.width * 0.25;
        }break;
        //
        case ScannableAreaFormatTypeFullScreen:{
            width = previewView.frame.size.width - 20.0;
            height = previewView.frame.size.height - 20.0;
        }break;
    }
    
    rectScanSizeWidthConstraint.constant = width;
    rectScanSizeHeightConstraint.constant = height;
    [viewOfInterest setNeedsLayout];
    
    [self.view layoutIfNeeded];
    
    [viewOfInterest.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    //BACKGROUND:
    CGFloat extHeight = previewView.frame.size.height;
    CGFloat extWidth = previewView.frame.size.width;
    CGFloat intHeight =  height; //viewOfInterest.frame.size.height;
    CGFloat intWidth =  width; //viewOfInterest.frame.size.width;
    
    UIBezierPath *externalPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-(extWidth-intWidth)/2.0, -(extHeight-intHeight)/2.0, extWidth, extHeight) cornerRadius:0];
    UIBezierPath *internalPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, intWidth, intHeight) cornerRadius:0];
    [externalPath appendPath:internalPath];
    [externalPath setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = externalPath.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [viewOfInterest.layer addSublayer:fillLayer];
    
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
    
    [viewOfInterest.layer addSublayer:pathLayer];
}

- (NSString*)metadataNameForType:(AVMetadataObjectType)type andSubtype:(AVMetadataObjectSubtype)subtype
{
    if ([type isEqualToString:AVMetadataObjectTypeQRCode]){
        return @"QRCode";
    }else if ([type isEqualToString:AVMetadataObjectTypeAztecCode]){
        return @"Código Aztec";
    }else if ([type isEqualToString:AVMetadataObjectTypeDataMatrixCode]){
        return @"Data Matrix";
    }else if ([type isEqualToString:AVMetadataObjectTypeCode128Code]){
        return @"Código 128";
    }else if ([type isEqualToString:AVMetadataObjectTypeEAN13Code]){
        return @"Código EAN-13";
    }else if ([type isEqualToString:AVMetadataObjectTypeEAN8Code]){
        return @"Código EAN-8";
    }else if ([type isEqualToString:AVMetadataObjectTypeUPCECode]){
        return @"Código UPC-E";
    }else if ([type isEqualToString:AVMetadataObjectTypeCode39Code]){
        return @"Código 39";
    }else if ([type isEqualToString:AVMetadataObjectTypeCode39Mod43Code]){
        return @"Código 39 Mod 43";
    }else if ([type isEqualToString:AVMetadataObjectTypeCode93Code]){
        return @"Código 93";
    }else if ([type isEqualToString:AVMetadataObjectTypeFace]){
        return @"Face";
    }else if ([type isEqualToString:AVMetadataObjectTypeInterleaved2of5Code]){
        if (subtype == AVMetadataObjectSubtypeGeneric){
            return @"Código Intercalado 2 de 5";
        }else if (subtype == AVMetadataObjectSubtypeBoleto){
            return @"Boleto";
        }else if (subtype == AVMetadataObjectSubtypeConvenio){
            return @"Convênio";
        }
    }else if ([type isEqualToString:AVMetadataObjectTypeITF14Code]){
        return @"Código ITF14";
    }else if ([type isEqualToString:AVMetadataObjectTypePDF417Code]){
        return @"Código PDF417";
    }
    return nil;
}
#pragma mark - Scanning

- (void)startScanning {
    scannedCode = nil;
    
    __weak BarcodeReaderViewController *weakSelf = self;
    scanner.didStartScanningBlock = ^{
        NSLog(@"The scanner started scanning!");
        // Optionally set a rectangle of interest to scan codes. Only codes within this rect will be scanned.
        weakSelf.scanner.scanRect = weakSelf.viewOfInterest.frame;
    };
    
    NSError *error = nil;
    [self.scanner startScanningWithResultBlock:^(NSArray *codes, UIImage *interestRectSnapshot ) {
        
        lblResult.alpha = 0.0;
        
        if (!captureIsFrozen){
            AVMetadataMachineReadableCodeObject *metadataObj = codes.count > 0 ? [codes firstObject] : nil;
            
            if (metadataObj){
                
                NSString *str = metadataObj.stringValue;
                
                AVMetadataObjectSubtype subtype = [self subtypeForType:metadataObj.type forValue:str];
                
                if ([subtypesToRead containsObject:subtype]){
                    
                    NSString *metadataTypeName = [self metadataNameForType:metadataObj.type andSubtype:subtype];
                    
                    metadataTypeName = (metadataTypeName == nil ? @"Código Escaneado" : metadataTypeName);
                    
                    BOOL processCode = [self checkValidCode:str forType:metadataObj.type];
                    
                    //Verificando chave e valor:
                    if (processCode){
                        
                        if (validationKey){
                            NSDictionary *dic = [ToolBox converterHelper_DictionaryFromStringJson:str];
                            if (dic == nil){
                                processCode = NO;
                            }else{
                                if (![[dic allKeys] containsObject:validationKey]){
                                    processCode = NO;
                                }else{
                                    if (validationValue){
                                        id val = [dic objectForKey:validationKey];
                                        //
                                        if(val){
                                            NSString *strVal = [NSString stringWithFormat:@"%@", val];
                                            if (![strVal isEqualToString:validationValue]){
                                                processCode = NO;
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            if (validationValue){
                                if (![str isEqualToString:validationValue]){
                                    processCode = NO;
                                }
                            }
                        }
                        
                    }
                    
                    //Caso seja necessário processar o conteúdo escaneado:
                    if (processCode){
                        
                        [self.scanner captureStillImage:^(UIImage *image, NSError *error) {
                            snapshot = [self cropImageToViewOfInterest:image];
                            if (rectScanType == ScannableAreaFormatTypeVerticalStripe){
                                //A imagem precisa ser tombada:
                                snapshot = [self rotateImage:snapshot];
                            }
                        }];
                        
                        NSString *editedCode = [self editCode:str forType:metadataObj.type andSubtype:subtype];
                        
                        dispatch_sync(serialQueue, ^{
                            switch (resultType) {
                                case BarcodeReaderResultTypeNotifyAndAlert:{
                                    captureIsFrozen = YES;
                                    //[scanner freezeCapture];
                                    //
                                    [self postNotificationWithName:BARCODE_READER_RESULT_NOTIFICATION_KEY objectData:editedCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:metadataTypeName, @"type", nil]];
                                    //
                                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                    [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                                        //[scanner unfreezeCapture];
                                        captureIsFrozen = NO;
                                    }];
                                    NSString *simplifiedSTR = [self simplifyText:editedCode];
                                    [alert showInfo:metadataTypeName subTitle:simplifiedSTR closeButtonTitle:nil duration:0.0];
                                }break;
                                    //
                                case BarcodeReaderResultTypeNotifyAndClose:{
                                    captureIsFrozen = YES;
                                    //[scanner freezeCapture];
                                    //
                                    [self postNotificationWithName:BARCODE_READER_RESULT_NOTIFICATION_KEY objectData:editedCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:metadataTypeName, @"type", nil]];
                                    //
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [scanner stopScanning];
                                    });
                                    [self.navigationController popViewControllerAnimated:YES];
                                }break;
                                    //
                                case BarcodeReaderResultTypeAlertNotifyAndClose:{
                                    captureIsFrozen = YES;
                                    //[scanner freezeCapture];
                                    //
                                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                    [alert addButton:@"Utilizar Código" withType:SCLAlertButtonType_Normal actionBlock:^{
                                        [self postNotificationWithName:BARCODE_READER_RESULT_NOTIFICATION_KEY objectData:editedCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:metadataTypeName, @"type", nil]];
                                        //
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [scanner stopScanning];
                                        });
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }];
                                    [alert addButton:@"Descartar" withType:SCLAlertButtonType_Neutral actionBlock:^{
                                        //[scanner unfreezeCapture];
                                        captureIsFrozen = NO;
                                    }];
                                    NSString *simplifiedSTR = [self simplifyText:editedCode];
                                    [alert showInfo:metadataTypeName subTitle:simplifiedSTR closeButtonTitle:nil duration:0.0];
                                }break;
                                    //
                                case BarcodeReaderResultTypeDisplayOnly:{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        lblResult.text = [self simplifyText:editedCode];;
                                        lblResult.alpha = 1.0;
                                    });
                                }break;
                            }
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

- (void)postNotificationWithName:(NSString*)nName objectData:(id)objData userInfo:(NSDictionary*)infoDic
{
    if (snapshot){
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:infoDic];
        [mDic setValue:snapshot forKey:@"snapshot"];
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:nName object:objData userInfo:mDic];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:nName object:objData userInfo:infoDic];
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

- (UIImage*) cropImageToViewOfInterest:(UIImage*)image
{
    if (image == nil){
        return nil;
    }
    
    UIImage *fixedImage = [image fixOrientation];
    CIImage *convertedImage = [[CIImage alloc] initWithImage:fixedImage];  //imageWithCGImage:fixedImage.CGImage];
    
    CGFloat originX = viewOfInterest.frame.origin.x / previewView.frame.size.width;
    CGFloat originY = viewOfInterest.frame.origin.y / previewView.frame.size.height;
    
    CGFloat sizeX = viewOfInterest.frame.size.width / previewView.frame.size.width;
    CGFloat sizeY = viewOfInterest.frame.size.height / previewView.frame.size.height;
    
    CGRect rect = CGRectMake(fixedImage.size.width * originX, fixedImage.size.height * originY, fixedImage.size.width * sizeX, fixedImage.size.height * sizeY);
    
    CIFilter *filter = [CIFilter filterWithName:@"CICrop"];
    if (filter){
        [filter setDefaults];
        [filter setValue:convertedImage forKey:kCIInputImageKey];
        CIVector *vector = [[CIVector alloc] initWithCGRect:rect];
        [filter setValue:vector forKey:@"inputRectangle"];
        //
        CIImage *ciImage = [filter outputImage];
        if (ciImage){
            return [UIImage imageWithCIImage:ciImage];
        }
    }
    
    return image;
}

-(UIImage*) rotateImage:(UIImage*)image
{
    //A imagem precisa ser tombada. Neste caso foi escolhida a rotação anti-horário (como se o usuário estivesse usando "landscape right").
    UIImage *img = [UIImage imageWithCIImage:image.CIImage scale:1.0 orientation:UIImageOrientationRight];
    
    return img;
}

-(NSString*) simplifyText:(NSString*)text
{
    if (text.length > 100){
        NSString *reduced = [text substringToIndex:100];
        return [NSString stringWithFormat:@"%@...", reduced];
    }else{
        return text;
    }
}

- (AVMetadataObjectSubtype)subtypeForType:(AVMetadataObjectType)type forValue:(NSString*)text
{
    if (type == AVMetadataObjectTypeInterleaved2of5Code){
        if (text.length != 44){
            return AVMetadataObjectSubtypeGeneric;
        }else{
            
            //NOTE: É possível que uma instituição financeira inicie com 8 (somente uma foi aprovada até o momento), assim como os convênios. Segundo a documentação não é proibido.
            //Para saber mais: http://wiki.biserp.com.br/index.php/Especifica%C3%A7%C3%A3o_de_Guias_e_Boletos
            //Para atualizar a lista local (barcode_bank_list.json): https://www.conta-corrente.com/codigo-dos-bancos/
            
            NSString *bankCode = [text substringWithRange:NSMakeRange(0, 3)];
            NSString *bank = [self bankForCode:bankCode];
            
            if (bank == nil){
                //Pode ser um banco desconhecido ou um convênio
                if ([text hasPrefix:@"8"]){
                    //Tem muita chance de ser um convênio, pois apenas uma instituição financeira tem seu código iniciado com 8 (neste caso teremos um falso positivo...):
                    return AVMetadataObjectSubtypeConvenio;
                }else{
                    //Com certeza é um banco não identificado:
                    return AVMetadataObjectSubtypeBoleto;
                }
            }else{
                //É um banco com certeza:
                return AVMetadataObjectSubtypeBoleto;
            }
        }
    }else{
        return AVMetadataObjectSubtypeGeneric;
    }
}

-(NSString*) editCode:(NSString*)code forType:(AVMetadataObjectType)type andSubtype:(AVMetadataObjectSubtype)subtypeCode
{
    if (type == AVMetadataObjectTypeInterleaved2of5Code){
        
        if (subtypeCode == AVMetadataObjectSubtypeBoleto){
            
            NSString *bankCode = [code substringWithRange:NSMakeRange(0, 3)];
            NSString *bank = [self bankForCode:bankCode];
            
            //Exemplo (BOLETO):
            //código lido : 03399780100000156009930017100000061068970101
            //formatação esperada: 03399.93008 17100.000060 10689.701018 9 78010000015600
            
            NSString *A = [code substringWithRange:NSMakeRange(0, 5)]; //03399
            
            NSString *B = [code substringWithRange:NSMakeRange(20, 4)]; //9300 + 8 verificador
            
            NSString *digitGroup1 = [self calculateModule10For:[NSString stringWithFormat:@"%@%@", A, B]];
            
            NSString *C = [code substringWithRange:NSMakeRange(24, 5)]; //17100
            
            NSString *D = [code substringWithRange:NSMakeRange(29, 5)]; //00006 + 0 verificador
            
            NSString *digitGroup2 = [self calculateModule10For:[NSString stringWithFormat:@"%@%@", C, D]];
            
            NSString *E = [code substringWithRange:NSMakeRange(34, 5)]; //10689
            
            NSString *F = [code substringWithRange:NSMakeRange(39, 5)]; //70101 + 8 verificador
            
            NSString *digitGroup3 = [self calculateModule10For:[NSString stringWithFormat:@"%@%@", E, F]];
            
            NSString *G = [code substringWithRange:NSMakeRange(19, 1)]; //9 (já consta na sequência)
            
            NSString *H = [code substringWithRange:NSMakeRange(5, 14)]; //78010000015600
            
            NSString *complete = [NSString stringWithFormat:@"%@.%@%@ %@.%@%@ %@.%@%@ %@ %@\n[%@]", A, B, digitGroup1, C, D, digitGroup2, E, F, digitGroup3, G, H, bank];
            
            return complete;
        
        }else if (subtypeCode == AVMetadataObjectSubtypeConvenio){
            
            //Exemplo (CONVÊNIO):
            //código lido : 84620000003037802962019022000700000153763159
            //formatação esperada: 846200000-8 0303780296201-1 90220007000-8 00153763159-8
            
            NSString *A = [code substringWithRange:NSMakeRange(0, 11)]; //03399
            
            NSString *digitGroup1 = [self calculateModule10For:A];
            
            NSString *B = [code substringWithRange:NSMakeRange(11, 11)]; //03399
            
            NSString *digitGroup2 = [self calculateModule10For:B];
            
            NSString *C = [code substringWithRange:NSMakeRange(22, 11)]; //03399
            
            NSString *digitGroup3 = [self calculateModule10For:C];
            
            NSString *D = [code substringWithRange:NSMakeRange(33, 11)]; //03399
            
            NSString *digitGroup4 = [self calculateModule10For:D];
            
            NSString *complete = [NSString stringWithFormat:@"%@-%@ %@-%@ %@-%@ %@-%@", A, digitGroup1, B, digitGroup2, C, digitGroup3, D, digitGroup4];
        
            return complete;
        }
    }
    
    return code;
}

- (BOOL)checkValidCode:(NSString*)code forType:(AVMetadataObjectType)type
{
    if (type == AVMetadataObjectTypeInterleaved2of5Code){
        if ([subtypesToRead containsObject:AVMetadataObjectSubtypeBoleto] || [subtypesToRead containsObject:AVMetadataObjectSubtypeConvenio]){
            
            //NOTE: O boleto pode ser apresentado de 2 formas distintas (ambas são entregues pelo leitor com 44 caracteres):
            
            //BOLETOS:
            /*
             O boleto é uma forma de cobrança emitida por meio de um banco.
             Qualquer pessoa que tenha uma conta bancária pode solicitar a emissão de um boleto de cobrança para que outra pessoa lhe pague um valor devido.
             Esse tipo de conta também é chamada de título bancário.
            */
            
            //CONVÊNIOS:
            /*
             Os convênios também possuem código de barras, mas não são títulos.
             Eles normalmente são emitidos por concessionárias de serviços com água, luz, telefone e gás.
             Popularmente os convênios são chamados de contas.
            */
            
            //Para saber mais:
            //http://carlosfprocha.com/blogs/paleo/archive/2013/06/21/linha-digit-225-vel-de-boletos-banc-225-rios.aspx
            //http://www.jrimum.org/bopepo/wiki/Componente/Documentacao/Negocio
            //https://www.conta-corrente.com/codigo-dos-bancos/
            //http://wiki.biserp.com.br/index.php/Especifica%C3%A7%C3%A3o_de_Guias_e_Boletos
            
            if (code.length == 44){
                return YES;
            }else{
                return NO;
            }
        }
    }
    
    return YES;
}

- (NSString*)calculateModule10For:(NSString*)numbers
{
    NSMutableString *newSTR = [NSMutableString new];
    
    int peso = 2;
    
    for (int i = 0; i < numbers.length; i++)
    {
        //Os dígitos são dispostos da direita para a esquerda;
        int digit = [[numbers substringWithRange:NSMakeRange((numbers.length - 1) - i, 1)] intValue];
        
        //cada um deles é multiplicado por 2 ou 1. O primeiro por 2, o segundo por 1, o terceiro por 2, o quarto por 1 e assim sucessivamente;
        digit = digit * peso;
        peso = (peso == 2 ? 1 : 2);
        
        //os resultados que possuirem dois dígitos são convertidos na soma destes dígitos;
        if (digit > 9){
            NSString *doubleDigit = [NSString stringWithFormat:@"%i", digit];
            int n1 = [[doubleDigit substringWithRange:NSMakeRange(0, 1)] intValue];
            int n2 = [[doubleDigit substringWithRange:NSMakeRange(1, 1)] intValue];
            digit = n1 + n2;
        }
        
        [newSTR insertString:[NSString stringWithFormat:@"%i", digit] atIndex:0];
    }
    
    //então somam-se todos os dígitos restantes do resultado e divide-se esta soma por 10;
    int soma = 0;
    
    for (int i = 0; i < newSTR.length; i++)
    {
        soma += [[newSTR substringWithRange:NSMakeRange(i, 1)] intValue];
    }
    
    //o que nos importa aqui não é o resultado da divisão, mas apenas o resto dela;
    soma = soma % 10;
    
    //subtraímos este resto do número dez e o que obtivermos será o nosso dígito verificador.
    int result = 10 - soma;
    
    return [NSString stringWithFormat:@"%i", result];
}

- (NSString*)calculateModule11For:(NSString*)numbers
{
    //TODO:
    return @"";
}

- (NSString*)bankForCode:(NSString*)code
{
    NSString *bank = [bankData valueForKey:code];
    if (bank == nil){
        return @"???"; //Indica que a tabela de nome de bancos precisa de atualização...
    }else{
        return bank;
    }
}

@end
