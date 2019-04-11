//
//  BannerHelper.h
//  AdAlive
//
//  Created by Lab360 on 2/16/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Banner;
@protocol BannerHelperDelegate <NSObject>

-(void)requestFinishedWithSuccess:(Banner *)banner;
-(void)requestFinishedWithError:(NSError *)error;

@end

@interface BannerHelper : NSObject

@property(nonatomic, assign) id<BannerHelperDelegate> delegate;

-(instancetype)initWithDelegate:(id)delegate;
- (void)requestBannerToServer;

@end
