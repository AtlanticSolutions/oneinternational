//
//  VC_ResetPassword.m
//  AHK-100anos
//
//  Created by Lucas Correia Granados Castro on 20/10/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//


#pragma mark - • HEADER IMPORT
#import "VC_ResetPassword.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_ResetPassword()

@property (nonatomic, weak) IBOutlet UIScrollView *scvBackground;
@property (nonatomic, weak) UITextField *activeTextField;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_ResetPassword
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES

@synthesize txtNewPass, txtOldPass, txtNewPass2, btnSave, imvBackground, scvBackground, activeTextField;
@synthesize user;

#pragma mark - • CLASS METHODS


#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.navigationItem.rightBarButtonItem = [AppD createProfileButton];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_RESET_PASSWORD", @"");

    txtNewPass2.delegate = self;
    txtNewPass.delegate = self;
    txtOldPass.delegate = self;
    
    [self.view layoutIfNeeded];
    [self updateLayout];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)reset:(id)sender
{
    if([txtNewPass.text isEqualToString:@""] || [txtNewPass2.text isEqualToString:@""])
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_EMPTY_FIELDS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMPTY_FIELDS_GENERAL", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else if(![txtNewPass.text isEqualToString:txtNewPass2.text])
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PASSWORD_MATCH", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else if(txtNewPass2.text.length < 8)
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_PASSWORD_INVALID", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else
    {
        user.password = txtNewPass2.text;
        [self.navigationController popViewControllerAnimated:true];
    }
}


#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scvBackground.contentInset = contentInsets;
    scvBackground.scrollIndicatorInsets = contentInsets;
    //
    [scvBackground scrollRectToVisible:activeTextField.frame animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    scvBackground.contentInset = UIEdgeInsetsZero;
    scvBackground.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void) updateLayout
{
    self.view.backgroundColor = [UIColor clearColor];
    //
    imvBackground.image = [AppD createDefaultBackgroundImage];
    //
    [txtNewPass setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [txtNewPass setSecureTextEntry:true];
    txtNewPass.placeholder = NSLocalizedString(@"PLACEHOLDER_NEW_PASSWORD", @"");
    //
    [txtNewPass2 setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [txtNewPass2 setSecureTextEntry:true];
    txtNewPass2.placeholder = NSLocalizedString(@"PLACEHOLDER_NEW_PASSWORD2", @"");
    //
    [txtOldPass setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:15.0]];
    [txtOldPass setSecureTextEntry:true];
    txtOldPass.placeholder = NSLocalizedString(@"PLACEHOLDER_ACTUAL_PASSWORD", @"");
    //
    [btnSave setBackgroundColor:[UIColor clearColor]];
    //
    btnSave.backgroundColor = [UIColor clearColor];
    [btnSave.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:17.0]];
    [btnSave setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSave.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnSave setTitle:NSLocalizedString(@"BUTTON_TITLE_RESET", @"") forState:UIControlStateNormal];
    [btnSave setTitle:NSLocalizedString(@"BUTTON_TITLE_RESET", @"") forState:UIControlStateHighlighted];
    
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btnSave setExclusiveTouch:true];
}

@end



