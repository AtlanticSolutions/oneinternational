//
//  VirtualShowcasePhoto.h
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VirtualShowcasePhoto : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *fileURL;
@property (nonatomic, assign) BOOL selected;

@end
