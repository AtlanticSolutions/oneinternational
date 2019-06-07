//
//  SideMenuItem.m
//  LAB360-ObjC
//
//  Created by Erico GT on 24/05/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "SideMenuItem.h"
#import "ConstantsManager.h"

#define CLASS_SIDEMENU_ITEM_DEFAULT @"sidemenu_item"
#define CLASS_SIDEMENU_ITEM_TITLE @"name"
#define CLASS_SIDEMENU_ITEM_TYPE @"menu_type"
#define CLASS_SIDEMENU_ITEM_ID @"identifier"
#define CLASS_SIDEMENU_ITEM_WEB_URL @"url"
#define CLASS_SIDEMENU_ITEM_WEB_SHOW_CONTROLS @"flg_web_controls"
#define CLASS_SIDEMENU_ITEM_WEB_SHOW_SHAREBUTTON @"flg_web_share_button"
#define CLASS_SIDEMENU_ITEM_WEB_CHECK_URL @"flg_api_adalive"
#define CLASS_SIDEMENU_ITEM_ICON_URL @"icon_url"
#define CLASS_SIDEMENU_ITEM_BLOCKED @"flg_blocked"
#define CLASS_SIDEMENU_ITEM_SHOWINTIMELINE @"flg_timeline"
#define CLASS_SIDEMENU_ITEM_BLOCKED_MESSAGE @"blocked_message"
#define CLASS_SIDEMENU_ITEM_HIGHLIGHTED @"flg_highlighted"
#define CLASS_SIDEMENU_ITEM_FEATURED_MESSAGE @"featured_message"
#define CLASS_SIDEMENU_ITEM_BADGE @"badge"
#define CLASS_SIDEMENU_ITEM_ORDER @"order"
#define CLASS_SIDEMENU_ITEM_SUB_ITEMS @"app_menu_items"

//

#define CLASS_ITEM_CODE_PROTOTYPE @"PROTOTYPE"
#define CLASS_ITEM_CODE_HOME @"HOME"
#define CLASS_ITEM_CODE_PROFILE @"PROFILE"
#define CLASS_ITEM_CODE_EVENTS @"EVENTS"
#define CLASS_ITEM_CODE_AGENDA @"AGENDA"
#define CLASS_ITEM_CODE_DOCUMENTS @"DOCUMENTS"
#define CLASS_ITEM_CODE_CHAT @"CHAT"
#define CLASS_ITEM_CODE_SPONSOR @"SPONSOR"
#define CLASS_ITEM_CODE_VIDEOS @"VIDEOS"
#define CLASS_ITEM_CODE_BEACONSHOWROOM @"BEACONSHOWROOM"
#define CLASS_ITEM_CODE_QUESTIONNAIRE @"QUESTIONNAIRE"
#define CLASS_ITEM_CODE_QUESTIONNAIRESEARCH @"QUESTIONNAIRESEARCH"
#define CLASS_ITEM_CODE_SCANNER @"SCANNER"
#define CLASS_ITEM_CODE_SCANNERHISTORY @"SCANNERHISTORY"
#define CLASS_ITEM_CODE_GIFTCARD @"GIFTCARD"
#define CLASS_ITEM_CODE_VIRTUALSHOWCASE @"VIRTUALSHOWCASE"
#define CLASS_ITEM_CODE_SHOWCASE360 @"SHOWCASE360"
#define CLASS_ITEM_CODE_PROMOTIONALCARD @"PROMOTIONALCARD"
#define CLASS_ITEM_CODE_UTILITIES @"UTILITIES"
#define CLASS_ITEM_CODE_WEBPAGE @"WEBPAGE"
#define CLASS_ITEM_CODE_OPTIONS @"OPTIONS"
#define CLASS_ITEM_CODE_ABOUT @"ABOUT"
#define CLASS_ITEM_CODE_EXIT @"EXIT"
#define CLASS_ITEM_CODE_MENUGROUP @"MENUGROUP"

#define CLASS_ITEM_TYPE_APP @"APP"
#define CLASS_ITEM_TYPE_WEB @"WEBVIEW"

@implementation SideMenuItem

@synthesize itemName, itemType, prototypeID, itemID, icon, iconDataGIF, iconURL, order, subItems, webPageURL, webShowControls, webShowShareButton, itemInternalCode, blocked, blockedMessage, highlighted, featuredMessage, badgeCount, showShortcut, webNeedCheckUrl;
@synthesize uiControlOptionLevel, uiControlGroupIdentifier, uiControlState;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        itemName = nil;
        itemType = SideMenuItemType_App;
        prototypeID = 0;
        itemID = nil;
        order = 0;
        icon = nil;
        iconDataGIF = nil;
        iconURL = nil;
        subItems = [NSMutableArray new];
        webPageURL = nil;
        webShowControls = YES;
        webShowShareButton = YES;
        webNeedCheckUrl = NO;
        itemInternalCode = SideMenuItemCode_Prototype;
        blocked = NO;
        blockedMessage = nil;
        highlighted = NO;
        featuredMessage = nil;
        badgeCount = 0;
        //
        uiControlOptionLevel = 0;
        uiControlGroupIdentifier = nil;
        uiControlState = SideMenuItemControlState_Compressed;
        //
        showShortcut = NO;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------

+ (SideMenuItem*)newObject
{
    SideMenuItem *sm = [SideMenuItem new];
    return sm;
}

+ (SideMenuItem*)createObjectFromDictionary:(NSDictionary*)dicData
{
    SideMenuItem *sm = [SideMenuItem new];
    
    //NSDictionary *dic = [dicData valueForKey:[SideMenuConfig className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        sm.itemName = [keysList containsObject:CLASS_SIDEMENU_ITEM_TITLE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SIDEMENU_ITEM_TITLE]] : sm.itemName;
        //
        NSString *strType = [keysList containsObject:CLASS_SIDEMENU_ITEM_TYPE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SIDEMENU_ITEM_TYPE]] : CLASS_ITEM_TYPE_APP;
        if (strType != nil) {
            strType = [strType uppercaseString];
            //
            if ([strType isEqualToString:CLASS_ITEM_TYPE_APP]) {
                sm.itemType = SideMenuItemType_App;
            }else if ([strType isEqualToString:CLASS_ITEM_TYPE_WEB]) {
                sm.itemType = SideMenuItemType_Web;
            }
        }
        //
        sm.itemID = [keysList containsObject:CLASS_SIDEMENU_ITEM_ID] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SIDEMENU_ITEM_ID]] : sm.itemID;
        //
        sm.iconURL = [keysList containsObject:CLASS_SIDEMENU_ITEM_ICON_URL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SIDEMENU_ITEM_ICON_URL]] : sm.iconURL;
        //
        sm.webPageURL = [keysList containsObject:CLASS_SIDEMENU_ITEM_WEB_URL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SIDEMENU_ITEM_WEB_URL]] : sm.iconURL;
        sm.webShowControls = [keysList containsObject:CLASS_SIDEMENU_ITEM_WEB_SHOW_CONTROLS] ? [[neoDic  valueForKey:CLASS_SIDEMENU_ITEM_WEB_SHOW_CONTROLS] boolValue] : sm.webShowControls;
        sm.webShowShareButton = [keysList containsObject:CLASS_SIDEMENU_ITEM_WEB_SHOW_SHAREBUTTON] ? [[neoDic  valueForKey:CLASS_SIDEMENU_ITEM_WEB_SHOW_SHAREBUTTON] boolValue] : sm.webShowShareButton;
        sm.webNeedCheckUrl = [keysList containsObject:CLASS_SIDEMENU_ITEM_WEB_CHECK_URL] ? [[neoDic  valueForKey:CLASS_SIDEMENU_ITEM_WEB_CHECK_URL] boolValue] : sm.webNeedCheckUrl;
        //
        if ([keysList containsObject:CLASS_SIDEMENU_ITEM_SUB_ITEMS]) {
            NSArray *itemsL = nil;
            @try {
                itemsL = [[NSArray alloc] initWithArray:[neoDic  valueForKey:CLASS_SIDEMENU_ITEM_SUB_ITEMS]];
            } @catch (NSException *exception) {
                NSLog(@"createObjectFromDictionary >> Error >> %@", [exception reason]);
            }
            if (itemsL != nil && itemsL.count > 0) {
                NSMutableArray *allItems = [NSMutableArray new];
                for (NSDictionary *dic in itemsL) {
                    [allItems addObject:[SideMenuItem createObjectFromDictionary:dic]];
                }
                //order
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                sm.subItems = [[NSMutableArray alloc] initWithArray:[allItems sortedArrayUsingDescriptors:sortDescriptors]];
            }
        }
        //
        sm.blocked = [keysList containsObject:CLASS_SIDEMENU_ITEM_BLOCKED] ? [[neoDic  valueForKey:CLASS_SIDEMENU_ITEM_BLOCKED] boolValue] : sm.blocked;
        //
        sm.blockedMessage = [keysList containsObject:CLASS_SIDEMENU_ITEM_BLOCKED_MESSAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SIDEMENU_ITEM_BLOCKED_MESSAGE]] : sm.blockedMessage;
        //
        sm.highlighted = [keysList containsObject:CLASS_SIDEMENU_ITEM_HIGHLIGHTED] ? [[neoDic  valueForKey:CLASS_SIDEMENU_ITEM_HIGHLIGHTED] boolValue] : sm.highlighted;
        //
        sm.featuredMessage = [keysList containsObject:CLASS_SIDEMENU_ITEM_FEATURED_MESSAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SIDEMENU_ITEM_FEATURED_MESSAGE]] : sm.featuredMessage;
        //
        sm.badgeCount = [keysList containsObject:CLASS_SIDEMENU_ITEM_BADGE] ? [[neoDic  valueForKey:CLASS_SIDEMENU_ITEM_BADGE] intValue] : sm.badgeCount;
        //
        sm.order = [keysList containsObject:CLASS_SIDEMENU_ITEM_ORDER] ? [[neoDic  valueForKey:CLASS_SIDEMENU_ITEM_ORDER] intValue] : sm.order;
        //
        sm.showShortcut = [keysList containsObject:CLASS_SIDEMENU_ITEM_SHOWINTIMELINE] ? [[neoDic  valueForKey:CLASS_SIDEMENU_ITEM_SHOWINTIMELINE] boolValue] : sm.showShortcut;
        
        //Imagem Ícone Padrão:
        sm.itemInternalCode = [sm codeForString:sm.itemID];
        
     
        //sm.icon = [sm defaultImageForCode:sm.itemInternalCode];
    }
    
    return sm;
}

- (SideMenuItem*)copyObject
{
    SideMenuItem *sm = [SideMenuItem new];
    sm.itemName = self.itemName != nil ? [NSString stringWithFormat:@"%@", self.itemName] : nil;
    sm.itemType = self.itemType;
    sm.prototypeID = self.prototypeID;
    sm.itemInternalCode = self.itemInternalCode;
    sm.order = self.order;
    sm.itemID = self.itemID != nil ? [NSString stringWithFormat:@"%@", self.itemID] : nil;
    sm.icon = self.icon.CGImage != nil ? [UIImage imageWithCGImage:self.icon.CGImage] : nil;
    sm.iconDataGIF = self.iconDataGIF != nil ? [NSData dataWithData:self.iconDataGIF] : nil;
    sm.iconURL = self.iconURL != nil ? [NSString stringWithFormat:@"%@", self.iconURL] : nil;
    sm.subItems = [NSMutableArray new];
    for (SideMenuItem *item in self.subItems) {
        [sm.subItems addObject:[item copyObject]];
    }
    sm.webPageURL = self.webPageURL != nil ? [NSString stringWithFormat:@"%@", self.webPageURL] : nil;
    sm.webShowControls = self.webShowControls;
    sm.webShowShareButton = self.webShowShareButton;
    sm.webNeedCheckUrl = self.webNeedCheckUrl;
    sm.blocked = self.blocked;
    sm.blockedMessage = self.blockedMessage != nil ? [NSString stringWithFormat:@"%@", self.blockedMessage] : nil;
    sm.highlighted = self.highlighted;
    sm.featuredMessage = self.featuredMessage != nil ? [NSString stringWithFormat:@"%@", self.featuredMessage] : nil;
    sm.badgeCount = self.badgeCount;
    //
    sm.uiControlOptionLevel = self.uiControlOptionLevel;
    sm.uiControlGroupIdentifier = self.uiControlGroupIdentifier != nil ? [NSString stringWithFormat:@"%@", self.uiControlGroupIdentifier] : nil;
    sm.uiControlState = self.uiControlState;
    //
    sm.showShortcut = self.showShortcut;
    //
    return sm;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    [dicData setValue:self.itemName != nil ? self.itemName : @"" forKey:CLASS_SIDEMENU_ITEM_TITLE];
    //
    switch (self.itemType) {
        case SideMenuItemType_App:{
            [dicData setValue:CLASS_ITEM_TYPE_APP forKey:CLASS_SIDEMENU_ITEM_TYPE];
        }break;
        case SideMenuItemType_Web:{
            [dicData setValue:CLASS_ITEM_TYPE_WEB forKey:CLASS_SIDEMENU_ITEM_TYPE];
        }break;
    }
    //
    [dicData setValue:@(self.order) forKey:CLASS_SIDEMENU_ITEM_ORDER];
    [dicData setValue:@(self.badgeCount) forKey:CLASS_SIDEMENU_ITEM_BADGE];
    [dicData setValue:self.itemID != nil ? self.itemID : @"" forKey:CLASS_SIDEMENU_ITEM_ID];
    [dicData setValue:self.iconURL != nil ? self.iconURL : @"" forKey:CLASS_SIDEMENU_ITEM_ICON_URL];
    //
    [dicData setValue:self.webPageURL != nil ? self.webPageURL : @"" forKey:CLASS_SIDEMENU_ITEM_WEB_URL];
    [dicData setValue:@(self.webShowControls) forKey:CLASS_SIDEMENU_ITEM_WEB_SHOW_CONTROLS];
    [dicData setValue:@(self.webShowShareButton) forKey:CLASS_SIDEMENU_ITEM_WEB_SHOW_SHAREBUTTON];
    [dicData setValue:@(self.webNeedCheckUrl) forKey:CLASS_SIDEMENU_ITEM_WEB_CHECK_URL];
    //
    NSMutableArray *itemsL = [NSMutableArray new];
    for (SideMenuItem *item in self.subItems) {
        [itemsL addObject:[item dictionaryJSON]];
    }
    [dicData setValue:itemsL forKey:CLASS_SIDEMENU_ITEM_SUB_ITEMS];
    //
    [dicData setValue:@(self.blocked) forKey:CLASS_SIDEMENU_ITEM_BLOCKED];
    [dicData setValue:self.blockedMessage != nil ? self.blockedMessage : @"" forKey:CLASS_SIDEMENU_ITEM_BLOCKED_MESSAGE];
    [dicData setValue:@(self.highlighted) forKey:CLASS_SIDEMENU_ITEM_HIGHLIGHTED];
    [dicData setValue:self.featuredMessage != nil ? self.featuredMessage : @"" forKey:CLASS_SIDEMENU_ITEM_FEATURED_MESSAGE];
    //
    [dicData setValue:@(self.showShortcut) forKey:CLASS_SIDEMENU_ITEM_SHOWINTIMELINE];
    //
    return dicData;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Methods
//-------------------------------------------------------------------------------------------------------------

- (NSString*)stringForCode:(SideMenuItemCode)code
{
    NSString *str = nil;
    
    switch (code) {
        case SideMenuItemCode_Prototype:{ str = CLASS_ITEM_CODE_PROTOTYPE; }break;
        case SideMenuItemCode_Home:{ str = CLASS_ITEM_CODE_HOME; }break;
        case SideMenuItemCode_Profile:{ str = CLASS_ITEM_CODE_PROFILE; }break;
        case SideMenuItemCode_Events:{ str = CLASS_ITEM_CODE_EVENTS; }break;
        case SideMenuItemCode_Agenda:{ str = CLASS_ITEM_CODE_AGENDA; }break;
        case SideMenuItemCode_Documents:{ str = CLASS_ITEM_CODE_DOCUMENTS; }break;
        case SideMenuItemCode_Chat:{ str = CLASS_ITEM_CODE_CHAT; }break;
        case SideMenuItemCode_Sponsor:{ str = CLASS_ITEM_CODE_SPONSOR; }break;
        case SideMenuItemCode_Videos:{ str = CLASS_ITEM_CODE_VIDEOS; }break;
        case SideMenuItemCode_BeaconShowroom:{ str = CLASS_ITEM_CODE_BEACONSHOWROOM; }break;
        case SideMenuItemCode_Questionnaire:{ str = CLASS_ITEM_CODE_QUESTIONNAIRE; }break;
        case SideMenuItemCode_QuestionnaireSearch:{ str = CLASS_ITEM_CODE_QUESTIONNAIRESEARCH; }break;
        case SideMenuItemCode_ScannerAdAlive:{ str = CLASS_ITEM_CODE_SCANNER; }break;
        case SideMenuItemCode_ScannerAdAliveHistory:{ str = CLASS_ITEM_CODE_SCANNERHISTORY; }break;
        case SideMenuItemCode_GiftCard:{ str = CLASS_ITEM_CODE_GIFTCARD; }break;
        case SideMenuItemCode_VirtualShowcase:{ str = CLASS_ITEM_CODE_VIRTUALSHOWCASE; }break;
        case SideMenuItemCode_Showcase360:{ str = CLASS_ITEM_CODE_SHOWCASE360; }break;
        case SideMenuItemCode_PromotionalCardScratch:{ str = CLASS_ITEM_CODE_PROMOTIONALCARD; }break;
        case SideMenuItemCode_Utilities:{ str = CLASS_ITEM_CODE_UTILITIES; }break;
        case SideMenuItemCode_WebPage:{ str = CLASS_ITEM_CODE_WEBPAGE; }break;
        case SideMenuItemCode_Options:{ str = CLASS_ITEM_CODE_OPTIONS; }break;
        case SideMenuItemCode_About:{ str = CLASS_ITEM_CODE_ABOUT; }break;
        case SideMenuItemCode_Exit:{ str = CLASS_ITEM_CODE_EXIT; }break;
        case SideMenuItemCode_MenuGroup:{ str = CLASS_ITEM_CODE_MENUGROUP; }break;
    }
    
    return str;
}

- (SideMenuItemCode)codeForString:(NSString*)str
{
    SideMenuItemCode code = SideMenuItemCode_Prototype;
    
    if (str != nil && ![str isEqualToString:@""]) {
        
        NSString *strCode = [str uppercaseString];
        
        if ([strCode isEqualToString:CLASS_ITEM_CODE_HOME]){ code = SideMenuItemCode_Home; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_PROFILE]){ code = SideMenuItemCode_Profile; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_EVENTS]){ code = SideMenuItemCode_Events; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_AGENDA]){ code = SideMenuItemCode_Agenda; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_DOCUMENTS]){ code = SideMenuItemCode_Documents; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_CHAT]){ code = SideMenuItemCode_Chat; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_SPONSOR]){ code = SideMenuItemCode_Sponsor; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_VIDEOS]){ code = SideMenuItemCode_Videos; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_BEACONSHOWROOM]){ code = SideMenuItemCode_BeaconShowroom; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_QUESTIONNAIRE]){ code = SideMenuItemCode_Questionnaire; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_QUESTIONNAIRESEARCH]){ code = SideMenuItemCode_QuestionnaireSearch; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_SCANNER]){ code = SideMenuItemCode_ScannerAdAlive; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_SCANNERHISTORY]){ code = SideMenuItemCode_ScannerAdAliveHistory; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_GIFTCARD]){ code = SideMenuItemCode_GiftCard; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_VIRTUALSHOWCASE]){ code = SideMenuItemCode_VirtualShowcase; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_SHOWCASE360]){ code = SideMenuItemCode_Showcase360; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_PROMOTIONALCARD]){ code = SideMenuItemCode_PromotionalCardScratch; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_UTILITIES]){ code = SideMenuItemCode_Utilities; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_WEBPAGE]){ code = SideMenuItemCode_WebPage; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_OPTIONS]){ code = SideMenuItemCode_Options; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_ABOUT]){ code = SideMenuItemCode_About; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_EXIT]){ code = SideMenuItemCode_Exit; }
        else if ([strCode isEqualToString:CLASS_ITEM_CODE_MENUGROUP]){ code = SideMenuItemCode_MenuGroup; }
    }
    
    return code;
}

- (UIImage*)defaultImageForCode:(SideMenuItemCode)code
{
    UIImage *img = nil;
    
    switch (code) {
        case SideMenuItemCode_Prototype:{ img = [UIImage imageNamed:@"SideMenuItemIconPrototype"]; }break;
        case SideMenuItemCode_Home:{ img = [UIImage imageNamed:@"SideMenuItemIconHome"]; }break;
        case SideMenuItemCode_Profile:{ img = [UIImage imageNamed:@"SideMenuItemIconProfile"]; }break;
        case SideMenuItemCode_Events:{ img = [UIImage imageNamed:@"SideMenuItemIconEvents"]; }break;
        case SideMenuItemCode_Agenda:{ img = [UIImage imageNamed:@"SideMenuItemIconAgenda"]; }break;
        case SideMenuItemCode_Documents:{ img = [UIImage imageNamed:@"SideMenuItemIconDocuments"]; }break;
        case SideMenuItemCode_Chat:{ img = [UIImage imageNamed:@"SideMenuItemIconChat"]; }break;
        case SideMenuItemCode_Sponsor:{ img = [UIImage imageNamed:@"SideMenuItemIconSponsor"]; }break;
        case SideMenuItemCode_Videos:{ img = [UIImage imageNamed:@"SideMenuItemIconVideos"]; }break;
        case SideMenuItemCode_BeaconShowroom:{ img = [UIImage imageNamed:@"SideMenuItemBeaconShowroom"]; }break;
        case SideMenuItemCode_Questionnaire:{ img = [UIImage imageNamed:@"SideMenuItemQuestionnaire"]; }break;
        case SideMenuItemCode_QuestionnaireSearch:{ img = [UIImage imageNamed:@"SideMenuItemQuestionnaireSearch"]; }break;
        case SideMenuItemCode_ScannerAdAlive:{ img = [UIImage imageNamed:@"SideMenuItemIconScanner"]; }break;
        case SideMenuItemCode_ScannerAdAliveHistory:{ img = [UIImage imageNamed:@"SideMenuItemIconScannerHistory"]; }break;
        case SideMenuItemCode_GiftCard:{ img = [UIImage imageNamed:@"SideMenuItemIconGiftCard"]; }break;
        case SideMenuItemCode_VirtualShowcase:{ img = [UIImage imageNamed:@"SideMenuItemIconVirtualShowcase"]; }break;
        case SideMenuItemCode_Showcase360:{ img = [UIImage imageNamed:@"SideMenuItemIconShowcase360"]; }break;
        case SideMenuItemCode_PromotionalCardScratch:{ img = [UIImage imageNamed:@"SideMenuItemIconPromotionalCard"]; }break;
        case SideMenuItemCode_Utilities:{ img = [UIImage imageNamed:@"SideMenuItemIconUtilities"]; }break;
        case SideMenuItemCode_WebPage:{ img = [UIImage imageNamed:@"SideMenuItemIconWebPage"]; }break;
        case SideMenuItemCode_Options:{ img = [UIImage imageNamed:@"SideMenuItemIconOptions"]; }break;
        case SideMenuItemCode_About:{ img = [UIImage imageNamed:@"SideMenuItemIconAbout"]; }break;
        case SideMenuItemCode_Exit:{ img = [UIImage imageNamed:@"SideMenuItemIconExit"]; }break;
        case SideMenuItemCode_MenuGroup:{ img = [UIImage imageNamed:@"SideMenuItemIconMenuGroup"]; }break;
    }
    
    if (img == nil){
        return [UIImage new];
    }else{
        return [ToolBox graphicHelper_ImageWithTintColor:[UIColor grayColor] andImageTemplate:img];
    }
}


@end
