//
//  PromotionalCardScratchVC.h
//  LAB360-ObjC
//
//  Created by Erico GT on 25/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • INTERFACE HEADERS
#import "AppDelegate.h"
#import "PromotionalCard.h"
#import "ScrathItem.h"
#import "GameParticleEmitter.h"
#import "SCLAlertViewStyleKit.h"

#pragma mark - • FRAMEWORK HEADERS
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

#pragma mark - • OTHERS IMPORTS

#pragma mark - • LOCAL DEFINES

#pragma mark - • INTERFACE
@interface PromotionalCardScratchVC : UIViewController<MDScratchImageViewDelegate>

#pragma mark - • PUBLIC PROPERTIES
@property (nonatomic, strong) PromotionalCard *promotionalCard;

#pragma mark - • CLASS METHODS

#pragma mark - • PUBLIC INSTANCE METHODS

@end
