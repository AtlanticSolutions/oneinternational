//
//  VC_VideoPlayer.m
//  GS&MD
//
//  Created by Erico GT on 12/2/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_VideoPlayer.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_VideoPlayer()

@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_VideoPlayer
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize videoData, playerView;

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
//    self.navigationItem.rightBarButtonItem = [self createShareButton];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    //self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_VIDEO", @"");
    
    self.playerView.delegate = self;
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
    
    //MARK: para saber mais sobre os opções: https://developers.google.com/youtube/player_parameters
    NSDictionary *playerVars = [[NSDictionary alloc] initWithObjectsAndKeys:@0, @"playsinline", @2, @"controls", @0, @"rel", nil];
    
    [self.playerView loadWithVideoId:videoData.videoID playerVars:playerVars];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.view layoutIfNeeded];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    [self.playerView playVideo];
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    NSLog(@"State: %ld", (long)state);
    
    if (state == kYTPlayerStatePlaying){
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            [self.view layoutIfNeeded];
        }];
    }else if(state == kYTPlayerStatePaused || state == kYTPlayerStateEnded){
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBarHidden = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality
{
    NSLog(@"Quality: %ld", (long)quality);
}

- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
{
    NSLog(@"Error: %ld", (long)error);
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    self.navigationController.toolbar.translucent = YES;
    self.navigationController.toolbar.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    self.navigationItem.title = videoData.nameCustom;
}

- (UIBarButtonItem*)createShareButton
{
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeSystem];
    userButton.imageView.contentMode = UIViewContentModeScaleToFill;
    //
    UIImage *shareImage = [[UIImage imageNamed:@"icon-share-system"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:shareImage forState:UIControlStateNormal];
    [userButton setImage:shareImage forState:UIControlStateHighlighted];
    //
    [userButton setFrame:CGRectMake(0, 0, 32, 32)];
    [userButton setClipsToBounds:YES];
    [userButton setExclusiveTouch:YES];
    [userButton addTarget:self action:@selector(shareVideo:) forControlEvents:UIControlEventTouchUpInside];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}

- (void)shareVideo:(id)sender
{
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[videoData.urlYouTube] applicationActivities:nil];
    if (IDIOM == IPAD){
        activityController.popoverPresentationController.sourceView = sender;
    }
    [self presentViewController:activityController animated:YES completion:^{
        NSLog(@"x");
    }];
}
@end
