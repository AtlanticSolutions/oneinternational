//
//  TVC_FakeTextField.h
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 30/11/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_FakeTextField : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lbTitle;
@property (nonatomic, weak) IBOutlet UIButton *btnSelect;
@property (nonatomic, weak) IBOutlet UITextField *txtTitle;
@property (nonatomic, weak) IBOutlet UIImageView *imvLine;
@property (nonatomic, strong) IBOutlet UIImageView *ivTextField;

-(void) updateLayout;

@end
