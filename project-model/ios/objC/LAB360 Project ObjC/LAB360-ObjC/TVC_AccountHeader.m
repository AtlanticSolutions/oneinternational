//
//  TVC_AccountHeader.m
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 10/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_AccountHeader.h"

@implementation TVC_AccountHeader

@synthesize btnPhoto;

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
    [btnPhoto setBackgroundColor:[UIColor clearColor]];
    //
    [btnPhoto setTitle:@"" forState:UIControlStateNormal];
    [btnPhoto setTitle:@"" forState:UIControlStateHighlighted];
    //
    btnPhoto.layer.cornerRadius = btnPhoto.bounds.size.width/2;
    [btnPhoto setClipsToBounds:YES];
    
    //
    [btnPhoto.imageView setContentMode:UIViewContentModeScaleAspectFit];

}


@end
