//
//  TVC_SimpleButton.h
//  ShoppingBH
//
//  Created by lordesire on 02/11/2017.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_SimpleButton : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *btnSubmit;

-(void) updateLayoutWithButtonTitle:(NSString*)buttonTitle;

@end
