//
//  MapMarker.m
//  GS&MD
//
//  Created by Erico GT on 25/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "MapMarker.h"

@interface MapMarker()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImage *pinImage;
@property (nonatomic, assign) bool showInContextList;

@end

@implementation MapMarker

@synthesize title, subtitle, coordinate, pinImage, showInContextList;

- (instancetype)init
{
    self = [super init];
    if (self) {
        title = @"";
        subtitle = @"";
        coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
        pinImage = nil;
        showInContextList = true;
    }
    return self;
}

+ (MapMarker* _Nonnull)newMarkerWithTitle:(NSString* _Nullable)markerTitle subtitle:(NSString* _Nullable)markerSubtitle coordinate:(CLLocationCoordinate2D)markerCoordinate image:(UIImage* _Nullable)markerImage show:(bool)showMarker;
{
    MapMarker *marker = [MapMarker new];
    marker.title = markerTitle;
    marker.subtitle = markerSubtitle;
    marker.coordinate = markerCoordinate;
    marker.pinImage = markerImage;
    marker.showInContextList = showMarker;
    //
    return marker;
}

- (MapMarker* _Nonnull)copyObject
{
    MapMarker *marker = [MapMarker new];
    marker.title = self.title ? [NSString stringWithFormat:@"%@", self.title] : nil;
    marker.subtitle = self.subtitle ? [NSString stringWithFormat:@"%@", self.subtitle] : nil;
    marker.coordinate = CLLocationCoordinate2DMake(self.coordinate.latitude, self.coordinate.longitude);
    marker.pinImage = self.pinImage ? [UIImage imageWithData:UIImagePNGRepresentation(self.pinImage)] : nil;
    marker.showInContextList = self.showInContextList;
    //
    return marker;
}

@end
