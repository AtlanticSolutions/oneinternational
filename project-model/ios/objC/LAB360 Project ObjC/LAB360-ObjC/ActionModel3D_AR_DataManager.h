//
//  ActionModel3D_AR_DataManager.h
//  LAB360-ObjC
//
//  Created by Erico GT on 24/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionModel3D_AR.h"
#import "ViewControllerModel.h"

@interface ActionModel3D_AR_DataManager : NSObject

+ (ActionModel3D_AR_DataManager*)sharedInstance;
//
- (BOOL)saveActionModel3D:(ActionModel3D_AR*)model;
- (ActionModel3D_AR*)loadResourcesFromDiskUsingReference:(ActionModel3D_AR*)model;

@end
