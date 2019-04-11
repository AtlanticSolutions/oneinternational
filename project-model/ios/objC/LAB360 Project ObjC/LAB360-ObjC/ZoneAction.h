//
//  ZoneAction.h
//  LAB360-ObjC
//
//  Created by Erico GT on 03/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZoneActionTypeInfo            = 2,
    ZoneActionTypeDirection       = 3
} ZoneActionType;

typedef enum {
    ZoneActionOrientation_N         = 1,
    ZoneActionOrientation_NE        = 2,
    ZoneActionOrientation_E         = 3,
    ZoneActionOrientation_SE        = 4,
    ZoneActionOrientation_S         = 5,
    ZoneActionOrientation_SW        = 6,
    ZoneActionOrientation_W         = 7,
    ZoneActionOrientation_NW        = 8
} ZoneActionOrientation;

@class NavigationZone;

@interface ZoneAction : NSObject

//Properties:
@property(nonatomic, assign) long actionID;
@property(nonatomic, assign) CGPoint positionInImage;
@property(nonatomic, assign) CGPoint positionInView;
@property(nonatomic, assign) ZoneActionType type;
//
@property(nonatomic, strong) NSString* infoTitle;
@property(nonatomic, strong) NSString* infoMessage;
@property(nonatomic, strong) UIImage* infoImage;
@property(nonatomic, strong) NSString* infoImageURL;
//
@property(nonatomic, assign) ZoneActionOrientation orientation;
@property(nonatomic, strong) NavigationZone* destinationZone;

//Methods:
- (ZoneAction*)copyObject;

- (UIButton*)createFriendlyButtonWithSize:(CGSize)size;

@end
