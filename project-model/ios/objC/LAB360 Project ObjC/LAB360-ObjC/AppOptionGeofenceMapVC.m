//
//  AppOptionGeofenceMapVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 23/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <MapKit/MapKit.h>
//
#import "AppOptionGeofenceMapVC.h"
#import "AppDelegate.h"
#import "MapMarker.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AppOptionGeofenceMapVC()<MKMapViewDelegate>

//Data:
@property (nonatomic, strong) NSMutableArray<MapMarker*> *markersList;

//Layout:
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

#pragma mark - • IMPLEMENTATION
@implementation AppOptionGeofenceMapVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize screenName, regionsToShow, markersList;
@synthesize mapView;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createMarkers];
    
    if (@available(iOS 11.0, *)) {
        [mapView setMapType:MKMapTypeHybridFlyover];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:screenName];
    
    [mapView showAnnotations:markersList animated:YES];
    [self showCircularRegionInMap];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [mapView setShowsUserLocation:YES];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - MapView

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *annotationIdentifier=@"MapMarkerIdentifier";
    
    if([annotation isKindOfClass:[MapMarker class]])
    {
        //Try to get an unused annotation, similar to uitableviewcells
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        //If one isn't available, create a new one
        if(!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.canShowCallout = YES;
        }
        
        //Here's where the magic happens (^_^):
        annotationView.image = ((MapMarker*)annotation).pinImage;
        annotationView.centerOffset = CGPointMake(0, -((MapMarker*)annotation).pinImage.size.height / 2);
        
        return annotationView;
    }
    
    return nil;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleRenderer* aRenderer = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
        aRenderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.15];
        aRenderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.75];
        aRenderer.lineWidth = 2;
        return aRenderer;
    }else{
        return nil;
    }
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

- (void)createMarkers
{
    markersList = [NSMutableArray new];
    for (CLCircularRegion *region in regionsToShow){
        NSString *sub = [NSString stringWithFormat:@"LAT: %f, LONG: %f, R: %.1fm", region.center.latitude, region.center.longitude, region.radius];
        UIImage *pinImage = [UIImage imageNamed:@"PinMapGeofence"];
        MapMarker *mapMarker = [MapMarker newMarkerWithTitle:region.identifier subtitle:sub coordinate:region.center image:pinImage show:YES];
        //
        [markersList addObject:mapMarker];
    }
}

- (void)showCircularRegionInMap
{
    for (CLCircularRegion *region in regionsToShow){
        MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:region.center radius:region.radius];
        [circleOverlay setTitle:region.identifier];
        [mapView addOverlay:circleOverlay];
    }
}

#pragma mark - UTILS (General Use)

@end
