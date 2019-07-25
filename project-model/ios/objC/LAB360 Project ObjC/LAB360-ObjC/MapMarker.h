//
//  MapMarker.h
//  GS&MD
//
//  Created by Erico GT on 25/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapMarker : NSObject<MKAnnotation>

@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, strong, nullable) UIImage *pinImage;
@property (nonatomic, readonly) bool showInContextList;

+ (MapMarker* _Nonnull)newMarkerWithTitle:(NSString* _Nullable)markerTitle
                                 subtitle:(NSString* _Nullable)markerSubtitle
                               coordinate:(CLLocationCoordinate2D)markerCoordinate
                                    image:(UIImage* _Nullable)markerImage
                                     show:(bool)showMarker;

- (MapMarker* _Nonnull)copyObject;

@end
