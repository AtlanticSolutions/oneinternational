//
//  BeaconShowroomManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 12/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BeaconShowroomManagerTypeRangingNearable       = 1, //Use esta versão para rastrear dados do beacon de forma mais completa (permite resgatar dados do beacon device).
    BeaconShowroomManagerTypeMotionNearable        = 2, //Esta versão apenas verifica se o beacon se moveu/parou (para estimote 'sticker').
    BeaconShowroomManagerTypeMotionTelemetry       = 3, //Esta versão apenas verifica se o beacon se moveu/parou (para estimote 'location/GPS').
} BeaconShowroomManagerType;

@class BeaconShowroomManager;

@protocol BeaconShowroomManagerDelegate <NSObject>
/** Este método reporta início de movimento para os tipos 'BeaconShowroomManagerTypeMotionNearable' e 'BeaconShowroomManagerTypeMotionTelemetry'. */
- (void)showroomManager:(BeaconShowroomManager*)showroomManager didDetectPickupForBeacon:(NSString *)beaconIdentifier;

/** Este método reporta término de movimento para os tipos 'BeaconShowroomManagerTypeMotionNearable' e 'BeaconShowroomManagerTypeMotionTelemetry'. */
- (void)showroomManager:(BeaconShowroomManager*)showroomManager didDetectPutdownForBeacon:(NSString *)beaconIdentifier;

/** Este método reporta mudança de movimento apenas para o tipo 'BeaconShowroomManagerTypeRangingNearable'. */
- (void)showroomManager:(BeaconShowroomManager*)showroomManager didDetectMotionChange:(BOOL)isMoving toBeacon:(NSString *)beaconIdentifier withData:(NSDictionary*)beaconData;
@end

@interface BeaconShowroomManager : NSObject

@property (weak, nonatomic) id<BeaconShowroomManagerDelegate> delegate;
@property (nonatomic, assign, readonly) BeaconShowroomManagerType managerType;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

//Methods:
- (instancetype)initWithProductsIdentifiers:(NSArray<NSString*>*)products type:(BeaconShowroomManagerType)type andDelegate:(id<BeaconShowroomManagerDelegate>)mDelegate;
- (void)startUpdates;
- (void)stopUpdates;
//Logs:
- (void)logEstimoteBeaconDataToServer:(NSDictionary*)beaconData forUser:(NSString*)userEmail;

@end
