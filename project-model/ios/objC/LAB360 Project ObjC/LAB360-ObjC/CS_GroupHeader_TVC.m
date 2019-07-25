//
//  CS_GroupHeader_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 11/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_GroupHeader_TVC.h"

@implementation CS_GroupHeader_TVC

@synthesize lblMessage, imvBackground;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textColor = [UIColor darkGrayColor];
    [lblMessage setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NOTE]];
    lblMessage.text = @"";
    
    imvBackground.backgroundColor = [UIColor groupTableViewBackgroundColor]; //SURVEY_COLOR_LIGHTBLUE
    imvBackground.layer.cornerRadius = 5.0;
    imvBackground.layer.borderColor = [UIColor lightGrayColor].CGColor; //SURVEY_COLOR_BLUE.CGColor
    imvBackground.layer.borderWidth = 1.5;
    [imvBackground setAlpha:0.4];
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    self.lblMessage.text = element.group.headerMessage;
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return UITableViewAutomaticDimension;
}

@end
