//
//  SurveyNumberTableViewCell.h
//  AdAlive
//
//  Created by Lab360 on 1/28/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyNumberTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UISlider *sliderAnswer;
@property(nonatomic, weak) IBOutlet UILabel *lbSelectedValue;
@property(nonatomic, strong) NSString *isAnswered;

@end
