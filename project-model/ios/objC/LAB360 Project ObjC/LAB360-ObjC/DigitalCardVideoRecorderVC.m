//
//  DigitalCardVideoRecorderVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 20/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "DigitalCardVideoRecorderVC.h"
//
#import <AVKit/AVKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface DigitalCardVideoRecorderVC()

@property(nonatomic, weak) IBOutlet UIImageView *imgBackground;
@property(nonatomic, weak) IBOutlet UIButton *btnRecord;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) UIImagePickerController *videoPicker;
@property (nonatomic, strong) AVAsset *videoAsset;
@property (nonatomic, strong) UIColor *customViewColor;
@property (nonatomic, strong) NSString *localVideoURL;

@end

#pragma mark - • IMPLEMENTATION
@implementation DigitalCardVideoRecorderVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize imgBackground, btnRecord, lblTitle;
@synthesize customViewColor, videoPicker, videoAsset, videoID, localVideoURL;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    customViewColor = [UIColor colorWithRed:178.0/255.0 green:58.0/255.0 blue:108.0/255.0 alpha:1.0];
    
    videoPicker = nil;
    localVideoURL = nil;
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
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
    
    if (!error){
        [self actionUploadVideo];
    }
}

- (void)actionUploadVideo
{
    //TODO: upload do video
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
    
    
}

- (IBAction)actionRecordVideo:(id)sender
{
    videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    videoPicker.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeMovie];
    videoPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    videoPicker.videoMaximumDuration = 30.0;
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    videoPicker.allowsEditing = NO;
    videoPicker.showsCameraControls = YES;
    videoPicker.cameraViewTransform = CGAffineTransformIdentity;
    videoPicker.delegate = self;
    //optional (video frame):
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    iv.image = [UIImage imageNamed:@"mother_frame_border.png"];
    videoPicker.cameraOverlayView = iv;
    //
   [self presentViewController:videoPicker animated:YES completion:NULL];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1 - Get media type
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    // 2 - Dismiss image picker
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 3 - Handle video selection (neste caso o tipo sempre será vídeo, pois assim foi definido para o 'imagePickerCOntroller' anteriormente)
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        videoAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Processing];
        });
        [self saveAndProccessVideo];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = customViewColor;
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    
    self.navigationItem.title = @"Gravar Cartão";
    
    imgBackground.backgroundColor = nil;
    
    lblTitle.backgroundColor = nil;
    lblTitle.textColor = customViewColor;
    [lblTitle setFont:[UIFont fontWithName:FONT_SIGNPAINTER size:30.0]];
    [lblTitle setText:@"Grave uma vídeo especial para sua Mãe!\n\nVocê tem até 30 segundos para registrar sua mensagem."];
    
    //Botões:
    btnRecord.backgroundColor = [UIColor clearColor];
    [btnRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnRecord.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnRecord setTitle:@"Gravar Mensagem" forState:UIControlStateNormal];
    [btnRecord setExclusiveTouch:YES];
    [btnRecord setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnRecord.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btnRecord setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnRecord.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    UIImage *iconCreate = [ToolBox graphicHelper_ImageWithTintColor:[UIColor redColor] andImageTemplate:[UIImage imageNamed:@"AudioControlRec"]];
    [btnRecord setImage:iconCreate forState:UIControlStateNormal];
    [btnRecord setImageEdgeInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 15.0)];
    [btnRecord.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnRecord setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    //[btnRecord setTintColor:[UIColor redColor]];
    
    [ToolBox graphicHelper_ApplyShadowToView:btnRecord withColor:[UIColor blackColor] offSet:CGSizeMake(2.0, 2.0) radius:2.0 opacity:0.5];
    
}

#pragma mark - Video Proccess

- (void)saveAndProccessVideo
{
    // 1 - Early exit if there's no video file selected
    if (!self.videoAsset) {
        NSLog(@"Video Asset não carregado!");
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        return;
    }
    
    // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 3 - Video & Audio track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration) ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration) ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:self.videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize];
    
    // 4 - Get path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *videosDirectory = [documentsDirectory stringByAppendingPathComponent:@"Videos"];
    [self resolvePath:videosDirectory];
    localVideoURL = [videosDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"VIDEO_%@.mp4", videoID]];
    [self resolveFile:localVideoURL];
    NSURL *url = [NSURL fileURLWithPath:localVideoURL];
    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = url;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                BOOL okToSaveVideo = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(localVideoURL);
                if (okToSaveVideo) {
                    UISaveVideoAtPathToSavedPhotosAlbum(localVideoURL, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
                }else{
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    //
                    [self actionUploadVideo];
                }
            }else{
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                //
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:@"Erro!" subTitle:[NSString stringWithFormat:@"Um erro inexperado impede que o vídeo seja corretamente processado: %@", [exporter.error localizedDescription]] closeButtonTitle:@"OK" duration:0.0];
            }
        });
    }];
}

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
    // 1 - Overlay (image) ****************************************************************************
    UIImage *overlayImage = [UIImage imageNamed:@"mother_overlay_watermark.png"];
    CGFloat ratio = overlayImage.size.width / overlayImage.size.height;
    CGFloat newWidth = size.width / 5.0 * 3.0;
    CGFloat newHeight = newWidth / ratio;
    overlayImage = [ToolBox graphicHelper_ResizeImage:overlayImage toSize:CGSizeMake(newWidth, newHeight)];
    //water-mark
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer setContents:(id)[overlayImage CGImage]];
    [overlayLayer setContentsGravity:kCAGravityBottom];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    //border
    UIImage *overlayImage2 = [UIImage imageNamed:@"mother_frame_border.png"];
    CALayer *overlayLayer2 = [CALayer layer];
    [overlayLayer2 setContents:(id)[overlayImage2 CGImage]];
    overlayLayer2.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer2 setMasksToBounds:YES];
    
    // 2 - Overlay (texto, exemplo) ****************************************************************************
//    CATextLayer *textLayer = [[CATextLayer alloc] init];
//    [textLayer setFont:FONT_SIGNPAINTER];
//    [textLayer setFontSize:20];
//    [textLayer setFrame:CGRectMake(0, 0, size.width, 100)];
//    [textLayer setString:@"Feliz Dia das Mães!"];
//    [textLayer setAlignmentMode:kCAAlignmentCenter];
//    [textLayer setForegroundColor:[[UIColor whiteColor] CGColor]];
//    //
//    CALayer *overlayLayer3 = [CALayer layer];
//    [overlayLayer3 addSublayer:textLayer];
//    [overlayLayer3 setContentsGravity:kCAGravityTop];
//    overlayLayer3.frame = CGRectMake(0, 0, size.width, size.height);
//    [overlayLayer3 setMasksToBounds:YES];
    
    // 3 - Parent Layer ****************************************************************************
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    [parentLayer addSublayer:overlayLayer2];
    
    // 4 - Composição Final ****************************************************************************
    composition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}

- (void)resolvePath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)resolveFile:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        NSError *error;
        [fileManager removeItemAtPath:path error:&error];
        if (error){
            NSLog(@"resolveFile > Error > %@", [error localizedDescription]);
        }
    }
}

@end
