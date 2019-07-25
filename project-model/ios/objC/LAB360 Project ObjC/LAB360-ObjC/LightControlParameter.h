//
//  LightControlParameter.h
//  LAB360-ObjC
//
//  Created by Erico GT on 02/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LightControlParameterTypeGeneric           = 0,
    LightControlParameterTypeIntensity         = 1,
    LightControlParameterTypeTemperature       = 2,
    LightControlParameterTypeColor             = 3,
    LightControlParameterTypeShadowOpacity     = 4,
    LightControlParameterTypeShadowRadius      = 5,
    LightControlParameterTypeEulerAngleX       = 6,
    LightControlParameterTypeEulerAngleY       = 7,
    LightControlParameterTypeEulerAngleZ       = 8,
    LightControlParameterTypeAdditionalLights  = 9
    
} LightControlParameterType;

@interface LightControlParameter : NSObject

//Properties:
@property(nonatomic, assign) LightControlParameterType type;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) float minValue;
@property(nonatomic, assign) float maxValue;
@property(nonatomic, assign) float currentValue;
@property(nonatomic, strong) UIColor *color;

//Methods:
- (LightControlParameter*)copyObject;

@end
