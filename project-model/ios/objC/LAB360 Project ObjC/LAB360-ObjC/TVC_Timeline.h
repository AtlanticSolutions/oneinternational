//
//  TVC_Timeline.h
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 26/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface TVC_Timeline : UITableViewCell
typedef enum {eTypeTimeline_Top, eTypeTimeline_Bottom, eTypeTimeline_Body} enumTypeTimeline;

@property (nonatomic, weak) IBOutlet UIImageView *imgTime;
@property (nonatomic, weak) IBOutlet UILabel *lblYear;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UIImageView *imgLine;


-(void) updateLayoutWithType:(enumTypeTimeline)type;



@end
