//
//  RecommendedTableViewCell.h
//  AdAlive
//
//  Created by Monique Trevisan on 11/17/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendedTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@end
