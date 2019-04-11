//
//  VirtualShowcaseProduct.h
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultObjectModelProtocol.h"

@interface VirtualShowcaseProduct : NSObject<DefaultObjectModelProtocol>

@property (nonatomic, assign) long productID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) NSString *maskURL;
//
@property (nonatomic, strong) NSString *leftEyePositionX;
@property (nonatomic, strong) NSString *leftEyePositionY;
@property (nonatomic, strong) NSString *rightEyePositionX;
@property (nonatomic, strong) NSString *rightEyePositionY;
//
@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, strong) UIImage *mask;
@property (nonatomic, strong) UIImage *combinedPhoto;
//Control
@property (nonatomic, assign) BOOL selected;

//Protocol Methods:
+ (VirtualShowcaseProduct*)newObject;
+ (VirtualShowcaseProduct*)createObjectFromDictionary:(NSDictionary*)dicData;
- (VirtualShowcaseProduct*)copyObject;
- (NSDictionary*)dictionaryJSON;

@end
