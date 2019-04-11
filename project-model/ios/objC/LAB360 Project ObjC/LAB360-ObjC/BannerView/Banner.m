//
//  Banner.m
//  AdAlive
//
//  Created by Lab360 on 2/16/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import "Banner.h"

@implementation Banner

-(instancetype)initWithDictionary:(NSDictionary *)dicBanner
{
    self = [super init];
    
    if (self)
    {
        self.id = [dicBanner objectForKey:@"id"];
        self.image_url = [dicBanner objectForKey:@"image_url"];
        self.direct_url = [dicBanner objectForKey:@"href"];
        self.timer = [dicBanner objectForKey:@"timer"];
    }
    
    return self;
}

@end
