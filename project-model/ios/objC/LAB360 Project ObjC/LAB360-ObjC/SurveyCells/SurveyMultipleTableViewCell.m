//
//  SurveyMultipleTableViewCell.m
//  AdAlive
//
//  Created by Lab360 on 1/28/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import "SurveyMultipleTableViewCell.h"

@implementation SurveyMultipleTableViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [_answerButton setTitle:@"Red Button" forState:UIControlStateNormal];
    [_answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _answerButton.circleColor = [UIColor grayColor];
    _answerButton.indicatorColor = [UIColor blueColor];
    _answerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

}

@end
