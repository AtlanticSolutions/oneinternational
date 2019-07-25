//
//  AppOptionPermissionsVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 16/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT

#import <Photos/Photos.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <Speech/Speech.h>
//
#import "AppOptionPermissionsVC.h"
#import "AppDelegate.h"
#import "AppOptionPermissionItem.h"
#import "AppOptionPermissionItemTVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AppOptionPermissionsVC()<UITableViewDelegate, UITableViewDataSource>

//Data:
@property(nonatomic, strong) NSMutableArray<AppOptionPermissionItem*> *permissionsList;

//Layout:
@property(nonatomic, weak) IBOutlet UITableView *tvPermissionItems;

@end

#pragma mark - • IMPLEMENTATION
@implementation AppOptionPermissionsVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize permissionsList;
@synthesize tvPermissionItems;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tvPermissionItems.delegate = self;
    tvPermissionItems.dataSource = self;
    
    [tvPermissionItems registerNib:[UINib nibWithNibName:@"AppOptionPermissionItemTVC" bundle:nil] forCellReuseIdentifier:@"AppOptionPermissionItemCell"];
    [tvPermissionItems setTableFooterView:[UIView new]];
    
    [self loadPermissionsList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_PERMISSIONS", @"")];
    
    [tvPermissionItems setAlpha:0.0];
    
    self.navigationItem.rightBarButtonItem = [self createHelpButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [tvPermissionItems reloadData];
    
    [UIView animateWithDuration:ANIMA_TIME_FAST animations:^{
        [tvPermissionItems setAlpha:1.0];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionHelp:(id)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert addButton:@"Abrir Ajustes" withType:SCLAlertButtonType_Normal actionBlock:^{
        [self openAppSettings];
    }];
    [alert addButton:@"Cancelar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
    [alert showInfo:@"Permissões" subTitle:@"É possível modificar as permissões do aplicativo no menu de Ajustes do sistema. Note que itens com status 'Indeterminado' não aparecerão no menu de Ajustes até que sejam solicitados pela aplicação (conforme necessidade)." closeButtonTitle:nil duration:0.0];
}

- (void)actionApplicationDidBecomeActive:(NSNotification*)notification
{
    [self loadPermissionsList];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return permissionsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierOption = @"AppOptionPermissionItemCell";
    AppOptionPermissionItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierOption];
    if(cell == nil){
        cell = [[AppOptionPermissionItemTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierOption];
    }
    
    AppOptionPermissionItem *currentItem = [permissionsList objectAtIndex:indexPath.row];
    
    [cell setupLayout];
    
    cell.lblTitle.text = currentItem.name;
    cell.lblDescription.text = currentItem.userDescription;
    cell.lblStatus.text = currentItem.statusMessage;
    
    switch (currentItem.status) {
        case AppOptionPermissionItemStatusNotUsed:{
            cell.imvStatus.backgroundColor = COLOR_MA_DARKGRAY;
        }break;
        //
        case AppOptionPermissionItemStatusUndefined:{
            cell.imvStatus.backgroundColor = COLOR_MA_ORANGE;
        }break;
        //
        case AppOptionPermissionItemStatusDenied:{
            cell.imvStatus.backgroundColor = COLOR_MA_RED;
        }break;
        //
        case AppOptionPermissionItemStatusGuaranteed:{
            cell.imvStatus.backgroundColor = COLOR_MA_GREEN;
        }break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0)
    {
        tableView.tag = 1;
        AppOptionPermissionItemTVC *cell = (AppOptionPermissionItemTVC*)[tableView cellForRowAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion: ^(BOOL finished) {
            
            AppOptionPermissionItem *item = [permissionsList objectAtIndex:indexPath.row];
            
            switch (item.status) {
                case AppOptionPermissionItemStatusNotUsed:{
                    //nothing...
                }break;
                    //
                case AppOptionPermissionItemStatusUndefined:{
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showInfo:item.name subTitle:@"Esta permissão está pendente pois a funcionalidade ainda não foi executada pelo aplicativo." closeButtonTitle:@"OK" duration:0.0];
                }break;
                    //
                case AppOptionPermissionItemStatusGuaranteed:{
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showSuccess:item.name subTitle:@"Esta permissão está autorizada. O aplicativo usará a respectiva capacidade quando necessário." closeButtonTitle:@"OK" duration:0.0];
                }break;
                    //
                case AppOptionPermissionItemStatusDenied:{
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showError:item.name subTitle:@"Esta permissão foi negada pelo usuário ou possui alguma restrição (incapacidade do dispositivo, por exemplo)." closeButtonTitle:@"OK" duration:0.0];
                }break;
            }
            
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
    
    tvPermissionItems.backgroundColor = [UIColor whiteColor];
}

- (void)loadPermissionsList
{
    permissionsList = [NSMutableArray new];
    
    //kTCCServiceMediaLibrary biblioteca de mídia...
    //notifications
    
//    // Apple Music ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSAppleMusicUsageDescription";
//        item.name = @"Músicas";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
    // Bluetooth ===========================================================================================================================
    {
        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
        item.systemKey = @"NSBluetoothPeripheralUsageDescription";
        item.name = @"Periféricos Bluetooth";
        item.userDescription = @"O uso da tecnologia bluetooth é necessário para a comunicação com dispositivos compatíveis próximos.";
        item.status = [self verifyBluetoothPermission];
        item.statusMessage = [self messageForStatus:item.status];
        //
        [permissionsList addObject:item];
    }
    
//    // Calendar ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSCalendarsUsageDescription";
//        item.name = @"Calendário / Eventos";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
    // Camera ===========================================================================================================================
    {
        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
        item.systemKey = @"NSCameraUsageDescription";
        item.name = @"Câmera";
        item.userDescription = @"O uso da camera é necessário para a gravação de vídeos e fotos com seu dispositivo. Ela também é utilizada para a Realidade Virtual (VR) e Realidade Aumentada (AR).";
        item.status = [self verifyCameraPermission];
        item.statusMessage = [self messageForStatus:item.status];
        //
        [permissionsList addObject:item];
    }
    
//    // Contatos ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSContactsUsageDescription";
//        item.name = @"Contatos";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
//    // FaceID ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSFaceIDUsageDescription";
//        item.name = @"FaceID";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
//    // Health Share ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSHealthShareUsageDescription";
//        item.name = @"Health Share";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
//    // Health Update ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSHealthUpdateUsageDescription";
//        item.name = @"Health Update";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
//    // Home Kit ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSHomeKitUsageDescription";
//        item.name = @"Home Kit";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
    //NOTE: As várias formas de localização foram agrupadas em apenas uma:
    
    // Location (Generic) ===========================================================================================================================
    {
        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
        item.systemKey = @"NSLocationGenericDescription"; //key inventada
        item.name = @"Localização";
        item.userDescription = @"Com o serviço de localização do dispositivo ligado e a permissão dada é possível para a aplicação determinar automaticamente um conteúdo mais apropriado ao usuário dependendo de sua localidade atual.";
        item.status = [self verifyLocationPermission];
        item.statusMessage = [self messageForStatus:item.status];
        //
        [permissionsList addObject:item];
    }
    
//    // Location ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSLocationUsageDescription";
//        item.name = @"Localização";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
//    // Location (Always) ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSLocationAlwaysUsageDescription";
//        item.name = @"Localização (Sempre)";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
//    // Location (When in use) ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSLocationWhenInUseUsageDescription";
//        item.name = @"Localização (Quando em uso)";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
    // Microphone ===========================================================================================================================
    {
        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
        item.systemKey = @"NSMicrophoneUsageDescription";
        item.name = @"Microphone";
        item.userDescription = @"Esta permissão é necessária para o uso do Reconhecimento de Voz.";
        item.status = [self verifyMicrofonePermission];
        item.statusMessage = [self messageForStatus:item.status];
        //
        [permissionsList addObject:item];
    }
    
    //Note: A classe CMMotionManager não precisa de autorização para ser utilizada, apenas verificação de disponibilidade: DeviceMotionAvailable, AccelerometerAvailable, GyroAvailable, MagnetometerAvailable.
//    // Motion (Accelerometer) ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSMotionUsageDescription";
//        item.name = @"Movimento (Acelerômetro)";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
//    // NFC (Near-field communication) ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NFCReaderUsageDescription";
//        item.name = @"NFC (Near-field communication)";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
    //Note: NSPhotoLibraryUsageDescription e NSPhotoLibraryAddUsageDescription são verificadas pelo mesmo método, o que não reflete o status atual real.
    //Cada uma delas pede uma autorização diferente do usuário, mas só há um método para saber o status.
    
    // Photo Library ===========================================================================================================================
    {
        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
        item.systemKey = @"NSPhotoLibraryUsageDescription";
        item.name = @"Fotos da Biblioteca";
        item.userDescription = @"O acesso a sua biblioteca de fotos e vídeos permite que essas mídias sejam utilizadas dentro da aplicação. Uma permissão secundária pode ser solicitada para gravação no Rolo da Câmera.";
        item.status = [self verifyLibraryAccessPermission];
        item.statusMessage = [self messageForStatus:item.status];
        //
        [permissionsList addObject:item];
    }
    
    //Note: Embora exista um tipo de autorização específico 'somente leitura' o método que retorna o status atual da permissão é igual para NSPhotoLibraryUsageDescription e NSPhotoLibraryAddUsageDescription.
    //
//    // Photo Library (Write-only access) ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSPhotoLibraryAddUsageDescription";
//        item.name = @"Fotos da Biblioteca (Gravação)";
//        item.userDescription = @"Esta capacidade permite que o aplicativo salve imagens no Rolo da Câmera do usuário.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
    // Push Notifications ===========================================================================================================================
    {
        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
        item.systemKey = @"PushNotifications"; //key inventada
        item.name = @"Notificações";
        item.userDescription = @"Permissão que regula o envio de notificações de sistema para o usuário.";
        item.status = [self verifyNotificationsPermission];
        item.statusMessage = [self messageForStatus:item.status];
        //
        [permissionsList addObject:item];
    }
    
//    // Reminders ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSRemindersUsageDescription";
//        item.name = @"Lembretes";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
//    // Siri ===========================================================================================================================
//    {
//        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
//        item.systemKey = @"NSSiriUsageDescription";
//        item.name = @"Siri";
//        item.userDescription = @"Esta capacidade não é utilizada pela aplicação.";
//        item.status = AppOptionPermissionItemStatusNotUsed;
//        item.statusMessage = [self messageForStatus:item.status];
//        //
//        [permissionsList addObject:item];
//    }
    
    // Speech Recognition ===========================================================================================================================
    {
        AppOptionPermissionItem *item = [AppOptionPermissionItem new];
        item.systemKey = @"NSSpeechRecognitionUsageDescription";
        item.name = @"Reconhecimento de Voz";
        item.userDescription = @"O reconhecimento de voz é utilizado para transformar fala em texto, agilizando o processo de preenchimento de campos.";
        item.status = [self verifySpeechRecognitionPermission];
        item.statusMessage = [self messageForStatus:item.status];
        //
        [permissionsList addObject:item];
    }
}

- (NSString*)messageForStatus:(AppOptionPermissionItemStatus)status
{
    NSString *message = @"";
    
    switch (status) {
        case AppOptionPermissionItemStatusNotUsed:{
            message = @"Status: -";
        }break;
            //
        case AppOptionPermissionItemStatusUndefined:{
            message = @"Status: Indeterminado";
        }break;
            //
        case AppOptionPermissionItemStatusDenied:{
            message = @"Status: Negado";
        }break;
            //
        case AppOptionPermissionItemStatusGuaranteed:{
            message = @"Status: Autorizado";
        }break;
    }
    
    return message;
}

- (AppOptionPermissionItemStatus)verifyCameraPermission
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        return AppOptionPermissionItemStatusGuaranteed;
    } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        return AppOptionPermissionItemStatusDenied;
    } else {
        //AVAuthorizationStatusNotDetermined
        return AppOptionPermissionItemStatusUndefined;
    }
}

- (AppOptionPermissionItemStatus)verifyBluetoothPermission
{
    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
    
    if (status == CBPeripheralManagerAuthorizationStatusAuthorized) {
        return AppOptionPermissionItemStatusGuaranteed;
    }else if (status == CBPeripheralManagerAuthorizationStatusDenied || status == CBPeripheralManagerAuthorizationStatusRestricted){
        return AppOptionPermissionItemStatusDenied;
    } else {
        //CBPeripheralManagerAuthorizationStatusNotDetermined
        return AppOptionPermissionItemStatusUndefined;
    }
}

- (AppOptionPermissionItemStatus)verifyLibraryAccessPermission
{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if(authStatus == PHAuthorizationStatusAuthorized) {
       return AppOptionPermissionItemStatusGuaranteed;
    } else if(authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted){
       return AppOptionPermissionItemStatusDenied;
    } else {
        //PHAuthorizationStatusNotDetermined
        return AppOptionPermissionItemStatusUndefined;
    }
}

- (AppOptionPermissionItemStatus)verifyLocationPermission
{
    //O serviço de localização desligado aqui foi considerado como 'negado'
//    if (![CLLocationManager locationServicesEnabled]){
//        return AppOptionPermissionItemStatusDenied;
//    }else{
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways:{
                return AppOptionPermissionItemStatusGuaranteed;
            }break;
            //
            case kCLAuthorizationStatusAuthorizedWhenInUse:{
                return AppOptionPermissionItemStatusGuaranteed;
            }break;
            //
            case kCLAuthorizationStatusDenied:{
                return AppOptionPermissionItemStatusDenied;
            }break;
            //
            case kCLAuthorizationStatusRestricted:{
                return AppOptionPermissionItemStatusDenied;
            }break;
            //
            case kCLAuthorizationStatusNotDetermined:{
                return AppOptionPermissionItemStatusUndefined;
            }break;
        }
//    }
}

- (AppOptionPermissionItemStatus)verifyMicrofonePermission
{
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
    if(permission == AVAudioSessionRecordPermissionGranted) {
        return AppOptionPermissionItemStatusGuaranteed;
    } else if(permission == AVAudioSessionRecordPermissionDenied){
        return AppOptionPermissionItemStatusDenied;
    } else {
        //AVAudioSessionRecordPermissionUndetermined
        return AppOptionPermissionItemStatusUndefined;
    }
}

- (AppOptionPermissionItemStatus)verifySpeechRecognitionPermission
{
    SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
    if(status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
        return AppOptionPermissionItemStatusGuaranteed;
    } else if(status == SFSpeechRecognizerAuthorizationStatusDenied || status == SFSpeechRecognizerAuthorizationStatusRestricted){
        return AppOptionPermissionItemStatusDenied;
    } else {
        //SFSpeechRecognizerAuthorizationStatusNotDetermined
        return AppOptionPermissionItemStatusUndefined;
    }
}

- (AppOptionPermissionItemStatus)verifyNotificationsPermission
{
    if (@available(iOS 10.0, *)){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            //Com este método o retorno é asyncrono:
            UNAuthorizationStatus authorizationStatus = settings.authorizationStatus;
            
            AppOptionPermissionItemStatus permitionStatus = AppOptionPermissionItemStatusUndefined;
            if (authorizationStatus == UNAuthorizationStatusAuthorized){
                permitionStatus = AppOptionPermissionItemStatusGuaranteed;
            }else if (authorizationStatus == UNAuthorizationStatusDenied){
                permitionStatus = AppOptionPermissionItemStatusDenied;
            }
            
            for (AppOptionPermissionItem *item in permissionsList){
                if ([item.systemKey isEqualToString:@"PushNotifications"]){
                    item.status = permitionStatus;
                    item.statusMessage = [self messageForStatus:item.status];
                    break;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [tvPermissionItems reloadData];
            });
            
        }];
        
        return AppOptionPermissionItemStatusUndefined;
    }else{
        UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (notificationSettings.types != UIUserNotificationTypeNone){
            return AppOptionPermissionItemStatusGuaranteed;
        }else{
            return AppOptionPermissionItemStatusDenied;
        }
    }
    
}

#pragma mark - UTILS (General Use)

- (void)openAppSettings
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

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
