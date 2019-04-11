//
//  LabBeacon.h
//  LAB360-ObjC
//
//  Created by Erico GT on 09/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"
//
#import "AdAliveAction.h"

@interface LaBeacon : NSObject<DefaultObjectModelProtocol>

@property (nonatomic, assign) long beaconID;
@property (nonatomic, strong) NSString* _Nullable name;
@property (nonatomic, strong) NSString* _Nullable proximityUUID;
@property (nonatomic, strong) NSString* _Nullable major;
@property (nonatomic, strong) NSString* _Nullable minor;
//
@property (nonatomic, assign) long currentMotionState;
@property (nonatomic, strong) NSString* _Nullable sku;
@property (nonatomic, strong) NSString* _Nullable tagID;
@property (nonatomic, strong) NSString* _Nullable trackingDistance;
@property (nonatomic, strong) NSString* _Nullable type;
@property (nonatomic, strong) NSString* _Nullable estimoteType;
//
@property (nonatomic, strong) NSString* _Nullable entryMessage;
@property (nonatomic, strong) NSString* _Nullable leaveMessage;
@property (nonatomic, strong) NSDate* _Nullable lastEntryReportDate;
@property (nonatomic, strong) NSDate* _Nullable lastExitReportDate;
//
@property (nonatomic, strong) AdAliveAction* _Nullable adAliveAction;
//
@property (nonatomic, strong) NSMutableDictionary* _Nullable estimoteBeaconData;

//Public Methods
-(NSUUID* _Nullable) nsuuid;
-(NSString* _Nonnull) codificator;

//Protocol Methods
+ (LaBeacon* _Nullable)newObject;
+ (NSString* _Nonnull)className;
+ (LaBeacon* _Nonnull)createObjectFromDictionary:(NSDictionary* _Nonnull)dicData;
- (LaBeacon* _Nonnull)copyObject;
- (NSDictionary* _Nonnull)dictionaryJSON;
- (bool)isEqualToObject:(LaBeacon* _Nullable)object;

@end
