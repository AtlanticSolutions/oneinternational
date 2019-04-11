//
//  BannerView.m
//  AdAlive
//
//  Created by Lab360 on 2/16/16.
//  Copyright © 2016 Lab360. All rights reserved.
//


#import "BannerView.h"
#import "BannerHelper.h"
#import "Banner.h"
#import "AdAliveWS.h"
#import "AppDelegate.h"

@interface BannerView () <BannerHelperDelegate, AdAliveWSDelegate>

@property(nonatomic , strong) BannerHelper *bannerHelper;
@property(nonatomic , strong) Banner *banner;

@end

@implementation BannerView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.bannerHelper = [[BannerHelper alloc] initWithDelegate:self];
        self.contentMode = UIViewContentModeScaleAspectFit;
        [_bannerHelper performSelector:@selector(requestBannerToServer)];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];

    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognizer];
}

-(void)layoutIfNeeded
{
    [super layoutIfNeeded];
}

-(void)reestartTimerWithBanner:(Banner *)banner
{
    [NSTimer scheduledTimerWithTimeInterval:[banner.timer integerValue]*1000 target:self selector:@selector(finishTimer:) userInfo:nil repeats:NO];
}

-(void)finishTimer:(NSTimer *)timer
{
    [self.bannerHelper requestBannerToServer];
}

#pragma mark - Banner Helper delegate

-(void)requestFinishedWithSuccess:(Banner *)banner
{
    self.banner = banner;
    NSURL *urlImageBanner = [NSURL URLWithString:self.banner.image_url];
    
    [self downloadImageWithURL:urlImageBanner completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            self.image = image;
        }
    }];
    
//    [self reestartTimerWithBanner: banner];
}

-(void)requestFinishedWithError:(NSError *)error
{
    self.banner = [[Banner alloc] init];
    self.banner.direct_url = @"http://ad-alive.com";
    self.image = [UIImage imageNamed:@"banner"];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   self.banner = [[Banner alloc] init];
                                   self.banner.direct_url = @"http://ad-alive.com";
                                   self.image = [UIImage imageNamed:@"banner"];
                                   completionBlock(NO,nil);
                               }
                           }];
}

#pragma mark - Gesture Methods

-(void)handleTap:(UITapGestureRecognizer *)tapGesture
{
    if(self.banner.id)
    {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		AdAliveWS *adaliveWS = [[AdAliveWS alloc] initWithUrlServer:[defaults stringForKey:BASE_APP_URL] andUserEmail:AppD.loggedUser.email error:nil];
		adaliveWS.delegate = self;
		
		NSNumber *bannerId = [NSNumber numberWithInteger:[self.banner.id integerValue]];
		[adaliveWS clickBannerLog:bannerId destinationURL:self.banner.direct_url];
		
    }

    if ([self.delegate respondsToSelector:@selector(didTapOnBannerView:withLink:)])
    {
        [self.delegate didTapOnBannerView:self withLink:self.banner.direct_url];
    }
}

@end
