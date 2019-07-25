//
//  SideMenuItem.h
//  LAB360-ObjC
//
//  Created by Erico GT on 24/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"
#import "UIImage+animatedGIF.h"

typedef enum {
    SideMenuItemCode_Prototype                  = 0,
    SideMenuItemCode_Home                       = 1,
    SideMenuItemCode_Profile                    = 2,
    SideMenuItemCode_Events                     = 3,
    SideMenuItemCode_Agenda                     = 4,
    SideMenuItemCode_Documents                  = 5,
    SideMenuItemCode_Chat                       = 6,
    SideMenuItemCode_Sponsor                    = 7,
    SideMenuItemCode_Videos                     = 8,
    SideMenuItemCode_BeaconShowroom             = 9,
    SideMenuItemCode_Questionnaire              = 10,
    SideMenuItemCode_QuestionnaireSearch        = 11,
    SideMenuItemCode_ScannerAdAlive             = 12,
    SideMenuItemCode_ScannerAdAliveHistory      = 13,
    SideMenuItemCode_GiftCard                   = 14,
    SideMenuItemCode_VirtualShowcase            = 15,
    SideMenuItemCode_Showcase360                = 16,
    SideMenuItemCode_PromotionalCardScratch     = 17,
    SideMenuItemCode_Utilities                  = 18,
    SideMenuItemCode_WebPage                    = 19,
    SideMenuItemCode_Options                    = 20,
    SideMenuItemCode_About                      = 21,
    SideMenuItemCode_Exit                       = 22,
    SideMenuItemCode_MenuGroup                  = 100
} SideMenuItemCode;

typedef enum {
    SideMenuItemType_App       = 1,
    SideMenuItemType_Web       = 2
} SideMenuItemType;

typedef enum {
    SideMenuItemControlState_Compressed     = 1,
    SideMenuItemControlState_Expanded       = 2
} SideMenuItemControlState;

@interface SideMenuItem : NSObject<DefaultObjectModelProtocol>

//Properties
@property(nonatomic, strong) NSString *itemName;
@property(nonatomic, assign) SideMenuItemType itemType;
@property(nonatomic, assign) long prototypeID;
@property(nonatomic, strong) NSString *itemID;
@property(nonatomic, assign) SideMenuItemCode itemInternalCode;
@property(nonatomic, assign) int order;
//
@property(nonatomic, strong) UIImage *icon;
@property(nonatomic, strong) NSData *iconDataGIF;
@property(nonatomic, strong) NSString *iconURL;
@property(nonatomic, strong) NSMutableArray<SideMenuItem*> *subItems;
@property(nonatomic, assign) int badgeCount;
//
@property(nonatomic, strong) NSString *webPageURL;
@property(nonatomic, assign) BOOL webShowControls;
@property(nonatomic, assign) BOOL webShowShareButton;
//
@property(nonatomic, assign) BOOL blocked;
@property(nonatomic, strong) NSString *blockedMessage;
@property(nonatomic, assign) BOOL highlighted;
@property(nonatomic, strong) NSString *featuredMessage;
//
@property(nonatomic, assign) int uiControlOptionLevel;
@property(nonatomic, strong) NSString *uiControlGroupIdentifier;
@property(nonatomic, assign) SideMenuItemControlState uiControlState;
//
@property(nonatomic, assign) BOOL showShortcut;

//Protocol Methods
+ (SideMenuItem*)newObject;
+ (SideMenuItem*)createObjectFromDictionary:(NSDictionary*)dicData;
- (SideMenuItem*)copyObject;
- (NSDictionary*)dictionaryJSON;

//Methods
- (NSString*)stringForCode:(SideMenuItemCode)code;
- (SideMenuItemCode)codeForString:(NSString*)str;
- (UIImage*)defaultImageForCode:(SideMenuItemCode)code;

@end
