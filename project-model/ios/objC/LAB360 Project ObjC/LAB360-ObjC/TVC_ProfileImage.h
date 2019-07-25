//
//  TVC_ProfileImage.h
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 25/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_ProfileImage : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgPhoto;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *actInd;

-(void) updateLayout;


@end
