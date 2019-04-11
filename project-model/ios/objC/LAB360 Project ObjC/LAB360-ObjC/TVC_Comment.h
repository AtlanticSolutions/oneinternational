//
//  TVC_Comment.h
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 18/01/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ToolBox.h"
#import "UIImageView+AFNetworking.h"

@interface TVC_Comment : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imvProfile;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblDate;
@property (nonatomic, weak) IBOutlet UILabel *lblComment;
@property (nonatomic, weak) IBOutlet UIImageView *imvLine;


-(void) updateLayout;

@end
