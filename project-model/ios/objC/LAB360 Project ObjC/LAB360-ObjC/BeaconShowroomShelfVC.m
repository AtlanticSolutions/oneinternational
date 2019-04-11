//
//  BeaconShowroomShelfVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 15/06/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "BeaconShowroomShelfVC.h"
#import "AppDelegate.h"
#import "BeaconShowroomItemTVC.h"
#import "BeaconShowroomRadarVC.h"
//
#import "BeaconShowroomDataSource.h"
#import "AdAliveWS.h"
#import "UIBarButtonItem+Badge.h"
#import <CoreBluetooth/CoreBluetooth.h>

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface BeaconShowroomShelfVC()<AdAliveWSDelegate, CBCentralManagerDelegate>

//Data:
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSString *userPIN;
//
@property (nonatomic, strong) CBCentralManager *cbCentralManager;
@property (nonatomic, assign) CBManagerState bluetoothState;

//Layout:
@property (nonatomic, weak) IBOutlet UILabel *lblEmptyList;
@property (nonatomic, weak) IBOutlet UILabel *lblHeader;
@property (nonatomic, weak) IBOutlet UITableView *tvShelf;

@end

#pragma mark - • IMPLEMENTATION
@implementation BeaconShowroomShelfVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize isLoaded, currentShowroom, placeholderImage, userPIN, cbCentralManager, bluetoothState;
@synthesize lblEmptyList, lblHeader, tvShelf;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isLoaded = NO;
    placeholderImage = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
    userPIN = nil;
    //
    dispatch_queue_t centralQueue = dispatch_queue_create("br.com.lab360.beaconshowroom.centralmanager", DISPATCH_QUEUE_SERIAL);
    cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self setupLayout:currentShowroom.name];
        [self loadShelfListFromServer];
        isLoaded = YES;
    }else{
        if (currentShowroom.subItems.count == 0){
            [self loadShelfListFromServer];
        }
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToRadarVC"]){
        BeaconShowroomRadarVC *vc = segue.destinationViewController;
        vc.currentShelf = sender;
        vc.pinToUnlock = userPIN;
    }
    
    tvShelf.tag = 0;
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionMenuProtection:(id)sender
{
    if (userPIN == nil) {
        
        //Ainda não possui proteção:
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        
        UITextField *textField = [alert addTextField:@"Insira o PIN"];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [textField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TITLE_NAVBAR]];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [textField setSpellCheckingType:UITextSpellCheckingTypeNo];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        
        [alert addButton:@"Usar PIN" withType:SCLAlertButtonType_Normal actionBlock:^{
            [textField resignFirstResponder];
            if ([ToolBox textHelper_CheckRelevantContentInString:textField.text]){
                self.userPIN = textField.text;
                self.navigationItem.rightBarButtonItem = [self createProtectionIcon:YES];
            }
        }];
        
        [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
        
        [alert showInfo:self title:@"Proteção de Tela" subTitle:@"Deseja proteger a tela de monitoramento com um PIN?\n\n(somente será possível sair da referida tela inserindo este código)" closeButtonTitle:nil duration:0.0];
        
    }else{
        
        //Já possuí proteção:
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        
        [alert addButton:@"Remover PIN" withType:SCLAlertButtonType_Normal actionBlock:^{
            self.userPIN = nil;
            self.navigationItem.rightBarButtonItem = [self createProtectionIcon:NO];
        }];
        
        [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
        
        [alert showInfo:self title:@"Proteção de Tela" subTitle:[NSString stringWithFormat:@"O monitoramento de beacons está protegido com a senha '%@'. Deseja remover o PIN atual?", self.userPIN] closeButtonTitle:nil duration:0.0];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

//MARK: UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentShowroom.subItems.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"CellShowroomItem";
    __block BeaconShowroomItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    if(cell == nil){
        cell = [[BeaconShowroomItemTVC alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    [cell updateLayoutUsingImage:NO];
    
    __block BeaconShowroomItem *item = [currentShowroom.subItems objectAtIndex:indexPath.row];
    
    BOOL showImage = YES;
    
    if ([ToolBox textHelper_CheckRelevantContentInString:item.imageURL]){
        [cell updateLayoutUsingImage:YES];
    }else{
        [cell updateLayoutUsingImage:NO];
        showImage = NO;
    }
    
    cell.lblName.text = item.name;
    cell.lblDetail.text = item.detail;
    
    if (showImage){
        if (item.image){
            cell.imvItemImage.image = item.image;
        }else{
            [cell.activityIndicator startAnimating];
            [cell.imvItemImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:item.imageURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                item.image = image;
                //
                [cell.activityIndicator stopAnimating];
                cell.imvItemImage.image = image;
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                [cell.activityIndicator stopAnimating];
                cell.imvItemImage.image = placeholderImage;
            }];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //O toque na célula é tratado desta forma pois a animação e o processo a ser executado ocorrem na main thread, o que impede a execução da animação da forma correta.
    //Controlando por uma variável, impedimos que dois toques seguidos sejam iniciados.
    
    if (tableView.tag == 0)
    {
        tableView.tag = 1;
        
        BeaconShowroomItemTVC *cell = (BeaconShowroomItemTVC*)[tableView cellForRowAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion:^(BOOL finished) {
            
            if (bluetoothState == CBCentralManagerStatePoweredOn){
                BeaconShowroomItem *shelf = [currentShowroom.subItems objectAtIndex:indexPath.row];
                
                //Log
                [AppD logAdAliveEventWithName:@"Shelf Selected" data:[shelf dictionaryJSON]];
                
                [self performSegueWithIdentifier:@"SegueToRadarVC" sender:[shelf copyObject]];
            }else{
                
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:@"Atenção!" subTitle:@"O monitoramento por beacon precisa que o 'Bluetooth' do seu dispositivo esteja ligado.\nPor favor, habilite-o antes de continuar." closeButtonTitle:@"OK" duration:0.0];
                tableView.tag = 0;
            }

        }];
    }
}

#pragma mark - CBCentralManager

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    bluetoothState = central.state;
}

#pragma mark - AdAliveWSDelegate

-(void)didReceiveResponse:(AdAliveWS *)adalivews withSuccess:(NSDictionary *)response{
    
    //    NSArray *allKeys = [response allKeys];
    //
    //    if([allKeys containsObject:@"beacons"]){
    //        NSArray *beacons = [response objectForKey:@"beacons"];
    //        [self configureBeacons: beacons];
    //    }else{
    //        [self updateBeaconViewShowingContent:NO];
    //        //
    //        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
    //        //
    //        [self initiateRefreshDataTimer];
    //    }
}

-(void)didReceiveResponse:(AdAliveWS *)adalivews withError:(NSError *)error
{
    //    [self updateBeaconViewShowingContent:NO];
    //    //
    //    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
    //    //
    //    [self initiateRefreshDataTimer];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString*)screenName
{
    [super setupLayout:screenName];
    
    lblEmptyList.text = @"Nenhum prateleira foi encontrada para o showroom selecionado. Por favor, verifique sua conexão ou tente novamente mais tarde.";
    lblEmptyList.textColor = [UIColor grayColor];
    lblEmptyList.backgroundColor = nil;
    lblEmptyList.numberOfLines = 0;
    lblEmptyList.textAlignment = NSTextAlignmentCenter;
    lblEmptyList.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:17];
    
    lblHeader.text = @"Selecione a prateleira";
    lblHeader.textColor = [UIColor whiteColor];
    lblHeader.backgroundColor = [UIColor grayColor];
    lblHeader.numberOfLines = 0;
    lblHeader.textAlignment = NSTextAlignmentCenter;
    lblHeader.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:15];
    
    tvShelf.backgroundColor = [UIColor whiteColor];
    [tvShelf setTableFooterView:[UIView new]];
    
    [lblEmptyList setAlpha:0.0];
    [lblHeader setAlpha:0.0];
    [tvShelf setAlpha:0.0];
}

- (void)loadShelfListFromServer
{
    self.navigationItem.rightBarButtonItem = nil;
    
    BeaconShowroomDataSource *ds = [BeaconShowroomDataSource new];

    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });

    [ds getShelfsForShowroom:currentShowroom.itemID withCompletionHandler:^(NSMutableArray<BeaconShowroomItem *> * _Nullable data, DataSourceResponse * _Nonnull response) {
        
        if (response.status == DataSourceResponseStatusSuccess){
            self.currentShowroom.subItems = [[NSMutableArray alloc] initWithArray:data];
            //
            for (BeaconShowroomItem *b in self.currentShowroom.subItems){
                b.parentItemID = self.currentShowroom.itemID;
            }
            //
            self.navigationItem.rightBarButtonItem = [self createProtectionIcon:NO];
        }else{
            self.currentShowroom.subItems = [NSMutableArray new];
        }
        
        [tvShelf reloadData];
        
        [self updateComponentsVisibility];
        
    }];
}

- (void)updateComponentsVisibility
{
    if (currentShowroom.subItems.count == 0) {
        [lblHeader setAlpha:0.0];
        [tvShelf setAlpha:0.0];
        //
        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
            [lblEmptyList setAlpha:1.0];
        }];
    }else{
        [lblEmptyList setAlpha:0.0];
        //
        [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
            [lblHeader setAlpha:1.0];
            [tvShelf setAlpha:1.0];
        }];
    }
    //
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
}

//- (void)createProtectionPINforShelf:(BeaconShowroomItem*)shelf
//{
//    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
//
//    UITextField *textField = [alert addTextField:@"Insira o PIN"];
//    textField.keyboardType = UIKeyboardTypeNumberPad;
//    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    [textField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TITLE_NAVBAR]];
//    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
//    [textField setSpellCheckingType:UITextSpellCheckingTypeNo];
//    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
//
//    [alert addButton:@"Continuar com PIN" withType:SCLAlertButtonType_Destructive actionBlock:^{
//
//        [textField resignFirstResponder];
//
//        if ([ToolBox textHelper_CheckRelevantContentInString:textField.text]){
//            self.userPIN = textField.text;
//        }else{
//            self.userPIN = nil;
//        }
//
//        [self performSegueWithIdentifier:@"SegueToRadarVC" sender:shelf];
//
//    }];
//
//    [alert addButton:@"Não usar PIN" withType:SCLAlertButtonType_Normal actionBlock:^{
//        self.userPIN = nil;
//        [self performSegueWithIdentifier:@"SegueToRadarVC" sender:shelf];
//    }];
//
//    [alert showInfo:self title:@"Atenção!" subTitle:@"Antes de iniciar a busca por beacons desta prateleira é possível definir um PIN para proteger a tela de busca.\nDesta forma um dispositivo em exposição, por exemplo, não poderá ser manuseado por clientes não autorizados. Certifique-se de anotar o PIN inserido para uso posterior." closeButtonTitle:nil duration:0.0];
//}

- (UIBarButtonItem*)createProtectionIcon:(BOOL)isLocked
{
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage *img = nil;
    if (isLocked){
        img = [[UIImage imageNamed:@"BeaconMenuLock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }else{
        img = [[UIImage imageNamed:@"BeaconMenuUnlock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    //    }
    [userButton setFrame:CGRectMake(0, 0, 32, 32)];
    [userButton setClipsToBounds:YES];
    //[userButton.layer setCornerRadius:16];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(actionMenuProtection:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    if (isLocked){
        [bbi setBadgeValue:@"!"];
    }
    return bbi;
}

@end
