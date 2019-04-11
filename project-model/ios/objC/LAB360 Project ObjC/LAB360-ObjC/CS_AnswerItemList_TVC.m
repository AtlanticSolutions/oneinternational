//
//  CS_AnswerItemList_TVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 06/02/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "CS_AnswerItemList_TVC.h"

@interface CS_AnswerItemList_TVC()<UITextFieldDelegate>

@property(nonatomic, assign) NSInteger cellRow;
@property(nonatomic, assign) NSInteger cellSection;
@property(nonatomic, assign) NSInteger maxLenght;
@property(nonatomic, assign) NSInteger maxItems;
@property(nonatomic, strong) NSString *regex;
//
@property(nonatomic, strong) NSString *placeholder;
@property(nonatomic, strong) NSMutableArray *itemsList;
//
@property(nonatomic, strong) UIImage *imageButtonEdit;

@end

@implementation CS_AnswerItemList_TVC

@synthesize vcDelegate, lblItems, btnInsert, viewItemsContainer;
@synthesize cellRow, cellSection, maxLenght, maxItems, regex, placeholder, itemsList, imageButtonEdit;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    imageButtonEdit = [[UIImage imageNamed:@"CustomSurveyIconItemListEdit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    lblItems.backgroundColor = [UIColor clearColor];
    lblItems.textColor = [UIColor lightGrayColor];
    [lblItems setFont:[UIFont fontWithName:FONT_DEFAULT_ITALIC size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblItems.text = @"";
    
    [btnInsert setBackgroundColor:[UIColor clearColor]];
    [btnInsert setTitle:@"Inserir Item" forState:UIControlStateNormal];
    [btnInsert setExclusiveTouch:YES];
    [btnInsert.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnInsert.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [btnInsert setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnInsert.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnInsert setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnInsert.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    [btnInsert setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    //
    [btnInsert setClipsToBounds:YES];
    btnInsert.layer.cornerRadius = 4.0;
    [btnInsert setEnabled:YES];
    
    viewItemsContainer.backgroundColor = [UIColor clearColor];
    [viewItemsContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [viewItemsContainer setClipsToBounds:YES];
    
    cellRow = 0;
    cellSection = 0;
    maxLenght = 0;
    maxItems = 0;
    placeholder = @"";
    regex = nil;
    itemsList = [NSMutableArray new];
}

- (void)configureLayoutFor:(UITableView*)tableView usingElement:(CustomSurveyCollectionElement*)element atIndex:(NSIndexPath*)indexPath
{
    [self setupLayout];
    
    [self layoutIfNeeded];
    
    cellSection = indexPath.section;
    cellRow = indexPath.row;
    maxLenght = element.question.maxTextLenght;
    maxItems = element.question.selectableItems;
    placeholder = element.question.hint;
    
    if ([ToolBox textHelper_CheckRelevantContentInString:element.question.regexValidator]){
        regex = [NSString stringWithFormat:@"%@", element.question.regexValidator];
    }
    
    for (CustomSurveyAnswer *answer in element.question.userAnswers){
        [itemsList addObject:answer.text];
    }
    
    if (maxItems == 0){
        lblItems.text = [NSString stringWithFormat:@"%lu item(s)", (unsigned long)itemsList.count];
    }else{
        lblItems.text = [NSString stringWithFormat:@"%lu / %lu item(s)", (unsigned long)itemsList.count, maxItems];
    }
    
    if (itemsList.count == 0){
        viewItemsContainer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }else{
        [self createViewsForItemsList];
    }
    
    if ((element.question.userAnswers.count >= maxItems) && (maxItems > 0)){
         [btnInsert setEnabled:NO];
    }
}

+ (CGFloat)referenceHeightForContainerWidth:(CGFloat)containerWidth usingParameters:(id)parametersData
{
    //Specific or UITableViewAutomaticDimension:
    
    if ([parametersData isKindOfClass:[CustomSurveyCollectionElement class]]){
        CustomSurveyCollectionElement *element = (CustomSurveyCollectionElement*)parametersData;
        if (element.question.type == SurveyQuestionTypeItemList){
            CGFloat totalHeight = 66.0 + ((float)(element.question.userAnswers.count) * 36.0);
            return totalHeight;
        }
    }
    
    return 66.0;
}

#pragma mark -

- (IBAction)actionAddItemToList:(UIButton*)sender
{
    SCLAlertViewPlus *alert = [AppD createLargeAlert];
    alert.customViewColor = COLOR_MA_BLUE;
    
    UITextField *textField = [alert addTextField:placeholder ? placeholder : @""];
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [textField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setSpellCheckingType:UITextSpellCheckingTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    textField.delegate = self;
    
    [alert addButton:@"Inserir" withType:SCLAlertButtonType_Normal actionBlock:^{
        [textField resignFirstResponder];
        if ([ToolBox textHelper_CheckRelevantContentInString:textField.text]){
            if (vcDelegate){
                
                //[vcDelegate didEndEditingItemComponentAtSection:cellSection row:cellRow collectionIndex:-1 withValue:textField.text];
                
                if (regex && maxLenght == 0){
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    if([predicate evaluateWithObject:textField.text]){
                        //Aprovado!
                        if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
                            [vcDelegate didEndEditingItemComponentAtSection:cellSection row:cellRow collectionIndex:sender.tag withValue:textField.text];
                        }
                    }else{
                        //Desaprovado!
                        textField.text = @"";
                        //
                        if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValidationErrorMessage:)]){
                            [vcDelegate didEndEditingItemComponentAtSection:cellSection row:cellRow collectionIndex:sender.tag withValidationErrorMessage:@"Formato de dados inválido. Por favor, verifique sua resposta."];
                        }
                    }
                }else{
                    if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
                        [vcDelegate didEndEditingItemComponentAtSection:cellSection row:cellRow collectionIndex:sender.tag withValue:textField.text];
                    }
                }
                
            }
        }
    }];
    
    [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
    
    [alert showEdit:@"Novo Item" subTitle:@"Digite um texto válido para o novo item" closeButtonTitle:nil duration:0.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField becomeFirstResponder];
    });
    
}

- (IBAction)actionEditItem:(UIButton*)sender
{
    SCLAlertViewPlus *alert = [AppD createLargeAlert];
    alert.customViewColor = COLOR_MA_BLUE;
    
    UITextField *textField = [alert addTextField:placeholder ? placeholder : @""];
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [textField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setSpellCheckingType:UITextSpellCheckingTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    textField.delegate = self;
    
    textField.text = [self.itemsList objectAtIndex:sender.tag];
    
    [alert addButton:@"Editar" withType:SCLAlertButtonType_Normal actionBlock:^{
        [textField resignFirstResponder];
        if ([ToolBox textHelper_CheckRelevantContentInString:textField.text]){
            if (vcDelegate){
                
                //[vcDelegate didEndEditingItemComponentAtSection:cellSection row:cellRow collectionIndex:sender.tag withValue:textField.text];
                
                if (regex && maxLenght == 0){
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    if([predicate evaluateWithObject:textField.text]){
                        //Aprovado!
                        if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
                            [vcDelegate didEndEditingItemComponentAtSection:cellSection row:cellRow collectionIndex:sender.tag withValue:textField.text];
                        }
                    }else{
                        //Desaprovado!
                        textField.text = @"";
                        //
                        if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValidationErrorMessage:)]){
                            [vcDelegate didEndEditingItemComponentAtSection:cellSection row:cellRow collectionIndex:sender.tag withValidationErrorMessage:@"Formato de dados inválido. Por favor, verifique sua resposta."];
                        }
                    }
                }else{
                    if ([vcDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
                        [vcDelegate didEndEditingItemComponentAtSection:cellSection row:cellRow collectionIndex:sender.tag withValue:textField.text];
                    }
                }
                
            }
        }
    }];
    
    [alert addButton:@"Remover" withType:SCLAlertButtonType_Destructive actionBlock:^{
        if (vcDelegate){
            [vcDelegate didEndEditingItemComponentAtSection:cellSection row:cellRow collectionIndex:sender.tag withValue:nil];
        }
    }];
    
    [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
    
    [alert showEdit:@"Editar Item" subTitle:@"Edite ou remova o item selecionado" closeButtonTitle:nil duration:0.0];
}

#pragma mark -

- (void)createViewsForItemsList
{
    for (int i=0; i<self.itemsList.count; i++){
        
        NSInteger reverseIndex = (self.itemsList.count - 1 - i);
        
        NSString *item = [self.itemsList objectAtIndex:reverseIndex];
        
        CGFloat yPosition = 36.0 * (float)(i);
        
        //Order Label
        UILabel *oLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, yPosition, 32.0, 32.0)];
        oLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        oLabel.textColor = [UIColor grayColor];
        oLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_LABEL_NOTE];
        oLabel.textAlignment = NSTextAlignmentCenter;
        [oLabel setMinimumScaleFactor:0.1];
        [oLabel setAdjustsFontSizeToFitWidth:YES];
        oLabel.text = [NSString stringWithFormat:@"%li", (reverseIndex + 1)];
        
        //Item Text Label
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 + 32.0 + 5.0, yPosition, viewItemsContainer.frame.size.width - (2 * (32.0 + 5.0)), 32.0)];
        tLabel.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:254.0/255.0 blue:192.0/255.0 alpha:1.0];
        tLabel.textColor = [UIColor grayColor];
        tLabel.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS];
        tLabel.textAlignment = NSTextAlignmentLeft;
        [tLabel setMinimumScaleFactor:0.5];
        [tLabel setAdjustsFontSizeToFitWidth:YES];
        tLabel.text = [NSString stringWithFormat:@"  %@", item];
        
        //Edit Button
        UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnEdit setFrame:CGRectMake(tLabel.frame.origin.x + tLabel.frame.size.width + 5.0, yPosition, 32.0, 32.0)];
        [btnEdit setBackgroundColor: [UIColor groupTableViewBackgroundColor]];
        [btnEdit setExclusiveTouch:YES];
        [btnEdit.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [btnEdit setImage:imageButtonEdit forState:UIControlStateNormal];
        btnEdit.tag = reverseIndex;
        [btnEdit setTintColor: [UIColor grayColor]];
        [btnEdit addTarget:self action:@selector(actionEditItem:) forControlEvents:UIControlEventTouchUpInside];
        btnEdit.layer.cornerRadius = 3.0;
        
        //
        
        [viewItemsContainer addSubview:oLabel];
        [viewItemsContainer addSubview:tLabel];
        [viewItemsContainer addSubview:btnEdit];
    }
}

#pragma mark - Text Field Delegate

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (cellEditorDelegate){
//        if ([cellEditorDelegate respondsToSelector:@selector(didBeginEditingTextInRect:)]){
//            [cellEditorDelegate didBeginEditingTextInRect:self.frame];
//        }
//    }
//}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (cellEditorDelegate){
//        if ([cellEditorDelegate respondsToSelector:@selector(didEndEditingComponentAtSection:row:withValue:)]){
//            [cellEditorDelegate didEndEditingComponentAtSection:cellSection row:cellRow withValue:txtResult.text];
//        }
//    }
//}

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

//-(UIView*)createAcessoryViewForTextField:(UITextField*)textField
//{
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
//    view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
//
//    UIButton *btnClear = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth/2, 40)];
//    btnClear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [btnClear addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
//    [btnClear setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
//    [btnClear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnClear.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]];
//    [btnClear setTitle:@"Limpar" forState:UIControlStateNormal];
//    [view addSubview:btnClear];
//    //
//    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2, 0, screenWidth/2, 40)];
//    btnDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [btnDone addTarget:textField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
//    [btnDone setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
//    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnDone.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]];
//    [btnDone setTitle:@"Confirmar" forState:UIControlStateNormal];
//    [view addSubview:btnDone];
//
//    return view;
//}
//
//- (void)clearTextField:(id)sender
//{
//    self.txtResult.text = @"";
//}

@end
