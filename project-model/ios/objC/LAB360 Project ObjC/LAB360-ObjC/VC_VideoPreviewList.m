//
//  VC_VideoPreviewList.m
//  CozinhaTudo
//
//  Created by lucas on 16/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_VideoPreviewList.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_VideoPreviewList()

@property(nonatomic, weak) IBOutlet UITableView *tbvVideo;
@property(nonatomic, strong) NSMutableArray *videoList;
@property(nonatomic, weak) IBOutlet UISearchBar *srbVideo;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *tbvTopSpace;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_VideoPreviewList
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize tbvVideo, srbVideo, tbvTopSpace;
@synthesize videoList, selectedCategory, showSearchBar;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    tbvVideo.delegate = self;
    tbvVideo.dataSource = self;
    srbVideo.delegate = self;
    
    videoList = [[NSMutableArray alloc] init];
    
    [tbvVideo registerNib:[UINib nibWithNibName:@"TVC_VideoPlayer" bundle:nil] forCellReuseIdentifier:@"CustomCellVideo"];
    [tbvVideo setTableFooterView:[UIView new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout];
    if(showSearchBar) {
        showSearchBar = false;
        tbvTopSpace.constant = 56;
    } else {
        tbvTopSpace.constant = 0;
        [self setupData];
        [srbVideo setHidden:YES];
    }
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.view layoutIfNeeded];

}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(void) touchPlayButton:(UIButton*)sender {
    
    TVC_VideoPlayerListItem *cell = [tbvVideo cellForRowAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0]];
    VideoData *video = (VideoData *)[videoList objectAtIndex:sender.tag];
    
    [cell playVideoWithURL: video.urlVideo];
    
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return videoList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TVC_VideoPlayerListItem *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellVideo"];
    VideoData *video = (VideoData *)[videoList objectAtIndex:indexPath.row];
    
    if (video.thumbnail == nil){
        
        [cell.imvThumb setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:video.urlVideoThumb]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            cell.imvThumb.image = image;
            video.thumbnail = image;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
            cell.imvThumb.image = nil;
        }];
    }else{
        cell.imvThumb.image = video.thumbnail;
    }
    [cell.btnPlay setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    cell.videoDelegate = self;
    cell.btnPlay.tag = indexPath.row;
    cell.viewVideo.tag = indexPath.row;
    cell.viewVideoContainer.tag = indexPath.row;
    [cell.btnPlay addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.lblTitle.text = video.nameCustom;
    [self configureDataForCell:cell andIndexPath:indexPath];
    [cell updateLayout];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250.0;
}

- (void)cellVideoDelegateNeedEnterFullScreenWithIndex:(long)cellIndex
{
    VideoData *video = (VideoData *)[videoList objectAtIndex:cellIndex];
    //
    TVC_VideoPlayerListItem *cell = [tbvVideo cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
    //
    [self openVideoPlayerWithURL:video.urlVideo timeOffset:cell.viewVideo.videoProgress];
    [cell stopVideo];
    cell.progressVideo.progress = 0.0;
    [cell.viewVideoContainer setHidden:YES];
    [cell.imvThumb setHidden:NO];
    [cell.btnPlay setHidden:NO];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - SEARCH DELEGATE
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.text = @"";
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getVideosWithLimit:@"" offset:@"" videoId:@"" category_id:@"" subcategory_id:@"" tag:searchBar.text withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD hideLoadingAnimation];
            
            if(error) {
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_FEED_VIDEOS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            } else {
                
                if(response) {
                    
                    [videoList removeAllObjects];
                    NSArray *tempArray = [response valueForKey:@"videos"];
                    for (NSDictionary *dic in tempArray) {
                        
                        VideoData *video = [VideoData createObjectFromDictionary:dic];
                        [videoList addObject:video];
                    }
                    [tbvVideo reloadData];
                }
            }
            
        }];
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)
-(void) configureDataForCell:(TVC_VideoPlayerListItem *)cell andIndexPath:(NSIndexPath *)indexPath {
    
    for (UIGestureRecognizer *gr in [cell.viewVideo gestureRecognizers]){
        [cell.viewVideo removeGestureRecognizer:gr]; //imvPhoto_PostImage
    }
    
    UITapGestureRecognizer *simpleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(simpleTapInVideoAction:)];
    [simpleTapGesture setNumberOfTapsRequired:1];
    [simpleTapGesture setNumberOfTouchesRequired:1];
    simpleTapGesture.delegate = self;
    [cell.viewVideo addGestureRecognizer:simpleTapGesture];

}

- (void)simpleTapInVideoAction:(UITapGestureRecognizer*)sender {
    
    TVC_VideoPlayerListItem *cell = [tbvVideo cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.view.tag inSection:0]];
    VideoData *video = [videoList objectAtIndex:sender.view.tag];
    
    if (cell.viewVideo.playerStatus == UIViewVideoPlayerStoped){
        [cell playVideoWithURL:video.urlVideo];
    }else{
        [cell showOrHideVideoControls];
    }
}


- (void)openVideoPlayerWithURL:(NSString*)videoURL timeOffset:(CGFloat)tOffset
{
    NSURL *videoNSURL = [NSURL URLWithString:videoURL];
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
        CMTime seektime = CMTimeMakeWithSeconds((int32_t)((CGFloat) timeSeconds * tOffset), timeScale);
        [player seekToTime:seektime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        //
        [player play];
    }];
    
}

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //Navigation Controller
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_FEED_VIDEOS", nil);
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    //self.navigationController.toolbar.translucent = YES;
    //self.navigationController.toolbar.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
    //
    srbVideo.placeholder = NSLocalizedString(@"PLACEHOLDER_VIDEO_SEARCH", nil);
    srbVideo.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
}

-(void) setupData {
    
    NSString *subcatId = @"";
    
    for (DocVidCategory* cat in selectedCategory.subcategoryArray) {
        if(cat.selected) {
            self.navigationItem.title = cat.name;
            subcatId = [NSString stringWithFormat:@"%li", cat.idCategory];
            break;
        }
    }
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getVideosWithLimit:@"" offset:@"" videoId:@"" category_id:[NSString stringWithFormat:@"%li", selectedCategory.idCategory] subcategory_id:subcatId tag:@"" withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD hideLoadingAnimation];
            
            if(error) {
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_FEED_VIDEOS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            } else {
                
                if(response) {
                    
                    [videoList removeAllObjects];
                    NSArray *tempArray = [response valueForKey:@"videos"];
                    for (NSDictionary *dic in tempArray) {
                        
                        VideoData *video = [VideoData createObjectFromDictionary:dic];
                        [videoList addObject:video];
                    }
                    [tbvVideo reloadData];
                }
            }
            
        }];
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    
}
@end
