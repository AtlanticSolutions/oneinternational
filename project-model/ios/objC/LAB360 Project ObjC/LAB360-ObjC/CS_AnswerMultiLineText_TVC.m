//
//  CS_AnswerMultiLineText_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 14/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerMultiLineText_TVC.h"

@interface CS_AnswerMultiLineText_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
@property(nonatomic, assign) NSInteger maxLenght;

@end

@implementation CS_AnswerMultiLineText_TVC

@synthesize txtResultView, cellEditorDelegate, lblPlaceholder;
@synthesize cellRow, cellSection, maxLenght;

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
    
    lblPlaceholder.backgroundColor = [UIColor clearColor];
    lblPlaceholder.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0980392 alpha:0.22]; //placeholderColor
    [lblPlaceholder setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    lblPlaceholder.text = @"";
    
    [txtResultView setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    txtResultView.text = @"";
    [txtResultView setContentInset:UIEdgeInsetsMake(6.0, 4.0, 6.0, 4.0)];
    [txtResultView setInputAccessoryView:[self createAcessoryViewForTextView:txtResultView]];
    //
    [txtResultView.layer setCornerRadius:4.0];
    [txtResultView.layer setBorderColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0980392 alpha:0.22].CGColor];
    [txtResultView.layer setBorderWidth:0.5];
    
    cellRow = 0;
    cellSection = 0;
    maxLenght = 0;
    
    [lblPlaceholder setHidden:NO];
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    cellSection = indexPath.section;
    cellRow = indexPath.row;
    maxLenght = element.question.maxTextLenght;
    
    [lblPlaceholder setText:element.question.hint];
    
    CustomSurveyAnswer *ua = [element.question.userAnswers firstObject];
    if (ua){
        txtResultView.text = ua.text;
        //
        if (![ua.text isEqualToString:@""]){
            [lblPlaceholder setHidden:YES];
        }
    }
    
    [self layoutIfNeeded];
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return 140.0;
}

#pragma mark - Text Field Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (cellEditorDelegate){
        if ([cellEditorDelegate respondsToSelector:@selector(didBeginEditingTextInRect:)]){
            [cellEditorDelegate didBeginEditingTextInRect:self.frame];
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (cellEditorDelegate){
        if ([cellEditorDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
            [cellEditorDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:txtResultView.text];
        }
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Prevent crashing undo bug
    if(range.length + range.location > textView.text.length){
        return NO;
    }
    
    //Exibindo o placeholder se necessário:
    NSString *finalString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([finalString isEqualToString:@""]){
        [lblPlaceholder setHidden:NO];
    }else{
        [lblPlaceholder setHidden:YES];
    }
    
    //Max lenght
    if (maxLenght > 0){
        NSUInteger newLength = [textView.text length] + [text length] - range.length;
        if (newLength <= maxLenght){
            return YES;
        }
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - Utils

-(UIView*)createAcessoryViewForTextView:(UITextView*)textView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    UIButton *btnClear = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth/2, 40)];
    btnClear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnClear addTarget:self action:@selector(clearTextView:) forControlEvents:UIControlEventTouchUpInside];
    [btnClear setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [btnClear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClear.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]];
    [btnClear setTitle:@"Limpar" forState:UIControlStateNormal];
    [view addSubview:btnClear];
    //
    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2, 40)];
    btnDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnDone addTarget:textView action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [btnDone setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]];
    [btnDone setTitle:@"Confirmar" forState:UIControlStateNormal];
    [view addSubview:btnDone];
    
    return view;
}

- (void)clearTextView:(id)sender
{
    self.txtResultView.text = @"";
    [lblPlaceholder setHidden:NO];
}

@end
