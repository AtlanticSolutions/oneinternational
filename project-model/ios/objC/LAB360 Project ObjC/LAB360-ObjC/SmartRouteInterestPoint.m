//
//  SmartRouteInterestPoint.m
//  Siga
//
//  Created by Erico GT on 27/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "SmartRouteInterestPoint.h"

#define CLASS_SMARTROUTE_INTERESTPOINT_DEFAULT @"custom_banners"
#define CLASS_SMARTROUTE_INTERESTPOINT_ID @"id"
#define CLASS_SMARTROUTE_INTERESTPOINT_NAME @"name"
#define CLASS_SMARTROUTE_INTERESTPOINT_URLIMAGE @"image_url"
#define CLASS_SMARTROUTE_INTERESTPOINT_PHONE @"phone_number"
#define CLASS_SMARTROUTE_INTERESTPOINT_MESSAGE @"message"
#define CLASS_SMARTROUTE_INTERESTPOINT_LINK @"href"
#define CLASS_SMARTROUTE_INTERESTPOINT_LOCATIONS @"locations"

@implementation SmartRouteInterestPoint

@synthesize pointID, name, bannerURL, bannerImage, phoneNumber, message, link, pointsList;

//-------------------------------------------------------------------------------------------------------------
#pragma mark - Init
//-------------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        pointID = 0;
        name = nil;
        bannerURL = nil;
        bannerImage = nil;
        phoneNumber = nil;
        message = nil;
        link = nil;
        pointsList = nil;
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------
#pragma mark - DefaultObjectModelProtocol
//-------------------------------------------------------------------------------------------------------------

+ (SmartRouteInterestPoint*)newObject
{
    SmartRouteInterestPoint *srip = [SmartRouteInterestPoint new];
    return srip;
}

+ (SmartRouteInterestPoint*)createObjectFromDictionary:(NSDictionary*)dicData
{
    SmartRouteInterestPoint *p = [SmartRouteInterestPoint new];
    
    //NSDictionary *dic = [dicData valueForKey:[User className]];
    NSDictionary *neoDic = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicData withString:@""];
    
    NSArray *keysList = [neoDic allKeys];
    
    if (keysList.count > 0)
    {
        p.pointID = [keysList containsObject:CLASS_SMARTROUTE_INTERESTPOINT_ID] ? [[neoDic  valueForKey:CLASS_SMARTROUTE_INTERESTPOINT_ID] longValue] : p.pointID;
        
        p.name = [keysList containsObject:CLASS_SMARTROUTE_INTERESTPOINT_NAME] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SMARTROUTE_INTERESTPOINT_NAME]] : p.name;
        
        p.bannerURL = [keysList containsObject:CLASS_SMARTROUTE_INTERESTPOINT_URLIMAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SMARTROUTE_INTERESTPOINT_URLIMAGE]] : p.bannerURL;
        
        //p.bannerImage = nil;
        
        p.phoneNumber = [keysList containsObject:CLASS_SMARTROUTE_INTERESTPOINT_PHONE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SMARTROUTE_INTERESTPOINT_PHONE]] : p.phoneNumber;
        
        p.link = [keysList containsObject:CLASS_SMARTROUTE_INTERESTPOINT_LINK] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SMARTROUTE_INTERESTPOINT_LINK]] : p.link;
        
        p.message = [keysList containsObject:CLASS_SMARTROUTE_INTERESTPOINT_MESSAGE] ? [NSString stringWithFormat:@"%@", [neoDic  valueForKey:CLASS_SMARTROUTE_INTERESTPOINT_MESSAGE]] : p.message;
        
        if ([keysList containsObject:CLASS_SMARTROUTE_INTERESTPOINT_LOCATIONS]) {
            NSArray *array = [[NSArray alloc] initWithArray:[neoDic  valueForKey:CLASS_SMARTROUTE_INTERESTPOINT_LOCATIONS]];
            p.pointsList = [NSMutableArray new];
            for (NSDictionary *dic in array){
                
                long rID = [[dic  valueForKey:@"id"] longValue];
                NSString *regionID = [NSString stringWithFormat:@"point_%li", rID];
                double lat = [[dic valueForKey:@"latitude"] doubleValue];
                double lon = [[dic valueForKey:@"longitude"] doubleValue];
                double radius = [[dic valueForKey:@"radius"] doubleValue];
                //
                double minSpeed = 0.0; //[[dic valueForKey:@"min_speed"] doubleValue];
                double maxSpeed = 0.0; //[[dic valueForKey:@"max_speed"] doubleValue];
                double direction = 0.0; //[[dic valueForKey:@"direction"] doubleValue];
                //
                ImprovedCircularRegion *icr = [[ImprovedCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(lat, lon) radius:radius identifier:regionID];
                icr.regionID = rID;
                icr.minSpeed = minSpeed;
                icr.maxSpeed = maxSpeed;
                icr.direction = direction;
                //
                [p.pointsList addObject:icr];
            }
        }
    }
    
    return p;
}

- (SmartRouteInterestPoint*)copyObject
{
    SmartRouteInterestPoint *c = [SmartRouteInterestPoint new];
    c.pointID = self.pointID;
    c.name = self.name ? [NSString stringWithFormat:@"%@", self.name] : nil;
    c.bannerURL = self.bannerURL ? [NSString stringWithFormat:@"%@", self.bannerURL] : nil;
    c.bannerImage = self.bannerImage.CGImage == nil ? nil : [UIImage imageWithData:UIImagePNGRepresentation(self.bannerImage)];
    c.phoneNumber = self.phoneNumber ? [NSString stringWithFormat:@"%@", self.phoneNumber] : nil;
    c.link = self.link ? [NSString stringWithFormat:@"%@", self.link] : nil;
    c.message = self.message ? [NSString stringWithFormat:@"%@", self.message] : nil;
    if (self.pointsList == nil){
        c.pointsList = nil;
    }else{
        c.pointsList = [NSMutableArray new];
        for (ImprovedCircularRegion *region in self.pointsList){
            [c.pointsList addObject:[region copyRegion]];
        }
    }
    //
    return c;
}

- (SmartRouteInterestPoint*)copyReducedObject
{
    SmartRouteInterestPoint *c = [SmartRouteInterestPoint new];
    c.pointID = self.pointID;
    c.name = self.name ? [NSString stringWithFormat:@"%@", self.name] : nil;
    c.bannerURL = self.bannerURL ? [NSString stringWithFormat:@"%@", self.bannerURL] : nil;
    c.bannerImage = self.bannerImage.CGImage == nil ? nil : [UIImage imageWithData:UIImagePNGRepresentation(self.bannerImage)];
    c.phoneNumber = self.phoneNumber ? [NSString stringWithFormat:@"%@", self.phoneNumber] : nil;
    c.link = self.link ? [NSString stringWithFormat:@"%@", self.link] : nil;
    c.message = self.message ? [NSString stringWithFormat:@"%@", self.message] : nil;
    c.pointsList = nil;
    //
    return c;
}

- (NSDictionary*)dictionaryJSON
{
    //TODO: precisa finalizar
    return nil;
}

@end
