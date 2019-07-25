//
//  VC_WebFileShareViewer.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/01/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "VC_WebFileShareViewer.h"

/* Others */
#import "AppDelegate.h"

@import WebKit;

@interface VC_WebFileShareViewer ()<WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (strong, nonatomic) WKWebView *webView;
//
@property (nonatomic, strong) NSURL *fileUrlToShare;

@end

@implementation VC_WebFileShareViewer

@synthesize fileURL, fileType, fileUrlToShare, fileTitle, titleScreen;
@synthesize webViewContainer, webView;

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureData];
    
    self.navigationItem.rightBarButtonItem = [self createLoadingView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    fileUrlToShare = [NSURL URLWithString:self.fileURL];
    
    [self loadContentToShare];
    [self configureUI];
}

#pragma mark - Configuration
- (void)configureData {
    [webView setNavigationDelegate:self];
}

- (void)configureUI {
    /* Add a web view to the container */
    CGRect frame = webViewContainer.frame;
    frame.origin.y = 0;
    
    webView = [[WKWebView alloc] initWithFrame:frame];
    [webViewContainer addSubview:webView];
    [webViewContainer setBackgroundColor:nil];
    
    /* Configure the webView */
    NSURL *url = [[NSURL alloc] initWithString:fileURL];
    NSURLRequest *rqst = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:rqst];
    
    /* Setup the title */
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal,
                                                                      NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD
                                                                                                          size:FONT_SIZE_TITLE_NAVBAR]}];
    
    /* Configure the nav controller   */
    if (titleScreen == nil){
        self.navigationItem.title = fileTitle;
    }else{
        self.navigationItem.title = titleScreen;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size
                                                                 byRoundingCorners:UIRectCornerAllCorners
                                                                 cornerRadius:CGSizeZero
                                                                 andColor:AppD.styleManager.colorPalette.backgroundNormal]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1)
                                                             byRoundingCorners:UIRectCornerAllCorners
                                                             cornerRadius:CGSizeZero
                                                             andColor:AppD.styleManager.colorPalette.backgroundNormal]];
}

#pragma mark - WebView
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"WKWebView - delegate: WKWebView did finish the page load");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"WKWebView - delegate: %@", [NSString stringWithFormat:@"WebView error: %@", error.userInfo]);
}

- (void)shareURL:(id)sender
{
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[fileUrlToShare] applicationActivities:nil];
    if (IDIOM == IPAD){
        activityController.popoverPresentationController.sourceView = sender;
    }
    [self presentViewController:activityController animated:YES completion:^{
        NSLog(@"activityController presented");
    }];
}

- (void)loadContentToShare
{
    [[[AsyncImageDownloader alloc] initWithFileURL:fileURL successBlock:^(NSData *data) {
        
        if (data != nil){
            
            // create url
            fileUrlToShare = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.%@", [[fileTitle stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""] , fileType]]];
            // write data
            [data writeToURL:fileUrlToShare atomically:NO];
            //show share button
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareURL:)];
        }
        
    } failBlock:^(NSError *error) {
        self.navigationItem.rightBarButtonItem = nil;
        NSLog(@"Erro ao baixar contrato para compartilhamento: %@", error.domain);
    }] startDownload];
    
}

- (UIBarButtonItem*)createLoadingView
{
    UIActivityIndicatorView *indicatorView;
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.hidesWhenStopped = YES;
    indicatorView.color = [UIColor whiteColor];
    [indicatorView startAnimating];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:indicatorView];
}

@end
