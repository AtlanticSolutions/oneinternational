//
//  LocationPickerViewController.m
//  LAB360-ObjC
//
//  Created by Erico GT on 08/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <MapKit/MapKit.h>
//
#import "LocationPickerViewController.h"
#import "AppDelegate.h"
#import "MapMarker.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface LocationPickerViewController()<MKMapViewDelegate>
//Data:

//Layout:
@property (nonatomic, weak) IBOutlet MKMapView *viewMap;
@property (nonatomic, weak) IBOutlet UIButton *btnConfirm;
@property (nonatomic, weak) IBOutlet UIImageView *imvMarkerPin;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *effectView;
@property (nonatomic, weak) IBOutlet UIImageView *imgPin;
@property (nonatomic, weak) IBOutlet UILabel *lblLatitude;
@property (nonatomic, weak) IBOutlet UILabel *lblLongitude;
//
@property (nonatomic, strong) MapMarker *mapMarker;
@property (nonatomic, strong) UIImage *pinImage;
@property (nonatomic, assign) BOOL needUpdateCenterMap;

@end

#pragma mark - • IMPLEMENTATION
@implementation LocationPickerViewController
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize titleScreen, showUserLocation, startLocation, viewMap, imvMarkerPin, needUpdateCenterMap, btnConfirm, mapMarker, pinImage, effectView, imgPin, lblLatitude, lblLongitude, snapShotMapView;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pinImage = [[UIImage imageNamed:@"TargetMapMarker"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [viewMap setShowsUserLocation:NO];
    [viewMap setUserTrackingMode:MKUserTrackingModeNone];
    
    needUpdateCenterMap = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:titleScreen];
    
    [viewMap setShowsPointsOfInterest:YES];
    [viewMap setShowsCompass:YES];
    
    if (startLocation){
        //[viewMap setCenterCoordinate:CLLocationCoordinate2DMake(startLocation.coordinate.latitude, startLocation.coordinate.longitude)];
        
        [self setMapViewCenterCoordinate:CLLocationCoordinate2DMake(startLocation.coordinate.latitude, startLocation.coordinate.longitude) zoomLevel:17.0 animated:NO];
        
        [self updateLabelPosition];
        //
        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
            [imvMarkerPin setAlpha:1.0];
        }];
        //
        if (showUserLocation){
            [viewMap setShowsUserLocation:YES];
        }
    }else{
        
        if (showUserLocation){
            needUpdateCenterMap = YES;
            [viewMap setShowsUserLocation:YES];
        }else{
            [self updateLabelPosition];
            //
            [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
                [imvMarkerPin setAlpha:1.0];
            }];
        }
    }

}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    if ([segue.identifier isEqualToString:@"???"]){
//        AppOptionsVC *vc = segue.destinationViewController;
//    }
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionConfirm:(id)sender
{
    [self processReverseGeocodeLocationForLatitude:viewMap.centerCoordinate.latitude longitude:viewMap.centerCoordinate.longitude];
    
//    if (mapMarker){
//
//        //Utiliza a posição do PIN (map marquer):
//        [self processReverseGeocodeLocationForLatitude:mapMarker.coordinate.latitude longitude:mapMarker.coordinate.longitude];
//
//    }else{
//
//        //Nenhum PIN foi colocado no mapa:
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        lblLatitude.text = [NSString stringWithFormat:@"latitude: %f", mapView.centerCoordinate.latitude];
        lblLongitude.text = [NSString stringWithFormat:@"longitude: %f", mapView.centerCoordinate.longitude];
    });
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
//    static NSString *annotationIdentifier = @"MapMarkerIdentifier";
//
//    if([annotation isKindOfClass:[MapMarker class]])
//    {
//        //Try to get an unused annotation, similar to uitableviewcells
//        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
//
//        //If one isn't available, create a new one
//        if(!annotationView)
//        {
//            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
//            annotationView.draggable = NO;
//            annotationView.canShowCallout = NO;
//        }
//
//        //Here's where the magic happens (^_^):
//        annotationView.image = pinImage;
//        annotationView.centerOffset = CGPointMake(0, pinImage.size.height / 2);
//
//        return annotationView;
//    }
//
//    return nil;
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
//    if([view.annotation isKindOfClass:[MapMarker class]])
//    {
//        CLLocationCoordinate2D newLocation = [mapView convertPoint:CGPointMake(view.center.x - view.centerOffset.x, view.center.y - view.centerOffset.y) toCoordinateFromView:view.superview];
//
//        mapMarker = [MapMarker newMarkerWithTitle:@"Localização" subtitle:[NSString stringWithFormat:@"LAT: %f, LNG: %f", newLocation.latitude, newLocation.longitude] coordinate:newLocation image:pinImage show:YES];
//        [[[mapView annotations] firstObject] setCoordinate:mapMarker.coordinate];
//    }
//
//    if (newState == MKAnnotationViewDragStateEnding || newState == MKAnnotationViewDragStateCanceling){
//        [view setDragState:MKAnnotationViewDragStateNone];
//    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (needUpdateCenterMap){
        needUpdateCenterMap = NO;
        //
        [self setMapViewCenterCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) zoomLevel:17.0 animated:NO];
        //
        [self updateLabelPosition];
        //
        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
            [imvMarkerPin setAlpha:1.0];
        }];
    }
    
    NSLog(@"mapView:didUpdateUserLocation: %@", userLocation);
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if (needUpdateCenterMap){
        needUpdateCenterMap = NO;
        //
        [self setMapViewCenterCoordinate:CLLocationCoordinate2DMake(viewMap.centerCoordinate.latitude, viewMap.centerCoordinate.longitude) zoomLevel:17.0 animated:NO];
        //
        [self updateLabelPosition];
        //
        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
            [imvMarkerPin setAlpha:1.0];
        }];
    }
    
    NSLog(@"mapView:didFailToLocateUserWithError: %@", [error localizedDescription]);
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //Button
    btnConfirm.backgroundColor = [UIColor clearColor];
    //[btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnConfirm.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
    [btnConfirm setTitle:@"CONFIRMAR LOCALIZAÇÃO" forState:UIControlStateNormal];
    [btnConfirm setExclusiveTouch:YES];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnConfirm.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:COLOR_MA_BLUE] forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnConfirm.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:COLOR_MA_GRAY] forState:UIControlStateHighlighted];
    //
    [btnConfirm setEnabled:YES];
    
    //Effect Background
    effectView.layer.cornerRadius = effectView.frame.size.height / 2.0;
    effectView.layer.masksToBounds = YES;
    effectView.clipsToBounds = YES;
    
    [imvMarkerPin setAlpha:0.0];
    
    imgPin.backgroundColor = nil;
    imgPin.image = pinImage;
    imgPin.tintColor = [UIColor whiteColor];
    
    lblLatitude.backgroundColor = [UIColor clearColor];
    lblLatitude.textColor = [UIColor whiteColor];
    [lblLatitude setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NOTE]];
    lblLatitude.text = @"latitude: ?";
    
    lblLongitude.backgroundColor = [UIColor clearColor];
    lblLongitude.textColor = [UIColor whiteColor];
    [lblLongitude setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NOTE]];
    lblLongitude.text = @"longitude: ?";
    
}

- (void)processReverseGeocodeLocationForLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    [self showActivityIndicatorView];
    
    CLGeocoder* geocoder = [CLGeocoder new];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSMutableDictionary *coordinateData = [NSMutableDictionary new];
        
        [coordinateData setValue:@(location.coordinate.latitude) forKey:@"SPECIAL_INPUT_KEY_LOCATION_LATITUDE"];
        
        [coordinateData setValue:@(location.coordinate.longitude) forKey:@"SPECIAL_INPUT_KEY_LOCATION_LONGITUDE"];
        
        if (error == nil && [placemarks count] > 0)
        {
            NSLog(@"Location: %@", [placemarks lastObject]);
            
            CLPlacemark* myPlacemark = [placemarks lastObject];
            
            //país
            [coordinateData setValue:[myPlacemark.addressDictionary valueForKey:@"Country"] forKey:@"SPECIAL_INPUT_KEY_LOCATION_COUNTRY"];
            
            //código país
            [coordinateData setValue:[myPlacemark.addressDictionary valueForKey:@"CountryCode"] forKey:@"SPECIAL_INPUT_KEY_LOCATION_COUNTRYCODE"];
            
            //estado
            [coordinateData setValue:[myPlacemark.addressDictionary valueForKey:@"State"] forKey:@"SPECIAL_INPUT_KEY_LOCATION_STATE"];
            
            //cidade
            [coordinateData setValue:[myPlacemark.addressDictionary valueForKey:@"City"] forKey:@"SPECIAL_INPUT_KEY_LOCATION_CITY"];
            
            //região
            [coordinateData setValue:[myPlacemark.addressDictionary valueForKey:@"SubLocality"] forKey:@"SPECIAL_INPUT_KEY_LOCATION_SUBLOCALITY"];
            
            //bairro
            NSString *name = [myPlacemark.addressDictionary valueForKey:@"Name"];
            if ([name isEqualToString:myPlacemark.subLocality] || [name isEqualToString:myPlacemark.thoroughfare] || [name isEqualToString:myPlacemark.postalCode]){
                [coordinateData setValue:[myPlacemark.addressDictionary valueForKey:@"Name"] forKey:@"SPECIAL_INPUT_KEY_LOCATION_NAME"];
            }else{
                [coordinateData setValue:@"-" forKey:@"SPECIAL_INPUT_KEY_LOCATION_NAME"];
            }
            
            //rua
            [coordinateData setValue:[myPlacemark.addressDictionary valueForKey:@"Street"] forKey:@"SPECIAL_INPUT_KEY_LOCATION_STREET"];
            
            //CEP
            [coordinateData setValue:[myPlacemark.addressDictionary valueForKey:@"ZIP"] forKey:@"SPECIAL_INPUT_KEY_LOCATION_ZIP"];
            
            //timezone
            [coordinateData setValue:[myPlacemark.timeZone description] forKey:@"SPECIAL_INPUT_KEY_LOCATION_TIMEZONE"];
            
            /*
             
            [coordinateData setValue:myPlacemark.name forKey:@"name"];
            
            //[coordinateData setValue:myPlacemark.addressDictionary forKey:@"addressDictionary"];
            
            [coordinateData setValue:myPlacemark.ISOcountryCode forKey:@"ISOcountryCode"];
            
            [coordinateData setValue:myPlacemark.country forKey:@"country"];
            
            [coordinateData setValue:myPlacemark.postalCode forKey:@"postalCode"];
            
            [coordinateData setValue:myPlacemark.administrativeArea forKey:@"administrativeArea"];
            
            [coordinateData setValue:myPlacemark.subAdministrativeArea forKey:@"subAdministrativeArea"];
            
            [coordinateData setValue:myPlacemark.locality forKey:@"locality"];
            
            [coordinateData setValue:myPlacemark.subLocality forKey:@"subLocality"];
            
            [coordinateData setValue:myPlacemark.thoroughfare forKey:@"thoroughfare"];
            
            [coordinateData setValue:myPlacemark.subThoroughfare forKey:@"subThoroughfare"];
            
            //[coordinateData setValue:myPlacemark.region forKey:@"region"];
             
             */
            
        }
        
        if (snapShotMapView){
            
            [self snapshotMapViewUsingData:coordinateData];
            
        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_PICKER_RESULT_NOTIFICATION_KEY object:coordinateData userInfo:nil];
            
            [self hideActivityIndicatorView];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }];
}

- (void)updateLabelPosition
{
    dispatch_async(dispatch_get_main_queue(), ^{
        lblLatitude.text = [NSString stringWithFormat:@"latitude: %f", viewMap.centerCoordinate.latitude];
        lblLongitude.text = [NSString stringWithFormat:@"longitude: %f", viewMap.centerCoordinate.longitude];
    });
}

- (void)setMapViewCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated {
    MKCoordinateSpan span = MKCoordinateSpanMake(0, 360/pow(2, zoomLevel) * viewMap.frame.size.width / 256.0);
    [viewMap setRegion:MKCoordinateRegionMake(centerCoordinate, span) animated:animated];
}

- (void)snapshotMapViewUsingData:(NSDictionary*)dataDic
{
    //********************************************************************************************
    //NOTE: Método A >> Usando a própria imagem da view.
    //********************************************************************************************
    
    UIImage *image = [ToolBox graphicHelper_Snapshot_View:self.view];
    //
    CGFloat goodSide = image.size.width - 20.0;
    CGFloat extra = image.size.height - goodSide;
    CGRect squareArea = CGRectMake(20.0 * image.scale, (extra / 2.0) * image.scale, goodSide * image.scale, goodSide * image.scale); //- pinImage.size.height
    //
    UIImage *croppedImage = [ToolBox graphicHelper_CropImage:image usingFrame:squareArea];
    
    NSDictionary *imgDic = [[NSDictionary alloc] initWithObjectsAndKeys:croppedImage, @"snapshot", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_PICKER_RESULT_NOTIFICATION_KEY object:dataDic userInfo:imgDic];
    
    [self hideActivityIndicatorView];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    //********************************************************************************************
    //NOTE: Método B >> Criando um snapshot do mapa, com as mesmas configurações do MapView.
    //********************************************************************************************
    
    /*
    MKMapSnapshotOptions *options = [MKMapSnapshotOptions new];
    options.camera = viewMap.camera;
    options.region = viewMap.region;
    //
    double extra = options.mapRect.size.height - options.mapRect.size.width;
    MKMapRect squareArea = MKMapRectMake(options.mapRect.origin.x, options.mapRect.origin.y + (extra / 2.0), options.mapRect.size.width, options.mapRect.size.width);
    options.mapRect = squareArea; //viewMap.visibleMapRect;
    //
    options.mapType = viewMap.mapType;
    options.showsPointsOfInterest = viewMap.showsPointsOfInterest;
    options.showsBuildings = viewMap.showsBuildings;
    //
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    options.size = CGSizeMake(viewMap.frame.size.width * scale, viewMap.frame.size.width * scale);
    options.scale = 1.0;
    //options.appearance = ?
    //
    MKMapSnapshotter *snapShotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapShotter startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        
        if (snapshot.image){
            
            NSDictionary *imgDic = [[NSDictionary alloc] initWithObjectsAndKeys:snapshot.image, @"snapshot", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_PICKER_RESULT_NOTIFICATION_KEY object:dataDic userInfo:imgDic];
            
        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_PICKER_RESULT_NOTIFICATION_KEY object:dataDic userInfo:nil];
            
        }
        
        [self hideActivityIndicatorView];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
     
    */
}
#pragma mark - UTILS (General Use)

@end
