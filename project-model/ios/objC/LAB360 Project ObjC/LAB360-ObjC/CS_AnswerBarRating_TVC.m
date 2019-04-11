//
//  CS_AnswerBarRating_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 16/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerBarRating_TVC.h"

@interface CS_AnswerBarRating_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;

@end

@implementation CS_AnswerBarRating_TVC

@synthesize vcDelegate, lblMinMessage, lblMaxMessage, segControl;
@synthesize cellRow, cellSection;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lblMinMessage.backgroundColor = [UIColor clearColor];
    lblMinMessage.textColor = [UIColor grayColor];
    [lblMinMessage setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NOTE]];
    lblMinMessage.text = @"";
    
    lblMaxMessage.backgroundColor = [UIColor clearColor];
    lblMaxMessage.textColor = [UIColor grayColor];
    [lblMaxMessage setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NOTE]];
    lblMaxMessage.text = @"";
    
    segControl.tintColor = [UIColor darkGrayColor];
    [segControl setTitleTextAttributes:@{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.backgroundNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]} forState:UIControlStateNormal];
    [segControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]} forState:UIControlStateSelected];
    for (int i=0; i<segControl.numberOfSegments; i++){
        [segControl setTitle:[NSString stringWithFormat:@"%i", i] forSegmentAtIndex:i];
    }
    [segControl setBackgroundColor:[UIColor whiteColor]];
    [segControl setSelectedSegmentIndex: UISegmentedControlNoSegment];
    
    cellRow = 0;
    cellSection = 0;
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];

    cellSection = indexPath.section;
    cellRow = indexPath.row;

    if (element.question.type == SurveyQuestionTypeBarRating){
        CustomSurveyAnswer *ua = [element.question.userAnswers firstObject];
        if (ua){
            int value = [ua.text intValue];
            if (value >=0 && value <=10){
                [segControl setSelectedSegmentIndex:value];
            }
        }
        
        if ([ToolBox textHelper_CheckRelevantContentInString:element.question.minBarRatingMessage]){
            lblMinMessage.text = element.question.minBarRatingMessage;
        }
        
        if ([ToolBox textHelper_CheckRelevantContentInString:element.question.maxBarRatingMessage]){
            lblMaxMessage.text = element.question.maxBarRatingMessage;
        }
        
    }
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return 83.0;
}

#pragma mark -

- (IBAction)segmentedControlChanged:(UISegmentedControl*)sender
{
   if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
        NSString *value = [NSString stringWithFormat:@"%li", (long)sender.selectedSegmentIndex];
        [vcDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:value];
    }
}


@end
