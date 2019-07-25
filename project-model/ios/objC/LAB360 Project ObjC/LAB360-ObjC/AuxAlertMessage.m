//
//  AuxAlertMessage.m
//  GS&MD
//
//  Created by Lab360 on 08/09/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "AuxAlertMessage.h"

@implementation AuxAlertMessage

@synthesize showInScreen, targetName;

- (id)init
{
	self = [super init];
	if (self)
	{
		showInScreen = false;
		targetName = nil;
	}
	
	return self;
}

@end
