//
//  ColorPalette.m
//  LAB360-ObjC
//
//  Created by Erico GT on 28/02/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "ColorPalette.h"

@implementation ColorPalette

@synthesize backgroundNormal, backgroundLight, backgroundDark;
@synthesize textNormal, textLight, textDark;
@synthesize primaryButtonNormal, primaryButtonSelected, primaryButtonTitleNormal, primaryButtonTitleSelected;
@synthesize secondaryButtonNormal, secondaryButtonSelected, secondaryButtonTitleNormal, secondaryButtonTitleSelected;
@synthesize defaultButtonNormal, defaultButtonSelected, defaultButtonTitleNormal, defaultButtonTitleSelected;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self applyDefaultColorLayout];
    }
    return self;
}

- (void)applyDefaultColorLayout
{
    backgroundNormal = [ToolBox graphicHelper_colorWithHexString:@"#a6ca44"];
    backgroundLight = [ToolBox graphicHelper_colorWithHexString:@"#f0f0f0"];
    backgroundDark = [ToolBox graphicHelper_colorWithHexString:@"#637925"];
    //
    textNormal = [ToolBox graphicHelper_colorWithHexString:@"#fefffa"];
    textLight = [UIColor lightTextColor];
    textDark = [UIColor darkTextColor];
    //
    primaryButtonNormal = [ToolBox graphicHelper_colorWithHexString:@"#a6ca44"];
    primaryButtonSelected = [ToolBox graphicHelper_colorWithHexString:@"#637925"];
    primaryButtonTitleNormal = [ToolBox graphicHelper_colorWithHexString:@"#fefffa"];
    primaryButtonTitleSelected = [ToolBox graphicHelper_colorWithHexString:@"#fefffa"];
    //
    secondaryButtonNormal = [ToolBox graphicHelper_colorWithHexString:@"#000000"];
    secondaryButtonSelected = [ToolBox graphicHelper_colorWithHexString:@"#444444"];
    secondaryButtonTitleNormal = [ToolBox graphicHelper_colorWithHexString:@"#fefffa"];
    secondaryButtonTitleSelected = [ToolBox graphicHelper_colorWithHexString:@"#fefffa"];
    //
    defaultButtonNormal = [UIColor grayColor];
    defaultButtonSelected = [UIColor darkGrayColor];
    defaultButtonTitleNormal = [UIColor whiteColor];
    defaultButtonTitleSelected = [UIColor whiteColor];
}

- (void)applyCustomColorLayout:(NSDictionary*)parameters
{
    NSDictionary *colorsDataDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:parameters withString:@""];
    
    if (colorsDataDic){
        
        NSArray *keys = [parameters allKeys];
        
        NSString *background_color = [keys containsObject:@"background_color"] ? [colorsDataDic valueForKey:@"background_color"] : nil;
        backgroundNormal = ((background_color == nil || [background_color isEqualToString:@""]) ? backgroundNormal : [ToolBox graphicHelper_colorWithHexString:background_color]);
        //
        NSString *text_color = [keys containsObject:@"text_color"] ? [colorsDataDic valueForKey:@"text_color"] : nil;
        textNormal = ((text_color == nil || [text_color isEqualToString:@""]) ? textNormal : [ToolBox graphicHelper_colorWithHexString:text_color]);
        //
        NSString *button_first_color = [keys containsObject:@"button_first_color"] ? [colorsDataDic valueForKey:@"button_first_color"] : nil;
        primaryButtonNormal = ((button_first_color == nil || [button_first_color isEqualToString:@""]) ? primaryButtonNormal : [ToolBox graphicHelper_colorWithHexString:button_first_color]);
        NSString *selected_button_first_color = [keys containsObject:@"selected_button_first_color"] ? [colorsDataDic valueForKey:@"selected_button_first_color"] : nil;
        primaryButtonSelected = ((selected_button_first_color == nil || [selected_button_first_color isEqualToString:@""]) ? primaryButtonSelected : [ToolBox graphicHelper_colorWithHexString:selected_button_first_color]);
        NSString *title_button_first_color = [keys containsObject:@"title_button_first_color"] ? [colorsDataDic valueForKey:@"title_button_first_color"] : nil;
        primaryButtonTitleNormal = ((title_button_first_color == nil || [title_button_first_color isEqualToString:@""]) ? primaryButtonTitleNormal : [ToolBox graphicHelper_colorWithHexString:title_button_first_color]);
        NSString *selected_title_button_first_color = [keys containsObject:@"selected_title_button_first_color"] ? [colorsDataDic valueForKey:@"selected_title_button_first_color"] : nil;
        primaryButtonTitleSelected = ((selected_title_button_first_color == nil || [selected_title_button_first_color isEqualToString:@""]) ? primaryButtonTitleSelected : [ToolBox graphicHelper_colorWithHexString:selected_title_button_first_color]);
        //
        NSString *button_second_color = [keys containsObject:@"button_second_color"] ? [colorsDataDic valueForKey:@"button_second_color"] : nil;
        secondaryButtonNormal = ((button_second_color == nil || [button_second_color isEqualToString:@""]) ? secondaryButtonNormal : [ToolBox graphicHelper_colorWithHexString:button_second_color]);
        NSString *selected_button_second_color = [keys containsObject:@"selected_button_second_color"] ? [colorsDataDic valueForKey:@"selected_button_second_color"] : nil;
        secondaryButtonSelected = ((selected_button_second_color == nil || [selected_button_second_color isEqualToString:@""]) ? secondaryButtonSelected : [ToolBox graphicHelper_colorWithHexString:selected_button_second_color]);
        NSString *title_button_second_color = [keys containsObject:@"title_button_second_color"] ? [colorsDataDic valueForKey:@"title_button_second_color"] : nil;
        secondaryButtonTitleNormal = ((title_button_second_color == nil || [title_button_second_color isEqualToString:@""]) ? secondaryButtonTitleNormal : [ToolBox graphicHelper_colorWithHexString:title_button_second_color]);
        NSString *selected_title_button_second_color = [keys containsObject:@"selected_title_button_second_color"] ? [colorsDataDic valueForKey:@"selected_title_button_second_color"] : nil;
        secondaryButtonTitleSelected = ((selected_title_button_second_color == nil || [selected_title_button_second_color isEqualToString:@""]) ? secondaryButtonTitleSelected : [ToolBox graphicHelper_colorWithHexString:selected_title_button_second_color]);
    }
}

@end
