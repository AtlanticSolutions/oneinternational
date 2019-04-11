//
//  CustomSurveyAvailableSamplesVC.m
//  LAB360-ObjC
//
//  Created by lordesire on 21/01/2019.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "CustomSurveyAvailableSamplesVC.h"
#import "AppDelegate.h"
#import "CustomSurveyMainVC.h"
#import "CustomSurvey.h"
#import "CustomSurveySampleCellTVC.h"
#import "QuestionnaireDataSource.h"
#import "CustomSurveyAvailableItemNote.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface CustomSurveyAvailableSamplesVC()<UITableViewDataSource, UITableViewDelegate>

//Data:
@property(nonatomic, strong) NSMutableArray<CustomSurvey*> *questionnaireList;

//Layout:
@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UITableView *tvSampleSurveys;

@end

#pragma mark - • IMPLEMENTATION
@implementation CustomSurveyAvailableSamplesVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize questionnaireList, lblTitle, tvSampleSurveys;

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
    
    [self setupLayout:@"Questionários Personalizáveis"];
    
    [tvSampleSurveys reloadData];
    
    [self loadQuestionnairesFromServer];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];

    if ([segue.identifier isEqualToString:@"SegueToMainCustomSurvey"]){
        CustomSurveyMainVC *vc = segue.destinationViewController;
        vc.showAppMenu = NO;
        vc.survey = [(CustomSurvey*)sender copyObject];
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return questionnaireList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"CustomSurveySampleCellIdentifier";
    CustomSurveySampleCellTVC *cell = (CustomSurveySampleCellTVC*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    if(cell == nil){
        cell = [[CustomSurveySampleCellTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    [cell setupLayout];
    
    CustomSurvey *survey = [questionnaireList objectAtIndex:indexPath.row];
    
    if (survey.surveyID == 0){
        cell.contentView.backgroundColor = COLOR_MA_LIGHTYELLOW;
    }else{
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.lblTitle.text = survey.name;
    cell.lblDescription.text = survey.presentation;
    
    CustomSurveyAvailableItemNote *itemConfig = [self verifyNoteForQuestionnaire:survey];
    
    if (itemConfig != nil){
        [cell.lblNote setBackgroundColor:itemConfig.color];
        [cell updateNoteLabelWithText:itemConfig.note];
        //
        [cell.lblNote setHidden:NO];
    }
    
    [cell layoutIfNeeded];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0)
    {
        __block CustomSurvey *selectedSurvey = [questionnaireList objectAtIndex:indexPath.row];
        
        tableView.tag = 1;
        CustomSurveySampleCellTVC *cell = (CustomSurveySampleCellTVC*)[tableView cellForRowAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion: ^(BOOL finished) {
            [self resolveSelectionForSurvey:selectedSurvey];
            tableView.tag = 0;
        }];
    }
}

- (void)resolveSelectionForSurvey:(CustomSurvey*)survey
{
    NSString *message = [survey validateSurveyBeforeStart];
    if (message){
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Atenção" subTitle:message closeButtonTitle:@"OK" duration:0.0];
    }else{
        [self performSegueWithIdentifier:@"SegueToMainCustomSurvey" sender:survey];
    }
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor grayColor];
    [lblTitle setFont:[UIFont fontWithName:FONT_MYRIAD_PRO_ITALIC size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblTitle.text = @"Buscando questionários disponíveis...";
    
    tvSampleSurveys.backgroundColor = [UIColor whiteColor];
    tvSampleSurveys.tableFooterView = [UIView new];
}

- (void)loadQuestionnairesFromServer
{
    QuestionnaireDataSource *dataSource = [QuestionnaireDataSource new];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });
    
    [dataSource getAvailableQuestionnairesFromServerWithCompletionHandler:^(NSArray<CustomSurvey *> * _Nullable questionnaries, DataSourceResponse * _Nonnull response) {
        
        [self loadLocalSamples];
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        
        if (response.status == DataSourceResponseStatusSuccess){
            
            for (CustomSurvey *q in questionnaries){
                [self.questionnaireList addObject:q];
            }

        }else{
            
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:@"Atenção" subTitle:response.message closeButtonTitle:@"OK" duration:0.0];
            
        }
        
        if (self.questionnaireList.count == 0){
            
            lblTitle.text = @"Nenhum questionário disponível para exibição no momento.";
            
        }else{
            
            lblTitle.text = @"Selecione um questionário para respondê-lo.";
        }
        
        [tvSampleSurveys reloadData];
        
    }];
}

- (void)loadLocalSamples
{
    questionnaireList = [NSMutableArray new];
    
    //Todos os componentes:
    {
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"questionnaire-sample-complete-components" ofType:@"json"]]];
        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"Custom Survey: %@", json);
        
        if (error == nil){
            if ([json isKindOfClass:[NSDictionary class]]){
                NSDictionary *dicResponse = (NSDictionary *)json;
                if ([[dicResponse allKeys] containsObject:@"custom_survey"]) {
                    CustomSurvey *survey = [CustomSurvey createObjectFromDictionary:[dicResponse valueForKey:@"custom_survey"]];
                    //
                    [questionnaireList addObject:survey];
                    
                }
            }
        }
    }
    
//    {
//        CustomSurvey *survey = [CustomSurvey new];
//        survey.surveyID = 1;
//        survey.name = @"📗 Todos Componentes";
//        survey.presentation = @"Apresentação de todos os componentes suportados pelo questionário.\nModo FULLPAGE.";
//        survey.formType = SurveyFormTypeFullPage;
//        //
//        [questionnaireList addObject:survey];
//    }
//
//    {
//        CustomSurvey *survey = [CustomSurvey new];
//        survey.surveyID = 2;
//        survey.name = @"📘 Pesquisa de Opinião";
//        survey.presentation = @"Exemplo de pesquisa com tempo máximo para conclusão.\nModo FULLPAGE.";
//        survey.formType = SurveyFormTypeFullPage;
//        //
//        [questionnaireList addObject:survey];
//    }
//
//    {
//        CustomSurvey *survey = [CustomSurvey new];
//        survey.surveyID = 3;
//        survey.name = @"📙 Visita Técnica";
//        survey.presentation = @"Questões agrupadas por assunto. Útil para registro de andamento/conclusão de eventos.\nModo GROUPS.";
//        survey.formType = SurveyFormTypeGroups;
//        //
//        [questionnaireList addObject:survey];
//    }
//
//    {
//        CustomSurvey *survey = [CustomSurvey new];
//        survey.surveyID = 4;
//        survey.name = @"📕 Teste de Conhecimento";
//        survey.presentation = @"Apresentação de um questionário dividido em estágios, permitindo não apenas separação de assuntos mas também nível de complexidade.\nModo STAGES.";
//        survey.formType = SurveyFormTypeStages;
//        //
//        [questionnaireList addObject:survey];
//    }
    
}

- (CustomSurveyAvailableItemNote*)verifyNoteForQuestionnaire:(CustomSurvey*)currentSurvey
{
    CustomSurveyAvailableItemNote *config = nil;
    
    if (currentSurvey.surveyID == 0){
        
        //DEMONSTRAÇÃO
        config = [CustomSurveyAvailableItemNote new];
        config.note = @"Demonstração";
        config.color = [UIColor orangeColor];
        //
        return config;
        
    }
    
    if (config == nil){
        if (currentSurvey.availableFromDate){
            
            NSDate *d1 = [NSDate date];
            NSDate *d2 = [ToolBox dateHelper_DateFromString:currentSurvey.availableFromDate withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA];
            if ([ToolBox dateHelper_CompareDate:d1 withDate:d2 usingRule:tbComparationRule_Less]){
                
                //FUTURO!
                config = [CustomSurveyAvailableItemNote new];
                config.note = [NSString stringWithFormat:@"Disponível em: %@", [ToolBox dateHelper_StringFromDate:d2 withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL]];
                config.color = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
                //
                return config;
                
            }else{
                
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:d2 toDate:d1 options:0];
                
                if (labs(components.day) <= 7){
                    
                    //NOVO!
                    config = [CustomSurveyAvailableItemNote new];
                    config.note = @"Novo!";
                    config.color = [UIColor blueColor];
                    //
                    return config;
                }
                
            }
        }
    }
    
    
    if (config == nil){
        if (currentSurvey.validUntilDate){
            
            NSDate *d1 = [NSDate date];
            NSDate *d2 = [ToolBox dateHelper_DateFromString:currentSurvey.validUntilDate withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA];
            
            if ([ToolBox dateHelper_CompareDate:d1 withDate:d2 usingRule:tbComparationRule_LessOrEqual]){
                
                NSDate *startDate = [NSDate date];
                NSDate *endDate = [ToolBox dateHelper_DateFromString:currentSurvey.validUntilDate withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA];
                
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];
                
                if (labs(components.day) <= 7){
                    
                    //DISPONÍVEL ATÉ...
                    config = [CustomSurveyAvailableItemNote new];
                    config.note = [NSString stringWithFormat:@"Disponível até: %@", [ToolBox dateHelper_StringFromDate:d2 withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL]];
                    config.color = [UIColor redColor];
                    //
                    return config;
                }
                
            }else{
                
                //EXPIRADO!
                config = [CustomSurveyAvailableItemNote new];
                config.note = @"Expirado!";
                config.color = [UIColor blackColor];
                //
                return config;
                
            }
            
        }
    }
    
    return config;
    
}


#pragma mark - UTILS (General Use)

@end
