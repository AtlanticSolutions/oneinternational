//
//  VC_PostsGallery.m
//  GS&MD
//
//  Created by Erico GT on 1/13/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//


#pragma mark - • HEADER IMPORT
#import <Crashlytics/Crashlytics.h>
//
#import "VC_PostsGallery.h"
#import "VC_Post.h"
#import "VC_Notifications.h"
#import "UIBarButtonItem+Badge.h"
#import "VC_ContactsChat.h"
#import "VC_WebViewCustom.h"
#import "TimelineConfigurationManager.h"
#import "SmartRouteManager.h"
#import "LoadingViewLAB360.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_PostsGallery()<UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, SmartRouteManagerDelegate>

//Componentes
@property (nonatomic, weak) IBOutlet UITableView *tvPosts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, weak) IBOutlet UIView *viewConnection;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConnectionConstraint;
@property (nonatomic, weak) IBOutlet UIImageView *imvConnection;
@property (nonatomic, weak) IBOutlet UILabel *lblConnection;
@property (nonatomic, weak) IBOutlet UILabel *lblEmptyPostsList;
@property (nonatomic, strong) UIBarButtonItem *btnUserShopCart;
//
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorTableFooter;
@property (nonatomic, weak) IBOutlet UIToolbar *footerBar;

//Data
@property (nonatomic, strong) NSMutableArray *postsList;
@property (nonatomic, strong) UIImage *imagePlaceholderPhoto;
@property (nonatomic, strong) UIImage *imagePlaceholderVideo;
@property (nonatomic, strong) UIImage *imageLogoWaterMark;
@property (nonatomic, strong) UIBarButtonItem *messageButton;
@property (nonatomic, strong) UIBarButtonItem *notificationButton;
//
@property (nonatomic, assign) bool firstLoad;
@property (nonatomic, assign) bool isLayoutLoaded;
@property (nonatomic, assign) bool isLoadingPosts;
@property (nonatomic, assign) bool isAnimatingNoConnection;
@property (nonatomic, assign) bool isProcessingNotificationInteraction;
@property (nonatomic, assign) bool isShowingPostImageDetail;
//
@property (nonatomic, assign) bool canLike;
@property (nonatomic, assign) bool canComment;
@property (nonatomic, assign) bool canShare;
//
@property (nonatomic, strong) Post *selectedPost;
//
@property (nonatomic, strong) NSMutableArray<UIImage*>* localBannerImageList;
@property (nonatomic, strong) BannerDisplayView *fixedBannerImageView;
//
@property (nonatomic, strong) TimelineConfigurationManager *timelineConfManager;
//
@property (nonatomic, strong) SmartRouteManager *routeManager;
@property (nonatomic, strong) SmartRouteInterestPoint *currentInterestPoint;
@property (nonatomic, strong) NSArray<SmartRouteInterestPoint*> *customBannersList;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_PostsGallery
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
}

#pragma mark - • SYNTESIZES
@synthesize tvPosts, refreshControl, viewConnection, bottomConnectionConstraint, imvConnection, lblConnection, lblEmptyPostsList, btnUserShopCart, indicatorTableFooter, footerBar;
@synthesize imagePlaceholderPhoto, imagePlaceholderVideo, imageLogoWaterMark, postsList, firstLoad, isLayoutLoaded, isLoadingPosts, isAnimatingNoConnection, isProcessingNotificationInteraction, isShowingPostImageDetail;
@synthesize selectedPost, messageButton, notificationButton, canLike, canComment, canShare, localBannerImageList, fixedBannerImageView, timelineConfManager, routeManager, currentInterestPoint, customBannersList;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
	
    self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
    
    //Observers:
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserProfilePic:) name:SYSNOT_LAYOUT_PROFILE_PIC_USER_UPDATED object:nil];
    
	[self.navigationController setNavigationBarHidden:NO];
    
    //Video Cache
    if (AppD.timelineVideoCacheManager == nil){
        AppD.timelineVideoCacheManager = [TimelineVideoCacheManager newVideoCache];
    }
    
	//Video Players
    if (AppD.timelineVideoPlayerManager == nil){
        AppD.timelineVideoPlayerManager = [TimelineVideoPlayerManager new];
    }else{
        [AppD.timelineVideoPlayerManager removeAllPlayers];
    }
    
    [self registerCells];

    imagePlaceholderPhoto = [UIImage imageNamed:@"picture-placeholder.jpg"];
    imagePlaceholderVideo = [UIImage imageNamed:@"video-placeholder.jpg"];
    imageLogoWaterMark = [UIImage imageNamed:@"logo-gsmd-watermark-post"];
    
    firstLoad = true;
    isLayoutLoaded = false;
    isLoadingPosts = false;
    isAnimatingNoConnection = false;
    isShowingPostImageDetail = false;
    
    //Refresh Control
    refreshControl = [UIRefreshControl new];
    refreshControl.backgroundColor = nil;
    refreshControl.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    //
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:AppD.styleManager.colorPalette.backgroundNormal forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LABEL_POST_REFRESH_CONTROL_PULL_TO_UPDATE", @"") attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    //
    [tvPosts addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshControlUpdate) forControlEvents:UIControlEventValueChanged];
    //
    AppD.mainMenuLoaded = true;
    isProcessingNotificationInteraction = false;
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	canLike = [userDefaults boolForKey:CONFIG_KEY_FLAG_LIKE];
	canComment = [userDefaults boolForKey:CONFIG_KEY_FLAG_COMMENT];
	canShare = [userDefaults boolForKey:CONFIG_KEY_FLAG_SHARE];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    //Monitoramento de beacons (mensagens de entrada e saída).
    [AppD.beaconsManager startMonitoringRegisteredBeaconsUsingServiceType:BeaconServiceTypeMonitoring];
    
    timelineConfManager = [TimelineConfigurationManager newManagerLoadingConfiguration];
    
    routeManager = [SmartRouteManager new];
    routeManager.delegate = self;
    currentInterestPoint = nil;
    customBannersList = nil;
    
    [self configureFixedBannerDisplay];
    
    [self updateCrashlyticsConfiguration];
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
    
    [self setNeedsStatusBarAppearanceUpdate];

    [self configureTitleView];
    
    [AppD setSideMenuDelegate:self];
    [AppD callForBarButtonsItems];
	
    messageButton = [self createMessageButton];
    notificationButton = [self createNotificationButton];
    
    if (AppD.chatInteractionEnabled){
        self.navigationItem.rightBarButtonItems = @[messageButton, notificationButton];
    }else{
        self.navigationItem.rightBarButtonItem = notificationButton;
    }
	
	[self loadInitialConfigs];
    
    selectedPost = nil;
    
    if (AppD.loggedUser.profilePic == nil){
        
        if (AppD.loggedUser.urlProfilePic != nil && ![AppD.loggedUser.urlProfilePic isEqualToString:@""]){
            
            [[[AsyncImageDownloader alloc] initWithMediaURL:AppD.loggedUser.urlProfilePic successBlock:^(UIImage *image) {
                
                if (image == nil){
                    AppD.loggedUser.profilePic = nil; //[UIImage imageNamed:@"icon-user-default"];
                }else{
                    AppD.loggedUser.profilePic = image;
                    NSDictionary *temp = [AppD.loggedUser dictionaryJSON];
                    
                    [AppD registerLoginForUser:AppD.loggedUser.email data: [temp valueForKey:@"app_user"]];
                }
                
                dispatch_async(dispatch_get_main_queue(),^{
//                    self.navigationItem.leftBarButtonItem = nil;
//                    self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
                    //
                    if (postsList.count > 0){
                        [tvPosts reloadSections:[NSIndexSet indexSetWithIndex:(tvPosts.numberOfSections - 1)] withRowAnimation:UITableViewRowAnimationMiddle];
                    }
                });
                
            } failBlock:^(NSError *error) {
                NSLog(@"Erro ao buscar imagem: %@", error.domain);
            }]startDownload];
            
        }else{
            
            AppD.loggedUser.profilePic = [UIImage imageNamed:@"icon-user-default"];
        }
    }
    
    if(!AppD.styleManager.baseLayoutManager.isImageLogoLoaded || !AppD.styleManager.baseLayoutManager.isImageBackgroundLoaded || !AppD.styleManager.baseLayoutManager.isImageBannerLoaded)
    {
        [self updateBaseLayout];
    }
    
    if (AppD.openedByNotification){
        
        [self analiseAppOpenedByNotification];
    }else{
		AppD.forceTimelineUpdate = YES;
        [self getPostsFromServer];
    }
    
    //TODO: Como o app não possui chat/notificações habilitadas (nem suas respectivas telas), o badge é zerado aqui.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    [timelineConfManager loadConfiguration];
    
    //Checando a validade do token do usuário:
    [AppD checkUserAuthenticationToken];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Verificação de mensagem para o usuário:
    [self analisePendingInteraction:nil];
    
    //Verificação de banner personalizado para o usuário:
    [self analiseRouteInterestPoints];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //
    [TVC_PostCell stopCurrentVideoPlayback];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [AppD statusBarStyleForViewController:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if([segue.identifier isEqualToString:@"SegueToPostComment"])
    {
        VC_Comments *vcComments = [segue destinationViewController];
        vcComments.selectedPost = [selectedPost copyObject];
    }
    //
    if ([segue.identifier isEqualToString:@"SegueToWebBrowser"]){
        VC_WebViewCustom *destViewController = (VC_WebViewCustom*)segue.destinationViewController;
        destViewController.titleNav = ((WebItemToShow*)sender).titleMenu;
        destViewController.fileURL = ((WebItemToShow*)sender).urlString;
        destViewController.showShareButton = YES;
        destViewController.hideViewButtons = YES;
        destViewController.showAppMenu = NO;
    }
    //
    if ([segue.identifier isEqualToString:@"SegueToVideoPlayer"]){
        VC_VideoPlayer *destVC = (VC_VideoPlayer*)segue.destinationViewController;
        //
        destVC.videoData = [(VideoData*)(sender) copyObject];
        
        //Event:
        [AppD.devLogger newLogEvent:@"OpenVideoPlayer" category:@"Timeline" dicData:[NSDictionary dictionaryWithObjectsAndKeys:destVC.videoData.urlYouTube, @"url_youtube", nil]];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_LAYOUT_PROFILE_PIC_USER_UPDATED object:nil];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS
- (void)photoViewDidHide:(VIPhotoView *)photoView
{
    __block id pv = photoView;
    
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [pv removeFromSuperview];
        pv = nil;
        isShowingPostImageDetail = false;
    }];
}

#pragma mark - • ACTION METHODS

- (IBAction)actionCreatePost:(UIButton*)sender
{
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
    [self performSegueWithIdentifier:@"SegueToNewPost" sender:self];
}

- (IBAction)actionOptions:(UIButton*)sender
{
    if (sender.frame.size.height > 0){
        [ToolBox graphicHelper_ApplyRippleEffectAnimationInView:sender withColor:AppD.styleManager.colorPalette.primaryButtonNormal andRadius:0.0];
    }
    
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive])
    {
        Post *actualPost = [postsList objectAtIndex:sender.tag];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //Opção LIKE: somente aparece se não estiver em processo de 'curtir'.
        if (!actualPost.likeBlocked && canLike){
            
            UIAlertAction *action1;
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            bool canPost = [userDefaults boolForKey:CONFIG_KEY_FLAG_POST];
            long section = 1;
            if (!canPost) {
                section = 0;
            }
            
            if ([actualPost checkLikeForUser:AppD.loggedUser.userID]){
                
                action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_SHEET_OPTION_UNLIKE", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    TVC_PostCell *cell = [tvPosts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:section]];
                    UIImageView *iv = (UIImageView*)[cell viewWithTag:(sender.tag + 10000)];
                    [ToolBox graphicHelper_ApplyRotationEffectInView:iv withDuration:0.4 repeatCount:0];
                    //
                    [self unlikePost:[actualPost copyObject]];
                }];
                
            }else{
                
                action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_SHEET_OPTION_LIKE", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    TVC_PostCell *cell = [tvPosts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:section]];
                    UIImageView *iv = (UIImageView*)[cell viewWithTag:(sender.tag + 10000)];
                    [ToolBox graphicHelper_ApplyRotationEffectInView:iv withDuration:0.4 repeatCount:0];
                    //
                    [self likePost:[actualPost copyObject]];
                }];
            }
            
            [alert addAction:action1];
        }
        
        //Opção COMMENT: sempre exibe.
		if (canComment) {
			UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_SHEET_OPTION_COMMENT", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				
				self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
				self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
				//
				selectedPost = [postsList objectAtIndex:sender.tag];
				//
				[self performSegueWithIdentifier:@"SegueToPostComment" sender:self];
				
			}];
			[alert addAction:action2];
		}
		
        //Opção SHARE: compartilhar imagem:
		if (canShare) {
			UIAlertAction *action6 = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_SHEET_OPTION_SHARE", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				
				NSArray *itemsToShare;
				
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                bool canPost = [userDefaults boolForKey:CONFIG_KEY_FLAG_POST];
                long section = 1;
                if (!canPost) {
                    section = 0;
                }
                
				//TVC_PostCell *pc = [tvPosts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:section]];
				
				if (actualPost.sponsored){
                    //Se o post é patrocinado, compartilha o link:
                    itemsToShare = @[[NSString stringWithFormat:@"%@", actualPost.sponsorURL]];
				}else{
                    //Se o post não é compartilhado, compartilha o conteúdo:
                    if (actualPost.type == TimelinePostTypeVideo){
                        //Compartilha link do vídeo:
                        itemsToShare = @[[NSString stringWithFormat:@"%@", actualPost.videoURL]];
                    }else if (actualPost.type == TimelinePostTypePhoto){
                        //Compartilha a imagem, se existir:
                        if (actualPost.picture == nil){
                            itemsToShare = @[[NSString stringWithFormat:@"%@", actualPost.pictureURL]];
                        }else{
                            UIImage *image = actualPost.picture;
                            itemsToShare = @[image];
                        }
                    }else{
                        //Campartilha o texto:
                        itemsToShare = @[[NSString stringWithFormat:@"%@", actualPost.message]];
                    }
				}
				
				UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
                if (IDIOM == IPAD){
                    activityController.popoverPresentationController.sourceView = sender;
                }
				[self presentViewController:activityController animated:YES completion:^{
					NSLog(@"x");
				}];
			}];
			
			[alert addAction:action6];
		}
		
        //Opção REMOVE POST: aparece se o post for do usuário
        if (actualPost.user.userID == AppD.loggedUser.userID){
            UIAlertAction *action3 = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_SHEET_OPTION_DELETE_POST", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                SCLAlertViewPlus *alertView = [AppD createDefaultAlert];
                //
                [alertView addButton:NSLocalizedString(@"ALERT_OPTION_REMOVE", @"") withType:SCLAlertButtonType_Destructive actionBlock:^{
                    dispatch_async(dispatch_get_main_queue(),^{
                        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Updating];
                    });
                    
                    [self removePost:[actualPost copyObject]];
                }];
                //
                [alertView addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Normal actionBlock:nil];
                //
                [alertView showQuestion:self title:NSLocalizedString(@"ALERT_TITLE_POST_DELETE_CONFIRMATION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_POST_DELETE_CONFIRMATION", @"") closeButtonTitle:nil duration:0.0];

            }];
            [alert addAction:action3];
        
        }
//        else{
//            //TODO:
//            //Opção REPORT POST: talvez não tenha neste momento
//            UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"Reportar este post" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                
//                //[self reportPost:[actualPost copyObject]];
//                
//            }];
//            [alert addAction:action4];
//        }
        
        //Opção CANCEL: fecha o alerta
        UIAlertAction *action5 = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action5];
        
        if (IDIOM == IPAD){
            alert.popoverPresentationController.sourceView = sender;
        }
        
        //SHOW:
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        
        [self showConnectionView];
    }
    
//    NSLog(@"Tag: %i", sender.tag);
}

- (IBAction)actionSponsor:(UIButton*)sender
{
    Post *actualPost = [postsList objectAtIndex:sender.tag];
    
    if (actualPost.sponsored && ![actualPost.sponsorURL isEqualToString:@""]){
        WebItemToShow *webItem = [WebItemToShow new];
        webItem.urlString = [actualPost.sponsorURL stringByReplacingOccurrencesOfString:@" " withString:@""];
        webItem.titleMenu = actualPost.title;
        //
        [self performSegueWithIdentifier:@"SegueToWebBrowser" sender:webItem];
    }
}

- (IBAction)actionLike:(UIButton*)sender
{
    Post *actualPost = [postsList objectAtIndex:sender.tag];
    
    if (!actualPost.likeBlocked){
        
        ConnectionManager *connection = [[ConnectionManager alloc] init];
        
        if ([connection isConnectionActive])
        {
            actualPost.likeBlocked = true;
            //
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            bool canPost = [userDefaults boolForKey:CONFIG_KEY_FLAG_POST];
            long section = 1;
            if (!canPost) {
                section = 0;
            }
            //
            TVC_PostCell *cell = [tvPosts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:section]];
            UIImageView *iv = (UIImageView*)[cell viewWithTag:(sender.tag + 10000)];
            [ToolBox graphicHelper_ApplyRotationEffectInView:iv withDuration:0.4 repeatCount:0];
            //
            CGRect rect = [tvPosts convertRect:cell.frame toView:self.view];
            __block UIImageView *ivHeart = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x + rect.size.width/2.0 - 25, rect.origin.y + rect.size.height/2.0 - 25, 50.0, 50.0)];
            ivHeart.backgroundColor = nil;
            ivHeart.tintColor = [UIColor colorWithRed:194.0/255.0 green:62.0/255.0 blue:75.0/255.0 alpha:1.0];
            if ([actualPost checkLikeForUser:AppD.loggedUser.userID]){
                [self unlikePost:[actualPost copyObject]];
                //
                ivHeart.image = [[UIImage imageNamed:@"heart_outline"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }else{
                [self likePost:[actualPost copyObject]];
                //
                ivHeart.image = [[UIImage imageNamed:@"heart_fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            //
            [self.view addSubview:ivHeart];
            [self.view bringSubviewToFront:ivHeart];
            //
            [ToolBox graphicHelper_ApplyHeartBeatAnimationInView:ivHeart withScale:2.0];
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ivHeart removeFromSuperview];
                ivHeart = nil;
            });
        }
        else{
            [self showConnectionView];
        }
    }

}

- (IBAction)actionComment:(UIButton*)sender
{
    //[ToolBox graphicHelper_ApplyRippleEffectAnimationInView:sender withColor:AppD.styleManager.colorBackground andRadius:0.0];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
    //
    selectedPost = [postsList objectAtIndex:sender.tag];
    //
    [self performSegueWithIdentifier:@"SegueToPostComment" sender:self];
    
//    NSLog(@"Tag: %i", sender.tag);
}

- (IBAction)actionExpandLongPost:(UIButton*)sender
{
    Post *post = [postsList objectAtIndex:sender.tag];
    post.expandedView = !post.expandedView;
    //
    [tvPosts reloadData];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - SIDE MENU

- (int)sideMenu:(VC_SideMenu*)menu dynamicBadgeValueForItem:(SideMenuItem*)item
{
    if (item.itemInternalCode == SideMenuItemCode_Chat){
        int badge = 0;
        @try {
            badge = [messageButton.badgeValue intValue];
        } @catch (NSException *exception) {
            NSLog(@"dynamicBadgeValueForItem >> Exception >> %@", [exception reason]);
        }
        return badge;
    }
    
    return 0;
}

- (void)sideMenu:(VC_SideMenu*)menu barButtonsForRegisteredConfiguration:(NSArray<UIBarButtonItem*>*)items
{
    [footerBar setTintColor:AppD.styleManager.colorPalette.backgroundNormal];
    
    if (items.count > 0){
        NSArray *constraintArr = self.footerBar.constraints;
        for (NSLayoutConstraint *c in constraintArr){
            if ([c.identifier isEqualToString:@"heightConstraint"]){
                c.constant = 44.0;
                break;
            }
        }
        //
        footerBar.items = items;
    }else{
        footerBar.items = [NSArray new];
        //
        NSArray *constraintArr = self.footerBar.constraints;
        for (NSLayoutConstraint *c in constraintArr){
            if ([c.identifier isEqualToString:@"heightConstraint"]){
                c.constant = 0.0;
                break;
            }
        }
    }
    
    [self.view layoutIfNeeded];
}

#pragma mark - SmartRouteManagerDelegate

- (void)smartRouteManager:(SmartRouteManager* _Nonnull)manager didUpdateCurrentInterestPoint:(SmartRouteInterestPoint* _Nullable)interestPoint
{
    currentInterestPoint = nil;
    if (interestPoint.bannerImage != nil){
        currentInterestPoint = [interestPoint copyReducedObject];
    }
    //
    [self configureFixedBannerDisplay];
}

#pragma mark - GESTURE RECOGNIZER

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - TABLEVIEW

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    bool canPost = [userDefaults boolForKey:CONFIG_KEY_FLAG_POST];
//
//    if (!canPost) {
//        return postsList.count;
//    }
//    else{
//        if (section == 0){
//            return 0;
//        }else{
//            return postsList.count;
//        }
//    }
    
    //NOTE: ver comentário do método 'numberOfSectionsInTableView'.
    if (section == 0){
        return 0;
    }else{
        return postsList.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //*************************************************************************************
    //NOTE: ericogt (31/01/2019) >> Anteriormente era assim:
    //Quando o usuário pode postar, o banner rola com a tabela e o campo "criar post" fica fixado no header.
    //Quando ele não pode postar, o banner fica fixo e não é exibido o campo "criar post".
    //...
    //Agora é assim:
    //O banner sempre rolará com a tabela. Para isso sempre serão precisas 2 sections.
    //*************************************************************************************
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    bool canPost = [userDefaults boolForKey:CONFIG_KEY_FLAG_POST];
//
//    if (!canPost) {
//        return 1;
//    }
	
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [postsList objectAtIndex:indexPath.row];
    
    CGFloat cellHeight = 10.0 + 10.0 + 50.0 + 53.0 + 10.0; //header + footer
    
    bool hasText = (![post.message isEqualToString:@""] && post.message != nil);
    bool hasImage = (![post.pictureURL isEqualToString:@""] && post.pictureURL != nil);
    
    if (post.sponsored){
        cellHeight += 40.0;
    }else{
        cellHeight += 1.0;
    }
    
    if (hasText){
        
        NSString *postTextContent = post.message;
        
        if (TIMELINE_POSTS_EXPANDABLE_SIZE > 0){
            
            if (post.message.length > TIMELINE_POSTS_EXPANDABLE_SIZE){
                
                if (post.expandedView == NO){
                    postTextContent = [post.message substringToIndex:(TIMELINE_POSTS_EXPANDABLE_SIZE - 1)];
                    postTextContent = [NSString stringWithFormat:@"%@...\n\n", postTextContent];
                }else{
                    postTextContent = [NSString stringWithFormat:@"%@\n\n", postTextContent];
                }
            }
        }
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        CGRect textRect = [postTextContent boundingRectWithSize:CGSizeMake(self.view.frame.size.width - (28.0 * 2), CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName:font}
                                                 context:nil];

        
        if (textRect.size.height < 40.0){
            cellHeight += 60.0;
        }else {
            cellHeight += textRect.size.height + 20.0;
        }
        
    }else{
        cellHeight += 10.0;
    }
    
    if (hasImage){
        
        CGSize size = CGSizeMake(self.view.frame.size.width - 16.0, (self.view.frame.size.width - 16.0) * 0.8);
        if (size.height < 100.0){
            cellHeight += 100.0;
        }else {
            cellHeight += size.height;
        }
        
    }else{
        cellHeight += 1.0;
    }
    
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        
        //BANNER:
        if (fixedBannerImageView){
            return fixedBannerImageView.frame.size.height;
        }else{
            return 0.0;
        }
        
    }else{
        
        //POSTS:
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        bool canPost = [userDefaults boolForKey:CONFIG_KEY_FLAG_POST];
        
        if (canPost) {
            return 80.0;
        }else{
            return 0.0;
        }
    }
}

#pragma mark -

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierPost = @"CustomCellPost";
    
    TVC_PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPost forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[TVC_PostCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPost];
    }

    [cell layoutIfNeeded];
	
	Post *post = [self.postsList objectAtIndex:indexPath.row];
	[self configureCell:cell forDataObject:post andIndexPath:indexPath];
	
    return cell;
}

- (void)configureCell:(TVC_PostCell *)cell forDataObject:(id)dataObject andIndexPath:(NSIndexPath *)indexPath {

	__block Post *post = (Post *)dataObject;
	
    cell.referenceObjectID = post.postID;
    
	//header
	cell.lblHeader_UserName.text = post.user.name;
	cell.lblHeader_PostDate.text = [ToolBox dateHelper_StringFromDate:post.createdDate withFormat:TOOLBOX_DATA_BARRA_LONGA_NORMAL];
	[cell.imvHeader_UserPicture setImageWithURL:[NSURL URLWithString:post.user.pictureURL] placeholderImage:[[UIImage imageNamed:@"icon-user-default"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	cell.imvHeader_UserPicture.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
	//
	cell.btnHeader_Options.tag = indexPath.row;
	[cell.btnHeader_Options addTarget:self action:@selector(actionOptions:) forControlEvents:UIControlEventTouchDown];
	
	//text
    cell.btnPostTextViewMore.tag = indexPath.row;
    
    NSString *postTextContent = post.message;
    if (TIMELINE_POSTS_EXPANDABLE_SIZE > 0){
        if (post.message.length > TIMELINE_POSTS_EXPANDABLE_SIZE){
            //show expand button
            if (post.expandedView == NO){
                postTextContent = [post.message substringToIndex:(TIMELINE_POSTS_EXPANDABLE_SIZE - 1)];
                postTextContent = [NSString stringWithFormat:@"%@...\n\n", postTextContent];
            }else{
                postTextContent = [NSString stringWithFormat:@"%@\n\n", postTextContent];
            }
        }
    }
    cell.lblText_PostText.text = postTextContent;
    
	//photo
    cell.imvPhoto_PostImage.image = nil;
    
    UIImage *placeholder = imagePlaceholderPhoto;
    if (post.type == TimelinePostTypeVideo){
        placeholder = imagePlaceholderVideo;
    }
    
    //Layout:
    __block bool hasText = (![post.message isEqualToString:@""] && post.message != nil);
    __block bool hasImage = (![post.pictureURL isEqualToString:@""] && post.pictureURL != nil);
    __block bool hasVideo = (![post.videoURL isEqualToString:@""] && post.videoURL != nil);
    
    [cell.viewPhoto setUserInteractionEnabled:NO];
	
	cell.lblPhotoAction_Title.text = NSLocalizedString(@"LABEL_POST_SPONSOR_ACTION", @"");
	//
	cell.btnPhotoAction_Activation.tag = indexPath.row;
	[cell.btnPhotoAction_Activation addTarget:self action:@selector(actionSponsor:) forControlEvents:UIControlEventTouchDown];
	
	//footer
    cell.viewLike.hidden = !canLike;
	cell.viewLike.hidden = !canLike;
	cell.viewComments.hidden = !canComment;
	
	if (post.commentsList.count > 1){
		cell.lblFooter_TotalComments.text = [NSString stringWithFormat:@"%li %@", (unsigned long)post.commentsList.count, NSLocalizedString(@"LABEL_POST_QTD_COMMENTS_PLURAL", @"")];
	}else{
		cell.lblFooter_TotalComments.text = [NSString stringWithFormat:@"%li %@", (unsigned long)post.commentsList.count, NSLocalizedString(@"LABEL_POST_QTD_COMMENTS_SINGULAR", @"")];
	}
	
	cell.lblFooter_Like.text = [NSString stringWithFormat:@"%li", (unsigned long)post.likeList.count];
	cell.lblFooter_Comments.text = NSLocalizedString(@"LABEL_POST_BUTTON_COMMENT", @"");
	
	if ([post checkLikeForUser:AppD.loggedUser.userID]){
		if (post.likeBlocked){
			cell.imvFooter_Like.image = [[UIImage imageNamed:@"icon-heart-outline"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		}else{
			cell.imvFooter_Like.image = [[UIImage imageNamed:@"icon-heart-fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		}
	}else{
		if (post.likeBlocked){
			cell.imvFooter_Like.image = [[UIImage imageNamed:@"icon-heart-fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		}else{
			cell.imvFooter_Like.image = [[UIImage imageNamed:@"icon-heart-outline"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		}
	}
	
	cell.btnFooter_Like.tag = indexPath.row;
	[cell.btnFooter_Like addTarget:self action:@selector(actionLike:) forControlEvents:UIControlEventTouchDown];
	
	cell.btnFooter_Comments.tag = indexPath.row;
	cell.imvFooter_Like.tag = (indexPath.row + 10000);//TODO
	[cell.btnFooter_Comments addTarget:self action:@selector(actionComment:) forControlEvents:UIControlEventTouchDown];
	
    cell.videoDelegate = self;
    
    //Layout
    if (hasText){
        if (hasVideo){
            [cell updateLayoutForPostType:eTVC_PostType_TextAndVideo andSponsor:post.sponsored];
        }else{
            if (hasImage){
                [cell updateLayoutForPostType:eTVC_PostType_TextAndPhoto andSponsor:post.sponsored];
            }else{
                [cell updateLayoutForPostType:eTVC_PostType_TextOnly andSponsor:post.sponsored];
            }
        }
    }else{
        if (hasVideo){
            [cell updateLayoutForPostType:eTVC_PostType_VideoOnly andSponsor:post.sponsored];
        }else{
            if (hasImage){
                [cell updateLayoutForPostType:eTVC_PostType_PhotoOnly andSponsor:post.sponsored];
            }else{
                [cell updateLayoutForPostType:eTVC_PostType_Empty andSponsor:post.sponsored];
            } 
        }
    }
    
    //Botão ver mais:
    if (TIMELINE_POSTS_EXPANDABLE_SIZE > 0){
        if (post.message.length > TIMELINE_POSTS_EXPANDABLE_SIZE){
            //show expand button
            if (post.expandedView){
                [cell.btnPostTextViewMore setTitle:@"Ver menos..." forState:UIControlStateNormal];
            }else{
                [cell.btnPostTextViewMore setTitle:@"Ver mais..." forState:UIControlStateNormal];
            }
            [cell.btnPostTextViewMore addTarget:self action:@selector(actionExpandLongPost:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnPostTextViewMore setHidden:NO];
        }
    }
    
    //Video Control
    if (post.picture == nil){
        
        if (post.pictureURL != nil && ![post.pictureURL isEqualToString:@""]) {
            
            if ([post.pictureURL hasSuffix:@"GIF"] || [post.pictureURL hasSuffix:@"gif"]) {
                
                //Post animado (GIF)
                
                cell.imvPhoto_PostImage.image = placeholder;
                [cell.activityIndicator startAnimating];
                
                [[[AsyncImageDownloader alloc] initWithFileURL:post.pictureURL successBlock:^(NSData *data) {
                    if (data != nil){
                        post.picture = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:data];
                        cell.imvPhoto_PostImage.image = post.picture;
                    }
                    //
                    if (hasVideo && timelineConfManager.autoPlayVideos){
                        [cell playVideoWithURL:[self videoURLForPost:post] muted:timelineConfManager.startVideoMuted looping:timelineConfManager.autoPlayVideos];
                    }
                    //
                    [cell.activityIndicator stopAnimating];
                    [cell.viewPhoto setUserInteractionEnabled:YES];
                } failBlock:^(NSError *error) {
                    //
                    if (hasVideo && timelineConfManager.autoPlayVideos){
                        [cell playVideoWithURL:[self videoURLForPost:post] muted:timelineConfManager.startVideoMuted looping:timelineConfManager.autoPlayVideos];
                    }
                    //
                    [cell.activityIndicator stopAnimating];
                    [cell.viewPhoto setUserInteractionEnabled:YES];
                }] startDownload];
                
            }else{
                
                //Post normal (imagem estática)
                
                [cell.activityIndicator startAnimating];
                [cell.imvPhoto_PostImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:post.pictureURL]] placeholderImage:placeholder success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                    [cell.activityIndicator stopAnimating];
                    cell.imvPhoto_PostImage.image = image;
                    //
                    post.picture = image;
                    //
                    if (hasVideo && timelineConfManager.autoPlayVideos){
                        [cell playVideoWithURL:[self videoURLForPost:post] muted:timelineConfManager.startVideoMuted looping:timelineConfManager.autoPlayVideos];
                    }
                    //
                    [cell.viewPhoto setUserInteractionEnabled:YES];
                } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                    [cell.activityIndicator stopAnimating];
                    //
                    if (hasVideo && timelineConfManager.autoPlayVideos){
                        [cell playVideoWithURL:[self videoURLForPost:post] muted:timelineConfManager.startVideoMuted looping:timelineConfManager.autoPlayVideos];
                    }
                    //
                    [cell.viewPhoto setUserInteractionEnabled:YES];
                }];
            }
            
        }else{
            
            //Post sem imagem
            
            cell.imvPhoto_PostImage.image = placeholder;
            //
            if (hasVideo && timelineConfManager.autoPlayVideos){
                [cell playVideoWithURL:[self videoURLForPost:post] muted:timelineConfManager.startVideoMuted looping:timelineConfManager.autoPlayVideos];
            }
            //
            [cell.viewPhoto setUserInteractionEnabled:YES];
            
        }
        
    }else{
        
        //Post com content (imagem) já carregada
        
        [cell.viewPhoto setUserInteractionEnabled:YES];
        cell.imvPhoto_PostImage.image = post.picture;
        //
        if (hasVideo && timelineConfManager.autoPlayVideos){
            [cell playVideoWithURL:[self videoURLForPost:post] muted:timelineConfManager.startVideoMuted looping:timelineConfManager.autoPlayVideos];
        }
    }
    
//    if (hasVideo){
//        cell.videoDelegate = self;
//    }else{
//        cell.videoDelegate = nil;
//    }
    
    
	//Gestures:
    cell.viewPhoto.tag = indexPath.row;
	cell.imvPhoto_PostImage.tag = indexPath.row;
	
    for (UIGestureRecognizer *gr in [cell.viewPhoto gestureRecognizers]){
        [cell.viewPhoto removeGestureRecognizer:gr]; //imvPhoto_PostImage
    }
    
	//onetap
	UITapGestureRecognizer *simpleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(simpleTapInPostAction:)];
	[simpleTapGesture setNumberOfTapsRequired:1];
	[simpleTapGesture setNumberOfTouchesRequired:1];
	simpleTapGesture.delegate = self;
	[cell.viewPhoto addGestureRecognizer:simpleTapGesture];
	
	//doubleTap
	UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapInPostAction:)];
	[doubleTapGesture setNumberOfTapsRequired:2];
	[doubleTapGesture setNumberOfTouchesRequired:1];
	doubleTapGesture.delegate = self;
	[cell.viewPhoto addGestureRecognizer:doubleTapGesture];
	
	[simpleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
	
	//longPressInPostAction
	UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressInPostAction:)];
	[longPressGesture setNumberOfTouchesRequired:1];
	[longPressGesture setMinimumPressDuration:0.8];
	longPressGesture.allowableMovement = 40.0;
	longPressGesture.delaysTouchesBegan = NO;
	longPressGesture.delegate = self;
	[cell.viewPhoto addGestureRecognizer:longPressGesture];
	
	[cell setNeedsLayout];
	
	cell.contentView.userInteractionEnabled = false;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        
        if (fixedBannerImageView){
            return fixedBannerImageView;
        }else{
            
            return nil;
        }
        
    }else{
        
        //POSTS:
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        bool canPost = [userDefaults boolForKey:CONFIG_KEY_FLAG_POST];
        
        if (canPost) {
            ViewSectionPost *viewSection = [[[NSBundle mainBundle] loadNibNamed:@"ViewSectionPost" owner:self options:nil] objectAtIndex:0];
            viewSection.translatesAutoresizingMaskIntoConstraints = YES;
            viewSection.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
            [viewSection setNeedsUpdateConstraints];
            [viewSection layoutIfNeeded];
            //
            [viewSection updateLayout];
            //
            [viewSection.btnHeaderAction addTarget:self action:@selector(actionCreatePost:) forControlEvents:UIControlEventTouchUpInside];
            //
            return viewSection;
        }else{
        
            return nil;
        }
    }
}



-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[TVC_PostCell class]]){
        TVC_PostCell *postCell = (TVC_PostCell*)cell;
        [postCell stopVideo];
    }
}

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    for (NSIndexPath *indexPath in indexPaths){
        
        __block Post *post = [self.postsList objectAtIndex:indexPath.row];
        
        if (![post.videoURL isEqualToString:@""] && post.videoURL != nil){
            //Video cache para timeline:
            if (timelineConfManager.useVideoCache && ![post.videoURL hasSuffix:@"m3u8"]){
                NSString *postID = [NSString stringWithFormat:@"%li", post.postID];
                NSString *cachedVideoURL = [AppD.timelineVideoCacheManager loadVideoURLforID:postID andRemotelURL:post.videoURL];
                //
                if (cachedVideoURL == nil){
                    [AppD.timelineVideoCacheManager saveVideoWithID:postID andRemoteURL:post.videoURL withCompletionHandler:^(BOOL success, NSString *localVideoURL, NSError *error) {
                        if (error == nil && localVideoURL != nil){
                            [AppD.timelineVideoPlayerManager addPlayerForReferenceObjectID:post.postID andURL:localVideoURL];
                        }
                    }];
                }else{
                    [AppD.timelineVideoPlayerManager addPlayerForReferenceObjectID:post.postID andURL:cachedVideoURL];
                }
            }else{
                [AppD.timelineVideoPlayerManager addPlayerForReferenceObjectID:post.postID andURL:post.videoURL];
            }
        }
    }
    
}

//MARK: Scroll da Tabela
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!refreshControl.refreshing){
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:AppD.styleManager.colorPalette.backgroundNormal forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LABEL_POST_REFRESH_CONTROL_PULL_TO_UPDATE", @"") attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
}

#pragma mark - PostCellVideoDelegate

- (void)postCellVideoDelegateNeedEnterFullScreenWithIndex:(long)cellIndex
{
    Post *post = [postsList objectAtIndex:cellIndex];
    //
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    bool canPost = [userDefaults boolForKey:CONFIG_KEY_FLAG_POST];
    TVC_PostCell *cell = [tvPosts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:(canPost ? 1 : 0)]];
    //
    [self openVideoPlayerWithURL:post.videoURL timeOffset:cell.viewVideo.videoProgress];
    [cell stopVideo];
    cell.progressVideo.progress = 0.0;
    [cell.viewVideoContainer setHidden:YES];
    [cell.imvPhoto_PostImage setHidden:NO];
}

- (void)postCellVideoDelegateDidChangeVideoMutedState:(BOOL)newState withIndex:(long)cellIndex
{
    [timelineConfManager setStateToStartVideoMuted:newState];
}

#pragma mark - BannerDisplayViewDelegate

- (void)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView didChangePage:(long)currentPage
{
    //NSLog(@"BannerDisplayView >> didChangePage >> Index: %li", currentPage);
    return;
}

- (void)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView didTapPageAtIndex:(long)pageIndex
{
    if (customBannersList == nil || customBannersList.count == 0){
        //Está usando o banner default (que não processa o toque do usuário);
        return;
    }else{
        
        SmartRouteInterestPoint *currentBanner = nil;
        
        if (SMART_ROUTE_GEOFENCE_MODE){
            currentBanner = currentInterestPoint;
        }else{
            currentBanner = [customBannersList objectAtIndex:pageIndex];
        }
        
        //Verificação de link (site) ou telefonema
        if ([ToolBox textHelper_CheckRelevantContentInString:currentBanner.link]){
            WebItemToShow *webItem = [WebItemToShow new];
            webItem.urlString = currentBanner.link;
            webItem.titleMenu = currentBanner.name;
            //
            [self performSegueWithIdentifier:@"SegueToWebBrowser" sender:webItem];
        }else if ([ToolBox textHelper_CheckRelevantContentInString:currentBanner.phoneNumber]){
            BOOL canCallNumber = NO;
            __block NSURL *phoneURL = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:currentInterestPoint.phoneNumber]];
            if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
                canCallNumber = YES;
            }else{
                phoneURL = [NSURL URLWithString:[@"tel://" stringByAppendingString:currentInterestPoint.phoneNumber]];
                if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
                    canCallNumber = YES;
                }
            }
            
            if (canCallNumber){
                NSString *m = [NSString stringWithFormat:@"%@\n\nDeseja ligar para o número %@?", currentInterestPoint.message, currentInterestPoint.phoneNumber];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Atenção!" message:m preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *actionCall = [UIAlertAction actionWithTitle:@"Ligar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [UIApplication.sharedApplication openURL:phoneURL];
                }];
                UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:actionCall];
                [alert addAction:actionCancel];
                //
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    
//    NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
//    if ([appID isEqualToString:@"1000012"] || [appID isEqualToString:@"12"]){
//
//        //Open fixed links:
//        WebItemToShow *webItem = [WebItemToShow new];
//        switch (pageIndex) {
//            case 0:{
//                webItem.urlString = @"http://lab360.com.br/";
//                webItem.titleMenu = @"LAB360";
//            }break;
//            //
//            case 1:{
//                webItem.urlString = @"http://atlanticsolutions.com.br/Adalive/index.html";
//                webItem.titleMenu = @"AdAlive";
//            }break;
//            //
//            case 2:{
//                webItem.urlString = @"http://atlanticsolutions.com.br/";
//                webItem.titleMenu = @"Atlantic Solutions";
//            }break;
//            //
//            case 3:{
//                webItem.urlString = @"http://atlanticsolutions.com.br/Horus/index.html";
//                webItem.titleMenu = @"Horus";
//            }break;
//            //
//            default:{
//                webItem.urlString = @"https://www.google.com.br/";
//                webItem.titleMenu = @"Google";
//            }break;
//        }
//        //
//        [self performSegueWithIdentifier:@"SegueToWebBrowser" sender:webItem];
//
//    }else{
//
//        //NSLog(@"BannerDisplayView >> didTapPageAtIndex >> Index: %li", pageIndex);
//        return;
//    }
}

- (void)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView didTouchInShareAtIndex:(long)pageIndex
{
    //NSLog(@"BannerDisplayView >> didTouchInShareAtIndex >> Index: %li", pageIndex);
    return;
}

- (BOOL)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView showShareButtonAtIndex:(long)pageIndex
{
    //TODO: no futuro pode ter compartilhamento de link
    //NSLog(@"BannerDisplayView >> showShareButtonAtIndex >> Index: %li", pageIndex);
    return NO;
}

- (UIColor*)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView backgroundColorForItemAtIndex:(long)pageIndex
{
    //NSLog(@"BannerDisplayView >> backgroundColorForItemAtIndex >> Index: %li", pageIndex);
    return [UIColor clearColor];
}

- (UIImage*)bannerDisplayViewDelegate:(BannerDisplayView*)bannerDisplayView imageForItemAtIndex:(long)pageIndex
{
    if (customBannersList == nil || customBannersList.count == 0){
        //Está usando o banner default (que não processa o toque do usuário);
        return AppD.styleManager.baseLayoutManager.imageBanner;
    }else{
        SmartRouteInterestPoint *currentBanner = nil;
        if (SMART_ROUTE_GEOFENCE_MODE){
            currentBanner = currentInterestPoint;
        }else{
            currentBanner = [customBannersList objectAtIndex:pageIndex];
        }
        return currentBanner.bannerImage;
    }
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    if (firstLoad){
        
        //Self
        self.view.backgroundColor = [UIColor whiteColor];
        
        //Navigation Controller
		[self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];

        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
		self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
        
        //self.navigationController.toolbar.translucent = YES;
        //self.navigationController.toolbar.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
        
        tvPosts.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.15];
        
        lblEmptyPostsList.text = NSLocalizedString(@"LABEL_POST_NO_ITEMS_AVAILABLES", @"");
        lblEmptyPostsList.textColor = [UIColor grayColor];
        lblEmptyPostsList.backgroundColor = nil;
        lblEmptyPostsList.numberOfLines = 0;
        lblEmptyPostsList.textAlignment = NSTextAlignmentCenter;
        lblEmptyPostsList.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:17];
        lblEmptyPostsList.alpha = 0.0;
        
        viewConnection.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];;
        imvConnection.image = [[UIImage imageNamed:@"icon-no-connection"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imvConnection.tintColor = [UIColor whiteColor];
        lblConnection.backgroundColor = nil;
        lblConnection.textColor = [UIColor whiteColor];
        lblConnection.text = NSLocalizedString(@"LABEL_POST_NO_CONNECTION", @"");
        
        indicatorTableFooter.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
		indicatorTableFooter.color = AppD.styleManager.colorPalette.backgroundNormal;
        [indicatorTableFooter stopAnimating];
        
        CGFloat bottomPading = 0.0;
        if (@available(iOS 11.0, *)) {
            bottomPading = AppD.window.safeAreaInsets.bottom;
        }
        
        bottomConnectionConstraint.constant = -(viewConnection.frame.size.height);
        
        [footerBar setBarTintColor:AppD.styleManager.colorPalette.backgroundNormal];
        NSArray *constraintArr = self.footerBar.constraints;
        for (NSLayoutConstraint *c in constraintArr){
            if ([c.identifier isEqualToString:@"heightConstraint"]){
                c.constant = 0.0;
                break;
            }
        }
        
        [self.view layoutIfNeeded];
        
        //viewConnection.frame = CGRectMake(0.0, self.view.frame.size.height + bottomPading, viewConnection.frame.size.width, viewConnection.frame.size.height);
    }
}

-(void)registerCells{
    
    UINib *nib = [UINib nibWithNibName:@"TVC_PostCell" bundle:nil];
    [tvPosts registerNib:nib forCellReuseIdentifier:@"CustomCellPost"];
}

- (UIImage*)applyWaterMarkForImage:(UIImage*)baseImage
{
    CGFloat posW = (baseImage.size.width / 5);
    CGFloat posH = (baseImage.size.height / 5);
    UIImage *resI = [ToolBox graphicHelper_ResizeImage:imageLogoWaterMark forCGRectSize:CGSizeMake(posW/2, posH/2)];
    
    return [ToolBox graphicHelper_MergeImage:baseImage withImage:resI position:CGPointMake((baseImage.size.width - resI.size.width) - (resI.size.height / 2), (baseImage.size.height - resI.size.height) - (resI.size.height / 2)) blendMode:kCGBlendModeNormal alpha:1.0 scale:1.0];
}

#pragma mark - Server Calls

- (void)getPostsFromServer
{
    if (AppD.forceTimelineUpdate){
        if (firstLoad){
            dispatch_async(dispatch_get_main_queue(),^{
                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Updating];
            });
			
			[self getPostsWithLimit:20];
        }
		else{
			Post *post = [self.postsList firstObject];
			[self getPostsWithID:post.postID andType:@"up"];
		}
    }
}

-(void)refreshControlUpdate
{
    [self getPostsWithLimit:20];
    
	//Post *post = [self.postsList firstObject];
	//[self getPostsWithID:post.postID andType:@"up"];
}

-(void)loadMorePosts{
	
	Post *post = [self.postsList lastObject];
	[self getPostsWithID:post.postID andType:@"down"];
}

- (void)getPostsWithID:(long)postID andType:(NSString *)typeOrder
{
	if (!isLoadingPosts){
		
		ConnectionManager *connection = [[ConnectionManager alloc] init];
		
		if ([connection isConnectionActive])
		{
			NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:AppD.styleManager.colorPalette.backgroundNormal forKey:NSForegroundColorAttributeName];
			NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LABEL_POST_REFRESH_CONTROL_UPDATING", @"") attributes:attrsDictionary];
			self.refreshControl.attributedTitle = attributedTitle;
			
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
			
			isLoadingPosts = true;
			
			[connection getPostsFromMasterEventID:AppD.masterEventID postID:postID andType:typeOrder withCompletionHandler:^(NSArray *response, NSError *error) {
				
				[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
				[AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
				//
				isLoadingPosts = false;
				[refreshControl endRefreshing];
				
				if (error){
					
					NSLog(@"%@", error.description);
					
				}else{
					if(response){
						if (!postsList) {
							postsList = nil;
							postsList = [NSMutableArray new];
						}
						
						if ([typeOrder isEqualToString:@"up"]){
							
							long total = [response count]-1;
							for (long i = total; i >=0; i--) {
								NSDictionary *dic = [response objectAtIndex:i];
								Post *post = [Post createObjectFromDictionary:dic];
								//Controle sponsor:
								[self updateSponsorControl:post];
								//MasterEventID não vem no objeto:
								post.masterEventID = AppD.masterEventID;
                                //Controle de auto expansão:
                                post.expandedView = timelineConfManager.autoExpandLongPosts;
                                
								Post *lastPost = [postsList firstObject];
								if (lastPost.postID != post.postID) {
									[postsList insertObject:post atIndex:0];
									[self reloadScreen];
								}
							}
						}
						else{
							for (NSDictionary *dic in response){
								Post *post = [Post createObjectFromDictionary:dic];
								//Controle sponsor:
								[self updateSponsorControl:post];
								//MasterEventID não vem no objeto:
								post.masterEventID = AppD.masterEventID;
								
								Post *firstPost = [postsList lastObject];
								if (firstPost.postID != post.postID) {
									
									[postsList addObject:post];
									[self reloadScreen];
								}
							}
						}
						
						if (postsList.count == 0){
							lblEmptyPostsList.alpha = 1.0;
						}else{
							lblEmptyPostsList.alpha = 0.0;
						}
						
						AppD.forceTimelineUpdate = false;
						
						if (firstLoad){
							//Observer:
							[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analisePendingInteraction:) name:SYSNOT_PUSH_NOTIFICATION_INTERACTIVE object:nil];
							//
							firstLoad = false;
						}
					}
				}
			}];
			
		}else{
			
			[AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
			//
			[refreshControl endRefreshing];
			//
			NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:AppD.styleManager.colorPalette.backgroundNormal forKey:NSForegroundColorAttributeName];
			NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LABEL_POST_REFRESH_CONTROL_PULL_TO_UPDATE", @"") attributes:attrsDictionary];
			self.refreshControl.attributedTitle = attributedTitle;
			//
			[self showConnectionView];
		}
	}
}

- (void)getPostsWithLimit:(long)limit
{
    if (!isLoadingPosts){
		
        ConnectionManager *connection = [[ConnectionManager alloc] init];
		
        if ([connection isConnectionActive])
        {
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:AppD.styleManager.colorPalette.backgroundNormal forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LABEL_POST_REFRESH_CONTROL_UPDATING", @"") attributes:attrsDictionary];
            self.refreshControl.attributedTitle = attributedTitle;
			
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
			
            isLoadingPosts = true;
			
            [connection getPostsWithLimit:limit fromMasterEventID:AppD.masterEventID withCompletionHandler:^(NSArray *response, NSError *error) {
				
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                //
                isLoadingPosts = false;
                [refreshControl endRefreshing];
                
                if (error){
                    
                    NSLog(@"%@", error.description);
                    
                }else{
                    if(response){
                        
                        postsList = nil;
                        postsList = [NSMutableArray new];
                        //
                        for (NSDictionary *dic in response){
                            Post *post = [Post createObjectFromDictionary:dic];
                            //Controle sponsor:
                            [self updateSponsorControl:post];
                            //MasterEventID não vem no objeto:
                            post.masterEventID = AppD.masterEventID;
                            //Controle de auto expansão:
                            post.expandedView = timelineConfManager.autoExpandLongPosts;
                            //
                            [postsList addObject:post];
                        }
                        
                        if (postsList.count == 0){
                            lblEmptyPostsList.alpha = 1.0;
                        }else{
                            lblEmptyPostsList.alpha = 0.0;
                        }
                        
                        [self reloadScreen];
                        
                        AppD.forceTimelineUpdate = false;
                        
                        if (firstLoad){
                            //Observer:
                            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analisePendingInteraction:) name:SYSNOT_PUSH_NOTIFICATION_INTERACTIVE object:nil];
                            //
                            firstLoad = false;
                        }
                    }
                }
            }];
        
        }else{
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            //
            [refreshControl endRefreshing];
            //
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:AppD.styleManager.colorPalette.backgroundNormal forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LABEL_POST_REFRESH_CONTROL_PULL_TO_UPDATE", @"") attributes:attrsDictionary];
            self.refreshControl.attributedTitle = attributedTitle;
            //
            [self showConnectionView];
        }
    }
}


- (void)unlikePost:(Post*)postToLike
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [connection postRemoveLikeForPost:postToLike.postID user:AppD.loggedUser.userID withCompletionHandler:^(NSDictionary *response, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        
        if (error){
            
            NSLog(@"%@", error.description);
            
            //Volta o post para o status de não curtido.
            for (Post *p in postsList){
                if (p.postID == postToLike.postID){
                    p.likeBlocked = false;
                    //
                    [self reloadScreen];
                    //
                    break;
                }
            }
            
            NSLog(@"Erro ao descurtir post %li", postToLike.postID);
            
        }else{
            
            if (response){
                
                if ([[response allKeys] containsObject:@"errors"]){
                    
                    //Volta o post para o status de não curtido.
                    for (Post *p in postsList){
                        if (p.postID == postToLike.postID){
                            p.likeBlocked = false;
                            //
                            [self reloadScreen];
                            //
                            break;
                        }
                    }
                    
                    NSLog(@"Erro ao descurtir post %li", postToLike.postID);
                    
                }else{
                    
                    Post *updatedPost = [Post createObjectFromDictionary:response];
                    [self updateSponsorControl:updatedPost];
                    updatedPost.masterEventID = AppD.masterEventID;
                    
                    for (int i=0; i<postsList.count; i++){
                        
                        Post *iPost = [postsList objectAtIndex:i];
                        
                        if (iPost.postID == updatedPost.postID){
                            updatedPost.masterEventID = AppD.masterEventID;
                            [postsList replaceObjectAtIndex:i withObject:updatedPost];
                            //
                            [self reloadScreen];
                            //
                            break;
                        }
                    }
                    
                    NSLog(@"Sucesso ao descurtir post %li", postToLike.postID);
                }
                
            }else{
                
                //Volta o post para o status de não curtido.
                for (Post *p in postsList){
                    if (p.postID == postToLike.postID){
                        p.likeBlocked = false;
                        //
                        [self reloadScreen];
                        //
                        break;
                    }
                }
                
                NSLog(@"Erro ao descurtir post %li", postToLike.postID);
            }
        }
        
    }];
}

- (void)likePost:(Post*)postToLike
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [connection postAddLikeForPost:postToLike.postID user:AppD.loggedUser.userID withCompletionHandler:^(NSDictionary *response, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        
        if (error){
            
            NSLog(@"%@", error.description);
            
            //Volta o post para o status de não curtido.
            for (Post *p in postsList){
                if (p.postID == postToLike.postID){
                    p.likeBlocked = false;
                    //
                    [self reloadScreen];
                    //
                    break;
                }
            }
            NSLog(@"Erro ao curtir post %li", postToLike.postID);
            
        }else{
            
            if (response){
                
                if ([[response allKeys] containsObject:@"errors"]){
                    
                    //Volta o post para o status de não curtido.
                    for (Post *p in postsList){
                        if (p.postID == postToLike.postID){
                            p.likeBlocked = false;
                            //
                            [self reloadScreen];
                            //
                            break;
                        }
                    }
                    NSLog(@"Erro ao curtir post %li", postToLike.postID);
                    
                }else{
                    
                    Post *updatedPost = [Post createObjectFromDictionary:response];
                    [self updateSponsorControl:updatedPost];
                    updatedPost.masterEventID = AppD.masterEventID;
                    
                    for (int i=0; i<postsList.count; i++){
                        
                        Post *iPost = [postsList objectAtIndex:i];
                        
                        if (iPost.postID == updatedPost.postID){
                            [postsList replaceObjectAtIndex:i withObject:updatedPost];
                            //
                            [self reloadScreen];
                            //
                            break;
                        }
                    }
                    NSLog(@"Sucesso ao curtir post %li", postToLike.postID);
                }

            }else{
                
                //Volta o post para o status de não curtido.
                for (Post *p in postsList){
                    if (p.postID == postToLike.postID){
                        p.likeBlocked = false;
                        //
                        [self reloadScreen];
                        //
                        break;
                    }
                }
                NSLog(@"Erro ao curtir post %li", postToLike.postID);
            }
        }

    }];
}

- (void)removePost:(Post*)postToRemove
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [connection postRemovePostWithParameters:[postToRemove dictionaryJSON] withCompletionHandler:^(NSDictionary *response, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        
        if (error){
            
            NSLog(@"%@", error.description);
        
            NSLog(@"Erro ao excluir post %li", postToRemove.postID);
            
        }else{
            
            if (response){
                
                if ([[response allKeys] containsObject:@"errors"]){
                    
                    NSLog(@"Erro ao excluir post %li", postToRemove.postID);
                    
                }else{
                    
                    int indexToRemove = -1;
                    
                    for (int i=0; i<postsList.count; i++){
                        
                        Post *iPost = [postsList objectAtIndex:i];
                        
                        if (iPost.postID == postToRemove.postID){
                            indexToRemove = i;
                            //
                            break;
                        }
                    }
                    
                    if (indexToRemove > -1){
                        [postsList removeObjectAtIndex:indexToRemove];
                        //
                        [self reloadScreen];
                    }
                    
                    NSLog(@"Sucesso ao excluir post %li", postToRemove.postID);
                }
                
            }else{
                
                NSLog(@"Erro ao curtir post %li", postToRemove.postID);
            }
        }
        
    }];
}

- (void)loadInitialConfigs
{
	ConnectionManager *connection = [[ConnectionManager alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[connection getInitialConfigurationsWithUserID:AppD.loggedUser.userID withCompletionHandler:^(NSDictionary *response, NSError *error) {
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
		
		if (error){
			messageButton.badgeValue = @"0";
			notificationButton.badgeValue = @"0";
		}else{
			
			if (response){
				NSDictionary *dicData = [response objectForKey:@"data_in_app"];
				NSInteger notificationValue = [[dicData objectForKey:@"notification_not_read"] integerValue];
				NSInteger chatValue = [[dicData objectForKey:@"chat_not_read"] integerValue];
				
				messageButton.badgeValue = [NSString stringWithFormat:@"%ld", (long)chatValue];
				notificationButton.badgeValue = [NSString stringWithFormat:@"%ld", (long)notificationValue];
		
			}else{
				messageButton.badgeValue = @"0";
				notificationButton.badgeValue = @"0";
			}
		}
	}];
}

#pragma mark - Layout

- (void)updateBaseLayout
{
    if (!isLayoutLoaded){
		
        ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
		
        NSLog(@"%i", AppD.loggedUser.userID);
		
        if ([connectionManager isConnectionActive])
        {
			NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
            [connectionManager getLayoutDefinitions:[appID intValue] masterEventId:AppD.masterEventID WithCompletionHandler:^(NSDictionary *response, NSError *error) {
				
                if (!error && response){
					
                    NSArray *keysList = [response allKeys];
                    
                    if ([keysList containsObject:@"app"]){
                        
                        NSDictionary *appDic = [[NSDictionary alloc] initWithDictionary:[response valueForKey:@"app"]];
                        
                        NSString *backStr = [appDic valueForKey:@"background_image"];
                        NSString *logoStr = [appDic valueForKey:@"logo"];
                        NSString *bannerStr = [appDic valueForKey:@"head_image"];
                        
                        if (backStr != nil && ![backStr isEqualToString:@""]){
                            AppD.styleManager.baseLayoutManager.urlBackground = backStr;
                        }
                        
                        if (logoStr != nil && ![logoStr isEqualToString:@""]){
                            AppD.styleManager.baseLayoutManager.urlLogo = logoStr;
                        }
                        
                        if (bannerStr != nil && ![bannerStr isEqualToString:@""]){
                            AppD.styleManager.baseLayoutManager.urlBanner = bannerStr;
                        }
                        
                        isLayoutLoaded = true;
                        
                        //Remove Previus Observer
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BACKGROUND object:nil];
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_LOGO object:nil];
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BANNER object:nil];
                        //Add Observer
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageBackground:) name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BACKGROUND object:nil];
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageLogo:) name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_LOGO object:nil];
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageBanner:) name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BANNER object:nil];
                        //
						[AppD.styleManager.baseLayoutManager updateImagesFromURLs:false];
                    }
                }
            }];
        }
    }
}

- (void)updateImageBackground:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BACKGROUND object:nil];
    //
    [AppD.styleManager.baseLayoutManager saveConfiguration];
}

- (void)updateImageLogo:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_LOGO object:nil];
    //
    [AppD.styleManager.baseLayoutManager saveConfiguration];
}

- (void)updateImageBanner:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BANNER object:nil];
    //
    [AppD.styleManager.baseLayoutManager saveConfiguration];
	[self reloadScreen];
}

- (void)showConnectionView
{
    if (!isAnimatingNoConnection){
        isAnimatingNoConnection = true;
        
        CGFloat bottomPading = 0.0;
        if (@available(iOS 11.0, *)) {
            bottomPading = AppD.window.safeAreaInsets.bottom;
        }
        
//        viewConnection.frame = CGRectMake(0.0, self.view.frame.size.height + bottomPading, viewConnection.frame.size.width, viewConnection.frame.size.height);
//        //
//        [UIView animateWithDuration:0.5 animations:^{
//            viewConnection.frame = CGRectMake(0.0, (self.view.frame.size.height + bottomPading) - (viewConnection.frame.size.height + bottomPading), viewConnection.frame.size.width, viewConnection.frame.size.height);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                viewConnection.frame = CGRectMake(0.0, self.view.frame.size.height + bottomPading, viewConnection.frame.size.width, viewConnection.frame.size.height);
//            } completion:^(BOOL finished) {
//                isAnimatingNoConnection = false;
//            }];
//        }];
        
        //bottomConnectionConstraint.constant = -(viewConnection.frame.size.height);
        bottomConnectionConstraint.constant = bottomPading;
        
        //viewConnection.frame = CGRectMake(0.0, self.view.frame.size.height + bottomPading, viewConnection.frame.size.width, viewConnection.frame.size.height);
        //
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            bottomConnectionConstraint.constant = -(viewConnection.frame.size.height);
            [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                isAnimatingNoConnection = false;
            }];
        }];
        
        
        
    }
}

- (void)refreshUserProfilePic:(NSNotification*)notification
{
    self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
//    CGFloat actualPosition = scrollView_.contentOffset.y;
//    CGFloat contentHeight = scrollView_.contentSize.height - scrollView_.frame.size.height - 50;
//    if (actualPosition >= contentHeight) {
//        [self loadMorePosts];
//        isLoadingPosts = YES;
//    }
    
    CGFloat maxHeight = MAX(scrollView_.contentSize.height + 57.0, scrollView_.frame.size.height + 57.0);
    
    if ((scrollView_.contentOffset.y + scrollView_.frame.size.height) >= (maxHeight) && postsList.count > 0) //(scrollView_.contentSize.height + 57.0)
    {
        [indicatorTableFooter startAnimating];
        //
        [self loadMorePosts];
        isLoadingPosts = YES;
    }else{
        [indicatorTableFooter stopAnimating];
    }
}

- (void)configureTitleView
{
    NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
    if ([appID isEqualToString:@"1000012"] || [appID isEqualToString:@"12"]){

        LoadingViewLAB360 *configuredLoadingView = [self.navigationItem.titleView viewWithTag:969];
        
        if (configuredLoadingView){
            [configuredLoadingView startAnimating];
        }else{
            
            //APP LAB360:
            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0 / 2.0, 40.0)];
            containerView.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
            [containerView.widthAnchor constraintEqualToConstant:120.0].active = YES;
            [containerView.heightAnchor constraintEqualToConstant:40.0].active = YES;
            containerView.layer.cornerRadius = 4.0;
            [containerView setClipsToBounds:YES];
            //
            LoadingViewLAB360 *loading = [LoadingViewLAB360 newLoadingViewWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0) primaryColor:AppD.styleManager.colorPalette.textNormal andSecondaryColor:nil];
            loading.logoPrimaryColor = [UIColor colorWithRed:166.0/255.0 green:201.0/255.0 blue:67.0/255.0 alpha:1.0];
            loading.logoSecondaryColor = AppD.styleManager.colorPalette.textNormal;
            loading.tag = 969;
            [containerView addSubview:loading];
            //
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(42.0, 0.0, 120.0 - 42.0, 40.0)];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setAdjustsFontSizeToFitWidth:YES];
            [label setMinimumScaleFactor:0.25];
            [label setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]];
            [label setTextColor:AppD.styleManager.colorPalette.textNormal];
            [label setText:AppD.appName];
            [containerView addSubview:label];
            //
            self.navigationItem.titleView = containerView;
            //
            [loading startAnimating];
            
        }
        
    }else{
        
        //Qualquer outro app:
        self.navigationItem.title = AppD.appName;
    }
}

#pragma mark - Controle Notificação

- (void)analiseAppOpenedByNotification
{
    if (AppD.loggedUser.userID != 0){
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [ud valueForKey:PLISTKEY_PUSH_NOTIFICATION_DICTIONARY_DATA];
        
        NSDictionary *dicNotification = dic ? [dic valueForKey:@"aps"] : nil;
        
        if (dicNotification){
            
            NSString *category = [dicNotification valueForKey:@"category"];
            
            //Só é preciso tratar push notifications da categoria 'MESSAGE'
            if ([category isEqualToString:PUSHNOT_CATEGORY_MESSAGE] && AppD.chatInteractionEnabled){
                
                //==============================================================================================
                //Readaptando a lista de controllers para que o voltar seja para a tela de grupos:
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]];
                VC_ContactsChat *vcContactChat = [storyboard instantiateViewControllerWithIdentifier:@"VC_ContactsChat"];
                [vcContactChat awakeFromNib];
                //
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
                //
                [self.navigationController pushViewController:vcContactChat animated:NO];
                
                //==============================================================================================
                //Tela de chat:
                ChatMessage *newMessage = [AppD chatMessageFromDictionary:dic];
                
                //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]];
                VC_Chat *vcChat = [storyboard instantiateViewControllerWithIdentifier:@"VC_Chat"];
                [vcChat awakeFromNib];
                
                if (newMessage.messageType == eChatMessageType_Single){
                    
                    vcChat.chatType = eChatScreenType_Single;
                    //
                    User *oUser = [User new];
                    oUser.userID = newMessage.userID;
                    oUser.name = newMessage.userName;
                    vcChat.outerUser = oUser;
                    //Group = null
                    vcChat.receiverGroup = nil;
                    
                }else if(newMessage.messageType == eChatMessageType_Group){
                    
                    vcChat.chatType = eChatScreenType_Group;
                    //
                    GroupChat *gChat = [GroupChat new];
                    gChat.groupId = newMessage.outerGroupID;
                    gChat.groupName = newMessage.chatName;
                    vcChat.receiverGroup = gChat;
                    //User = null
                    vcChat.outerUser = nil;
                }
                
                UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
                topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
                
                [ud setValue:nil forKey:PLISTKEY_PUSH_NOTIFICATION_DICTIONARY_DATA];
                AppD.openedByNotification = false;
                
                [self.navigationController pushViewController:vcChat animated:NO];
            
            }
			else if ([category isEqualToString:PUSHNOT_CATEGORY_SECTOR]){
			
				//Busca pelo "targetName" (que se chama 'info' na notificação) para poder abrir a tela de pesquisa:
			   if (![[dic valueForKey:@"info"] isKindOfClass:[NSNull class]]){
				   NSString *targetName = [dic valueForKey:@"info"];
				   if (targetName != nil && ![targetName isEqualToString:@""]){
					   
					   //Abrindo a tela de 'pesquisa':
					   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
					   ProductViewController *productController = (ProductViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProductViewController"];
					   productController.dicProductData = nil;
					   productController.showBackButton = YES;
					   productController.targetName = targetName;
					   productController.executeAutoLaunch = YES;
					   
					   [productController awakeFromNib];
					   //
					   UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
					   topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
					   topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
					   
					   [ud setValue:nil forKey:PLISTKEY_PUSH_NOTIFICATION_DICTIONARY_DATA];
					   AppD.openedByNotification = false;
					   
					   //Abrindo a tela
					   [AppD.rootViewController.navigationController pushViewController:productController animated:YES];
					   
//					   //Readaptando a lista de controllers:
//					   NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
//					   NSMutableArray *listaF = [NSMutableArray new];
//					   [listaF addObject:[listaC objectAtIndex:0]];
//					   [listaF addObject:[listaC objectAtIndex:1]];
//					   [listaF addObject:productController];
//					   
//					   //Carregando dados
//					   AppD.rootViewController.navigationController.viewControllers = listaF;
			   
				   }
			   }
				
			}else{
                [ud setValue:nil forKey:PLISTKEY_PUSH_NOTIFICATION_DICTIONARY_DATA];
                AppD.openedByNotification = false;
            }
        }
    }
}

- (void)analisePendingInteraction:(NSNotification*)notification
{
    //Este método apenas executa uma verificação por vez, para que o usuário não fique sobrecarregado de interações:
    if (!isProcessingNotificationInteraction){
              
        if (AppD.notificationInteraction){
            
            isProcessingNotificationInteraction = true;
            
            if (AppD.notificationInteraction.isFeedback){
                
                //Avisa o servidor sobre a ação do usuário:
                [self sendInteractionToServer];
            }else{
                
                //Mostra a notificação em forma de alerta para o usuário:
                
                if ([AppD.notificationInteraction.category isEqualToString:@"INTERACTIVE"]){
                    
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    //
                    [alert addButton:NSLocalizedString(@"PUSH_NOTIFICATION_OPTION_INTERACTIVE_YES", "") withType:SCLAlertButtonType_Question actionBlock:^{
                        
                        //Avisa o servidor sobre a ação do usuário:
                        [self sendInteractionToServer];
                    }];
                    //
                    [alert addButton:NSLocalizedString(@"PUSH_NOTIFICATION_OPTION_INTERACTIVE_NO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
                        
                        isProcessingNotificationInteraction = false;
                        NSLog(@"PUSH_NOTIFICATION > INTERACTIVE > OPTION_NO");
                    }];
                    //
                    [alert showQuestion:AppD.notificationInteraction.title subTitle:AppD.notificationInteraction.userMessage closeButtonTitle:nil duration:0.0];
                    
                }else{
                    isProcessingNotificationInteraction = false;
                }
            }
        }
    }
}

- (void)sendInteractionToServer
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    [connection pushNotificationInteractionFeedbackFor:AppD.notificationInteraction.notificationID user:AppD.loggedUser.userID action:AppD.notificationInteraction.action withCompletionHandler:^(NSDictionary *response, NSError *error) {
        
        isProcessingNotificationInteraction = false;
        AppD.notificationInteraction = nil;
        
        if (error){
            
            NSLog(@"Erro ao enviar feedback de notificação ao servidor: %@", error.description);
            
        }else{
            
            if (response){
                if ([[response allKeys] containsObject:@"message"]){
                    
                    NSString *message = [response valueForKey:@"message"]; //ALERT_MESSAGE_NOTIFICATION_INTERACTIVE_FEEDBACK
                    
                    if (message != nil && ![message isEqualToString:@""]){
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showSuccess:NSLocalizedString(@"ALERT_TITLE_NOTIFICATION_INTERACTIVE_FEEDBACK", @"") subTitle:message closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", "") duration:0.0];
                    }
                    //else: ignora no momento
                }
            }
        }
    }];
}

- (void)analiseRouteInterestPoints
{
    if (routeManager.lastUpdate == nil){
        //Primeira chamada:
        [routeManager updateBannersFromServerWithCompletionHandler:^(DataSourceResponse * _Nonnull response) {
            if (response.status == DataSourceResponseStatusSuccess){
                if (SMART_ROUTE_GEOFENCE_MODE){
                    [routeManager startUpdatingUserLocation];
                }else{
                    [self downloadImagesForBanners:[routeManager getBannersList]];
                }
            }
        }];
    }else{
        NSTimeInterval passedTime = [[NSDate date] timeIntervalSinceDate:routeManager.lastUpdate];
        if (passedTime > 600){
            [routeManager updateBannersFromServerWithCompletionHandler:^(DataSourceResponse * _Nonnull response) {
                if (response.status == DataSourceResponseStatusSuccess){
                    if (SMART_ROUTE_GEOFENCE_MODE){
                        [routeManager startUpdatingUserLocation];
                    }else{
                        [self downloadImagesForBanners:[routeManager getBannersList]];
                    }
                }
            }];
        }
    }
}

- (void)downloadImagesForBanners:(NSArray<SmartRouteInterestPoint*>*)bList
{
    //Aqui as imagens são baixadas:
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    for (SmartRouteInterestPoint *banner in bList){
        //Download da imagem do banner:
        dispatch_group_enter(serviceGroup);
        [[[AsyncImageDownloader alloc] initWithFileURL:banner.bannerURL successBlock:^(NSData *data) {
            if (data != nil){
                banner.bannerImage = [UIImage imageWithData:data];
            }
            dispatch_group_leave(serviceGroup);
        } failBlock:^(NSError *error) {
            NSLog(@"downloadImagesForBanners >> Error >> %@", [error localizedDescription]);
            dispatch_group_leave(serviceGroup);
        }] startDownload];
    }

    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        // Bloco a ser executado no final dos downloads:
        customBannersList = bList;
        [self configureFixedBannerDisplay];
    });
}

#pragma mark - Gesture Actions

- (void)simpleTapInPostAction:(UITapGestureRecognizer*)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    bool canPost = [userDefaults boolForKey:CONFIG_KEY_FLAG_POST];
    TVC_PostCell *cell = [tvPosts cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.view.tag inSection:(canPost ? 1 : 0)]];
    UIImageView *iv = cell.imvPhoto_PostImage;
    //
    Post *post = [postsList objectAtIndex:sender.view.tag];
    //
    if (post.type == TimelinePostTypeVideo){

        //Verificando o tipo de URL:
        if ([[post.videoURL lowercaseString] rangeOfString:@"youtube.com"].location == NSNotFound){

            //Não é video do youtube:

            //Verificar se está usando auto-play
            //Se estiver, faz o código abaixo
            if (cell.viewVideo.playerStatus != UIViewVideoPlayerPlaying && cell.viewVideo.playerStatus != UIViewVideoPlayerPaused){
                [cell playVideoWithURL:[self videoURLForPost:post] muted:timelineConfManager.startVideoMuted looping:timelineConfManager.autoPlayVideos];
            }else{
                [cell showOrHideVideoControls];
            }

        }else{

            //É link do youTube:
            [self openYouTubeLink:post.videoURL];
        }

    }else{
        
        if (!isShowingPostImageDetail && (iv.image != imagePlaceholderPhoto) && (iv.image.size.width > 0.0)){
            isShowingPostImageDetail = true;
            //UIImage *backImage = [ToolBox graphicHelper_ApplyBlurEffectInImage:[ToolBox graphicHelper_Snapshot_Layer:[AppD window].layer] withRadius:5.0];
            VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:iv.image backgroundImage:nil andDelegate:self];
            photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
            photoView.autoresizingMask = (1 << 6) -1;
            photoView.alpha = 0.0;
            //
            [AppD.window addSubview:photoView];
            [AppD.window bringSubviewToFront:photoView];
            //
            [UIView animateWithDuration:0.3 animations:^{
                photoView.alpha = 1.0;
            }];
        }
    }
}

- (void)doubleTapInPostAction:(UITapGestureRecognizer*)sender
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive]){
        Post *actualPost = [postsList objectAtIndex:sender.view.tag];
        //
        if (!actualPost.likeBlocked){
            
            //Botão fake para ativa o action:
            UIButton *b = [[UIButton alloc]init];
            b.tag = sender.view.tag;
            //
            [self actionLike:b];
        }
    }else{
        [self showConnectionView];
    }
}

- (void)longPressInPostAction:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan && !isShowingPostImageDetail)
    {
        //Botão fake para ativa o action:
        UIButton *b = [[UIButton alloc]init];
        b.tag = sender.view.tag;
        //
        [self actionOptions:b];
    }
}

#pragma mark - Sponsor Control

- (void)updateSponsorControl:(Post*)post
{
    //Tratamento contra 'Patrocinado' sem noção:
    if (post.sponsored){
        if (post.sponsorURL == nil || [post.sponsorURL isEqualToString:@""]){
            post.sponsored = false;
            //
            if (post.message == nil || [post.message isEqualToString:@""]){
                post.message = @"   ";
            }
        }
    }
}

#pragma mark - show chat view

-(void)showChatView:(UIBarButtonItem *)barButton{
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]];
	VC_ContactsChat *vcGroupChat = [storyboard instantiateViewControllerWithIdentifier:@"VC_ContactsChat"];
	vcGroupChat.isMenuSelection = NO;
	[vcGroupChat awakeFromNib];
	//
	UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
	topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
	topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
	//
	//Abrindo a tela
	[self.navigationController pushViewController:vcGroupChat animated:YES];
	
}

-(void)showNotificationsView:(UIBarButtonItem *)barButton{
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	VC_Notifications *vcNotifications = [storyboard instantiateViewControllerWithIdentifier:@"VC_Notifications"];
	[vcNotifications awakeFromNib];
	//
	UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
	topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
	topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
	//
//	//Abrindo a tela
	[self.navigationController pushViewController:vcNotifications animated:YES];
	
}

-(void)tapTimelineBanner:(UITapGestureRecognizer *)gesture{
	
	NSLog(@"Tap Banner");
}

- (UIBarButtonItem*)createMessageButton
{
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    UIImage *img = [[UIImage imageNamed:@"icon-chat.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    //
    [userButton setFrame:CGRectMake(0, 0, 32, 32)];
    [userButton setClipsToBounds:YES];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(showChatView:) forControlEvents:UIControlEventTouchUpInside];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}

- (UIBarButtonItem*)createNotificationButton
{
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    UIImage *img = [[UIImage imageNamed:@"ic_notifications.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    //
    [userButton setFrame:CGRectMake(0, 0, 32, 32)];
    [userButton setClipsToBounds:YES];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(showNotificationsView:) forControlEvents:UIControlEventTouchUpInside];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}

#pragma mark - Video Player

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

- (void)openYouTubeLink:(NSString *)videoLink
{
    VideoData* selectedPostVideo = [VideoData new];
    selectedPostVideo.urlYouTube = videoLink;
    selectedPostVideo.videoID = [self extractYoutubeIdFromLink:videoLink];
    selectedPostVideo.nameCustom = @"YouTube";
    //
    [self performSegueWithIdentifier:@"SegueToVideoPlayer" sender:selectedPostVideo];
}



#pragma mark - Utils

- (NSString *)extractYoutubeIdFromLink:(NSString *)link {
    
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}

- (void)reloadScreen
{
    if (fixedBannerImageView == nil){
        [self configureFixedBannerDisplay];
    }
    [tvPosts reloadData];
}

- (NSString*)videoURLForPost:(Post*)post
{
    //NOTE: links de arquivos 'm3u8' (para streaming) não permitem ao iOS salvar o vídeo localmente. Por este motivo o cache não funciona para esta extensão.
    
    if (timelineConfManager.useVideoCache && ![post.videoURL hasSuffix:@"m3u8"]){
        NSString *postID = [NSString stringWithFormat:@"%li", post.postID];
        NSString *cachedVideoURL = [AppD.timelineVideoCacheManager loadVideoURLforID:postID andRemotelURL:post.videoURL];
        if (cachedVideoURL == nil){
            return post.videoURL;
        }else{
            return cachedVideoURL;
        }
    }else{
        return post.videoURL;
    }
}

#pragma mark - Fixed BannerDisplayView Configuration

- (void)configureFixedBannerDisplay
{
    BOOL useBaseBanner = NO;
    
    SmartRouteInterestPoint *currentBanner = nil;
    
    if (SMART_ROUTE_GEOFENCE_MODE){
        if (currentInterestPoint == nil){
            useBaseBanner = YES;
        }else{
            if (currentInterestPoint.bannerImage == nil){
                useBaseBanner = YES;
            }else{
                currentBanner = currentInterestPoint;
            }
        }
    }else{
        if (customBannersList != nil && customBannersList.count > 0){
            currentBanner = [customBannersList objectAtIndex:0];
        }else{
            useBaseBanner = YES;
        }
    }
    
    CGFloat idealHeight = 120; //para banner default apenas...
    
    if (useBaseBanner){
        
        if (AppD.styleManager.baseLayoutManager.imageBanner){
            if (AppD.styleManager.baseLayoutManager.imageBanner.size.height < AppD.styleManager.baseLayoutManager.imageBanner.size.width){
                CGFloat ratio = AppD.styleManager.baseLayoutManager.imageBanner.size.width / AppD.styleManager.baseLayoutManager.imageBanner.size.height;
                idealHeight = self.view.frame.size.width / ratio;
            }
            //
            fixedBannerImageView = [BannerDisplayView createBannerDisplayViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, idealHeight) imagesURLs:nil fixedImageSlots:1 andDelegate:self];
            [fixedBannerImageView setPageControlVisible:NO];
            [fixedBannerImageView setAutoRotationBannerWithTime:0];
        }else{
            fixedBannerImageView = nil;
        }
        
    }else{
        
        if (currentBanner.bannerImage.size.height < currentBanner.bannerImage.size.width){
            CGFloat ratio = currentBanner.bannerImage.size.width / currentBanner.bannerImage.size.height;
            idealHeight = self.view.frame.size.width / ratio;
        }
        //
        fixedBannerImageView = [BannerDisplayView createBannerDisplayViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, idealHeight) imagesURLs:nil fixedImageSlots:(int)customBannersList.count andDelegate:self];
        [fixedBannerImageView setPageControlVisible:YES];
        [fixedBannerImageView setAutoRotationBannerWithTime:routeManager.timeBetweenBanners];
    }
    
    [tvPosts reloadData];
}

#pragma mark - Crashlytics
- (void)updateCrashlyticsConfiguration
{
    //Chaves adicionais para report de exceções do Crashlytics.
    //Elas ficarão disponíveis junto com o crash no console do Firebase.
    
    //user data:
    [CrashlyticsKit setUserName:AppD.loggedUser.name];
    [CrashlyticsKit setUserEmail:AppD.loggedUser.email];
    [CrashlyticsKit setUserIdentifier:[NSString stringWithFormat:@"ID_%i", AppD.loggedUser.userID]];
    //app data:
    NSInteger startCount = [[NSUserDefaults standardUserDefaults] integerForKey:PLISTKEY_APP_START_COUNT];
    [CrashlyticsKit setObjectValue:[NSString stringWithFormat:@"%ld", (long)startCount] forKey:@"app_start_count"];
    //other custom data:
    //insert here...
    //[CrashlyticsKit crash];
}

@end

