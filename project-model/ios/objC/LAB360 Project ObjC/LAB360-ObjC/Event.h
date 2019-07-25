//
//  Event.h
//  AHKHelper
//
//  Created by Lucas Correia on 06/10/16.
//  Copyright © 2016 Lucas Correia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultObjectModelProtocol.h"
#import "ToolBox.h"

@interface Event : NSObject<DefaultObjectModelProtocol>

typedef enum {eUserRegistrationStatus_Undefined, eUserRegistrationStatus_Subscribed, eUserRegistrationStatus_Available, eUserRegistrationStatus_Cancelled, eUserRegistrationStatus_Unavailable} enumUserRegistrationStatus;

//Properties
@property (nonatomic, assign) int eventID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSDate *schedule;
@property (nonatomic, strong) NSString *local;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *registrationURL;
@property (nonatomic, strong) NSString *speakerName;
@property (nonatomic, strong) NSString *speakerDescription;
@property (nonatomic, strong) NSString *speakerPhotoURL;
//
@property (nonatomic, assign) enumUserRegistrationStatus userRegistrationStatus;


//Protocol Methods
+(Event*)newObject;
+(NSString*)className;
+(Event*)createObjectFromDictionary:(NSDictionary*)dicData;
-(Event*)copyObject;
-(NSDictionary*)dictionaryJSON;



@end
