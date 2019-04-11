//
//  TVC_AssociateItem.m
//  AHK-100anos
//
//  Created by Erico GT on 10/21/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_AssociateItem.h"
#import "AppDelegate.h"

@implementation TVC_AssociateItem

@synthesize lblTitle, imvLine, imvArrow;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}

- (void) updateLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [lblTitle setTextColor:[UIColor darkGrayColor]];
    lblTitle.backgroundColor = [UIColor clearColor];
    //
    imvArrow.backgroundColor = [UIColor clearColor];
    imvArrow.image = [[UIImage imageNamed:@"icon-right-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvArrow setTintColor:[UIColor darkGrayColor]];
    //
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    
}

@end
