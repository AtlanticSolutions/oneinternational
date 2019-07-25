//
//  PromotionalCard.m
//  LAB360-ObjC
//
//  Created by Erico GT on 25/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "PromotionalCard.h"
#import "ConstantsManager.h"

#define CLASS_PROMOTIONALCARD_DEFAULT @"promotional_card"
#define CLASS_PROMOTIONALCARD_KEY_ID @"id"
#define CLASS_PROMOTIONALCARD_KEY_CODE @"code"
#define CLASS_PROMOTIONALCARD_KEY_TITLE @"title"
#define CLASS_PROMOTIONALCARD_KEY_LINK @"link"
#define CLASS_PROMOTIONALCARD_KEY_MESSAGE @"message"
#define CLASS_PROMOTIONALCARD_KEY_INFO @"info"
#define CLASS_PROMOTIONALCARD_KEY_PREMIUM @"is_premium"
#define CLASS_PROMOTIONALCARD_KEY_SIZE @"prefered_size"
#define CLASS_PROMOTIONALCARD_KEY_POSITION @"prefered_position"
#define CLASS_PROMOTIONALCARD_KEY_PRIZEWON @"url_prize_won"
#define CLASS_PROMOTIONALCARD_KEY_PRIZELOSE @"url_prize_lose"
#define CLASS_PROMOTIONALCARD_KEY_PRIZEPENDING @"url_prize_pending"
#define CLASS_PROMOTIONALCARD_KEY_BACKGROUNDCARD @"url_background_card"
#define CLASS_PROMOTIONALCARD_KEY_COVERCARD @"url_cover_card"
#define CLASS_PROMOTIONALCARD_KEY_WALLPAPER @"url_background_screen"
#define CLASS_PROMOTIONALCARD_KEY_PARTICLE @"url_particle_object"
#define CLASS_PROMOTIONALCARD_KEY_COLOR_BACKGROUND @"color_background"
#define CLASS_PROMOTIONALCARD_KEY_COLOR_DETAIL @"color_detail"
#define CLASS_PROMOTIONALCARD_KEY_COLOR_TEXT @"color_text"
#define CLASS_PROMOTIONALCARD_KEY_LINE_WIDTH @"line_width"
#define CLASS_PROMOTIONALCARD_KEY_COVER_LIMIT @"cover_limit"

@implementation PromotionalCard

@synthesize cardID;
@synthesize code, titleScreen, promotionalLink, promotionalMessage, info, isPremium, preferedSize, preferedPosition;
@synthesize urlPrizeWon, urlPrizeLose, urlPrizePending, urlBackgroundCard, urlCoverCard, urlWallpaperScreen, urlParticleObject, imgPrizeWon, imgPrizePending, imgPrizeLose, imgBackgroundCard, imgCoverCard, imgWallpaperScreen, imgParticleObject;
@synthesize colorBackground, colorDetail, colorText;
@synthesize lineWidth, coverLimit;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        cardID = 0;
        //promotion
        code = nil;
        titleScreen = nil;
        promotionalLink = nil;
        promotionalMessage = nil;
        info = nil;
        isPremium = NO;
        preferedSize = PromotionalCardSizeNormal;
        preferedPosition = PromotionalCardPositionRandom;
        //images urls
        urlPrizeWon = nil;
        urlPrizeLose = nil;
        urlPrizePending = nil;
        urlBackgroundCard = nil;
        urlCoverCard = nil;
        urlWallpaperScreen = nil;
        urlParticleObject = nil;
        //images
        imgPrizeWon = nil;
        imgPrizeLose = nil;
        imgPrizePending = nil;
        imgBackgroundCard = nil;
        imgCoverCard = nil;
        imgWallpaperScreen = nil;
        imgParticleObject = nil;
        //colors
        colorBackground = nil;
        colorDetail = nil;
        colorText = nil ;
        //parameters
        lineWidth = 40.0;
        coverLimit = 95.0;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------

+ (PromotionalCard*)newObject
{
    PromotionalCard *c = [PromotionalCard new];
    return c;
}

+ (PromotionalCard*)createObjectFromDictionary:(NSDictionary*)dicData
{
    PromotionalCard *c = [PromotionalCard new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        c.cardID = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_ID] ? [[neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_ID] longValue] : c.cardID;
        //promotion
        c.code = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_CODE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_CODE]] : c.code;
        c.titleScreen = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_TITLE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_TITLE]] : c.titleScreen;
        c.promotionalLink = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_LINK] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_LINK]] : c.promotionalLink;
        c.promotionalMessage = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_MESSAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_MESSAGE]] : c.promotionalMessage;
        c.info = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_INFO] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_INFO]] : c.info;
        c.isPremium = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_PREMIUM] ? [[neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_PREMIUM] boolValue] : c.isPremium;
        c.preferedSize = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_SIZE] ? [[neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_SIZE] intValue] : c.preferedSize;
        c.preferedPosition = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_POSITION] ? [[neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_POSITION] intValue] : c.preferedPosition;
        //images urls
        c.urlPrizeWon = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_PRIZEWON] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_PRIZEWON]] : c.urlPrizeWon;
        c.urlPrizeLose = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_PRIZELOSE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_PRIZELOSE]] : c.urlPrizeLose;
        c.urlPrizePending = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_PRIZEPENDING] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_PRIZEPENDING]] : c.urlPrizePending;
        c.urlBackgroundCard = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_BACKGROUNDCARD] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_BACKGROUNDCARD]] : c.urlBackgroundCard;
        c.urlCoverCard = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_COVERCARD] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_COVERCARD]] : c.urlCoverCard;
        c.urlWallpaperScreen = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_WALLPAPER] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_WALLPAPER]] : c.urlWallpaperScreen;
        c.urlParticleObject = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_PARTICLE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_PARTICLE]] : c.urlParticleObject;
        //images
        //c.imgPrizeWon = nil;
        //c.imgPrizeLose = nil;
        //c.imgBackgroundCard = nil;
        //c.imgCoverCard = nil;
        //c.imgWallpaperScreen = nil;
        //c.imgParticleObject = nil;
        //colors
        c.colorBackground = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_COLOR_BACKGROUND] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_COLOR_BACKGROUND]] : c.colorBackground;
        c.colorDetail =  [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_COLOR_DETAIL] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_COLOR_DETAIL]] : c.colorDetail;
        c.colorText = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_COLOR_TEXT] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_COLOR_TEXT]] : c.colorText;
        //parameters
        c.lineWidth = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_LINE_WIDTH] ? [[neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_LINE_WIDTH] floatValue] : c.lineWidth;
        c.coverLimit = [keysList containsObject:CLASS_PROMOTIONALCARD_KEY_COVER_LIMIT] ? [[neoDic  valueForKey:CLASS_PROMOTIONALCARD_KEY_COVER_LIMIT] floatValue] : c.coverLimit;
    }
    
    c.lineWidth = c.lineWidth < 40.0 ? 40.0 : (c.lineWidth > 120.0 ? 120.0 : c.lineWidth);
    c.coverLimit = c.coverLimit < 0.0 ? 0.0 : (c.coverLimit > 1.0 ? 1.0 : c.coverLimit);
    //
    if (c.preferedSize < 1 || c.preferedSize > 3){
        c.preferedSize = PromotionalCardSizeNormal;
    }
    if (c.preferedPosition < 1 || c.preferedPosition > 2){
        c.preferedPosition = PromotionalCardPositionRandom;
    }
    
    return c;
}

- (PromotionalCard*)copyObject
{
    PromotionalCard *c = [PromotionalCard new];
    c.cardID = self.cardID;
    //promotion
    c.code = self.code ? [NSString stringWithFormat:@"%@", self.code] : nil;
    c.titleScreen = self.titleScreen ? [NSString stringWithFormat:@"%@", self.titleScreen] : nil;
    c.promotionalLink = self.promotionalLink ? [NSString stringWithFormat:@"%@", self.promotionalLink] : nil;
    c.promotionalMessage = self.promotionalMessage ? [NSString stringWithFormat:@"%@", self.promotionalMessage] : nil;
    c.info = self.info ? [NSString stringWithFormat:@"%@", self.info] : nil;
    c.isPremium = self.isPremium;
    c.preferedSize = self.preferedSize;
    c.preferedPosition = self.preferedPosition;
    //images urls
    c.urlPrizeWon = self.urlPrizeWon ? [NSString stringWithFormat:@"%@", self.urlPrizeWon] : nil;
    c.urlPrizeLose = self.urlPrizeLose ? [NSString stringWithFormat:@"%@", self.urlPrizeLose] : nil;
    c.urlPrizePending = self.urlPrizePending ? [NSString stringWithFormat:@"%@", self.urlPrizePending] : nil;
    c.urlBackgroundCard = self.urlBackgroundCard ? [NSString stringWithFormat:@"%@", self.urlBackgroundCard] : nil;
    c.urlCoverCard = self.urlCoverCard ? [NSString stringWithFormat:@"%@", self.urlCoverCard] : nil;
    c.urlWallpaperScreen = self.urlWallpaperScreen ? [NSString stringWithFormat:@"%@", self.urlWallpaperScreen] : nil;
    c.urlParticleObject = self.urlParticleObject ? [NSString stringWithFormat:@"%@", self.urlParticleObject] : nil;
    //images
    c.imgPrizeWon = self.imgPrizeWon.CGImage == nil ? nil : [UIImage imageWithCGImage:self.imgPrizeWon.CGImage];
    c.imgPrizeLose = self.imgPrizeLose.CGImage == nil ? nil : [UIImage imageWithCGImage:self.imgPrizeLose.CGImage];
    c.imgPrizePending = self.imgPrizePending.CGImage == nil ? nil : [UIImage imageWithCGImage:self.imgPrizePending.CGImage];
    c.imgBackgroundCard = self.imgBackgroundCard.CGImage == nil ? nil : [UIImage imageWithCGImage:self.imgBackgroundCard.CGImage];
    c.imgCoverCard = self.imgCoverCard.CGImage == nil ? nil : [UIImage imageWithCGImage:self.imgCoverCard.CGImage];
    c.imgWallpaperScreen = self.imgWallpaperScreen.CGImage == nil ? nil : [UIImage imageWithCGImage:self.imgWallpaperScreen.CGImage];
    c.imgParticleObject = self.imgParticleObject.CGImage == nil ? nil : [UIImage imageWithCGImage:self.imgParticleObject.CGImage];
    //colors
    c.colorBackground = self.colorBackground ? [NSString stringWithFormat:@"%@", self.colorBackground] : nil;
    c.colorDetail = self.colorDetail ? [NSString stringWithFormat:@"%@", self.colorDetail] : nil;
    c.colorText = self.colorText ? [NSString stringWithFormat:@"%@", self.colorText] : nil;
    //parameters
    c.lineWidth = self.lineWidth;
    c.coverLimit = self.coverLimit;
    //
    return c;
}

- (NSDictionary*)dictionaryJSON
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    //
    [dicData setValue:@(self.cardID) forKey:CLASS_PROMOTIONALCARD_KEY_ID];
    [dicData setValue:(self.code ? self.code : @"") forKey:CLASS_PROMOTIONALCARD_KEY_CODE];
    [dicData setValue:(self.titleScreen ? self.titleScreen : @"") forKey:CLASS_PROMOTIONALCARD_KEY_TITLE];
    [dicData setValue:(self.promotionalLink ? self.promotionalLink : @"") forKey:CLASS_PROMOTIONALCARD_KEY_LINK];
    [dicData setValue:(self.promotionalMessage ? self.promotionalMessage : @"") forKey:CLASS_PROMOTIONALCARD_KEY_MESSAGE];
    [dicData setValue:(self.info ? self.info : @"") forKey:CLASS_PROMOTIONALCARD_KEY_INFO];
    [dicData setValue:@(self.isPremium) forKey:CLASS_PROMOTIONALCARD_KEY_PREMIUM];
    [dicData setValue:@(self.preferedSize) forKey:CLASS_PROMOTIONALCARD_KEY_SIZE];
    [dicData setValue:@(self.preferedPosition) forKey:CLASS_PROMOTIONALCARD_KEY_POSITION];
    [dicData setValue:(self.urlPrizeWon ? self.urlPrizeWon : @"") forKey:CLASS_PROMOTIONALCARD_KEY_PRIZEWON];
    [dicData setValue:(self.urlPrizeLose ? self.urlPrizeLose : @"") forKey:CLASS_PROMOTIONALCARD_KEY_PRIZELOSE];
    [dicData setValue:(self.urlPrizePending ? self.urlPrizePending : @"") forKey:CLASS_PROMOTIONALCARD_KEY_PRIZEPENDING];
    [dicData setValue:(self.urlBackgroundCard ? self.urlBackgroundCard : @"") forKey:CLASS_PROMOTIONALCARD_KEY_BACKGROUNDCARD];
    [dicData setValue:(self.urlCoverCard ? self.urlCoverCard : @"") forKey:CLASS_PROMOTIONALCARD_KEY_COVERCARD];
    [dicData setValue:(self.urlWallpaperScreen ? self.urlWallpaperScreen : @"") forKey:CLASS_PROMOTIONALCARD_KEY_WALLPAPER];
    [dicData setValue:(self.urlParticleObject ? self.urlParticleObject : @"") forKey:CLASS_PROMOTIONALCARD_KEY_PARTICLE];
    [dicData setValue:(self.colorBackground ? self.colorBackground : @"") forKey:CLASS_PROMOTIONALCARD_KEY_COLOR_BACKGROUND];
    [dicData setValue:(self.colorDetail ? self.colorDetail : @"") forKey:CLASS_PROMOTIONALCARD_KEY_COLOR_DETAIL];
    [dicData setValue:(self.colorText ? self.colorText : @"") forKey:CLASS_PROMOTIONALCARD_KEY_COLOR_TEXT];
    [dicData setValue:@(self.lineWidth) forKey:CLASS_PROMOTIONALCARD_KEY_LINE_WIDTH];
    [dicData setValue:@(self.coverLimit) forKey:CLASS_PROMOTIONALCARD_KEY_COVER_LIMIT];
    //
    return dicData;
}

@end
