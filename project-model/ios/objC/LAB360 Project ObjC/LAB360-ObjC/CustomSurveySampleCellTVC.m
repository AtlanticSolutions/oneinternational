//
//  CustomSurveySampleCellTVC.m
//  LAB360-ObjC
//
//  Created by lordesire on 21/01/2019.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CustomSurveySampleCellTVC.h"
#import "ConstantsManager.h"
#import "ToolBox.h"

@implementation CustomSurveySampleCellTVC

@synthesize lblTitle, lblDescription, lblNote, imvArrow, noteWidthConstraint;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor darkTextColor];
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblTitle.text = @"";
    
    lblDescription.backgroundColor = [UIColor clearColor];
    lblDescription.textColor = [UIColor grayColor];
    [lblDescription setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    lblDescription.text = @"";
    
    lblNote.backgroundColor = [UIColor clearColor];
    lblNote.textColor = [UIColor whiteColor];
    [lblNote setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL]];
    lblNote.text = @"";
    //
    [lblNote setClipsToBounds:NO];
    lblNote.layer.masksToBounds = YES;
    [lblNote.layer setCornerRadius:lblNote.frame.size.height / 2.0];
    //
    [ToolBox graphicHelper_ApplyShadowToView:lblNote withColor:[UIColor blackColor] offSet:CGSizeMake(1.0, 1.0) radius:2.0 opacity:0.5];
    [lblNote setHidden:YES];
    
    noteWidthConstraint.constant = self.contentView.bounds.size.width / 2.0;
    
    imvArrow.backgroundColor = [UIColor clearColor];
    imvArrow.contentMode = UIViewContentModeScaleAspectFit;
    imvArrow.image = [UIImage imageNamed:@"RightPaddingArrow"];
    
    [self.contentView layoutIfNeeded];
}

- (void)updateNoteLabelWithText:(NSString*)newNote
{
    CGRect textRect = [newNote boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, lblNote.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lblNote.font} context:nil];
    CGFloat newWidth = textRect.size.width > (self.contentView.frame.size.width * 0.9) ? (self.contentView.frame.size.width * 0.9) : textRect.size.width;
    //
    lblNote.text = newNote;
    noteWidthConstraint.constant = newWidth + 20.0;
    //
    [self.contentView layoutIfNeeded];
}

@end
