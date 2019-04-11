//
//  VideoPlayerViewController.m
//  AdAlive
//
//  Created by Monique Trevisan on 10/8/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import "LinkViewController.h"
#import "AppDelegate.h"

@interface LinkViewController ()

@property(nonatomic, weak) IBOutlet UIWebView *wvVideo;

@end

@implementation LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(youTubeStarted:)
                                                 name:UIWindowDidBecomeVisibleNotification
                                               object:self.view.window
     ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(youTubeFinished:)
                                                 name:UIWindowDidBecomeHiddenNotification
                                               object:self.view.window
     ];

    
    UIImageView *imageView;
    
#ifdef WILVALE
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-navbar3"]];
#elif NATURA
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-navbar-natura"]];
#elif ETNA
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
#elif IPIRANGA
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
#elif HINODE
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
#endif
    
    UIBarButtonItem *logoView = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.rightBarButtonItem = logoView;
    
//    float width = 320.0f;
//    float height = 400.0f;
////
//    [self.wvVideo setFrame:CGRectMake(0, 64, width, height)];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.stringHref hasPrefix:@"http://"] && ![self.stringHref hasPrefix:@"https://"])
    {
        self.stringHref = [NSString stringWithFormat:@"http://%@", self.stringHref];
    }
    
    NSURL *urlVideo = [[NSURL alloc] initWithString:self.stringHref];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlVideo];
    
    [self.wvVideo loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Orientation methods

- (BOOL)shouldAutorotate
{
    return YES;
}

-(void)youTubeStarted:(NSNotification *)notification
{
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.youtube = (UIWindow *)notification.object;
}

-(void)youTubeFinished:(NSNotification *)notification
{
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.youtube = nil;
}

@end
