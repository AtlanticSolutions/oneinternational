//
//  TVC_EventDescription.h
//  AHKHelper
//
//  Created by Lucas Correia on 12/10/16.
//  Copyright © 2016 Lucas Correia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_EventDescription : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel* lblTitulo;
@property (nonatomic, weak) IBOutlet UILabel* lblTexto;
@property (nonatomic, weak) IBOutlet UIImageView* imvLine;

-(void) updateLayout;

@end
