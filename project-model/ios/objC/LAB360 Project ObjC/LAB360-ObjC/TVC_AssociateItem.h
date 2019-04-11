//
//  TVC_AssociateItem.h
//  AHK-100anos
//
//  Created by Erico GT on 10/21/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVC_AssociateItem : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* lblTitle;
@property (nonatomic, weak) IBOutlet UIImageView* imvLine;
@property (nonatomic, weak) IBOutlet UIImageView* imvArrow;

-(void) updateLayout;

@end
