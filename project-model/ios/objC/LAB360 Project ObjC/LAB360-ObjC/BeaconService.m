//
//  BeaconService.m
//  LAB360-ObjC
//
//  Created by Erico GT on 09/03/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "BeaconService.h"
#import "AppDelegate.h"
#import "ConstantsManager.h"
#import "FileManager.h"

@interface BeaconService()
@property(nonatomic, assign) BeaconServiceType serviceType;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *beaconsToMonitor;
@end

@implementation BeaconService

@synthesize locationManager, beaconsToMonitor, serviceType, secondsToReportBeaconEvents;

- (BeaconService*)init
{
    self = [super init];
    if (self)
    {
        [self configureLocationManager];
        //
        beaconsToMonitor = nil;
        self.serviceType = BeaconServiceTypeMonitoring;
        self.secondsToReportBeaconEvents = 60;     //3600; //1 hora
    }
    return self;
}

+ (BeaconService*)newBeaconService
{
    BeaconService *service = [BeaconService new];
    //
    return service;
}

- (void)registerBeaconsToMonitor:(NSArray<LaBeacon*>*)beacons
{
    beaconsToMonitor = [NSMutableArray new];
    
    if (locationManager == nil){
        [self configureLocationManager];
    }else{
        for (CLRegion *region in [locationManager monitoredRegions]){
            [locationManager stopMonitoringForRegion:region];
            [locationManager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
        }
    }
    
    for (LaBeacon* b in beacons){
        [beaconsToMonitor addObject:[b copyObject]];
    }    
}

- (void)startMonitoringRegisteredBeaconsUsingServiceType:(BeaconServiceType)type
{
    //NOTE: Para 'monitoring' é necessário AlwaysAuthorization, para 'ranging' WhenInUse' basta (mas neste caso não funcionará em background).
    
    if (beaconsToMonitor.count > 0){
        
        serviceType = type;
        
        [locationManager requestAlwaysAuthorization];
        
        for (LaBeacon* b in beaconsToMonitor){
            
            b.lastEntryReportDate = nil;
            b.lastExitReportDate = nil;
            
            CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[b nsuuid] major:[b.major integerValue] minor:[b.minor integerValue] identifier:[b codificator]];
            if (serviceType == BeaconServiceTypeMonitoring){
                beaconRegion.notifyOnEntry = YES;
                beaconRegion.notifyOnExit = YES;
                [locationManager startMonitoringForRegion:beaconRegion];
            }else{
                [locationManager startRangingBeaconsInRegion:beaconRegion];
            }
        }
    }
    
}

- (void)stopMonitoringRegisteredBeacons
{
    for (LaBeacon* b in beaconsToMonitor){
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[b nsuuid] major:[b.major integerValue] minor:[b.minor integerValue] identifier:[b codificator]];
        //
        if (serviceType == BeaconServiceTypeMonitoring){
            [locationManager stopMonitoringForRegion:beaconRegion];
        }else{
            [locationManager stopRangingBeaconsInRegion:beaconRegion];
        }
    }
}

- (void)stopMonitoringEspecificBeacon:(LaBeacon*)beacon
{
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[beacon nsuuid] major:[beacon.major integerValue] minor:[beacon.minor integerValue] identifier:[beacon codificator]]; //[NSString stringWithFormat:@"%li", beacon.beaconID]];
    //
    if (serviceType == BeaconServiceTypeMonitoring){
        [locationManager stopMonitoringForRegion:beaconRegion];
    }else{
        [locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)restartMessagesForAllMonitoredBeacons
{
    for (LaBeacon* b in beaconsToMonitor){
        b.lastEntryReportDate = nil;
        b.lastExitReportDate = nil;
    }
}

#pragma mark - Private Methods

- (BOOL)needShowEnterRegionNotificationForBeacon:(LaBeacon*)beacon
{
    if (beacon.lastEntryReportDate == nil){
        return YES;
    }else{
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitSecond fromDate:beacon.lastEntryReportDate toDate:[NSDate date] options:0];
        
        if ([components second] > secondsToReportBeaconEvents){
            return YES;
        }
        
        return NO;
    }
}

- (BOOL)needShowExitRegionNotificationForBeacon:(LaBeacon*)beacon
{
    if (beacon.lastExitReportDate == nil){
        return YES;
    }else{
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitSecond fromDate:beacon.lastExitReportDate toDate:[NSDate date] options:0];
        
        if ([components second] > secondsToReportBeaconEvents){
            return YES;
        }
        
        return NO;
    }
}

- (void)configureLocationManager
{
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    //As duas propriedades abaixo apenas tem efeito para ranging (em modo background).
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]] && region.identifier != nil){
        
        for (LaBeacon *beacon in beaconsToMonitor){
         
            BOOL exists = [self needShowEnterRegionNotificationForBeacon:beacon];
            
            if (exists && [[beacon codificator] isEqualToString:region.identifier]){
                
                if ([ToolBox textHelper_CheckRelevantContentInString:beacon.entryMessage]){
                    
                    NSString *title = NSLocalizedString(@"ALERT_TITLE_NO_APP", @"");
                    
                    if (AppD.loggedUser.userID != 0){
                        title = [NSString stringWithFormat:@"%@, %@", NSLocalizedString(@"ALERT_TITLE_NO_APP", @""),AppD.loggedUser.name];
                    }
                    
                    NSLog(@"CLBeaconRegion >> didEnterRegion >> %@", beacon.name);
                    
                    UILocalNotification *notification = [[UILocalNotification alloc] init];
                    notification.alertTitle = title;
                    notification.alertBody = beacon.entryMessage;
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    notification.category = PUSHNOT_CATEGORY_LOCAL;
                    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                    
                    beacon.lastEntryReportDate = [NSDate date];
                    
                    break;
                }
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]] && region.identifier != nil){
        
        for (LaBeacon *beacon in beaconsToMonitor){
            
            BOOL exists = [self needShowExitRegionNotificationForBeacon:beacon];
            
            if (exists && [[beacon codificator] isEqualToString:region.identifier]){
                
                NSString *title = NSLocalizedString(@"ALERT_TITLE_NO_APP", @"");
                
                if ([ToolBox textHelper_CheckRelevantContentInString:beacon.leaveMessage]){
                    
                    if (AppD.loggedUser.userID != 0){
                        title = [NSString stringWithFormat:@"%@, %@", NSLocalizedString(@"ALERT_TITLE_NO_APP", @""),AppD.loggedUser.name];
                    }
                    
                    NSLog(@"CLBeaconRegion >> didExit >> %@", beacon.name);
                    
                    UILocalNotification *notification = [[UILocalNotification alloc] init];
                    notification.alertTitle = title;
                    notification.alertBody = beacon.leaveMessage;
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    notification.category = PUSHNOT_CATEGORY_LOCAL;
                    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                    
                    beacon.lastExitReportDate = [NSDate date];
                    
                    break;
                }
            }
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //
    LaBeacon *nearestLaBeacon = nil;
    CLBeacon *nearestCLBeacon = nil;
    
    //NOTE: Usando 'rangingBeacons' apenas a notificação equivalente a ENTER_REGION é utilizada.
    for (LaBeacon *beacon in beaconsToMonitor){
        
        BOOL existENTER = [self needShowEnterRegionNotificationForBeacon:beacon];
        
        if (existENTER && [[beacon codificator] isEqualToString:region.identifier]){
            for (CLBeacon *b in beacons){
                if (b.proximity == CLProximityImmediate || b.proximity == CLProximityNear){
                    if ([b.proximityUUID.UUIDString isEqualToString:beacon.proximityUUID]){
                        if ([[NSString stringWithFormat:@"%@", b.major] isEqualToString:beacon.major]){
                            if ([[NSString stringWithFormat:@"%@", b.minor] isEqualToString:beacon.minor]){
                                
                                if (nearestCLBeacon == nil){
                                    nearestCLBeacon = b;
                                    nearestLaBeacon = beacon;
                                }else{
                                    if (b.accuracy < nearestCLBeacon.accuracy && b.accuracy > 0.0){
                                        nearestCLBeacon = b;
                                        nearestLaBeacon = beacon;
                                    }
                                }
                                
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    
    if (nearestLaBeacon){
        NSString *title = NSLocalizedString(@"ALERT_TITLE_NO_APP", @"");
        
        if ([ToolBox textHelper_CheckRelevantContentInString:nearestLaBeacon.entryMessage]){
            
            if (AppD.loggedUser.userID != 0){
                title = [NSString stringWithFormat:@"%@, %@", NSLocalizedString(@"ALERT_TITLE_NO_APP", @""),AppD.loggedUser.name];
            }
            
            NSLog(@"CLBeaconRegion >> didEnterRegion >> %@", nearestLaBeacon.name);
            
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertTitle = title;
            notification.alertBody = nearestLaBeacon.entryMessage;
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.category = PUSHNOT_CATEGORY_LOCAL;
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            
            nearestLaBeacon.lastEntryReportDate = [NSDate date];
        }
    }
}

#pragma mark - Delegate Errors

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(nonnull CLBeaconRegion *)region withError:(nonnull NSError *)error
{
    NSLog(@"locationManager:rangingBeaconsDidFailForRegion:withError: %@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"locationManager:monitoringDidFailForRegion:withError: %@", [error localizedDescription]);
}

@end
