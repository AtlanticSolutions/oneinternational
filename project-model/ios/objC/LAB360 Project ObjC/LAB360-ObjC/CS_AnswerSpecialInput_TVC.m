//
//  CS_AnswerSpecialInput_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 08/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerSpecialInput_TVC.h"

@interface CS_AnswerSpecialInput_TVC()

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
@property(nonatomic, assign) NSInteger maxLenght;
@property(nonatomic, assign) SurveySpecialInputType inputType;
@end

@implementation CS_AnswerSpecialInput_TVC

@synthesize txtResultView, vcDelegate, lblPlaceholder, btnInput;
@synthesize cellRow, cellSection, maxLenght, inputType;

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
    [lblPlaceholder setHidden:YES];
    
    [txtResultView setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    txtResultView.text = @"";
    [txtResultView setContentInset:UIEdgeInsetsMake(6.0, 4.0, 6.0, 4.0)];
    [txtResultView setInputAccessoryView:[self createAcessoryViewForTextView:txtResultView]];
    [txtResultView setBackgroundColor:COLOR_MA_LIGHTYELLOW];
    [txtResultView setTextColor:[UIColor darkTextColor]];
    //
    [txtResultView.layer setCornerRadius:4.0];
    [txtResultView.layer setBorderColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0980392 alpha:0.22].CGColor];
    [txtResultView.layer setBorderWidth:0.5];
    //
    [txtResultView setEditable:NO];
    [txtResultView setSelectable:NO];
    
    [btnInput setBackgroundColor:[UIColor grayColor]];
    [btnInput setTitle:@"" forState:UIControlStateNormal];
    [btnInput setExclusiveTouch:YES];
    [btnInput.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnInput setImageEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)];
    [btnInput setTintColor:[UIColor whiteColor]];
    //
    [btnInput setClipsToBounds:YES];
    btnInput.layer.cornerRadius = 4.0;
    [btnInput setEnabled:YES];
    
    cellRow = 0;
    cellSection = 0;
    maxLenght = 0;
    inputType = SurveySpecialInputTypeNormal;
    
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    cellSection = indexPath.section;
    cellRow = indexPath.row;
    maxLenght = element.question.maxTextLenght;
    inputType = element.question.specialInputType;
    
    [lblPlaceholder setText:element.question.hint];
    
    switch (inputType) {

        case SurveySpecialInputTypeNormal:{
            [btnInput setBackgroundColor:COLOR_MA_GRAY];
            [btnInput setImage:[[UIImage imageNamed:@"SurveySpecialInputIconNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }break;
            
        case SurveySpecialInputTypeGeolocation:{
            [btnInput setBackgroundColor:COLOR_MA_RED];
            [btnInput setImage:[[UIImage imageNamed:@"SurveySpecialInputIconGeolocation"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }break;
            
        case SurveySpecialInputTypeQRCode:{
            [btnInput setBackgroundColor:COLOR_MA_BLUE];
            [btnInput setImage:[[UIImage imageNamed:@"SurveySpecialInputIconQRCode"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }break;
            
        case SurveySpecialInputTypeBarcode:{
            [btnInput setBackgroundColor:COLOR_MA_PURPLE];
            [btnInput setImage:[[UIImage imageNamed:@"SurveySpecialInputIconBarcode"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }break;
            
        case SurveySpecialInputTypePDF417: {
            [btnInput setBackgroundColor:COLOR_MA_ORANGE];
            [btnInput setImage:[[UIImage imageNamed:@"SurveySpecialInputIconBarcode"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }break;
            
        case SurveySpecialInputTypeBoleto: {
            [btnInput setBackgroundColor:COLOR_MA_GREEN];
            [btnInput setImage:[[UIImage imageNamed:@"SurveySpecialInputIconBarcode"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }break;
            
        case SurveySpecialInputTypeColor: {
            [btnInput setBackgroundColor:COLOR_MA_YELLOW];
            [btnInput setImage:[[UIImage imageNamed:@"SurveySpecialInputIconColor"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }break;
    }
    
    CustomSurveyAnswer *ua = [element.question.userAnswers firstObject];
    if (ua){
        
        if (inputType == SurveySpecialInputTypeNormal){
            txtResultView.text = ua.text;
        }else if (inputType == SurveySpecialInputTypeColor){
            txtResultView.attributedText = [self attributtedTextForImage:ua.auxImage andDictionary:ua.complexValue];
        }else{
            txtResultView.attributedText = [self attributtedTextForDictionary:ua.complexValue withImage:ua.auxImage];
        }

        if ([txtResultView.text isEqualToString:@""]){
            [lblPlaceholder setHidden:NO];
        }
    }
    
    [self layoutIfNeeded];

}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    return 180.0;
}

#pragma mark -

-(IBAction)actionSpecialInput:(UIButton*)sender
{
    if (inputType == SurveySpecialInputTypeNormal){
        
        [txtResultView setBackgroundColor:[UIColor whiteColor]];
        [txtResultView setEditable:YES];
        [txtResultView setSelectable:YES];
        [txtResultView becomeFirstResponder];
        
    }else{
        if (vcDelegate){
            if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
                [vcDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:nil];
            }
        }
    }
    
}

#pragma mark - Text Field Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (vcDelegate){
        if ([vcDelegate respondsToSelector:@selector(didBeginEditingTextInRect:)]){
            [vcDelegate didBeginEditingTextInRect:self.frame];
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (vcDelegate){
        if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
            [vcDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:txtResultView.text];
        }
    }
    
    [txtResultView setBackgroundColor:COLOR_MA_LIGHTYELLOW];
    [txtResultView setEditable:NO];
    [txtResultView setSelectable:NO];
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

//Versão mais simples para uso sem formatação.
//- (NSString*)textForDictionary:(NSDictionary*)dicValue
//{
//    NSMutableString *strDic = [[NSMutableString alloc] initWithString:@""];
//
//    NSArray *keys = [dicValue allKeys];
//    for (NSString *k in keys){
//        [strDic appendFormat:@"%@ : %@\n", k, [dicValue valueForKey:k]];
//    }
//
//    return strDic;
//}

- (NSAttributedString*)attributtedTextForDictionary:(NSDictionary*)dicValue withImage:(UIImage*)image
{
    UIFont *fontBold = [UIFont fontWithName:FONT_DEFAULT_BOLD size:FONT_SIZE_BUTTON_NO_BORDERS];
    UIFont *fontRegular = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS];
    //
    NSDictionary *textAttributesBold = @{NSFontAttributeName:fontBold, NSForegroundColorAttributeName:[UIColor darkTextColor]};
    NSDictionary *textAttributesRegular = @{NSFontAttributeName:fontRegular, NSForegroundColorAttributeName:[UIColor grayColor]};
    //
    NSMutableAttributedString *finalAttributedString = [NSMutableAttributedString new];
    //
    NSArray *keys = [dicValue allKeys];
    for (NSString *k in keys){
        NSAttributedString *textKey = [[NSAttributedString alloc] initWithString:NSLocalizedString(k, @"") attributes:textAttributesBold];
        NSAttributedString *textValue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" : %@\n", [dicValue valueForKey:k]] attributes:textAttributesRegular];
        //
        [finalAttributedString appendAttributedString:textKey];
        [finalAttributedString appendAttributedString:textValue];
    }
    //
    if (image){
        
        CGFloat aspect = image.size.width / image.size.height;
        CGFloat newWidth = self.txtResultView.frame.size.width - 20.0;
        CGFloat newHeight = newWidth / aspect;
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        attachment.bounds = CGRectMake(10.0, 0, newWidth, newHeight);
        
        NSAttributedString *attString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        [finalAttributedString appendAttributedString:attString];
    }
    
    //
    return finalAttributedString;
}

- (NSAttributedString*)attributtedTextForImage:(UIImage*)image andDictionary:(NSDictionary*)dicValue
{
    UIFont *fontBold = [UIFont fontWithName:FONT_DEFAULT_BOLD size:FONT_SIZE_BUTTON_NO_BORDERS];
    UIFont *fontRegular = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS];
    //
    NSDictionary *textAttributesBold = @{NSFontAttributeName:fontBold, NSForegroundColorAttributeName:[UIColor darkTextColor]};
    NSDictionary *textAttributesRegular = @{NSFontAttributeName:fontRegular, NSForegroundColorAttributeName:[UIColor grayColor]};
    //
    NSMutableAttributedString *finalAttributedString = [NSMutableAttributedString new];
    //
    if (image){
        
        CGFloat aspect = image.size.width / image.size.height;
        CGFloat newWidth = self.txtResultView.frame.size.width - 20.0;
        CGFloat newHeight = newWidth / aspect;
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        attachment.bounds = CGRectMake(10.0, 0, newWidth, newHeight);
        
        NSAttributedString *attString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        [finalAttributedString appendAttributedString:attString];
        
        [finalAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    }
    //
    NSArray *keys = [dicValue allKeys];
    for (NSString *k in keys){
        NSAttributedString *textKey = [[NSAttributedString alloc] initWithString:NSLocalizedString(k, @"") attributes:textAttributesBold];
        NSAttributedString *textValue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" : %@\n", [dicValue valueForKey:k]] attributes:textAttributesRegular];
        //
        [finalAttributedString appendAttributedString:textKey];
        [finalAttributedString appendAttributedString:textValue];
    }
    //
    return finalAttributedString;
}

@end
