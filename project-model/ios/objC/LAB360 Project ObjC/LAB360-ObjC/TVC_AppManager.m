//
//  TVC_AppManager.m
//  LAB360-ObjC
//
//  Created by Alexandre on 28/05/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "TVC_AppManager.h"

@implementation TVC_AppManager

@synthesize lblName, lblVersion, lblBuild, imvApp;

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
    self.backgroundColor = nil;
    self.contentView.backgroundColor = nil;
    
    lblName.backgroundColor = nil;
    [lblName setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION]];
    [lblName setTextColor:AppD.styleManager.colorPalette.primaryButtonNormal];
    [lblName setText:@""];
    //
    lblVersion.backgroundColor = nil;
    [lblVersion setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [lblVersion setTextColor:[UIColor grayColor]];
    [lblVersion setText:@""];
    //
    lblBuild.backgroundColor = nil;
    [lblBuild setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [lblBuild setTextColor:[UIColor grayColor]];
    [lblBuild setText:@""];
    //
//    tvDescription.backgroundColor = nil;
//    [tvDescription setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
//    [tvDescription setTextColor:[UIColor grayColor]];
//    [tvDescription setText:@""];
//    tvDescription.editable = NO;
    
    //
    imvApp.backgroundColor = nil;
    imvApp.image = nil;
    [imvApp cancelImageRequestOperation];
}

@end
