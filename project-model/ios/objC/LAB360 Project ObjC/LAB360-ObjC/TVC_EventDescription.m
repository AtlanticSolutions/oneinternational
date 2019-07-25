//
//  TVC_EventDescription.m
//  AHKHelper
//
//  Created by Lucas Correia on 12/10/16.
//  Copyright © 2016 Lucas Correia. All rights reserved.
//

#import "TVC_EventDescription.h"

@implementation TVC_EventDescription

@synthesize lblTexto, lblTitulo, imvLine;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateLayout
{
    self.backgroundColor = [UIColor clearColor];
    
    [lblTitulo setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_SMALL]];
    [lblTitulo setTextColor:AppD.styleManager.colorCalendarAvailable];
    lblTitulo.backgroundColor = [UIColor clearColor];
    
    [lblTexto setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [lblTexto setTextColor: [UIColor blackColor]];
    lblTexto.backgroundColor = [UIColor clearColor];
    
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor lightGrayColor]];
    
}

@end
