//
//  TVC_AccountBody.h
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 10/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_AccountBody : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lbTitle;
@property (nonatomic, weak) IBOutlet UITextField *txtBody;
@property (nonatomic, strong) IBOutlet UIImageView *ivTextField;

-(void) updateLayout;

@end
