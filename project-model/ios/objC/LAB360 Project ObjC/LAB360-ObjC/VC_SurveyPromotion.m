//
//  VC_SurveyPromotion.m
//  ShoppingBH
//
//  Created by Erico GT on 01/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_SurveyPromotion.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_SurveyPromotion()

//Layout
@property (nonatomic, weak) IBOutlet UITableView *tvSurvey;

//Data
@property (nonatomic, strong) UIImage *uncheckedImage;
@property (nonatomic, strong) UIImage *checkedImage;
//
@property (nonatomic, strong) LocationService *location;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_SurveyPromotion
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize uncheckedImage, checkedImage, currentPromotion, location;
@synthesize tvSurvey;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //Button Profile Pic
    //self.navigationItem.rightBarButtonItem = [AppD createProfileButton];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_SURVEY_PROMOTION", @"");
    
    tvSurvey.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    checkedImage = [[UIImage imageNamed:@"icon-ratio-checked"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    uncheckedImage = [[UIImage imageNamed:@"icon-ratio-unchecked"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    location = [LocationService initAndStartMonitoringLocation];
    
    //Ordenando as respostas:
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    currentPromotion.question.alternativesList = [[NSMutableArray alloc] initWithArray:[currentPromotion.question.alternativesList sortedArrayUsingDescriptors:sortDescriptors]];
    //Selecionando a correta:
    for (int i=0; i<currentPromotion.question.alternativesList.count; i++){
        PromotionSurveyAnswer *answer = [currentPromotion.question.alternativesList objectAtIndex:i];
        if (answer.isSelected){
            currentPromotion.question.selectedAnswer = i;
            break;
        }
    }
    
    [tvSurvey reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [location stopMonitoring];
    location = nil;
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionSend:(id)sender
{
    bool correct = false;
    
    for (int i=0; i<currentPromotion.question.alternativesList.count; i++){
        PromotionSurveyAnswer *answer = [currentPromotion.question.alternativesList objectAtIndex:i];
        if (answer.isSelected && i == currentPromotion.question.selectedAnswer){
            //resposta certa selecionada
            correct = true;
            break;
        }
    }
    
    if (correct){
        [self registerUserInPromotion];
    }else{
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_SURVEY_ANSWER", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_ERROR_SURVEY_ANSWER", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //quantidade de perguntas...
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //quantidade de respostas...
    if (currentPromotion.question.alternativesList.count == 0){
        return 0;
    }else{
        return (currentPromotion.question.alternativesList.count + 1); //respostas + botão finalizar
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < (currentPromotion.question.alternativesList.count)){
        
        //Linha de resposta:
        static NSString *CellIdentifierGroup1 = @"SurveyOptionCell";
        
        TVC_SurveyOptionPromotion *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierGroup1];
        
        if(cell == nil)
        {
            cell = [[TVC_SurveyOptionPromotion alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierGroup1];
        }
        
        [cell updateLayout];
        //
        PromotionSurveyAnswer *answer = [currentPromotion.question.alternativesList objectAtIndex:indexPath.row];
        
        cell.lblTitleOption.text = answer.answer;
        
        if (currentPromotion.question.selectedAnswer == indexPath.row){
            cell.imvRadioOption.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
            cell.imvRadioOption.image = checkedImage;
        }else{
            cell.imvRadioOption.tintColor = [UIColor darkGrayColor];
            cell.imvRadioOption.image = uncheckedImage;
        }
        
        return cell;
        
    }else{
        
        //Última linha:
        static NSString *CellIdentifierGroup2 = @"SurveySendButtonCell";
        
        TVC_SimpleButton *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierGroup2];
        
        if(cell == nil)
        {
            cell = [[TVC_SimpleButton alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierGroup2];
        }
        
        [cell updateLayoutWithButtonTitle:NSLocalizedString(@"BUTTON_TITLE_SEND_ANSWER", @"")];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < (currentPromotion.question.alternativesList.count)){
        return 50.0;
    }else{
        return 80.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UIFont *font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
    CGRect textRect = [currentPromotion.question.question boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    //
    return (textRect.size.height + 40.0);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIFont *font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION];
    CGRect textRect = [currentPromotion.question.question boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    //
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, (textRect.size.height + 40.0))];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.view.frame.size.width - 20.0, headerView.frame.size.height)];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [label setFont:font];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setNumberOfLines:0];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.text = currentPromotion.question.question;
    //
    [headerView addSubview:label];
    //
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentPromotion.question.selectedAnswer = indexPath.row;
    //
    [tvSurvey reloadData];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    //Background
    self.view.backgroundColor = [UIColor whiteColor];
    tvSurvey.backgroundColor = nil;
}

- (void)registerUserInPromotion
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        NSMutableDictionary *parameters = [NSMutableDictionary new]; //[[NSMutableDictionary alloc] initWithDictionary:[AppD.loggedUser dictionaryJSON]];
        //INFO: Os dados do usuário são pegos manualmente pois o dicionário possui quantidade de campos e nomes particulares parea esta requisição.
        [parameters setValue:[self clearMask:AppD.loggedUser.CPF] forKey:@"cpf"];
        [parameters setValue:AppD.loggedUser.RG forKey:@"rg"];
        [parameters setValue:AppD.loggedUser.name forKey:@"name"];
        [parameters setValue:(AppD.loggedUser.birthdate != nil ? [ToolBox dateHelper_StringFromDate:AppD.loggedUser.birthdate withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL] : @"") forKey:@"birthdate"];
        [parameters setValue:AppD.loggedUser.phoneDDD forKey:@"ddd_phone"];
        [parameters setValue:AppD.loggedUser.phone forKey:@"phone"];
        [parameters setValue:AppD.loggedUser.mobilePhoneDDD forKey:@"ddd_cell_phone"];
        [parameters setValue:AppD.loggedUser.mobilePhone forKey:@"cell_phone"];
        [parameters setValue:AppD.loggedUser.zipCode forKey:@"zipcode"];
        [parameters setValue:AppD.loggedUser.address forKey:@"address"];
        [parameters setValue:AppD.loggedUser.addressNumber forKey:@"number"];
        [parameters setValue:AppD.loggedUser.complement forKey:@"complement"];
        [parameters setValue:AppD.loggedUser.district forKey:@"district"];
        [parameters setValue:AppD.loggedUser.city forKey:@"city"];
        [parameters setValue:AppD.loggedUser.state forKey:@"state"];
        //
        [parameters setValue:@(currentPromotion.promotionID) forKey:@"promotion_id"];
        CLLocationDegrees latitude = self.location.latitude;
        CLLocationDegrees longitude = self.location.longitude;
        [parameters setValue:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
        [parameters setValue:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
        NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
        [parameters setValue:appID forKey:@"app_id"];
        
        [connectionManager postRegisterUserInPromotionUsingParameters:parameters withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (!error) {
                
                if (response) {
                    
                    if ([[response allKeys] containsObject:@"status"]) {
                        
                        NSString *status = [response valueForKey:@"status"];
                        
                        if ([status isEqualToString:@"ERROR"]) {
                            
                            if ([[response allKeys] containsObject:@"error"]) {
                                
                                NSDictionary *eResult = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:[response valueForKey:@"error"] withString:@""];
                                
                                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:[eResult valueForKey:@"description"] closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                            
                            } else {
                                
                                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_REGISTER_PROMOTION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                            }
                            
                        } else {
                            
                            if ([[response allKeys] containsObject:@"shop_promotion_user"]){
                                
                                NSDictionary *dResult = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:[response valueForKey:@"shop_promotion_user"] withString:@""];
                                
                                long shoP = 0;
                                
                                @try {
                                    shoP = [[dResult valueForKey:@"id"] longValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception: %@", [exception reason]);
                                }
                                
                                if (shoP != 0) {
                                    
                                    //Success
                                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                    [alert addButton:NSLocalizedString(@"BUTTON_TITLE_COUPON_REGISTER", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
                                        //Instanciando a nova view destino
                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Invoice" bundle:[NSBundle mainBundle]];
                                        VC_InvoiceScan *vcInvoice = [storyboard instantiateViewControllerWithIdentifier:@"VC_InvoiceScan"];
                                        [vcInvoice awakeFromNib];
                                        //
                                        UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
                                        topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                                        topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
                                        //
                                        //Abrindo a tela
                                        [AppD.rootViewController.navigationController pushViewController:vcInvoice animated:YES];
                                        
                                        //Readaptando a lista de controllers:
                                        NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
                                        NSMutableArray *listaF = [NSMutableArray new];
                                        [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
                                        [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
                                        [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
                                        [listaF addObject:vcInvoice];
                                        
                                        //Carregando dados
                                        AppD.rootViewController.navigationController.viewControllers = listaF;
                                    }];
                                    //
                                    [alert addButton:NSLocalizedString(@"BUTTON_TITLE_RETURN_TO_START", @"") withType:SCLAlertButtonType_Neutral actionBlock:^{
                                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                                    }];
                                    
                                    [alert showSuccess:self title:NSLocalizedString(@"ALERT_TITLE_SUCCESS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SUCCESS_SURVEY_REGISTER", @"") closeButtonTitle:nil duration:0.0];
                                    
                                } else {
                                    
                                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_REGISTER_PROMOTION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                                }
                            } else {
                                
                                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_REGISTER_PROMOTION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                            }
                        }
                    }else{
                        //status
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_REGISTER_PROMOTION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                } else {
                    //response
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_REGISTER_PROMOTION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }
            } else {
                //error
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_REGISTER_PROMOTION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
        }];
    } else {
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        //
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
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
