//
//  ZoneActionInfoView.h
//  LAB360-ObjC
//
//  Created by Erico GT on 04/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoneAction.h"

@class ZoneActionInfoView;

@protocol ZoneActionInfoViewDelegate
@required
- (void)zoneActionInfoViewExecuteCloseAction:(ZoneActionInfoView*)infoView;
@end

@interface ZoneActionInfoView : UIView

@property(nonatomic, strong, readonly) ZoneAction* currentZoneAction;

+ (ZoneActionInfoView*)newZoneActionInfoViewWithFrame:(CGRect)frame andDelegate:(id<ZoneActionInfoViewDelegate>)delegate;

- (void)updateContentToZoneAction:(ZoneAction*)zoneAction;

@end
