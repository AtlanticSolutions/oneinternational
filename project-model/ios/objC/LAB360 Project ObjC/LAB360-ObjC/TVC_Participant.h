//
//  TVC_Participant.h
//  GS&MD
//
//  Created by Erico GT on 12/2/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_Participant : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* lblTitle;
@property (nonatomic, weak) IBOutlet UILabel* lblTime;
@property (nonatomic, weak) IBOutlet UILabel* lblRole;
@property (nonatomic, weak) IBOutlet UIImageView* imvLine;
@property (nonatomic, weak) IBOutlet UIImageView* imvThumbnail;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* activityIndicator;

-(void) updateLayout;

@end
