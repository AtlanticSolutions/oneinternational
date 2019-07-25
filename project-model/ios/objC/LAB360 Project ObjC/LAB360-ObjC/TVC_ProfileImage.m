//
//  TVC_ProfileImage.m
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 25/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_ProfileImage.h"


@implementation TVC_ProfileImage

@synthesize imgPhoto, actInd;

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
    [actInd setColor:AppD.styleManager.colorPalette.backgroundNormal];
    actInd.hidden = true;
}


@end
