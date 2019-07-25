//
//  VC_EventSubscribe.m
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 17/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_EventSubscribe.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_EventSubscribe()

@property (nonatomic, weak) IBOutlet UIImageView *imgBackground;
@property (nonatomic, weak) IBOutlet UITableView *tbvSubscribe;
@property (nonatomic, weak) UITextField *activeTextField;

//objetos
@property (nonatomic, strong) User *eventUser;
@property (nonatomic, strong) SubscribedUser *subs;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_EventSubscribe
{
#pragma mark - • I_VARS
    
    
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES

@synthesize imgBackground, tbvSubscribe;
@synthesize activeTextField;
@synthesize eventUser, event, subs;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.rightBarButtonItem = [AppD createProfileButton];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_SUBSCRIBE", @"");
    //
    eventUser = [AppD.loggedUser copyObject];
    subs = [self fillObjectUser];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self atualizaLayout];
    [tbvSubscribe reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[Answers logCustomEventWithName:@"Acesso a tela Inscrição Eventos" customAttributes:@{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierTextField = @"cellTextField";
    static NSString *CellIdentifierSave = @"cellSaveButton";
    
    //Célula de rodapé(Save Button)
    if (indexPath.row == 17){
        
        
        TVC_AccountFooter *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSave];
        
        if(cell == nil)
        {
            cell = [[TVC_AccountFooter alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSave];
        }
        [cell layoutIfNeeded];
        [cell updateLayout];
        
        [cell.btnSave addTarget:self action:@selector(clickSave:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    //Célula do corpo(TextFields)
    else
    {
        TVC_AccountBody *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTextField];
        
        if(cell == nil)
        {
            cell = [[TVC_AccountBody alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierTextField];
        }
        
        cell.txtBody.delegate = self;
        [cell.txtBody setAutocorrectionType:UITextAutocorrectionTypeNo];
        [cell.txtBody setSpellCheckingType:UITextSpellCheckingTypeNo];
        
        
        //NOME
        if(indexPath.row == 0)
        {
            cell.txtBody.tag = 0;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_NAME", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.name;
        }
        //SOBRENOME
        else if(indexPath.row == 1)
        {
            cell.txtBody.tag = 1;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_LAST_NAME", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.lastName;
        }
        //CPF
        else if(indexPath.row == 2)
        {
            cell.txtBody.tag = 2;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_CPF", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-doc-info"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeNumberPad];
            cell.txtBody.text = subs.CPF;
            cell.txtBody.inputAccessoryView = [AppD createAcessoryViewWithTarget:cell.txtBody andSelector:@selector(resignFirstResponder)];
        }
        //TELEFONE
        else if(indexPath.row == 3)
        {
            cell.txtBody.tag = 3;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_PHONE", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-phone"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeNumberPad];
            cell.txtBody.text = subs.phone;
            cell.txtBody.inputAccessoryView = [AppD createAcessoryViewWithTarget:cell.txtBody andSelector:@selector(resignFirstResponder)];
        }
        //EMAIL
        else if(indexPath.row == 4)
        {
            cell.txtBody.tag = 4;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_EMAIL", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-email"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeEmailAddress];
            cell.txtBody.text = subs.email;
        }
        //EMPRESA
        else if(indexPath.row == 5)
        {
            cell.txtBody.tag = 5;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_COMPANY", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-enterprise"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.company;
        }
        //CNPJ
        else if(indexPath.row == 6)
        {
            cell.txtBody.tag = 6;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_CNPJ", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-enterprise"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeNumberPad];
            cell.txtBody.text = subs.CNPJ;
            cell.txtBody.inputAccessoryView = [AppD createAcessoryViewWithTarget:cell.txtBody andSelector:@selector(resignFirstResponder)];
        }
        //CARGO
        else if(indexPath.row == 7)
        {
            cell.txtBody.tag = 7;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_ROLE", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-enterprise"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.role;
        }
        //HOMEPAGE
        else if(indexPath.row == 8)
        {
            cell.txtBody.tag = 8;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_HOMEPAGE", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-enterprise"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.homePage;
        }

        //ENDERECO
        else if(indexPath.row == 9)
        {
            cell.txtBody.tag = 9;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_ADDRESS", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-place"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.address;
        }
        //NUMERO
        else if(indexPath.row == 10)
        {
            cell.txtBody.tag = 10;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_NUMBER", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-place"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.number;
            
        }
        //COMPLEMENTO
        else if(indexPath.row == 11)
        {
            cell.txtBody.tag = 11;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_ADJUNCT", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-place"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.adjunct;
        }
        //CIDADE
        else if(indexPath.row == 12)
        {
            cell.txtBody.tag = 12;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_CITY", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-place"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.city;
        }
        //CEP
        else if(indexPath.row == 13)
        {
            cell.txtBody.tag = 13;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_ZIPCODE", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-place"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeNumberPad];
            cell.txtBody.text = subs.zipCode;
            cell.txtBody.inputAccessoryView = [AppD createAcessoryViewWithTarget:cell.txtBody andSelector:@selector(resignFirstResponder)];
        }
        //ESTADO
        else if(indexPath.row == 14)
        {
            cell.txtBody.tag = 14;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_STATE", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-place"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.state;
        }
        //PAIS
        else if(indexPath.row == 15)
        {
            cell.txtBody.tag = 15;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_COUNTRY", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-place"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.country;
        }
        //OBSERVACAO
        else if(indexPath.row == 16)
        {
            cell.txtBody.tag = 16;
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_NOTE", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = subs.note;
        }
        
        [cell updateLayout];
        [cell layoutIfNeeded];
        return cell;
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 18;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 17)
    {
        return 80;
    }
    else
    {
        return 50;
    }
}


#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)clickSave:(id)sender
{
   if([subs.name isEqualToString:@""] || [subs.lastName isEqualToString:@""] || [subs.CPF isEqualToString:@""] || [subs.email isEqualToString:@""] || [subs.company isEqualToString:@""] || [subs.CNPJ isEqualToString:@""] || [subs.address isEqualToString:@""] || [subs.number isEqualToString:@""] || [subs.phone isEqualToString:@""] || [subs.role isEqualToString:@""] || [subs.homePage isEqualToString:@""] || [subs.city isEqualToString:@""] || [subs.state isEqualToString:@""] || [subs.zipCode isEqualToString:@""] || [subs.country isEqualToString:@""])
   {
       SCLAlertView *alert = [AppD createDefaultAlert];
       [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_EMPTY_FIELDS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMPTY_FIELDS_GENERAL", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
   }
    else if([ToolBox validationHelper_EmailChecker:subs.email] == tbValidationResult_Disapproved)
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMAIL_INVALID", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else if([ToolBox validationHelper_ValidateCPF:subs.CPF] == tbValidationResult_Disapproved)
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CPF_INVALID", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else if([ToolBox validationHelper_validateCNPJ:subs.CNPJ] == false)
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CNPJ_INVALID", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else
    {
        
        subs.eventID = event.eventID;
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CONFIRM", @"") withType:SCLAlertButtonType_Question actionBlock:^{
            
            ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
            
            if ([connectionManager isConnectionActive])
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
                });
                
                connectionManager.delegate = self;
                
                NSDictionary *dicParameters = [subs dictionaryJSON];
                
                [connectionManager subscribeToEventUsingParameters:dicParameters withCompletionHandler:^(NSDictionary *response, NSError *error) {
                    
                    if (error){
                        
                        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                        
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SUBSCRIBE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                    else
                    {
                       // id idInscricao = [response valueForKey:@"Id"];
                        
                        NSMutableDictionary* dicData = [[NSMutableDictionary alloc]init];
                        [dicData setValue:@(event.eventID) forKey:@"event_id"];
                        [dicData setValue:@(AppD.loggedUser.userID) forKey:@"app_user_id"];
                        
                        if ([connectionManager isConnectionActive])
                        {
                            
                            [connectionManager sendEventInfoToServerForMasterEventID:AppD.masterEventID withParameters:dicData withCompletionHandler:^(NSDictionary *response, NSError *error) {
                                
                                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                                
                                if (error){
                                    
                                    SCLAlertView *alert = [AppD createDefaultAlert];
                                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SUBSCRIBE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                                }
                                else
                                {
                                    SCLAlertView *alert = [AppD createDefaultAlert];
                                    [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") actionBlock:^{
                                        
                                        event.userRegistrationStatus = eUserRegistrationStatus_Subscribed;
                                        [self.navigationController popViewControllerAnimated:true];

                                    }];
                                    
                                    [alert showSuccess:self title:NSLocalizedString(@"ALERT_TITLE_SUBSCRIBE_SUCCESS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SUBSCRIBE_SUCCESS", @"") closeButtonTitle:nil duration:0.0];
                                    
                                }
                            }];
                        }
                        
                        else
                        {
                            SCLAlertView *alert = [AppD createDefaultAlert];
                            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                        }
                    
                        
                    }
                }];
            }
            else
            {
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
            
        }];
        
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        
        [alert showQuestion:self title:NSLocalizedString(@"ALERT_TITLE_CONFIRM", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EVENT_CONFIRM", @"") closeButtonTitle:nil duration:0.0];
    
    }
    
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • TEXT FIELD DELEGATE

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    
    
    if(textField.tag == 0)
    {
        subs.name = textField.text;
    }
    else if(textField.tag == 1)
    {
        subs.lastName = textField.text;
    }
    else if(textField.tag == 2)
    {
        subs.CPF = textField.text;
    }
    else if(textField.tag == 3)
    {
        subs.phone = textField.text;
    }
    else if(textField.tag == 4)
    {
        subs.email = textField.text;
    }
    else if(textField.tag == 5)
    {
        subs.company = textField.text;
    }
    else if(textField.tag == 6)
    {
        subs.CNPJ = textField.text;
    }
    else if(textField.tag == 7)
    {
        subs.role = textField.text;
    }
    else if(textField.tag == 8)
    {
        subs.homePage = textField.text;
    }
    else if(textField.tag == 9)
    {
        subs.address = textField.text;
    }
    else if(textField.tag == 10)
    {
        subs.number = textField.text;
    }
    else if(textField.tag == 11)
    {
        subs.adjunct = textField.text;
    }
    else if(textField.tag == 12)
    {
        subs.city = textField.text;
    }
    else if(textField.tag == 13)
    {
        subs.zipCode = textField.text;
    }
    else if(textField.tag == 14)
    {
        subs.state = textField.text;
    }
    else if(textField.tag == 15)
    {
        subs.country = textField.text;
    }
    else if(textField.tag == 16)
    {
        subs.note = textField.text;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if(textField.tag == 2)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 11;
    }
    else if(textField.tag == 6)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 14;
    }
    else if(textField.tag == 13)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 8;
    }
    else
    {
        return YES;
    }
    
}



#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    tbvSubscribe.contentInset = contentInsets;
    tbvSubscribe.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
        [tbvSubscribe scrollRectToVisible:activeTextField.superview.superview.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    tbvSubscribe.contentInset = contentInsets;
    tbvSubscribe.scrollIndicatorInsets = contentInsets;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

-(void) atualizaLayout
{
    //
    self.view.backgroundColor = [UIColor blackColor];
    //
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    //Background and Icons
    imgBackground.backgroundColor = [UIColor clearColor];
    imgBackground.image = [AppD createDefaultBackgroundImage];
    //
    tbvSubscribe.backgroundColor = [UIColor clearColor];
    
}

-(SubscribedUser*) fillObjectUser
{
    SubscribedUser *sub = [[SubscribedUser alloc] init];
    
    
    sub.name = AppD.loggedUser.name;
    sub.CPF = AppD.loggedUser.CPF;
    sub.phone = AppD.loggedUser.phone;
    sub.email = AppD.loggedUser.email;
    sub.company = AppD.loggedUser.company;
    sub.CNPJ = AppD.loggedUser.CNPJ;
    sub.role = AppD.loggedUser.jobRoleDescription;
    sub.address = AppD.loggedUser.address;
    sub.city = AppD.loggedUser.city;
    sub.zipCode = AppD.loggedUser.zipCode;
    sub.state = AppD.loggedUser.state;
    sub.country = AppD.loggedUser.country;

    return sub;
    
}

@end
