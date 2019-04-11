//
//  RegionService.m
//  LAB360-ObjC
//
//  Created by Erico GT on 22/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "RegionService.h"

@interface RegionService()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *regionsToMonitor;
@end

@implementation RegionService

@synthesize delegate, locationManager, regionsToMonitor;

- (RegionService*)init
{
    self = [super init];
    if (self)
    {
        [self configureLocationManager];
        //
        delegate = nil;
        regionsToMonitor = nil;
    }
    return self;
}

+ (RegionService*)newRegionService
{
    RegionService *rs = [RegionService new];
    return rs;
}

- (void)registerRegionsToMonitor:(NSArray<GeofenceRegion*>*)regions
{
    regionsToMonitor = [NSMutableArray new];
    
    if (locationManager == nil){
        [self configureLocationManager];
    }else{
        for (CLCircularRegion *region in [locationManager monitoredRegions]){
            [locationManager stopMonitoringForRegion:region];
        }
    }
    
    for (GeofenceRegion* gr in regions){
        [regionsToMonitor addObject:[gr copyObject]];
    }
}

- (void)startMonitoringRegisteredRegions
{
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [locationManager requestAlwaysAuthorization];
    }else if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways){
        [self startMonitoring];
    }
}

- (void)stopMonitoringRegisteredRegions
{
    for (GeofenceRegion *region in regionsToMonitor){
        CLCircularRegion *geoRegion = [[CLCircularRegion alloc] initWithCenter:region.location.coordinate radius:region.radius identifier:region.identifier];
        [locationManager stopMonitoringForRegion:geoRegion];
    }
}

- (void)stopMonitoringEspecificRegion:(GeofenceRegion*)region
{
    CLCircularRegion *geoRegion = [[CLCircularRegion alloc] initWithCenter:region.location.coordinate radius:region.radius identifier:region.identifier];
    [locationManager stopMonitoringForRegion:geoRegion];
}

- (void)restartMessagesForAllMonitoredRegions
{
    //TODO:
}

#pragma mark - PRIVATE

- (void)configureLocationManager
{
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    [locationManager setAllowsBackgroundLocationUpdates:NO]; //YES para uso em background-mode
    [locationManager setPausesLocationUpdatesAutomatically:NO];
    if (@available(iOS 11.0, *)) {
        [self.locationManager setShowsBackgroundLocationIndicator:NO];
    }
    //
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;    
}

- (void)startMonitoring
{
    for (GeofenceRegion* region in regionsToMonitor){
        
        //b.lastEntryReportDate = nil;
        //b.lastExitReportDate = nil;
        
        if (region.radius > self.locationManager.maximumRegionMonitoringDistance) {
            region.radius = self.locationManager.maximumRegionMonitoringDistance;
        }
        
        // Criando a região geográfica de monitoramento
        CLCircularRegion *geoRegion = [[CLCircularRegion alloc] initWithCenter:region.location.coordinate radius:region.radius identifier:region.identifier];
        
        if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
            [locationManager startMonitoringForRegion:geoRegion];
        }
    }
}

#pragma mark - Location Delegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways){
        [self startMonitoring];
    }
}

#pragma mark - Regions methods

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    if ([region isKindOfClass:[CLCircularRegion class]] && region.identifier != nil){
        for (GeofenceRegion *region in regionsToMonitor){
            if ([region.identifier isEqualToString:region.identifier]){
                
                if (delegate){
                    if ([delegate respondsToSelector:@selector(regionService:didFailMonitoringToRegion:withError:)]){
                        [delegate regionService:self didFailMonitoringToRegion:region.identifier withError:error];
                    }
                }
                //
                break;
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLCircularRegion class]] && region.identifier != nil){
        for (GeofenceRegion *region in regionsToMonitor){
            if ([region.identifier isEqualToString:region.identifier]){
                
                if (delegate){
                    if ([delegate respondsToSelector:@selector(regionService:didStartMonitoringToRegion:)]){
                        [delegate regionService:self didStartMonitoringToRegion:region.identifier];
                    }
                }
                //
                break;
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLCircularRegion class]] && region.identifier != nil){
        for (GeofenceRegion *region in regionsToMonitor){
            if ([region.identifier isEqualToString:region.identifier]){
                
                if (delegate){
                    if ([delegate respondsToSelector:@selector(regionService:didEnterInRegion:)]){
                        [delegate regionService:self didEnterInRegion:region.identifier];
                    }
                }
                //
                break;
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLCircularRegion class]] && region.identifier != nil){
        for (GeofenceRegion *region in regionsToMonitor){
            if ([region.identifier isEqualToString:region.identifier]){
                
                if (delegate){
                    if ([delegate respondsToSelector:@selector(regionService:didExitFromRegion:)]){
                        [delegate regionService:self didExitFromRegion:region.identifier];
                    }
                }
                //
                break;
            }
        }
    }
}
@end
