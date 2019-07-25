//
//  CarouselViewItem.m
//  LAB360-ObjC
//
//  Created by Erico GT on 06/03/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//


#import "CarouselViewItem.h"
#import "AppDelegate.h"
#import "ToolBox.h"

@implementation CarouselViewItem

@synthesize lblNote, imvItem, indicatorView;

+ (CarouselViewItem*)createNewComponentWithFrame:(CGRect)frame
{
    CarouselViewItem *customView = [CarouselViewItem new];
    [customView setFrame:frame];
    
    //image
    customView.imvItem = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, customView.frame.size.width - 10.0, customView.frame.size.height)];
    [customView.imvItem setBackgroundColor:[UIColor clearColor]];
    [customView.imvItem setContentMode:UIViewContentModeScaleAspectFit];
    customView.imvItem.image = nil;
    //
    [customView addSubview:customView.imvItem];
    
    //text
    customView.lblNote = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, customView.frame.size.width - 10.0, customView.frame.size.height)];
    [customView.lblNote setBackgroundColor:[UIColor clearColor]];
    customView.lblNote.textColor = COLOR_MA_GRAY; //[UIColor darkTextColor];
    [customView.lblNote setTextAlignment:NSTextAlignmentCenter];
    [customView.lblNote setAdjustsFontSizeToFitWidth:YES];
    [customView.lblNote setMinimumScaleFactor:0.2];
    [customView.lblNote setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_LARGE]];
    customView.lblNote.text = @"";
    //
    [customView addSubview:customView.lblNote];
    
    //indicator
    customView.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    customView.indicatorView.center = CGPointMake(customView.frame.size.width / 2.0, customView.frame.size.height / 2.0);
    [customView.indicatorView setColor:[UIColor darkTextColor]];
    [customView.indicatorView stopAnimating];
    //
    [customView addSubview:customView.indicatorView];
    
    [customView bringSubviewToFront:customView.lblNote];
    [customView bringSubviewToFront:customView.indicatorView];
    
    return customView;
}

@end
