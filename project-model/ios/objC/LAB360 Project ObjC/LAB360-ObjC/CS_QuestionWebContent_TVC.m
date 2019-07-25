//
//  CS_QuestionWebContent_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 06/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_QuestionWebContent_TVC.h"

@interface CS_QuestionWebContent_TVC()

//@property (nonatomic, assign) float aspectRatio;

@end

@implementation CS_QuestionWebContent_TVC

@synthesize headerView, containerView, lblHint, btnControl, indicatorView, webView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //hint
    lblHint.backgroundColor = [UIColor clearColor];
    lblHint.textColor = [UIColor grayColor];
    [lblHint setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    lblHint.text = @"";
    
    //control
    [btnControl setBackgroundColor:[UIColor lightGrayColor]];
    [btnControl setTitle:@"" forState:UIControlStateNormal];
    [btnControl setExclusiveTouch:YES];
    [btnControl.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnControl setImageEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)];
    [btnControl setImage:nil forState:UIControlStateNormal];
    [btnControl setTintColor:[UIColor whiteColor]];
    [btnControl setClipsToBounds:YES];
    btnControl.layer.cornerRadius = 4.0;
    [btnControl setEnabled:NO];
    
    //content
    [containerView setBackgroundColor: [UIColor whiteColor]];
    [containerView setClipsToBounds:YES];
    containerView.layer.cornerRadius = 5.0;
    containerView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
    containerView.layer.borderWidth = 1.5;
    
    [headerView setBackgroundColor: [UIColor whiteColor]];
    headerView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
    headerView.layer.borderWidth = 1.5;
    
    //indicator
    indicatorView.color = [UIColor grayColor];
    [indicatorView setHidesWhenStopped:YES];
    [indicatorView stopAnimating];
    
    //webview
    if (webView){
        [webView stopLoading];
        [webView removeFromSuperview];
        webView.UIDelegate = nil;
        webView.navigationDelegate = nil;
        webView = nil;
    }
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    if (element.question.discreteDisplay){
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    //hint
    lblHint.text = element.question.hint;
    
    //control
    
    //webview
    if ([ToolBox textHelper_CheckRelevantContentInString:element.question.webContentURL]){
        CGRect frame = CGRectMake(0.0, 36.0, containerView.frame.size.width, containerView.frame.size.height - 36.0);
        
        webView = [[WKWebView alloc] initWithFrame:frame];
        
        [webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        [containerView addSubview:webView];
        
        webView.UIDelegate = self;
        [webView setNavigationDelegate:self];
        
        NSURL *url = [[NSURL alloc] initWithString:element.question.webContentURL];
        NSURLRequest *rqst = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:rqst];
        //
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [indicatorView startAnimating];
        //
        [btnControl setEnabled:YES];
    }
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    
    if ([parametersData isKindOfClass:[CustomSurveyCollectionElement class]]){
        
        CustomSurveyCollectionElement *element = (CustomSurveyCollectionElement*)parametersData;
        
        CGFloat usableWidth = containerWidth - 20.0;
        CGFloat aspect = element.question.webContentAspectRatio;
        CGFloat usableHeight = (usableWidth / aspect) + 20.0 + 36.0;
        //
        return usableHeight;
        
    }else{
        
        return UITableViewAutomaticDimension;
    }
}

#pragma mark - Internal

- (IBAction)actionWebViewControl:(id)sender
{
    if(webView.isLoading){
        [webView stopLoading];
        //
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [indicatorView stopAnimating];
    }else{
        [webView reload];
        //
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [indicatorView startAnimating];
    }
}

- (void)updateControlButton
{
    if(webView.isLoading){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [indicatorView startAnimating];
        [btnControl setImage:[[UIImage imageNamed:@"CWV_Stop"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [btnControl setTintColor:COLOR_MA_RED];
    }else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [indicatorView stopAnimating];
        [btnControl setImage:[[UIImage imageNamed:@"CWV_Reload"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [btnControl setTintColor:COLOR_MA_BLUE];
    }
}

#pragma mark - WebView Delegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"WKWebView - delegate: WKWebView did finish the page load");
    [self updateControlButton];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"WKWebView - delegate: WKWebView did finish the page load");
    [self updateControlButton];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"WKWebView - delegate: %@", [NSString stringWithFormat:@"WebView error: %@", error.userInfo]);
    [self updateControlButton];
}

@end
