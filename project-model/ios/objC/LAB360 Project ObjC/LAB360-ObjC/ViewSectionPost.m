//
//  ViewSectionPost.m
//  GS&MD
//
//  Created by Erico GT on 1/19/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#import "ViewSectionPost.h"

@implementation ViewSectionPost

@synthesize viewHeader, viewCreatePost, imvHeaderUserPhoto, lblHeaderMessage, imvHeaderIcon, btnHeaderAction;


- (ViewSectionPost*)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self updateLayout];
    }
    return self;
}

- (ViewSectionPost*)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self updateLayout];
    }
    return self;
}

- (ViewSectionPost*)init
{
    self = [super init];
    if (self) {
        [self updateLayout];
    }
    return self;
}

- (void)updateLayout
{
    viewHeader.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.15];
    //
    viewCreatePost.backgroundColor = [UIColor whiteColor];
    [viewCreatePost.layer setCornerRadius:4.0];
    [ToolBox graphicHelper_ApplyShadowToView:viewCreatePost withColor:[UIColor blackColor] offSet:CGSizeMake(1.0, 1.0) radius:2.0 opacity:0.50];
    //
    imvHeaderUserPhoto.backgroundColor = nil;
    if (AppD.loggedUser.profilePic == nil || (AppD.loggedUser.urlProfilePic == nil || [AppD.loggedUser.urlProfilePic isEqualToString:@""])){
        imvHeaderUserPhoto.image =[[UIImage imageNamed:@"icon-user-default"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imvHeaderUserPhoto.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    }else{
        imvHeaderUserPhoto.image = AppD.loggedUser.profilePic;
    }
    [imvHeaderUserPhoto.layer setCornerRadius:20.0];
    //
    lblHeaderMessage.backgroundColor = nil;
    lblHeaderMessage.textColor = [UIColor lightGrayColor];
    lblHeaderMessage.text = NSLocalizedString(@"LABEL_POST_CREATE_NEW", @"");
    //
    imvHeaderIcon.backgroundColor = nil;
    imvHeaderIcon.image = [[UIImage imageNamed:@"icon-timeline-post-modern"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; //antigo: "icon-post-camera"
    imvHeaderIcon.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    //
    btnHeaderAction.backgroundColor = nil;
    [btnHeaderAction setTitle:@"" forState:UIControlStateNormal];
    [btnHeaderAction setTitle:@"" forState:UIControlStateHighlighted];
}

@end
