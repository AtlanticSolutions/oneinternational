//
//  TVC_NewsItem.h
//  AHK-100anos
//
//  Created by Erico GT on 10/31/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_NewsItem : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* lblTitle;
@property (nonatomic, weak) IBOutlet UILabel* lblSummary;
@property (nonatomic, weak) IBOutlet UIImageView* imvPhoto;
@property (nonatomic, weak) IBOutlet UIImageView* imvLine;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;

-(void) updateLayout;

@end
