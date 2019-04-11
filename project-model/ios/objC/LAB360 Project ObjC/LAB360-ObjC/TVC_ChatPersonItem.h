//
//  TVC_ChatPersonItem.h
//  GS&MD
//
//  Created by Erico GT on 1/30/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVC_ChatPersonItem : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* lblTitle;
@property (nonatomic, weak) IBOutlet UILabel* lblNote;
@property (nonatomic, weak) IBOutlet UILabel* lblLocal;
@property (nonatomic, weak) IBOutlet UIImageView* imvLine;
@property (nonatomic, weak) IBOutlet UIImageView* imvArrow;

-(void) updateLayout;

@end
