//
//  BeaconShowroomManager.m
//  LAB360-ObjC
//
//  Created by Erico GT on 12/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "BeaconShowroomManager.h"
#import "InternetConnectionManager.h"
#import "AppDelegate.h"
//
#import <EstimoteSDK/EstimoteSDK.h>

@interface BeaconShowroomManager () <ESTTriggerManagerDelegate, ESTNearableManagerDelegate, ESTTelemetryNotificationProtocol>

//Ranging Beacon
@property (nonatomic) ESTNearableManager *nearableManager;
@property (nonatomic, strong) NSMutableDictionary *beaconsData;
//Nearable
@property (nonatomic) ESTTriggerManager *triggerManager;
@property (nonatomic) NSMutableArray<ESTTrigger *> *triggers;
//Telemetry
@property (nonatomic, strong) ESTDeviceManager *deviceManager;
@property (nonatomic, strong) NSMutableDictionary *beaconsDevicesIDs;
//Generic
@property (nonatomic, assign) BeaconShowroomManagerType managerType;

@end

@implementation BeaconShowroomManager

@synthesize delegate, beaconsDevicesIDs, triggerManager, triggers, nearableManager, beaconsData, deviceManager, managerType;

- (instancetype)initWithProductsIdentifiers:(NSArray<NSString*>*)products type:(BeaconShowroomManagerType)type andDelegate:(id<BeaconShowroomManagerDelegate>)mDelegate;
{
    self = [super init];
    if (self) {
        
        self.managerType = type;
        
        self.delegate = mDelegate;
        
        /** NOTE: ericogt
         Existem duas formas de monitorar o 'motion' do estimote.
         - Usando um beacon 'estimote stickers' (nearable)
         - Usando um beacon 'estimote location' (telemetry)
         Ambos tipos conseguem informar mudanças no sensor de movimento, mas de formas diferentes.
         */
        
        if (type == BeaconShowroomManagerTypeRangingNearable) {
            
            //BeaconShowroomManagerTypeRangingNearable
            self.nearableManager = [ESTNearableManager new];
            self.nearableManager.delegate = self;
            //
            self.beaconsData = [NSMutableDictionary new];
            for (NSString *str in products){
                [beaconsData setValue:[NSDictionary new] forKey:str];
            }
            
        }else if (type == BeaconShowroomManagerTypeMotionNearable) {
            
            //BeaconShowroomManagerTypeMotionNearable
            self.triggerManager = [ESTTriggerManager new];
            self.triggerManager.delegate = self;
            
            self.triggers = [NSMutableArray new];
            
            for (NSString *str in products) {
                ESTMotionRule *motionRule = [ESTMotionRule motionStateEquals:YES forNearableIdentifier:str];
                ESTTrigger *motionTrigger = [[ESTTrigger alloc] initWithRules:@[motionRule] identifier:str];
                //
                [self.triggers addObject:motionTrigger];
            }
        }else{
            
            //BeaconShowroomManagerTypeMotionTelemetry
            self.deviceManager = [ESTDeviceManager new];
            beaconsDevicesIDs = [NSMutableDictionary new];
            //
            for (NSString *str in products) {
                if (str.length == 32){
                    NSString *halfID = [str substringToIndex:16];
                    [beaconsDevicesIDs setValue:str forKey:halfID];
                }
            }
        }
    }
    return self;
}

- (void)startUpdates {
    
    if (self.managerType == BeaconShowroomManagerTypeRangingNearable) {
        NSArray *beaconsList = [beaconsData allKeys];
        for (NSString *key in beaconsList){
            [self.nearableManager startRangingForIdentifier:key];
        }
    }else if (self.managerType == BeaconShowroomManagerTypeMotionNearable) {
        for (ESTTrigger *trigger in self.triggers) {
            [self.triggerManager startMonitoringForTrigger:trigger];
        }
    }else{
        [self.deviceManager registerForTelemetryNotification:self];
    }
}

- (void)stopUpdates {
    if (self.managerType == BeaconShowroomManagerTypeRangingNearable) {
        NSArray *beaconsList = [beaconsData allKeys];
        for (NSString *key in beaconsList){
            [self.nearableManager stopRangingForIdentifier:key];
        }
    }else if (self.managerType == BeaconShowroomManagerTypeMotionNearable) {
        for (ESTTrigger *trigger in self.triggers) {
            [self.triggerManager stopMonitoringForTriggerWithIdentifier:trigger.identifier];
        }
    }else{
        [self.deviceManager unregisterForTelemetryNotification:self];
        [beaconsDevicesIDs removeAllObjects];
    }
}

- (void)logEstimoteBeaconDataToServer:(NSDictionary*)beaconData forUser:(NSString*)userEmail
{
    NSMutableDictionary *logDic = [NSMutableDictionary new];
    [logDic setValue:userEmail forKey:@"email"];
    [logDic setValue:beaconData forKey:@"estimote_log"];
    
    if ([NSJSONSerialization isValidJSONObject:logDic])
    {
        InternetConnectionManager *icm = [InternetConnectionManager new];
        InternetActiveConnectionType iType = [icm activeConnectionType];
        
        if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
            NSString *urlString = [NSString stringWithFormat:@"%@%@", [icm serverPreference], @"/api/v1/logs/estimote"];
            [icm postTo:urlString body:logDic completionHandler:^(id  _Nullable responseObject, NSInteger statusCode, NSError * _Nullable error) {
                if (error == nil && (statusCode >= 200 && statusCode <= 300)){
                    //DevLogger
                    [AppD.devLogger newLogEvent:@"AdAlive" category:@"BeaconEstimoteLog" dicData:beaconData];
                }
            }];
        }
    }
}

#pragma mark - ESTTriggerManager

- (void)triggerManager:(ESTTriggerManager *)manager triggerChangedState:(ESTTrigger *)trigger
{
    NSString *str = trigger.identifier;
    
    if (str == nil) {
        return;
    }
    
    if (trigger.state == YES) {
        //BeaconDetectedPutdown
        [self.delegate showroomManager:self didDetectPickupForBeacon:str];
    } else {
        //BeaconDetectedPutdown
        [self.delegate showroomManager:self didDetectPutdownForBeacon:str];
    }
}

- (void)actionTimerAutoClose:(NSTimer*)timer
{
    NSString *str = (NSString*)timer.userInfo;
    
    //O tipo 'BeaconShowroomManagerTypeMotionTelemetry' e 'BeaconShowroomManagerTypeRangingNearable' informam a parada de movimento de outra forma (eles não precisam de um timer auxiliar).
    if (self.managerType == BeaconShowroomManagerTypeMotionNearable) {
        [self.delegate showroomManager:self didDetectPutdownForBeacon:str];
    }
}

#pragma mark - ESTTelemetryNotificationProtocol

- (void)fireNotificationBlockWithTelemetryInfo:(ESTTelemetryInfo *)info
{
    NSString *halfID = info.shortIdentifier;
    
    NSString *productID = [beaconsDevicesIDs valueForKey:halfID];
    
    if (!productID){
        return;
    }
    
    ESTTelemetryInfoMotion *motionInfo = (ESTTelemetryInfoMotion*)info;
    
    if ([motionInfo.motionState intValue] == 0) {
        //BeaconDetectedPutdown
        [self.delegate showroomManager:self didDetectPutdownForBeacon:productID];
    }else{
        //BeaconDetectedPickup
        [self.delegate showroomManager:self didDetectPickupForBeacon:productID];
    }
}

- (Class)getInfoClass
{
    return [ESTTelemetryInfoMotion class];
}

#pragma mark - ESTNearableManager

- (void)nearableManager:(ESTNearableManager *)manager didRangeNearable:(ESTNearable *)nearable
{
    NSMutableDictionary *nearableBeaconData = [NSMutableDictionary new];
    
    //beacon_id
    [nearableBeaconData setValue:@(0) forKey:@"beacon_id"]; //Este dado precisa ser atualizado posteriormente pois o ID não é conhecido neste momento.
    
    //identifier
    [nearableBeaconData setValue:nearable.identifier forKey:@"identifier"];
    
    //zone
    NSString *zone = @"";
    switch (nearable.zone) {
        case ESTNearableZoneUnknown:{ zone = @"Unknown"; }break;
        case ESTNearableZoneImmediate:{ zone = @"Immediate"; }break;
        case ESTNearableZoneNear:{ zone = @"Near"; }break;
        case ESTNearableZoneFar:{ zone = @"Far"; }break;
    }
    [nearableBeaconData setValue:zone forKey:@"zone"];
    
    //estimote_type
    NSString *type = @"";
    switch (nearable.type) {
        case ESTNearableTypeUnknown:{ type = @"Unknown"; }break;
        case ESTNearableTypeDog:{ type = @"Dog"; }break;
        case ESTNearableTypeCar:{ type = @"Car"; }break;
        case ESTNearableTypeFridge:{ type = @"Fridge"; }break;
        case ESTNearableTypeBag:{ type = @"Bag"; }break;
        case ESTNearableTypeBike:{ type = @"Bike"; }break;
        case ESTNearableTypeChair:{ type = @"Chair"; }break;
        case ESTNearableTypeBed:{ type = @"Bed"; }break;
        case ESTNearableTypeDoor:{ type = @"Door"; }break;
        case ESTNearableTypeShoe:{ type = @"Shoe"; }break;
        case ESTNearableTypeGeneric:{ type = @"Generic"; }break;
        case ESTNearableTypeAll:{ type = @"All"; }break;
    }
    [nearableBeaconData setValue:type forKey:@"estimote_type"];
    
    //color
    NSString *color = @"";
    switch (nearable.color) {
        case ESTColorUnknown:{ color = @"Unknown"; }break;
        case ESTColorMintCocktail:{ color = @"MintCocktail"; }break;
        case ESTColorIcyMarshmallow:{ color = @"IcyMarshmallow"; }break;
        case ESTColorBlueberryPie:{ color = @"BlueberryPie"; }break;
        case ESTColorSweetBeetroot:{ color = @"SweetBeetroot"; }break;
        case ESTColorCandyFloss:{ color = @"CandyFloss"; }break;
        case ESTColorLemonTart:{ color = @"LemonTart"; }break;
        case ESTColorVanillaJello:{ color = @"VanillaJello"; }break;
        case ESTColorLiquoriceSwirl:{ color = @"LiquoriceSwirl"; }break;
        case ESTColorWhite:{ color = @"White"; }break;
        case ESTColorBlack:{ color = @"Black"; }break;
        case ESTColorCoconutPuff:{ color = @"CoconutPuff"; }break;
        case ESTColorTransparent:{ color = @"Transparent"; }break;
    }
    [nearableBeaconData setValue:color forKey:@"color"];
    
    //hardware_version
    [nearableBeaconData setValue:nearable.hardwareVersion forKey:@"hardware_version"];
   
    //firmware_version
    [nearableBeaconData setValue:nearable.firmwareVersion forKey:@"firmware_version"];
    
    //rssi
    [nearableBeaconData setValue:@(nearable.rssi) forKey:@"rssi"];
    
    //idle_battery_voltage
    NSString *idleBatteryVoltage = nearable.idleBatteryVoltage ? [NSString stringWithFormat:@"%@", nearable.idleBatteryVoltage] : @"";
    [nearableBeaconData setValue:idleBatteryVoltage forKey:@"idle_battery_voltage"];
    
    //stress_battery_voltage
    NSString *stressBatteryVoltage = nearable.stressBatteryVoltage ? [NSString stringWithFormat:@"%@", nearable.stressBatteryVoltage] : @"";
    [nearableBeaconData setValue:stressBatteryVoltage forKey:@"stress_battery_voltage"];
    
    //current_motion_state_duration
    [nearableBeaconData setValue:@(nearable.currentMotionStateDuration) forKey:@"current_motion_state_duration"];
    
    //previous_motion_state_duration
    [nearableBeaconData setValue:@(nearable.previousMotionStateDuration) forKey:@"previous_motion_state_duration"];
    
    //is_moving
    [nearableBeaconData setValue:@(nearable.isMoving) forKey:@"is_moving"];
    
    //orientation
    NSString *orientation = @"";
    switch (nearable.orientation) {
        case ESTNearableOrientationUnknown:{ orientation = @"Unknown"; }break;
        case ESTNearableOrientationHorizontal:{ orientation = @"Horizontal"; }break;
        case ESTNearableOrientationHorizontalUpsideDown:{ orientation = @"HorizontalUpsideDown"; }break;
        case ESTNearableOrientationVertical:{ orientation = @"Vertical"; }break;
        case ESTNearableOrientationVerticalUpsideDown:{ orientation = @"VerticalUpsideDown"; }break;
        case ESTNearableOrientationLeftSide:{ orientation = @"LeftSide"; }break;
        case ESTNearableOrientationRightSide:{ orientation = @"RightSide"; }break;
    }
    [nearableBeaconData setValue:orientation forKey:@"orientation"];
    
    //x_acceleration
    [nearableBeaconData setValue:@(nearable.xAcceleration) forKey:@"x_acceleration"];
    
    //y_acceleration
    [nearableBeaconData setValue:@(nearable.yAcceleration) forKey:@"y_acceleration"];
    
    //z_acceleration
    [nearableBeaconData setValue:@(nearable.zAcceleration) forKey:@"z_acceleration"];
    
    //temperature
    [nearableBeaconData setValue:@(nearable.temperature) forKey:@"temperature"];
    
    //power
    NSString *power = nearable.power ? [NSString stringWithFormat:@"%@", nearable.power] : @"";
    [nearableBeaconData setValue:power forKey:@"power"];
    
    //adv_interval
    NSString *advInterval = nearable.advInterval ? [NSString stringWithFormat:@"%@", nearable.advInterval] : @"";
    [nearableBeaconData setValue:advInterval forKey:@"adv_interval"];
    
    //firmware_state
    NSString *firmwareState = @"";
    switch (nearable.firmwareState) {
        case ESTNearableFirmwareStateBoot:{ firmwareState = @"Boot"; }break;
        case ESTNearableFirmwareStateApp:{ firmwareState = @"App"; }break;
    }
    [nearableBeaconData setValue:firmwareState forKey:@"firmware_state"];
    
    //broadcasting_scheme
    NSString *broadcastingScheme = @"";
    switch (nearable.broadcastingScheme) {
        case ESTNearableBroadcastingSchemeUnknown:{ broadcastingScheme = @"Unknown"; }break;
        case ESTNearableBroadcastingSchemeNearable:{ broadcastingScheme = @"Nearable"; }break;
        case ESTNearableBroadcastingSchemeIBeacon:{ broadcastingScheme = @"IBeacon"; }break;
        case ESTNearableBroadcastingSchemeEddystoneURL:{ broadcastingScheme = @"EddystoneURL"; }break;
    }
    [nearableBeaconData setValue:broadcastingScheme forKey:@"broadcasting_scheme"];
    
    //eddyston_url
    [nearableBeaconData setValue:nearable.eddystoneURL forKey:@"eddyston_url"];
    
    //proximity_uuid
    [nearableBeaconData setValue:nearable.proximityUUID forKey:@"proximity_uuid"];
    
    //major
    [nearableBeaconData setValue:nearable.major forKey:@"major"];
    
    //minor
    [nearableBeaconData setValue:nearable.minor forKey:@"minor"];
    
    //beacon_region
    [nearableBeaconData setValue:(nearable.beaconRegion != nil ? @"YES" : @"NO") forKey:@"beacon_region"];
    
    //is_motion_broken
    [nearableBeaconData setValue:@(nearable.isMotionBroken) forKey:@"is_motion_broken"];
    
    //is_temperature_broken
    [nearableBeaconData setValue:@(nearable.isTemperatureBroken) forKey:@"is_temperature_broken"];
  
    //***************************************************************************************************
    
    [self.delegate showroomManager:self didDetectMotionChange:nearable.isMoving toBeacon:nearable.identifier withData:nearableBeaconData];
}

@end
