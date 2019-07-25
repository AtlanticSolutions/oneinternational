//
//  TVC_Timeline.m
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 26/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_Timeline.h"

@implementation TVC_Timeline
@synthesize imgLine, imgTime, lblName, lblYear;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) updateLayoutWithType:(enumTypeTimeline)type
{
    self.backgroundColor = [UIColor whiteColor];
    //
    [lblYear setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_SMALL]];
    [lblYear setTextColor:AppD.styleManager.colorCalendarAvailable];
    lblYear.backgroundColor = [UIColor clearColor];
    
    [lblName setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [lblName setTextColor: [UIColor blackColor]];
    lblName.backgroundColor = [UIColor clearColor];
    
    imgLine.backgroundColor = [UIColor clearColor];
    imgLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imgLine setTintColor:[UIColor lightGrayColor]];
    
    //inicio
    if(type == eTypeTimeline_Top)
    {
        imgTime.image = [UIImage imageNamed:@"icon-timelline-top"];
    }
    //meio
    else if(type == eTypeTimeline_Body)
    {
        imgTime.image = [UIImage imageNamed:@"icon-timelline-middle"];
    }
    //fim
    else if(type == eTypeTimeline_Bottom)
    {
        imgTime.image = [UIImage imageNamed:@"icon-timelline-bottom"];
    }
}


@end
