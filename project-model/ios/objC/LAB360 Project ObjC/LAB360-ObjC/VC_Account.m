//
//  VC_Account.m
//  AHK-100anos
//
//  Created by Erico GT on 10/5/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_Account.h"
#import "VC_PostsGallery.h"

enum ROWS_ACCOUNT
{
	ROW_PHOTO = 0,
	ROW_NAME,
	ROW_EMAIL,
	ROW_LIST,
	ROW_CITY,
	ROW_STATE,
	ROW_PASSWORD,
	ROW_SAVE,
	ROW_COUNT
};

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_Account()

@property (nonatomic, weak) IBOutlet UIImageView *imgBackground;
@property (nonatomic, weak) IBOutlet UITableView *tbvAccount;
@property (nonatomic, weak) IBOutlet UIButton *btnPassword;
@property (nonatomic, weak) UITextField *activeTextField;

//objetos
@property (nonatomic, strong) User *userModificado;
@property (nonatomic, strong) User *userEstatico;
@property (nonatomic, assign) BOOL escolheuFoto;

//
@property (nonatomic, assign) HiveOfActivityCompany *selected;
@property (nonatomic, strong) NSArray *listState;
@property (nonatomic, strong) NSArray *listCategory;
@property (nonatomic, strong) id selectedItem;
//
@property (nonatomic, assign) Boolean isFirstLoad;
@property (nonatomic, assign) Boolean isState;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_Account
{
#pragma mark - • I_VARS
    
    
    Boolean _photoChanged;
    long _lastTagSelected;
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES

@synthesize imgBackground, tbvAccount, btnPassword;
@synthesize activeTextField;
@synthesize userModificado, userEstatico, escolheuFoto;
@synthesize isFirstLoad, selected, listCategory, listState, isState;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _photoChanged = false;
    
    self.automaticallyAdjustsScrollViewInsets = false;
	
	//Button Profile Pic
	self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
	
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
	[self.navigationItem setHidesBackButton:YES];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_ACCOUNT", @"");
    
    //
    userEstatico = [[User alloc] init];
    userModificado = [[User alloc] init];
    
    userEstatico = [AppD.loggedUser copyObject];
    userModificado = [AppD.loggedUser copyObject];
	
	listState = @[@"AC", @"AL", @"AM", @"AP", @"BA", @"CE", @"DF", @"ES", @"GO", @"MA", @"MT", @"MS", @"MG", @"PA", @"PB", @"PR", @"PE", @"PI", @"RJ", @"RN", @"RO", @"RS", @"RR", @"SC", @"SE", @"SP", @"TO"];
    
    [btnPassword addTarget:self action:@selector(clickReset:) forControlEvents:UIControlEventTouchUpInside];
    
    isFirstLoad = true;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self atualizaLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    if(isFirstLoad)
    {
        isFirstLoad = false;
        [self setupDataLists];
    }
    else
    {
//        if(isSector)
//        {
//            for (HiveOfActivityCompany* item in listSector) {
//                if(item.selected)
//                {
//                    userModificado.sectorID = item.code;
//                    userModificado.sectorName = item.name;
//                    break;
//                }
//            }
//            
//            for (HiveOfActivityCompany* item in listCategory) {
//                if(item.code == userModificado.sectorID)
//                {
//                    item.selected = true;
//                }
//            }
//            
//        }
//        else{
//            [userModificado.category removeAllObjects];
//            
//            for (HiveOfActivityCompany* item in listCategory) {
//                if(item.selected == true)
//                {
//                    [userModificado.category addObject:@(item.code)];
//                }
//            }
//        }
        [tbvAccount reloadData];
    }
    
    tbvAccount.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[Answers logCustomEventWithName:@"Acesso a tela Meus Dados" customAttributes:@{}];
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
    static NSString *CellIdentifierPhoto = @"cellPhotoButton";
    static NSString *CellIdentifierTextField = @"cellTextField";
    static NSString *CellIdentifierSave = @"cellSaveButton";
    static NSString *CellIdentifierList = @"cellDropList";
    
    //Célula de rodapé(Save Button)
    if (indexPath.row == ROW_SAVE){
        
        
        TVC_AccountFooter *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSave];
        
        if(cell == nil)
        {
            cell = [[TVC_AccountFooter alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSave];
        }
        
        [cell.contentView layoutIfNeeded];
        [cell updateLayout];
        
        [cell.btnSave addTarget:self action:@selector(clickSave:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnSave setExclusiveTouch:true];
        
        return cell;
    }
#if CLICKME != true
    else if (indexPath.row == ROW_PASSWORD){
		
        TVC_AccountFooter *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierSave];
        
        if(cell == nil)
        {
            cell = [[TVC_AccountFooter alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierSave];
        }
        
        [cell.contentView layoutIfNeeded];
        //[cell updateLayout];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.btnSave.backgroundColor = [UIColor clearColor];
        [cell.btnSave setTitleColor:AppD.styleManager.colorPalette.primaryButtonNormal forState:UIControlStateNormal];
        [cell.btnSave setTitleColor:AppD.styleManager.colorPalette.primaryButtonSelected forState:UIControlStateHighlighted];
        [cell.btnSave.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM]];
        [cell.btnSave setTitle:NSLocalizedString(@"BUTTON_TITLE_CHANGE_PASSWORD", @"") forState:UIControlStateNormal];
        [cell.btnSave setTitle:NSLocalizedString(@"BUTTON_TITLE_CHANGE_PASSWORD", @"") forState:UIControlStateHighlighted];
        [cell.btnSave setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:cell.btnSave.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        [cell.btnSave addTarget:self action:@selector(clickReset:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnSave setExclusiveTouch:true];
        
        return cell;
    }
#endif
	
    //Célula do topo(Photo Button)
    else if(indexPath.row == ROW_PHOTO)
    {
        TVC_AccountHeader *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPhoto];
        
        if(cell == nil)
        {
            cell = [[TVC_AccountHeader alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPhoto];
        }
        if(escolheuFoto)
        {
            [cell.btnPhoto setBackgroundImage:userModificado.profilePic forState:UIControlStateNormal];
            [cell.btnPhoto setBackgroundImage:userModificado.profilePic forState:UIControlStateHighlighted];
        }
        else
        {
            if(userModificado.profilePic != nil && ![userModificado.urlProfilePic isEqualToString:@""])
            {
                [cell.btnPhoto setBackgroundImage:userModificado.profilePic forState:UIControlStateNormal];
                [cell.btnPhoto setBackgroundImage:userModificado.profilePic forState:UIControlStateHighlighted];
            }
            else{
                [cell.btnPhoto setBackgroundImage: [UIImage imageNamed:@"button-background-camera"] forState:UIControlStateHighlighted];
                [cell.btnPhoto setBackgroundImage: [UIImage imageNamed:@"button-background-camera"] forState:UIControlStateNormal];
                
            }
            //else if(userModificado.profilePic != nil && [userModificado.urlProfilePic isEqualToString:@""])
            //{
            
            //}
        }
        
        [cell updateLayout];
        
        [cell.btnPhoto addTarget:self action:@selector(clickPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnPhoto setExclusiveTouch:true];
        
        return cell;
        
    }
	else if(indexPath.row == ROW_LIST)
    {
        TVC_FakeTextField *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierList];
        
        if(cell == nil)
        {
            cell = [[TVC_FakeTextField alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierList];
        }
		
		cell.lbTitle.text = NSLocalizedString(@"PLACEHOLDER_ROLE", @"");
		cell.txtTitle.placeholder = NSLocalizedString(@"PLACEHOLDER_ROLE", @"");
        cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
        cell.ivTextField.image = [[UIImage imageNamed:@"icon-new-list"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.btnSelect.tag = 1;
        [cell.btnSelect addTarget:self action:@selector(clickJobRole:) forControlEvents:UIControlEventTouchUpInside];
		
		if(userModificado.jobRole && listCategory)
		{
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d", [userModificado.jobRole integerValue]];
			NSArray *filtered = [listCategory filteredArrayUsingPredicate:predicate];
			if ([filtered count] > 0)
			{
				NSDictionary *dicRole = [filtered objectAtIndex:0];
				cell.txtTitle.text = [dicRole objectForKey:@"description"];
			}
			else{
				cell.txtTitle.text = @"";
			}
		}
		else
		{
			
		}
		
		[cell updateLayout];
		
        return cell;

    }
    //Célula do corpo(TextFields)
    else{
        TVC_AccountBody *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTextField];
        
        if(cell == nil)
        {
            cell = [[TVC_AccountBody alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierTextField];
        }
        
        cell.txtBody.delegate = self;
        [cell.txtBody setAutocorrectionType:UITextAutocorrectionTypeNo];
        [cell.txtBody setSpellCheckingType:UITextSpellCheckingTypeNo];
        
        //NOME
        if(indexPath.row == ROW_NAME)
        {
			cell.lbTitle.text = NSLocalizedString(@"PLACEHOLDER_NAME", @"");
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_NAME", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-new-user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
            cell.txtBody.text = userModificado.name;
            cell.txtBody.tag = 1;
        }
        //EMPRESA
//#ifdef GSMD | ATLANTIC
//        else if(indexPath.row == ROW_CITY)
//        {
//            cell.lbTitle.text = NSLocalizedString(@"PLACEHOLDER_CITY", @"");
//            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_CITY", @"");
//            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
//            cell.ivTextField.image = [[UIImage imageNamed:@"icon-new-company"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//            [cell.txtBody setKeyboardType:UIKeyboardTypeDefault];
//            cell.txtBody.text = userModificado.city;
//            cell.txtBody.tag = 3;
//        }
//        else if(indexPath.row == ROW_STATE)
//        {
//            TVC_FakeTextField *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierList];
//            
//            if(cell == nil)
//            {
//                cell = [[TVC_FakeTextField alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierList];
//            }
//            cell.lbTitle.text = NSLocalizedString(@"PLACEHOLDER_STATE", @"");
//            cell.txtTitle.placeholder = NSLocalizedString(@"PLACEHOLDER_STATE", @"");
//            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
//            cell.ivTextField.image = [[UIImage imageNamed:@"icon-new-options"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//            cell.txtTitle.text = userModificado.sectorName;
//            cell.btnSelect.tag = 0;
//            [cell.btnSelect addTarget:self action:@selector(clickState:) forControlEvents:UIControlEventTouchUpInside];
//            
//            if(userModificado.state)
//            {
//                cell.txtTitle.text = userModificado.state;
//            }
//            else
//            {
//                cell.txtTitle.text = @"";
//            }
//            
//            [cell updateLayout];
//            
//            return cell;
//        }
//#endif
        //EMAIL
        else if(indexPath.row == ROW_EMAIL)
        {
			cell.lbTitle.text = NSLocalizedString(@"PLACEHOLDER_EMAIL", @"");
            cell.txtBody.placeholder = NSLocalizedString(@"PLACEHOLDER_EMAIL", @"");
            cell.ivTextField = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
            cell.ivTextField.image = [[UIImage imageNamed:@"icon-new-email"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.txtBody setKeyboardType:UIKeyboardTypeEmailAddress];
            cell.txtBody.text = userModificado.email;
            cell.txtBody.tag = 2;
        }
        
        [cell updateLayout];
        [cell layoutIfNeeded];
        return cell;
        
    }

    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ROW_COUNT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ROW_PHOTO)
    {
        return 180;
    }
//	else if(indexPath.row == 6)
//    {
//        return 80;
//    }
    else
    {
        return 80;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Segue_Reset"])
    {
        VC_ResetPassword *vc_reset = [segue destinationViewController];
        vc_reset.user = userModificado;
    }
	
    if([segue.identifier isEqualToString:@"Segue_DropList"])
    {
        VC_DropList *vc_drop = [segue destinationViewController];
        
        if(_lastTagSelected == 0)
        {
            isState = true;
            vc_drop.isState = isState;
			vc_drop.user = userModificado;
            vc_drop.dropList = listState;
        }
        else if(_lastTagSelected == 1)
        {
            isState = false;
            vc_drop.isState = isState;
			vc_drop.user = self.userModificado;
            
            //Removendo os jobs do dicionário:
            NSMutableArray *jobList = [NSMutableArray new];
            for (NSDictionary *dic in listCategory){
                [jobList addObject:[dic objectForKey:@"description"]];
            }
            vc_drop.dropList = jobList;
        }
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(void) clickDone
{
    [self.view resignFirstResponder];
}

-(IBAction)clickSave:(id)sender
{
    [self.view endEditing:YES];
    
    if([userModificado.name isEqualToString:@""] || [userModificado.email isEqualToString:@""])
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_EMPTY_FIELDS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMPTY_FIELDS_USER", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else if([ToolBox validationHelper_EmailChecker:userModificado.email] == tbValidationResult_Disapproved)
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_EMAIL_INVALID", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    else
    {
        if(![userModificado isEqualToObject:userEstatico] || _photoChanged)
        {
            ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
            
            if ([connectionManager isConnectionActive])
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
                });
                
                connectionManager.delegate = self;
                NSDictionary *dicParameters = [userModificado dictionaryJSON];
                
                [connectionManager updateUserUsingParameters:dicParameters withUserID:userEstatico.userID withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
                    
                    if (error){
                        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                        //
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_UPDATE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                    else
                    {
                        _photoChanged = false;
                        escolheuFoto = false;
                        
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
                                updatedUser.profilePic = userModificado.profilePic;
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
							
							
							UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
							VC_PostsGallery *vcPostGallery = [storyboard instantiateViewControllerWithIdentifier:@"VC_PostsGallery"];
							[vcPostGallery awakeFromNib];
							//
							UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
							topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
							topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
							//
							//Abrindo a tela
							[AppD.rootViewController.navigationController pushViewController:vcPostGallery animated:YES];
							
							//Readaptando a lista de controllers:
							NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
							NSMutableArray *listaF = [NSMutableArray new];
							[listaF addObject:[listaC objectAtIndex:0]];
							[listaF addObject:[listaC objectAtIndex:1]];
							[listaF addObject:vcPostGallery];
							
							//Carregando dados
							AppD.rootViewController.navigationController.viewControllers = listaF;

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
}

-(IBAction)clickPhoto:(id)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    
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

-(IBAction)clickReset:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self performSegueWithIdentifier:@"Segue_Reset" sender:nil];
}

- (IBAction)clickState:(UIButton*)sender
{
    [self.view endEditing:true];
    _lastTagSelected = sender.tag;
    [self performSegueWithIdentifier:@"Segue_DropList" sender:nil];
}

- (IBAction)clickJobRole:(UIButton*)sender
{
    [self.view endEditing:true];
	_lastTagSelected = sender.tag;
	[self performSegueWithIdentifier:@"Segue_DropList" sender:nil];
	
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
    
    if(textField.tag == 1)
    {
        userModificado.name = textField.text;
    }
    else if(textField.tag == 2)
    {
        userModificado.email = textField.text;
    }
    else if(textField.tag == 3)
    {
        userModificado.city = textField.text;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    tbvAccount.contentInset = contentInsets;
    tbvAccount.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
        [tbvAccount scrollRectToVisible:activeTextField.superview.superview.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    tbvAccount.contentInset = contentInsets;
    tbvAccount.scrollIndicatorInsets = contentInsets;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage* chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    userModificado.profilePic = [ToolBox graphicHelper_NormalizeImage:chosenImage maximumDimension:IMAGE_MAXIMUM_SIZE_SIDE quality:1.0];
    
    _photoChanged = true;
    escolheuFoto = true;
    dispatch_async(dispatch_get_main_queue(),^{
        
        TVC_AccountHeader *row = (TVC_AccountHeader*)[tbvAccount cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]];
        
        [row.btnPhoto setBackgroundImage:chosenImage forState:UIControlStateNormal];
        [row.btnPhoto setBackgroundImage:chosenImage forState:UIControlStateHighlighted];
    });
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - • PRIVATE METHODS (INTERNAL USE)

-(void) atualizaLayout
{
    self.view.backgroundColor = [UIColor blackColor];
    //
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    //Background and Icons
    imgBackground.backgroundColor = [UIColor clearColor];
    imgBackground.image = [AppD createDefaultBackgroundImage];
    
    //
    btnPassword.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [btnPassword setTitleColor:AppD.styleManager.colorPalette.textNormal forState:UIControlStateNormal];
    [btnPassword setTitleColor:AppD.styleManager.colorPalette.textNormal forState:UIControlStateHighlighted];
    [btnPassword.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM]];
    [btnPassword setTitle:NSLocalizedString(@"BUTTON_TITLE_CHANGE_PASSWORD", @"") forState:UIControlStateNormal];
    [btnPassword setTitle:NSLocalizedString(@"BUTTON_TITLE_CHANGE_PASSWORD", @"") forState:UIControlStateHighlighted];
    //
    tbvAccount.backgroundColor = [UIColor clearColor];
}

//-(void) setupDataCategory
//{
//    ConnectionManager *connection = [[ConnectionManager alloc] init];
//    
//    if ([connection isConnectionActive])
//    {
//        dispatch_async(dispatch_get_main_queue(),^{
//            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
//        });
//        
//        [connection getCategoryListWithCompletionHandler:^(NSArray *response, NSError *error) {
//            
//            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
//            
//            if (error){
//                
//                SCLAlertView *alert = [AppD createDefaultAlert];
//                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CATEGORY_SEARCH_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
//                
//            }else{
//                
//                listCategory = [[NSArray alloc] initWithArray:[response valueForKey:@"interest_areas"]];
//				
////                for (HiveOfActivityCompany* item in listCategory) {
////                    for (NSNumber *item2 in userEstatico.category) {
////                        if((int)item.code == [item2 intValue])
////                        {
////                            item.selected = true;
////                        }
////                    }
////                    
////                }
//				
//                
//                [tbvAccount reloadData];
//            }
//        }];
//        
//    }else{
//        
//        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
//        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
//    }
//}

-(void)setupDataLists
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    
    if ([connection isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connection getJobRolesListWithCompletionHandler:^(NSArray *response, NSError *error) {
	
            if (error){
                
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SECTOR_SEARCH_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            }else{
                
                listCategory = [[NSArray alloc] initWithArray:[response valueForKey:@"job_roles"]];
				
                [tbvAccount reloadData];
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            }
        }];
        
    }else{
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

@end
