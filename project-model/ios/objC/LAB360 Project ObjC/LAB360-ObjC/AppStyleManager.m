//
//  AppStyle.m
//  AdAliveStore
//
//  Created by Erico GT on 9/20/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "AppStyleManager.h"

@implementation AppStyleManager

#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self)
    {
        baseLayoutManager = [BaseLayoutManager createNewBaseLayoutAppUsingStoredValues];
        colorPalette = [ColorPalette new];
        [self defaultColorLayout];
    }
    
    return self;
}

@synthesize colorPalette, baseLayoutManager, colorCalendarToday, colorCalendarSelected, colorCalendarRegistered, colorCalendarAvailable;

#pragma mark - Layout Manager

- (void)defaultColorLayout
{
    //A classe inicializa no modo padrão sempre:
    colorCalendarToday = [UIColor colorWithRed:244.0/255.0 green:193.0/255.0 blue:66.0/255.0 alpha:1.0];
    colorCalendarSelected = [UIColor colorWithRed:1.0/255.0 green:55.0/255.0 blue:91.0/255.0 alpha:1.0];
    colorCalendarRegistered = [UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:90.0/255.0 alpha:1.0];
    colorCalendarAvailable = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
    //
    [colorPalette applyDefaultColorLayout];
}

@end
