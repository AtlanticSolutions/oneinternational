//
//  CS_AnswerOrderlyOptions_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 04/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerOrderlyOptions_TVC.h"

@interface CS_AnswerOrderlyOptions_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;

@end

@implementation CS_AnswerOrderlyOptions_TVC

@synthesize cellRow, cellSection;
@synthesize lblOrder, lblOption;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self layoutIfNeeded];
    
    lblOrder.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lblOrder.textColor = [UIColor darkGrayColor];
    [lblOrder setFont:[UIFont fontWithName:FONT_DEFAULT_BOLD size:20.0]];
    lblOrder.text = @"";
    //
    lblOrder.layer.cornerRadius = 4.0;
    lblOrder.clipsToBounds = YES;
    
    lblOption.backgroundColor = [UIColor clearColor];
    lblOption.textColor = [UIColor grayColor];
    [lblOption setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblOption.text = @"";
    
    cellRow = 0;
    cellSection = 0;
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    cellRow = indexPath.row;
    cellSection = indexPath.section;
    
    NSInteger originalIndex = element.answer.referenceIndex;
    
    CustomSurveyAnswer *userAnswer = [element.question.userAnswers objectAtIndex:originalIndex];
    
    self.lblOrder.text = [NSString stringWithFormat:@"%li", userAnswer.referenceIndex];
    self.lblOption.text = userAnswer.text;
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return UITableViewAutomaticDimension;
}

//- (IBAction)actionUp:(UIButton*)sender
//{
//    if (cellDelegate){
//        [cellDelegate activateOptionInComponentAtSection:cellSection row:cellRow ascending:YES];
//    }
//}
//
//- (IBAction)actionDown:(UIButton*)sender
//{
//    if (cellDelegate){
//        [cellDelegate activateOptionInComponentAtSection:cellSection row:cellRow ascending:NO];
//    }
//}

@end
