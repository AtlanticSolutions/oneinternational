//
//  CS_AnswerStarRating_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 16/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerStarRating_TVC.h"

@interface CS_AnswerStarRating_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
@property(nonatomic, strong) NSArray *buttonsList;
//
@property(nonatomic, strong) UIImage *fullStarImage;
@property(nonatomic, strong) UIImage *emptyStarImage;

@end

@implementation CS_AnswerStarRating_TVC

@synthesize vcDelegate, btnStar1, btnStar2, btnStar3, btnStar4, btnStar5;
@synthesize cellRow, cellSection, buttonsList, fullStarImage, emptyStarImage;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    fullStarImage = [UIImage imageNamed:@"CustomSurveyIconRatingStarFull"];
    emptyStarImage = [UIImage imageNamed:@"CustomSurveyIconRatingStarEmpty"];
    //
    buttonsList = [[NSArray alloc] initWithObjects:btnStar1, btnStar2, btnStar3, btnStar4, btnStar5, nil];
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [btnStar1 setBackgroundColor:[UIColor clearColor]];
    [btnStar1 setExclusiveTouch:YES];
    [btnStar1 setImage:emptyStarImage forState:UIControlStateNormal];
    btnStar1.tag = 1;
    //
    [btnStar2 setBackgroundColor:[UIColor clearColor]];
    [btnStar2 setExclusiveTouch:YES];
    [btnStar2 setImage:emptyStarImage forState:UIControlStateNormal];
    btnStar2.tag = 2;
    //
    [btnStar3 setBackgroundColor:[UIColor clearColor]];
    [btnStar3 setExclusiveTouch:YES];
    [btnStar3 setImage:emptyStarImage forState:UIControlStateNormal];
    btnStar3.tag = 3;
    //
    [btnStar4 setBackgroundColor:[UIColor clearColor]];
    [btnStar4 setExclusiveTouch:YES];
    [btnStar4 setImage:emptyStarImage forState:UIControlStateNormal];
    btnStar4.tag = 4;
    //
    [btnStar5 setBackgroundColor:[UIColor clearColor]];
    [btnStar5 setExclusiveTouch:YES];
    [btnStar5 setImage:emptyStarImage forState:UIControlStateNormal];
    btnStar5.tag = 5;
    
    cellRow = 0;
    cellSection = 0;
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    cellSection = indexPath.section;
    cellRow = indexPath.row;
    
    if (element.question.type == SurveyQuestionTypeStarRating){
        
        CustomSurveyAnswer *ua = [element.question.userAnswers firstObject];
        if (ua){
            int value = [ua.text intValue];
            
            for (UIButton *b in buttonsList){
                if (b.tag <= value){
                    [b setImage:fullStarImage forState:UIControlStateNormal];
                }
            }
        }
    }
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return 60.0;
}

#pragma mark -

- (IBAction)actionStartSelection:(UIButton*)sender
{
    if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
        NSString *value = [NSString stringWithFormat:@"%li", (long)sender.tag];
        [vcDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:value];
    }
}


@end
