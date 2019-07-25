//
//  TVC_AccountBody.m
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 10/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_AccountBody.h"

@implementation TVC_AccountBody

@synthesize txtBody, ivTextField, lbTitle;

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
	[lbTitle setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [txtBody setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    //Configura imagem no textField, imagem vai ser setada na classe que utiliza o tableView
	lbTitle.textColor = AppD.styleManager.colorPalette.textNormal;
    ivTextField.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    [ivTextField setContentMode:UIViewContentModeScaleAspectFit];
    [txtBody setLeftViewMode:UITextFieldViewModeAlways];
    txtBody.leftView = ivTextField;
    
}

@end
