 //
//  VC_Login.m
//  AHK-100anos
//
//  Created by Erico GT on 10/5/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_Login.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_Login()

//Components
@property (nonatomic, weak) IBOutlet UIImageView *imvBackground;
@property (nonatomic, weak) IBOutlet UIScrollView *scvMenu;
//
@property (nonatomic, weak) IBOutlet UITextField *txtEmail;
@property (nonatomic, weak) IBOutlet UITextField *txtPassword;
//
@property (nonatomic, weak) IBOutlet UIButton *btnLogin;
@property (nonatomic, weak) IBOutlet UIButton *btnSignup;
@property (nonatomic, weak) IBOutlet FBSDKLoginButton *btnLoginFacebook; 
@property (nonatomic, weak) IBOutlet UIButton *btnPasswordRecovery;

//Variables (for control)
@property (nonatomic, assign) bool isAnimating;
@property (nonatomic, assign) bool isFirstIntro;
@property (nonatomic, assign) bool emailAvailable;
@property (nonatomic, assign) bool registerAvailable;
@property (nonatomic, assign) bool fromFacebookLogin;
//(support)
@property (nonatomic, weak) UITextField *activeTextField;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, assign) bool isLoaded;
@property (nonatomic, assign) BOOL sessionClosed;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_Login
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
}

#pragma mark - • SYNTESIZES
@synthesize imvBackground, scvMenu, txtEmail, txtPassword, btnLogin, btnSignup, btnLoginFacebook, btnPasswordRecovery;
@synthesize isAnimating, isFirstIntro, emailAvailable, registerAvailable, fromFacebookLogin, activeTextField, profileImage, isLoaded, sessionClosed;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_USER_AUTHENTICATION_TOKEN_INVALID_ALERT object:nil];
}

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //RootViewController for application
	AppD.rootViewController = self;
    isFirstIntro = true;
    
    //btnfacbook
    btnLoginFacebook.delegate = self;
    btnLoginFacebook.readPermissions = @[@"public_profile", @"email"];
    btnLoginFacebook.loginBehavior = FBSDKLoginBehaviorNative; //FBSDKLoginBehaviorWeb;
    
    emailAvailable = false;
    fromFacebookLogin = false;
    isLoaded = false;
	
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //Controle de sessão para o usuário
    sessionClosed = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionUserAuthenticationTokenInvalidAlert:) name:SYSNOT_USER_AUTHENTICATION_TOKEN_INVALID_ALERT object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES];
    
    if (!isLoaded){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageBackground:) name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BACKGROUND object:nil];
        
        [FBSDKAccessToken setCurrentAccessToken:nil];
        self.navigationController.navigationBarHidden = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        //Layout
        [self.view layoutIfNeeded];
        [self setupLayout];
        
        isAnimating = false;
    }
	
    //Caso o usuário já exista (logado) o mesmo é redirecionado automaticamente para o menu principal
    if (AppD.loggedUser.userID != 0)
    {
        if (AppD.appName == nil || [AppD.appName isEqualToString:@""]){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            AppD.appName = [userDefaults valueForKey:PLISTKEY_APP_NAME];
        }
        
        [self performSegueWithIdentifier:@"SegueToHomeMenuFast" sender:self];
    }
    
    profileImage = [UIImage new];
    
    //TODO: Esconder até ter conta no facebook
    //btnLoginFacebook.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //
    if (sessionClosed){
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Sessão Expirada" subTitle:@"A sesssão atual não é mais válida. Ela pode ter sido encerrada por um login efetuado com suas credenciais em outro dispositivo.\n\nPor favor, autentique-se novamente para continuar." closeButtonTitle:@"OK" duration:0.0];
        //
        sessionClosed = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //
    txtEmail.text = @"";
    txtPassword.text = @"";
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [AppD statusBarStyleForViewController:self];
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
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
    
    //TODO: máscara
//    NSString *mask = @"";
//
//    if (textField == txtEmail){
//        mask = @"###.###.###-##";
//    }else if(textField == txtPassword){
//        mask = @"(##)#####-####";
//    }
//    //OBS: Atualizar o método 'clearTextFromMask' com os símbolos utilizados na máscara.
//
//    NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//    bool ignore = false;
//
//    if(range.length == 1 && /* Only do for single deletes */ string.length < range.length && [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound){
//
//        // Something was deleted.  Delete past the previous number
//        NSInteger location = changedString.length-1;
//        if(location > 0)
//        {
//            for(; location > 0; location--)
//            {
//                if(isdigit([changedString characterAtIndex:location]))
//                {
//                    break;
//                }
//            }
//            changedString = [changedString substringToIndex:location];
//        }
//        else{
//            ignore = true;
//        }
//    }
//
//    if (ignore){
//        textField.text = @"";
//    }else{
//        textField.text = [self filteredStringFromString:changedString filter:mask];
//    }
//
//    return NO;
    
    return YES;
    
}


#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)clickLogin:(id)sender
{
    NSString *textEmail = txtEmail.text;
    NSString *textPassword = txtPassword.text;
    
    //textEmail = [self clearTextFromMask:txtEmail.text];
    //textPassword = [self clearTextFromMask:txtPassword.text];
    
    //TODO: login apenas para testes (abreviator power word):
//    if ([textEmail isEqualToString:@"ericogt"]){
//        textEmail = @"erico.gimenes@gmail.com";
//        textPassword = @"asdfasdf";
//    }
	
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    if ([textEmail isEqualToString:@""] || [textPassword isEqualToString:@""])
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_EMPTY_FIELDS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMPTY_FIELDS", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else
    {
        ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
        
        if ([connectionManager isConnectionActive])
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
            });
            
            connectionManager.delegate = self;
            
            [txtEmail resignFirstResponder];
            [txtPassword resignFirstResponder];
            
			NSDictionary * dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:textEmail, AUTHENTICATE_EMAIL_KEY, textPassword, AUTHENTICATE_PASSWORD_KEY, @(AppD.masterEventID), AUTHENTICATE_MASTER_EVENT_ID, nil];
			
            [connectionManager authenticateUserUsingParameters:dicParameters withCompletionHandler:^(NSDictionary *response, NSError *error) {
                
                if (error){
                    
					NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    SCLAlertView *alert = [AppD createDefaultAlert];
					
					NSString *errorMessage = [defaults objectForKey:PLISTKEY_LOGIN_ERROR_MESSAGE];
					if (!errorMessage || [errorMessage isEqualToString:@""])
					{
						[alert showError:self title:NSLocalizedString(@"ALERT_TITLE_AUTHENTICATION_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_AUTHENTICATION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
					}
					else{
						[alert showError:self title:NSLocalizedString(@"ALERT_TITLE_AUTHENTICATION_ERROR", @"") subTitle:[defaults objectForKey:PLISTKEY_LOGIN_ERROR_MESSAGE] closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
					}
					
                }else{
                    
                    //[Answers logLoginWithMethod:@"Sucesso Login" success:@YES customAttributes:@{}];
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setInteger:AppD.masterEventID forKey:PLISTKEY_MASTER_EVENT_ID];

                    [AppD registerLoginForUser:txtEmail.text data:response];
                    
					if (AppD.styleForRole) {
						NSDictionary *appDic = [AppD.styleForRole objectForKey:AppD.loggedUser.role];
						bool canPost = [[appDic objectForKey:CONFIG_KEY_FLAG_POST] boolValue];
						bool canLike = [[appDic objectForKey:CONFIG_KEY_FLAG_LIKE] boolValue];
						bool canComment = [[appDic objectForKey:CONFIG_KEY_FLAG_COMMENT] boolValue];
						bool canShare = [[appDic objectForKey:CONFIG_KEY_FLAG_SHARE] boolValue];
						
						[userDefaults setBool:canPost forKey:CONFIG_KEY_FLAG_POST];
						[userDefaults setBool:canLike forKey:CONFIG_KEY_FLAG_LIKE];
						[userDefaults setBool:canComment forKey:CONFIG_KEY_FLAG_COMMENT];
						[userDefaults setBool:canShare forKey:CONFIG_KEY_FLAG_SHARE];
					}
					
					[userDefaults synchronize];
					
                    [self performSegueWithIdentifier:@"SegueToHomeMenu" sender:self];
                    
                    //PushNotification - Firebase
                    if ([AppD isEnableForRemoteNotifications]){
                        [AppD registerForRemoteNotifications];
                    }
                }
                
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            }];
        }
        else
        {
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }
}

- (IBAction)clickNewAccount:(id)sender
{
    fromFacebookLogin = false;
    
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self performSegueWithIdentifier:@"SegueToUserSignup" sender:self];
}

- (IBAction)clickPasswordRecovery:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    
    UITextField *textField = [alert addTextField:NSLocalizedString(@"PLACEHOLDER_EMAIL", @"")];
    textField.keyboardType = UIKeyboardTypeEmailAddress;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [textField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setSpellCheckingType:UITextSpellCheckingTypeNo];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_SEND", @"") actionBlock:^{
        
        [textField resignFirstResponder];
        
        if (![textField.text isEqualToString:@""]){
            
            if ([ToolBox validationHelper_EmailChecker:textField.text] == tbValidationResult_Approved){
                
                ConnectionManager *connection = [[ConnectionManager alloc] init];
                
                if ([connection isConnectionActive])
                {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
                    });
                    
                    connection.delegate = self;
                    
                    [connection resetUserPassword:textField.text withCompletionHandler:^(NSDictionary *response, NSError *error) {
                        
                        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                        
                        if (error){
                            
                            SCLAlertView *alert = [AppD createDefaultAlert];
                            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PASSWORD_RESET_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                            
                        }else{
                            
                            if([response valueForKey:@"errors"] != nil)
                            {
                                
                                SCLAlertView *alert = [AppD createDefaultAlert];
                                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PASSWORD_RESET_NOT_FOUND", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                                
                            }
                            else
                            {
                                SCLAlertView *alert = [AppD createDefaultAlert];
                                [alert showSuccess:self title:NSLocalizedString(@"ALERT_TITLE_SUCCESS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PASSWORD_RESET_SUCCESS", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                            }
                            
                            //Abaixo segue o padrão AlbumShow para referencia:
                            /*
                            NSString *result = [response valueForKey:@"status"];
                            if ([result isEqualToString:@"SUCCESS"]){
                                //sucesso
                                SCLAlertView *alert = [AppD createDefaultAlert];
                                [alert showSuccess:self title:NSLocalizedString(@"ALERT_TITLE_SUCCESS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PASSWORD_RESET_SUCCESS", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                            }else{
                                //erro
                                NSDictionary *dicError = [response valueForKey:@"error"];
                                if (dicError){
                                    SCLAlertView *alert = [AppD createDefaultAlert];
                                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:[dicError valueForKey:@"description"] closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                                }else{
                                    SCLAlertView *alert = [AppD createDefaultAlert];
                                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PASSWORD_RESET_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                                }
                            }
                             */
                            
                        }
                    }];
                    
                }else{
                    
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }
                
            }else{
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showWarning:self title:NSLocalizedString(@"ALERT_TITLE_INCORRECT_EMAIL_FORMAT", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_INCORRECT_EMAIL_FORMAT", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
        }
    }];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
    
    [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_FORGOT_PASSWORD", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_FORGOT_PASSWORD", @"") closeButtonTitle:nil duration:0.0];
}

- (void)actionUserAuthenticationTokenInvalidAlert:(NSNotification*)notification
{
    //Indicador para saber se precisa mostrar mensagem para o usuário
    sessionClosed = YES;
    //
    [AppD removeForRemoteNotifications];
    [AppD registerLogoutForCurrentUser];
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
    [AppD.rootViewController.navigationController popToViewController:AppD.rootViewController animated:YES];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    if (@available(iOS 11.0, *)) {
        contentInsets.bottom += self.view.safeAreaInsets.bottom;
    }
    scvMenu.contentInset = contentInsets;
    scvMenu.scrollIndicatorInsets = contentInsets;
    //
    [scvMenu scrollRectToVisible:activeTextField.frame animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    scvMenu.contentInset = UIEdgeInsetsZero;
    scvMenu.scrollIndicatorInsets = UIEdgeInsetsZero;
}


-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    fromFacebookLogin = true;
    NSString *idFacebook = result.token.userID;
    NSString *tokenFacebook = result.token.tokenString;

    //verifica sucesso da requisicao facebook login
    if([FBSDKAccessToken currentAccessToken] && !result.isCancelled)
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        //requisita informacoes do usuario logado
        NSMutableDictionary *dataDicFace = [[NSMutableDictionary alloc] init];
        [dataDicFace setValue:@"first_name, last_name, picture.width(200).height(200), email" forKey:@"fields"];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:dataDicFace] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if(error)
            {
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                NSLog(@"%@", error);
            }
            else
            {
                NSString *name = result[@"first_name"];
                NSString *lastName = result[@"last_name"];
                NSString *email = result[@"email"];
                
                NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
                [dicData setValue:idFacebook forKey:@"fb_id"];
                [dicData setValue:tokenFacebook forKey:@"fb_access_token"];
                [dicData setValue:email forKey:@"email"];
                [dicData setValue:[NSString stringWithFormat:@"%@ %@", name, lastName] forKey:@"first_name"];
                [dicData setValue:@(true) forKey:@"create"];
                [dicData setValue:@(AppD.masterEventID) forKey:@"master_event_id"];
                
                //User picture [ericogt: o link pra imagem do usuário não era passada para o servidor antes (pois o mesmo pode pegar pelo token)]
                NSString *urlP = @"";
                @try {
                    urlP = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                } @catch (NSException *exception) {
                    NSLog(@"Facebook > User Picture > Get URL Error: %@", [exception reason]);
                } @finally {
                    [dicData setValue:urlP forKey:@"profile_image"];
                }
                
                /*
                picture =     {
                    data =         {
                        height = 200;
                        "is_silhouette" = 0;
                        url = "https://scontent.xx.fbcdn.net/v/t1.0-1/p200x200/13938418_100461793769269_3220144461207207949_n.jpg?oh=e91c0d3d4c375349298a192a92ba93bf&oe=5ABA130E";
                        width = 200;
                    };
                };
                 */
                
                ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
                
                if ([connectionManager isConnectionActive])
                { 
                    connectionManager.delegate = self;
                    
                    [connectionManager authenticateUserByFacebookWithParameters:dicData withCompletionHandler:^(NSDictionary *response, NSError *error) {
                        
                        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                        
                        if (error){
                            
                            [FBSDKAccessToken setCurrentAccessToken:nil];
                            [txtEmail resignFirstResponder];
                            [txtPassword resignFirstResponder];
                            
                            SCLAlertView *alert = [AppD createDefaultAlert];
                            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_AUTHENTICATION_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_AUTHENTICATION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                            
                        }else{
                            
                            //[Answers logLoginWithMethod:@"Sucesso Login Facebook" success:@YES customAttributes:@{}];
                            
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            [userDefaults setInteger:AppD.masterEventID forKey:PLISTKEY_MASTER_EVENT_ID];
                            [userDefaults synchronize];
                            
                            NSMutableDictionary *responseServer = [[NSMutableDictionary alloc] initWithDictionary:[ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:response withString:@""]];
                            if (![urlP isEqualToString:@""] && [[responseServer valueForKey:@"profile_image"] isEqualToString:@""]){
                                [responseServer setValue:urlP forKey:@"profile_image"];
                            }
                            
                            [AppD registerLoginForUser:email data:responseServer];
                            
                            //TODO: o servidor precisa habilitar o mesmo tipo de retorno do criar/login normal
                            
                            if (AppD.styleForRole) {
                                NSDictionary *appDic = [AppD.styleForRole objectForKey:AppD.loggedUser.role];
                                bool canPost = [[appDic objectForKey:CONFIG_KEY_FLAG_POST] boolValue];
                                bool canLike = [[appDic objectForKey:CONFIG_KEY_FLAG_LIKE] boolValue];
                                bool canComment = [[appDic objectForKey:CONFIG_KEY_FLAG_COMMENT] boolValue];
                                bool canShare = [[appDic objectForKey:CONFIG_KEY_FLAG_SHARE] boolValue];
                                
                                [userDefaults setBool:canPost forKey:CONFIG_KEY_FLAG_POST];
                                [userDefaults setBool:canLike forKey:CONFIG_KEY_FLAG_LIKE];
                                [userDefaults setBool:canComment forKey:CONFIG_KEY_FLAG_COMMENT];
                                [userDefaults setBool:canShare forKey:CONFIG_KEY_FLAG_SHARE];
                            }
                            
                            [userDefaults synchronize];
                             
                            
                            //PushNotification - Firebase
                            if ([AppD isEnableForRemoteNotifications]){
                                [AppD registerForRemoteNotifications];
                            }
                            
                            [self performSegueWithIdentifier:@"SegueToHomeMenu" sender:self];
    
                        }
                    }];
                }
                else
                {
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    //
                    [FBSDKAccessToken setCurrentAccessToken:nil];
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }
            }
        }];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"Logout");
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)updateImageBackground:(NSNotification*)notification
{
    imvBackground.image = [AppD createDefaultBackgroundImage];
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BACKGROUND object:nil];
    
    [AppD.styleManager.baseLayoutManager saveConfiguration];
}

- (void)updateImageLogo:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_LOGO object:nil];
    //
    [AppD.styleManager.baseLayoutManager saveConfiguration];
}

- (void)updateImageBanner:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BANNER object:nil];
    //
    [AppD.styleManager.baseLayoutManager saveConfiguration];
}

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Navigation Controller (Transparente)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    //Background
    imvBackground.backgroundColor = [UIColor clearColor];
    imvBackground.image = [AppD createDefaultBackgroundImage];
    //
    scvMenu.backgroundColor = nil;
    
    //Buttons
    btnLoginFacebook.backgroundColor = [UIColor clearColor];
    btnLoginFacebook.backgroundColor = [UIColor clearColor];
    btnLoginFacebook.exclusiveTouch = YES;
    
    btnLogin.backgroundColor = [UIColor clearColor];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnLogin setTitle:NSLocalizedString(@"BUTTON_TITLE_LOGIN", @"") forState:UIControlStateNormal];
    [btnLogin setExclusiveTouch:YES];
    [btnLogin setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnLogin.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnLogin.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    registerAvailable = [userDefaults valueForKey:PLISTKEY_SHOW_REGISTER_BUTTON];
    if (registerAvailable) {
        btnSignup.hidden = NO;
        btnSignup.backgroundColor = [UIColor clearColor];
        [btnSignup setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        btnSignup.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
        [btnSignup setTitle:NSLocalizedString(@"BUTTON_TITLE_ACCOUNT", @"") forState:UIControlStateNormal];
        [btnSignup setExclusiveTouch:YES];
        [btnSignup setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnLogin.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    }else{
        btnSignup.hidden = YES;
    }

    btnPasswordRecovery.backgroundColor = [UIColor clearColor];
    [btnPasswordRecovery setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPasswordRecovery.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS];
    [btnPasswordRecovery setTitle:NSLocalizedString(@"BUTTON_TITLE_PASSWORD_RECOVERY", @"") forState:UIControlStateNormal];
    [btnPasswordRecovery setExclusiveTouch:YES];
    
    //Text Fields
    [txtEmail setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [txtPassword setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
	
	txtEmail.placeholder = NSLocalizedString(@"PLACEHOLDER_EMAIL", @"");
	txtPassword.placeholder = NSLocalizedString(@"PLACEHOLDER_PASSWORD", @"");

    //Ícones TextFields
    UIImageView *ivLoginUser = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    UIImageView *ivLoginLock = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    ivLoginUser.tintColor = [UIColor grayColor];
    ivLoginLock.tintColor = [UIColor grayColor];
    //
    ivLoginUser.image = [[UIImage imageNamed:@"icon-email"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ivLoginLock.image = [[UIImage imageNamed:@"icon-password"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [ivLoginUser setContentMode:UIViewContentModeScaleAspectFit];
    [ivLoginLock setContentMode:UIViewContentModeScaleAspectFit];
    //
    [txtEmail setLeftViewMode:UITextFieldViewModeAlways];
    [txtPassword setLeftViewMode:UITextFieldViewModeAlways];
    //
    txtEmail.leftView = ivLoginUser;
    txtPassword.leftView = ivLoginLock;
    
    isLoaded = true;

}

#pragma mark - Auxiliar para máscara:

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

-(UIView*)createAcessoryViewWithTarget:(UIView*)target andSelector:(SEL)selector
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    UIButton *btnApply = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 40)];
    btnApply.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnApply addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btnApply setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnApply.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [btnApply setTitle:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") forState:UIControlStateNormal];
    
    [view addSubview:btnApply];
    
    return view;
}

- (NSString*)clearTextFromMask:(NSString*)text
{
    NSString *clearT = [text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    clearT = [clearT stringByReplacingOccurrencesOfString:@")" withString:@""];
    clearT = [clearT stringByReplacingOccurrencesOfString:@"." withString:@""];
    clearT = [clearT stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return clearT;
    
}
@end
