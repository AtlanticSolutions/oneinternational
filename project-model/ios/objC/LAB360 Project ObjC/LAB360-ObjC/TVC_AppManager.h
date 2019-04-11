//
//  TVC_AppManager.h
//  LAB360-ObjC
//
//  Created by Alexandre on 28/05/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface TVC_AppManager : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* lblName;
@property (nonatomic, weak) IBOutlet UILabel* lblVersion;
@property (nonatomic, weak) IBOutlet UILabel* lblBuild;
//@property (nonatomic, weak) IBOutlet UITextView *tvDescription;
@property (nonatomic, weak) IBOutlet UIButton *btAction;
@property (nonatomic, weak) IBOutlet UIButton *btInfo;
@property (nonatomic, weak) IBOutlet UIImageView* imvApp;

-(void) updateLayout;

@end
