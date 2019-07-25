//
//  VC_WebDocumentsViewer.m
//  ShoppingBH
//
//  Created by Erico GT on 10/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_WebDocumentsViewer.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_WebDocumentsViewer()

//Layout
@property(nonatomic, weak) IBOutlet UIWebView *wView;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;
//Data
@property(nonatomic, strong) NSMutableArray *masterDownloadsList;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_WebDocumentsViewer
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize wView, activityIndicator;
@synthesize masterDownloadsList;

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
    self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SIDE_MENU_OPTION_7_CHRISTMAS_SCHEDULE", @"");
    
    masterDownloadsList = [NSMutableArray new];
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
    
    [self loadMasterEventFiles];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

//MARK: Web View Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL);
    //
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"WebView StartLoad");
    //
    [activityIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //
    wView.alpha = 1.0;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"WebView FinishLoad");
    //
    [activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_NO_FILES_AVAILABLE", @"") subTitle:@"Não é possível abrir o arquivo solicitado neste momento. Por favor, tente mais tarde." closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    
    wView.alpha = 0.0;
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
    
    //self.navigationController.toolbar.translucent = YES;
    
    [wView setBackgroundColor:[UIColor whiteColor]];
    [wView setClipsToBounds:YES];
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.color = [UIColor whiteColor];
    activityIndicator.hidesWhenStopped = true;
    [activityIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
}

-(void)loadMasterEventFiles
{
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });
    
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive])
    {
        //connection.delegate = self;
        [connection getDownloadsForMasterEvent:AppD.masterEventID withCompletionHandler:^(NSDictionary *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_MASTER_DOWNLOAD_NODATA_RESPONSE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            }else{
                
                if (response){
                    NSArray *result = [[NSArray alloc] initWithArray:[response valueForKey:@"documents"]];
                    for (NSDictionary *dic in result){
                        [masterDownloadsList addObject:[DownloadItem createObjectFromDictionary:dic]];
                    }
                    
                    if (masterDownloadsList.count == 0){
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_NO_FILES_AVAILABLE", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_MASTER_FILES_AVAILABLE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }else{
                        
                        DownloadItem *docToShow = [masterDownloadsList firstObject];
                        [wView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:docToShow.urlFile]]];
                        [activityIndicator startAnimating];
                    }
                    
                }else{
                    //No response
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_FILES_AVAILABLE", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_MASTER_FILES_AVAILABLE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }
            }
        }];
        
    }else{
        
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}


@end
