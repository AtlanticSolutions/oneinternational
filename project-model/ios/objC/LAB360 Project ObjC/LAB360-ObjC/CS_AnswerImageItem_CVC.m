//
//  CS_AsnwerImageItem_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerImageItem_CVC.h"

@implementation CS_AnswerImageItem_CVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@synthesize imvPicture;

- (void)setupLayoutWithImage:(UIImage*)picture
{
    self.backgroundColor = [UIColor clearColor];
    
    imvPicture.backgroundColor = [UIColor clearColor];
    [imvPicture setContentMode:UIViewContentModeScaleAspectFill];
    [imvPicture setClipsToBounds:YES];
    //
    imvPicture.image = picture;
    
    [self layoutIfNeeded];
}

@end
