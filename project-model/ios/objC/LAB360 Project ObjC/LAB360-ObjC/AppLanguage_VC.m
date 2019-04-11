//
//  AppLanguage_VC.m
//  LAB360-Dev
//
//  Created by Rodrigo Baroni on 23/08/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//


#pragma mark - • HEADER IMPORT
#import "AppLanguage_VC.h"
#import "AppDelegate.h"
#import "Localisator.h"
#import "ToolBox.h"
#import "SCLAlertViewPlus.h"
#import "AppOptionLanguageItemTVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AppLanguage_VC()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableViewLanguages;
//
@property NSArray * arrayOfLanguages;
@property NSString *modelPhone;

@end

#pragma mark - • IMPLEMENTATION
@implementation AppLanguage_VC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize modelPhone;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    
    [self.tableViewLanguages setTableFooterView:[UIView new]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    [self configureViewFromLocalisation];
    
    self.navigationItem.rightBarButtonItem = [self createHelpButton];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    if ([segue.identifier isEqualToString:@"???"]){
//        AppOptionsVC *vc = segue.destinationViewController;
//    }
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

-(void)configureViewFromLocalisation
{
    //NSString * currentLanguageChoice = [[Localisator sharedInstance] currentLanguage];
    
    [self setupLayout:LOCALIZATION(@"TITLE_CONFIGURANTION_LANGUAGE")];
    [self.tableViewLanguages  reloadData];
    //
    modelPhone = [ToolBox deviceHelper_Model];
}


#pragma mark - • ACTION METHODS

- (IBAction)actionHelp:(id)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showInfo:@"Linguagem" subTitle:@"O idioma definido no sistema operacional pode ainda não ter suporte no aplicativo.\n\nÉ possível que alguns conteúdos da aplicação não sejam atualizados de imediato após trocar a linguagem (neste caso será preciso reiniciar a aplicação)." closeButtonTitle:@"OK" duration:0.0];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void) receiveLanguageChangedNotification:(NSNotification *) notification
{
    if ([notification.name isEqualToString:kNotificationLanguageChanged])
    {
        [self configureViewFromLocalisation];
    }
}

#pragma mark - UITableViewDataSource protocol conformance

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrayOfLanguages == nil)
        return 0;
    
    return [self.arrayOfLanguages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"MyIdentifier";
    AppOptionLanguageItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    if(cell == nil){
        cell = [[AppOptionLanguageItemTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    NSString * currentLanguageChoice = [[Localisator sharedInstance] currentLanguage];
    NSString * actualLanguage = self.arrayOfLanguages[indexPath.row];
    
    [cell setupLayoutForSelectedItem:[currentLanguageChoice isEqualToString:actualLanguage]];
    
    modelPhone = ToolBox.deviceHelper_Model;
    if ([actualLanguage isEqualToString:@"DeviceLanguageKey_Default"]) {
        if ([modelPhone isEqualToString: @"iPhone X"]){
            cell.imvFlag.image = [UIImage imageNamed:@"iPhoneX"];
        }else {
            cell.imvFlag.image = [UIImage imageNamed:@"iPhone"];
        }
        
        NSString *str = [NSString stringWithFormat:@"%@ (%@)", LOCALIZATION(self.arrayOfLanguages[indexPath.row]), [[ToolBox deviceHelper_SystemLanguage] capitalizedString]];
        cell.lblTitle.text = str;
    } else {
        cell.imvFlag.image = [UIImage imageNamed:self.arrayOfLanguages[indexPath.row]];
        //
        cell.lblTitle.text = LOCALIZATION(self.arrayOfLanguages[indexPath.row]);
    }
    
    //cell.lblTitle.text = LOCALIZATION(self.arrayOfLanguages[indexPath.row]);

    /* Now that the cell is configured we return it to the table view so that it can display it */
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 32.0)];
    view.backgroundColor = [UIColor darkGrayColor];
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, view.frame.size.width - 20.0, 32.0)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.text = LOCALIZATION(@"LABEL_SELECIONAR_IDIOMA");
    //
    [view addSubview:label];
    //
    return view;
}

#pragma mark - UITableViewDelegate protocol conformance

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0)
    {
        tableView.tag = 1;
        AppOptionLanguageItemTVC *cell = (AppOptionLanguageItemTVC*)[tableView cellForRowAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion: ^(BOOL finished) {
            
            NSString * currentLanguageChoice = [[Localisator sharedInstance] currentLanguage];
            NSString * languageSelected = self.arrayOfLanguages[indexPath.row];
            
            if ([currentLanguageChoice isEqualToString:languageSelected])
            {
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [[Localisator sharedInstance] setLanguage:self.arrayOfLanguages[indexPath.row]];
                [alert addButton:LOCALIZATION(@"OK") withType:SCLAlertButtonType_Neutral actionBlock:nil];
                [alert showNotice:LOCALIZATION(@"TITLE_ALERT_LANGUAGE") subTitle:LOCALIZATION(@"TITLE_SAME_LANGUAGE") closeButtonTitle:nil duration:0.0];
                
            }else {
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert addButton:LOCALIZATION(@"TITLE_CONFIRM_BUTTON_ALERT") withType:SCLAlertButtonType_Normal actionBlock:^{
                    [[Localisator sharedInstance] setLanguage:self.arrayOfLanguages[indexPath.row]];
                }];
                [alert addButton:LOCALIZATION(@"TITLE_CANCEL_BUTTON_ALERT") withType:SCLAlertButtonType_Neutral actionBlock:nil];
                [alert showWarning:LOCALIZATION(@"TITLE_ALERT_LANGUAGE") subTitle:LOCALIZATION(@"SUBTITLE_ALERT_LANGUAGE") closeButtonTitle:nil duration:0.0];
            }
            
            tableView.tag = 0;
        }];
    }   
    
}

#pragma mark - UTILS (General Use)

- (UIBarButtonItem*)createHelpButton
{
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.backgroundColor = nil;
    collectionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *img = [[UIImage imageNamed:@"NavControllerHelpIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [collectionButton setImage:img forState:UIControlStateNormal];
    //
    [collectionButton setFrame:CGRectMake(0, 0, 32, 32)];
    [collectionButton setClipsToBounds:YES];
    [collectionButton setExclusiveTouch:YES];
    [collectionButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [collectionButton addTarget:self action:@selector(actionHelp:) forControlEvents:UIControlEventTouchUpInside];
    //
    [collectionButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    //
    [[collectionButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[collectionButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:collectionButton];
}

@end
