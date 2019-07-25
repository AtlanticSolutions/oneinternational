//
//  ImageTargetItem.h
//  ARC360
//
//  Created by Erico GT on 25/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTargetItem : NSObject

@property (nonatomic, assign) long targetID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImage *image;

@end

