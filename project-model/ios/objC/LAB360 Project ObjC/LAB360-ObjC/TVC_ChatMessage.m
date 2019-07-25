//
//  TVC_ChatMessage.m
//  AHK-100anos
//
//  Created by Erico GT on 11/7/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#import "TVC_ChatMessage.h"

@implementation TVC_ChatMessage

@synthesize imvBackground, lblDate, lblUser, lblMessage, indicator, imvIcon, imvBackName;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateLayoutForSender:(enumChatMessageSender)sender withActivity:(enumChatMessageStatus)messageStatus
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    lblUser.textColor = [UIColor whiteColor];
    lblMessage.textColor = [UIColor whiteColor];
    
    if (sender == eChatMessageSender_Self){
        imvBackground.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
        [imvBackground.layer setCornerRadius:5.0];
        [ToolBox graphicHelper_ApplyShadowToView:imvBackground withColor:[UIColor blackColor] offSet:CGSizeMake(2.0, 2.0) radius:4.0 opacity:0.5];
        lblDate.textColor = AppD.styleManager.colorPalette.primaryButtonSelected;
        indicator.color = AppD.styleManager.colorPalette.primaryButtonSelected;
    }else{
        imvBackground.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
        [imvBackground.layer setCornerRadius:5.0];
        [ToolBox graphicHelper_ApplyShadowToView:imvBackground withColor:[UIColor blackColor] offSet:CGSizeMake(2.0, 2.0) radius:4.0 opacity:0.5];
        lblDate.textColor = AppD.styleManager.colorCalendarAvailable;
        indicator.color = AppD.styleManager.colorCalendarAvailable;
    }
    
    [imvBackName.layer setCornerRadius:5.0];
    
    [lblDate setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL]];
    [lblUser setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL]];
    [lblMessage setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    
    lblUser.backgroundColor = [UIColor clearColor];
    imvBackName.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.10];
    lblMessage.backgroundColor = [UIColor clearColor];
    
    imvIcon.backgroundColor = [UIColor clearColor];
    imvIcon.image = [[UIImage imageNamed:@"icon-send-message-error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imvIcon.tintColor = [UIColor redColor];
    
    if (messageStatus == eChatMessageStatus_Sending){
        indicator.hidden = NO;
        [indicator startAnimating];
        lblDate.alpha = 0.0f;
        imvIcon.alpha = 0.0f;
    }else if(messageStatus == eChatMessageStatus_Error){
        indicator.hidden = YES;
        [indicator stopAnimating];
        lblDate.alpha = 0.0f;
        imvIcon.alpha = 1.0;
    }else{
        indicator.hidden = YES;
        [indicator stopAnimating];
        lblDate.alpha = 1.0f;
        imvIcon.alpha = 0.0;
    }
}
@end
