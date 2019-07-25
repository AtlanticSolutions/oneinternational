//
//  CS_AnswerDecimal_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 16/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerDecimal_TVC.h"

@interface CS_AnswerDecimal_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
@property(nonatomic, assign) long decimalPrecision;
@property(nonatomic, strong) NSString *cleanValue;
@property(nonatomic, strong) NSString *leftSymbol;
@property(nonatomic, strong) NSString *rightSymbol;

@end

@implementation CS_AnswerDecimal_TVC

@synthesize txtNumericEntry, vcDelegate;
@synthesize cellRow, cellSection, decimalPrecision, leftSymbol, rightSymbol, cleanValue;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [txtNumericEntry setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:20.0]];
    txtNumericEntry.text = @"";
    [txtNumericEntry setTextColor:[UIColor darkGrayColor]];
    [txtNumericEntry setClearButtonMode:UITextFieldViewModeNever]; //não possui opção de apagar na própria caixa
    [txtNumericEntry setTextAlignment:NSTextAlignmentCenter];
    [txtNumericEntry setPlaceholder:@""];
    [txtNumericEntry setInputAccessoryView:[self createAcessoryViewForTextField:txtNumericEntry]];
    
    cellRow = 0;
    cellSection = 0;
    decimalPrecision = 0;
    leftSymbol = nil;
    rightSymbol = nil;
    cleanValue = @"";
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    cellSection = indexPath.section;
    cellRow = indexPath.row;
    
    decimalPrecision = element.question.decimalPrecision <= 0 ? 0 : element.question.decimalPrecision;
    
    leftSymbol = element.question.decimalLeftSymbol != nil ? [NSString stringWithFormat:@"%@", element.question.decimalLeftSymbol] : nil;
    
    rightSymbol = element.question.decimalRightSymbol != nil ? [NSString stringWithFormat:@"%@", element.question.decimalRightSymbol] : nil;
    
    [txtNumericEntry setPlaceholder:element.question.hint];
    
    CustomSurveyAnswer *ua = [element.question.userAnswers firstObject];
    if (ua){
        cleanValue = [self formatToDecimalString:ua.text];
        //
        [self formatStringForTextField:cleanValue];
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
    [self cleanStringFromTextField:textField.text];
    textField.text = cleanValue;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self cleanStringFromTextField:textField.text];
    
    if (vcDelegate){
        if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
            [vcDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:cleanValue];
        }
    }
    
    //A caixa de texto fica formatada até que a edição inicie:
    [self formatStringForTextField:cleanValue];
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
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (string.length==0) { //Delete any cases
        if(range.length > 1){
            //Delete whole word
        }
        else if(range.length == 1){
            //Delete single letter
        }
        else if(range.length == 0){
            //Tap delete key when textField empty
        }
    }
    
    cleanValue = [self formatToDecimalString:newString];
    txtNumericEntry.text = cleanValue;
    
    return NO;
}

#pragma mark - Utils

- (NSString*)formatToDecimalString:(NSString*)string
{
    NSNumber *number = @(0.0);
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.currencySymbol = @"";
    formatter.internationalCurrencySymbol = @"";
    formatter.decimalSeparator = @",";
    formatter.groupingSeparator = @".";
    formatter.maximumFractionDigits = decimalPrecision;
    formatter.minimumFractionDigits = decimalPrecision;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *resultString = [regex stringByReplacingMatchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length) withTemplate:@""];
    
    double strValue = [resultString doubleValue];
    number = [NSNumber numberWithDouble:(strValue / pow(10.0, decimalPrecision))];
    
    NSString *formatedString = [formatter stringFromNumber:number];
    
    return formatedString;
}

-(UIView*)createAcessoryViewForTextField:(UITextField*)textField
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, 40.0)];
    view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    UIButton *btnClear = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth/2.0, 40.0)];
    btnClear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnClear addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    [btnClear setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [btnClear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClear.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]];
    [btnClear setTitle:@"Limpar" forState:UIControlStateNormal];
    [view addSubview:btnClear];
    //
    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2.0, 0.0, screenWidth/2.0, 40.0)];
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
    self.txtNumericEntry.text = @""; //[self formatToDecimalString:@""];
}

- (void)cleanStringFromTextField:(NSString *)text
{
    NSString *clearString = text;
    
    clearString = [clearString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (leftSymbol){
        clearString = [clearString stringByReplacingOccurrencesOfString:leftSymbol withString:@""];
    }
    
    if (rightSymbol){
        clearString = [clearString stringByReplacingOccurrencesOfString:rightSymbol withString:@""];
    }
    
    cleanValue = clearString;
}

- (void)formatStringForTextField:(NSString*)text
{
    if ([text isEqualToString:@""] || text == nil){
        txtNumericEntry.text = @"";
    }else{
        NSString *finalString = leftSymbol != nil ? [NSString stringWithFormat:@"%@ %@", leftSymbol, text] : text;
        finalString = rightSymbol != nil ? [NSString stringWithFormat:@"%@ %@", finalString, rightSymbol] : finalString;
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            txtNumericEntry.text = finalString;
        });
    }
}

@end
