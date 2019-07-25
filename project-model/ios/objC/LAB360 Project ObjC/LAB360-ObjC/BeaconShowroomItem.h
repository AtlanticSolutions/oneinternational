//
//  BeaconShowroomItem.h
//  LAB360-ObjC
//
//  Created by Erico GT on 15/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBox.h"
#import "DefaultObjectModelProtocol.h"

@interface BeaconShowroomItem : NSObject<DefaultObjectModelProtocol>

//Properties:
@property (nonatomic, assign) long itemID;
@property (nonatomic, assign) long parentItemID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) long order;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray<BeaconShowroomItem*> *subItems;
//
@property (nonatomic, assign) BOOL isMediaAdvertisingVideo;
@property (nonatomic, strong) NSString *mediaAdvertisingURL;

//Protocol Methods:
+ (BeaconShowroomItem*)newObject;
+ (BeaconShowroomItem*)createObjectFromDictionary:(NSDictionary*)dicData;
- (BeaconShowroomItem*)copyObject;
- (NSDictionary*)dictionaryJSON;

@end
