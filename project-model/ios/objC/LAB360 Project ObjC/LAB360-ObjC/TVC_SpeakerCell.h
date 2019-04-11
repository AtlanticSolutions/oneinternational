//
//  TVC_SpeakerCell.h
//  GS&MD
//
//  Created by Lab360 on 24/08/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TVC_SpeakerCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *speakerPhoto;
@property (nonatomic, weak) IBOutlet UIImageView* imvLine;
@property(nonatomic, weak) IBOutlet UILabel *lblSpeakerTitle;
@property(nonatomic, weak) IBOutlet UILabel *lblSpeakerName;
@property(nonatomic, weak) IBOutlet UILabel *lblSpeakerDescription;

- (void) updateLayout;

@end
