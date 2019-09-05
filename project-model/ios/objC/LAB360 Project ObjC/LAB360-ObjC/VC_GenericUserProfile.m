//
//  VC_GenericUserProfile.m
//  ShoppingBH
//
//  Created by Erico GT on 08/01/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_GenericUserProfile.h"
#import "VC_ResetPassword.h"
#import "VC_DropList.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_GenericUserProfile()<DropListProtocol>

@property (nonatomic, weak) IBOutlet UIImageView *imgBackground;
//
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *cpfTextField;
@property (nonatomic, weak) IBOutlet UITextField *cnpjTextField;
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
//
@property (nonatomic, weak) IBOutlet UIButton *btnNavPhoto;
@property (nonatomic, weak) IBOutlet UIButton *btnChangePassword;
@property (nonatomic, weak) IBOutlet UIButton *btnSave;
//
@property (nonatomic, weak) UITextField *activeTextField;

//objetos
@property (nonatomic, strong) User *userModificado;
@property (nonatomic, strong) User *userEstatico;
@property (nonatomic, assign) BOOL selectedPhoto;
@property (nonatomic, strong) id selectedItem;
@property (nonatomic, assign) Boolean isFirstLoad;
@property (nonatomic, assign) Boolean isState;
@property (nonatomic, assign) Boolean photoChanged;
@property (nonatomic, assign) long  lastTagSelected;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_GenericUserProfile
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES

@synthesize imgBackground, btnNavPhoto, btnChangePassword, btnSave, activeTextField;
@synthesize nameTextField, cnpjTextField,cpfTextField, rgTextField, birthdateTextField, genderTextField, dddTextField, phoneTextField, dddMobileTextField, mobilePhoneTextField, emailTextField, zipCodeTextField, addressTextField, addressNumberTextField,complementTextField, districtTextField, cityTextField,stateTextField;
@synthesize userModificado, userEstatico, selectedPhoto, selectedItem, isFirstLoad, isState, photoChanged, lastTagSelected;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    userEstatico = [AppD.loggedUser copyObject];
    userModificado = [AppD.loggedUser copyObject];
    
    if ([userModificado.urlProfilePic isEqualToString:@""] || userModificado.urlProfilePic == nil){
        userEstatico.profilePic = nil;
        userModificado.profilePic = nil;
    }
    
    isFirstLoad = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isFirstLoad){
        isFirstLoad = false;
        //
        [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_ACCOUNT", @"")];
        //
        [self loadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if([segue.identifier isEqualToString:@"SegueToChangePassword"])
    {
        VC_ResetPassword *vc_reset = [segue destinationViewController];
        vc_reset.user = userModificado;
        
    }else if ([segue.identifier isEqualToString:@"SegueToDropList"]) {
        
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
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)clickSave:(id)sender
{
    [self.view endEditing:YES];

    //Preenchendo dados do usuário:

        if ([nameTextField.text         isEqualToString:@""]
        || [cpfTextField.text           isEqualToString:@""]
      //  || [cnpjTextField.text          isEqualToString:@""]
        || [rgTextField.text            isEqualToString:@""]
        || [birthdateTextField.text     isEqualToString:@""]
        || [genderTextField.text        isEqualToString:@""]
        || [dddTextField.text           isEqualToString:@""]
        || [phoneTextField.text         isEqualToString:@""]
        || [dddMobileTextField.text     isEqualToString:@""]
        || [mobilePhoneTextField.text   isEqualToString:@""]
        || [zipCodeTextField.text       isEqualToString:@""]
        || [addressTextField.text       isEqualToString:@""]
        || [addressNumberTextField.text isEqualToString:@""]
        || [districtTextField.text      isEqualToString:@""]
        || [cityTextField.text          isEqualToString:@""]
        || [stateTextField.text         isEqualToString:@""]
        ) {

        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_EMPTY_FIELDS", @"") subTitle:NSLocalizedString(@"MESSAGE_REGISTER_EMPTY", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];

    } else if (![emailTextField.text isEqualToString:@""]) {

        if ([ToolBox validationHelper_EmailChecker:emailTextField.text] == tbValidationResult_Disapproved) {

            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMAIL_INVALID", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];

        } else {

            [self fillUserWithTextFieldData];
            //
            [self updateUserData];
        }
    }
}

-(IBAction)clickPasswordChange:(id)sender
{
    [self.view endEditing:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self performSegueWithIdentifier:@"SegueToChangePassword" sender:nil];
}

-(IBAction)clickPhoto:(id)sender
{
    [self.view endEditing:YES];
    
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_PICK_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_TAKE_PHOTO", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }];
    
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
    
    [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_PICK_PHOTO", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PICK_PHOTO", @"") closeButtonTitle:nil duration:0.0] ;
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)keyboardWillAppearAlert
{
    [self.scrollViewBackground scrollRectToVisible:activeTextField.frame animated:YES];
    NSLog(@"keyboardWillAppearAlert-super");
}

- (void)keyboardWillHideAlert
{
    NSLog(@"keyboardWillHideAlert-super");
}

- (void)dropListProtocolDidSelectItem:(NSString*)itemText atIndex:(long)itemIndex
{
    if (activeTextField == genderTextField){
        genderTextField.text = itemText;
        userModificado.gender = itemText;
    }else if (activeTextField == stateTextField){
        stateTextField.text = itemText;
        userModificado.state = itemText;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:NULL];
    //
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:chosenImage];
    cropViewController.delegate = self;
    cropViewController.customAspectRatio = CGSizeMake(1, 1);
    cropViewController.aspectRatioLockEnabled = true;
    cropViewController.aspectRatioPickerButtonHidden = true;
    cropViewController.resetAspectRatioEnabled = false;
    //
    cropViewController.title = NSLocalizedString(@"LABEL_PHOTO_CROP_AVATAR_TITLE", @"");
    //cropViewController.doneButtonTitle = @"";
    //cropViewController.cancelButtonTitle = @"";
    //
    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    // 'image' is the newly cropped version of the original image
    userModificado.profilePic = [ToolBox graphicHelper_NormalizeImage:image maximumDimension:256.0 quality:1.0];
    
    [cropViewController dismissViewControllerAnimated:YES completion:NULL];
    
    photoChanged = true;
    selectedPhoto = true;
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self updateUserPhoto];
    });
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    [cropViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - • TEXT FIELD DELEGATE

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    //[self.scrollViewBackground scrollRectToVisible:activeTextField.frame animated:YES];
    
    if (textField == genderTextField || textField == stateTextField) {
        
        [self.view endEditing:YES];
        [self performSegueWithIdentifier:@"SegueToDropList" sender:nil];
        
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
    
    if ((textField == cpfTextField) || (textField == cnpjTextField)|| (textField == rgTextField)||(textField == zipCodeTextField) || (textField == dddTextField) || (textField == dddMobileTextField) || (textField == phoneTextField) || (textField == mobilePhoneTextField)) {
        
        NSString *mask = @"";
        
        //99.999.999/9999-99"
        
        if (textField == self.cpfTextField) {
            mask = @"###.###.###-##";
        }
        else if (textField == self.cnpjTextField) {
            mask = @"##.###-###/####-##";
        }
        
        else if (textField == self.rgTextField) {
            mask = @"##.###-###-##";
        }
        
        else if (textField == self.zipCodeTextField) {
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
    //activeTextField = nil;
    
    if (textField == self.nameTextField) {
        self.userModificado.name = self.nameTextField.text;
    }
    else if (textField == self.emailTextField) {
        self.userModificado.email = self.emailTextField.text;
    }
    else if (textField == self.cpfTextField) {
        self.userModificado.CPF = self.cpfTextField.text;
    }
    else if (textField == self.cnpjTextField) {
        self.userModificado.CNPJ = self.cnpjTextField.text;
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
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

-(void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];

    //Background
    imgBackground.backgroundColor = [UIColor clearColor];
    
    // Scroll
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollViewBackground.contentInset = contentInsets;
    self.scrollViewBackground.scrollIndicatorInsets = contentInsets;
    
    //Buttons:
    //Save
    [btnSave setBackgroundColor:[UIColor clearColor]];
    [btnSave.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    [btnSave setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSave.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnSave setTitle:NSLocalizedString(@"BUTTON_TITLE_ACCOUNT_SAVE", @"") forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSave setExclusiveTouch:YES];
    //Password
    btnChangePassword.backgroundColor = [UIColor clearColor];
    [btnChangePassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChangePassword.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    [btnChangePassword setTitle:NSLocalizedString(@"BUTTON_TITLE_CHANGE_PASSWORD", @"") forState:UIControlStateNormal];
    [btnChangePassword setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnChangePassword.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [btnChangePassword setExclusiveTouch:YES];
    //Photo
    [btnNavPhoto setBackgroundColor:[UIColor clearColor]];
    btnNavPhoto.layer.cornerRadius = btnNavPhoto.bounds.size.width/2;
    btnNavPhoto.layer.masksToBounds = YES;
    btnNavPhoto.layer.borderColor = AppD.styleManager.colorPalette.backgroundNormal.CGColor;
    btnNavPhoto.layer.borderWidth = 2.0;
    btnNavPhoto.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [btnNavPhoto setClipsToBounds:YES];
    [btnNavPhoto setExclusiveTouch:YES];
    [btnNavPhoto setTitle:@"" forState:UIControlStateNormal];
    
    //TextFields & Labels
    nameTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_NAME", @"")];
    cpfTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_CPF", @"")];
    cnpjTextField.placeholder = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PLACEHOLDER_CNPJ", @"")];
    rgTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_RG", @"")];
    birthdateTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_BIRTHDATE", @"")];
    dddTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_DDD", @"")];
    dddMobileTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_DDD", @"")];
    phoneTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_PHONE_FIX", @"")];
    mobilePhoneTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_MOBILE_PHONE", @"")];
    genderTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_GENDER", @"")];
    emailTextField.placeholder = NSLocalizedString(@"PLACEHOLDER_EMAIL", @"");
    addressTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_ADDRESS", @"")];
    addressNumberTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_NUMBER", @"")];
    complementTextField.placeholder = NSLocalizedString(@"PLACEHOLDER_ADJUNCT", @"");
    districtTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_DISTRICT", @"")];
    cityTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_CITY", @"")];
    stateTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_UF", @"")];
    zipCodeTextField.placeholder = [NSString stringWithFormat:@"%@*", NSLocalizedString(@"PLACEHOLDER_ZIPCODE", @"")];
    
    [nameTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [cpfTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [cnpjTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [rgTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [birthdateTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [dddTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [phoneTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [dddMobileTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [mobilePhoneTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [genderTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [emailTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [addressTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [addressNumberTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [complementTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [districtTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [cityTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [stateTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [zipCodeTextField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    
    nameTextField.delegate = self;
    cpfTextField.delegate = self;
    cnpjTextField.delegate = self;
    rgTextField.delegate = self;
    genderTextField.delegate = self;
    birthdateTextField.delegate = self;
    dddTextField.delegate = self;
    phoneTextField.delegate = self;
    dddMobileTextField.delegate = self;
    mobilePhoneTextField.delegate = self;
    emailTextField.delegate = self;
    addressTextField.delegate = self;
    addressNumberTextField.delegate = self;
    complementTextField.delegate = self;
    zipCodeTextField.delegate = self;
    districtTextField.delegate = self;
    cityTextField.delegate = self;
    stateTextField.delegate = self;
    
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cpfTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    rgTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cnpjTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobilePhoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    complementTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    districtTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    zipCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImageView *arrowImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(emailTextField.frame.size.width - 30.0, 0, 30.0, emailTextField.frame.size.height)];
    UIImageView *arrowImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(emailTextField.frame.size.width - 30.0, 0, 30.0, emailTextField.frame.size.height)];
    arrowImage1.tintColor = [UIColor grayColor];
    arrowImage2.tintColor = [UIColor grayColor];
    arrowImage1.image = [[UIImage imageNamed:@"icon-down-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    arrowImage2.image = [[UIImage imageNamed:@"icon-down-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [arrowImage1 setContentMode:UIViewContentModeScaleAspectFit];
    [arrowImage2 setContentMode:UIViewContentModeScaleAspectFit];
    [genderTextField setRightViewMode:UITextFieldViewModeAlways];
    [stateTextField setRightViewMode:UITextFieldViewModeAlways];
    genderTextField.rightView = arrowImage1;
    stateTextField.rightView = arrowImage2;
    
    cpfTextField.inputAccessoryView = [self createAcessoryViewWithTarget:cpfTextField andSelector:@selector(resignFirstResponder)];
    rgTextField.inputAccessoryView = [self createAcessoryViewWithTarget:rgTextField andSelector:@selector(resignFirstResponder)];
      cnpjTextField.inputAccessoryView = [self createAcessoryViewWithTarget:cnpjTextField andSelector:@selector(resignFirstResponder)];
    birthdateTextField.inputAccessoryView = [self createAcessoryViewWithTarget:birthdateTextField andSelector:@selector(resignFirstResponder)];
    dddTextField.inputAccessoryView = [self createAcessoryViewWithTarget:dddTextField andSelector:@selector(resignFirstResponder)];
    dddMobileTextField.inputAccessoryView = [self createAcessoryViewWithTarget:dddMobileTextField andSelector:@selector(resignFirstResponder)];
    phoneTextField.inputAccessoryView = [self createAcessoryViewWithTarget:phoneTextField andSelector:@selector(resignFirstResponder)];
    mobilePhoneTextField.inputAccessoryView = [self createAcessoryViewWithTarget:mobilePhoneTextField andSelector:@selector(resignFirstResponder)];
    addressNumberTextField.inputAccessoryView = [self createAcessoryViewWithTarget:addressNumberTextField andSelector:@selector(resignFirstResponder)];
    zipCodeTextField.inputAccessoryView = [self createAcessoryViewWithTarget:zipCodeTextField andSelector:@selector(resignFirstResponder)];
    
    genderTextField.tag = 0;
    stateTextField.tag = 1;
    
    UIDatePicker *datePicker = [UIDatePicker new];
    [datePicker setMaximumDate:[NSDate date]];
    if (AppD.loggedUser.birthdate != nil){
        [datePicker setDate:AppD.loggedUser.birthdate];
    }else{
        [datePicker setDate:[NSDate date]];
    }
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [birthdateTextField setInputView:datePicker];
    
    //scvBackground.alpha = 0.0;
}

- (void)updateUserPhoto
{
    if(userModificado.profilePic != nil){ //} && ![userModificado.urlProfilePic isEqualToString:@""]){
        [btnNavPhoto setBackgroundImage:userModificado.profilePic forState:UIControlStateNormal];
    }
    else{
        [btnNavPhoto setBackgroundImage: [UIImage imageNamed:@"button-background-camera"] forState:UIControlStateNormal];
    }
}

- (void)loadData
{
    [self fillTextFieldsAndLabelsWith:self.userEstatico];
    //
    [self updateUserPhoto];
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

-(void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)birthdateTextField.inputView;
    birthdateTextField.text = [ToolBox dateHelper_StringFromDate:picker.date withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
}

- (void)freeAddressFields
{
    addressTextField.text = @"";
    [addressTextField setEnabled:YES];
    [addressTextField setTextColor:[UIColor darkTextColor]];
    //
    districtTextField.text = @"";
    [districtTextField setEnabled:YES];
    [districtTextField setTextColor:[UIColor darkTextColor]];
    //
    cityTextField.text = @"";
    [cityTextField setEnabled:YES];
    [cityTextField setTextColor:[UIColor darkTextColor]];
    //
    stateTextField.text = @"";
    [stateTextField setEnabled:YES];
    [stateTextField setTextColor:[UIColor darkTextColor]];
}

- (void)fillTextFieldsAndLabelsWith:(User*)userData
{
    //CPF
    self.cpfTextField.text = [ToolBox textHelper_UpdateMaskToText:userData.CPF usingMask:@"###.###.###-##"];
    //CNPJ
    //99.999.999/9999-99"
    self.cnpjTextField.text = [ToolBox textHelper_UpdateMaskToText:userData.CPF usingMask:@"##.###.###-###-##"];
    //Nome
    //Nome
    self.nameTextField.text = userData.name;
    //RG
    self.rgTextField.text = [ToolBox textHelper_UpdateMaskToText:userData.RG usingMask:@"##.###.###-#"];
    //CNPJ
   // self.cnpjTextField.text = userData.CNPJ;
    //Data Nascimento
    self.birthdateTextField.text = [ToolBox dateHelper_StringFromDate:userData.birthdate withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
    //Sexo
    self.genderTextField.text = userData.gender;
    //DDD - Telefone
    self.dddTextField.text = userData.phoneDDD;
    //Telefone
    self.phoneTextField.text = [ToolBox textHelper_UpdateMaskToText:userData.phone usingMask:@"####-####"];
    //DDD - Celular
    self.dddMobileTextField.text = userData.mobilePhoneDDD;
    //Celular
    self.mobilePhoneTextField.text = [ToolBox textHelper_UpdateMaskToText:userData.mobilePhone usingMask:@"#####-####"];
    //Email
    self.emailTextField.text = userData.email;
    //CEP
    self.zipCodeTextField.text = [ToolBox textHelper_UpdateMaskToText:userData.zipCode usingMask:@"##.###-###"];
    //Rua
    self.addressTextField.text = userData.address;
    //Número
    self.addressNumberTextField.text = userData.addressNumber;
    //Complemento
    self.complementTextField.text = userData.complement;
    //Bairro
    self.districtTextField.text = userData.district;
    //Cidade
    self.cityTextField.text = userData.city;
    //Estado
    self.stateTextField.text = userData.state;
    
    //Avatar
    if (userData.profilePic == nil){
        
        [btnNavPhoto setBackgroundImage: [UIImage imageNamed:@"button-background-camera"] forState:UIControlStateNormal];
        
        if (userData.urlProfilePic != nil && ![userData.urlProfilePic isEqualToString:@""]){
            
            [[[AsyncImageDownloader alloc] initWithMediaURL:userData.urlProfilePic successBlock:^(UIImage *image) {
                
                if (image != nil){
                    //Sempre atualiza o usuário 'volátil'
                    self.userModificado.profilePic = image;
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                        [btnNavPhoto setBackgroundImage:image forState:UIControlStateNormal];
                    });
                    
                    //Não registar neste momento"
                    //AppD.loggedUser.profilePic = image;
                    //NSDictionary *temp = [AppD.loggedUser dictionaryJSON];
                    //[AppD registerLoginForUser:AppD.loggedUser.email data: [temp valueForKey:@"app_user"]];
                }
                
            } failBlock:^(NSError *error) {
                NSLog(@"Erro ao buscar imagem: %@", error.domain);
            }]startDownload];
            
        }else{
            [btnNavPhoto setBackgroundImage: [UIImage imageNamed:@"button-background-camera"] forState:UIControlStateNormal];
        }
    }else{
        [btnNavPhoto setBackgroundImage:userData.profilePic forState:UIControlStateNormal];
    }
    
}

- (void)fillUserWithTextFieldData
{
    //CPF
    self.userModificado.CPF = [self clearMask:self.cpfTextField.text];
    //Nome
    self.userModificado.name = self.nameTextField.text;
    //RG
    self.userModificado.RG = self.rgTextField.text;
    //CNPJ
    self.userModificado.CNPJ = self.cnpjTextField.text;
    //Data Nascimento
    self.userModificado.birthdate = [ToolBox dateHelper_DateFromString:self.birthdateTextField.text withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
    //Sexo
    self.userModificado.gender = [self.genderTextField.text isEqualToString:@""] ? @"" : self.genderTextField.text; //([self.genderTextField.text isEqualToString:NSLocalizedString(@"PLACEHOLDER_GENDER_MALE", @"")] ? @"MALE" : ([self.genderTextField.text isEqualToString:NSLocalizedString(@"PLACEHOLDER_GENDER_FEMALE", @"")] ? @"FEMALE" : @""));
    //DDD - Telefone
    self.userModificado.phoneDDD = self.dddTextField.text;
    //Telefone
    self.userModificado.phone = [self clearMask:self.phoneTextField.text];
    //DDD - Celular
    self.userModificado.mobilePhoneDDD = self.dddMobileTextField.text;
    //Celular
    self.userModificado.mobilePhone = [self clearMask:self.mobilePhoneTextField.text];
    //Email
    self.userModificado.email = self.emailTextField.text;
    //CEP
    self.userModificado.zipCode = [self clearMask:self.zipCodeTextField.text];
    //Rua
    self.userModificado.address = self.addressTextField.text;
    //Número
    self.userModificado.addressNumber = self.addressNumberTextField.text;
    //Complemento
    self.userModificado.complement = self.complementTextField.text;
    //Bairro
    self.userModificado.district = self.districtTextField.text;
    //Cidade
    self.userModificado.city = self.cityTextField.text;
    //Estado
    self.userModificado.state = self.stateTextField.text;
    //Avatar
    //Se houver alteração o objeto usuário modificado neste ponto já possui a imagem atualizada
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

#pragma mark - Connection

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
                        addressTextField.text = [NSString stringWithFormat:@"%@", [response objectForKey:@"logradouro"]];
                        [addressTextField setEnabled:NO];
                        [addressTextField setTextColor:[UIColor grayColor]];
                    }else{
                        addressTextField.text = @"";
                        [addressTextField setEnabled:YES];
                        [addressTextField setTextColor:[UIColor darkTextColor]];
                    }
                    //
                    if ([allKeys containsObject:@"bairro"]){
                        districtTextField.text = [NSString stringWithFormat:@"%@", [response objectForKey:@"bairro"]];
                        [districtTextField setEnabled:NO];
                        [districtTextField setTextColor:[UIColor grayColor]];
                    }else{
                        districtTextField.text = @"";
                        [districtTextField setEnabled:YES];
                        [districtTextField setTextColor:[UIColor darkTextColor]];
                    }
                    //
                    if ([allKeys containsObject:@"localidade"]){
                        cityTextField.text = [NSString stringWithFormat:@"%@", [response objectForKey:@"localidade"]];
                        [cityTextField setEnabled:NO];
                        [cityTextField setTextColor:[UIColor grayColor]];
                    }else{
                        cityTextField.text = @"";
                        [cityTextField setEnabled:YES];
                        [cityTextField setTextColor:[UIColor darkTextColor]];
                    }
                    //
                    if ([allKeys containsObject:@"uf"]){
                        stateTextField.text = [NSString stringWithFormat:@"%@", [response objectForKey:@"uf"]];
                        [stateTextField setEnabled:NO];
                        [stateTextField setTextColor:[UIColor grayColor]];
                    }else{
                        stateTextField.text = @"";
                        [stateTextField setEnabled:YES];
                        [stateTextField setTextColor:[UIColor darkTextColor]];
                    }
                    
                }else{
                    
                    NSLog(@"getAddressByZipCode > CEP não encontrado.");
                    
                    [self freeAddressFields];
                }
            }
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        }];
    }
    
}

- (void)updateUserData
{
    if(![userModificado isEqualToObject:userEstatico] || photoChanged)
    {
        ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
        
        if ([connectionManager isConnectionActive])
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Updating];
            });
            
            NSDictionary *dicParameters = [userModificado dictionaryJSON];
       
            [connectionManager updateUserUsingParametersWithoudID:dicParameters withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
                
                if (error){
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    //
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_UPDATE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }
                else
                {
                    photoChanged = false;
                    selectedPhoto = false;
                    
                    User *updatedUser = [User createObjectFromDictionary:response];
                    
                    bool needUpdateMainMenu = false;
                    
                    if (updatedUser.urlProfilePic != nil && ![updatedUser.urlProfilePic isEqualToString:@""] && ![userModificado.urlProfilePic isEqualToString:updatedUser.urlProfilePic]){
                        
                        NSURL *url = [NSURL URLWithString:(updatedUser.urlProfilePic)];
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        updatedUser.profilePic = [UIImage imageWithData: data];
                        //
                        needUpdateMainMenu = true;
                    }else{
                        
                        if ([userModificado.urlProfilePic isEqualToString:updatedUser.urlProfilePic] && userModificado.profilePic != nil){
                            //updatedUser.profilePic = userModificado.profilePic;
                            updatedUser.profilePic = [UIImage imageWithData:UIImagePNGRepresentation(userModificado.profilePic)];
                        }
                    }
                    
                    [AppD registerLoginForUser:updatedUser.email data:[[updatedUser dictionaryJSON] valueForKey:@"app_user"]];
                    
                    if (needUpdateMainMenu){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_LAYOUT_PROFILE_PIC_USER_UPDATED object:nil userInfo:response];
                        });
                    }
                    
                    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                    
                    SCLAlertView *alert = [AppD createDefaultAlert];
                    [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") actionBlock:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert showSuccess:self title:NSLocalizedString(@"ALERT_TITLE_SUCCESS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_UPDATE_SUCCESS", @"") closeButtonTitle:nil duration:0.0];
                }
            }];
        }
        else
        {
            SCLAlertView *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_NO_CHANGES", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CHANGES", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

@end

