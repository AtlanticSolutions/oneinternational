//
//  TVC_SideMenuItem.m
//  AHK-100anos
//
//  Created by Erico GT on 10/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_SideMenuItem.h"

@interface TVC_SideMenuItem()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contraintLeftPadding;

@end

@implementation TVC_SideMenuItem

@synthesize lblItem, lblFeature, lblBadge, imvFlag,imvLine, imvIcon, imvShortcut, contraintLeftPadding;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
////    dispatch_async(dispatch_get_main_queue(), ^(void){
////
////        [self setBackgroundColor:AppD.styleManager.colorButtonBackgroundNormal];
////        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
////            [self setBackgroundColor:AppD.styleManager.colorPalette.backgroundNormal];
////        } completion:^(BOOL finished) {
////            nil;
////        }];
////    });
//}

- (void)updateLayoutWithImage:(UIImage*)iconImage highlighted:(BOOL)highlighted
{
    self.backgroundColor = [UIColor whiteColor];
    //
    lblItem.backgroundColor = [UIColor clearColor];
	lblItem.textColor = [UIColor darkGrayColor]; //AppD.styleManager.colorTextNormal;
    if (highlighted) {
        lblItem.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:FONT_SIZE_TITLE_NAVBAR];
        //lblItem.shadowColor = AppD.styleManager.colorPalette.backgroundNormal;
        //lblItem.shadowOffset = CGSizeMake(1.0f, 1.0f);
    } else {
        lblItem.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
        //lblItem.shadowColor = nil;
        //lblItem.shadowOffset = CGSizeMake(0.0f, 0.0f);
    }
    lblItem.text = @"";
    //
    lblFeature.backgroundColor = [UIColor clearColor];
    lblFeature.textColor = AppD.styleManager.colorPalette.backgroundNormal; //[UIColor grayColor];
    lblFeature.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:12.0];
    [lblFeature setTextAlignment:NSTextAlignmentRight];
    lblFeature.text = @"";
    //
    lblBadge.backgroundColor = [UIColor redColor];
    lblBadge.textColor = [UIColor whiteColor];
    lblBadge.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:14.0];
    lblBadge.layer.cornerRadius = lblBadge.frame.size.height / 2.0;
    lblBadge.layer.masksToBounds = YES;
    lblBadge.text = @"";
    //
    imvFlag.backgroundColor = [UIColor clearColor];
    imvFlag.tintColor = [UIColor lightGrayColor];
    //
    imvLine.backgroundColor = [UIColor clearColor];
    imvLine.image = [[UIImage imageNamed:@"line-separator-tableviewcell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imvLine setTintColor:[UIColor grayColor]];
	//
	imvIcon.backgroundColor = [UIColor clearColor];
	//imvIcon.tintColor = [UIColor grayColor];
	imvIcon.image = iconImage;
	if (iconImage){
		contraintLeftPadding.constant = 45.0;
	}else{
		contraintLeftPadding.constant = 16.0;
	}
    //
    imvShortcut.backgroundColor = [UIColor clearColor];
    imvShortcut.image = [UIImage imageNamed:@"side-menu-shortcut-indicator-background.png"];
    [imvShortcut setHidden:YES];
    //
    [self layoutIfNeeded];
    
}

@end
