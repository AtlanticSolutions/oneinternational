//
//  LightControlView.h
//  LAB360-ObjC
//
//  Created by Erico GT on 02/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LightControlParameter.h"

@class LightControlView;

@protocol LightControlViewDelegate
@required
- (NSString*)lightControlView:(LightControlView*)lcView textForUpdatedParameterValue:(LightControlParameter*)updatedParameter;
@end

@interface LightControlView : UIView

//Properties
@property (nonatomic, weak) id<LightControlViewDelegate> viewDelegate;

//Methods
+ (LightControlView*)newLightControlViewWithFrame:(CGRect)frame parameter:(LightControlParameter*)lightParameter andDelegate:(id<LightControlViewDelegate>)delegate;
- (void)updateWithParameter:(LightControlParameter*)newParameter;
- (LightControlParameterType)currentParameterType;

@end

