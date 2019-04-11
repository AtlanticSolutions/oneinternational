//
//  TVC_FakeTextField.m
//  GS&MD
//
//  Created by Lucas Correia Granados Castro on 30/11/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_FakeTextField.h"

@implementation TVC_FakeTextField

@synthesize txtTitle, btnSelect, imvLine, ivTextField, lbTitle;

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
	
	[lbTitle setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [txtTitle setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    
    //ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    lbTitle.textColor = AppD.styleManager.colorPalette.textNormal;
	ivTextField.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    [ivTextField setContentMode:UIViewContentModeScaleAspectFit];
    [txtTitle setLeftViewMode:UITextFieldViewModeAlways];
    txtTitle.leftView = ivTextField;
    
    btnSelect.backgroundColor = [UIColor clearColor];
    [btnSelect setTitle:@"" forState:UIControlStateNormal];
    [btnSelect setTitle:@"" forState:UIControlStateHighlighted];
    
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
}

@end
