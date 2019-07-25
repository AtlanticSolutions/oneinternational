//
//  ZoneAction.m
//  LAB360-ObjC
//
//  Created by Erico GT on 03/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "ZoneAction.h"
#import "NavigationZone.h"
#import "ToolBox.h"

@implementation ZoneAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.actionID = 0;
        self.positionInImage = CGPointZero;
        self.positionInView = CGPointZero;
        self.infoTitle = nil;
        self.infoMessage = nil;
        self.infoImage = nil;
        self.infoImageURL = nil;
        self.type = ZoneActionTypeInfo;
        self.orientation = ZoneActionOrientation_N;
        self.destinationZone = nil;
    }
    return self;
}

- (ZoneAction*)copyObject
{
    ZoneAction *actionCopy = [ZoneAction new];
    actionCopy.actionID = self.actionID;
    actionCopy.positionInImage = self.positionInImage;
    actionCopy.positionInView = self.positionInView;
    actionCopy.infoTitle = self.infoTitle != nil ? [NSString stringWithFormat:@"%@", self.infoTitle] : nil;
    actionCopy.infoMessage = self.infoMessage != nil ? [NSString stringWithFormat:@"%@", self.infoMessage] : nil;
    actionCopy.infoImage = self.infoImage != nil ? [UIImage imageWithData:UIImagePNGRepresentation(self.infoImage)] : nil;
    actionCopy.infoImageURL = self.infoImageURL != nil ? [NSString stringWithFormat:@"%@", self.infoImageURL] : nil;
    actionCopy.type = self.type;
    actionCopy.orientation = self.orientation;
    actionCopy.destinationZone = self.destinationZone != nil ? [self.destinationZone copyObject] : nil;
    //
    return actionCopy;
}

- (UIButton*)createFriendlyButtonWithSize:(CGSize)size
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.positionInView.x - (size.width / 2.0)), (self.positionInView.y - (size.height / 2.0)), size.width, size.height)];
    //
    button.backgroundColor = nil;
    [button setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:button.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:[UIColor colorWithWhite:0.0 alpha:0.5]] forState:UIControlStateNormal];
    [button setImage:[self defaultImageButton] forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button setImageEdgeInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setExclusiveTouch:YES];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.tag = self.actionID;
    //
    return button;
}

- (UIImage*)defaultImageButton
 {
     UIImage *img = nil;
     
     if (self.type == ZoneActionTypeInfo){
         img = [UIImage imageNamed:@"ZoneActionPinInfo"];
     }else{
         switch (self.orientation) {
            case ZoneActionOrientation_N:{ img = [UIImage imageNamed:@"ZoneActionPinOrientationN"]; }break;
            case ZoneActionOrientation_NE:{ img = [UIImage imageNamed:@"ZoneActionPinOrientationNE"]; }break;
            case ZoneActionOrientation_E:{ img = [UIImage imageNamed:@"ZoneActionPinOrientationE"]; }break;
            case ZoneActionOrientation_SE:{ img = [UIImage imageNamed:@"ZoneActionPinOrientationSE"]; }break;
            case ZoneActionOrientation_S:{ img = [UIImage imageNamed:@"ZoneActionPinOrientationS"]; }break;
            case ZoneActionOrientation_SW:{ img = [UIImage imageNamed:@"ZoneActionPinOrientationSW"]; }break;
            case ZoneActionOrientation_W:{ img = [UIImage imageNamed:@"ZoneActionPinOrientationW"]; }break;
            case ZoneActionOrientation_NW:{ img = [UIImage imageNamed:@"ZoneActionPinOrientationNW"]; }break;
         }
     }
     
     return [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
 }
     
@end
