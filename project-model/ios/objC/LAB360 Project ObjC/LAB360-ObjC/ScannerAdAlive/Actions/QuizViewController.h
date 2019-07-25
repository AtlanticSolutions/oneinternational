//
//  QuizViewController.h
//  AdAlive
//
//  Created by Monique Trevisan on 12/04/15.
//  Copyright (c) 2015 Lab360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@interface QuizViewController : UIViewController <ConnectionManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSString *questionPath;

@end
