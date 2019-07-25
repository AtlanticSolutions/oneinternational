//
//  PromotionalCard.h
//  LAB360-ObjC
//
//  Created by Erico GT on 25/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"

typedef enum {
    PromotionalCardSizeSmall = 1,
    PromotionalCardSizeNormal = 2,
    PromotionalCardSizeLarge = 3
}PromotionalCardSize;

typedef enum {
    PromotionalCardPositionRandom = 1,
    PromotionalCardPositionCenter = 2
}PromotionalCardPosition;

@interface PromotionalCard : NSObject<DefaultObjectModelProtocol>

//Properties:

//basic
@property (nonatomic, assign) long cardID;
//promotion
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *titleScreen;
@property (nonatomic, strong) NSString *promotionalLink;
@property (nonatomic, strong) NSString *promotionalMessage;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, assign) BOOL isPremium;
@property (nonatomic, assign) PromotionalCardSize preferedSize;
@property (nonatomic, assign) PromotionalCardPosition preferedPosition;
//images urls
@property (nonatomic, strong) NSString *urlPrizeWon;
@property (nonatomic, strong) NSString *urlPrizeLose;
@property (nonatomic, strong) NSString *urlPrizePending;
@property (nonatomic, strong) NSString *urlBackgroundCard;
@property (nonatomic, strong) NSString *urlCoverCard;
@property (nonatomic, strong) NSString *urlWallpaperScreen;
@property (nonatomic, strong) NSString *urlParticleObject;
//images
@property (nonatomic, strong) UIImage *imgPrizeWon;
@property (nonatomic, strong) UIImage *imgPrizeLose;
@property (nonatomic, strong) UIImage *imgPrizePending;
@property (nonatomic, strong) UIImage *imgBackgroundCard;
@property (nonatomic, strong) UIImage *imgCoverCard;
@property (nonatomic, strong) UIImage *imgWallpaperScreen;
@property (nonatomic, strong) UIImage *imgParticleObject;
//colors
@property (nonatomic, strong) NSString *colorBackground;
@property (nonatomic, strong) NSString *colorDetail;
@property (nonatomic, strong) NSString *colorText;
//parameters
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat coverLimit;

//Protocol Methods:
+ (PromotionalCard*)newObject;
+ (PromotionalCard*)createObjectFromDictionary:(NSDictionary*)dicData;
- (PromotionalCard*)copyObject;
- (NSDictionary*)dictionaryJSON;

@end
