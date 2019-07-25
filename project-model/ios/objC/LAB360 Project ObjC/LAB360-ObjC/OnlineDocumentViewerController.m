//
//  OnlineDocumentViewerController.m
//  LAB360-ObjC
//
//  Created by Erico GT on 27/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "OnlineDocumentViewerController.h"
@import WebKit;

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface OnlineDocumentViewerController()<WKNavigationDelegate>

@property (nonatomic, weak) IBOutlet UIView *webViewContainer;
@property (nonatomic, strong) WKWebView *webView;
//
@property (nonatomic, strong) NSURL *fileUrlToShare;

@end

#pragma mark - • IMPLEMENTATION
@implementation OnlineDocumentViewerController
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize documentURL, documentName, allowsShareDoc, useSimpleReturnButton;
@synthesize webViewContainer, webView, fileUrlToShare;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    
    if (documentName == nil || [documentName isEqualToString:@""]){
        //TODO: trocar o nome conforme a necessidade!
        self.navigationItem.title = @"Document Viewer";
    }else{
        self.navigationItem.title = documentName;
    }
    
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
    
    if (!useSimpleReturnButton){
        self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
    }
    
    self.navigationItem.rightBarButtonItem = [self createLoadingView];
    if (allowsShareDoc){
         [self loadContentToShare];
    }
    
    //Load content:
    NSURL *url = [[NSURL alloc] initWithString:documentURL];
    NSURLRequest *rqst = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:rqst];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - WebView
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"WKWebView - delegate: WKWebView did finish the page load");
    
    if (!allowsShareDoc){
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"WKWebView - delegate: %@", [NSString stringWithFormat:@"WebView error: %@", error.userInfo]);
    
    if (!allowsShareDoc){
        self.navigationItem.rightBarButtonItem = nil;
    }
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
    
    /* Add a web view to the container */
    CGRect frame = webViewContainer.frame;
    frame.origin.x = 0.0;
    frame.origin.y = 0.0;
    
    webView = [[WKWebView alloc] initWithFrame:frame];
    [webView setNavigationDelegate:self];
    [webViewContainer addSubview:webView];
    [webViewContainer setBackgroundColor:nil];
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
    [[[AsyncImageDownloader alloc] initWithFileURL:documentURL successBlock:^(NSData *data) {
        if (data != nil){
            //URL local para guardar o documento temporariamente:
            fileUrlToShare = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"temp_doc.pdf"]];
            
            if ([data writeToURL:fileUrlToShare atomically:NO]){
                //Habilita o botão de compartilhamento:
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareURL:)];
            }else{
                self.navigationItem.rightBarButtonItem = nil;
            }
            
        }
    } failBlock:^(NSError *error) {
        self.navigationItem.rightBarButtonItem = nil;
        NSLog(@"Erro ao baixar documento para visualização: %@", error.domain);
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
