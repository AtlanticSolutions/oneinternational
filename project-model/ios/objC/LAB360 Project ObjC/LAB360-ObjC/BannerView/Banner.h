//
//  Banner.h
//  AdAlive
//
//  Created by Lab360 on 2/16/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Banner : NSObject

@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *image_url;
@property(nonatomic, strong) NSString *direct_url;
@property(nonatomic, strong) NSNumber *timer;

-(instancetype)initWithDictionary:(NSDictionary *)dicBanner;


@end
