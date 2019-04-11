//
//  TVC_EventFourOptions.h
//  AHKHelper
//
//  Created by Lucas Correia on 12/10/16.
//  Copyright © 2016 Lucas Correia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_EventFourOptions : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton* btnChat;
@property (nonatomic, weak) IBOutlet UIButton* btnDownload;
@property (nonatomic, weak) IBOutlet UIButton* btnCancel;
@property (nonatomic, weak) IBOutlet UIButton* btnResearch;
@property (nonatomic, weak) IBOutlet UILabel* lblResearch;
@property (nonatomic, weak) IBOutlet UILabel* lblChat;
@property (nonatomic, weak) IBOutlet UILabel* lblDownload;
@property (nonatomic, weak) IBOutlet UILabel* lblCancel;
@property (nonatomic, weak) IBOutlet UIImageView* imgResearch;
@property (nonatomic, weak) IBOutlet UIImageView* imgChat;
@property (nonatomic, weak) IBOutlet UIImageView* imgDownload;
@property (nonatomic, weak) IBOutlet UIImageView* imgCancel;
@property (nonatomic, weak) IBOutlet UIView* viewChat;
@property (nonatomic, weak) IBOutlet UIView* viewDownload;
@property (nonatomic, weak) IBOutlet UIView* viewCancel;
@property (nonatomic, weak) IBOutlet UIView* viewResearch;
@property (nonatomic, weak) IBOutlet UIImageView* imgBackResearch;
@property (nonatomic, weak) IBOutlet UIImageView* imgBackChat;
@property (nonatomic, weak) IBOutlet UIImageView* imgBackDownload;
@property (nonatomic, weak) IBOutlet UIImageView* imgBackCancel;
@property (nonatomic, weak) IBOutlet UIImageView* imvLine;



- (void) updateLayout;

@end
