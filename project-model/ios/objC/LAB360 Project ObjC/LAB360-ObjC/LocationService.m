//
//  LocationServiceControl.m
//  Carrorama3
//
//  Created by Érico Gimenes on 14/12/15.
//  Copyright © 2015 going2. All rights reserved.
//


#import "LocationService.h"
#import "AppDelegate.h"
#import "ConstantsManager.h"

@interface LocationService()

@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LocationService

@synthesize locationManager, authorizationStatus, locationError, statusMessage;
@synthesize updateCount, latitude, longitude;
@synthesize name, addressDictionary, ISOcountryCode, country, postalCode, administrativeArea, subAdministrativeArea, locality, subLocality, thoroughfare, subThoroughfare, region;

+ (id)sharedLocation {
	static LocationService *sharedMyLocation = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedMyLocation = [[self alloc] init];
	});
	return sharedMyLocation;
}

- (LocationService*)init
{
    self = [super init];
    if (self)
    {
        [self resetData];
        //
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

+ (LocationService*)initAndStartMonitoringLocation
{
    LocationService *lsc = [LocationService sharedLocation];
	
//    if ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
//        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
//    {
//        [lsc.locationManager requestAlwaysAuthorization];
//    }
    
    if ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [lsc.locationManager requestWhenInUseAuthorization];
    }
	
    [lsc startMonitoringLocation];
    return lsc;
}

- (void)startMonitoringLocation
{
    NSLog(@"Iniciando monitoramento GPS!");

    [locationManager startUpdatingLocation];
    authorizationStatus = [CLLocationManager authorizationStatus];
}

- (void)stopMonitoring
{
    NSLog(@"Parando monitoramento GPS!");
    [self resetData];
    [locationManager stopUpdatingLocation];
}

- (void)resetData
{
    updateCount = 0;
    //
    authorizationStatus = kCLAuthorizationStatusNotDetermined;
    locationError = -1;
    statusMessage = @"OK!";
    //
    latitude = 0.0;
    longitude = 0.0;
    //
    name = nil;
    addressDictionary = nil;
    ISOcountryCode = nil;
    country = nil;
    postalCode = nil;
    administrativeArea = nil;
    subAdministrativeArea = nil;
    locality = nil;
    subLocality = nil;
    thoroughfare = nil;
    subThoroughfare = nil;
    region = nil;
}

#pragma mark - Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    updateCount += 1;
    
    latitude = manager.location.coordinate.latitude;
    longitude = manager.location.coordinate.longitude;
    
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0)
        {
            CLPlacemark* myPlacemark = [placemarks lastObject];
            //
            name = myPlacemark.name;
            addressDictionary = myPlacemark.addressDictionary;
            ISOcountryCode = myPlacemark.ISOcountryCode;
            country = myPlacemark.country;
            postalCode = myPlacemark.postalCode;
            administrativeArea = myPlacemark.administrativeArea;
            subAdministrativeArea = myPlacemark.subAdministrativeArea;
            locality = myPlacemark.locality;
            subLocality = myPlacemark.subLocality;
            thoroughfare = myPlacemark.thoroughfare;
            subThoroughfare = myPlacemark.subThoroughfare;
            region = myPlacemark.region;
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NO_LocationServiceGeocodeInfoUpdate" object:nil userInfo:nil];
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    locationError = [error code];
    statusMessage = error.domain;
}

@end
