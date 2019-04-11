//
//  TVC_AssociateShare.h
//  AHK-100anos
//
//  Created by Erico GT on 10/24/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_AssociateShare : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton* btnLinkedin;
@property (nonatomic, weak) IBOutlet UIButton* btnFacebook;
@property (nonatomic, weak) IBOutlet UIButton* btnTwitter;
@property (nonatomic, weak) IBOutlet UIButton* btnShare;
@property (nonatomic, weak) IBOutlet UIImageView* imvLine;
@property (nonatomic, weak) IBOutlet UIImageView* imvLogo;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* activityIndicator;

-(void) updateLayout;

@end
