//
//  AppOptionItem.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppOptionItem : NSObject

typedef enum {
    AppOptionItemStatusSelection          = 1,
    AppOptionItemStatusDestination        = 2,
    AppOptionItemStatusSwitchable         = 3
}AppOptionItemStatus;

typedef enum {
    AppOptionItemIdentificationGeneric         = 0,
    AppOptionItemIdentificationTutorial        = 1,
    AppOptionItemIdentificationSecurity        = 2,
    AppOptionItemIdentificationPermission      = 3,
    AppOptionItemIdentificationSounds          = 4,
    AppOptionItemIdentificationTimeline        = 5,
    AppOptionItemIdentificationLanguage        = 6,
    AppOptionItemIdentificationGeofence        = 7,
    AppOptionItemIdentificationContact         = 8
}AppOptionItemIdentification;

//Properties:
@property (nonatomic, assign) AppOptionItemStatus status;
@property (nonatomic, assign) AppOptionItemIdentification identification;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *selectionDescription;
@property (nonatomic, strong) NSString *destinationDescription;
@property (nonatomic, strong) NSString *switchableONDescription;
@property (nonatomic, strong) NSString *switchableOFFDescription;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) BOOL blocked;

//Methods:
- (AppOptionItem*)copyObject;

@end
