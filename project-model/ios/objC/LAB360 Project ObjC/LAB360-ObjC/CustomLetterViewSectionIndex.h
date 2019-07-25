//
//  CustomLetterViewSectionIndex.h
//  AHK-100anos
//
//  Created by Erico GT on 10/26/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CustomLetterViewSectionIndex : UIView

+ (nonnull CustomLetterViewSectionIndex*)createComponent;
- (void)bindWithTableView:(nonnull UITableView*)tableView;
- (void)showWithLetter:(nonnull NSString*)letterText position:(CGFloat)yPosition;

@end
