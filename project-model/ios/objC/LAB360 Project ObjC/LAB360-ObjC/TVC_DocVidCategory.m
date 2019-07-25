//
//  TVC_DocVidCategory.m
//  CozinhaTudo
//
//  Created by lucas on 12/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "TVC_DocVidCategory.h"
#import "AppDelegate.h"

@implementation TVC_DocVidCategory

@synthesize lblCategory, imvCategory;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateLayout {
    
    [lblCategory setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NORMAL]];
    lblCategory.textColor = AppD.styleManager.colorPalette.textDark;
    
}

@end
