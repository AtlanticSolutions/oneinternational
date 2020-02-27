//
//  VC_SignUp.m
//  AHK-100anos
//
//  Created by Lucas Correia on 06/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//


#pragma mark - • HEADER IMPORT
#import "VC_SignUp.h"
#import "VC_Configurations.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_SignUp()

//Components
@property (nonatomic, weak) IBOutlet UILabel *lbName;
@property (nonatomic, weak) IBOutlet UILabel *lbLastName;
@property (nonatomic, weak) IBOutlet UILabel *lbEmail;
@property (nonatomic, weak) IBOutlet UILabel *lbPassword;
@property (nonatomic, weak) IBOutlet UILabel *lbPasswordConfirmation;
@property (nonatomic, weak) IBOutlet UITextField *txtName;
@property (nonatomic, weak) IBOutlet UITextField *txtLastName;
@property (nonatomic, weak) IBOutlet UITextField *txtEmail;
@property (nonatomic, weak) IBOutlet UITextField *txtPassword;
@property (nonatomic, weak) IBOutlet UITextField *txtPasswordConfirmation;
@property (nonatomic, weak) IBOutlet UIButton *btnSave;
@property (nonatomic, weak) IBOutlet UIButton *btnPhoto;
@property (nonatomic, weak) IBOutlet UIScrollView *scvMenu;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIImageView *imvBackground;
@property (nonatomic, strong) UIButton *btnNavPhoto;

//(support)
@property (nonatomic, weak) UITextField *activeTextField;
@property (nonatomic, assign) Boolean isSector;
@property (nonatomic, assign) Boolean isFirstLoad;
@property (nonatomic, assign) HiveOfActivityCompany *selected;


@property (nonatomic, strong) NSMutableArray *listSector;
@property (nonatomic, strong) NSMutableArray<HiveOfActivityCompany*> *listCategory;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_SignUp
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
    long _lastTagSelected;
    
}

#pragma mark - • SYNTESIZES

@synthesize lbEmail, lbPassword, txtEmail, txtPassword, btnSave, btnPhoto, scvMenu, imvBackground, txtPasswordConfirmation, txtName, txtLastName, lbPasswordConfirmation, lbName, lbLastName, btnNavPhoto;
@synthesize activeTextField;
@synthesize user, isSector, selected, isFirstLoad, listSector, listCategory, fromFacebook, emailAvailable;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_SIGNUP", @"");
    
    //RootViewController for application
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    
    isFirstLoad = true;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //Layout
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    self.navigationItem.rightBarButtonItem = [self createNavPhotoButton];
    
    if(fromFacebook)
    {
        if(!emailAvailable)
        {
            SCLAlertViewPlus*alert = [AppD createDefaultAlert];
            [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_EMAIL", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NEED_EMAIL", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)clickPhoto:(id)sender
{
    SCLAlertViewPlus*alert = [AppD createDefaultAlert];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_PICK_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_TAKE_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
    
    [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_PICK_PHOTO", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PICK_PHOTO", @"") closeButtonTitle:nil duration:0.0] ;
}

- (IBAction)clickSave:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtPasswordConfirmation resignFirstResponder];
    [txtName resignFirstResponder];
    [txtLastName resignFirstResponder];
    
    if ([self.txtName.text isEqualToString:@""] || [self.txtLastName.text isEqualToString:@""] || [self.txtEmail.text isEqualToString:@""] || [self.txtPasswordConfirmation.text isEqualToString:@""] || [self.txtPassword.text isEqualToString:@""] )
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_EMPTY_FIELDS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMPTY_FIELDS_USER", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else if([ToolBox validationHelper_EmailChecker:txtEmail.text] == tbValidationResult_Disapproved)
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMAIL_INVALID", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else if(![txtPassword.text isEqualToString:txtPasswordConfirmation.text])
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PASSWORD_MATCH", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else if(txtPassword.text.length < 8 || txtPassword.text.length > 12)
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PASSWORD_INVALID", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else
    {
        user = [User new];
        user.email = txtEmail.text;
        user.password = txtPassword.text;
        user.name = txtName.text;
        user.lastName = txtLastName.text;
        
        ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
        
        if ([connectionManager isConnectionActive])
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
            });
            
            connectionManager.delegate = self;
            
            NSMutableDictionary *dicParameters = [[NSMutableDictionary alloc]initWithDictionary:[user dictionaryJSON]];
            [dicParameters setValue:@(AppD.masterEventID) forKey:@"master_event_id"];
            
            [connectionManager createUserUsingParameters:dicParameters withCompletionHandler:^(NSDictionary *response, NSError *error) {
                
                if (error){
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CREATION_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }else{
                    
                    if([response valueForKey:@"errors"])
                    {
                        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CREATION_ERROR_EMAIL", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                    else
                    {
                        //[Answers logSignUpWithMethod:@"Sucesso Cadastro" success:@YES customAttributes:@{}];
                        
                        NSDictionary *dicParameters;
                        
                        dicParameters  = [NSDictionary dictionaryWithObjectsAndKeys:txtEmail.text, AUTHENTICATE_EMAIL_KEY, txtPassword.text, AUTHENTICATE_PASSWORD_KEY, @(AppD.masterEventID), AUTHENTICATE_MASTER_EVENT_ID, nil];
                        
                        [connectionManager authenticateUserUsingParameters:dicParameters withCompletionHandler:^(NSDictionary *response, NSError *error) {
                            
                            if (error){
                                
                                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                                
                                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
                                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_AUTHENTICATION_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_AUTHENTICATION_AFTER_SIGNUP_ERROR", @"") closeButtonTitle:nil duration:0.0];
                            }else{
                                
                                //[Answers logLoginWithMethod:@"Sucesso Login" success:@YES customAttributes:@{}];
                                
                                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                                
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
                                
                                //PushNotification - Firebase
                                if ([AppD isEnableForRemoteNotifications]){
                                    [AppD registerForRemoteNotifications];
                                }
                                
                                SCLAlertView *alert = [AppD createDefaultAlert];
                                [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") actionBlock:^{
                                    
                                    //Instanciando a nova view destino
                                    [self.navigationController popViewControllerAnimated:NO];
                                    
                                }];
                                
                                [alert showSuccess:self title:NSLocalizedString(@"ALERT_TITLE_SUCCESS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CREATION_SUCCESS", @"") closeButtonTitle:nil duration:0.0];
                            }
                        }];
                    }
                }
                
            }];
        }
        else
        {
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }
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
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
        [scvMenu scrollRectToVisible:activeTextField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scvMenu.contentInset = contentInsets;
    scvMenu.scrollIndicatorInsets = contentInsets;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage* chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    user.profilePic = [ToolBox graphicHelper_NormalizeImage:chosenImage maximumDimension:IMAGE_MAXIMUM_SIZE_SIDE quality:1.0];
    
    dispatch_async(dispatch_get_main_queue(),^{
//        [self.btnPhoto setBackgroundImage:chosenImage forState:UIControlStateNormal];
//        [self.btnPhoto setBackgroundImage:chosenImage forState:UIControlStateHighlighted];
        [btnNavPhoto setBackgroundImage:chosenImage forState:UIControlStateNormal];
        btnNavPhoto.layer.cornerRadius = btnNavPhoto.bounds.size.width/2;
        btnNavPhoto.layer.masksToBounds = YES;
    });
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor blackColor];
    imvBackground.image = [AppD createDefaultBackgroundImage];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationItem setTitle:NSLocalizedString(@"SCREEN_TITLE_SIGNUP", @"")];
    self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
    
    //Background and Icons
    imvBackground.backgroundColor = [UIColor clearColor];
    
    //Scroll
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scvMenu.contentInset = contentInsets;
    scvMenu.scrollIndicatorInsets = contentInsets;
    
    //Buttons
    btnSave.backgroundColor = [UIColor clearColor];
    [btnSave.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    [btnSave setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSave.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnSave setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSave.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [btnSave setTitle:NSLocalizedString(@"BUTTON_TITLE_ACCOUNT", @"") forState:UIControlStateNormal];
    [btnSave setTitle:NSLocalizedString(@"BUTTON_TITLE_ACCOUNT", @"") forState:UIControlStateHighlighted];
    
    btnPhoto.layer.cornerRadius = btnPhoto.bounds.size.width/2;
    [btnPhoto setClipsToBounds:YES];
    [btnPhoto setBackgroundImage: [UIImage imageNamed:@"button-background-camera"] forState:UIControlStateHighlighted];
    [btnPhoto setBackgroundImage: [UIImage imageNamed:@"button-background-camera"] forState:UIControlStateNormal];
    [btnPhoto setHidden:true];
    
    //
    [btnSave setExclusiveTouch:YES];
    [btnPhoto setExclusiveTouch:YES];
    
    //Text Fields
    txtPassword.secureTextEntry = true;
    txtPasswordConfirmation.secureTextEntry = true;
    lbName.text = NSLocalizedString(@"PLACEHOLDER_NAME", @"");
    lbLastName.text = NSLocalizedString(@"PLACEHOLDER_LAST_NAME", @"");
    lbEmail.text = NSLocalizedString(@"PLACEHOLDER_EMAIL", @"");
    lbPassword.text = NSLocalizedString(@"PLACEHOLDER_PASSWORD", @"");
    lbPasswordConfirmation.text = NSLocalizedString(@"PLACEHOLDER_NEW_PASSWORD2", @"");
    txtName.placeholder = NSLocalizedString(@"PLACEHOLDER_NAME", @"");
    txtLastName.placeholder = NSLocalizedString(@"PLACEHOLDER_LAST_NAME", @"");
    txtEmail.placeholder = NSLocalizedString(@"PLACEHOLDER_EMAIL", @"");
    txtPassword.placeholder = NSLocalizedString(@"PLACEHOLDER_PASSWORD", @"");
    txtPasswordConfirmation.placeholder = NSLocalizedString(@"PLACEHOLDER_NEW_PASSWORD2", @"");
    
    [lbName setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [lbLastName setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [lbEmail setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [lbPassword setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [lbPasswordConfirmation setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [txtName setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [txtLastName setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [txtEmail setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [txtPassword setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [txtPasswordConfirmation setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    
    lbName.textColor = AppD.styleManager.colorPalette.textDark;
    lbLastName.textColor = AppD.styleManager.colorPalette.textDark;
    lbEmail.textColor = AppD.styleManager.colorPalette.textDark;
    lbPassword.textColor = AppD.styleManager.colorPalette.textDark;
    lbPasswordConfirmation.textColor = AppD.styleManager.colorPalette.textDark;
    
    //Ícones TextFields
    UIImageView *ivLoginUser = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    UIImageView *ivLoginLock = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    UIImageView *ivLoginCompany = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    UIImageView *ivLoginName = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    UIImageView *ivLoginLastName = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
    
    ivLoginUser.tintColor = [UIColor grayColor];
    ivLoginLock.tintColor = [UIColor grayColor];
    ivLoginCompany.tintColor = [UIColor grayColor];
    ivLoginName.tintColor = [UIColor grayColor];
    ivLoginLastName.tintColor = [UIColor grayColor];
    
    ivLoginUser.image = [[UIImage imageNamed:@"icon-email"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ivLoginLock.image = [[UIImage imageNamed:@"icon-password"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ivLoginCompany.image = [[UIImage imageNamed:@"icon-password"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ivLoginName.image = [[UIImage imageNamed:@"icon-user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    ivLoginLastName.image = [[UIImage imageNamed:@"icon-user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [ivLoginUser setContentMode:UIViewContentModeScaleAspectFit];
    [ivLoginLock setContentMode:UIViewContentModeScaleAspectFit];
    [ivLoginCompany setContentMode:UIViewContentModeScaleAspectFit];
    [ivLoginName setContentMode:UIViewContentModeScaleAspectFit];
    [ivLoginLastName setContentMode:UIViewContentModeScaleAspectFit];
    //
    [txtEmail setLeftViewMode:UITextFieldViewModeAlways];
    [txtPassword setLeftViewMode:UITextFieldViewModeAlways];
    [txtPasswordConfirmation setLeftViewMode:UITextFieldViewModeAlways];
    [txtName setLeftViewMode:UITextFieldViewModeAlways];
    [txtLastName setLeftViewMode:UITextFieldViewModeAlways];
    //
    txtEmail.leftView = ivLoginUser;
    txtPassword.leftView = ivLoginLock;
    txtPasswordConfirmation.leftView = ivLoginCompany;
    txtName.leftView = ivLoginName;
    txtLastName.leftView = ivLoginLastName;
}

- (UIBarButtonItem*)createNavPhotoButton {
    
    //Button Profile User
    btnNavPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNavPhoto.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [btnNavPhoto setBackgroundImage: [UIImage imageNamed:@"button-background-camera"] forState:UIControlStateNormal];
    
    btnNavPhoto.layer.cornerRadius = btnNavPhoto.bounds.size.width/2;
    btnNavPhoto.layer.masksToBounds = YES;
    [btnNavPhoto setFrame:CGRectMake(0, 0, 32, 32)];
    [btnNavPhoto setClipsToBounds:YES];
    [btnNavPhoto setExclusiveTouch:YES];
    [btnNavPhoto setTintColor:AppD.styleManager.colorPalette.textNormal];
    [btnNavPhoto addTarget:self action:@selector(clickPhoto:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[btnNavPhoto.widthAnchor constraintEqualToConstant:32.0] setActive:YES]; 
    [[btnNavPhoto.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:btnNavPhoto];
}

-(void) setupDataForSector
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connection getSectorsListWithCompletionHandler:^(NSArray *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SECTOR_SEARCH_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            }else{
                
                NSArray *tempResult = [[NSArray alloc] initWithArray:[response valueForKey:@"sectors"]];
                listSector = [NSMutableArray new];
                
                for (NSDictionary *dic in tempResult){
                    [listSector addObject:[HiveOfActivityCompany createObjectFromDictionary:dic]];
                }
                
            }
        }];
        
    }else{
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

-(void) setupDataCategory
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connection getCategoryListWithCompletionHandler:^(NSArray *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CATEGORY_SEARCH_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            }else{
                
                NSArray *tempResult = [[NSArray alloc] initWithArray:[response valueForKey:@"interest_areas"]];
                listCategory = [NSMutableArray new];
                
                for (NSDictionary *dic in tempResult){
                    [listCategory addObject:[HiveOfActivityCompany createObjectFromDictionary:dic]];
                }
                
            }
        }];
        
    }else{
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

@end

