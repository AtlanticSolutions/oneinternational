//
//  RecommendedTableViewCell.m
//  AdAlive
//
//  Created by Monique Trevisan on 11/17/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import "RecommendedTableViewCell.h"

@implementation RecommendedTableViewCell

- (void)awakeFromNib {
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
