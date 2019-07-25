//
//  CVC_Team_Member.h
//  GS&MD
//
//  Created by Erico GT on 11/29/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CVC_Team_Member : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UIImageView *imvPerson;
@property(nonatomic, weak) IBOutlet UIImageView *imvFooter;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic, weak) IBOutlet UILabel *lblName;

- (void)updateLayout;

@end
