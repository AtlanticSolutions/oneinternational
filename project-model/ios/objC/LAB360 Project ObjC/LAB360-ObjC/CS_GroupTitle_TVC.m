//
//  CS_GroupTitle_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 11/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_GroupTitle_TVC.h"

@implementation CS_GroupTitle_TVC

@synthesize lblTitle, lblComplete, imvBackground;

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
    lblTitle.textColor = [UIColor whiteColor];
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblTitle.text = @"";
    
    lblComplete.backgroundColor = [UIColor clearColor];
    lblComplete.textColor = [UIColor yellowColor];
    [lblComplete setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    lblComplete.text = @"";
    
    imvBackground.backgroundColor = [UIColor darkGrayColor];
    imvBackground.layer.cornerRadius = 5.0;
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    self.lblTitle.text = element.group.name;
        
    self.lblComplete.text = [element.group groupCompletion];
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return UITableViewAutomaticDimension;
}

@end
