//
//  CustomSurveyGeralFormVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 09/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "CustomSurveyGeralFormVC.h"
#import "AppDelegate.h"
#import "FloatingPickerView.h"
#import "CustomPickerView.h"
#import "BarcodeReaderViewController.h"
#import "LocationPickerViewController.h"
#import "ColorPickerViewController.h"
#import "QuestionnaireDataSource.h"
//
#import "CS_GroupTitle_TVC.h"
#import "CS_GroupHeader_TVC.h"
#import "CS_GroupImage_TVC.h"
#import "CS_GroupFooter_TVC.h"
//
#import "CS_QuestionText_TVC.h"
#import "CS_QuestionImage_TVC.h"
#import "CS_QuestionWebContent_TVC.h"
//
#import "CS_AnswerSingleSelection_TVC.h"
#import "CS_AnswerMultiSelection_TVC.h"
#import "CS_AnswerSingleLineText_TVC.h"
#import "CS_AnswerMultiLineText_TVC.h"
#import "CS_AnswerMaskedText_TVC.h"
#import "CS_AnswerImage_TVC.h"
#import "CS_AnswerOptions_TVC.h"
#import "CS_AnswerStarRating_TVC.h"
#import "CS_AnswerBarRating_TVC.h"
#import "CS_AnswerLikeRating_TVC.h"
#import "CS_AnswerUnitRating_TVC.h"
#import "CS_AnswerDecimal_TVC.h"
#import "CS_AnswerCollectionView_TVC.h"
#import "CS_AnswerOrderlyOptions_TVC.h"
#import "CS_AnswerItemList_TVC.h"
#import "CS_AnswerSpecialInput_TVC.h"
#import "CS_AnswerOptionRating_TVC.h"
//
#import "LocationService.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface CustomSurveyGeralFormVC()<UITableViewDelegate, UITableViewDataSource, FloatingPickerViewDelegate, EditableComponentTableViewCellProtocol, SelectableComponentTableViewCellProtocol, OptionsComponentTableViewCellProtocol, CustomPickerViewDelegate, EditableItemComponentTableViewCellProtocol>

//Data:
@property(nonatomic, strong) NSMutableArray *elements;
@property(nonatomic, strong) NSMutableDictionary *offscreenCells;
@property(nonatomic, strong) NSTimer *refreshDataTimer;
@property(nonatomic, strong) NSMutableArray *pickerElementOptionList;
@property(nonatomic, weak) CustomSurveyCollectionElement *currentElement;
//
@property(nonatomic, assign) BOOL dataLoaded;

//Layout:
@property(nonatomic, weak) IBOutlet UITableView *tvSurvey;
//
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *footerConstraint;
//
@property(nonatomic, weak) IBOutlet UIView *footerView;
@property(nonatomic, weak) IBOutlet UILabel *lblFooterTitle;
@property(nonatomic, weak) IBOutlet UILabel *lblFooterTime;
//
@property(nonatomic, strong) FloatingPickerView *pickerView;
//
@property(nonatomic, strong) CustomPickerView *scrollPickerView;

@end

#pragma mark - • IMPLEMENTATION
@implementation CustomSurveyGeralFormVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize survey, groupIndex, refreshDataTimer, elements, currentElement, offscreenCells, dataLoaded, pickerElementOptionList;
@synthesize tvSurvey, footerConstraint;
@synthesize footerView, lblFooterTitle, lblFooterTime;
@synthesize pickerView, scrollPickerView;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    offscreenCells = [NSMutableDictionary new];
    dataLoaded = NO;
    
    pickerView = [FloatingPickerView newFloatingPickerView];
    pickerView.contentStyle = FloatingPickerViewContentStyleAuto;
    pickerView.backgroundTouchForceCancel = YES;
    pickerView.tag = 0;
    
    [self registerCells];
    
    [LocationService initAndStartMonitoringLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //add observers:
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    //remove observers:
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BARCODE_READER_RESULT_NOTIFICATION_KEY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOCATION_PICKER_RESULT_NOTIFICATION_KEY object:nil];
    
    if (!dataLoaded){
        
        [self setupLayout:@" "];
        
        pickerElementOptionList = [NSMutableArray new];
        currentElement = nil;
        [self rearrangeSurveyDataForIndexPath:nil];
        dataLoaded = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![survey isRunning]){
        [survey startSurvey];
    }
    
    if (survey.secondsToFinish > 0 && refreshDataTimer == nil){
        [self startSurveyTimer];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToCustomSurveyForm"]){
        CustomSurveyGeralFormVC *destViewController = (CustomSurveyGeralFormVC*)segue.destinationViewController;
        destViewController.survey = survey;
        destViewController.groupIndex = self.groupIndex + 1;
        destViewController.showAppMenu = NO;
        return;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToCodeReader"]){
        
        BarcodeReaderViewController *vc = segue.destinationViewController;
        vc.titleScreen = @"Leitor de Códigos";
        vc.resultType = BarcodeReaderResultTypeAlertNotifyAndClose;
        //vc.validationKey =
        //vc.validationValue =
        
        if (currentElement.question.specialInputType == SurveySpecialInputTypeQRCode){
            
            vc.rectScanType = ScannableAreaFormatTypeLargeSquare;
            vc.typesToRead = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeDataMatrixCode];
            vc.instructionText = @"QRCode | Aztec | DataMatrix";
            
        }else if (currentElement.question.specialInputType == SurveySpecialInputTypeBarcode){
            
            vc.rectScanType = ScannableAreaFormatTypeHorizontalStripe;
            vc.typesToRead = @[AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode128Code];
            vc.instructionText = @"EAN8 | EAN13 | UPCE | Code128";
            
        }else if (currentElement.question.specialInputType == SurveySpecialInputTypePDF417){
            
            vc.rectScanType = ScannableAreaFormatTypeHorizontalStripe;
            vc.typesToRead = @[AVMetadataObjectTypePDF417Code];
            vc.instructionText = @"PDF417";
            
        }else if (currentElement.question.specialInputType == SurveySpecialInputTypeBoleto){
            
            vc.rectScanType = ScannableAreaFormatTypeVerticalStripe;
            vc.typesToRead = @[AVMetadataObjectTypeInterleaved2of5Code];
            vc.subtypesToRead = @[AVMetadataObjectSubtypeBoleto, AVMetadataObjectSubtypeConvenio];
            vc.instructionText = @"Boleto | Convênio";
            
        }else{
            
            vc.rectScanType = ScannableAreaFormatTypeDefinedByUser;
            vc.typesToRead = @[];
            vc.instructionText = @"Genérico";
            
        }
        
    }
    
    if ([segue.identifier isEqualToString:@"SegueToLocationPicker"]){
        
        LocationPickerViewController *vc = segue.destinationViewController;
        vc.titleScreen = @"Mapa";
        vc.showUserLocation = YES;
        vc.snapShotMapView = YES;
        
        if (currentElement.question.userAnswers.count > 0){
            CustomSurveyAnswer *answer = [currentElement.question.userAnswers firstObject];
            if (answer.complexValue){
                if ([[answer.complexValue allKeys] containsObject:NSLocalizedString(@"SPECIAL_INPUT_KEY_LOCATION_LATITUDE", @"")] && [[answer.complexValue allKeys] containsObject:NSLocalizedString(@"SPECIAL_INPUT_KEY_LOCATION_LONGITUDE", @"")]){
                    double latitude = [[answer.complexValue valueForKey:NSLocalizedString(@"SPECIAL_INPUT_KEY_LOCATION_LATITUDE", @"")] doubleValue];
                    double longitude = [[answer.complexValue valueForKey:NSLocalizedString(@"SPECIAL_INPUT_KEY_LOCATION_LONGITUDE", @"")] doubleValue];
                    //
                    vc.startLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                }
            }
        }
        
    }
    
    if ([segue.identifier isEqualToString:@"SegueToColorPicker"]){
        
        ColorPickerViewController *vc = segue.destinationViewController;
        vc.titleScreen = @"Paleta";
        vc.selectedColor = [UIColor whiteColor];
        
        if (currentElement.question.userAnswers.count > 0){
            CustomSurveyAnswer *answer = [currentElement.question.userAnswers firstObject];
            if (answer.complexValue){
                if ([[answer.complexValue allKeys] containsObject:@"SPECIAL_INPUT_KEY_COLORPICKER_HEX"]){
                    
                    NSString *hexColor = [answer.complexValue valueForKey:@"SPECIAL_INPUT_KEY_COLORPICKER_HEX"];
                    UIColor *color = nil;
                    
                    @try {
                        color = [ToolBox graphicHelper_colorWithHexString:hexColor];
                        vc.selectedColor = color;
                    } @catch (NSException *exception) {
                        NSLog(@"SegueToColorPicker >> Color Error >> %@", [exception reason]);
                    }

                }
            }
        }
        
    }
}
    
#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionBarcodeReaderResult:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BARCODE_READER_RESULT_NOTIFICATION_KEY object:nil];
    
    NSString *scannedText = [NSString stringWithFormat:@"%@", (NSString*)notification.object];
    
    if (currentElement.type == SurveyCollectionElementTypeAnswerItem){
        
        if (currentElement.question.specialInputType == SurveySpecialInputTypeQRCode || currentElement.question.specialInputType == SurveySpecialInputTypeBarcode || currentElement.question.specialInputType == SurveySpecialInputTypePDF417 || currentElement.question.specialInputType == SurveySpecialInputTypeBoleto) {
            
            CustomSurveyAnswer *copyAnswer = [currentElement.answer copyObject];
            copyAnswer.text = scannedText;
            
            NSString *type = [notification.userInfo valueForKey:@"type"];
            copyAnswer.complexValue = [NSDictionary dictionaryWithObjectsAndKeys:type, NSLocalizedString(@"SPECIAL_INPUT_KEY_CODEREADER_TYPE", @""), scannedText, NSLocalizedString(@"SPECIAL_INPUT_KEY_CODEREADER_CONTENT", @""), nil];
            
            if (notification.userInfo){
                copyAnswer.auxImage = [notification.userInfo objectForKey:@"snapshot"];
            }
            
            //removendo a resposta da lista:
            [currentElement.question.userAnswers removeAllObjects];
            
            //adicionando a resposta, caso tenha um texto válido:
            if (scannedText != nil && ![scannedText isEqualToString:@""]){
                [currentElement.question.userAnswers addObject:copyAnswer];
            }
            
            [self rearrangeSurveyDataForIndexPath:currentElement.referenceIndexPath];
            
        }
        
    }
    
}

- (IBAction)actionLocationPickerResult:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOCATION_PICKER_RESULT_NOTIFICATION_KEY object:nil];
    
    NSDictionary *locationDic = (NSDictionary*)notification.object;
    
    if (currentElement.type == SurveyCollectionElementTypeAnswerItem){
        
        if (currentElement.question.specialInputType == SurveySpecialInputTypeGeolocation) {
            
            CustomSurveyAnswer *copyAnswer = [currentElement.answer copyObject];
            copyAnswer.text = @"";
            copyAnswer.complexValue = locationDic;
            
            if (notification.userInfo){
                copyAnswer.auxImage = [notification.userInfo objectForKey:@"snapshot"];
            }
            
            //removendo a resposta da lista:
            [currentElement.question.userAnswers removeAllObjects];
            
            //adicionando a resposta, caso tenha um texto válido:
            if (locationDic.allKeys.count > 0){
                [currentElement.question.userAnswers addObject:copyAnswer];
            }
            
            [self rearrangeSurveyDataForIndexPath:currentElement.referenceIndexPath];
            
        }
        
    }
}

- (IBAction)actionColorPickerResult:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:COLOR_PICKER_RESULT_NOTIFICATION_KEY object:nil];
    
    NSDictionary *colorDic = (NSDictionary*)notification.object;
    
    if (currentElement.type == SurveyCollectionElementTypeAnswerItem){
        
        if (currentElement.question.specialInputType == SurveySpecialInputTypeColor) {
            
            CustomSurveyAnswer *copyAnswer = [currentElement.answer copyObject];
            copyAnswer.text = @"";
            copyAnswer.complexValue = colorDic;
            
            //removendo a resposta da lista:
            [currentElement.question.userAnswers removeAllObjects];
            
            //adicionando a resposta, caso tenha um texto válido:
            if (colorDic.allKeys.count > 0){
                
                UIColor *color = nil;
                @try {
                    color = [ToolBox graphicHelper_colorWithHexString:[colorDic valueForKey:@"SPECIAL_INPUT_KEY_COLORPICKER_HEX"]];
                } @catch (NSException *exception) {
                    NSLog(@"actionColorPickerResult >> Error >> %@", [exception reason]);
                }
                
                if (color){
                    copyAnswer.auxImage = [ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.view.frame.size.width - 20.0 - 70.0, 40.0) backgroundColor:color borderWidth:2.0 borderColor:[UIColor darkGrayColor] byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero];
                }
                
                [currentElement.question.userAnswers addObject:copyAnswer];
            }
            
            [self rearrangeSurveyDataForIndexPath:currentElement.referenceIndexPath];
            
        }
        
    }
}

- (IBAction)actionReturnToList:(id)sender
{
    [self.view endEditing:YES];
    
    //Retorno permitido (não finaliza o questionário):
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionReturnToHome:(id)sender
{
    //Retorno para a primeira etapa do questionário:
    
    //0 - vc_configuracoes
    //1 - vc_login
    //2 - vc_timeline
    //3 - vc_custom_survey_samples
    //4 - vc_main_custom_survey
    //5 - vc_geral_form (custom survey first screen)
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:5] animated:YES];
}

- (IBAction)actionExitSurvey:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.survey.acceptsInterruption){
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:@"Sair" withType:SCLAlertButtonType_Normal actionBlock:^{
            
            //TODO: tratar pesquisa interrompida:
            
            [self.survey finishSurvey];
            LocationService *ls = [LocationService initAndStartMonitoringLocation];
            [ls stopMonitoring];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
        [alert showInfo:@"Atenção" subTitle:self.survey.STR.MSG_INTERRUPTEDBYUSER closeButtonTitle:nil duration:0.0];
        
    }else{
        
        if (self.survey.finishedTime){
            
            //O tempo para finalizar a pesquisa já acabou:
            //Ainda há tempo para finalizar a pesquisa:
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert addButton:@"Sair" withType:SCLAlertButtonType_Normal actionBlock:^{
                
                //TODO: tratar pesquisa interrompida aqui...
                
                [self.survey finishSurvey];
                LocationService *ls = [LocationService initAndStartMonitoringLocation];
                [ls stopMonitoring];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
            [alert showError:@"Atenção" subTitle:self.survey.STR.MSG_TIMEOUTEXIT closeButtonTitle:nil duration:0.0];
            
        }else{
            
            //Ainda há tempo para finalizar a pesquisa:
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert addButton:@"Sair" withType:SCLAlertButtonType_Normal actionBlock:^{
                
                //TODO: tratar pesquisa interrompida aqui...
                
                [self.survey finishSurvey];
                LocationService *ls = [LocationService initAndStartMonitoringLocation];
                [ls stopMonitoring];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
            [alert showError:@"Atenção" subTitle:self.survey.STR.MSG_WITHDRAWALBYUSER closeButtonTitle:nil duration:0.0];
            
        }
        
    }
}

- (IBAction)actionNextGroup:(id)sender
{
    [self.view endEditing:YES];
    
    if (!self.survey.intermediateCheckRequirement){
        
        [self performSegueWithIdentifier:@"SegueToCustomSurveyForm" sender:nil];
        
    }else{
        
        BOOL OK = YES;
        CustomSurveyGroup *actualGroup = [self.survey.groups objectAtIndex:groupIndex];
        
        for (CustomSurveyQuestion *question in actualGroup.questions){
            if (question.required && (question.type != SurveyQuestionTypeUnanswerable) && question.activeForUser){
                if (question.userAnswers.count == 0){
                    OK = NO;
                    break;
                }
            }
        }
        
        if (OK){
            [self performSegueWithIdentifier:@"SegueToCustomSurveyForm" sender:nil];
        }else{
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:@"Atenção" subTitle:self.survey.STR.MSG_INCOMPLETESTAGE closeButtonTitle:@"OK" duration:0.0];
        }
        
    }
    
}

- (IBAction)actionFinishSurvey:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.survey.finishedTime){
        
        //O tempo para finalizar a pesquisa já acabou:
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Atenção" subTitle:self.survey.STR.MSG_TIMEOUTFINISH closeButtonTitle:@"OK" duration:0.0];
        
    }else{
        
        //Ainda há tempo para finalizar a pesquisa:
        
        NSString *validationMessage = [self.survey validateSurveyToActualCompletionData];
        
        if (validationMessage){
            
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:@"Atenção" subTitle:validationMessage closeButtonTitle:@"OK" duration:0.0];
            
        }else{
            
            NSString *message = @"Está certo que deseja finalizar agora?";
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Atenção!" message:message preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *actionStart = [UIAlertAction actionWithTitle:@"Finalizar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                dispatch_async(dispatch_get_main_queue(),^{
                    [AppD showLoadingAnimationWithType:eActivityIndicatorType_Processing];
                });
                
                LocationService *ls = [LocationService initAndStartMonitoringLocation];
                
                NSMutableDictionary *questionnaireDic = [[NSMutableDictionary alloc] initWithDictionary:[self.survey reducedJSON]];
                [questionnaireDic setValue:[ToolBox deviceHelper_IdentifierForVendor] forKey:@"device_id_vendor"];
                [questionnaireDic setValue:[NSString stringWithFormat:@"%f", ls.latitude] forKey:@"latitude"];
                [questionnaireDic setValue:[NSString stringWithFormat:@"%f", ls.longitude] forKey:@"longitude"];
                
                NSLog(@"Reduced Questionnarie: %@", questionnaireDic);
                
                if (self.survey.consumptionType == SurveyConsumptionTypeDisposable){
                    
                    //***********************************************************************************************************************
                    //Questionário Descartável
                    // >> Seus dados podem ser usados mas o servidor não precisa dos dados diretamente. Uma outra tela fará uso dos dados.
                    // >> Exemplo: Um cadastro usa os dados do formulário preenchido. O servidor precisa dos dados do cadastro, não do questionário.
                    //***********************************************************************************************************************
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [AppD hideLoadingAnimation];
                            });
                            
                            [self.survey finishSurvey];
                            
                            //TODO: cada aplicação deve fazer uso desta opção separadamente!
                            NSDictionary *questionnaireData = [self.survey dictionaryJSON];
                            NSLog(@"Complete Questionnaire : %@", questionnaireData);
                            
                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
                            
                        }];
                        [alert showSuccess:@"Concluído" subTitle:@"Nenhuma aplicação para os dados estão programadas para este aplicativo." closeButtonTitle:nil duration:0.0];
                    });
                    
                }else{
                    
                    if (self.survey.surveyID != 0){
                        
                        //***********************************************************************************************************************
                        //Questionário Real Server
                        //***********************************************************************************************************************
                        
                        QuestionnaireDataSource *dataSource = [QuestionnaireDataSource new];
                        
                        [dataSource postQuestionnaireToServer:questionnaireDic withCompletionHandler:^(DataSourceResponse * _Nonnull response) {
                            
                            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                            
                            if (response.status == DataSourceResponseStatusSuccess){
                                
                                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                                    [self.survey finishSurvey];
                                    LocationService *ls = [LocationService initAndStartMonitoringLocation];
                                    [ls stopMonitoring];
                                    //retorna para a lista de questionários:
                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
                                }];
                                [alert showSuccess:@"Finalizado!" subTitle:self.survey.STR.MSG_SUCCESSFINISH closeButtonTitle:nil duration:0.0];
                                
                            }else{
                                
                                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                [alert showError:@"Error!" subTitle:response.message closeButtonTitle:@"OK" duration:0.0];
                                
                            }
                            
                        }];
                        
                    }else{
                        
                        //***********************************************************************************************************************
                        //Questionário Demonstração
                        //***********************************************************************************************************************
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                            [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [AppD hideLoadingAnimation];
                                });
                                
                                [self.survey finishSurvey];
                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
                                
                            }];
                            [alert showSuccess:@"Finalizado!" subTitle:@"Obrigado por avaliar esta demonstração!" closeButtonTitle:nil duration:0.0];
                        });
                        
                    }
                    
                }
                
            }];
            [alertController addAction:actionStart];
            
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alertController addAction:actionCancel];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - ScrollView

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == tvSurvey){
        for (UITableViewCell *cell in [tvSurvey visibleCells]){
            if ([cell isKindOfClass:[CS_QuestionWebContent_TVC class]]){
                CS_QuestionWebContent_TVC *cellWC = (CS_QuestionWebContent_TVC*)cell;
                [cellWC.webView setNeedsLayout];
                [cellWC layoutIfNeeded];
            }
        }
    }
}

#pragma mark - EditableComponentTableViewCellProtocol

- (void)didEndEditingComponentAtSection:(NSInteger)section row:(NSInteger)row withValue:(NSString*)textValue
{
    NSMutableArray *list = [elements objectAtIndex:section];
    CustomSurveyCollectionElement *element = [list objectAtIndex:row];
    
    if (element.question.type == SurveyQuestionTypeSingleLineText || element.question.type == SurveyQuestionTypeMultiLineText || element.question.type == SurveyQuestionTypeMaskedText || element.question.type == SurveyQuestionTypeDecimal){
        
        CustomSurveyAnswer *copyAnswer = [element.answer copyObject];
        copyAnswer.text = textValue;
        
        //removendo a resposta da lista:
        [element.question.userAnswers removeAllObjects];
        
        //adicionando a resposta, caso tenha um texto válido:
        if (textValue != nil && ![textValue isEqualToString:@""]){
            [element.question.userAnswers addObject:copyAnswer];
        }
        
        [self rearrangeSurveyDataForIndexPath:nil];
    
    }else if (element.question.type == SurveyQuestionTypeStarRating || element.question.type == SurveyQuestionTypeBarRating || element.question.type == SurveyQuestionTypeLikeRating || element.question.type == SurveyQuestionTypeUnitRating){
        
        //removendo a resposta da lista:
        [element.question.userAnswers removeAllObjects];
        
        //adicionando a resposta
        CustomSurveyAnswer *copyA = [[element.question.answers firstObject] copyObject];
        copyA.text = textValue;
        [element.question.userAnswers addObject:copyA];
        
        [self rearrangeSurveyDataForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    
    }else if (element.question.type == SurveyQuestionTypeSpecialInput){
        
        currentElement = element;
        currentElement.referenceIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        //
        [self resolveSpecialInputCallForCurrentElementWithValue:textValue];
        
    }
    
}

- (void)didEndEditingComponentAtSection:(NSInteger)section row:(NSInteger)row withValidationErrorMessage:(NSString *)errorMessage
{
    NSMutableArray *list = [elements objectAtIndex:section];
    CustomSurveyCollectionElement *element = [list objectAtIndex:row];
    
    if (element.question.type == SurveyQuestionTypeSingleLineText) {
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Campo Validado" subTitle:errorMessage closeButtonTitle:@"OK" duration:0.0];
        
    }
}

- (void)didBeginEditingTextInRect:(CGRect)textRect
{
    [self.tvSurvey scrollRectToVisible:textRect animated:YES];
}

#pragma mark - EditableItemComponentTableViewCellProtocol

- (void)didEndEditingItemComponentAtSection:(NSInteger)section row:(NSInteger)row collectionIndex:(NSInteger)collectionIndex withValue:(NSString*)textValue
{
    NSMutableArray *list = [elements objectAtIndex:section];
    CustomSurveyCollectionElement *element = [list objectAtIndex:row];
    
    if (element.question.type == SurveyQuestionTypeItemList){
        
        if (textValue == nil){
            //Remove:
            [element.question.userAnswers removeObjectAtIndex:collectionIndex];
        }else{
            if (collectionIndex < 0){
                //Insert:
                if ((element.question.selectableItems <= 0) || (element.question.userAnswers.count < element.question.selectableItems)){
                    CustomSurveyAnswer *answer = [CustomSurveyAnswer new];
                    answer.text = textValue;
                    //
                    [element.question.userAnswers addObject:answer];
                }
            }else{
                //Edit:
                CustomSurveyAnswer *answer = [element.question.userAnswers objectAtIndex:collectionIndex];
                answer.text = textValue;
            }
        }
        
        [self rearrangeSurveyDataForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    }
}

- (void)didEndEditingItemComponentAtSection:(NSInteger)section row:(NSInteger)row collectionIndex:(NSInteger)collectionIndex withValidationErrorMessage:(NSString*)errorMessage
{
    NSMutableArray *list = [elements objectAtIndex:section];
    CustomSurveyCollectionElement *element = [list objectAtIndex:row];
    
    if (element.question.type == SurveyQuestionTypeItemList){
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Campo Validado" subTitle:errorMessage closeButtonTitle:@"OK" duration:0.0];
    }
}

#pragma mark - SelectableComponentTableViewCellProtocol

- (void)didEndSelectingComponentAtSection:(NSInteger)section row:(NSInteger)row collectionIndex:(NSInteger)collectionIndex withImage:(UIImage*)image
{
    NSMutableArray *list = [elements objectAtIndex:section];
    CustomSurveyCollectionElement *element = [list objectAtIndex:row];
    
    if (element.question.type == SurveyQuestionTypeImage){
        
        NSInteger indexToEdit = -1;
        for (int i=0; i< element.question.userAnswers.count; i++){
            CustomSurveyAnswer *answer = [element.question.userAnswers objectAtIndex:i];
            answer.referenceIndex = i;
            if (i == collectionIndex){
                indexToEdit = i;
                break;
            }
        }
        
        if (image == nil){
            
            //DELETE
            if (indexToEdit != -1){
                [element.question.userAnswers removeObjectAtIndex:indexToEdit];
            }
            
        }else{
            
            //ADD or EDIT
            
            if (indexToEdit != -1){
                //Edição:
                CustomSurveyAnswer *currentItem = [element.question.userAnswers objectAtIndex:collectionIndex];
                currentItem.image = image;
            }else{
                //Adição:
                CustomSurveyAnswer *newAnswer = [CustomSurveyAnswer newObject];
                newAnswer.image = image;
                newAnswer.referenceIndex = element.question.userAnswers.count;
                //
                [element.question.userAnswers addObject:newAnswer];
            }
        }
        
        [self rearrangeSurveyDataForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    
    }else if (element.question.type == SurveyQuestionTypeCollectionView){
        
        CustomSurveyAnswer *currentItem = [element.question.answers objectAtIndex:collectionIndex];
        
        //precisa remover da lista do usuário:
        CustomSurveyAnswer *answerToRemove = nil;
        for (CustomSurveyAnswer *answer in element.question.userAnswers){
            if (answer.answerID == currentItem.answerID){
                answerToRemove = answer;
                break;
            }
        }
        if (answerToRemove){
            [element.question.userAnswers removeObject:answerToRemove];
        }else{
            if (element.question.selectableItems == 0 || (element.question.userAnswers.count < element.question.selectableItems)){
                [element.question.userAnswers  addObject:[currentItem copyObject]];
            }
        }
        
        [self rearrangeSurveyDataForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    
    }else if (element.question.type == SurveyQuestionTypeOptionRating){
        
        CustomSurveyAnswer *currentItem = [element.question.answers objectAtIndex:collectionIndex];
        
        //precisa remover da lista do usuário:
        [element.question.userAnswers removeAllObjects];
        
        //adicionando a nova seleção:
        [element.question.userAnswers addObject:[currentItem copyObject]];
        
        [self rearrangeSurveyDataForIndexPath:nil];
    }
}

#pragma mark - OptionsComponentTableViewCellProtocol

- (void)requireOptionsListForComponentAtSection:(NSInteger)section row:(NSInteger)row
{
    NSMutableArray *list = [elements objectAtIndex:section];
    __block CustomSurveyCollectionElement *element = [list objectAtIndex:row];
    
    if (element.question.type == SurveyQuestionTypeOptions){
        
        pickerElementOptionList = [NSMutableArray new];
        currentElement = element;
        currentElement.referenceIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        //NOTE: Como apenas 1 item pode estar selecionado de cada vez, apenas o primeiro item da lista é relevante:
        CustomSurveyAnswer *sa = [element.question.userAnswers firstObject];
        
        for (int i=0; i<element.question.answers.count; i++){
            CustomSurveyAnswer *a = [element.question.answers objectAtIndex:i];
            
            BOOL selected = NO;
            if (sa){
                if (sa.answerID == a.answerID){
                    selected = YES;
                }
            }
            
            FloatingPickerElement *pElement = [FloatingPickerElement newElementWithTitle:a.text selection:selected tagID:i enum:0 andData:nil];
            [pickerElementOptionList addObject:pElement];
        }
        
        if (pickerElementOptionList.count > 0){
            [pickerView showFloatingPickerViewWithDelegate:self];
        }
    }
}

#pragma mark - OrderlyComponentTableViewCellProtocol

- (void)activateOptionInComponentAtSection:(NSInteger)section row:(NSInteger)row ascending:(BOOL)ascending
{
    NSMutableArray *list = [elements objectAtIndex:section];
    __block CustomSurveyCollectionElement *element = [list objectAtIndex:row];
    
    NSInteger originalIndex = element.answer.referenceIndex;
    
    if (element.question.type == SurveyQuestionTypeOrderlyOptions){
        
        if (ascending){
            
            //UP
            if (element.answer.referenceIndex !=0){
                
                //reduz o valor do referenceIndex do objeto (elevando seu nível!)
                CustomSurveyAnswer *userAnswer = [element.question.userAnswers objectAtIndex:originalIndex];
                
                if (userAnswer.referenceIndex > 1){
                    userAnswer.referenceIndex -= 1;
                    
                    //aumenta o valor do antigo referenceIndex (diminuindo seu nível!)
                    for (CustomSurveyAnswer *anotherAnswer in element.question.userAnswers){
                        if (anotherAnswer.answerID != userAnswer.answerID){
                            if (anotherAnswer.referenceIndex == userAnswer.referenceIndex){
                                anotherAnswer.referenceIndex += 1;
                            }
                        }
                    }
                    
                    [self rearrangeSurveyDataForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                }
                
            }
            
        }else{
            
            //DOWN
            if (element.answer.referenceIndex != (element.question.answers.count - 1)){
                
                //aumenta o valor do referenceIndex do objeto (diminuindo seu nível!)
                CustomSurveyAnswer *userAnswer = [element.question.userAnswers objectAtIndex:originalIndex];
                
                if (userAnswer.referenceIndex < element.question.userAnswers.count){
                    userAnswer.referenceIndex += 1;
                    
                    //diminui o valor do antigo referenceIndex (aumentando seu nível!)
                    for (CustomSurveyAnswer *anotherAnswer in element.question.userAnswers){
                        if (anotherAnswer.answerID != userAnswer.answerID){
                            if (anotherAnswer.referenceIndex == userAnswer.referenceIndex){
                                anotherAnswer.referenceIndex -= 1;
                            }
                        }
                    }
                    
                    [self rearrangeSurveyDataForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                }
                
            }
            
        }
        
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self calculateTableViewRowHeightFor:tableView atIndexPath:indexPath];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self calculateTableViewRowHeightFor:tableView atIndexPath:indexPath];
    return height;
}

- (CGFloat)calculateTableViewRowHeightFor:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *list = [elements objectAtIndex:indexPath.section];
    __block CustomSurveyCollectionElement *element = [list objectAtIndex:indexPath.row];
    
    switch (element.type) {
            
        //GROUP
            
        case SurveyCollectionElementTypeGroupTitle:{
            return [CS_GroupTitle_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
        }break;
            
        case SurveyCollectionElementTypeGroupHeader:{
            return [CS_GroupHeader_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
        }break;
            
        case SurveyCollectionElementTypeGroupImage:{
            return [CS_GroupImage_TVC referenceHeightForContainerWidth:(tableView.frame.size.width - 20.0) usingParameters:element];
        }break;
            
        case SurveyCollectionElementTypeGroupFooter:{
            return [CS_GroupFooter_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
        }break;
            
        //QUESTIONS
            
        case SurveyCollectionElementTypeQuestionText:{
            return [CS_QuestionText_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:element];
        }break;
            
        case SurveyCollectionElementTypeQuestionImage:{
            return [CS_QuestionImage_TVC referenceHeightForContainerWidth:(tableView.frame.size.width - 20.0) usingParameters:element];
        }break;
            
        case SurveyCollectionElementTypeQuestionWebContent:{
            return [CS_QuestionWebContent_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:element];
        }break;
            
        //ANSWER
            
        case SurveyCollectionElementTypeAnswerItem:{
            
            switch (element.question.type) {
                case SurveyQuestionTypeUnanswerable:{
                    return UITableViewAutomaticDimension;
                }break;
                    
                case SurveyQuestionTypeSingleSelection:{
                    return [CS_AnswerSingleSelection_TVC referenceHeightForContainerWidth:(tableView.frame.size.width - 10.0 - 28.0 - 10.0 - 10.0) usingParameters:element];
                }break;
                    
                case SurveyQuestionTypeMultiSelection:{
                    return [CS_AnswerMultiSelection_TVC referenceHeightForContainerWidth:(tableView.frame.size.width - 10.0 - 28.0 - 10.0 - 10.0) usingParameters:element];
                }break;
                    
                case SurveyQuestionTypeSingleLineText:{
                    return [CS_AnswerSingleLineText_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
                }break;
                    
                case SurveyQuestionTypeMultiLineText:{
                    return [CS_AnswerMultiLineText_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
                }break;
                    
                case SurveyQuestionTypeMaskedText:{
                    return [CS_AnswerMaskedText_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
                }break;
                    
                case SurveyQuestionTypeImage:{
                    return [CS_AnswerImage_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
                }break;
                    
                case SurveyQuestionTypeOptions:{
                    return [CS_AnswerOptions_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
                }break;
                    
                case SurveyQuestionTypeStarRating:{
                    return [CS_AnswerStarRating_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
                }break;
                    
                case SurveyQuestionTypeBarRating:{
                    return [CS_AnswerBarRating_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
                }break;
                    
                case SurveyQuestionTypeLikeRating:{
                    return [CS_AnswerLikeRating_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
                }break;
                    
                case SurveyQuestionTypeUnitRating:{
                    return [CS_AnswerUnitRating_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
                }break;
                    
                case SurveyQuestionTypeDecimal:{
                    return [CS_AnswerDecimal_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
                }break;
                    
                case SurveyQuestionTypeCollectionView:{
                    return [CS_AnswerCollectionView_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:element];
                }break;
                    
                case SurveyQuestionTypeOrderlyOptions:{
                    return [CS_AnswerOrderlyOptions_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:element];
                }break;
                    
                case SurveyQuestionTypeItemList:{
                    return [CS_AnswerItemList_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:element];
                }break;
                    
                case SurveyQuestionTypeSpecialInput:{
                    return [CS_AnswerSpecialInput_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:nil];
                }break;
                    
                case SurveyQuestionTypeOptionRating:{
                    return [CS_AnswerOptionRating_TVC referenceHeightForContainerWidth:tableView.frame.size.width usingParameters:element];
                }break;
                    
                default:{
                    return UITableViewAutomaticDimension;
                }break;
            }
            
        }break;
            
        default:{
            return UITableViewAutomaticDimension;
        }break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return elements.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *list = [elements objectAtIndex:section];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *list = [elements objectAtIndex:indexPath.section];
    __block CustomSurveyCollectionElement *element = [list objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self configureTableViewCell:tableView forElement:element atIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *list = [elements objectAtIndex:indexPath.section];
    __block CustomSurveyCollectionElement *element = [list objectAtIndex:indexPath.row];

    if (element.type == SurveyCollectionElementTypeAnswerItem){
        if ([self canSelectCellForType:element.question.type]){
            if (tableView.tag == 0)
            {
                tableView.tag = 1;
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
                [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
                
                //UI - Animação de seleção
                [UIView animateWithDuration:ANIMA_TIME_FAST delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
                    [cell setBackgroundColor:originalBColor];
                } completion: ^(BOOL finished) {
                    [self resolveSelectionForElement:element inRow:indexPath.row andSection:indexPath.section];
                    tableView.tag = 0;
                }];
            }
        }
    }
}

- (void)resolveSelectionForElement:(CustomSurveyCollectionElement*)element inRow:(NSInteger)row andSection:(NSInteger)section;
{
    //Aqui já se sabe que é um elemento do tipo resposta
    
    switch (element.question.type) {
            
        case SurveyQuestionTypeSingleSelection:{
            [element.question.userAnswers removeAllObjects];
            [element.question.userAnswers addObject:[element.answer copyObject]];
            //
            //[self rearrangeSurveyDataForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            [self rearrangeSurveyDataForIndexPath:[NSIndexPath new]];
        }break;
            
        case SurveyQuestionTypeMultiSelection:{
            
            CustomSurveyAnswer *answerToRemove = nil;
            for (CustomSurveyAnswer *answer in element.question.userAnswers){
                if (answer.answerID == element.answer.answerID){
                    answerToRemove = answer;
                    break;
                }
            }
            if (answerToRemove){
                [element.question.userAnswers removeObject:answerToRemove];
                //
                [self rearrangeSurveyDataForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            }else{
                if (element.question.selectableItems == 0 || (element.question.userAnswers.count < element.question.selectableItems)){
                    [element.question.userAnswers addObject:[element.answer copyObject]];
                    //
                    [self rearrangeSurveyDataForIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                }
            }
            
        }break;
            
        case SurveyQuestionTypeOrderlyOptions:{
            
            [scrollPickerView showPickerViewWithSender:element rowSelected:(int)element.answer.referenceIndex animated:YES];
            
        }
        
        default:{
            return;
        }break;
    }
}

- (BOOL)canSelectCellForType:(SurveyQuestionType)type
{
    if (type == SurveyQuestionTypeSingleSelection || type == SurveyQuestionTypeMultiSelection || type == SurveyQuestionTypeOrderlyOptions){
        return YES;
    }
    //
    return NO;
}

#pragma mark - FloatingPickerElement

- (NSArray<FloatingPickerElement*>* _Nonnull)floatingPickerViewElementsList:(FloatingPickerView *)pickerView
{
    if (pickerElementOptionList.count > 0){
        return pickerElementOptionList;
    }else{
        return [NSMutableArray new];
    }
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
    return @"Opções";
}

- (NSString* _Nonnull)floatingPickerViewSubtitle:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Selecione um dos itens abaixo:";
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
        
        if (currentElement){
            if (currentElement.question.type == SurveyQuestionTypeOptions){
                
                //removendo as possíveis respostas anteriores:
                [currentElement.question.userAnswers removeAllObjects];
                
                //inserindo a nova (element.tagID é o index do item selecionado)
                CustomSurveyAnswer *selectedAnswer = [currentElement.question.answers objectAtIndex:element.tagID];
                if (selectedAnswer){
                    [currentElement.question.userAnswers addObject:[selectedAnswer copyObject]];
                }
        
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self rearrangeSurveyDataForIndexPath:currentElement.referenceIndexPath];
                    //
                    currentElement = nil;
                });
            }
        }
        
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

#pragma mark - CustomPickerViewDelegate

-(void)didConfirmItem:(nullable NSString*)selectedItem forSender:(nullable id)sender
{
    NSInteger index = ([selectedItem integerValue] - 1);
    
    if ([sender isKindOfClass:[CustomSurveyCollectionElement class]]){
        
        CustomSurveyCollectionElement *el = (CustomSurveyCollectionElement*)sender;
        CustomSurveyAnswer *destinationAnswer = [el.question.userAnswers objectAtIndex:index];
        CustomSurveyAnswer *toRealocateAnswer = [el.question.userAnswers objectAtIndex:el.answer.referenceIndex];
        [el.question.userAnswers replaceObjectAtIndex:index withObject:[toRealocateAnswer copyObject]];
        [el.question.userAnswers replaceObjectAtIndex:el.answer.referenceIndex withObject:[destinationAnswer copyObject]];
        //
        for (int i=0; i<el.question.answers.count; i++){
            CustomSurveyAnswer *originalA = [el.question.answers objectAtIndex:i];
            CustomSurveyAnswer *userA = [el.question.userAnswers objectAtIndex:i];
            userA.referenceIndex = originalA.referenceIndex + 1;
        }
        //
        [tvSurvey reloadData];
    }
    
    sender = nil;
}

-(void)didClearSelectionForSender:(nullable id)sender
{
    sender = nil;
}

-(nonnull NSArray<NSString*>*)loadDataForSender:(nullable id)sender
{
    NSMutableArray *options = [NSMutableArray new];
    
    if ([sender isKindOfClass:[CustomSurveyCollectionElement class]]){
        
        CustomSurveyCollectionElement *el = (CustomSurveyCollectionElement*)sender;
        
        for (CustomSurveyAnswer *a in el.question.answers){
            [options addObject:[NSString stringWithFormat:@"%li", (a.referenceIndex + 1)]];
        }
        
    }
    
    return options;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    tvSurvey.backgroundColor = [UIColor whiteColor];
    [tvSurvey setTableFooterView:[self createFooterForTableView]];
    
    //footer
    footerView.backgroundColor = [UIColor darkGrayColor];
    //
    lblFooterTitle.backgroundColor = [UIColor clearColor];
    lblFooterTitle.textColor = [UIColor whiteColor];
    [lblFooterTitle setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NORMAL]];
    lblFooterTitle.text = @"Tempo restante:";
    //
    lblFooterTime.backgroundColor = [UIColor clearColor];
    lblFooterTime.textColor = [UIColor yellowColor];
    [lblFooterTime setFont:[UIFont fontWithName:FONT_DEFAULT_BOLD size:20.0]];
    lblFooterTime.text = [self.survey remainingTime];
    
    [footerView setHidden:YES];
    
    footerConstraint.constant = 0;
    
    //Botão Sair
    switch (self.survey.formType) {
        case SurveyFormTypeUnanswerable:{
            //nothing to do...
        }break;
            
        case SurveyFormTypeFullPage:{
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sair" style:UIBarButtonItemStylePlain target:self action:@selector(actionExitSurvey:)];
        }break;
            
        case SurveyFormTypeGroups:{
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Voltar" style:UIBarButtonItemStylePlain target:self action:@selector(actionReturnToList:)];
        }break;
            
        case SurveyFormTypeStages:{
            if (groupIndex == 0){
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sair" style:UIBarButtonItemStylePlain target:self action:@selector(actionExitSurvey:)];
            }else{
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Voltar" style:UIBarButtonItemStylePlain target:self action:@selector(actionReturnToList:)];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(actionReturnToHome:)];
            }
        }break;
    }
    
    if (scrollPickerView == nil){
        
        scrollPickerView = [CustomPickerView createComponent];
        [scrollPickerView initPickerViewWithDelegate:self confirmButtonTitle:@"Confirmar" clearButtonTitle:@"Cancelar"];
        //show
        //hide
        [scrollPickerView setAccessoryBackgroundColor:AppD.styleManager.colorPalette.backgroundNormal];
        UIFont *font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
        [scrollPickerView configRightButton:@"Confirmar" font:font textColor:[UIColor whiteColor] enabled:YES];
        [scrollPickerView configLeftButton:@"Cancelar" font:font textColor:[UIColor whiteColor] enabled:YES];
        
    }
    
    if (survey.formType == SurveyFormTypeStages){
        self.navigationItem.title = [NSString stringWithFormat:@"Etapa %li/%li", (self.groupIndex + 1), self.survey.groups.count];
    }
    
    [self.view layoutIfNeeded];
}

- (void)registerCells
{
    //Groups
    {
        UINib *nib = [UINib nibWithNibName:@"CS_GroupTitle_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_GroupTitle_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_GroupHeader_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_GroupHeader_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_GroupImage_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_GroupImage_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_GroupFooter_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_GroupFooter_TVC_Identifier"];
    }
    
    
    //Questions
    {
        UINib *nib = [UINib nibWithNibName:@"CS_QuestionText_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_QuestionText_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_QuestionImage_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_QuestionImage_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_QuestionWebContent_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_QuestionWebContent_TVC_Identifier"];
    }
    
    
    //Answer

    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerSingleSelection_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerSingleSelection_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerMultiSelection_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerMultiSelection_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerSingleLineText_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerSingleLineText_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerMultiLineText_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerMultiLineText_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerMaskedText_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerMaskedText_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerImage_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerImage_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerOptions_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerOptions_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerStarRating_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerStarRating_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerBarRating_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerBarRating_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerLikeRating_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerLikeRating_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerUnitRating_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerUnitRating_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerDecimal_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerDecimal_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerCollectionView_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerCollectionView_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerOrderlyOptions_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerOrderlyOptions_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerItemList_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerItemList_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerSpecialInput_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerSpecialInput_TVC_Identifier"];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:@"CS_AnswerOptionRating_TVC" bundle:nil];
        [tvSurvey registerNib:nib forCellReuseIdentifier:@"CS_AnswerOptionRating_TVC_Identifier"];
    }

    //
}

- (UIView*)createFooterForTableView
{
    UIView *baseView = [UIView new];
    
    switch (self.survey.formType) {
        case SurveyFormTypeUnanswerable:{
            //nothing to do...
        }break;
            
        case SurveyFormTypeFullPage:{
            
            baseView.frame = CGRectMake(0.0, 0.0, tvSurvey.frame.size.width, 110.0);
            baseView.backgroundColor = [UIColor whiteColor];
            
            UIButton *btnReturn = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 30.0, baseView.frame.size.width - 20.0, 50.0)];
            btnReturn.backgroundColor = [UIColor clearColor];
            [btnReturn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnReturn.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
            [btnReturn setTitle:@"FINALIZAR" forState:UIControlStateNormal];
            [btnReturn setExclusiveTouch:YES];
            [btnReturn setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReturn.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:COLOR_MA_BLUE] forState:UIControlStateNormal];
            [btnReturn setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReturn.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:COLOR_MA_DARKGRAY] forState:UIControlStateHighlighted];
            [btnReturn addTarget:self action:@selector(actionFinishSurvey:) forControlEvents:UIControlEventTouchUpInside];
            
            [baseView addSubview:btnReturn];
            
        }break;
            
        case SurveyFormTypeGroups:{
            
            baseView.frame = CGRectMake(0.0, 0.0, tvSurvey.frame.size.width, 100.0);
            baseView.backgroundColor = [UIColor whiteColor];
            
            UIButton *btnReturn = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 30.0, baseView.frame.size.width - 20.0, 40.0)];
            btnReturn.backgroundColor = [UIColor clearColor];
            [btnReturn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnReturn.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
            [btnReturn setTitle:@"Concluir Grupo" forState:UIControlStateNormal];
            [btnReturn setExclusiveTouch:YES];
            [btnReturn setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReturn.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
            [btnReturn setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReturn.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
            [btnReturn addTarget:self action:@selector(actionReturnToList:) forControlEvents:UIControlEventTouchUpInside];
            
            [baseView addSubview:btnReturn];
            
        }break;
            
        case SurveyFormTypeStages:{
            
            if (groupIndex == (survey.groups.count - 1)){
                
                //último estágio:
                
                baseView.frame = CGRectMake(0.0, 0.0, tvSurvey.frame.size.width, 110.0);
                baseView.backgroundColor = [UIColor whiteColor];
                
                UIButton *btnReturn = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 30.0, baseView.frame.size.width - 20.0, 50.0)];
                btnReturn.backgroundColor = [UIColor clearColor];
                [btnReturn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnReturn.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
                [btnReturn setTitle:@"FINALIZAR" forState:UIControlStateNormal];
                [btnReturn setExclusiveTouch:YES];
                [btnReturn setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReturn.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:COLOR_MA_BLUE] forState:UIControlStateNormal];
                [btnReturn setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReturn.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:COLOR_MA_DARKGRAY] forState:UIControlStateHighlighted];
                [btnReturn addTarget:self action:@selector(actionFinishSurvey:) forControlEvents:UIControlEventTouchUpInside];
                
                [baseView addSubview:btnReturn];
                
            }else{
                
                //intermediários:
                
                baseView.frame = CGRectMake(0.0, 0.0, tvSurvey.frame.size.width, 100.0);
                baseView.backgroundColor = [UIColor whiteColor];
                
                UIButton *btnReturn = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 30.0, baseView.frame.size.width - 20.0, 40.0)];
                btnReturn.backgroundColor = [UIColor clearColor];
                [btnReturn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnReturn.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
                [btnReturn setTitle:@"Próxima Etapa" forState:UIControlStateNormal];
                [btnReturn setExclusiveTouch:YES];
                [btnReturn setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReturn.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
                [btnReturn setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReturn.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
                [btnReturn addTarget:self action:@selector(actionNextGroup:) forControlEvents:UIControlEventTouchUpInside];
                
                [baseView addSubview:btnReturn];
                
            }
            
            
        }break;
    }
    
    return baseView;
}

- (void)startSurveyTimer
{
    footerConstraint.constant = footerView.frame.size.height;
    [footerView setHidden:NO];
    [self.view layoutIfNeeded];
    
    if (refreshDataTimer) {
        [refreshDataTimer invalidate];
    }
    refreshDataTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:refreshDataTimer forMode:NSRunLoopCommonModes];
}

- (void)updateTimer:(NSTimer*)timer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        lblFooterTime.text = [self.survey remainingTime];
    });
}

#pragma mark - • Data Control

- (void)rearrangeSurveyDataForIndexPath:(NSIndexPath*)indexPath
{
    NSInteger elCount = 0;
    
    if (elements.count > 0){
        elCount = elements.count;
    }
    
    elements = [NSMutableArray new];
    
    CustomSurveyGroup *referenceGroup = [self.survey.groups objectAtIndex:groupIndex];
    
    for (CustomSurveyGroup *group in self.survey.groups){
        
        if (survey.formType == SurveyFormTypeFullPage || (referenceGroup.groupID == group.groupID)){
            
            NSMutableArray<CustomSurveyCollectionElement*> *groupElements = [NSMutableArray new];
            
            //***************************************************************************
            
            //Group (title) REQUIRED!
            {
                CustomSurveyCollectionElement *el = [CustomSurveyCollectionElement new];
                el.type = SurveyCollectionElementTypeGroupTitle;
                el.group = group;
                el.question = nil;
                el.answer = nil;
                [groupElements addObject:el];
            }
            
            //Group (header)
            if ([ToolBox textHelper_CheckRelevantContentInString:group.headerMessage]){
                {
                    CustomSurveyCollectionElement *el = [CustomSurveyCollectionElement new];
                    el.type = SurveyCollectionElementTypeGroupHeader;
                    el.group = group;
                    el.question = nil;
                    el.answer = nil;
                    [groupElements addObject:el];
                }
            }
            
            //Group (image)
            if ([ToolBox textHelper_CheckRelevantContentInString:group.imageURL]){
                {
                    CustomSurveyCollectionElement *el = [CustomSurveyCollectionElement new];
                    el.type = SurveyCollectionElementTypeGroupImage;
                    el.group = group;
                    el.question = nil;
                    el.answer = nil;
                    [groupElements addObject:el];
                }
            }
            
            for (CustomSurveyQuestion *question in group.questions){
                
                question.activeForUser = NO;
                
                //Para desconsiderar as questões dependentes basta executar diretamente o conteúdo abaixo e deletar o corpo atual do 'for':
                //[self rearrangeQuestionData:question inGroup:group usingGroupElementList:groupElements];
                
                if (question.parentQuestionID != 0){
                    
                    //Questões dependentes apenas são consideradas caso alguma das opções da sua parent solicitem:
                    for (CustomSurveyQuestion *parentQuestion in group.questions){
                        //Para todas as questões do mesmo grupo diferentes da atual:
                        if (parentQuestion.questionID != question.questionID){
                            //Na questão "pai":
                            if (parentQuestion.questionID == question.parentQuestionID){
                                //Caso o obrigatoriedade venha de qualquer uma das respostas (ou seja, basta responder qualquer uma...):
                                if (question.parentAnswerID == 0 && parentQuestion.userAnswers.count > 0){
                                    [self rearrangeQuestionData:question inGroup:group usingGroupElementList:groupElements];
                                }else{
                                    //Caso o obrigatoriedade venha de uma resposta específica:
                                    for (CustomSurveyAnswer *parentUserAnswer in parentQuestion.userAnswers){
                                        if (parentUserAnswer.answerID == question.parentAnswerID){
                                            [self rearrangeQuestionData:question inGroup:group usingGroupElementList:groupElements];
                                            //
                                            break;
                                        }
                                    }
                                }
                                break;
                            }
                        }
                    }
                    
                }else{
                    
                    //Não há dependência a ser averiguada:
                     [self rearrangeQuestionData:question inGroup:group usingGroupElementList:groupElements];
                }
                
            }
            
            //Group (footer)
            if ([ToolBox textHelper_CheckRelevantContentInString:group.footerMessage]){
                {
                    CustomSurveyCollectionElement *el = [CustomSurveyCollectionElement new];
                    el.type = SurveyCollectionElementTypeGroupFooter;
                    el.group = group;
                    el.question = nil;
                    el.answer = nil;
                    [groupElements addObject:el];
                }
            }
            
            [elements addObject:groupElements];
        }
    }
    
    [tvSurvey setRemembersLastFocusedIndexPath:YES];
    
    if (elCount != elements.count){
        [tvSurvey reloadData];
    }else if (indexPath){
        
        if (indexPath.length == 0){
            [tvSurvey reloadData];
        }else{
            [tvSurvey reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }

}

- (void) rearrangeQuestionData:(CustomSurveyQuestion*)question inGroup:(CustomSurveyGroup*)group usingGroupElementList:(NSMutableArray<CustomSurveyCollectionElement*>*) groupElements
{
    question.activeForUser = YES;
    
    //***************************************************************************
    
    //Question (text) - REQUIRED!
    {
        CustomSurveyCollectionElement *el = [CustomSurveyCollectionElement new];
        el.type = SurveyCollectionElementTypeQuestionText;
        el.group = group;
        el.question = question;
        el.answer = nil;
        [groupElements addObject:el];
    }
    
    //Question (image)
    if ([ToolBox textHelper_CheckRelevantContentInString:question.imageURL]){
        {
            CustomSurveyCollectionElement *el = [CustomSurveyCollectionElement new];
            el.type = SurveyCollectionElementTypeQuestionImage;
            el.group = group;
            el.question = question;
            el.answer = nil;
            [groupElements addObject:el];
        }
    }else{
        
        //Question (web content)
        if ([ToolBox textHelper_CheckRelevantContentInString:question.webContentURL]){
            {
                CustomSurveyCollectionElement *el = [CustomSurveyCollectionElement new];
                el.type = SurveyCollectionElementTypeQuestionWebContent;
                el.group = group;
                el.question = question;
                el.answer = nil;
                [groupElements addObject:el];
            }
        }
    }
    
    if (question.type == SurveyQuestionTypeImage || question.type == SurveyQuestionTypeOptions || question.type == SurveyQuestionTypeCollectionView || question.type == SurveyQuestionTypeOptionRating){
        
        //Estes tipos de questões resumem todas as opções numa linha
        //Outros tipos utilizam uma linha por opção
        
        //Answer (one line) - REQUIRED!
        {
            CustomSurveyCollectionElement *el = [CustomSurveyCollectionElement new];
            el.type = SurveyCollectionElementTypeAnswerItem;
            el.group = group;
            el.question = question;
            el.answer = nil; //não precisa de uma resposta específica (todas serão exibidas num collection/list)
            [groupElements addObject:el];
        }
        
    }else if (question.type == SurveyQuestionTypeOrderlyOptions){
        
        //***************************************************************************
        
        long index = 0;
        
        for (CustomSurveyAnswer *answer in question.answers){
            
            //NOTE: O campo 'referenceIndex' possui 2 funções para este tipo de questão
            //1) registra a posição da resposta, quando lido 'element.answer.referenceIndex';
            //2) registra a importância dada pelo usuário, quando lido 'element.question.userAnswer.<i>.referenceIndex'.
            answer.referenceIndex = index;
            CustomSurveyAnswer *userAnswer = [answer copyObject];
            userAnswer.referenceIndex = (index + 1);
            [question.userAnswers addObject:userAnswer];
            
            {
                CustomSurveyCollectionElement *el = [CustomSurveyCollectionElement new];
                el.type = SurveyCollectionElementTypeAnswerItem;
                el.group = group;
                el.question = question;
                el.answer = answer;
                [groupElements addObject:el];
            }
            
            //incremento do índice:
            index += 1;
            
        }
        
    }else{
        
        if (question.type != SurveyQuestionTypeUnanswerable){
            for (CustomSurveyAnswer *answer in question.answers){
                
                //***************************************************************************
                
                //Answer (all items) - REQUIRED!
                {
                    CustomSurveyCollectionElement *el = [CustomSurveyCollectionElement new];
                    el.type = SurveyCollectionElementTypeAnswerItem;
                    el.group = group;
                    el.question = question;
                    el.answer = answer;
                    [groupElements addObject:el];
                }
            }
        }
        
    }
}

#pragma mark -

- (UITableViewCell*)configureTableViewCell:(UITableView*)tableView forElement:(CustomSurveyCollectionElement*)element atIndexPath:(NSIndexPath*)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    switch (element.type) {
            
        //GROUP
            
        case SurveyCollectionElementTypeGroupTitle:{
            
            CS_GroupTitle_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_GroupTitle_TVC_Identifier"];
            if(cell == nil){
                cell = [[CS_GroupTitle_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_GroupTitle_TVC_Identifier"];
            }
            [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
            return cell;
            
        }break;
            
        case SurveyCollectionElementTypeGroupHeader:{
            
            CS_GroupHeader_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_GroupHeader_TVC_Identifier"];
            if(cell == nil){
                cell = [[CS_GroupHeader_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_GroupHeader_TVC_Identifier"];
            }
            [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
            return cell;
            
        }break;
            
        case SurveyCollectionElementTypeGroupImage:{
            
            CS_GroupImage_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_GroupImage_TVC_Identifier"];
            if(cell == nil){
                cell = [[CS_GroupImage_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_GroupImage_TVC_Identifier"];
            }
            [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
            return cell;
            
        }break;
            
        case SurveyCollectionElementTypeGroupFooter:{
            
            CS_GroupFooter_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_GroupFooter_TVC_Identifier"];
            if(cell == nil){
                cell = [[CS_GroupFooter_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_GroupFooter_TVC_Identifier"];
            }
            [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
            return cell;
            
        }break;
            
        //QUESTIONS
            
        case SurveyCollectionElementTypeQuestionText:{
            
            if (![ToolBox textHelper_CheckRelevantContentInString:element.question.text]){
                return [UITableViewCell new];
            }else{
                CS_QuestionText_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_QuestionText_TVC_Identifier"];
                if(cell == nil){
                    cell = [[CS_QuestionText_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_QuestionText_TVC_Identifier"];
                }
                [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                return cell;
            }
            
        }break;
            
        case SurveyCollectionElementTypeQuestionImage:{
            
            CS_QuestionImage_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_QuestionImage_TVC_Identifier"];
            if(cell == nil){
                cell = [[CS_QuestionImage_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_QuestionImage_TVC_Identifier"];
            }
            [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
            return cell;
            
        }break;
            
        case SurveyCollectionElementTypeQuestionWebContent:{
            
            CS_QuestionWebContent_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_QuestionWebContent_TVC_Identifier"];
            if(cell == nil){
                cell = [[CS_QuestionWebContent_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_QuestionWebContent_TVC_Identifier"];
            }
            [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
            return cell;
            
        }break;
            
        //ANSWER
            
        case SurveyCollectionElementTypeAnswerItem:{
            
            switch (element.question.type) {
                case SurveyQuestionTypeUnanswerable:{
                    return [UITableViewCell new];
                }break;
                    
                case SurveyQuestionTypeSingleSelection:{
                    
                    CS_AnswerSingleSelection_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerSingleSelection_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerSingleSelection_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerSingleSelection_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeMultiSelection:{
                    
                    CS_AnswerMultiSelection_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerMultiSelection_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerMultiSelection_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerMultiSelection_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeSingleLineText:{
                    
                    CS_AnswerSingleLineText_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerSingleLineText_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerSingleLineText_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerSingleLineText_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.cellEditorDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeMultiLineText:{
                    
                    CS_AnswerMultiLineText_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerMultiLineText_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerMultiLineText_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerMultiLineText_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.cellEditorDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeMaskedText:{
                    
                    CS_AnswerMaskedText_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerMaskedText_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerMaskedText_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerMaskedText_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.cellEditorDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeImage:{
                    
                    CS_AnswerImage_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerImage_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerImage_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerImage_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.vcDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeOptions:{
                    
                    CS_AnswerOptions_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerOptions_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerOptions_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerOptions_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.vcDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeStarRating:{
                    
                    CS_AnswerStarRating_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerStarRating_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerStarRating_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerStarRating_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.vcDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeBarRating:{
                    
                    CS_AnswerBarRating_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerBarRating_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerBarRating_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerBarRating_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.vcDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeLikeRating:{
                    
                    CS_AnswerLikeRating_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerLikeRating_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerLikeRating_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerLikeRating_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.vcDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeUnitRating:{
                    
                    CS_AnswerUnitRating_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerUnitRating_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerUnitRating_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerUnitRating_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.vcDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeDecimal:{
                    
                    CS_AnswerDecimal_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerDecimal_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerDecimal_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerDecimal_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.vcDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeCollectionView:{
                    
                    CS_AnswerCollectionView_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerCollectionView_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerCollectionView_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerCollectionView_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.vcDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeOrderlyOptions:{
                    
                    CS_AnswerOrderlyOptions_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerOrderlyOptions_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerOrderlyOptions_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerOrderlyOptions_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeItemList:{
                    
                    CS_AnswerItemList_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerItemList_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerItemList_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerItemList_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.vcDelegate = self;
                    [tableView beginUpdates];
                    [tableView endUpdates];
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeSpecialInput:{
                    
                    CS_AnswerSpecialInput_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerSpecialInput_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerSpecialInput_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerSpecialInput_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.vcDelegate = self;
                    return cell;
                    
                }break;
                    
                case SurveyQuestionTypeOptionRating:{
                    
                    CS_AnswerOptionRating_TVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CS_AnswerOptionRating_TVC_Identifier"];
                    if(cell == nil){
                        cell = [[CS_AnswerOptionRating_TVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CS_AnswerOptionRating_TVC_Identifier"];
                    }
                    [cell configureLayoutFor:tableView usingElement:element atIndex:indexPath];
                    cell.vcDelegate = self;
                    return cell;
                    
                }break;
                    
                default:{
                    return [UITableViewCell new];
                }break;
            }
            
        }break;
            
        default:{
            return [UITableViewCell new];
        }break;
    }
    
    return [UITableViewCell new];
}

- (void) resolveSpecialInputCallForCurrentElementWithValue:(NSString*)textValue
{
    switch (currentElement.question.specialInputType) {
            
        //******************************************************************************************************
            
        case SurveySpecialInputTypeNormal:{
            
            //O usuário inseriu um texto normal:
            
            CustomSurveyAnswer *copyAnswer = [currentElement.answer copyObject];
            copyAnswer.text = textValue;
            
            //removendo a resposta da lista:
            [currentElement.question.userAnswers removeAllObjects];
            
            //adicionando a resposta, caso tenha um texto válido:
            if (textValue != nil && ![textValue isEqualToString:@""]){
                [currentElement.question.userAnswers addObject:copyAnswer];
            }
            
            [self rearrangeSurveyDataForIndexPath:nil];
            
        }break;
            
        //******************************************************************************************************
            
        case SurveySpecialInputTypeGeolocation:{
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionLocationPickerResult:) name:LOCATION_PICKER_RESULT_NOTIFICATION_KEY object:nil];
            [self performSegueWithIdentifier:@"SegueToLocationPicker" sender:nil];
            
        }break;
            
        //******************************************************************************************************
            
        case SurveySpecialInputTypeColor:{
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionColorPickerResult:) name:COLOR_PICKER_RESULT_NOTIFICATION_KEY object:nil];
            [self performSegueWithIdentifier:@"SegueToColorPicker" sender:nil];
            
        }break;
            
        //******************************************************************************************************
        
        default:{
            
            //SurveySpecialInputTypeQRCode
            //SurveySpecialInputTypeBarcode
            //SurveySpecialInputTypePDF417
            //SurveySpecialInputTypeBoleto
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionBarcodeReaderResult:) name:BARCODE_READER_RESULT_NOTIFICATION_KEY object:nil];
            [self performSegueWithIdentifier:@"SegueToCodeReader" sender:nil];
            
        }break;
            
    }
}

#pragma mark - UTILS (General Use)

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    if (@available(iOS 11.0, *)) {
        contentInsets.bottom += self.view.safeAreaInsets.bottom;
    }
    tvSurvey.contentInset = contentInsets;
    tvSurvey.scrollIndicatorInsets = contentInsets;
    //
    //[tvSurvey scrollRectToVisible:xxxxx animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    tvSurvey.contentInset = UIEdgeInsetsZero;
    tvSurvey.scrollIndicatorInsets = UIEdgeInsetsZero;
}

@end
