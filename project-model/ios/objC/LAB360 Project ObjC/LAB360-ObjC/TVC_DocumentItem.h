//
//  TVC_DocumentItem.h
//  CozinhaTudo
//
//  Created by lucas on 18/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"

@interface TVC_DocumentItem : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblDocTitle;
@property(nonatomic, weak) IBOutlet UIImageView *imvDoc;

-(void) updateLayout;

@end
