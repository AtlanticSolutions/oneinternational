//
//  NavigationZone.h
//  LAB360-ObjC
//
//  Created by Erico GT on 03/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoneAction.h"

@interface NavigationZone : NSObject

//Properties:
@property(nonatomic, assign) long zoneID;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) UIImage* image;
@property(nonatomic, strong) NSString* urlImage;
@property(nonatomic, strong) NSMutableArray<ZoneAction*>* actions;
@property(nonatomic, assign) CGPoint enterPosition;

//Methods:
- (NavigationZone*)copyObject;

@end
