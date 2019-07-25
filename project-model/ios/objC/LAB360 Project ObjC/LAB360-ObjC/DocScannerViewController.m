//
//  DocScannerViewController.m
//  LAB360-ObjC
//
//  Created by Erico GT on 02/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "DocScannerViewController.h"
#import "DocCameraView.h"
#import "AppDelegate.h"
#import "TOCropViewController.h"

@interface DocScannerViewController ()<DocCameraViewProtocol, TOCropViewControllerDelegate>

@property (weak) id<DocScannerViewControllerDelegate> camera_PrivateDelegate;

@property (nonatomic, strong)  UIButton *btnFlash;
@property (weak, nonatomic) IBOutlet UIImageView *focusIndicator;
//
@property (weak, nonatomic) IBOutlet DocCameraView  *cameraView;
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UILabel *lblInstructions;
@property (nonatomic, weak) IBOutlet UIImageView *imvInstructions;

- (IBAction)captureButton:(id)sender;

@property (readwrite, nonatomic)        DocScannerViewType                   cameraViewType;

@property (readwrite, nonatomic)        DocScannerDetectorType               detectorType;

@end

@implementation DocScannerViewController

#pragma mark - Initializer

@synthesize screenTitle;
@synthesize btnFlash, footerView, lblInstructions, imvInstructions;

+ (instancetype)cameraViewWithDefaultType:(DocScannerViewType)type defaultDetectorType:(DocScannerDetectorType)detector withDelegate:(id<DocScannerViewControllerDelegate>)delegate
{
    NSAssert(delegate != nil, @"You must provide a delegate");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Utilities" bundle:[NSBundle mainBundle]];
    DocScannerViewController* cameraView = [storyboard instantiateViewControllerWithIdentifier:@"DocScannerViewController"];
    cameraView.cameraViewType = type;
    cameraView.detectorType = detector;
    cameraView.camera_PrivateDelegate = delegate;
    cameraView.detectionOverlayColor = [UIColor greenColor];
    cameraView.cameraView.enableShowAutoFocus;
    return cameraView;
}

#pragma mark - Button delegates

#pragma mark - Setters

- (void)setCameraViewType:(DocScannerViewType)cameraViewType {
    _cameraViewType = cameraViewType;
    [self.cameraView setCameraViewType:cameraViewType];
}

- (void)setDetectorType:(DocScannerDetectorType)detectorType {
    _detectorType = detectorType;
    [self.cameraView setDetectorType:detectorType];
}

//- (void)setShowAutoFocusWhiteRectangle:(BOOL)showAutoFocusWhiteRectangle {
//    //_showAutoFocusWhiteRectangle = showAutoFocusWhiteRectangle;
//    [self.cameraView setEnableShowAutoFocus:showAutoFocusWhiteRectangle];
//}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.cameraView setupCameraView];
    [self.cameraView setDelegate:self];
    [self.cameraView setOverlayColor:self.detectionOverlayColor];
    [self.cameraView setDetectorType:self.detectorType];
    [self.cameraView setCameraViewType:self.cameraViewType];
    [self.cameraView setEnableShowAutoFocus:YES];
    
    [self.cameraView setEnableBorderDetection:YES];
 
    screenTitle = @"Scanner";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    [self updateLayout];
    
    if (self.cameraView.flash){
        UIBarButtonItem *buttonF = [[UIBarButtonItem alloc] initWithCustomView:btnFlash];
        UIBarButtonItem *buttonC = [self createCameraFilterTypeButton];
        self.navigationItem.rightBarButtonItems = @[buttonF, buttonC];
    }else{
        UIBarButtonItem *buttonC = [self createCameraFilterTypeButton];
        self.navigationItem.rightBarButtonItem = buttonC;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //
    [self.cameraView start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //
    [self.cameraView stop];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate{
    return NO;
}

#pragma mark - CameraVC Actions

- (IBAction)actionDetectingQualityToogle:(id)sender
{
    [self setDetectorType:(self.detectorType == DocScannerDetectorTypeAccuracy) ? DocScannerDetectorTypePerformance : DocScannerDetectorTypeAccuracy];
}

- (IBAction)actionCameraFilterToogle:(id)sender
{
    //Normal
    switch (self.cameraViewType) {
        case DocScannerViewTypeBlackAndWhite:
            [self setCameraViewType:DocScannerViewTypeNormal];
            break;
        case DocScannerViewTypeNormal:
            [self setCameraViewType:DocScannerViewTypeUltraContrast];
            break;
        case DocScannerViewTypeUltraContrast:
            [self setCameraViewType:DocScannerViewTypeBlackAndWhite];
            break;
        default:
            break;
    }
    
    //Apenas alter entre colorido e bp
    //if (self.cameraViewType == DocScannerViewTypeBlackAndWhite){
    //    [self setCameraViewType:DocScannerViewTypeNormal];
    //}else{
    //    [self setCameraViewType:DocScannerViewTypeNormal];
    //}
}

- (IBAction)actionFlashToogle:(id)sender
{
    BOOL enable = !self.cameraView.isTorchEnabled;
    //
    [self updateFlashButtonIconUsingStateON:enable];
    //
    self.cameraView.enableTorch = enable;
}

#pragma mark - UI animations

- (void)changeButton:(UIButton *)button targetTitle:(NSString *)title toStateEnabled:(BOOL)enabled
{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:(enabled) ? [UIColor colorWithRed:1 green:0.81 blue:0 alpha:1] : [UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark - CameraVC Capture Image

- (IBAction)captureButton:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]){
        [((UIButton*)sender) setEnabled:NO];
    }
    
    // Some Feedback to the User
    UIView *white = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [white setBackgroundColor:[UIColor whiteColor]];
    white.alpha = 0.0f;
    [self.view addSubview:white];
    [UIView animateWithDuration:0.25f animations:^{
        white.alpha = 1.0f;
        white.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [white removeFromSuperview];
        
        //Indicador sonoro de sucesso:
        [AppD.soundManager playSound:SoundMediaNameCameraClick withVolume:0.85];
    
        //Capturando a imagem final:
        [self.cameraView captureImageWithCompletionHander:^(id data)
         {
             UIImage *image = nil;
             
             @try {
                 image = ([data isKindOfClass:[NSData class]]) ? [UIImage imageWithData:data] : data;
             } @catch (NSException *exception) {
                 NSLog(@"captureImageWithCompletionHander >> Error >> %@", [exception reason]);
             }
             
             if (image){
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self showImageEditorUsing:image];
                     [self.cameraView stop];
                 });
             }else{
                 if (self.camera_PrivateDelegate)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.camera_PrivateDelegate pageSnapped:image from:self];
                         [self.navigationController popViewControllerAnimated:YES];
                     });
                 }
             }
             
             if ([sender isKindOfClass:[UIButton class]]){
                 [((UIButton*)sender) setEnabled:YES];
             }
            
         }];
    }];
}

- (void)showImageEditorUsing:(UIImage*)image
{
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
    cropViewController.delegate = self;
    cropViewController.customAspectRatio = CGSizeMake(image.size.width, image.size.height);
    cropViewController.aspectRatioLockEnabled = false;
    cropViewController.aspectRatioPickerButtonHidden = true;
    cropViewController.resetAspectRatioEnabled = true;
    cropViewController.showActivitySheetOnDone = false;
    //
    cropViewController.title = @"Edição";
    cropViewController.doneButtonTitle = @"OK";
    cropViewController.cancelButtonTitle = @"Descartar";
    //
    [self presentViewController:cropViewController animated:YES completion:nil];
}

#pragma mark - DocCameraViewProtocol

-(void)didLostConfidence:(DocCameraView*)view
{
    [self setInstructionsMessage:@"Enquadre o documento por completo."];
}

-(void)didDetectRectangle:(DocCameraView*)view withConfidence:(NSUInteger)confidence
{
    //__weak  typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (confidence > view.minimumConfidenceForFullDetection) {
            float range = (float)view.maximumConfidenceForFullDetection - (float)view.minimumConfidenceForFullDetection;
            float actual = (float)confidence - (float)view.minimumConfidenceForFullDetection;
            float percent = actual / range;
            //
            [self setInstructionsMessage:[NSString stringWithFormat:@"Finalizando %.1f %%", (percent * 100.0)]];

        } else {
            [self setInstructionsMessage:@"Escaneando. Mantenha sua posição!"];
        }
    });
}

-(void)didGainFullDetectionConfidence:(DocCameraView*)view
{
    [self setInstructionsMessage:@"Documento escaneado!"];
    //
    [self captureButton:view];
}

#pragma mark - Private

- (void)updateLayout
{
    //Self
    self.view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    //
    self.navigationItem.title = screenTitle;
    
    [self createFlashButton];
    
    footerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.50];
    
    lblInstructions.backgroundColor = [UIColor clearColor];
    lblInstructions.textColor = [UIColor whiteColor];
    lblInstructions.text = @"";
    [lblInstructions setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    
    imvInstructions.backgroundColor = [UIColor clearColor];
    imvInstructions.image = [UIImage imageNamed:@"VirtualSceneInfoIcon"];
}

- (void)createFlashButton
{
    btnFlash = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFlash.backgroundColor = [UIColor clearColor];
    btnFlash.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    [btnFlash setImage:[ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal andImageTemplate:[UIImage imageNamed:@"flash-button"]] forState:UIControlStateNormal];
    [btnFlash setImage:[ToolBox graphicHelper_ImageWithTintColor:[UIColor orangeColor] andImageTemplate:[UIImage imageNamed:@"flash-button"]] forState:UIControlStateSelected];
    //
    [btnFlash setFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [btnFlash setClipsToBounds:YES];
    [btnFlash setExclusiveTouch:YES];
    [btnFlash addTarget:self action:@selector(actionFlashToogle:) forControlEvents:UIControlEventTouchUpInside];
    [btnFlash setSelected:NO];
    //
    [self updateFlashButtonIconUsingStateON:NO];
}

- (UIBarButtonItem*)createCameraFilterTypeButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    UIImage *image = [[UIImage imageNamed:@"PhotoCameraFilterType"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    //
    [button setFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [button setClipsToBounds:YES];
    [button setExclusiveTouch:YES];
    [button addTarget:self action:@selector(actionCameraFilterToogle:) forControlEvents:UIControlEventTouchUpInside];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:button];    
}

- (void)updateFlashButtonIconUsingStateON:(BOOL)stateON
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [btnFlash setSelected:stateON];
    });
}

- (void)setInstructionsMessage:(NSString*)message
{
    dispatch_async(dispatch_get_main_queue(),^{
        lblInstructions.text = message;
    });
}

#pragma mark - TOCropViewControllerDelegate

//- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropImageToRect:(CGRect)cropRect angle:(NSInteger)angle NS_SWIFT_NAME(cropViewController(_:didCropImageToRect:angle:))
//{
//
//}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle NS_SWIFT_NAME(cropViewController(_:didCropToImage:rect:angle:))
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.camera_PrivateDelegate)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.camera_PrivateDelegate pageSnapped:image from:self];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

//- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropToCircularImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle NS_SWIFT_NAME(cropViewController(_:didCropToCircleImage:rect:angle:))
//{
//
//}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled NS_SWIFT_NAME(cropViewController(_:didFinishCancelled:))
{
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cameraView start];
        });
    }];
}

@end
