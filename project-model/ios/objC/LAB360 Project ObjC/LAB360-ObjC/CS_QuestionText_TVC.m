//
//  CS_QuestionText_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 11/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_QuestionText_TVC.h"

@implementation CS_QuestionText_TVC

@synthesize lblText;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lblText.backgroundColor = [UIColor clearColor];
    lblText.textColor = [UIColor darkTextColor];
    [lblText setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblText.text = @"";
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    if (element.question.required && !element.question.discreteDisplay){
       
        //precisa de uma indicação visual de obrigatoriedade:
        
        UIFont *fontRequired = [UIFont fontWithName:FONT_SAN_FRANCISCO_MEDIUM size:FONT_SIZE_LABEL_SMALL];
        UIFont *fontText = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
        //
        NSDictionary *textAttributesRequired = @{NSFontAttributeName:fontRequired, NSForegroundColorAttributeName:COLOR_MA_RED};
        NSDictionary *textAttributesText = @{NSFontAttributeName:fontText, NSForegroundColorAttributeName:[UIColor darkTextColor]};
        //
        NSAttributedString *textR = [[NSAttributedString alloc] initWithString:@"OBRIGATÓRIA\n\n" attributes:textAttributesRequired]; // ⚠️ ❗️ 📌
        NSAttributedString *textT = [[NSAttributedString alloc] initWithString:element.question.text attributes:textAttributesText];
        //
        NSMutableAttributedString *finalAttributedString = [NSMutableAttributedString new];
        [finalAttributedString appendAttributedString:textR];
        [finalAttributedString appendAttributedString:textT];
        //
        self.lblText.attributedText = finalAttributedString;
        
    }else{
        
        if (element.question.discreteDisplay){
            self.contentView.backgroundColor = [UIColor whiteColor];
            lblText.textColor = [UIColor darkGrayColor];
            [lblText setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
        }
        
        self.lblText.text = element.question.text;
    }
            
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    
    if ([parametersData isKindOfClass:[CustomSurveyCollectionElement class]]){
        CustomSurveyCollectionElement *element = (CustomSurveyCollectionElement*)parametersData;
        
        if (element.question.required){
            
            if (element.question.discreteDisplay){
                
                if (![ToolBox textHelper_CheckRelevantContentInString:element.question.text]){
                    return 0.0;
                }
                
            }
            
        }else{
            
            if (![ToolBox textHelper_CheckRelevantContentInString:element.question.text]){
                return 0.0;
            }
            
        }
       
    }
    
    return UITableViewAutomaticDimension;
}

@end
