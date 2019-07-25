//
//  CS_AnswerSingleLineText_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerSingleLineText_TVC.h"

@interface CS_AnswerSingleLineText_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
@property(nonatomic, assign) NSInteger maxLenght;
@property(nonatomic, strong) NSString *regex;

@end

@implementation CS_AnswerSingleLineText_TVC

@synthesize txtResult, cellEditorDelegate;
@synthesize cellRow, cellSection, maxLenght, regex;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [txtResult setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    txtResult.text = @"";
    [txtResult setClearButtonMode:UITextFieldViewModeWhileEditing];
    [txtResult setPlaceholder:@""];
    [txtResult setInputAccessoryView:[self createAcessoryViewForTextField:txtResult]];
    
    cellRow = 0;
    cellSection = 0;
    maxLenght = 0;
    regex = nil;
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    cellSection = indexPath.section;
    cellRow = indexPath.row;
    maxLenght = element.question.maxTextLenght;
    
    if ([ToolBox textHelper_CheckRelevantContentInString:element.question.regexValidator]){
        regex = [NSString stringWithFormat:@"%@", element.question.regexValidator];
    }
    
    [txtResult setPlaceholder:element.question.hint];
    
    CustomSurveyAnswer *ua = [element.question.userAnswers firstObject];
    if (ua){
        txtResult.text = ua.text;
    }
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return 60.0;
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (cellEditorDelegate){
        if ([cellEditorDelegate respondsToSelector:@selector(didBeginEditingTextInRect:)]){
            [cellEditorDelegate didBeginEditingTextInRect:self.frame];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (cellEditorDelegate){
        
        if (regex && maxLenght == 0){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if([predicate evaluateWithObject:textField.text]){
                //Aprovado!
                if ([cellEditorDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
                    [cellEditorDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:txtResult.text];
                }
            }else{
                //Desaprovado!
                textField.text = @"";
                //
                if ([cellEditorDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValidationErrorMessage:)]){
                    [cellEditorDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValidationErrorMessage:@"Formato de dados inválido. Por favor, verifique sua resposta."];
                }
            }
        }else{
            if ([cellEditorDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
                [cellEditorDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:txtResult.text];
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Prevent crashing undo bug
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    
    //Max lenght
    if (maxLenght > 0){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (newLength <= maxLenght){
            return YES;
        }
        return NO;
    }else{
         return YES;
    }
}

#pragma mark - Utils

-(UIView*)createAcessoryViewForTextField:(UITextField*)textField
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    UIButton *btnClear = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth/2, 40)];
    btnClear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnClear addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    [btnClear setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [btnClear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClear.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]];
    [btnClear setTitle:@"Limpar" forState:UIControlStateNormal];
    [view addSubview:btnClear];
    //
    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2, 40)];
    btnDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnDone addTarget:textField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [btnDone setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]];
    [btnDone setTitle:@"Confirmar" forState:UIControlStateNormal];
    [view addSubview:btnDone];
    
    return view;
}

- (void)clearTextField:(id)sender
{
    self.txtResult.text = @"";
}

@end
