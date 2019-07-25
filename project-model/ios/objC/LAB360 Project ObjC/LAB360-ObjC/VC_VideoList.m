//
//  VC_VideoList.m
//  GS&MD
//
//  Created by Erico GT on 12/2/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_VideoList.h"
#import "TVC_VideoInfo.h"
#import "VideoData.h"
#import "VC_VideoPlayer.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_VideoList()

//Layout
@property (nonatomic, weak) IBOutlet UITableView *tvVideoList;

//Controls
@property (nonatomic, strong) NSMutableArray *videoPlayerList;
@property (nonatomic, assign) bool loaded;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_VideoList
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize tvVideoList, videoPlayerList, loaded;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loaded = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!loaded){
        
        [self.view layoutIfNeeded];
        [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_FEED_VIDEOS", @"")];
        
        ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
        
        NSLog(@"%i", AppD.loggedUser.userID);
        
        if ([connectionManager isConnectionActive])
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
            });
            
            //Buscando Feed de Vídeos
			[connectionManager getFeedVideoWithAppID:AppD.masterEventID withCompletionHandler:^(NSArray *response, NSError *error) {
                
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                
                if (error){
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_FEED_VIDEOS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }else{
                    
                    if (response){
                        
                        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[response valueForKey:@"videos"]];
                        NSMutableArray *tempResult = [NSMutableArray new];
                        for (NSDictionary *dic in tempArray){
                            VideoData *vd = [VideoData createObjectFromDictionary:dic];
                            [tempResult addObject:vd];
                        }
                        
                        //ordenando a lista
                        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        videoPlayerList = [[NSMutableArray alloc] initWithArray:[tempResult sortedArrayUsingDescriptors:sortDescriptors]];
                        
                        [tvVideoList reloadData];
                        loaded = true;
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
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VC_VideoPlayer *vcPlayer = (VC_VideoPlayer*)segue.destinationViewController;
    vcPlayer.videoData = sender;
    //
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
}

//TABLE VIEW

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return videoPlayerList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellVideoInfo";
    
    TVC_VideoInfo *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[TVC_VideoInfo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell updateLayout];
    
    VideoData *vData = [videoPlayerList objectAtIndex:indexPath.row];
    
    cell.lblTitle.text = vData.title;
    cell.lblTime.text = [NSString stringWithFormat:@"%@  |  %@", vData.time, vData.author];

    if (!vData.thumbnail){
        
        NSString *videoThumbnail = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg", vData.videoID];
        //
        [cell.imvThumbnail setBackgroundColor:[UIColor lightGrayColor]];
        [cell.activityIndicator startAnimating];
        //
        [[[AsyncImageDownloader alloc] initWithFileURL:videoThumbnail successBlock:^(NSData *data) {
            
            UIImage *img = nil;
            
            if (data != nil){
                img = [UIImage imageWithData:data];
                
                VideoData *vd = [videoPlayerList objectAtIndex:indexPath.row];
                vd.thumbnail = img;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    TVC_VideoInfo *updateCell = (id)[tvVideoList cellForRowAtIndexPath:indexPath];
                    if (updateCell){
                        updateCell.imvThumbnail.image = img;
                    }
                    [updateCell.activityIndicator stopAnimating];
                });
            }
            
        } failBlock:^(NSError *error) {
            NSLog(@"Erro ao buscar imagem: %@", error.domain);
        }] startDownload];
        
        
    }else{
        cell.imvThumbnail.image = vData.thumbnail;
        [cell.imvThumbnail setBackgroundColor:nil];
        [cell.activityIndicator stopAnimating];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Animação de seleção
    TVC_VideoInfo *cell = (TVC_VideoInfo*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            nil;
        }];
    });
    
    VideoData *vData = [videoPlayerList objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier:@"SegueToVideoPlayer" sender:vData];
    
    //MARK: Para abrir o vídeo conforme disponibilidade do sistema:
//    NSURL *url = [NSURL URLWithString:vData.urlYouTube];
//    if ([[UIApplication sharedApplication] canOpenURL:url]){
//        [[UIApplication sharedApplication] openURL:url];
//    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
        
    tvVideoList.backgroundColor = nil;
}
     
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
