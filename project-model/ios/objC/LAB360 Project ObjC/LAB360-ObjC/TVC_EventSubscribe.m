//
//  TVC_EventSubscribe.m
//  AHKHelper
//
//  Created by Lucas Correia on 12/10/16.
//  Copyright © 2016 Lucas Correia. All rights reserved.
//

#import "TVC_EventSubscribe.h"

@implementation TVC_EventSubscribe

@synthesize btnSubscribe, imvLine, btnDownloads;

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
    btnSubscribe.backgroundColor = [UIColor clearColor];
    [btnSubscribe.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    [btnSubscribe setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSubscribe.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnSubscribe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //
    btnDownloads.backgroundColor = [UIColor clearColor];
    [btnDownloads.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    [btnDownloads setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSubscribe.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal] forState:UIControlStateNormal];
    [btnDownloads setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor grayColor]];

}

@end
