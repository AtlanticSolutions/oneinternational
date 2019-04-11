//
//  LightControlParameter.m
//  LAB360-ObjC
//
//  Created by Erico GT on 02/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "LightControlParameter.h"

@implementation LightControlParameter

@synthesize type, name, minValue, maxValue, currentValue, color;

- (instancetype)init
{
    self = [super init];
    if (self) {
        type = LightControlParameterTypeGeneric;
        name = @"";
        minValue = 0.0;
        maxValue = 1.0;
        currentValue = 0.5;
        color = [UIColor whiteColor];
    }
    return self;
}

- (LightControlParameter*)copyObject
{
    LightControlParameter *parameter = [LightControlParameter new];
    parameter.type = self.type;
    parameter.name = self.name ? [NSString stringWithFormat:@"%@", self.name] : nil;
    parameter.minValue = self.minValue;
    parameter.maxValue = self.maxValue;
    parameter.currentValue = self.currentValue;
    parameter.color = self.color ? [UIColor colorWithCGColor:self.color.CGColor] : nil;
    //
    return parameter;
}

@end
