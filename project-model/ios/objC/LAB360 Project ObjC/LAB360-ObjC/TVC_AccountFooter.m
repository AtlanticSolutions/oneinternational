//
//  TVC_AccountFooter.m
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 10/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_AccountFooter.h"

@implementation TVC_AccountFooter

@synthesize btnSave;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateLayout
{
    self.backgroundColor = [UIColor clearColor];
    //
    [btnSave setBackgroundColor:[UIColor clearColor]];
    //
    btnSave.backgroundColor = [UIColor clearColor];
    [btnSave.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    [btnSave setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSave.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnSave setTitle:NSLocalizedString(@"BUTTON_TITLE_ACCOUNT_SAVE", @"") forState:UIControlStateNormal];
    [btnSave setTitle:NSLocalizedString(@"BUTTON_TITLE_ACCOUNT_SAVE", @"") forState:UIControlStateHighlighted];
    
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
