//
//  VehicleDetailVC.m
//  Siga
//
//  Created by Erico GT on 29/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT

#import <Photos/Photos.h>
//
#import "GenericFormViewerVC.h"
#import "GenericFormItemTVC.h"
#import "FloatingPickerView.h"
#import "AppDelegate.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface GenericFormViewerVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FloatingPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//Data:
@property (nonatomic, strong) NSMutableDictionary *optionsDic;
@property (nonatomic, strong) FormParameterReference *currentParameterReference;

//Layout:
@property (nonatomic, strong) FloatingPickerView *pickerView;
//
@property (nonatomic, weak) IBOutlet UITableView *tvProperties;
@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, strong) UITextField *activeTextField;

@end

#pragma mark - • IMPLEMENTATION
@implementation GenericFormViewerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize auxTag, optionsDic, delegate, screenName, parametersConfiguration, objectData, instructionHeaderText, currentParameterReference;
@synthesize tvProperties, btnConfirm, pickerView, activeTextField;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    optionsDic = [NSMutableDictionary new];
    
    tvProperties.delegate = self;
    tvProperties.dataSource = self;
    
    [tvProperties registerNib:[UINib nibWithNibName:@"GenericFormItemTVC" bundle:nil] forCellReuseIdentifier:@"GenericFormItemCell"];
    
    pickerView = [FloatingPickerView newFloatingPickerView];
    pickerView.contentStyle = FloatingPickerViewContentStyleAuto;
    pickerView.backgroundTouchForceCancel = YES;
    pickerView.tag = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    [self setupLayout:screenName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self validateData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

- (void)forceNavigationReturn
{
    [self.view endEditing:YES];
    
    [self pop:1];
}

- (BOOL)updateParameterObjectData:(id)parameterValue forKey:(NSString*)keyName
{
    @try {
        if ([[objectData allKeys] containsObject:keyName]){
            [objectData setValue:parameterValue forKey:keyName];
            [tvProperties reloadData];
            return YES;
        }else{
            return NO;
        }
    } @catch (NSException *exception) {
        return NO;
    }
}

#pragma mark - • ACTION METHODS

- (IBAction)actionCancelScreen:(id)sender
{
    if (delegate){
        if ([delegate genericFormViewer:self canCancelScreenWithData:objectData]){
            [self pop:1];
        }
    }else{
        [self pop:1];
    }
}

- (IBAction)actionSaveData:(id)sender
{
    if (delegate){
        if ([delegate genericFormViewer:self canConfirmScreenWithData:objectData]){
            [self pop:1];
        }
    }else{
        [self pop:1];
    }
}

- (IBAction)actionPreviusFirstResponder:(UIButton*)sender
{
    if (sender.tag > 0){
        GenericFormItemTVC *cell = (GenericFormItemTVC*)[tvProperties cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(sender.tag - 1) inSection:0]];
        if (cell){
            [tvProperties scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(sender.tag - 1) inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [cell.txtParameterValue becomeFirstResponder];
        }
    }
}

- (IBAction)actionNextFirstResponder:(UIButton*)sender
{
    if (sender.tag < (parametersConfiguration.count - 1)){
        GenericFormItemTVC *cell = (GenericFormItemTVC*)[tvProperties cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(sender.tag + 1) inSection:0]];
        if (cell){
            [tvProperties scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(sender.tag + 1) inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [cell.txtParameterValue becomeFirstResponder];
        }
    }
}

- (IBAction)actionDatePickerValueChanged:(UIDatePicker*)sender
{
    FormParameterReference *parameter = [parametersConfiguration objectAtIndex:sender.tag];
    dispatch_async(dispatch_get_main_queue(), ^{
        activeTextField.text = [ToolBox dateHelper_StringFromDate:sender.date withFormat:parameter.textFormat];
    });
}

- (void)actionKeyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    [tvProperties setContentInset:contentInsets];
    [tvProperties setScrollIndicatorInsets:contentInsets];
}

- (void)actionKeyboardWillHide:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [tvProperties setContentInset:contentInsets];
    [tvProperties setScrollIndicatorInsets:contentInsets];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - FloatingPickerElement

- (NSArray<FloatingPickerElement*>* _Nonnull)floatingPickerViewElementsList:(FloatingPickerView *)pickerView
{
    NSMutableArray *elements = [optionsDic objectForKey:currentParameterReference.keyName];
    //Resetando possíveis mudanças feitas pelo usuário (e não confirmadas)
    for (FloatingPickerElement *el in elements){
        int currentEnum = [[objectData valueForKey:currentParameterReference.keyName] intValue];
        if (el.associatedEnum == currentEnum){
            el.selected = YES;
        }else{
            el.selected = NO;
        }
    }
    //
    return elements;
}

//Appearence:
- (NSString* _Nonnull)floatingPickerViewTextForCancelButton:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Cancelar";
}

- (NSString* _Nonnull)floatingPickerViewTextForConfirmButton:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Confirmar";
}

- (NSString* _Nonnull)floatingPickerViewTitle:(FloatingPickerView* _Nonnull)pickerView
{
    if (delegate){
        return [delegate genericFormViewer:self titleForOptionsWithParameterKeyIdentifier:currentParameterReference.keyName];
    }
    
    return @"Opções";
}

- (NSString* _Nonnull)floatingPickerViewSubtitle:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Selecione uma opção:";
}

//Control:
- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willCancelPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    return YES;
}

- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willConfirmPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    if (elements.count == 0){
        return NO;
    }else{
        FloatingPickerElement *element = [elements firstObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [objectData setValue:@(element.associatedEnum) forKey:currentParameterReference.keyName];
            [tvProperties reloadData];
        });
        return YES;
    }
}

- (void)floatingPickerViewDidShow:(FloatingPickerView* _Nonnull)pickerView
{
    NSLog(@"floatingPickerViewDidShow");
}

- (void)floatingPickerViewDidHide:(FloatingPickerView* _Nonnull)pickerView
{
    NSLog(@"floatingPickerViewDidHide");
}

//Aparência
- (UIColor* _Nonnull)floatingPickerViewBackgroundColorCancelButton:(FloatingPickerView* _Nonnull)pickerView
{
    return COLOR_MA_RED;
}

- (UIColor* _Nonnull)floatingPickerViewTextColorCancelButton:(FloatingPickerView* _Nonnull)pickerView
{
    return [UIColor whiteColor];
}

- (UIColor* _Nonnull)floatingPickerViewBackgroundColorConfirmButton:(FloatingPickerView* _Nonnull)pickerView
{
    return COLOR_MA_GREEN;
}

- (UIColor* _Nonnull)floatingPickerViewTextColorConfirmButton:(FloatingPickerView* _Nonnull)pickerView
{
    return [UIColor whiteColor];
}

- (UIColor* _Nonnull)floatingPickerViewSelectedBackgroundColor:(FloatingPickerView* _Nonnull)pickerView
{
    return [UIColor groupTableViewBackgroundColor];
}

#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    FormParameterReference *parameter = [parametersConfiguration objectAtIndex:textField.tag];
    
    if (parameter.valueType == ParameterReferenceValueTypeOption){
        [self.view endEditing:YES];
        currentParameterReference = parameter;
        [pickerView showFloatingPickerViewWithDelegate:self];
        //
        return NO;
    }else if (parameter.valueType == ParameterReferenceValueTypeDate){
        if ([textField.inputView isKindOfClass:[UIDatePicker class]]){
            UIDatePicker *dPicker = (UIDatePicker*)textField.inputView;
            id date = [objectData valueForKey:parameter.keyName];
            //
            if ([date isKindOfClass:[NSDate class]]){
                dPicker.date = (NSDate*)date;
            }else{
                dPicker.date = [NSDate date];
                textField.text = [ToolBox dateHelper_StringFromDate:dPicker.date withFormat:parameter.textFormat];
            }
        }
    }
    
    [textField setTextColor:[UIColor darkTextColor]];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    FormParameterReference *parameter = [parametersConfiguration objectAtIndex:textField.tag];
    if (parameter.required){
        if (![ToolBox textHelper_CheckRelevantContentInString:textField.text]){
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    FormParameterReference *parameter = [parametersConfiguration objectAtIndex:textField.tag];
    
    id data = nil;
    
    //Destaque para campos incorretos:
    if ([ToolBox textHelper_CheckRelevantContentInString:textField.text] && [ToolBox textHelper_CheckRelevantContentInString:parameter.highlightingRegex]){
        NSString *regex = parameter.highlightingRegex;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if (![predicate evaluateWithObject: textField.text]){
            [textField setTextColor:COLOR_MA_RED];
        }
    }
    
    switch (parameter.valueType) {
        case ParameterReferenceValueTypeGeneric:{
            
            data = textField.text;
            
        }break;
            
        case ParameterReferenceValueTypeNumber:{
            
            if (parameter.autoClearMask){
                data = @([textField.text doubleValue]);
            }else{
                NSString *clearText = [self clearMask:textField.text];
                data = @([clearText doubleValue]);
            }
            
        }break;
            
        case ParameterReferenceValueTypeText:{
            
            if ([ToolBox textHelper_CheckRelevantContentInString:parameter.textFormat]){
                data = [NSString stringWithFormat:parameter.textFormat, data];
            }else{
                data = textField.text;
            }
            
        }break;
            
        case ParameterReferenceValueTypeOption:{
            
            NSArray<FloatingPickerElement*>* options = [optionsDic objectForKey:parameter.keyName];
            for (FloatingPickerElement *el in options){
                if ([textField.text isEqualToString:el.title]){
                    data = @(el.associatedEnum);
                    break;
                }
            }
            
        }break;
            
        case ParameterReferenceValueTypeDate:{
            
            //A edição da data ocorre na atualização do DatePicker.
            if ([ToolBox textHelper_CheckRelevantContentInString:textField.text]){
                data = [ToolBox dateHelper_DateFromString:textField.text withFormat:parameter.textFormat];
            }
            
        }break;
            
        case ParameterReferenceValueTypeImage:{
            //Não precisa fazer nada pois parâmetros imagem não possuem edição de texto
            return;
        }
    }
    
    if (data){
        [objectData setValue:data forKey:parameter.keyName];
    }else{
        [objectData setValue:[NSNull null] forKey:parameter.keyName];
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
    
    //Conforme parâmetros:
    FormParameterReference *parameter = [parametersConfiguration objectAtIndex:textField.tag];
    
    //Max size
    if (parameter.maxSize > 0){
        long n = textField.text.length + (string.length - range.length);
        if (n > parameter.maxSize){
            return NO;
        }
    }
    
    //Máscara
    if ([ToolBox textHelper_CheckRelevantContentInString:parameter.textMask]){
        
        NSString *mask = parameter.textMask;
        
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //NSString *replacedString = [self clearMask:[textField.text stringByReplacingCharactersInRange:range withString:string]];
        
        bool ignore = false;
        
        if(range.length == 1 && /* Only do for single deletes */ string.length < range.length && [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound){
            
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length - 1;
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
        
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 80.0;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([ToolBox textHelper_CheckRelevantContentInString:instructionHeaderText]){
        return 50.0;
    }else{
        return 0.0;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return parametersConfiguration.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"GenericFormItemCell";
    GenericFormItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    if(cell == nil){
        cell = [[GenericFormItemTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    cell.txtParameterValue.tag = indexPath.row;
    
    FormParameterReference *parameter = [parametersConfiguration objectAtIndex:indexPath.row];
    
    UIView *av = parameter.readyOnly ? nil : [self createAcessoryViewForTarget:cell.txtParameterValue];
    
    if (parameter.valueType == ParameterReferenceValueTypeDate){
        UIDatePicker *datePicker = [UIDatePicker new];
        [datePicker setDate:[NSDate date]];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker addTarget:self action:@selector(actionDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        datePicker.tag = indexPath.row;
        //
        if (parameter.minDate != nil){
            [datePicker setMinimumDate:parameter.minDate];
        }
        if (parameter.maxDate != nil){
            [datePicker setMaximumDate:parameter.maxDate];
        }
        //
        [cell.txtParameterValue setInputView:datePicker];
    }else{
        [cell.txtParameterValue setInputView:nil];
    }
    
    [cell setupLayoutWithInputAccessoryView:av usingIcon:parameter.parameterIcon];
    [cell.txtParameterValue setKeyboardType:parameter.keyboardType];
    [cell.txtParameterValue setAutocapitalizationType:parameter.capitalizationType];
    
    cell.lblParameterName.text = parameter.parameterName;
    
    [cell.txtParameterValue setPlaceholder:parameter.placeholder];
    
    cell.txtParameterValue.tag = indexPath.row;
    cell.txtParameterValue.delegate = self;
    
    if (parameter.readyOnly){
        cell.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
        [cell.txtParameterValue setEnabled:NO];
    }
    
    //Tratativas de valor:
    NSString *textToShow = @"";
    
    switch (parameter.valueType) {
        case ParameterReferenceValueTypeGeneric:{
            
            textToShow = [NSString stringWithFormat:@"%@", [objectData valueForKey:parameter.keyName]];
            
        }break;
            
        case ParameterReferenceValueTypeNumber:{
            
            id oData = [objectData valueForKey:parameter.keyName];
            if ([oData isKindOfClass:[NSNumber class]]){
                textToShow = [NSString stringWithFormat:parameter.textFormat, [oData doubleValue]];
            }else{
                textToShow = [NSString stringWithFormat:@"%@", oData];
            }
            
        }break;
            
        case ParameterReferenceValueTypeText:{
            
            textToShow = [NSString stringWithFormat:@"%@", [objectData valueForKey:parameter.keyName]];
            
        }break;
            
        case ParameterReferenceValueTypeOption:{
            
            NSArray<FloatingPickerElement*>* options = [optionsDic objectForKey:parameter.keyName];
            for (FloatingPickerElement *el in options){
                if (el.selected){
                    textToShow = el.title;
                    break;
                }
            }
            
        }break;
            
        case ParameterReferenceValueTypeDate:{
            
            id oData = [objectData valueForKey:parameter.keyName];
            if ([oData isKindOfClass:[NSDate class]]){
                textToShow = [ToolBox dateHelper_StringFromDate:(NSDate*)oData withFormat:parameter.textFormat];
            }else{
                textToShow = [NSString stringWithFormat:@"%@", oData];
            }
            
        }break;
            
        case ParameterReferenceValueTypeImage:{
            
            [cell.txtParameterValue setHidden:YES];
            
            id oData = [objectData valueForKey:parameter.keyName];
            if ([oData isKindOfClass:[UIImage class]]){
                cell.imvPicture.image = (UIImage*)oData;
            }
            
            [cell.imvPicture setHidden:NO];
            
        }break;
            
    }
    
    if ([ToolBox textHelper_CheckRelevantContentInString:parameter.highlightingRegex]){
        NSString *regex = parameter.highlightingRegex;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if (![predicate evaluateWithObject: [objectData valueForKey:parameter.keyName]]){
            [cell.txtParameterValue setTextColor:COLOR_MA_RED];
        }
    }
    
    cell.txtParameterValue.text = textToShow;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormParameterReference *parameter = [parametersConfiguration objectAtIndex:indexPath.row];
    
    if (parameter.valueType == ParameterReferenceValueTypeImage){
        
        currentParameterReference = parameter;
        
        id oData = [objectData valueForKey:parameter.keyName];
        if ([oData isKindOfClass:[UIImage class]]){
            
            SCLAlertViewPlus *alert = [AppD createDefaultRichAlert:@"" images:@[(UIImage*)oData] animationTimePerFrame:0.0];
            [alert addButton:NSLocalizedString(@"ALERT_OPTION_PICK_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
                [self resolvePhotoLibraryPermitions];
            }];
            [alert addButton:NSLocalizedString(@"ALERT_OPTION_TAKE_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
                [self resolveCameraPermitions];
            }];
            [alert addButton:NSLocalizedString(@"ALERT_OPTION_DELETE", @"") withType:SCLAlertButtonType_Destructive actionBlock:^{
                [objectData setValue:[NSNull null] forKey:parameter.keyName];
                [tvProperties reloadData];
            }];
            [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
            [alert showInfo:@"Foto Veículo" subTitle:@"É possível substituir ou excluir a imagem utilizada atualmente." closeButtonTitle:nil duration:0.0];
            
        }else{
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert addButton:NSLocalizedString(@"ALERT_OPTION_PICK_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
                [self resolvePhotoLibraryPermitions];
            }];
            [alert addButton:NSLocalizedString(@"ALERT_OPTION_TAKE_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
                [self resolveCameraPermitions];
            }];
            [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
            [alert showInfo:@"Foto Veículo" subTitle:NSLocalizedString(@"ALERT_MESSAGE_PICK_PHOTO", @"") closeButtonTitle:nil duration:0.0] ;
        }
        
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([ToolBox textHelper_CheckRelevantContentInString:instructionHeaderText]){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 50.0)];
        [view setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonSelected];
        //
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 4.0, self.view.frame.size.width - 20.0, 42.0)];
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setMinimumScaleFactor:0.5];
        [label setNumberOfLines:2];
        label.text = instructionHeaderText;
        //
        [view addSubview:label];
        //
        return view;
        
    }else{
        return nil;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage* chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage* editedPhoto = [ToolBox graphicHelper_NormalizeImage:chosenImage maximumDimension:IMAGE_MAXIMUM_SIZE_SIDE quality:1.0];
    
    [objectData setValue:editedPhoto forKey:currentParameterReference.keyName];
    
    [tvProperties reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    tvProperties.backgroundColor = [UIColor whiteColor];
    tvProperties.alpha = 0.0;
    
    btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnConfirm setFrame:CGRectMake(20.0, 20.0, self.view.frame.size.width - 40.0, 40.0)];
    btnConfirm.backgroundColor = [UIColor clearColor];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnConfirm.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnConfirm setTitle:@"SALVAR" forState:UIControlStateNormal];
    [btnConfirm setExclusiveTouch:YES];
    [btnConfirm setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnConfirm.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.secondaryButtonNormal] forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnConfirm.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.secondaryButtonSelected] forState:UIControlStateHighlighted];
    [btnConfirm addTarget:self action:@selector(actionSaveData:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 80.0)];
    [view setBackgroundColor:[UIColor clearColor]];
    [view addSubview:btnConfirm];
    //
    UIView *divisorLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 0.5)];
    [divisorLine setBackgroundColor:tvProperties.separatorColor];
    [view addSubview:divisorLine];
    //
    [tvProperties setTableFooterView:view];
}

- (void)validateData
{
    BOOL ok = YES;
    NSString *error = @"";
    
    if (delegate == nil){
        ok = NO;
        error = @"Para um correto funcionamento este componente precisa de um delegate efetivo.";
    }
    
    //Data:
    if (ok == NO){
        if (objectData == nil){
            ok = NO;
            error = @"É preciso que o dicionário do objeto referência possua dados válidos.";
        }else{
            if ([objectData allKeys].count == 0){
                ok = NO;
                error = @"É preciso que o dicionário do objeto referência possua dados válidos.";
            }
        }
    }
    
    //Parametros
    if (ok == NO){
        if (parametersConfiguration == nil){
            ok = NO;
            error = @"É preciso que hajam parâmetros válidos de configuração.";
        }else{
            if (parametersConfiguration.count == 0){
                ok = NO;
                error = @"É preciso que hajam parâmetros válidos de configuração.";
            }
        }
    }
    
    //Resultado:
    if (ok == NO){
        if (delegate){
            [delegate genericFormViewer:self errorReportWithMessage:error];
        }else{
            [self pop:1];
        }
    }else{
        
        //Os parâmetros são válidos para se usar a tela:
        
        //Verificando campos com opções:
        for (FormParameterReference *param in parametersConfiguration){
            if (param.valueType == ParameterReferenceValueTypeOption){
                [optionsDic setObject:[delegate genericFormViewer:self optionsForKey:param.keyName currentValue:[[objectData objectForKey:param.keyName] longValue]] forKey:param.keyName];
            }
        }
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(actionCancelScreen:)]; // [[UIBarButtonItem alloc] initWithTitle:@"Descartar" style:UIBarButtonItemStylePlain target:self action:@selector(actionCancelScreen:)];
        //
        [tvProperties reloadData];
        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
            [tvProperties setAlpha:1.0];
        }];
    }
    
}

- (void)resolveCameraPermitions
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //
        [self presentViewController:picker animated:YES completion:NULL];
        
    } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        
        //Explica o motivo da requisição
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        //
        [alert showInfo:NSLocalizedString(@"ALERT_TITLE_CAMERA_PERMISSION", "") subTitle:@"Autorize o uso da câmera para poder tirar fotos com seu dispositivo." closeButtonTitle:nil duration:0.0];
        
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        
        // Solicita permissão
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhotoFromCamera:YES];
                });
                
            } else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
    }
}

- (void)resolvePhotoLibraryPermitions
{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if(authStatus == PHAuthorizationStatusAuthorized) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    } else if(authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted){
        
        //Explica o motivo da requisição
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        //
        [alert showInfo:NSLocalizedString(@"ALERT_TITLE_PHOTO_LIBRARY_PERMISSION", "") subTitle:@"Autorize o acesso a suas fotos para poder utilizar uma delas para seu veículo." closeButtonTitle:nil duration:0.0];
        
    } else if(authStatus == PHAuthorizationStatusNotDetermined){
        
        // Solicita permissão
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status == PHAuthorizationStatusAuthorized){
                
                NSLog(@"Granted access to %@", AVMediaTypeVideo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhotoFromCamera:NO];
                });
                
            } else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
    }
}

- (void)takePhotoFromCamera:(BOOL)openCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    //
    if (openCamera){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - UTILS (General Use)

-(UIView*)createAcessoryViewForTarget:(UITextField*)targetField
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    UIButton *btnPrevius = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 0, 40.0, 40.0)];
    [btnPrevius setBackgroundColor:[UIColor clearColor]];
    [btnPrevius setImage:[[UIImage imageNamed:@"LeftPaddingArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnPrevius.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnPrevius setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 0)];
    [btnPrevius setTintColor:AppD.styleManager.colorPalette.textNormal];
    [btnPrevius addTarget:self action:@selector(actionPreviusFirstResponder:) forControlEvents:UIControlEventTouchUpInside];
    [btnPrevius setTag:targetField.tag];
    
    if (targetField.tag == 0){
        [btnPrevius setEnabled:NO];
    }
    
    UIButton *btnNext = [[UIButton alloc] initWithFrame:CGRectMake(10.0 + 40.0 + 10.0, 0, 40.0, 40.0)];
    [btnNext setBackgroundColor:[UIColor clearColor]];
    [btnNext setImage:[[UIImage imageNamed:@"RightPaddingArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btnNext.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnNext setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 0)];
    [btnNext setTintColor:AppD.styleManager.colorPalette.textNormal];
    [btnNext addTarget:self action:@selector(actionNextFirstResponder:) forControlEvents:UIControlEventTouchUpInside];
    [btnNext setTag:targetField.tag];
    
    if (targetField.tag == (parametersConfiguration.count - 1)){
        [btnNext setEnabled:NO];
    }
    
    //NOTA: Não está sendo tratado aqui o último item válido mas sim o último geral.
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 40)];
    btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnCancel addTarget:targetField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [btnCancel setTitle:@"Fechar" forState:UIControlStateNormal];
    [btnCancel setTag:targetField.tag];
    
    [view addSubview:btnPrevius];
    [view addSubview:btnNext];
    [view addSubview:btnCancel];
    
    return view;
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

- (NSString*)clearMask:(NSString*)text
{
    NSString *result = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"," withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"(" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@")" withString:@""];
    //
    return result;
}

@end

