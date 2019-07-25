//
//  BeaconShowroomItemTVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "BeaconShowroomItemTVC.h"
#import "AppDelegate.h"

@interface BeaconShowroomItemTVC()

@property(nonatomic, weak) IBOutlet NSLayoutConstraint *leftNameConstraint;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *leftDetailConstraint;

@end

@implementation BeaconShowroomItemTVC

@synthesize imvItemImage, activityIndicator, lblName, lblDetail, leftNameConstraint, leftDetailConstraint;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) updateLayoutUsingImage:(BOOL)showImage
{
    [self layoutIfNeeded];
    
    self.backgroundColor = nil;
    
    [imvItemImage setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    imvItemImage.image = nil;
    imvItemImage.contentMode = UIViewContentModeScaleAspectFill;
    [imvItemImage cancelImageRequestOperation];
    //
    [lblName setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:18.0]];
    [lblName setTextColor:[UIColor darkTextColor]];
    [lblName setBackgroundColor:nil];
    //
    [lblDetail setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:14.0]];
    [lblDetail setTextColor:[UIColor grayColor]];
    [lblDetail setBackgroundColor:nil];
    //
    activityIndicator.color = AppD.styleManager.colorPalette.backgroundNormal;
    [activityIndicator setHidesWhenStopped:YES];
    [activityIndicator stopAnimating];
    //
    if (showImage){
        leftNameConstraint.constant = 20.0 + imvItemImage.frame.size.width;
        leftDetailConstraint.constant = 20.0 + imvItemImage.frame.size.width;
        //
        [imvItemImage setHidden:NO];
    }else{
        leftNameConstraint.constant = 10.0;
        leftDetailConstraint.constant = 10.0;
        //
        [imvItemImage setHidden:YES];
    }
    //
    [self layoutIfNeeded];
}

@end
