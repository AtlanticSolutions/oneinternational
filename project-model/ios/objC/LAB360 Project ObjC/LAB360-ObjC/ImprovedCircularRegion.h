//
//  ImprovedCircularRegion.h
//  Siga
//
//  Created by Erico GT on 28/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface ImprovedCircularRegion : CLCircularRegion

@property (nonatomic, assign) long regionID;
@property (nonatomic, assign) CLLocationDegrees minSpeed;
@property (nonatomic, assign) CLLocationDegrees maxSpeed;
@property (nonatomic, assign) CLLocationDegrees direction;

- (ImprovedCircularRegion*) copyRegion;

@end
