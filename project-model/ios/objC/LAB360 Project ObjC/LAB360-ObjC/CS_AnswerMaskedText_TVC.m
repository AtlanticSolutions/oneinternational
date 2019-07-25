//
//  CS_AnswerMaskedText_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerMaskedText_TVC.h"

@interface CS_AnswerMaskedText_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
@property(nonatomic, strong) NSString *mask;

@end

@implementation CS_AnswerMaskedText_TVC

@synthesize txtResult, cellEditorDelegate;
@synthesize cellRow, cellSection, mask;

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
    [txtResult setKeyboardType:UIKeyboardTypeNumberPad];
    
    cellRow = 0;
    cellSection = 0;
    mask = nil;
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    cellSection = indexPath.section;
    cellRow = indexPath.row;
    
    if ([ToolBox textHelper_CheckRelevantContentInString:element.question.textMask]){
        mask = [NSString stringWithFormat:@"%@", element.question.textMask];
    }
    
    //mascarando o texto se necessário:
    
    [txtResult setPlaceholder:element.question.hint];
    
    CustomSurveyAnswer *ua = [element.question.userAnswers firstObject];
    if (ua){
        if (mask){
            txtResult.text = [ToolBox textHelper_UpdateMaskToText:ua.text usingMask:mask];
        }else{
            txtResult.text = ua.text;
        }
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
    NSString *noMaskText = [ToolBox textHelper_RemoveMaskToText:txtResult.text usingCharacters:TOOLBOX_TEXT_MASK_DEFAULT_CHARS_SET];
    
    if (cellEditorDelegate){
        if ([cellEditorDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
            [cellEditorDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:noMaskText];
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
    
    //NOTE: 'Max lenght' não precisa ser utilizado com text mascarado
    
    if (mask) {
        
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        bool ignore = false;
        
        if(range.length == 1 && /* Only do for single deletes */ string.length < range.length && [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound){
            
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length-1;
            if(location > 0)
            {
                for(; location > 0; location--)
                {
                    if(isdigit([changedString characterAtIndex:location]))
                    {
                        break;
                    }
                }
                changedString = [changedString substringToIndex:location];
            }
            else{
                ignore = true;
            }
        }
        
        if (ignore){
            textField.text = @"";
        }else{
            textField.text = [self filteredStringFromString:changedString filter:mask];
        }
        
        return NO;
    } else {
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

- (NSMutableString*) filteredStringFromString:(NSString*)string filter:(NSString*)filter
{
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done)
    {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
            {
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
            }break;
            default:
            {
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
            }break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSMutableString stringWithUTF8String:outputString];
}

@end
