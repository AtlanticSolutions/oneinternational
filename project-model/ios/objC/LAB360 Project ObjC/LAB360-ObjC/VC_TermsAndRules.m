//
//  VC_PromotionTerms.m
//  ShoppingBH
//
//  Created by Erico GT on 03/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_TermsAndRules.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_TermsAndRules()

//@property (nonatomic, strong) WebItemToShow *webItem;
//
@property(nonatomic, weak) IBOutlet UIWebView *wView;
@property(nonatomic, weak) IBOutlet UIButton *btnAcept;
@property(nonatomic, weak) IBOutlet UILabel *lblError;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *bottomWebViewConstraint;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;
//
@property(nonatomic, assign) bool loadingTermsErrorDetected;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_TermsAndRules
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize screenType, webItem, loadingTermsErrorDetected;
@synthesize wView, btnAcept, lblError, activityIndicator, bottomWebViewConstraint;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //MARK:
    
//    if (screenType == eTermsAndRulesScreenType_Promotion){
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(actionBackNavigationController:)];
    
//    }
//    else{
//        self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
//    }
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
    
    loadingTermsErrorDetected = false;
    
    //[wView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webItem.urlString]]];
    
    if (webItem == nil) {
        
        wView.alpha = 0.0;
        lblError.alpha = 1.0;
        
//        ConnectionManager *connection = [[ConnectionManager alloc] init];
//        NSString *url = [NSString stringWithFormat:@"%@%@", connection.serverPreference, SERVICE_URL_FIXED_APP_REGULAMENTATION];
//        [wView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        
    }else{
        
        wView.alpha = 1.0;
        lblError.alpha = 0.0;
        //
        [wView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webItem.urlString]]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //
    if ([wView isLoading]){
        [wView stopLoading];
    }
    [activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionAcceptTerms:(id)sender
{
    if (loadingTermsErrorDetected){
            //Tenta recarregar os termos novamente:
            [wView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webItem.urlString]]];
    }else{
        //TODO
    }
}

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
    loadingTermsErrorDetected = false;
    lblError.alpha = 0.0;
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
    //Para o type 'eTermsAndRulesScreenType_Promotion' não se faz nada pois o botão está oculto

    //Para outros, se necessário:
//    bottomWebViewConstraint.constant = 44.0;
//    [self.view layoutIfNeeded];
//    btnAcept.alpha = 1.0;
//    [btnAcept setTitle:@"Tentar Novamente" forState:UIControlStateNormal];
//    [btnAcept setTitle:@"Tentar Novamente" forState:UIControlStateHighlighted];
    
    [activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    lblError.alpha = 1.0;
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
    
    self.navigationItem.title = webItem.titleMenu;
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.color = [UIColor whiteColor];
    activityIndicator.hidesWhenStopped = true;
    [activityIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    lblError.backgroundColor = nil;
    lblError.textColor = [UIColor grayColor];
    lblError.text = NSLocalizedString(@"LABEL_TERMS_AND_RULES_NO_DATA", @"");
    lblError.alpha = 0.0;
    
    [btnAcept setExclusiveTouch:YES];
    if (screenType == eTermsAndRulesScreenType_Promotion){
        btnAcept.backgroundColor = [UIColor clearColor];
        [btnAcept setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnAcept.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
        [btnAcept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAcept setTitle:NSLocalizedString(@"BUTTON_TITLE_TERMS_ACCEPT", @"") forState:UIControlStateNormal];
        //
        btnAcept.alpha = 0.0;
        bottomWebViewConstraint.constant = 0.0;
        [self.view layoutIfNeeded];
    }
    
}

- (void)actionBackNavigationController:(id)sender
{
    //MARK: Possíveis validações podem ocorrer aqui:
    
    if (screenType == eTermsAndRulesScreenType_Promotion){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
