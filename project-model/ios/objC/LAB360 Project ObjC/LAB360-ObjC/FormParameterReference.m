//
//  FormParameterReference.m
//  Siga
//
//  Created by Erico GT on 29/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "FormParameterReference.h"

@implementation FormParameterReference

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.keyName = @"";
        self.parameterName = @"";
        self.parameterIcon = nil;
        self.placeholder = @"";
        self.textMask = @"";
        self.textFormat = @"";
        self.keyboardType = UIKeyboardTypeDefault;
        self.capitalizationType = UITextAutocapitalizationTypeNone;
        self.valueType = ParameterReferenceValueTypeGeneric;
        self.maxSize = 0;
        self.required = NO;
        self.autoClearMask = NO;
        self.readyOnly = NO;
        self.minDate = nil;
        self.maxDate = nil;
        self.highlightingRegex = nil;
    }
    return self;
}

@end

