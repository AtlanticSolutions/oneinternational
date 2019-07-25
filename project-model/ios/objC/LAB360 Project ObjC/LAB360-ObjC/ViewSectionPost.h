//
//  ViewSectionPost.h
//  GS&MD
//
//  Created by Erico GT on 1/19/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewSectionPost : UIView

@property (nonatomic, weak) IBOutlet UIView *viewHeader;
@property (nonatomic, weak) IBOutlet UIView *viewCreatePost;
@property (nonatomic, weak) IBOutlet UIImageView *imvHeaderUserPhoto;
@property (nonatomic, weak) IBOutlet UILabel *lblHeaderMessage;
@property (nonatomic, weak) IBOutlet UIImageView *imvHeaderIcon;
@property (nonatomic, weak) IBOutlet UIButton *btnHeaderAction;

- (void)updateLayout;

@end
