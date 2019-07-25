//
//  DigitalCardViewer.m
//  LAB360-ObjC
//
//  Created by Erico GT on 20/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "DigitalCardViewerVC.h"
#import "UIViewVideoPlayer.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface DigitalCardViewerVC()<UIViewVideoPlayerDelegate>

@property (nonatomic, weak) IBOutlet UIViewVideoPlayer *viewVideo;
@property (nonatomic, weak) IBOutlet UIView *viewVideoControls;
@property (nonatomic, weak) IBOutlet UIView *viewVideoContainer;
@property (nonatomic, weak) IBOutlet UIView *viewVideoTimerBar;
@property (nonatomic, weak) IBOutlet UIButton *btnVideoMute;
@property (nonatomic, weak) IBOutlet UIButton *btnVideoPlay;
@property (nonatomic, weak) IBOutlet UIButton *btnVideoFullScreen;
@property (nonatomic, weak) IBOutlet UILabel *lblVideoTime;
@property (nonatomic, weak) IBOutlet UIProgressView *progressVideo;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *bufferIndicator;
//
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblName;

@property (nonatomic, assign) BOOL isShowingVideoControls;
@property (nonatomic, strong) UIColor *customViewColor;
@property(nonatomic, strong) NSString *videoURL;
//
@property(nonatomic, assign) BOOL isLoaded;

@end

#pragma mark - • IMPLEMENTATION
@implementation DigitalCardViewerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize viewVideo, videoID, progressVideo, viewVideoControls, btnVideoMute, btnVideoPlay, btnVideoFullScreen, lblVideoTime, isShowingVideoControls, viewVideoContainer, viewVideoTimerBar, bufferIndicator;
@synthesize lblTitle, lblName;
@synthesize videoURL, customViewColor, isLoaded;

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
    isLoaded = NO;
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
        [self setupLayout];
        
        UITapGestureRecognizer *simpleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        [simpleTapGesture setNumberOfTapsRequired:1];
        [simpleTapGesture setNumberOfTouchesRequired:1];
        simpleTapGesture.delegate = self;
        [viewVideoContainer addGestureRecognizer:simpleTapGesture];
        
        self.navigationItem.rightBarButtonItem = [self createShareButton];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *videosDirectory = [documentsDirectory stringByAppendingPathComponent:@"Videos"];
        videoURL = [videosDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"VIDEO_%@.mp4", videoID]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isLoaded){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:videoURL]){
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                viewVideoContainer.alpha = 1.0;
            } completion:^(BOOL finished) {
                [self playVideoWithURL:videoURL];
                isLoaded = YES;
            }];
        }else{
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert showError:@"Erro!" subTitle:[NSString stringWithFormat:@"Nenhum vídeo com o código '%@' foi encontrado para reprodução.", videoID] closeButtonTitle:nil duration:0.0];
        }
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionTap:(id)sender
{
    [self showOrHideVideoControls];
}

- (IBAction)actionMuteVideo:(id)sender
{
    [viewVideo setMute:!viewVideo.isMuted];
    //
    [self updateVideoControls];
}

- (IBAction)actionPlayPauseVideo:(id)sender
{
    //    UIViewVideoPlayerUnknown           = 0,
    //    UIViewVideoPlayerReadyToPlay       = 1,
    //    UIViewVideoPlayerPlaying           = 2,
    //    UIViewVideoPlayerPaused            = 3,
    //    UIViewVideoPlayerStoped            = 4,
    //    UIViewVideoPlayerError             = 5
    
    if (viewVideo.playerStatus == UIViewVideoPlayerReadyToPlay || viewVideo.playerStatus == UIViewVideoPlayerPlaying){
        [viewVideo pauseVideo];
    }else if (viewVideo.playerStatus == UIViewVideoPlayerPaused){
        [viewVideo resumeVideo];
    }else if (viewVideo.playerStatus == UIViewVideoPlayerStoped || viewVideo.playerStatus == UIViewVideoPlayerUnknown){
        if (viewVideo.videoNSURL){
            [viewVideo playVideoFrom:viewVideo.videoNSURL.absoluteString atTime:0.0 muted:NO];
        }
    }
}

- (IBAction)actionGoToFullscreenVideo:(id)sender
{
    NSURL *videoNSURL;
    if ([videoURL hasPrefix:@"http"] || [videoURL hasPrefix:@"www"]){
        //Externo:
        videoNSURL = [NSURL URLWithString:videoURL];
    }else{
        //Interno:
        videoNSURL = [NSURL fileURLWithPath:videoURL];
    }
    AVPlayer *player = [AVPlayer playerWithURL:videoNSURL];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    controller.view.frame = self.view.frame; //CGRectMake(0, 20.0, self.view.frame.size.width, self.view.frame.size.height);
    if (@available(iOS 11.0, *)) {
        controller.entersFullScreenWhenPlaybackBegins = YES;
        controller.exitsFullScreenWhenPlaybackEnds = YES;
    }
    controller.player = player;
    //
    [self presentViewController:controller animated:YES completion:^{
        NSLog(@"video presented");
        //Abre o vídeo num tempo específico:
        long long value = player.currentItem.asset.duration.value;
        int32_t timeScale = player.currentItem.asset.duration.timescale;
        int32_t timeSeconds = (int32_t)(value / timeScale);
        CMTime seektime = CMTimeMakeWithSeconds((int32_t)((CGFloat) timeSeconds * (viewVideo.videoProgress)), timeScale);
        [player seekToTime:seektime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        //
        [player play];
    }];
    
    [self stopVideo];
}

- (IBAction)shareDigitalCard:(id)sender
{
    if (viewVideo.playerStatus == UIViewVideoPlayerPlaying){
        [viewVideo pauseVideo];
    }
    
    //O vídeo para compartilhamento será sempre local (fileURLWithPath):
    NSURL *videoPath = [NSURL fileURLWithPath:videoURL];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[videoPath] applicationActivities:nil];
    if (IDIOM == IPAD){
        activityController.popoverPresentationController.sourceView = sender;
    }
    [self presentViewController:activityController animated:YES completion:^{
        NSLog(@"activityController presented");
    }];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIViewVideoPlayerDelegate

- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView didChangeStatus:(UIViewVideoPlayerStatus)status
{
    if (status == UIViewVideoPlayerStoped){
        progressVideo.progress = 0.0;
        lblVideoTime.text = @"0:00";
    }
    
    [self updateVideoControls];
}

- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView videoProgressUpdate:(CGFloat)progress timePlayed:(long)sPlayed timeRemaining:(long)sRemaining totalTime:(long)sTotal
{
    dispatch_async(dispatch_get_main_queue(), ^{
        progressVideo.progress = progress;
        lblVideoTime.text = [self secondsToString:sRemaining];
    });
}

- (void)UIViewVideoPlayer:(UIViewVideoPlayer*_Nonnull)playerView waitingBufferToContinue:(BOOL)isWaiting
{
    if (isWaiting){
        [bufferIndicator startAnimating];
    }else{
        [bufferIndicator stopAnimating];
    }
}

- (NSString*)secondsToString:(NSUInteger)seconds
{
    NSUInteger h = seconds / 3600;
    NSUInteger m = (seconds / 60) % 60;
    NSUInteger s = seconds % 60;
    //
    NSString *formattedTime;
    //
    if (h != 0){
        formattedTime = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", h, m, s];
    }else{
        formattedTime = [NSString stringWithFormat:@"%02lu:%02lu", m, s];
    }
    //
    return formattedTime;
}

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
    self.navigationItem.title = @"Mensagem";
    
    lblTitle.backgroundColor = nil;
    lblTitle.textColor = customViewColor;
    [lblTitle setFont:[UIFont fontWithName:FONT_SIGNPAINTER size:30.0]];
    [lblTitle setText:@"Feliz Dia das Mães!!"];
    
    lblName.backgroundColor = nil;
    lblName.textColor = customViewColor;
    [lblName setFont:[UIFont fontWithName:FONT_SIGNPAINTER size:20.0]];
    [lblName setText:[NSString stringWithFormat:@"De: %@", AppD.loggedUser.name]];
    
    //Video:
    progressVideo.progress = 0.0;
    progressVideo.trackTintColor = UIColor.darkGrayColor;
    progressVideo.progressTintColor = [UIColor whiteColor];
    //
    bufferIndicator.color = [UIColor whiteColor];
    [bufferIndicator setHidesWhenStopped:YES];
    [bufferIndicator stopAnimating];
    //
    viewVideoControls.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    [viewVideoControls setClipsToBounds:YES];
    viewVideoControls.layer.cornerRadius = 5.0;
    //
    viewVideoContainer.backgroundColor = customViewColor;
    viewVideoContainer.layer.cornerRadius = 5.0;
    //
    viewVideoTimerBar.backgroundColor = customViewColor;
    //
    btnVideoMute.backgroundColor = [UIColor blackColor];
    [btnVideoMute setTitle:@"" forState:UIControlStateNormal];
    [btnVideoMute setTintColor:[UIColor whiteColor]];
    [btnVideoMute.imageView setContentMode:UIViewContentModeScaleAspectFit];
    btnVideoMute.layer.cornerRadius = 5.0;
    //
    btnVideoPlay.backgroundColor = [UIColor blackColor];
    [btnVideoPlay setTitle:@"" forState:UIControlStateNormal];
    [btnVideoPlay setTintColor:[UIColor whiteColor]];
    [btnVideoPlay.imageView setContentMode:UIViewContentModeScaleAspectFit];
    btnVideoPlay.layer.cornerRadius = 5.0;
    //
    btnVideoFullScreen.backgroundColor = [UIColor blackColor];
    [btnVideoFullScreen setTitle:@"" forState:UIControlStateNormal];
    [btnVideoFullScreen setTintColor:[UIColor whiteColor]];
    [btnVideoFullScreen.imageView setContentMode:UIViewContentModeScaleAspectFit];
    btnVideoFullScreen.layer.cornerRadius = 5.0;
    //
    lblVideoTime.backgroundColor = customViewColor;
    lblVideoTime.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    lblVideoTime.textColor = [UIColor whiteColor];
    lblVideoTime.text = @"0:00";
    //
    isShowingVideoControls = NO;
    viewVideoControls.alpha = 0.0;
    //
    [self updateVideoControls];
    
    viewVideoContainer.alpha = 0.0;
}

- (void)playVideoWithURL:(NSString*)videoURL
{
    if (videoURL != nil && ![videoURL isEqualToString:@""]){
        
        viewVideo.delegate = self;
        [viewVideo playVideoFrom:videoURL atTime:0.0 muted:NO];
        [viewVideo setMute:NO];
        //
        isShowingVideoControls = NO;
        viewVideoControls.alpha = 0.0;
    }
}

- (void)stopVideo
{
    [viewVideo stopVideo];
}

- (void)showOrHideVideoControls
{
    if (isShowingVideoControls){
        isShowingVideoControls = NO;
        [UIView animateWithDuration:0.2 animations:^{
            viewVideoControls.alpha = 0.0;
        }];
    }else{
        isShowingVideoControls = YES;
        //[viewVideo pauseVideo];
        [self updateVideoControls];
        [UIView animateWithDuration:0.2 animations:^{
            viewVideoControls.alpha = 1.0;
        }];
    }
}

- (void)updateVideoControls
{
    [viewVideo bringSubviewToFront:viewVideoControls];
    
    //Mute:
    if (viewVideo.isMuted){
        [btnVideoMute setImage:[[UIImage imageNamed:@"icon-videoplayer-muteon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }else{
        [btnVideoMute setImage:[[UIImage imageNamed:@"icon-videoplayer-muteoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    //Play:
    if (viewVideo.playerStatus == UIViewVideoPlayerReadyToPlay || viewVideo.playerStatus == UIViewVideoPlayerPlaying){
        [btnVideoPlay setImage:[[UIImage imageNamed:@"icon-videoplayer-pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }else{
        [btnVideoPlay setImage:[[UIImage imageNamed:@"icon-videoplayer-resume"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    //FullScreen:
    [btnVideoFullScreen setImage:[[UIImage imageNamed:@"icon-videoplayer-fullscreen"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
}

- (UIBarButtonItem*)createShareButton
{
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.backgroundColor = nil;
    collectionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *img = [[UIImage imageNamed:@"SharePhotoMask"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [collectionButton setImage:img forState:UIControlStateNormal];
    //
    [collectionButton setFrame:CGRectMake(0, 0, 32, 32)];
    [collectionButton setClipsToBounds:YES];
    [collectionButton setExclusiveTouch:YES];
    [collectionButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [collectionButton addTarget:self action:@selector(shareDigitalCard:) forControlEvents:UIControlEventTouchUpInside];
    //
    [collectionButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    //
    [[collectionButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[collectionButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:collectionButton];
}
@end
