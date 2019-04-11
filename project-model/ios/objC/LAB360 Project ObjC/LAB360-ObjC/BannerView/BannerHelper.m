//
//  BannerHelper.m
//  AdAlive
//
//  Created by Lab360 on 2/16/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BannerHelper.h"
#import "ConstantsManager.h"
#import "AppDelegate.h"
#import "AdAliveWS.h"
#import "Banner.h"

@interface BannerHelper () <AdAliveWSDelegate>

@end

@implementation BannerHelper

-(instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    
    if (self)
    {
        _delegate = delegate;
    }
    
    return self;
}

- (void)requestBannerToServer
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	AdAliveWS *adaliveWS = [[AdAliveWS alloc] initWithUrlServer:[defaults stringForKey:BASE_APP_URL] andUserEmail:AppD.loggedUser.email error:nil];
	adaliveWS.delegate = self;
	NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
	[adaliveWS findBannerWithAppId:[NSNumber numberWithInt:[appID intValue]]];
}

-(void)didReceiveResponse:(AdAliveWS *)adAliveWs withSuccess:(NSDictionary *)response{
    if ([self.delegate respondsToSelector:@selector(requestFinishedWithSuccess:)])
    {
        NSArray *allKeys = [response allKeys];
        if ([allKeys containsObject:@"banner"])
        {
            Banner *banner = [[Banner alloc] initWithDictionary:[response objectForKey:@"banner"]];
            [self.delegate requestFinishedWithSuccess:banner];
        }
    }
}

-(void)didReceiveResponse:(AdAliveWS *)adAliveWs withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(requestFinishedWithError:)])
    {
        [self.delegate requestFinishedWithError:error];
    }
}


@end
