//
//  ColorPalette.h
//  LAB360-ObjC
//
//  Created by Erico GT on 28/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"

@interface ColorPalette : NSObject

//Properties:
@property (nonatomic, strong) UIColor* _Nullable backgroundNormal;
@property (nonatomic, strong) UIColor* _Nullable backgroundLight;
@property (nonatomic, strong) UIColor* _Nullable backgroundDark;
//
@property (nonatomic, strong) UIColor* _Nullable textNormal;
@property (nonatomic, strong) UIColor* _Nullable textLight;
@property (nonatomic, strong) UIColor* _Nullable textDark;
//
@property (nonatomic, strong) UIColor* _Nullable primaryButtonNormal;
@property (nonatomic, strong) UIColor* _Nullable primaryButtonSelected;
@property (nonatomic, strong) UIColor* _Nullable primaryButtonTitleNormal;
@property (nonatomic, strong) UIColor* _Nullable primaryButtonTitleSelected;
//
@property (nonatomic, strong) UIColor* _Nullable secondaryButtonNormal;
@property (nonatomic, strong) UIColor* _Nullable secondaryButtonSelected;
@property (nonatomic, strong) UIColor* _Nullable secondaryButtonTitleNormal;
@property (nonatomic, strong) UIColor* _Nullable secondaryButtonTitleSelected;
//
@property (nonatomic, strong) UIColor* _Nullable defaultButtonNormal;
@property (nonatomic, strong) UIColor* _Nullable defaultButtonSelected;
@property (nonatomic, strong) UIColor* _Nullable defaultButtonTitleNormal;
@property (nonatomic, strong) UIColor* _Nullable defaultButtonTitleSelected;

//Methods:
- (void)applyDefaultColorLayout;
- (void)applyCustomColorLayout:(NSDictionary* _Nonnull)parameters;

@end
