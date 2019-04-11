//
//  ActionModel3D_AR_ScreenSetConfig.m
//  LAB360-ObjC
//
//  Created by Erico GT on 23/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "ActionModel3D_AR_ScreenSetConfig.h"
#import "ConstantsManager.h"
#import "ToolBox.h"

#define CLASS_ACTION3D_AR_SCREENSET_DEFAULT @"screen_set"
#define CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWPHOTOBUTTON @"show_photo_button"
#define CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWLIGHTCONTROLS @"show_light_controls"
#define CLASS_ACTION3D_AR_SCREENSET_KEY_SCREENTITLE @"screen_title"
#define CLASS_ACTION3D_AR_SCREENSET_KEY_FOOTERMESSAGE @"footer_message"

@implementation ActionModel3D_AR_ScreenSetConfig
@synthesize showPhotoButton, showLightControlOption, screenTitle, footerMessage;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        showPhotoButton = YES;
        showLightControlOption = YES;
        screenTitle = @"";
        footerMessage = @"";
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Support Methods
//-------------------------------------------------------------------------------------------------------------

+ (ActionModel3D_AR_ScreenSetConfig*)createObjectFromDictionary:(NSDictionary*)dicData
{
    ActionModel3D_AR_ScreenSetConfig *ss = [ActionModel3D_AR_ScreenSetConfig new];
    
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        ss.showPhotoButton = [keysList containsObject:CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWPHOTOBUTTON] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWPHOTOBUTTON] boolValue] : ss.showPhotoButton;
        ss.showLightControlOption = [keysList containsObject:CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWLIGHTCONTROLS] ? [[neoDic  valueForKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWLIGHTCONTROLS] boolValue] : ss.showLightControlOption;
        ss.screenTitle = [keysList containsObject:CLASS_ACTION3D_AR_SCREENSET_KEY_SCREENTITLE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SCREENTITLE]] : ss.screenTitle;
        ss.footerMessage = [keysList containsObject:CLASS_ACTION3D_AR_SCREENSET_KEY_FOOTERMESSAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_ACTION3D_AR_SCREENSET_KEY_FOOTERMESSAGE]] : ss.footerMessage;
    }
    
    return ss;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.showPhotoButton) forKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWPHOTOBUTTON];
    [dicData setValue:@(self.showLightControlOption) forKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWLIGHTCONTROLS];
    [dicData setValue:(self.screenTitle ? [NSString stringWithFormat:@"%@", self.screenTitle] : @"") forKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SCREENTITLE];
    [dicData setValue:(self.footerMessage ? [NSString stringWithFormat:@"%@", self.footerMessage] : @"") forKey:CLASS_ACTION3D_AR_SCREENSET_KEY_FOOTERMESSAGE];
    //
    return dicData;
}

- (ActionModel3D_AR_ScreenSetConfig*)copyObject
{
    ActionModel3D_AR_ScreenSetConfig *ss = [ActionModel3D_AR_ScreenSetConfig new];
    ss.showPhotoButton = self.showPhotoButton;
    ss.showLightControlOption = self.showLightControlOption;
    ss.screenTitle = self.screenTitle ? [NSString stringWithFormat:@"%@", self.screenTitle] : nil;
    ss.footerMessage = self.footerMessage ? [NSString stringWithFormat:@"%@", self.footerMessage] : nil;
    //
    return ss;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - NSCoding Methods
//-------------------------------------------------------------------------------------------------------------

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.showPhotoButton forKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWPHOTOBUTTON];
    [aCoder encodeBool:self.showLightControlOption forKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWLIGHTCONTROLS];
    [aCoder encodeObject:self.screenTitle forKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SCREENTITLE];
    [aCoder encodeObject:self.footerMessage forKey:CLASS_ACTION3D_AR_SCREENSET_KEY_FOOTERMESSAGE];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self != nil ){
        self.showPhotoButton = [aDecoder decodeBoolForKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWPHOTOBUTTON];
        self.showLightControlOption = [aDecoder decodeBoolForKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SHOWLIGHTCONTROLS];
        self.screenTitle = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_SCREENSET_KEY_SCREENTITLE];
        self.footerMessage = [aDecoder decodeObjectForKey:CLASS_ACTION3D_AR_SCREENSET_KEY_FOOTERMESSAGE];
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - NSSecureCoding Methods
//-------------------------------------------------------------------------------------------------------------

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
