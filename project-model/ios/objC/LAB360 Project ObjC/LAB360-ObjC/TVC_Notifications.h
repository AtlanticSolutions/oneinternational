//
//  TVC_Notifications.h
//  GS&MD
//
//  Created by Lab360 on 06/09/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVC_Notifications : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *imvArrow;
@property(nonatomic, weak) IBOutlet UILabel *lblDescription;
@property(nonatomic, weak) IBOutlet UIImageView *imvLine;

- (void) updateLayoutWithArrowVisible:(bool)arrowVisible;

@end
