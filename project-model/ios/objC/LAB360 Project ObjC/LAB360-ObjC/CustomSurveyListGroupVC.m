//
//  CustomSurveyListGroupVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 09/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "CustomSurveyListGroupVC.h"
#import "AppDelegate.h"
#import "CustomSurveyGroupItemTVC.h"
#import "CustomSurveyGeralFormVC.h"
//
#import "QuestionnaireDataSource.h"
#import "LocationService.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface CustomSurveyListGroupVC()<UITableViewDelegate, UITableViewDataSource>

//Data:
@property (nonatomic, strong) NSTimer *refreshDataTimer;

//Layout:
@property(nonatomic, weak) IBOutlet UITableView *tvGroups;
//
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *footerConstraint;
//
@property(nonatomic, weak) IBOutlet UIView *footerView;
@property(nonatomic, weak) IBOutlet UILabel *lblFooterTitle;
@property(nonatomic, weak) IBOutlet UILabel *lblFooterTime;

@end

#pragma mark - • IMPLEMENTATION
@implementation CustomSurveyListGroupVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize survey, refreshDataTimer;
@synthesize tvGroups, footerConstraint;
@synthesize footerView, lblFooterTitle, lblFooterTime;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![survey isRunning]){
        [self setupLayout:@" "];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![survey isRunning]){
        [self.survey startSurvey];
        //
        if (survey.secondsToFinish > 0){
            [self startSurveyTimer];
        }
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"Completo %@", [self.survey surveyCompletion]];
    
    [tvGroups reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToSurveyForm"]){
        CustomSurveyGeralFormVC *destViewController = (CustomSurveyGeralFormVC*)segue.destinationViewController;
        destViewController.survey = survey;
        destViewController.groupIndex = ((NSIndexPath*)sender).row;
        destViewController.showAppMenu = NO;
        //
        return;
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionExitSurvey:(id)sender
{
    if (self.survey.acceptsInterruption){
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:@"Sair" withType:SCLAlertButtonType_Normal actionBlock:^{
            
            //TODO: tratar pesquisa interrompida
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

- (IBAction)actionFinishSurvey:(id)sender
{
    if (self.survey.finishedTime){
        
        //O tempo para finalizar a pesquisa já acabou:
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Atenção" subTitle:self.survey.STR.MSG_TIMEOUTFINISH closeButtonTitle:@"OK" duration:0.0];
        
    }else{
        
        //Ainda há tempo para finalizar a pesquisa:
        
        NSString *validationMessage = [self.survey validateSurveyToActualCompletionData];
        
        if (validationMessage){
            
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:@"Atenção" subTitle:validationMessage closeButtonTitle:@"" duration:0.0];
            
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
                        //Questionário Exemplo Local
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
                            [alert showSuccess:@"Finalizado!" subTitle:@"Obrigado por avaliar este exemplo!" closeButtonTitle:nil duration:0.0];
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 180.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return survey.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"SurveyGroupItemCell";
    CustomSurveyGroupItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    if(cell == nil){
        cell = [[CustomSurveyGroupItemTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    [cell setupLayout];
    
    CustomSurveyGroup *group = [survey.groups objectAtIndex:indexPath.row];
    
    cell.lblTitle.text = group.name;
        
    cell.lblComplete.text = [group groupCompletion];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 180.0)];
    baseView.backgroundColor = [UIColor clearColor];
    
    //BACKGROUND-MESSAGE
    UIImageView *imvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 20.0, baseView.frame.size.width - 20.0, 70.0)];
    imvBackground.backgroundColor = [UIColor groupTableViewBackgroundColor];
    imvBackground.layer.cornerRadius = 5.0;
    imvBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imvBackground.layer.borderWidth = 1.5;
    [imvBackground setAlpha:0.4];
    //
    [baseView addSubview:imvBackground];
    
    //MESSAGE
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 30.0, imvBackground.frame.size.width - 30.0, imvBackground.frame.size.height - 20.0)];
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textColor = [UIColor darkGrayColor];
    [lblMessage setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NOTE]];
    [lblMessage setNumberOfLines:0];
    [lblMessage setMinimumScaleFactor:0.5];
    [lblMessage setAdjustsFontSizeToFitWidth:YES];
    [lblMessage setTextAlignment:NSTextAlignmentCenter];
    lblMessage.text = @"Toque no respectivo grupo para completar as questões separadamente. Você pode responder na ordem que desejar.";
    //
    [baseView addSubview:lblMessage];
    
    //FINISH BUTTON
    UIButton *btnFinishSurvey = [[UIButton alloc] initWithFrame:CGRectMake(10.0, (20.0 + 70.0 + 20.0), baseView.frame.size.width - 20.0, 50.0)];
    btnFinishSurvey.backgroundColor = [UIColor clearColor];
    [btnFinishSurvey setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFinishSurvey.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
    [btnFinishSurvey setTitle:@"FINALIZAR" forState:UIControlStateNormal];
    [btnFinishSurvey setExclusiveTouch:YES];
    [btnFinishSurvey setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnFinishSurvey.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:COLOR_MA_BLUE] forState:UIControlStateNormal];
    [btnFinishSurvey setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnFinishSurvey.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:COLOR_MA_DARKGRAY] forState:UIControlStateHighlighted];
    [btnFinishSurvey addTarget:self action:@selector(actionFinishSurvey:) forControlEvents:UIControlEventTouchUpInside];
    //
    [baseView addSubview:btnFinishSurvey];
    
    return baseView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0)
    {
        tableView.tag = 1;
        CustomSurveyGroupItemTVC *cell = (CustomSurveyGroupItemTVC*)[tableView cellForRowAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.imvBackground.backgroundColor.CGColor];
        [cell.imvBackground setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell.imvBackground setBackgroundColor:originalBColor];
        } completion: ^(BOOL finished) {
            [self resolveSelectionForIndexPath:indexPath];
            tableView.tag = 0;
        }];
    }
}

- (void)resolveSelectionForIndexPath:(NSIndexPath*)indexPath
{
    [self performSegueWithIdentifier:@"SegueToSurveyForm" sender:indexPath];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    tvGroups.backgroundColor = [UIColor whiteColor];
    [tvGroups setTableFooterView:[UIView new]];
    
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
    lblFooterTime.text = [self.survey calculateTimeToSurvey];
    
    [footerView setHidden:YES];
    
    footerConstraint.constant = 0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sair" style:UIBarButtonItemStylePlain target:self action:@selector(actionExitSurvey:)];
    
    [self.view layoutIfNeeded];    
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

#pragma mark - UTILS (General Use)

@end
