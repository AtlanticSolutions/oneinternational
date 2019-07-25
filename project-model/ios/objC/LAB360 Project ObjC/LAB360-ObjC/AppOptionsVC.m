//
//  AppOptionsVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT

#import <MessageUI/MFMailComposeViewController.h>
//
#import "AppOptionsVC.h"
#import "AppDelegate.h"
#import "AppOptionItem.h"
#import "AppOptionItemTVC.h"
#import "AppOptionPermissionsVC.h"
#import "BiometricAuthentication.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AppOptionsVC()<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

//Data:
@property(nonatomic, strong) NSMutableArray<AppOptionItem*> *optionsList;

//Layout:
@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UITableView *tvOptions;

@end

#pragma mark - • IMPLEMENTATION
@implementation AppOptionsVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize optionsList;
@synthesize lblTitle, tvOptions;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tvOptions.delegate = self;
    tvOptions.dataSource = self;
    
    [tvOptions registerNib:[UINib nibWithNibName:@"AppOptionItemTVC" bundle:nil] forCellReuseIdentifier:@"AppOptionItemCell"];
    [tvOptions setTableFooterView:[UIView new]];
    
    [self loadPersonalizedAppOptions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_APP_OPTIONS", @"")];
    
    [tvOptions setAlpha:0.0];
    [tvOptions reloadData];
    
    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
        [tvOptions setAlpha:1.0];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];

    if ([segue.identifier isEqualToString:@"SegueToPermissions"]){
        AppOptionPermissionsVC *vc = segue.destinationViewController;
        vc.showAppMenu = NO;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToRegionMonitoring"]){
        return;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToTimelineOptions"]){
        return;
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionSwitchChangeValue:(UISwitch*)sender
{
    AppOptionItem *item = [optionsList objectAtIndex:sender.tag];
    AppOptionItemTVC *cell = (AppOptionItemTVC*)[tvOptions cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    
    if (item.status == AppOptionItemStatusSwitchable){
        item.on = sender.on;
    }
    
    //Identificação da opção:
    if (item.identification == AppOptionItemIdentificationSounds){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        //NSString *key = [NSString stringWithFormat:@"%@%i", APP_OPTION_KEY_SOUNDEFFECTS_STATUS, AppD.loggedUser.userID];
        NSString *key = APP_OPTION_KEY_SOUNDEFFECTS_STATUS;
        [userDefault setBool:item.on forKey:key];
        [userDefault synchronize];
        //
        [AppD.soundManager updateConfigurationWithSoundEnabled:item.on];
        //
        [AppD.soundManager playSound:SoundMediaNameDamEffect withVolume:1.0];
    }
    
    //Atualização da tela:
    dispatch_async(dispatch_get_main_queue(), ^{
        if (item.on){
            cell.lblDescription.text = item.switchableONDescription;
        }else{
            cell.lblDescription.text = item.switchableOFFDescription;
        }
    });
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error;
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent){
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showSuccess:NSLocalizedString(@"SCREEN_TITLE_CONTACT", @"") subTitle:NSLocalizedString(@"LABEL_APP_OPTIONS_CONTACT_EMAIL_FEEDBACK", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return optionsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"AppOptionItemCell";
    AppOptionItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    if(cell == nil){
        cell = [[AppOptionItemTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    AppOptionItem *currentItem = [optionsList objectAtIndex:indexPath.row];
    
    switch (currentItem.status) {
        case AppOptionItemStatusSelection:{
            [cell setupLayoutForType:AppOptionItemCellTypeNone];
            cell.lblDescription.text = currentItem.selectionDescription;
        }break;
            
        case AppOptionItemStatusDestination:{
            [cell setupLayoutForType:AppOptionItemCellTypeArrow];
            cell.lblDescription.text = currentItem.destinationDescription;
        }break;
            
        case AppOptionItemStatusSwitchable:{
            [cell setupLayoutForType:AppOptionItemCellTypeSwitch];
            if (currentItem.on){
                cell.lblDescription.text = currentItem.switchableONDescription;
            }else{
                cell.lblDescription.text = currentItem.switchableOFFDescription;
            }
            cell.swtOption.on = currentItem.on;
            cell.swtOption.tag = indexPath.row;
            [cell.swtOption addTarget:self action:@selector(actionSwitchChangeValue:) forControlEvents:UIControlEventValueChanged];
        }break;
    }

    cell.lblTitle.text = currentItem.title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0)
    {
        tableView.tag = 1;
        AppOptionItemTVC *cell = (AppOptionItemTVC*)[tableView cellForRowAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion: ^(BOOL finished) {
            [self resolveOptionSelectionWith:indexPath.row];
            tableView.tag = 0;
        }];
    }
}
                       
#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor whiteColor];
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NORMAL]];
    lblTitle.text = NSLocalizedString(@"LABEL_APP_OPTIONS_TITLE", @"");
    
    tvOptions.backgroundColor = [UIColor whiteColor];
}

- (void)loadPersonalizedAppOptions
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    optionsList = [NSMutableArray new];
    
    // Tutoriais ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusSelection;
        item.identification = AppOptionItemIdentificationTutorial;
        item.title = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_TUTORIAL_MAIN", @"");
        item.selectionDescription = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_TUTORIAL_A", @"");
        item.destinationDescription = @"";
        item.switchableONDescription = @"";
        item.switchableOFFDescription = @"";
        item.blocked = NO;
        //
        [optionsList addObject:item];
    }
    
    // Segurança ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusSelection;
        item.identification = AppOptionItemIdentificationSecurity;
        item.title = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_SECURITY_MAIN", @"");
        item.selectionDescription = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_SECURITY_A", @"");
        item.destinationDescription = @"";
        item.switchableONDescription = @"";
        item.switchableOFFDescription = @"";
        item.blocked = NO;
        //
        [optionsList addObject:item];
    }
    
    // Permissões ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusDestination;
        item.identification = AppOptionItemIdentificationPermission;
        item.title = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_PERMISSIONS_MAIN", @"");
        item.selectionDescription = @"";
        item.destinationDescription = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_PERMISSIONS_A", @"");
        item.switchableONDescription = @"";
        item.switchableOFFDescription = @"";
        item.blocked = NO;
        //
        [optionsList addObject:item];
    }
    
    // Sons ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusSwitchable;
        item.identification = AppOptionItemIdentificationSounds;
        item.title = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_SOUNDS_MAIN", @"");
        item.selectionDescription = @"";
        item.destinationDescription = @"";
        item.switchableONDescription = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_SOUNDS_A", @"");
        item.switchableOFFDescription = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_SOUNDS_B", @"");
        item.blocked = NO;
        //
        //NSString *key = [NSString stringWithFormat:@"%@%i", APP_OPTION_KEY_SOUNDEFFECTS_STATUS, AppD.loggedUser.userID];
        NSString *key = APP_OPTION_KEY_SOUNDEFFECTS_STATUS;
        item.on = [userDefaults boolForKey:key];
        //
        [optionsList addObject:item];
    }
    
    // Timeline ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusDestination;
        item.identification = AppOptionItemIdentificationTimeline;
        item.title = @"Timeline (Menu Principal)";
        item.selectionDescription = @"";
        item.destinationDescription = @"Configurações da Timeline";
        item.switchableONDescription = @"";
        item.switchableOFFDescription = @"";
        item.blocked = NO;
        //
        [optionsList addObject:item];
    }
    
    // Linguagem ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusDestination;
        item.identification = AppOptionItemIdentificationLanguage;
        item.title = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_LANGUAGE_MAIN", @"");
        item.selectionDescription = @"";
        item.destinationDescription = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_LANGUAGE_A", @"");
        item.switchableONDescription = @"";
        item.switchableOFFDescription = @"";
        item.blocked = NO;
        //
        [optionsList addObject:item];
    }
    
    // Geofence ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusDestination;
        item.identification = AppOptionItemIdentificationGeofence;
        item.title = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_GEOFENCE_MAIN", @"");
        item.selectionDescription = @"";
        item.destinationDescription = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_GEOFENCE_A", @"");
        item.switchableONDescription = @"";
        item.switchableOFFDescription = @"";
        item.blocked = NO;
        //
        [optionsList addObject:item];
    }
    
    // Entre em Contato ===========================================================================================================================
    {
        AppOptionItem *item = [AppOptionItem new];
        item.status = AppOptionItemStatusSelection;
        item.identification = AppOptionItemIdentificationContact;
        item.title = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_CONTACTS_MAIN", @"");
        item.selectionDescription = NSLocalizedString(@"LABEL_APP_OPTIONS_ITEM_CONTACTS_A", @"");
        item.destinationDescription = @"";
        item.switchableONDescription = @"";
        item.switchableOFFDescription = @"";
        item.blocked = NO;
        //
        [optionsList addObject:item];
    }
    
}

- (void)resolveOptionSelectionWith:(NSInteger)selectedItemIndex
{
    AppOptionItem *selectedItem = [optionsList objectAtIndex:selectedItemIndex];
    
    switch (selectedItem.identification) {
        case AppOptionItemIdentificationGeneric:{
            //nothing...
        }break;
            
        case AppOptionItemIdentificationTutorial:{
            [self resolveTutorialInteraction];
        }break;
           
        case AppOptionItemIdentificationSecurity:{
            [self resolveSecurityInteraction];
        }break;
        
        case AppOptionItemIdentificationPermission:{
            [self resolvePermissionInteraction];
        }break;
            
        case AppOptionItemIdentificationSounds:{
            //O controle de som é feito pela action do switch na célula.
        }break;
            
        case AppOptionItemIdentificationTimeline:{
            [self resolveTimelineInteraction];
        }break;
            
        case AppOptionItemIdentificationLanguage:{
            [self resolveLanguageInteraction];
        }break;
            
        case AppOptionItemIdentificationGeofence:{
            [self resolveGeofenceInteraction];
        }break;
            
        case AppOptionItemIdentificationContact:{
            [self resolveContactInteraction];
        }break;
    }
}

- (void)resolveTutorialInteraction
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_RESET", @"") withType:SCLAlertButtonType_Destructive actionBlock:^{
        
        [self showActivityIndicatorView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //Resetando todos os tutoriais exibidos pelo aplicativo ==============================================================
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            //Dica showcase:
            NSString *key1 = [NSString stringWithFormat:@"%@%i", APP_OPTION_KEY_SHOWCASE_TIP_MASKUSER, AppD.loggedUser.userID];
            [userDefaults setBool:NO forKey:key1];
            
            //Tutorial 3D Viewer - AR:
            NSString *key2 = [NSString stringWithFormat:@"%@%i", APP_OPTION_KEY_3DVIEWER_TIP_AR, AppD.loggedUser.userID];
            [userDefaults setBool:NO forKey:key2];
            
            //Others here...
            
            [userDefaults synchronize];
            
            [self hideActivityIndicatorView];
        });
        
    }];
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
    [alert showQuestion:NSLocalizedString(@"ALERT_TITLE_APP_OPTIONS_RESET_TUTORIALS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_APP_OPTIONS_RESET_TUTORIALS", @"") closeButtonTitle:nil duration:0.0];
}

- (void)resolveSecurityInteraction
{
    NSString *userID = [NSString stringWithFormat:@"user%i", AppD.loggedUser.userID];
    BiometricType type = [BiometricAuthentication biometricTypeAvailable];
    UIImage *lock = [ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:[UIImage imageNamed:@"BeaconMenuLock"]];
    UIImage *unlock = [ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:[UIImage imageNamed:@"BeaconMenuUnlock"]];
    
    switch (type) {
        case BiometricTypeNone:{
            
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:@"Erro" subTitle:@"Este aplicativo não tem acesso ao sistema de autenticação biométrica.\nO mesmo pode estar desabilitado ou não ser compatível com este dispositivo." closeButtonTitle:@"OK" duration:0.0];
            
        }break;
        
        case BiometricTypeTouchID:{
            
            BOOL enabled = [BiometricAuthentication getAppProtectionStatusForUserIdentifier:userID];
            if (enabled){
                SCLAlertViewPlus *alert = [AppD createDefaultRichAlert:nil images:@[[UIImage imageNamed:@"BiometricAuthenticationTouchID"]] animationTimePerFrame:0.0];
                [alert addButton:@"Desabilitar" withType:SCLAlertButtonType_Destructive actionBlock:^{
                    [BiometricAuthentication setAppProtectionStatus:NO forUserIdentifier:userID];
                }];
                [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
                [alert showCustom:lock color:AppD.styleManager.colorPalette.backgroundNormal title:@"TouchID" subTitle:@"A proteção por TouchID está habilitada. Ao abrir o app será solicitada a autenticação biométrica." closeButtonTitle:nil duration:0.0];
            }else{
                SCLAlertViewPlus *alert = [AppD createDefaultRichAlert:nil images:@[[UIImage imageNamed:@"BiometricAuthenticationTouchID"]] animationTimePerFrame:0.0];
                [alert addButton:@"Habilitar" withType:SCLAlertButtonType_Normal actionBlock:^{
                    [BiometricAuthentication setAppProtectionStatus:YES forUserIdentifier:userID];
                }];
                [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
                [alert showCustom:unlock color:AppD.styleManager.colorPalette.backgroundNormal title:@"TouchID" subTitle:@"A proteção por TouchID está desabilitada." closeButtonTitle:nil duration:0.0];
            }
            
        }break;
            
        case BiometricTypeFaceID:{
            
            BOOL enabled = [BiometricAuthentication getAppProtectionStatusForUserIdentifier:userID];
            if (enabled){
                SCLAlertViewPlus *alert = [AppD createDefaultRichAlert:nil images:@[[UIImage imageNamed:@"BiometricAuthenticationFaceID"]] animationTimePerFrame:0.0];
                [alert addButton:@"Desabilitar" withType:SCLAlertButtonType_Destructive actionBlock:^{
                    [BiometricAuthentication setAppProtectionStatus:NO forUserIdentifier:userID];
                }];
                [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
                [alert showCustom:lock color:AppD.styleManager.colorPalette.backgroundNormal title:@"FaceID" subTitle:@"A proteção por FaceID está habilitada. Ao abrir o app será solicitada a autenticação biométrica." closeButtonTitle:nil duration:0.0];
            }else{
                SCLAlertViewPlus *alert = [AppD createDefaultRichAlert:nil images:@[[UIImage imageNamed:@"BiometricAuthenticationFaceID"]] animationTimePerFrame:0.0];
                [alert addButton:@"Habilitar" withType:SCLAlertButtonType_Normal actionBlock:^{
                    [BiometricAuthentication setAppProtectionStatus:YES forUserIdentifier:userID];
                }];
                [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
                [alert showCustom:unlock color:AppD.styleManager.colorPalette.backgroundNormal title:@"FaceID" subTitle:@"A proteção por FaceID está desabilitada." closeButtonTitle:nil duration:0.0];
            }
            
        }break;
    }
}

- (void)resolvePermissionInteraction
{
    [self performSegueWithIdentifier:@"SegueToPermissions" sender:nil];
}

- (void)resolveTimelineInteraction
{
    [self performSegueWithIdentifier:@"SegueToTimelineOptions" sender:nil];
}

- (void)resolveLanguageInteraction
{
    [self performSegueWithIdentifier:@"SegueToLanguage" sender:nil];
}

- (void)resolveGeofenceInteraction
{
    [self performSegueWithIdentifier:@"SegueToRegionMonitoring" sender:nil];
}

- (void)resolveContactInteraction
{
    if ([MFMailComposeViewController canSendMail]) {
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"LABEL_APP_OPTIONS_CONTACT_EMAIL_1", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
            [self sendMailWithSubject:NSLocalizedString(@"LABEL_APP_OPTIONS_CONTACT_EMAIL_1", @"")];
        }];
        [alert addButton:NSLocalizedString(@"LABEL_APP_OPTIONS_CONTACT_EMAIL_2", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
            [self sendMailWithSubject:NSLocalizedString(@"LABEL_APP_OPTIONS_CONTACT_EMAIL_2", @"")];
        }];
        [alert addButton:NSLocalizedString(@"LABEL_APP_OPTIONS_CONTACT_EMAIL_3", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
            [self sendMailWithSubject:NSLocalizedString(@"LABEL_APP_OPTIONS_CONTACT_EMAIL_3", @"")];
        }];
        [alert addButton:NSLocalizedString(@"LABEL_APP_OPTIONS_CONTACT_EMAIL_4", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
            [self sendMailWithSubject:NSLocalizedString(@"LABEL_APP_OPTIONS_CONTACT_EMAIL_4", @"")];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        [alert showInfo:NSLocalizedString(@"SCREEN_TITLE_CONTACT", @"") subTitle:NSLocalizedString(@"LABEL_APP_OPTIONS_CONTACT_EMAIL_MESSAGE", @"") closeButtonTitle:nil duration:0.0];
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_EMAIL_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMAIL_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    
}

#pragma mark - UTILS (General Use)

- (void)sendMailWithSubject:(NSString*)subject
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    [controller setSubject:subject];
    [controller setToRecipients:@[@"erico.teixeira@lab360.com.br"]]; //TODO: precisa de um email específico para esta função
    [controller setMessageBody:@"Deixe aqui sua mensagem: \n" isHTML:NO];
    
    if (controller){
        [self presentViewController:controller animated:YES completion:nil];
    }
}
@end
