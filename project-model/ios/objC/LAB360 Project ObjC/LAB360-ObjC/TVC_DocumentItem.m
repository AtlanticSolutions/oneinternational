//
//  TVC_DocumentItem.m
//  CozinhaTudo
//
//  Created by lucas on 18/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "TVC_DocumentItem.h"

@implementation TVC_DocumentItem

@synthesize imvDoc, lblDocTitle;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateLayout {
    
    self.backgroundColor = [UIColor clearColor];
    
    lblDocTitle.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_NORMAL];
    lblDocTitle.textColor = AppD.styleManager.colorPalette.textDark;
    imvDoc.layer.masksToBounds = YES;
    imvDoc.layer.cornerRadius = 5.0f;
}

@end
