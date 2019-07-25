//
//  ResultViewController.m
//  AdAlive
//
//  Created by Monique Trevisan on 9/26/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import <Social/Social.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MediaPlayer/MediaPlayer.h>
//
#import "ProductViewController.h"
#import "SurveyViewController.h"
#import "ActionsTableViewCell.h"
#import "BannerView.h"
#import "RecommendedTableViewCell.h"
#import "FileManager.h"
#import "AppDelegate.h"
#import "ConnectionManager.h"
#import "AdAliveLogHelper.h"
#import "AdAliveWS.h"
#import "ConnectionManager.h"
#import "UIImageView+AFNetworking.h"
#import "Error.h"
#import "AudioViewController.h"
#import "PriceActionViewController.h"
#import "OnlineDocumentViewerController.h"
#import "QuizViewController.h"
#import "ListCouponsViewController.h"
#import "MaskViewController.h"
#import "VC_WebViewCustom.h"
#import "PanoramaGalleryVC.h"
#import "ActionModel3D_AR.h"
#import "ActionModel3D_Scene_ViewerVC.h"
#import "ActionModel3D_AR_ViewerVC.h"
#import "ActionModel3D_TargetImage_ViewerVC.h"
#import "ActionModel3D_PlaceableAR_ViewerVC.h"
#import "ActionModel3D_QuickLookAR_ViewerVC.h"
#import "CustomSurveyMainVC.h"
#import "LabVideoPlayerManager.h"
#import "CustomSurvey.h"

#define TABLE_HEADER_HEIGHT 220 //270
#define SECTION_HEADER_HEIGHT 65

@implementation NSDictionary (JRAdditions)

- (NSDictionary *)dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for(NSString *key in self) {
        id object = [self objectForKey:key];
        if(object == nul) {
            //pointer comparison is way faster than -isKindOfClass:
            //since [NSNull null] is a singleton, they'll all point to the same
            //location in memory.
            [replaced setObject:blank
                         forKey:key];
        }else if ([object isKindOfClass:[NSArray class]])
        {
            NSMutableArray *array = [object mutableCopy];
            for (int i = 0; i < [object count]; i++)
            {
                NSDictionary *dicAux = [object objectAtIndex:i];
                dicAux = [dicAux dictionaryByReplacingNullsWithStrings];
                [array setObject:dicAux atIndexedSubscript:i];
            }
            
            object = array;
            [replaced setObject:object forKey:key];
        }
    }
    
    return [replaced copy];
}

@end

@interface ProductViewController () <MFMailComposeViewControllerDelegate, BannerViewDelegate, AdAliveWSDelegate, LabVideoPlayerManagerDelegate>//, LocationManagerDelegate>
{
    //To hold the scrollView offset value
    float _headerImageYOffset;
}

@property(nonatomic, weak) IBOutlet UIView *portraitView;
@property(nonatomic, weak) IBOutlet UIView *landscapeView;
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) UIImageView *landscapeImageView;
@property(nonatomic, strong) IBOutlet BannerView *bannerImageView;
@property(nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *productImage;
@property(nonatomic, weak) UILabel *productTitle;
@property(nonatomic, weak) UILabel *productSubTitle;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIAlertController *alertController;

@property(nonatomic, assign) bool videoPlayed;
@property(nonatomic, assign) bool linkOpened;

@property(nonatomic, assign) BOOL isLoaded;
@property(nonatomic, strong) LabVideoPlayerManager *videoPlayerManager;

@end

@implementation ProductViewController

@synthesize isLoaded, videoPlayerManager, vcDelegate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIView* headerView = [self headerViewForTable];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [UIView new];
	
    //Verifica se a imagem existe localmente, senão faz o download
	if(!self.dicProductData){
		[self loadProductData];
	}
	else{
		[self downloadProductImage];
	}
	
	if (!self.showBackButton)
	{
		self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
	}
    
    isLoaded = NO;
    videoPlayerManager = [LabVideoPlayerManager new];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    if (!isLoaded){
        
        [self.view layoutIfNeeded];
        
        //Layout:
        self.view.backgroundColor = [UIColor whiteColor];
        //
        [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
        self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_PRODUCT_DETAIL", @"");
        //
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
        self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
        
        if (self.dicProductData){
            NSString *title = [self.dicProductData objectForKey:PRODUCT_TITLE_KEY];
            self.navigationItem.title = title;
        }
        
        //Data:
        self.dicProductData = [self.dicProductData dictionaryByReplacingNullsWithStrings];
        
        NSString *pName = [self.dicProductData valueForKey:@"name"];
        if (pName != nil && ![pName isEqualToString:@""]){
            self.navigationItem.title = pName;
        }else{
            self.navigationItem.title = @"Produto";
        }
        
        if (self.executeAutoLaunch)
        {
            NSDictionary *dicAction = [self getAutoLaunchAction];
            
            if (dicAction)
            {
                NSArray *arrayActions = [self.dicProductData objectForKey:PRODUCT_ACTIONS_KEY];
                
                NSInteger index = [arrayActions indexOfObject:dicAction];
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            }
            
            self.executeAutoLaunch = NO;
        }
        
        [self.tableView reloadData];
        
        isLoaded = YES;
        
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

#pragma mark - Auto Launch

//Retorna a primeira ação com o atributo auto_launch
-(NSDictionary *)getAutoLaunchAction
{
    NSArray *arrayActions = [self.dicProductData objectForKey:PRODUCT_ACTIONS_KEY];
    
    for(NSDictionary *dicAction in arrayActions)
    {
        NSArray *allKeys = [dicAction allKeys];
        
        if ([allKeys containsObject:PRODUCT_AUTO_LAUNCH_KEY])
        {
            if ([[dicAction objectForKey:PRODUCT_AUTO_LAUNCH_KEY] isEqualToNumber:@1])
            {
                return dicAction;
            }
        }
    }
    
    return nil;
}

#pragma mark - Header View

-(UIView *)headerViewForTable
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TABLE_HEADER_HEIGHT)];
    
    if (!self.productImage)
    {
        self.productImage = [[UIImageView alloc] initWithFrame:headerView.frame];
    }
    
    [self.productImage setFrame:CGRectMake(0, 0, self.view.frame.size.width, TABLE_HEADER_HEIGHT)];
    self.productImage.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit
    self.productImage.clipsToBounds = YES;
    [headerView addSubview:self.productImage];
    
    headerView.backgroundColor = [UIColor clearColor];
    
    if (!self.activityIndicator && self.showBackButton)
    {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.center = CGPointMake(headerView.center.x, headerView.center.y + 40);
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        [headerView addSubview:self.activityIndicator];
    }
    
    return headerView;
}

#pragma mark - TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayActions = [self.dicProductData objectForKey:PRODUCT_ACTIONS_KEY];
    if (indexPath.row < ([arrayActions count]))
    {
        return 72;
    }
    else
    {
        return 120; //150
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrayActions = [self.dicProductData objectForKey:PRODUCT_ACTIONS_KEY];
    
    if (([self.dicProductData objectForKey:PRODUCT_RECOMMENDED_ITEMS] == nil) || ([[self.dicProductData objectForKey:PRODUCT_RECOMMENDED_ITEMS] count] == 0))
    {
        return [arrayActions count];
    }
    else
    {
        return [arrayActions count] + 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayActions = [self.dicProductData objectForKey:PRODUCT_ACTIONS_KEY];
    
    if (arrayActions)
    {
        if (indexPath.row < ([arrayActions count]))
        {
            NSString *cellIdentifier = @"ActionCell";
			
            ActionsTableViewCell *cell = (ActionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
			
            cell.backgroundColor = nil; //[UIColor colorWithRed:0.9019 green:0.9019 blue:0.9019 alpha:1];
            cell.lblTitleAction.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:16];
            cell.lblTitleAction.textColor = AppD.styleManager.colorPalette.textDark;
            
			NSDictionary *dicAction = [arrayActions objectAtIndex:indexPath.row];
			
            //Nome da action:
            cell.lblTitleAction.text = [dicAction objectForKey:ACTION_LABEL_KEY];
            
            //Imagem da action:
            NSString *strType = [dicAction objectForKey:ACTION_TYPE_KEY];
            cell.imgAction.image = [self imageForAction:strType];
            cell.imgAction.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
            
            return cell;
        }
        else
        {
            NSString *cellIdentifier2 = @"RecommendedCell";
            
            RecommendedTableViewCell *cell = (RecommendedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:16];
            cell.titleLabel.textColor = AppD.styleManager.colorPalette.textNormal;
            
            if (cell.scrollView.contentSize.width == 0 && [[self.dicProductData objectForKey:PRODUCT_RECOMMENDED_ITEMS] count] > 0)
            {
                [self configureCell:cell];
                //[self performSelectorInBackground:@selector(configureCell:) withObject:cell];
            }

            return cell;
        }
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *arrayActions = [self.dicProductData objectForKey:PRODUCT_ACTIONS_KEY];
	NSDictionary *dicAction = [arrayActions objectAtIndex:indexPath.row];
    NSString *actionType = [dicAction objectForKey:ACTION_TYPE_KEY];
    if([actionType isEqualToString:ACTION_VIDEO_AR] || [actionType isEqualToString:ACTION_VIDEO_AR_TRANSP]) {
        
        //NOTE: Com esta mensagem não será feita a chamada 'registerProductAction:' do protocolo ProductViewControllerDelegate.
        //Desta forma ao voltar para a tela de scan videosAR não serão tocados automaticamente.
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showInfo:@"Atenção!" subTitle:@"Actions do tipo 'VideoAR' e 'VideoAR Transparente' devem ser visualizadas diretamente no scanner. Por favor, aponte a camera do dipositivo para a imagem 'target' e o vídeo irá executar usando realidade aumentada." closeButtonTitle:@"OK" duration:0.0];        
        
    }else{
        
        [self processDictionaryAction:dicAction];
        
        /*
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        AdAliveWS *adaliveWS = [[AdAliveWS alloc] initWithUrlServer:[defaults stringForKey:BASE_APP_URL] andUserEmail:AppD.loggedUser.email error:nil];
        adaliveWS.delegate = self;
        NSString *actionID = [NSString stringWithFormat:@"%@", [dicAction objectForKey:@"id"]];
        [adaliveWS findActionWithID:actionID];
        */
        
    }
}

-(void)configureCell:(RecommendedTableViewCell *)cell
{
    [cell.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *arrayItems = [self.dicProductData objectForKey:PRODUCT_RECOMMENDED_ITEMS];
    
    [cell.scrollView setContentSize:CGSizeMake([arrayItems count] * 90, cell.scrollView.frame.size.height)];
    cell.backgroundColor = [UIColor colorWithRed:0.9019 green:0.9019 blue:0.9019 alpha:1];
    cell.scrollView.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < [arrayItems count]; i++)
    {
        NSDictionary *dicItem = [arrayItems objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((80 * i) + (10*i), 10, 80, 80)];
        imageView.tag = [[dicItem objectForKey:PRODUCT_ID_KEY] integerValue];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        imageView.layer.borderWidth = 1;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imageView addGestureRecognizer:tapGesture];
        
        [cell.scrollView addSubview:imageView];
        
        __weak UIImageView *weakImageView = imageView;
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dicItem objectForKey:PRODUCT_IMAGE_URL_KEY]]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            [weakImageView setImage:image];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            [weakImageView setImage:[UIImage imageNamed:@"cell-sponsor-image-placeholder"]];
        }];
    }
    
    /*
    @autoreleasepool
    {
        NSArray *arrayItems = [self.dicProductData objectForKey:PRODUCT_RECOMMENDED_ITEMS];
        
        [cell.scrollView setContentSize:CGSizeMake([arrayItems count] * 90, cell.scrollView.frame.size.height)];
        cell.backgroundColor = [UIColor colorWithRed:0.9019 green:0.9019 blue:0.9019 alpha:1];
        cell.scrollView.backgroundColor = [UIColor clearColor];
        
        for (int i = 0; i < [arrayItems count]; i++)
        {
            NSDictionary *dicItem = [arrayItems objectAtIndex:i];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((80 * i) + (10*i), 10, 80, 80)];
            imageView.tag = [[dicItem objectForKey:PRODUCT_ID_KEY] integerValue];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            imageView.layer.borderWidth = 1;
            
            //TODO: crash layout
            [cell.scrollView performSelectorOnMainThread:@selector(addSubview:) withObject:imageView waitUntilDone:YES];
//            [cell.scrollView addSubview:imageView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:tapGesture];
            
            UIImage *image = nil;
            
			NSURL *url = [NSURL URLWithString:[dicItem objectForKey:PRODUCT_IMAGE_URL_KEY]];
			NSData *data = [NSData dataWithContentsOfURL:url];
			image = [UIImage imageWithData:data];
			
			[imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        }
    }
     */
}

#pragma TextField Method

-(void)changeTextFieldValue:(UITextField *)textfield
{
    UIAlertAction *action = self.alertController.actions[0];
    
    NSString *tfQuantity = self.alertController.textFields[0].text;
    
    if (![tfQuantity isEqualToString:@""])
    {
        action.enabled = YES;
    }
    else
    {
        action.enabled = NO;
    }
    
}

#pragma mark - Facebook Methods

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [kv[1] stringByRemovingPercentEncoding]; //stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		params[kv[0]] = val;
	}
	return params;
}

#pragma mark - Interface Events

-(void)handleTap:(UITapGestureRecognizer *)tapGesture
{
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    
    /*
    NSArray *arrayItems = [self.dicProductData objectForKey:PRODUCT_RECOMMENDED_ITEMS];
    NSString *targetName = nil;
    
    for (int i = 0; i < [arrayItems count]; i++)
    {
        NSDictionary *dicItem = [arrayItems objectAtIndex:i];
        long productID = [[dicItem objectForKey:PRODUCT_ID_KEY] integerValue];
        
        if (imageView.tag == productID){
            targetName = [dicItem valueForKey:@"targetName"];
            break;
        }
    }
    
    //Carrega um novo produto:
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![targetName isEqualToString:self.lastTargetName])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        self.lastTargetName = targetName;
        AdAliveWS *adalivews = [[AdAliveWS alloc] initWithUrlServer:[defaults stringForKey:BASE_APP_URL] andUserEmail:AppD.loggedUser.email error:nil];
        adalivews.delegate = self;
        NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
        [adalivews findProductWithTargetName:targetName appID:appID];
    }
    */
    
    [self loadProductWithId:[NSString stringWithFormat:@"%ld", (long)imageView.tag]];
    
}

#pragma mark - Persistence Methods

-(void)downloadProductImage
{
    NSURL *url = [NSURL URLWithString:[self.dicProductData objectForKey:PRODUCT_IMAGE_URL_KEY]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    if (image)
    {
        [self.productImage setImage:image];
        self.landscapeImageView = [[UIImageView alloc] initWithImage:image];
        [self.landscapeImageView setImage:image];
        [self.activityIndicator removeFromSuperview];
    }
    else
    {
        //escolher uma imagem padrão.
        [self.productImage setImage:nil];
        [self.landscapeImageView setImage:nil];
    }
}

-(void)loadProductWithId:(NSString *)productId
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
	
	if ([connectionManager isConnectionActive])
	{
		dispatch_async(dispatch_get_main_queue(),^{
			[AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
		});
		
		[connectionManager loadProductWithId:productId withCompletionHandler:^(NSDictionary *response, NSError *error) {
			
			[AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
			
			if(!error){
                
                if ([response isKindOfClass:[NSDictionary class]]){
                    
                    NSArray *allkeys = [response allKeys];
                    
                    if ([allkeys containsObject:ERROR_ARRAY_KEY])
                    {
                        Error *error = [[Error alloc] initWithDictionary:response];
                        NSString *errorMessage = [error formatCompleteErrorMessage];
                        //
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_CONNECTION_DATA", @"") subTitle:errorMessage closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
                    }else{
                        
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ProductViewController *productController = (ProductViewController *)[sb instantiateViewControllerWithIdentifier:@"ProductViewController"];
                        productController.dicProductData = response;
                        //productController.targetName = ???;
                        productController.showBackButton = YES;
                        productController.executeAutoLaunch = YES;
                        //
                        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                        [self.navigationController pushViewController:productController animated:YES];
                        
                    }
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

#pragma mark - ConnectionManager Delegate

//-(void)didConnectWithSuccess:(NSDictionary *)response
//{
//    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
//
//    NSArray *allkeys = [response allKeys];
//
//    if([allkeys containsObject:ERROR_ARRAY_KEY])
//    {
//        Error *error = [[Error alloc] initWithDictionary:response];
//        NSString *errorMessage = [error formatCompleteErrorMessage];
//
//        SCLAlertView *alert = [AppD createDefaultAlert];
//        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_CONNECTION_DATA", @"") subTitle:errorMessage closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
//
//        //SCLAlertView *alert = [AppD createDefaultAlert];
//        //[alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_CONNECTION_DATA", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_ERROR_CONNECTION_DATA", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
//
//    }
//    else if([allkeys containsObject:@"questions"])
//    {
//        [self showMySurveysWithData:response];
//    }
//    else if ([allkeys containsObject:@"banner"])
//    {
//        //Mostrar o banner
//    }
//    else
//    {
//        //Produto Recomendado
//        NSMutableDictionary *dicProductData = [(NSDictionary *)response mutableCopy];
//        dicProductData = [[dicProductData dictionaryByReplacingNullsWithStrings] mutableCopy];
//
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        ProductViewController *productController = (ProductViewController *)[sb instantiateViewControllerWithIdentifier:@"ProductViewController"];
//
//        productController.dicProductData = dicProductData;
//
//        [self.navigationController pushViewController:productController animated:YES];
//
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        AdAliveLogs *logs = [AdAliveLogs sharedManager];
//        logs.urlServer = [defaults stringForKey:BASE_APP_URL];
//        logs.userEmail = AppD.loggedUser.email;
//        [logs productLogWithProductId:[dicProductData objectForKey:@"product_id"]  senderName:@"RECOMENDATION"];
//    }
//}
//
//-(void)didConnectWithFailure:(NSError *)error
//{
//    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
//
//    SCLAlertView *alert = [AppD createDefaultAlert];
//    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_CONNECTION_DATA", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_ERROR_CONNECTION_DATA", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
//
//}

#pragma mark -

-(void)didReceiveResponse:(AdAliveWS *)adAliveWs withSuccess:(NSDictionary *)response{
	
	NSArray *allKeys = [response allKeys];
	
    //****************************************************************************************************
    //PRODUCT
    //****************************************************************************************************
	if([allKeys containsObject:@"product"]){
		[AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
		self.dicProductData = [response objectForKey:@"product"];
		self.dicProductData = [self.dicProductData dictionaryByReplacingNullsWithStrings];
		[self downloadProductImage];
		[self.tableView reloadData];
	}
    
    //****************************************************************************************************
    //COUPONS
    //****************************************************************************************************
    else if ([allKeys containsObject:@"coupons"]){
        [self showMyCouponsWithData:response];
    }
    
    //****************************************************************************************************
    //QUESTIONS
    //****************************************************************************************************
	else if ([allKeys containsObject:@"questions"]){
		[AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
		[self showMySurveysWithData:response];
	}
    
    //****************************************************************************************************
    //BANNER
    //****************************************************************************************************
//    else if ([allKeys containsObject:@"banner"]){
//        //TODO: mostrar banner não está implementado no app demo
//    }
    
    //****************************************************************************************************
    //MASKS
    //****************************************************************************************************
    else if ([allKeys containsObject:@"masks"]){
        [self showMaskCollectionWithData:[response objectForKey:@"masks"]];
    }
    
	else if([allKeys containsObject:@"action"]){
		
        //****************************************************************************************************
        //ACTIONS
        //****************************************************************************************************
        
		NSDictionary *dicAction = [response objectForKey:@"action"];
        
        [self processDictionaryAction:dicAction];
	}
    
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
}

-(void)didReceiveResponse:(AdAliveWS *)adAliveWs withError:(NSError *)error{
	
	SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
    }];
	[alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:error.localizedDescription closeButtonTitle:nil duration:0.0];
}



#pragma mark - ScroolView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.landscapeImageView;
}

#pragma mark - Text Field Delegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    return YES;
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//
//}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Action events

-(void)showMySurveysWithData:(NSDictionary *)surveyData
{
    NSArray *arrayActions = [self.dicProductData objectForKey:PRODUCT_ACTIONS_KEY];
    NSDictionary *dicAction = [arrayActions objectAtIndex:[[self.tableView indexPathForSelectedRow] row] ];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SurveyViewController *surveyController = (SurveyViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SurveyViewController"];
    surveyController.dicSurveyData = surveyData;
    surveyController.actionId = [dicAction objectForKey:@"id"];
    surveyController.surveyId = [surveyData objectForKey:@"id"];
    surveyController.providesPresentationContextTransitionStyle = YES;
    surveyController.definesPresentationContext = YES;
    surveyController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    surveyController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:surveyController animated:YES];
}

-(void)requestSurveyDataWithId:(NSString *)surveyId
{
	dispatch_async(dispatch_get_main_queue(),^{
		[AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
	});
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	AdAliveWS *adalivews = [[AdAliveWS alloc] initWithUrlServer:[defaults stringForKey:BASE_APP_URL] andUserEmail:AppD.loggedUser.email error:nil];
	adalivews.delegate = self;
	[adalivews findSurveyWithId:[NSNumber numberWithInt:[surveyId intValue]]];
}

-(void)loadProductData{
	dispatch_async(dispatch_get_main_queue(),^{
		[AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
	});
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	AdAliveWS *adalivews = [[AdAliveWS alloc] initWithUrlServer:[defaults stringForKey:BASE_APP_URL] andUserEmail:AppD.loggedUser.email error:nil];
	adalivews.delegate = self;
	NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
	[adalivews findProductWithTargetName:self.targetName appID:appID];
}

#pragma mark - BannerView delegate

-(void)didTapOnBannerView:(BannerView *)bannerView withLink:(NSString *)bannerUrl
{
    NSURL *url = [NSURL URLWithString:bannerUrl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_INVALID_URL", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_INVALID_URL", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
	if ([segue.identifier isEqualToString:@"SegueCameraWeb"]){
        VC_WebViewCustom *destViewController = (VC_WebViewCustom*)segue.destinationViewController;
        destViewController.fileURL = ((WebItemToShow *)sender).urlString;
        //destViewController.titleNav = ((WebItemToShow *)sender).titleMenu;
        destViewController.showShareButton = NO;
        destViewController.hideViewButtons = NO;
        destViewController.showAppMenu = NO;
    }else if ([segue.identifier isEqualToString:@"SegueToQuiz"]){
        QuizViewController *quizVC = (QuizViewController*)segue.destinationViewController;
        quizVC.questionPath = (NSString*)sender;
    }
}

-(void)didFinishVideo{
    NSLog(@"didFinishVideo");
}

#pragma mark - Tap Actions

- (void)processDictionaryAction:(NSDictionary*)dicAction
{
    //ACTION_MODEL_3D @"Model3DAction"   ***************************************************
    if([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_MODEL_3D])
    {
        NSArray *allKeysAction = [dicAction allKeys];
        if ([allKeysAction containsObject:@"action_model_3d"]){
            ActionModel3D_AR *model3D = [ActionModel3D_AR createObjectFromDictionary:[dicAction valueForKey:@"action_model_3d"]];
            
            switch (model3D.type) {
                    
                case ActionModel3DViewerTypeScene:
                case ActionModel3DViewerTypeAnimatedScene:{
                    
                    if (@available(iOS 11.0, *)) {
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Model3DViewers" bundle:nil];
                        ActionModel3D_Scene_ViewerVC *vc = (ActionModel3D_Scene_ViewerVC *)[sb instantiateViewControllerWithIdentifier:@"ActionModel3D_Scene_ViewerVC"];
                        vc.actionM3D = model3D;
                        vc.animatedTransitions = NO;
                        vc.backgroundPreviewImage = [ToolBox graphicHelper_Snapshot_View:self.view];
                        //
                        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                        [self.navigationController pushViewController:vc animated:NO];
                    }else{
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showError:@"Atenção!" subTitle:@"Esta Action só está disponível no iOS 11.0 ou superior." closeButtonTitle:@"OK" duration:0.0];
                    }
                    
                }break;
                    //
                case ActionModel3DViewerTypeImageTarget:{
                    
                    if (@available(iOS 12.0, *)) {
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Model3DViewers" bundle:nil];
                        ActionModel3D_TargetImage_ViewerVC *vc = (ActionModel3D_TargetImage_ViewerVC *)[sb instantiateViewControllerWithIdentifier:@"ActionModel3D_TargetImage_ViewerVC"];
                        vc.actionM3D = model3D;
                        vc.animatedTransitions = NO;
                        //
                        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                        [self.navigationController pushViewController:vc animated:NO];
                    }else{
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showError:@"Atenção!" subTitle:@"Esta Action só está disponível no iOS 12.0 ou superior." closeButtonTitle:@"OK" duration:0.0];
                    }
                    
                }break;
                    //
                case ActionModel3DViewerTypeAR:{
                    
                    if (@available(iOS 11.0, *)) {
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Model3DViewers" bundle:nil];
                        ActionModel3D_AR_ViewerVC *vc = (ActionModel3D_AR_ViewerVC *)[sb instantiateViewControllerWithIdentifier:@"ActionModel3D_AR_ViewerVC"];
                        vc.actionM3D = model3D;
                        vc.animatedTransitions = NO;
                        //
                        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                        [self.navigationController pushViewController:vc animated:NO];
                    }else{
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showError:@"Atenção!" subTitle:@"Esta Action só está disponível no iOS 11.0 ou superior." closeButtonTitle:@"OK" duration:0.0];
                    }
                    
                }break;
                    //
                case ActionModel3DViewerTypePlaceableAR:{
                    
                    if (@available(iOS 11.0, *)) {
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Model3DViewers" bundle:nil];
                        ActionModel3D_PlaceableAR_ViewerVC *vc = (ActionModel3D_PlaceableAR_ViewerVC *)[sb instantiateViewControllerWithIdentifier:@"ActionModel3D_PlaceableAR_ViewerVC"];
                        vc.actionM3D = model3D;
                        vc.animatedTransitions = NO;
                        //
                        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                        [self.navigationController pushViewController:vc animated:NO];
                    }else{
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showError:@"Atenção!" subTitle:@"Esta Action só está disponível no iOS 11.0 ou superior." closeButtonTitle:@"OK" duration:0.0];
                    }
                    
                }break;
                    
                case ActionModel3DViewerTypeQuickLookAR:{
                    
                    if (@available(iOS 11.0, *)) {
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Model3DViewers" bundle:nil];
                        ActionModel3D_QuickLookAR_ViewerVC *vc = (ActionModel3D_QuickLookAR_ViewerVC *)[sb instantiateViewControllerWithIdentifier:@"ActionModel3D_QuickLookAR_ViewerVC"];
                        vc.actionM3D = model3D;
                        vc.animatedTransitions = NO;
                        //
                        vc.backgroundPreviewImage =  [ToolBox graphicHelper_Snapshot_View:self.view];
                        //
                        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                        [self.navigationController pushViewController:vc animated:NO];
                    }else{
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showError:@"Atenção!" subTitle:@"Esta Action só está disponível no iOS 11.0 ou superior." closeButtonTitle:@"OK" duration:0.0];
                    }
                    
                }break;
                    
            }
            
        }
    }
    
    //ACTION_VIDEO @"VideoAction"   ***************************************************
    if([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_VIDEO])
    {
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        NSString *href = [dicAction objectForKey:ACTION_HREF_KEY];
        
        if (![href isEqualToString:@""])
        {
            NSString *videoURL = [dicAction objectForKey:ACTION_HREF_KEY];
            [videoPlayerManager playStreamingVideoFrom:videoURL withViewControllerDelegate:self];
        }
    }
    
    //ACTION_VIDEO_AR @"VideoArAction"   ***************************************************
    else if([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_VIDEO_AR])
    {
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        NSString *href = [dicAction objectForKey:ACTION_HREF_KEY];
        
        if (![href isEqualToString:@""])
        {
            if (vcDelegate){
                if ([vcDelegate respondsToSelector:@selector(registerProductAction:)]){
                    [vcDelegate registerProductAction:dicAction];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    //ACTION_VIDEO_AR_TRANSP @"VideoArTranspAction"   ***************************************************
    else if([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_VIDEO_AR_TRANSP])
    {
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        NSString *href = [dicAction objectForKey:ACTION_HREF_KEY];
        
        if (![href isEqualToString:@""])
        {
            if (vcDelegate){
                if ([vcDelegate respondsToSelector:@selector(registerProductAction:)]){
                    [vcDelegate registerProductAction:dicAction];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    //ACTION_SURVEY @"SurveyAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_SURVEY])
    {
        [self requestSurveyDataWithId:[dicAction objectForKey:ACTION_HREF_KEY]];
    }
    
    //ACTION_INFO @"InfoAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_INFO])
    {
        NSString *url = [dicAction objectForKey:ACTION_HREF_KEY];
        if (![url containsString:@"http"])
        {
            url = [NSString stringWithFormat:@"http://%@", url];
        }
        
        _linkOpened = YES;
        WebItemToShow *webItem = [WebItemToShow new];
        webItem.urlString = url;
        //webItem.titleMenu = spo.name;
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [self performSegueWithIdentifier:@"SegueCameraWeb" sender:webItem];
    }
    
    //ACTION_AUDIO @"AudioAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_AUDIO])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AudioViewController *viewController = (AudioViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AudioViewController"];
        viewController.audioURL = [dicAction objectForKey:ACTION_HREF_KEY];
        viewController.providesPresentationContextTransitionStyle = YES;
        viewController.definesPresentationContext = YES;
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
    //ACTION_SELL @"SellAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_SELL])
    {
        //TODO: no demo não possui ação válida
        //[self performSegueWithIdentifier:@"BuySegue" sender:self];
    }
    
    //ACTION_PRICE @"PriceAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_PRICE])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PriceActionViewController *viewController = (PriceActionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PriceActionViewController"];
        viewController.dicProduct = self.dicProductData;
        viewController.providesPresentationContextTransitionStyle = YES;
        viewController.definesPresentationContext = YES;
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
    //ACTION_ORDER @"OrderAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_ORDER])
    {
        [self tapOrderAction];
        //TODO: averiguar (o app demo não faz nada com a resposta da order)
    }
    
    //ACTION_LIKE @"LikeAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_LIKE])
    {
        NSString *href = [dicAction objectForKey:ACTION_HREF_KEY];
        [self shareWithFacebookWithLink:href];
    }
    
    //ACTION_DRAW @"DrawAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_DRAW])
    {
        //TODO: no demo não possui ação válida
        NSLog(@"ACTION_DRAW");
        //[self performSegueWithIdentifier:@"DrawSegue" sender:self];
    }
    
    //ACTION_LINK @"LinkAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_LINK])
    {
        NSString *stringHref = [dicAction objectForKey:ACTION_HREF_KEY];
        
        if (stringHref != nil && ![stringHref isEqualToString:@""]){
            //Abre um web browser com o conteúdo:
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Utils" bundle:[NSBundle mainBundle]];
            OnlineDocumentViewerController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"OnlineDocumentViewerController"];
            [webViewController awakeFromNib];
            //
            webViewController.documentURL = stringHref;
            webViewController.documentName = [dicAction objectForKey:ACTION_LABEL_KEY];
            webViewController.allowsShareDoc = NO;
            webViewController.useSimpleReturnButton = YES;
            //
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            //
            //Abrindo a tela
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    }
    
    //ACTION_PHONE @"PhoneAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_PHONE])
    {
        NSString *phoneNumber = [dicAction objectForKey:ACTION_HREF_KEY];
        if (phoneNumber != nil && ![phoneNumber isEqualToString:@""]){
            
            NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@", phoneNumber]];
            NSURL *phoneFallbackUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@", phoneNumber]];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [UIApplication.sharedApplication openURL:phoneUrl];
            } else if ([[UIApplication sharedApplication] canOpenURL:phoneFallbackUrl]) {
                [UIApplication.sharedApplication openURL:phoneFallbackUrl];
            }else{
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_CALL_PHONE", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_ERROR_CALL_PHONE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
        }
    }
    
    //ACTION_QUIZ @"QuizAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_QUIZ])
    {
        NSString *stringHref = [dicAction objectForKey:ACTION_HREF_KEY];
        if (stringHref != nil && ![stringHref isEqualToString:@""]){
            [self performSegueWithIdentifier:@"SegueToQuiz" sender:stringHref];
        }
        //TODO: averiguar (o app demo não faz nada com a resposta do quiz)
    }
    
    //ACTION_REGISTER @"RegisterAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_REGISTER])
    {
        //TODO: verificar funcionamento
        NSLog(@"ACTION_REGISTER");
        //No app demo esta ação cai no else (abre como um link)
    }
    
    //ACTION_RSVP @"RsvpAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_RSVP])
    {
        [self performSegueWithIdentifier:@"SegueToRSVP" sender:self];
        //TODO: O app demo não inscreve o usuário em evento algum...
    }
    
    //ACTION_TWEET @"TweetAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_TWEET])
    {
        NSString *href = [dicAction objectForKey:ACTION_HREF_KEY];
        [self shareWithTwitterWithLink:href];
    }
    
    //ACTION_EMAIL @"EmailAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_EMAIL])
    {
        [self sendMailWithDictionary:dicAction];
    }
    
    //ACTION_COUPON @"CouponAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_COUPON])
    {
        //Coupom é tratado antes da verificação das actions
        NSLog(@"ACTION_COUPON");
    }
    
    //ACTION_PROMOTION @"PromotionAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_PROMOTION])
    {
        //TODO: verificar se o identificador da promotion é mesmo um href...
        [self requestPromotionDataWithId:[dicAction objectForKey:ACTION_HREF_KEY]];
    }
    
    //ACTION_TURISTIK @"TuristikAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_TURISTIK])
    {
        //TODO: no demo não possui ação implmentada
        NSLog(@"ACTION_TURISTIK");
    }
    
    //ACTION_TRACKING @"TrackingAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_TRACKING])
    {
        //TODO: no demo não possui ação implmentada
        NSLog(@"ACTION_TRACKING");
    }
    
    //ACTION_MASK @"MaskAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_MASK])
    {
        //TODO: ACTION_MASK
        NSString *href = [dicAction objectForKey:ACTION_HREF_KEY];
        if (href != nil && ![href isEqualToString:@""])
        {
            [self loadMaskCollection:href];
        }
    }
    
    //ACTION_PANORAMA_GALLERY @"PanoramaGalleryAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_PANORAMA_GALLERY])
    {
        [self openPanoramaGalleryForTarget:self.targetName];
    }
    
    //ACTION_CUSTOM_SURVEY @"CustomSurveyAction"   ***************************************************
    else if ([[dicAction objectForKey:ACTION_TYPE_KEY] isEqualToString:ACTION_CUSTOM_SURVEY])
    {
        [self openQuestionnaireForAction:dicAction];
    }
    
}

- (void)tapOrderAction
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    
    UITextField *textField = [alert addTextField:NSLocalizedString(@"LABEL_ACTION_QUANTITY", @"")];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [textField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setSpellCheckingType:UITextSpellCheckingTypeNo];
    textField.delegate = self;
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_SEND", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
        
        [textField resignFirstResponder];
        
        if (textField.text != nil && ![textField.text isEqualToString:@""]){
            
            NSDictionary *dicAux = [self.dicProductData dictionaryByReplacingNullsWithStrings];
            NSMutableDictionary *mProduct = [dicAux mutableCopy];
            NSArray *arrayTextFields = [self.alertController textFields];
            UITextField *quantity = [arrayTextFields objectAtIndex:0];
            [mProduct setObject:quantity.text forKey:ACTION_ORDER_QUANTITY];
            
            FileManager *fileManeger = [FileManager sharedInstance];
            NSArray *arrayOrder = [fileManeger getOrderData];
            
            if (arrayOrder)
            {
                NSMutableArray *mArray = [arrayOrder mutableCopy];
                [mArray addObject:mProduct];
                [fileManeger saveOrderData:mArray];
            }
            else
            {
                NSArray *array = [NSArray arrayWithObject:mProduct];
                [fileManeger saveOrderData:array];
            }
            
        }
    }];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
    
    [alert showEdit:self title:NSLocalizedString(@"ALERT_TITLE_FORGOT_PASSWORD", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_FORGOT_PASSWORD", @"") closeButtonTitle:nil duration:0.0];
   
}

-(void)shareWithFacebookWithLink:(NSString *)urlString
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *fbShare = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbShare addURL:[NSURL URLWithString:urlString]];
        fbShare.completionHandler = ^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone)
            {
                NSLog(@"Post Compartilhado");
            }
            else if(result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Post Cancelado");
            }
            else
            {
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_SOCIAL_SHARE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SOCIAL_SHARE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
            
            // dismiss controller
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:^{
                    NSLog(@"Facebook Sheet has been dismissed.");
                }];
            });
        };
        
        [self presentViewController:fbShare animated:YES completion:nil];
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ACCOUNT_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_ACCOUNT_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

-(void)shareWithTwitterWithLink:(NSString *)urlString
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *twShare = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twShare addURL:[NSURL URLWithString:urlString]];
        twShare.completionHandler = ^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultDone)
            {
                NSLog(@"Tweet Postado");
            }
            else if(result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Tweet Cancelado");
            }
            else
            {
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_SOCIAL_SHARE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SOCIAL_SHARE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }

            //  dismiss the Tweet Sheet
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:^{
                    NSLog(@"Tweet Sheet has been dismissed.");
                }];
            });
        };
        [self presentViewController:twShare animated:YES completion:nil];
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ACCOUNT_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_ACCOUNT_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

-(void)sendMailWithDictionary:(NSDictionary *)dicAction
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:[self.dicProductData objectForKey:PRODUCT_TITLE_KEY]];
        [controller setMessageBody:[dicAction objectForKey:ACTION_HREF_KEY] isHTML:NO];
        
        if (controller){
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            NSLog(@"Class 'MFMailComposeViewController' not found.");
        }
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_EMAIL_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMAIL_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

-(void)showMyCouponsWithData:(NSDictionary *)promotionData
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSArray *arrayActions = [self.dicProductData objectForKey:PRODUCT_ACTIONS_KEY];
    NSDictionary *dicAction = [arrayActions objectAtIndex:[[self.tableView indexPathForSelectedRow] row] ];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ListCouponsViewController *viewController = (ListCouponsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ListCouponsViewController"];
    //
    NSData *dicDataProduct = [NSKeyedArchiver archivedDataWithRootObject:self.dicProductData];
    viewController.dicProductData = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:dicDataProduct]];
    //
    NSData *dicDataPromotion = [NSKeyedArchiver archivedDataWithRootObject:promotionData];
    viewController.dicPromotionData = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:dicDataPromotion]];
    //
    viewController.actionId = [dicAction objectForKey:@"id"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)requestPromotionDataWithId:(NSString *)promotionId
{
    AdAliveConnectionManager *connectionManager = [[AdAliveConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@?email=%@",SERVICE_URL_PROMOTION, promotionId, AppD.loggedUser.email];
        
        [connectionManager getRequestUsingParametersFromURL:urlString withDictionaryCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            if (error){
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle: error.localizedDescription duration:0.0];
            }else{
                if ([response isKindOfClass:[NSDictionary class]]){
                    
                    NSArray *allkeys = [response allKeys];
                    
                    if ([allkeys containsObject:ERROR_ARRAY_KEY])
                    {
                        Error *error = [[Error alloc] initWithDictionary:response];
                        NSString *errorMessage = [error formatCompleteErrorMessage];
                        //
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_CONNECTION_DATA", @"") subTitle:errorMessage closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                    else if ([allkeys containsObject:@"coupons"])
                    {
                        [self showMyCouponsWithData:response];
                    }
                }
            }
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        }];
    }
    else
    {
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

-(void) loadMaskCollection:(NSString *)maskId
{
    AdAliveConnectionManager *connectionManager = [[AdAliveConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@/%@", [connectionManager getServerPreference] ,SERVICE_URL_MASK_COLLECTION, maskId];
        
        [connectionManager getRequestUsingParametersFromURL:urlString withDictionaryCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            if (error){
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle: error.localizedDescription duration:0.0];
            }else{
                if ([response isKindOfClass:[NSDictionary class]]){
                    
                    NSArray *allkeys = [response allKeys];
                    
                    if ([allkeys containsObject:ERROR_ARRAY_KEY])
                    {
                        Error *error = [[Error alloc] initWithDictionary:response];
                        NSString *errorMessage = [error formatCompleteErrorMessage];
                        //
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_CONNECTION_DATA", @"") subTitle:errorMessage closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                    else if ([allkeys containsObject:@"masks"])
                    {
                        [self showMaskCollectionWithData:[response objectForKey:@"masks"]];
                    }
                }
            }
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        }];
    }
    else
    {
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

-(void)showMaskCollectionWithData:(NSArray *)maskCollection
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MaskViewController *viewController = (MaskViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MaskViewController"];
    viewController.maskCollection = maskCollection;
    //
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)openPanoramaGalleryForTarget:(NSString*)productTarget
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Viewers" bundle:nil];
    PanoramaGalleryVC *viewController = (PanoramaGalleryVC *)[storyboard instantiateViewControllerWithIdentifier:@"PanoramaGalleryVC"];
    viewController.showAppMenu = NO;
    viewController.targetName = [NSString stringWithFormat:@"%@", productTarget];
    [viewController awakeFromNib];
    //
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    //
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)openQuestionnaireForAction:(NSDictionary*)questionnaireAction
{
    //Verificação dos campos necessários:
    if ([[questionnaireAction allKeys] containsObject:@"questionnaire"]){
        id q = [questionnaireAction objectForKey:@"questionnaire"];
        if ([q isKindOfClass:[NSDictionary class]]){
            NSDictionary *dicQuestionnaire = (NSDictionary*)q;
            CustomSurvey *survey = [CustomSurvey createObjectFromDictionary:dicQuestionnaire];
            if (survey.formType != SurveyFormTypeUnanswerable){
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CustomSurvey" bundle:nil];
                CustomSurveyMainVC *viewController = (CustomSurveyMainVC *)[storyboard instantiateViewControllerWithIdentifier:@"CustomSurveyMainVC"];
                viewController.showAppMenu = NO;
                viewController.survey = survey;
                [viewController awakeFromNib];
                //
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                //
                [self.navigationController pushViewController:viewController animated:YES];
                
            }
        }
    }
}

#pragma mark - LabVideoPlayerManagerDelegate

- (void)labVideoPlayerManagerDidShowVideoPlayer:(LabVideoPlayerManager* _Nonnull)videoVC
{
    NSLog(@"VideoPlayer >> Show");
}

- (void)labVideoPlayerManagerDidHideVideoPlayer:(LabVideoPlayerManager* _Nonnull)videoVC
{
    NSLog(@"VideoPlayer >> Hide");
}

- (void)labVideoPlayerManager:(LabVideoPlayerManager* _Nonnull)vManager executionError:(NSError* _Nonnull)error
{
    NSLog(@"VideoPlayer >> Error >> %@", error);
}
#pragma mark - Private Methods

-(UIImage*)imageForAction:(NSString*)actionName
{
    //ACTION_MODEL_3D @"Model3DAction"   ***************************************************
    if ([actionName isEqualToString:ACTION_MODEL_3D]){
        return [[UIImage imageNamed:@"ActionIconModel3D"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_VIDEO @"VideoAction"   ***************************************************
    if ([actionName isEqualToString:ACTION_VIDEO]){
        return [[UIImage imageNamed:@"ActionIconVideo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_VIDEO_AR @"VideoArAction"   ***************************************************
    if ([actionName isEqualToString:ACTION_VIDEO_AR]){
        return [[UIImage imageNamed:@"ActionIconVideoAR"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_VIDEO_AR_TRANSP @"VideoArTranspAction"   ***************************************************
    if ([actionName isEqualToString:ACTION_VIDEO_AR_TRANSP]){
        return [[UIImage imageNamed:@"ActionIconVideoART"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_AUDIO @"AudioAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_AUDIO]){
        return [[UIImage imageNamed:@"ActionIconAudio"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_SELL @"SellAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_SELL]){
        return [[UIImage imageNamed:@"ActionIconSell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_PRICE @"PriceAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_PRICE]){
        return [[UIImage imageNamed:@"ActionIconPrice"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_ORDER @"OrderAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_ORDER]){
        return [[UIImage imageNamed:@"ActionIconOrder"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_LIKE @"LikeAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_LIKE]){
        return [[UIImage imageNamed:@"ActionIconLike"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_INFO @"InfoAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_INFO]){
        return [[UIImage imageNamed:@"ActionIconInfo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_DRAW @"DrawAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_DRAW]){
        return [[UIImage imageNamed:@"ActionIconDraw"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_LINK @"LinkAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_LINK]){
        return [[UIImage imageNamed:@"ActionIconLink"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_PHONE @"PhoneAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_PHONE]){
        return [[UIImage imageNamed:@"ActionIconPhone"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_QUIZ @"QuizAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_QUIZ]){
        return [[UIImage imageNamed:@"ActionIconQuiz"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_REGISTER @"RegisterAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_REGISTER]){
        return [[UIImage imageNamed:@"ActionIconRegister"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_RSVP @"RsvpAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_RSVP]){
        return [[UIImage imageNamed:@"ActionIconRSVP"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_TWEET @"TweetAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_TWEET]){
        return [[UIImage imageNamed:@"ActionIconTweet"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_EMAIL @"EmailAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_EMAIL]){
        return [[UIImage imageNamed:@"ActionIconEmail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_COUPON @"CouponAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_COUPON]){
        return [[UIImage imageNamed:@"ActionIconCoupon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_PROMOTION @"PromotionAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_PROMOTION]){
        return [[UIImage imageNamed:@"ActionIconPromotion"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_TURISTIK @"TuristikAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_TURISTIK]){
        return [[UIImage imageNamed:@"ActionIconTuristik"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_SURVEY @"SurveyAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_SURVEY]){
        return [[UIImage imageNamed:@"ActionIconSurvey"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_TRACKING @"TrackingAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_TRACKING]){
        return [[UIImage imageNamed:@"ActionIconTracking"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_MASK @"MaskAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_MASK]){
        return [[UIImage imageNamed:@"ActionIconMask"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_PANORAMA_GALLERY @"PanoramaGalleryAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_PANORAMA_GALLERY]){
        return [[UIImage imageNamed:@"ActionIconPanoramaGallery"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //ACTION_CUSTOM_SURVEY @"CustomSurveyAction"   ***************************************************
    else if ([actionName isEqualToString:ACTION_CUSTOM_SURVEY]){
        return [[UIImage imageNamed:@"ActionIconQuestionnaire"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }

    //???  ***************************************************
    else{
        return [[UIImage imageNamed:@"ActionIconNone"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //Actions do site:
    //AudioAction
    //ArAvatarAction
    //ArOfferAction
    //EmailAction
    //InfoAction
    //LikeAction
    //LinkAction
    //MaskAction
    //OrderAction
    //PhoneAction
    //PriceAction
    //PromotionAction
    //SurveyAction
    //TweetAction
    //VideoAction
    //VideoArAction
    //VideoArTranspAction
    //AppLinkAction
    //DocumentAction
    
}


@end
