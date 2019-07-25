//
//  TVC_SubmitOrderTotal.m
//  GS&MD
//
//  Created by Erico GT on 18/10/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "TVC_SubmitOrderTotal.h"

@implementation TVC_SubmitOrderTotal

@synthesize lblTotalTitle, lblTotalValue;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) updateLayout
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    //Background:
    lblTotalTitle.backgroundColor = nil;
    lblTotalValue.backgroundColor = nil;
    
    //Texts:
    lblTotalTitle.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS];
    lblTotalTitle.textColor = [UIColor darkTextColor];
    lblTotalValue.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:24.0];
    lblTotalValue.textColor = COLOR_MA_GREEN;
    
    lblTotalTitle.text = @"Total do pedido:";
    lblTotalValue.text = @"";
}

@end
