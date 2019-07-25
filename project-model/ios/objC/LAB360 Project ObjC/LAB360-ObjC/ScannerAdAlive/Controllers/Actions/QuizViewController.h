//
//  QuizViewController.h
//  AdAlive
//
//  Created by Monique Trevisan on 12/04/15.
//  Copyright (c) 2015 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdAliveConnectionManager.h"

@interface QuizViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSString *questionPath;

@end
