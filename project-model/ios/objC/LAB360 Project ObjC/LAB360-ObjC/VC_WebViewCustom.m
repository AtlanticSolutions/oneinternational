//
//  VC_WebViewCustom.m
//  LAB360-ObjC
//
//  Created by Rodrigo Baroni on 24/05/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//
#pragma mark - • HEADER IMPORT
#import "VC_WebViewCustom.h"
#import <WebKit/WebKit.h>

#pragma mark - • INTERFACE PRIVATE PROPERTIES

@interface VC_WebViewCustom ()<WKNavigationDelegate, WKUIDelegate>

@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (strong, nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *viewButtons;
@property (weak, nonatomic) IBOutlet UIButton *btnReloadCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnGoForward;
@property (weak, nonatomic) IBOutlet UIButton *btnGoBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewButtons;

@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, strong) NSURL *fileUrlToShare;
@property (nonatomic, assign) BOOL isFileDownload;
@end

#pragma mark - • IMPLEMENTATION

@implementation VC_WebViewCustom

#pragma mark - • I_VARS

#pragma mark - • SYNTESIZES

@synthesize fileURL, fileType, titleNav, fileUrlToShare, isFileDownload, fileName, checkUrl;
@synthesize webViewContainer, webView, viewButtons;
@synthesize btnGoBack, btnGoForward, btnReloadCancel, showShareButton, hideViewButtons;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

-(id)init
{
    if (self = [super init])
    {
        fileURL = @"";
        fileType = @"";
        titleNav = @"";
        fileName = @"";
        hideViewButtons = NO;
        showShareButton = YES;
        
    }
    return self;
}

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    
    [self setupLayout:titleNav];
    
    if (showShareButton) {
        if ([self isFileURL:fileURL]){
            self.navigationItem.rightBarButtonItem = [self createLoadingView];
            [self loadContentToShare];
        }else{
            fileUrlToShare = [NSURL URLWithString:fileURL];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareURLWeb:)];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.view layoutIfNeeded];
    [self configureWebViewController];
    [self updateButtons];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionGoBack:(UIButton *)sender {
    [webView goBack];
    [self updateButtons];
}

- (IBAction)actionGoForward:(UIButton *)sender {
    [webView goForward];
    [self updateButtons];
}
- (IBAction)actionReloadCancel:(UIButton *)sender {
    
    if(webView.isLoading){
        [webView stopLoading];
    } else {
        [webView reload];
    }
}


#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • WKWEBVIEW

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"WKWebView - delegate: WKWebView did finish the page load");
    [self updateButtons];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"WKWebView - delegate: WKWebView did finish the page load");
    [self updateButtons];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"WKWebView - delegate: %@", [NSString stringWithFormat:@"WebView error: %@", error.userInfo]);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateButtons];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    viewButtons.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    self.view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    self.viewButtons.translatesAutoresizingMaskIntoConstraints = NO;
    if (hideViewButtons){
        self.constraintViewButtons.constant = 0;
    } else {
        self.constraintViewButtons.constant = 46;
    }
    
    [btnGoBack setBackgroundColor:[UIColor clearColor]];
    [btnGoBack setImage:[[UIImage imageNamed:@"CWV_ArrowLeft"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnGoBack setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    
    [btnGoForward setBackgroundColor:[UIColor clearColor]];
    [btnGoForward setImage:[[UIImage imageNamed:@"CWV_ArrowRight"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnGoForward setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    
    [btnReloadCancel setBackgroundColor:[UIColor clearColor]];
    [btnReloadCancel setImage:[[UIImage imageNamed:@"CWV_Reload"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnReloadCancel setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];

}

- (void)updateButtons
{
    btnGoForward.enabled = webView.canGoForward;
    btnGoBack.enabled = webView.canGoBack;
    
    if(webView.isLoading){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [btnReloadCancel setBackgroundColor:[UIColor clearColor]];
        [btnReloadCancel setImage:[[UIImage imageNamed:@"CWV_Stop"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [btnReloadCancel setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    }else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [btnReloadCancel setBackgroundColor:[UIColor clearColor]];
        [btnReloadCancel setImage:[[UIImage imageNamed:@"CWV_Reload"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [btnReloadCancel setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    }
}

- (void) configureWebViewController {
    
    if(checkUrl) {
        
        ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
        
        if ([connectionManager isConnectionActive])
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
            });
            
            [connectionManager getUrlForSMWebViewWithUrl:fileURL withCompletionHandler:^(NSDictionary * _Nonnull response, NSInteger statusCode, NSError * _Nonnull error) {
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                
                if (error){
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CATEGORY_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }else{
                    
                    if ([response.allKeys containsObject:@"url"]){
                        
                        /* Add a web view to the container */
                        CGRect frame = webViewContainer.frame;
                        frame.origin.y = 0;
                        
                        webView = [[WKWebView alloc] initWithFrame:frame];
                        [webViewContainer addSubview:webView];
                        [webViewContainer setBackgroundColor: [UIColor grayColor]];
                        
                        webView.UIDelegate = self;
                        [webView setNavigationDelegate:self];
                        
                        /* Configure the webView */
                        NSURL *url = [[NSURL alloc] initWithString:[response valueForKey:@"url"]];
                        NSURLRequest *rqst = [[NSURLRequest alloc] initWithURL:url];
                        [webView loadRequest:rqst];
                        
                    }
                }
            }];
            
        }
        else
        {
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
        

    } else {
        
        /* Add a web view to the container */
        CGRect frame = webViewContainer.frame;
        frame.origin.y = 0;
        
        webView = [[WKWebView alloc] initWithFrame:frame];
        [webViewContainer addSubview:webView];
        [webViewContainer setBackgroundColor: [UIColor grayColor]];
        
        webView.UIDelegate = self;
        [webView setNavigationDelegate:self];
        
        /* Configure the webView */
        NSURL *url = [[NSURL alloc] initWithString:fileURL];
        NSURLRequest *rqst = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:rqst];
        
    }

}

- (void)shareURLWeb:(id)sender{
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[fileUrlToShare] applicationActivities:nil];
    if (IDIOM == IPAD){
        activityController.popoverPresentationController.sourceView = sender;
    }
    [self presentViewController:activityController animated:YES completion:^{
        NSLog(@"activityController presented");
    }];
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
            NSString *fName = [ToolBox textHelper_CheckRelevantContentInString:fileName] ? fileName : @"file";
            fileUrlToShare = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.%@", fName, fileType]]];
                                                                                            
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


- (BOOL)isFileURL:(NSString *)url
{
    NSString *upperURL = [url uppercaseString];
    
    if ([upperURL hasSuffix:@"TXT"]){
        fileType = @"txt";
        return YES;
    } else if ([upperURL hasSuffix:@"PDF"]){
        fileType = @"pdf";
        return YES;
    } else if ([upperURL hasSuffix:@"DOC"]){
        fileType = @"doc";
        return YES;
    } else if ([upperURL hasSuffix:@"DOCX"]){
        fileType = @"docx";
        return YES;
    } else if ([upperURL hasSuffix:@"JPG"]){
        fileType = @"jpg";
        return YES;
    } else if ([upperURL hasSuffix:@"JPEG"]){
        fileType = @"jpeg";
        return YES;
    } else if ([upperURL hasSuffix:@"PNG"]){
        fileType = @"png";
        return YES;
    } else if ([upperURL hasSuffix:@"GIF"]){
        fileType = @"gif";
        return YES;
    } else if ([upperURL hasSuffix:@"TIF"]){
        fileType = @"tif";
        return YES;
    } else if ([upperURL hasSuffix:@"TIFF"]){
        fileType = @"tiff";
        return YES;
    } else if ([upperURL hasSuffix:@"MP3"]){
        fileType = @"mp3";
        return YES;
    } else if ([upperURL hasSuffix:@"WAV"]){
        fileType = @"wav";
        return YES;
    } else if ([upperURL hasSuffix:@"AIFF"]){
        fileType = @"aiff";
        return YES;
    } else if ([upperURL hasSuffix:@"FLAC"]){
        fileType = @"flac";
        return YES;
    } else if ([upperURL hasSuffix:@"MP4"]){
        fileType = @"mp4";
        return YES;
    } else if ([upperURL hasSuffix:@"WEBM"]){
        fileType = @"webm";
        return YES;
    } else if ([upperURL hasSuffix:@"MKV"]){
        fileType = @"mkv";
        return YES;
    } else if ([upperURL hasSuffix:@"VOB"]){
        fileType = @"vob";
        return YES;
    } else if ([upperURL hasSuffix:@"MOV"]){
        fileType = @"mov";
        return YES;
    } else if ([upperURL hasSuffix:@"M4V"]){
        fileType = @"m4v";
        return YES;
    } else if ([upperURL hasSuffix:@"AVI"]){
        fileType = @"avi";
        return YES;
    } else if ([upperURL hasSuffix:@"WAV"]){
        fileType = @"wav";
        return YES;
    } else if ([upperURL hasSuffix:@"3GP"]){
        fileType = @"3gp";
        return YES;
    }
    
    return NO;
}

@end
