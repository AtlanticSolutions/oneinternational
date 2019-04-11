//
//  AppStyle.h
//  AdAliveStore
//
//  Created by Erico GT on 9/20/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"
#import "BaseLayoutManager.h"
#import "ColorPalette.h"

#define STYLE_MANAGER_DEFAULT_ROUND_CORNER 5.0

@interface AppStyleManager : NSObject

#pragma mark - Properties
@property (nonatomic, strong) UIColor *colorCalendarToday;
@property (nonatomic, strong) UIColor *colorCalendarSelected;
@property (nonatomic, strong) UIColor *colorCalendarRegistered;
@property (nonatomic, strong) UIColor *colorCalendarAvailable;
//
@property (nonatomic, strong) ColorPalette *colorPalette;

#pragma mark - Layout Manager
@property (nonatomic, strong) BaseLayoutManager *baseLayoutManager;

@end
