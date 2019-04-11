//
//  SmartRouteInterestPoint.h
//  Siga
//
//  Created by Erico GT on 27/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//
#import "ImprovedCircularRegion.h"
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"

@interface SmartRouteInterestPoint : NSObject

//Properties:
@property (nonatomic, assign) long pointID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* bannerURL;
@property (nonatomic, strong) UIImage* bannerImage;
@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, strong) NSString* link;
@property (nonatomic, strong) NSString* message;
//
@property (nonatomic, strong) NSMutableArray<ImprovedCircularRegion*>* pointsList;

//Protocol Methods:
+ (SmartRouteInterestPoint*)newObject;
+ (SmartRouteInterestPoint*)createObjectFromDictionary:(NSDictionary*)dicData;
- (SmartRouteInterestPoint*)copyObject;
- (SmartRouteInterestPoint*)copyReducedObject;
- (NSDictionary*)dictionaryJSON;

//{
//    "custom_banners": [
//                       {
//                           "id": 1,
//                           "name": "Região Rodovia 1",
//                           "url_image": "www.urlimage.com.br",
//                           "phone_number" : "(11)1234-5678",
//                           "message" : "Utilize este número para pedir ajuda, etc, etc...",
//                           "locations": [
//                           {
//                               "id" : 1,
//                               "latitude" : "-23.5019783",
//                               "longitude" : "-46.8464165",
//                               "radius" : 100.0
//                           },
//                           {
//                               "id" : 2,
//                               "latitude" : "-23.5019783",
//                               "longitude" : "-46.8464165",
//                               "radius" : 100.0
//                           }
//                                         ]
//                       }
//                       ]
//}

@end
