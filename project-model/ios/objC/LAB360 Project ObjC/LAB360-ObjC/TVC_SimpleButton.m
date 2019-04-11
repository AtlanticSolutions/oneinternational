//
//  TVC_SimpleButton.m
//  ShoppingBH
//
//  Created by lordesire on 02/11/2017.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_SimpleButton.h"

@implementation TVC_SimpleButton

@synthesize btnSubmit;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

-(void) updateLayoutWithButtonTitle:(NSString*)buttonTitle
{
    self.backgroundColor = nil;
    //
    btnSubmit.backgroundColor = nil;
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS];
    [btnSubmit setTitle:buttonTitle forState:UIControlStateNormal];
    [btnSubmit setExclusiveTouch:YES];
    [btnSubmit setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSubmit.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
}

@end
