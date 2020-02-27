//
//  VC_PromotionRegister.m
//  ShoppingBH
//
//  Created by Erico GT on 01/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_PromotionRegister.h"
#import "VC_Configurations.h"
#import "VC_TermsAndRules.h"
#import "VC_SurveyPromotion.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_PromotionRegister()

// Outlets
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *cpfTextField;
@property (nonatomic, weak) IBOutlet UITextField *rgTextField;
@property (nonatomic, weak) IBOutlet UITextField *birthdateTextField;
@property (nonatomic, weak) IBOutlet UITextField *genderTextField;
@property (nonatomic, weak) IBOutlet UITextField *dddTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *dddMobileTextField;
@property (nonatomic, weak) IBOutlet UITextField *mobilePhoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *zipCodeTextField;
@property (nonatomic, weak) IBOutlet UITextField *addressTextField;
@property (nonatomic, weak) IBOutlet UITextField *addressNumberTextField;
@property (nonatomic, weak) IBOutlet UITextField *complementTextField;
@property (nonatomic, weak) IBOutlet UITextField *districtTextField;
@property (nonatomic, weak) IBOutlet UITextField *cityTextField;
@property (nonatomic, weak) IBOutlet UITextField *stateTextField;
@property (nonatomic, weak) IBOutlet UIButton *signUpButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, weak) IBOutlet UIButton *termsCheckBoxButton;
@property (nonatomic, weak) IBOutlet UILabel *termsLabel;

// Support Properties
@property (nonatomic, weak) UITextField *activeTextField;
@property (nonatomic, assign) Boolean isGender;
@property (nonatomic, assign) Boolean isFirstLoad;
@property (nonatomic, assign) HiveOfActivityCompany *selected;
@property (nonatomic, strong) NSMutableArray *listSector;
@property (nonatomic, strong) NSMutableArray<HiveOfActivityCompany*> *listCategory;
@property (nonatomic, strong) User *userModificado;
@property (nonatomic, strong) User *userEstatico;
@property (nonatomic, strong) NSMutableAttributedString *attributedString;
@property (nonatomic, assign) NSRange linkRange;
@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, strong) NSLayoutManager *layoutManager;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_PromotionRegister
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES

@synthesize activeTextField;
@synthesize isGender, selected, isFirstLoad, listSector, listCategory, fromFacebook, emailAvailable;

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
    
    [self.view layoutIfNeeded];
    self.textContainer.size = self.termsLabel.bounds.size;
    
    //Layout
    if (!isFirstLoad){
        [self setupLayout];
        //
        [self loadData];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"Segue_DropList"]) {
        
        VC_DropList *vc_drop = [segue destinationViewController];
        vc_drop.dropListDelegate = self;
        
        if (activeTextField == self.genderTextField) {
            
            vc_drop.dropList = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_MALE", @"")], [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_FEMALE", @"")], nil];
            vc_drop.isState = false;
            vc_drop.user = nil;
            vc_drop.screenTitle = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER", @"")];
        
        } else if (activeTextField == self.stateTextField) {
            
            vc_drop.dropList = [NSArray arrayWithObjects: @"AC", @"AL", @"AM", @"AP", @"BA", @"CE", @"DF", @"ES", @"GO", @"MA", @"MT", @"MS", @"MG", @"PA", @"PB", @"PR", @"PE", @"PI", @"RJ", @"RN", @"RO", @"RS", @"RR", @"SC", @"SE", @"SP", @"TO", nil];
            vc_drop.isState = true;
            vc_drop.user = nil;
            vc_drop.screenTitle = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_UF", @"")];
            
        }
    } else if ([segue.identifier isEqualToString:@"SegueToTerms"]) {
        
        VC_TermsAndRules *termsVC = [segue destinationViewController];
        //
        termsVC.screenType = eTermsAndRulesScreenType_Promotion;
        termsVC.webItem = [WebItemToShow new];
        termsVC.webItem.urlString = self.promotion.urlTerms;
        termsVC.webItem.titleMenu = self.promotion.name;
        
    } else if ([segue.identifier isEqualToString:@"SegueToSurveyPromotion"]) {
        
        VC_SurveyPromotion *surveyVC = [segue destinationViewController];
        surveyVC.currentPromotion = [self.promotion copyObject];
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)checkTerms:(id)sender {
    self.termsCheckBoxButton.selected = !self.termsCheckBoxButton.selected;
    [self shouldEnableSignUpButton];
}

- (IBAction)signUp:(id)sender
{
    [self.emailTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    
    if ([self.nameTextField.text         isEqualToString:@""]
        || [self.cpfTextField.text           isEqualToString:@""]
        || [self.rgTextField.text            isEqualToString:@""]
        || [self.birthdateTextField.text     isEqualToString:@""]
        || [self.genderTextField.text        isEqualToString:@""]
        || [self.dddTextField.text           isEqualToString:@""]
        || [self.phoneTextField.text         isEqualToString:@""]
        || [self.dddMobileTextField.text     isEqualToString:@""]
        || [self.mobilePhoneTextField.text   isEqualToString:@""]
        || [self.zipCodeTextField.text       isEqualToString:@""]
        || [self.addressTextField.text       isEqualToString:@""]
        || [self.addressNumberTextField.text isEqualToString:@""]
        || [self.districtTextField.text      isEqualToString:@""]
        || [self.cityTextField.text          isEqualToString:@""]
        || [self.stateTextField.text         isEqualToString:@""]) {
        
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_EMPTY_FIELDS", @"") subTitle:NSLocalizedString(@"MESSAGE_REGISTER_EMPTY", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        
    } else if (![self.emailTextField.text isEqualToString:@""]) {
        
        if ([ToolBox validationHelper_EmailChecker:self.emailTextField.text] == tbValidationResult_Disapproved) {
            
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMAIL_INVALID", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            
        } else {
            
            [self fillUserWithTextFieldData];
            //
            [self updateUserToRegister:true];
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
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeTextField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)dropListProtocolDidSelectItem:(NSString*)itemText atIndex:(long)itemIndex
{
    if (activeTextField == self.genderTextField){
        self.genderTextField.text = itemText;
        self.userModificado.gender = itemText;
    }else if (activeTextField == self.stateTextField){
        self.stateTextField.text = itemText;
        self.userModificado.state = itemText;
    }
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    [self.scrollView scrollRectToVisible:activeTextField.frame animated:YES];
    
    if (textField == self.genderTextField || textField == self.stateTextField) {
        
        [self.view endEditing:YES];
        [self performSegueWithIdentifier:@"Segue_DropList" sender:nil];
        
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    // Prevent crashing undo bug
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    
    activeTextField = textField;
    
    if ((textField == self.cpfTextField) || (textField == self.zipCodeTextField) || (textField == self.dddTextField) || (textField == self.dddMobileTextField) || (textField == self.phoneTextField) || (textField == self.mobilePhoneTextField)) {
    
        NSString *mask = @"";
        
        if (textField == self.cpfTextField) {
            mask = @"###.###.###-##";
        } else if (textField == self.zipCodeTextField) {
            mask = @"##.###-###";
        } else if (textField == self.dddTextField) {
            mask = @"##";
        } else if (textField == self.dddMobileTextField) {
            mask = @"##";
        } else if (textField == self.phoneTextField) {
            mask = @"####-####";
        } else if (textField == self.mobilePhoneTextField) {
            mask = @"#####-####";
        }
        
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *replacedString = [self clearMask:[textField.text stringByReplacingCharactersInRange:range withString:string]];
        
        bool ignore = false;
        
        if(range.length == 1 && /* Only do for single deletes */ string.length < range.length && [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound){
            
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length-1;
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
        
        if(textField == self.zipCodeTextField){
            if (replacedString.length == 8){
                [self getAddressByZipCode:replacedString];
            }else{
                [self freeAddressFields];
            }
        }
        
        return NO;
    } else {
        return YES;
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    activeTextField = nil;
    
    if (textField == self.nameTextField) {
        self.userModificado.name = self.nameTextField.text;
    }
    else if (textField == self.emailTextField) {
        self.userModificado.email = self.emailTextField.text;
    }
    else if (textField == self.cpfTextField) {
        self.userModificado.CPF = self.cpfTextField.text;
    }
    else if (textField == self.rgTextField) {
        self.userModificado.RG = self.rgTextField.text;
    }
    else if (textField == self.genderTextField) {
        self.userModificado.gender = self.genderTextField.text;
    }
    else if (textField == self.birthdateTextField) {
        self.userModificado.birthdate = [ToolBox dateHelper_DateFromString:self.birthdateTextField.text withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
    }
    else if (textField == self.dddTextField || textField == self.phoneTextField) {
        self.userModificado.phone = [NSString stringWithFormat:@"%@%@", self.dddTextField.text, self.phoneTextField.text];
    }
    else if (textField == self.dddMobileTextField || textField == self.mobilePhoneTextField) {
        self.userModificado.mobilePhone = [NSString stringWithFormat:@"%@%@", self.dddMobileTextField.text, self.mobilePhoneTextField.text];
    }
    else if (textField == self.addressTextField) {
        self.userModificado.address = self.addressTextField.text;
    }
    else if (textField == self.addressNumberTextField) {
        self.userModificado.addressNumber = self.addressNumberTextField.text;
    }
    else if (textField == self.zipCodeTextField) {
        self.userModificado.zipCode = self.zipCodeTextField.text;
    }
    else if (textField == self.districtTextField) {
        self.userModificado.district = self.districtTextField.text;
    }
    else if (textField == self.cityTextField) {
        self.userModificado.city = self.cityTextField.text;
    }
    else if (textField == self.stateTextField) {
        self.userModificado.state = self.stateTextField.text;
    }
    
    [self shouldEnableSignUpButton];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    activeTextField = nil;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

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
    [btnApply setTitle:@"Buscar" forState:UIControlStateNormal];
    
    [view addSubview:btnApply];
    
    return view;
}

#pragma mark - Layout

- (void)setupLayout
{
    // Self
    self.view.backgroundColor = [UIColor whiteColor];
    //imvBackground.image = [AppD createDefaultBackgroundImage];
    
    // NavBar
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
    [self.navigationController.navigationItem setTitle:NSLocalizedString(@"SCREEN_TITLE_SIGNUP", @"")];
    
    // Background Image
    self.backgroundImage.backgroundColor = [UIColor clearColor];
    
    // Scroll
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // Button
    self.signUpButton.backgroundColor = [UIColor clearColor];
    [self.signUpButton.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    [self.signUpButton setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.signUpButton.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.signUpButton setTitle:NSLocalizedString(@"BUTTON_TITLE_ACCOUNT", @"") forState:UIControlStateNormal];
    [self.signUpButton setTitle:NSLocalizedString(@"BUTTON_TITLE_ACCOUNT", @"") forState:UIControlStateHighlighted];
    
    [self.signUpButton setExclusiveTouch:YES];
    
    // Text Fields
    self.nameTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_NAME", @"")];
    self.cpfTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_CPF", @"")];
    self.rgTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_RG", @"")];
    self.birthdateTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_BIRTHDATE", @"")];
    self.dddTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_DDD", @"")];
    self.dddMobileTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_DDD", @"")];
    self.phoneTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_PHONE_FIX", @"")];
    self.mobilePhoneTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_MOBILE_PHONE", @"")];
    self.genderTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_GENDER", @"")];
    self.emailTextField.placeholder = NSLocalizedString(@"PLACEHOLDER_EMAIL", @"");
    self.addressTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_ADDRESS", @"")];
    self.addressNumberTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_NUMBER", @"")];
    self.complementTextField.placeholder = NSLocalizedString(@"PLACEHOLDER_ADJUNCT", @"");
    self.districtTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_DISTRICT", @"")];
    self.cityTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_CITY", @"")];
    self.stateTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_UF", @"")];
    self.zipCodeTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_ZIPCODE", @"")];
    
    [self.nameTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.cpfTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.rgTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.birthdateTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.dddTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.phoneTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.dddMobileTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.mobilePhoneTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.genderTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.emailTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.addressTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.addressNumberTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.complementTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.districtTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.cityTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.stateTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [self.zipCodeTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    
    self.nameTextField.delegate = self;
    self.cpfTextField.delegate = self;
    self.rgTextField.delegate = self;
    self.genderTextField.delegate = self;
    self.birthdateTextField.delegate = self;
    self.dddTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.dddMobileTextField.delegate = self;
    self.mobilePhoneTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.addressTextField.delegate = self;
    self.addressNumberTextField.delegate = self;
    self.complementTextField.delegate = self;
    self.zipCodeTextField.delegate = self;
    self.districtTextField.delegate = self;
    self.cityTextField.delegate = self;
    self.stateTextField.delegate = self;
    
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.cpfTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.rgTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mobilePhoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.complementTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.districtTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.cityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.zipCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImageView *arrowImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.emailTextField.frame.size.width - 30.0, 0, 30.0, self.emailTextField.frame.size.height)];
    UIImageView *arrowImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.emailTextField.frame.size.width - 30.0, 0, 30.0, self.emailTextField.frame.size.height)];
    arrowImage1.tintColor = [UIColor grayColor];
    arrowImage2.tintColor = [UIColor grayColor];
    arrowImage1.image = [[UIImage imageNamed:@"icon-down-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    arrowImage2.image = [[UIImage imageNamed:@"icon-down-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [arrowImage1 setContentMode:UIViewContentModeScaleAspectFit];
    [arrowImage2 setContentMode:UIViewContentModeScaleAspectFit];
    [self.genderTextField setRightViewMode:UITextFieldViewModeAlways];
    [self.stateTextField setRightViewMode:UITextFieldViewModeAlways];
    self.genderTextField.rightView = arrowImage1;
    self.stateTextField.rightView = arrowImage2;
    
    self.cpfTextField.inputAccessoryView = [self createAcessoryViewWithTarget:self.cpfTextField andSelector:@selector(resignFirstResponder)];
    self.rgTextField.inputAccessoryView = [self createAcessoryViewWithTarget:self.rgTextField andSelector:@selector(resignFirstResponder)];
    self.birthdateTextField.inputAccessoryView = [self createAcessoryViewWithTarget:self.birthdateTextField andSelector:@selector(resignFirstResponder)];
    self.dddTextField.inputAccessoryView = [self createAcessoryViewWithTarget:self.dddTextField andSelector:@selector(resignFirstResponder)];
    self.dddMobileTextField.inputAccessoryView = [self createAcessoryViewWithTarget:self.dddMobileTextField andSelector:@selector(resignFirstResponder)];
    self.phoneTextField.inputAccessoryView = [self createAcessoryViewWithTarget:self.phoneTextField andSelector:@selector(resignFirstResponder)];
    self.mobilePhoneTextField.inputAccessoryView = [self createAcessoryViewWithTarget:self.mobilePhoneTextField andSelector:@selector(resignFirstResponder)];
    self.addressNumberTextField.inputAccessoryView = [self createAcessoryViewWithTarget:self.addressNumberTextField andSelector:@selector(resignFirstResponder)];
    self.zipCodeTextField.inputAccessoryView = [self createAcessoryViewWithTarget:self.zipCodeTextField andSelector:@selector(resignFirstResponder)];
    
    self.genderTextField.tag = 0;
    self.stateTextField.tag = 1;
    
    UIDatePicker *datePicker = [UIDatePicker new];
    [datePicker setMaximumDate:[NSDate date]];
    if (AppD.loggedUser.birthdate != nil){
        [datePicker setDate:AppD.loggedUser.birthdate];
    }else{
        [datePicker setDate:[NSDate date]];
    }
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.birthdateTextField setInputView:datePicker];
    
    // Terms CheckBox
    self.termsCheckBoxButton.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.termsCheckBoxButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.termsCheckBoxButton.layer.borderWidth = 1;
    self.termsCheckBoxButton.layer.cornerRadius = 5;
    [self.termsCheckBoxButton setImage:[UIImage imageNamed:@"icon-checkmark.png"] forState:UIControlStateSelected];
    self.termsCheckBoxButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.termsCheckBoxButton setImage:nil forState:UIControlStateNormal];
    
    // Terms Label
    NSString *string = [NSString stringWithFormat: @"%@ %@", [NSString stringWithFormat:@"%@", NSLocalizedString(@"LABEL_ACCEPT_TERMS", @"")], self.promotion.name];
    self.linkRange = [string rangeOfString:[NSString stringWithFormat:@"%@", NSLocalizedString(@"LABEL_HIGHLIGHT_TERMS", @"")]];
    
    self.attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:nil];
    
    NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
                                      NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
    [self.attributedString setAttributes:linkAttributes range:self.linkRange];
    
    self.termsLabel.attributedText = self.attributedString;
    
    self.layoutManager = [[NSLayoutManager alloc] init];
    self.textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.termsLabel.attributedText];
    
    [self.layoutManager addTextContainer:self.textContainer];
    [textStorage addLayoutManager:self.layoutManager];
    
    self.textContainer.lineFragmentPadding = 0.0;
    self.textContainer.lineBreakMode = self.termsLabel.lineBreakMode;
    self.textContainer.maximumNumberOfLines = self.termsLabel.numberOfLines;
    
    self.termsLabel.userInteractionEnabled = YES;
    [self.termsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
    
    [self.emailTextField setEnabled:NO];
    [self.emailTextField setTextColor:[UIColor grayColor]];
}

-(void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.birthdateTextField.inputView;
    self.birthdateTextField.text = [ToolBox dateHelper_StringFromDate:picker.date withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
}

- (void)handleTapOnLabel:(UITapGestureRecognizer *)tapGesture
{
    [self performSegueWithIdentifier:@"SegueToTerms" sender:nil];
}

#pragma mark -

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

- (void)loadData {
    
    self.userEstatico = [AppD.loggedUser copyObject];
    self.userModificado = [AppD.loggedUser copyObject];
    
    [self fillTextFieldsAndLabels];
    [self shouldEnableSignUpButton];
    
    if ([self.userModificado.CPF isEqualToString:@""] || self.userModificado.CPF == nil){
        [self getCostumerDataByCPF];
    }else{
        [self loadCostumerData];
    }
}

- (void)fillTextFieldsAndLabels
{
    self.nameTextField.text = self.userEstatico.name;
    self.cpfTextField.text = self.userEstatico.CPF;
    self.rgTextField.text = self.userEstatico.RG;
    self.genderTextField.text = self.userEstatico.gender;
    self.birthdateTextField.text = [ToolBox dateHelper_StringFromDate:self.userEstatico.birthdate withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
    self.dddTextField.text = self.userEstatico.phoneDDD;
    self.phoneTextField.text = self.userEstatico.phone;
    self.dddMobileTextField.text = self.userEstatico.mobilePhoneDDD;
    self.mobilePhoneTextField.text = self.userEstatico.mobilePhone;
    self.emailTextField.text = self.userEstatico.email;
    if (![self.emailTextField.text isEqualToString:@""]) {
        [self.emailTextField setEnabled:false];
        [self.emailTextField setTextColor:[UIColor grayColor]];
    }
    self.addressTextField.text = self.userEstatico.address;
    self.addressNumberTextField.text = self.userEstatico.addressNumber;
    self.complementTextField.text = self.userEstatico.complement;
    self.zipCodeTextField.text = self.userEstatico.zipCode;
    self.districtTextField.text = self.userEstatico.district;
    self.cityTextField.text = self.userEstatico.city;
    self.stateTextField.text = self.userEstatico.state;
}

- (void)fillUserWithTextFieldData
{
    self.userModificado.name = self.nameTextField.text;
    self.userModificado.CPF = self.cpfTextField.text;
    self.userModificado.RG = self.rgTextField.text;
    self.userModificado.birthdate = [ToolBox dateHelper_DateFromString:self.birthdateTextField.text withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
    self.userModificado.gender = [self.genderTextField.text isEqualToString:@""] ? @"" : ([self.genderTextField.text isEqualToString:NSLocalizedString(@"PLACEHOLDER_GENDER_MALE", @"")] ? @"MALE" : @"FEMALE");
    self.userModificado.phone = self.phoneTextField.text;
    self.userModificado.mobilePhone = self.mobilePhoneTextField.text;
    self.userModificado.phoneDDD = self.dddTextField.text;
    self.userModificado.mobilePhoneDDD = self.dddMobileTextField.text;
    //ignorar email
    self.userModificado.address = self.addressTextField.text;
    self.userModificado.addressNumber = self.addressNumberTextField.text;
    self.userModificado.complement = self.complementTextField.text;
    self.userModificado.zipCode = self.zipCodeTextField.text;
    self.userModificado.district = self.districtTextField.text;
    self.userModificado.city = self.cityTextField.text;
    self.userModificado.state = self.stateTextField.text;
}

- (void)shouldEnableSignUpButton {
    
    if (self.termsCheckBoxButton.selected) {
        [self.signUpButton setEnabled:true];
    } else {
        [self.signUpButton setEnabled:false];
    }
}



- (void)updateUserData:(NSDictionary*)userDic
{
    NSArray *keysList = [userDic allKeys];
    //
    AppD.loggedUser.address = [keysList containsObject:@"address"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"address"]] : AppD.loggedUser.address;
    AppD.loggedUser.birthdate = [keysList containsObject:@"birthdate"] ? [ToolBox dateHelper_DateFromString:[NSString stringWithFormat:@"%@", [userDic  valueForKey:@"birthdate"]] withFormat:TOOLBOX_DATA_HIFEN_CURTA_INVERTIDA] : AppD.loggedUser.birthdate;
    AppD.loggedUser.city = [keysList containsObject:@"city"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"city"]] : AppD.loggedUser.city;
    AppD.loggedUser.complement = [keysList containsObject:@"complement"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"complement"]] : AppD.loggedUser.complement;
    AppD.loggedUser.country = [keysList containsObject:@"country"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"country"]] : AppD.loggedUser.country;
    AppD.loggedUser.CPF = [keysList containsObject:@"cpf"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"cpf"]] : AppD.loggedUser.CPF;
    AppD.loggedUser.district = [keysList containsObject:@"district"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"district"]] : AppD.loggedUser.district;
    AppD.loggedUser.name = [keysList containsObject:@"first_name"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"first_name"]] : AppD.loggedUser.name;
    NSString *gender = [keysList containsObject:@"gender"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"gender"]] : AppD.loggedUser.gender;
    if ([[gender uppercaseString] isEqualToString:@"0"]) {
        AppD.loggedUser.gender = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_MALE", @"")];
    } else if ([[gender uppercaseString] isEqualToString:@"1"]) {
        AppD.loggedUser.gender = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_FEMALE", @"")];
    } else{
        AppD.loggedUser.gender = @"";
    }
    AppD.loggedUser.addressNumber = [keysList containsObject:@"number"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"number"]] : AppD.loggedUser.addressNumber;
    AppD.loggedUser.phone = [keysList containsObject:@"phone"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"phone"]] : AppD.loggedUser.phone;
    AppD.loggedUser.mobilePhone = [keysList containsObject:@"cell_phone"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"cell_phone"]] : AppD.loggedUser.mobilePhone;
    AppD.loggedUser.phoneDDD = [keysList containsObject:@"ddd_phone"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"ddd_phone"]] : AppD.loggedUser.phoneDDD;
    AppD.loggedUser.mobilePhoneDDD = [keysList containsObject:@"ddd_cell_phone"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"ddd_cell_phone"]] : AppD.loggedUser.mobilePhoneDDD;
    AppD.loggedUser.urlProfilePic = [keysList containsObject:@"profile_image"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"profile_image"]] : AppD.loggedUser.urlProfilePic;
    AppD.loggedUser.RG = [keysList containsObject:@"rg"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"rg"]] : AppD.loggedUser.RG;
    AppD.loggedUser.state = [keysList containsObject:@"state"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"state"]] : AppD.loggedUser.state;
    AppD.loggedUser.zipCode = [keysList containsObject:@"zipcode"] ? [NSString stringWithFormat:@"%@", [userDic  valueForKey:@"zipcode"]] : AppD.loggedUser.zipCode;
    //
    //Removendo algumas máscaras não necessárias:
    AppD.loggedUser.phoneDDD = [self clearMask:AppD.loggedUser.phoneDDD];
    AppD.loggedUser.mobilePhoneDDD = [self clearMask:AppD.loggedUser.mobilePhoneDDD];
    //
    [AppD registerLoginForUser:AppD.loggedUser.email data:[[AppD.loggedUser dictionaryJSON] valueForKey:@"app_user"]];
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

- (SCLAlertViewPlus*)createAlertWithTextField
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    //
    UITextField *textField = [alert addTextField:NSLocalizedString(@"PLACEHOLDER_CPF", @"")];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [textField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setSpellCheckingType:UITextSpellCheckingTypeNo];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.inputAccessoryView = [self createAcessoryViewWithTarget:textField andSelector:@selector(resignFirstResponder)];
    //
    alert.defaultTextField = textField;
    //
    return alert;
}

- (void)showAlertWithTextField
{
    SCLAlertViewPlus *alert = [self createAlertWithTextField];
    
    __block UITextField *tField;
    tField = alert.defaultTextField;
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_SEND", @"") withType:SCLAlertButtonType_Question actionBlock:^{
        
        [tField resignFirstResponder];
        
        if ([tField.text isEqualToString:@""] || tField.text == nil || [ToolBox validationHelper_ValidateCPF:tField.text] != tbValidationResult_Approved){
            [self showAlertWithTextField];
        }else{
            [self loadCostumerDataUsingCPF:tField.text];
        }
    }];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_END_REGISTER", @"") withType:SCLAlertButtonType_Neutral actionBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_CONFIGURATION_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_INCORRECT_CPF_FORMAT", @"") closeButtonTitle:nil duration:0.0];
}

#pragma mark - Connection

- (void)getCostumerDataByCPF
{
    SCLAlertViewPlus *alert = [self createAlertWithTextField];
    
    __block UITextField *tField;
    tField = alert.defaultTextField;
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_SEND", @"") actionBlock:^{
        
        [tField resignFirstResponder];
        
        if ([tField.text isEqualToString:@""] || tField.text == nil || [ToolBox validationHelper_ValidateCPF:tField.text] != tbValidationResult_Approved){
            [self showAlertWithTextField];
        }else{
            [self loadCostumerDataUsingCPF:tField.text];
        }
    }];

    [alert showInfo:self title:NSLocalizedString(@"PLACEHOLDER_CPF", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_INCORRECT_CPF_FORMAT", @"") closeButtonTitle:nil duration:0.0];
}

- (void)loadCostumerDataUsingCPF:(NSString*)cpf
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive]) {
        
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getCostumerDataUsingCPF:cpf withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (!error) {
                if (response) {
                    
                    isFirstLoad = true;
                    
                    //NSString *status = [response valueForKey:@"status"];
                    //if ([status isEqualToString:@"SUCCESS"]){ o Fábio não vai mais mandar o sucesso pelo status
                        
                    if ([[response allKeys] containsObject:@"customer"]){
                        
                        NSMutableDictionary *costumer =  [[NSMutableDictionary alloc] initWithDictionary: [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:[response valueForKey:@"customer"] withString:@""]];
                        
                        NSArray *keysList = [costumer allKeys];
                        
                        //self.userModificado.email > ignorado pois não deve mudar
                        
                        self.userModificado.name = [keysList containsObject:@"first_name"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"first_name"]] : self.userModificado.name;
                        self.userModificado.CPF = [keysList containsObject:@"cpf"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"cpf"]] : self.userModificado.CPF;
                        self.userModificado.RG = [keysList containsObject:@"rg"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"rg"]] : self.userModificado.RG;
                        self.userModificado.mobilePhoneDDD = [keysList containsObject:@"ddd_cell_phone"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"ddd_cell_phone"]] : self.userModificado.mobilePhoneDDD;
                        self.userModificado.mobilePhone = [keysList containsObject:@"cell_phone"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"cell_phone"]] : self.userModificado.mobilePhone;
                        self.userModificado.phone = [keysList containsObject:@"phone"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"phone"]] : self.userModificado.phone;
                        self.userModificado.phoneDDD = [keysList containsObject:@"ddd_phone"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"ddd_phone"]] : self.userModificado.phoneDDD;
                        self.userModificado.address = [keysList containsObject:@"address"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"address"]] : self.userModificado.address;
                        self.userModificado.addressNumber = [keysList containsObject:@"number"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"number"]] : self.userModificado.addressNumber;
                        self.userModificado.complement = [keysList containsObject:@"complement"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"complement"]] : self.userModificado.complement;
                        self.userModificado.zipCode = [keysList containsObject:@"zipcode"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"zipcode"]] : self.userModificado.zipCode;
                        self.userModificado.district = [keysList containsObject:@"district"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"district"]] : self.userModificado.district;
                        self.userModificado.city = [keysList containsObject:@"city"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"city"]] : self.userModificado.city;;
                        self.userModificado.state = [keysList containsObject:@"state"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"state"]] : self.userModificado.state;;
                        
                        NSString *gender = [keysList containsObject:@"gender"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"gender"]] : self.userModificado.gender;
                        if ([[gender uppercaseString] isEqualToString:@"0"]) {
                            self.userModificado.gender = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_MALE", @"")];
                        } else if ([[gender uppercaseString] isEqualToString:@"1"]) {
                            self.userModificado.gender = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_FEMALE", @"")];
                        } else{
                            self.userModificado.gender = @"";
                        }
                        
                        self.userModificado.urlProfilePic = [keysList containsObject:@"profile_image"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"profile_image"]] : self.userModificado.urlProfilePic;
                        
                        //Removendo algumas máscaras não necessárias:
                        self.userModificado.phoneDDD = [self clearMask:self.userModificado.phoneDDD];
                        self.userModificado.mobilePhoneDDD = [self clearMask:self.userModificado.mobilePhoneDDD];
                        
                        [self updateUserToRegister:false];
                        
                    } else {
                        
                        NSLog(@"loadCostumerDataUsingCPF > No customer data.");
                    }
                } else {
                    
                    NSLog(@"loadCostumerDataUsingCPF > No response.");
                }
            } else {
                
                NSLog(@"loadCostumerDataUsingCPF > Connection error.");
            }
        }];
    } else {
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        //
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (void)loadCostumerData {
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive]) {
        
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getCostumerWithCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (!error) {
                if (response) {
                    
                    if ([[response allKeys] containsObject:@"customer"]){
                        
                        NSMutableDictionary *costumer =  [[NSMutableDictionary alloc] initWithDictionary: [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:[response valueForKey:@"customer"] withString:@""]];
                        
                        NSArray *keysList = [costumer allKeys];
                        
                        //self.userModificado.email > ignorado pois não deve mudar
                        
                        self.userModificado.name = [keysList containsObject:@"first_name"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"first_name"]] : self.userModificado.name;
                        self.userModificado.CPF = [keysList containsObject:@"cpf"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"cpf"]] : self.userModificado.CPF;
                        self.userModificado.RG = [keysList containsObject:@"rg"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"rg"]] : self.userModificado.RG;
                        self.userModificado.mobilePhoneDDD = [keysList containsObject:@"ddd_cell_phone"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"ddd_cell_phone"]] : self.userModificado.mobilePhoneDDD;
                        self.userModificado.mobilePhone = [keysList containsObject:@"cell_phone"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"cell_phone"]] : self.userModificado.mobilePhone;
                        self.userModificado.phone = [keysList containsObject:@"phone"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"phone"]] : self.userModificado.phone;
                        self.userModificado.phoneDDD = [keysList containsObject:@"ddd_phone"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"ddd_phone"]] : self.userModificado.phoneDDD;
                        self.userModificado.address = [keysList containsObject:@"address"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"address"]] : self.userModificado.address;
                        self.userModificado.addressNumber = [keysList containsObject:@"number"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"number"]] : self.userModificado.addressNumber;
                        self.userModificado.complement = [keysList containsObject:@"complement"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"complement"]] : self.userModificado.complement;
                        self.userModificado.zipCode = [keysList containsObject:@"zipcode"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"zipcode"]] : self.userModificado.zipCode;
                        self.userModificado.district = [keysList containsObject:@"district"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"district"]] : self.userModificado.district;
                        self.userModificado.city = [keysList containsObject:@"city"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"city"]] : self.userModificado.city;;
                        self.userModificado.state = [keysList containsObject:@"state"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"state"]] : self.userModificado.state;;
                        
                        NSString *gender = [keysList containsObject:@"gender"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"gender"]] : self.userModificado.gender;
                        if ([[gender uppercaseString] isEqualToString:@"0"]) {
                            self.userModificado.gender = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_MALE", @"")];
                        } else if ([[gender uppercaseString] isEqualToString:@"1"]) {
                            self.userModificado.gender = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_GENDER_FEMALE", @"")];
                        } else{
                            self.userModificado.gender = @"";
                        }
                        
                        self.userModificado.urlProfilePic = [keysList containsObject:@"profile_image"] ? [NSString stringWithFormat:@"%@", [costumer  valueForKey:@"profile_image"]] : self.userModificado.urlProfilePic;
                        
                        //Removendo algumas máscaras não necessárias:
                        self.userModificado.phoneDDD = [self clearMask:self.userModificado.phoneDDD];
                        self.userModificado.mobilePhoneDDD = [self clearMask:self.userModificado.mobilePhoneDDD];
                        
                        [self updateUserToRegister:false];
                        
                        isFirstLoad = true;
                        
                    } else {
                        
                        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    }
                } else {
                    
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                }
            } else {
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PROFILE_INFOS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
        }];
    } else {
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        //
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (void)getAddressByZipCode:(NSString*)zipCode
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.view endEditing:YES];
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager findAddressByCEP:zipCode withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            if(error){
                NSLog(@"getAddressByZipCode > Error > %@", error.localizedDescription);
            }
            else{
                
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                
                if (![[response allKeys] containsObject:@"erro"]){
                    
                    //    {
                    //        "cep": "18103-540",
                    //        "logradouro": "Rua Picolomo Cataldo",
                    //        "complemento": "",
                    //        "bairro": "Jardim Carolina",
                    //        "localidade": "Sorocaba",
                    //        "uf": "SP",
                    //        "unidade": "",
                    //        "ibge": "3552205",
                    //        "gia": "6695"
                    //    }
                    
                    NSArray *allKeys = [response allKeys];
                    //
                    if ([allKeys containsObject:@"logradouro"]){
                        self.addressTextField.text = [NSString stringWithFormat:@"%@", [response objectForKey:@"logradouro"]];
                        [self.addressTextField setEnabled:NO];
                        [self.addressTextField setTextColor:[UIColor grayColor]];
                    }else{
                        self.addressTextField.text = @"";
                        [self.addressTextField setEnabled:YES];
                        [self.addressTextField setTextColor:[UIColor darkTextColor]];
                    }
                    //
                    if ([allKeys containsObject:@"bairro"]){
                        self.districtTextField.text = [NSString stringWithFormat:@"%@", [response objectForKey:@"bairro"]];
                        [self.districtTextField setEnabled:NO];
                        [self.districtTextField setTextColor:[UIColor grayColor]];
                    }else{
                        self.districtTextField.text = @"";
                        [self.districtTextField setEnabled:YES];
                        [self.districtTextField setTextColor:[UIColor darkTextColor]];
                    }
                    //
                    if ([allKeys containsObject:@"localidade"]){
                        self.cityTextField.text = [NSString stringWithFormat:@"%@", [response objectForKey:@"localidade"]];
                        [self.cityTextField setEnabled:NO];
                        [self.cityTextField setTextColor:[UIColor grayColor]];
                    }else{
                        self.cityTextField.text = @"";
                        [self.cityTextField setEnabled:YES];
                        [self.cityTextField setTextColor:[UIColor darkTextColor]];
                    }
                    //
                    if ([allKeys containsObject:@"uf"]){
                        self.stateTextField.text = [NSString stringWithFormat:@"%@", [response objectForKey:@"uf"]];
                        [self.stateTextField setEnabled:NO];
                        [self.stateTextField setTextColor:[UIColor grayColor]];
                    }else{
                        self.stateTextField.text = @"";
                        [self.stateTextField setEnabled:YES];
                        [self.stateTextField setTextColor:[UIColor darkTextColor]];
                    }
                    
                }else{
                    
                    NSLog(@"getAddressByZipCode > CEP não encontrado.");
                    
                    [self freeAddressFields];
                }
            }
        }];
    }
    
    /*
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive]) {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.view endEditing:YES];
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getAddressByCEP:zipCode withCompletionHandler:^(NSDictionary *response, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error) {
                NSLog(@"getAddressByZipCode > Error > %@", error.localizedDescription);
            } else {
                
                NSDictionary *res = [[NSDictionary alloc] initWithDictionary:[response objectForKey:@"cep"]];
                NSArray *allKeys = [res allKeys];
                
                if ([res objectForKey:@"logradouro"] != nil) {
                    
                    NSString *tl = [allKeys containsObject:@"tipoLogradouro"] ? [NSString stringWithFormat:@"%@ ", [res objectForKey:@"tipoLogradouro"]] : @"";
                    NSString *nl = [allKeys containsObject:@"logradouro"] ? [NSString stringWithFormat:@"%@", [res objectForKey:@"logradouro"]] : @"";
                    self.addressTextField.text = (![tl isEqualToString:@""] || ![nl isEqualToString:@""]) ? [NSString stringWithFormat:@"%@%@", tl, nl] : @"";
                    self.districtTextField.text = [allKeys containsObject:@"bairro"] ? [NSString stringWithFormat:@"%@", [res objectForKey:@"bairro"]] : @"";
                    self.cityTextField.text = [allKeys containsObject:@"cidade"] ? [NSString stringWithFormat:@"%@", [res objectForKey:@"cidade"]] : @"";
                    self.stateTextField.text = [allKeys containsObject:@"uf"] ? [NSString stringWithFormat:@"%@", [res objectForKey:@"uf"]] : @"";
                    
                } else {
                    
                    NSLog(@"getAddressByZipCode > CEP não encontrado.");
                    
                    self.zipCodeTextField.text = @"";
                    self.addressTextField.text = @"";
                    self.districtTextField.text = @"";
                    self.cityTextField.text = @"";
                    self.stateTextField.text = @"";
                }
            }
        }];
    } else {
        NSLog(@"getAddressByZipCode > Sem conexão com internet.");
    }
     */
}

- (void)updateUserToRegister:(bool)toRegister {
    
    if (![self.userModificado isEqualToObject:self.userEstatico] || toRegister) {
        
        ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
        
        if ([connectionManager isConnectionActive]) {
            
            dispatch_async(dispatch_get_main_queue(),^{
                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
            });
            
            connectionManager.delegate = self;
            NSDictionary *dicParameters = [self.userModificado dictionaryJSON];
            NSDictionary *dicParameters2 = [dicParameters valueForKey:@"app_user"];
            if ([self.userModificado.gender isEqualToString:NSLocalizedString(@"PLACEHOLDER_GENDER_MALE", @"")] || [[self.userModificado.gender uppercaseString] isEqualToString:@"MALE"]){
                [dicParameters2 setValue:@(0) forKey:@"gender"];
            }else{
                [dicParameters2 setValue:@(1) forKey:@"gender"];
            }
            
            [connectionManager updateUserUsingParametersWithoudID:dicParameters  withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
                
                if (error) {
                    
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_UPDATE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    
                } else {
                    
                    isFirstLoad = true;
                    
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    
                    //Se o resultado não possuir keys, considera-se um erro.
                    NSArray *keys = [response allKeys];
                    if (keys.count > 0){
                        
                        //Sucesso:
                        [self updateUserData:[ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:response withString:@""]];
                        self.userModificado = [AppD.loggedUser copyObject];
                        self.userEstatico = [AppD.loggedUser copyObject];
                        
                        if (toRegister){
                            [self performSegueWithIdentifier:@"SegueToSurveyPromotion" sender:self.promotion];
                        }else{
                            [self fillTextFieldsAndLabels];
                            [self shouldEnableSignUpButton];
                        }
                        
                    }else{
                        //Erro:
                        [self fillTextFieldsAndLabels];
                        [self shouldEnableSignUpButton];
                        //
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_UPDATE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                }
            }];
        } else {
            
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }
}

- (void)freeAddressFields
{
    self.addressTextField.text = @"";
    [self.addressTextField setEnabled:YES];
    [self.addressTextField setTextColor:[UIColor darkTextColor]];
    //
    self.districtTextField.text = @"";
    [self.districtTextField setEnabled:YES];
    [self.districtTextField setTextColor:[UIColor darkTextColor]];
    //
    self.cityTextField.text = @"";
    [self.cityTextField setEnabled:YES];
    [self.cityTextField setTextColor:[UIColor darkTextColor]];
    //
    self.stateTextField.text = @"";
    [self.stateTextField setEnabled:YES];
    [self.stateTextField setTextColor:[UIColor darkTextColor]];
}

@end
