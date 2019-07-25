//
//  VirtualShowcaseCategory.h
//  LAB360-ObjC
//
//  Created by Erico GT on 14/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultObjectModelProtocol.h"
//
#import "VirtualShowcaseProduct.h"

@interface VirtualShowcaseCategory : NSObject<DefaultObjectModelProtocol>

@property (nonatomic, assign) long categoryID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) NSString *maskModelURL;
@property (nonatomic, strong) NSMutableArray<VirtualShowcaseProduct*> *products;
@property (nonatomic, assign) BOOL isFrontCameraPreferable;
//
@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, strong) UIImage *maskModel;
@property (nonatomic, assign) CGFloat maskAlpha;
@property (nonatomic, strong) UIColor *maskTintColor;
//Control
@property (nonatomic, assign) BOOL selected;

//Protocol Methods:
+ (VirtualShowcaseCategory*)newObject;
+ (VirtualShowcaseCategory*)createObjectFromDictionary:(NSDictionary*)dicData;
- (VirtualShowcaseCategory*)copyObject;
- (NSDictionary*)dictionaryJSON;

@end
