//
//  CS_AnswerOptions_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerOptions_TVC.h"

@interface CS_AnswerOptions_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, strong) UIImage *arrowImage;

@end

@implementation CS_AnswerOptions_TVC

@synthesize btnOptions, vcDelegate, cellRow, cellSection, selectedIndex, arrowImage;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    arrowImage = [ToolBox graphicHelper_ImageWithTintColor:[UIColor grayColor] andImageTemplate:[UIImage imageNamed:@"icon-down-arrow"]];
}

- (void)setupLayout
{
    [self layoutIfNeeded];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    btnOptions.backgroundColor = [UIColor clearColor];
    [btnOptions setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnOptions.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TITLE_NAVBAR];
    [btnOptions setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    [btnOptions setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOptions.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btnOptions setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOptions.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:[UIColor groupTableViewBackgroundColor]] forState:UIControlStateHighlighted];
    [btnOptions setTitle:@"selecione" forState:UIControlStateNormal];
    [btnOptions setExclusiveTouch:YES];
    [btnOptions setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    //
    [btnOptions.layer setCornerRadius:4.0];
    [btnOptions.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [btnOptions.layer setBorderWidth:0.5];
    
    UIImageView *imv = [btnOptions viewWithTag:99];
    if (imv == nil){
        imv = [[UIImageView alloc] initWithFrame:CGRectMake(btnOptions.frame.size.width - 35.0, 5.0, 30.0, 30.0)]; //posição não final (a constraint fará o trabalho correto)
        [imv setContentMode:UIViewContentModeScaleAspectFit];
        imv.image = arrowImage;
        imv.tag = 99;
        //
        [btnOptions addSubview:imv];
        //inserção de constraints para posicionar o ícone no ponto correto
        UILayoutGuide *lGuide = btnOptions.layoutMarginsGuide;
        [[imv.heightAnchor constraintEqualToConstant:30.0] setActive:YES];
        [[imv.widthAnchor constraintEqualToConstant:30.0] setActive:YES];
        [[imv.trailingAnchor constraintEqualToAnchor:lGuide.trailingAnchor constant:5.0] setActive:YES];
        [[imv.centerYAnchor constraintEqualToAnchor:lGuide.centerYAnchor] setActive:YES];
        [imv setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    cellRow = 0;
    cellSection = 0;
    selectedIndex = -1;
    
    [self.contentView layoutIfNeeded];
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    cellRow = indexPath.row;
    cellSection = indexPath.section;
    
    //NOTE: se a resposta atual estiver na lista de respostas do usuário o elemento está respondido:
    CustomSurveyAnswer *sa = [element.question.userAnswers firstObject];
    
    NSString *newTitle = @"";
    if (sa){
        for (int i=0; i<element.question.answers.count; i++){
            CustomSurveyAnswer *a = [element.question.answers objectAtIndex:i];
            if (sa.answerID == a.answerID){
                selectedIndex = i;
                newTitle = a.text;
                break;
            }
        }
    }
    
    if (selectedIndex > -1){
        [btnOptions setTitle:newTitle forState:UIControlStateNormal];
        [btnOptions setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        btnOptions.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    }else{
        if ([ToolBox textHelper_CheckRelevantContentInString:element.question.hint]){
            [btnOptions setTitle:element.question.hint forState:UIControlStateNormal];
        }
    }
    
    [self layoutIfNeeded];
    [tableView beginUpdates];
    [tableView endUpdates];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return 60.0;
}

#pragma mark - Actions

- (IBAction)actionDropDown:(id)sender
{
    if (vcDelegate){
        [vcDelegate requireOptionsListForComponentAtSection:cellSection row:cellRow];
    }
}

@end
