//
//  DiscountCouponHistoryVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 27/11/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "DiscountCouponHistoryVC.h"
#import "TVC_ScannerHistory.h"
#import "AppDelegate.h"
#import "BarcodeReaderViewController.h"
#import "LocationService.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface DiscountCouponHistoryVC()<UITableViewDelegate, UITableViewDataSource>

//Data:
@property(nonatomic, assign) BOOL isLoaded;
@property(nonatomic, strong) NSMutableArray *scanHistoryList;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) NSString *scannedCouponData;
//
@property (nonatomic, strong) LocationService *locationService;

//Layout:
@property(nonatomic, weak) IBOutlet UILabel *lblScanner;
@property(nonatomic, weak) IBOutlet UIButton *btnScanner;
@property(nonatomic, weak) IBOutlet UITableView *tvScanner;

@end

#pragma mark - • IMPLEMENTATION
@implementation DiscountCouponHistoryVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize isLoaded, scanHistoryList, dataList, scannedCouponData, locationService;
@synthesize lblScanner, btnScanner, tvScanner;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoaded = NO;
    scannedCouponData = nil;
    
    NSString *userID = [NSString stringWithFormat:@"USER_%i", AppD.loggedUser.userID];
    scanHistoryList = [[NSMutableArray alloc] initWithArray:[self loadUserScans:userID]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self setupLayout:@"Histórico de Cupons"];
        
        [self reloadDataList];
        
        [tvScanner reloadData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionScannerNotification:) name:BARCODE_READER_RESULT_NOTIFICATION_KEY object:nil];
        
        locationService = [LocationService initAndStartMonitoringLocation];
        
        isLoaded = YES;
        
        [self createHelpButton];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (scannedCouponData){
        [self processCouponData];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //pop desta tela:
    if ([self isMovingFromParentViewController])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:BARCODE_READER_RESULT_NOTIFICATION_KEY object:nil];
        //
        scannedCouponData = nil;
        //
        [locationService stopMonitoring];
        locationService = nil;
    }
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

#pragma mark - • ACTION METHODS

- (void)actionScannerNotification:(NSNotification*)notification
{
    if ([notification.object isKindOfClass:[NSString class]]){
        scannedCouponData = (NSString*)notification.object;
    }
}

- (void)actionHelp:(id)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showInfo:@"Cupons Escaneados" subTitle:@"Esta tela representa o ambiente do lojista, o qual irá escanear o cupom do cliente para poder aplicar um dado desconto.\n\nCaso o cupom seja consumido com sucesso (validado corretamente no servidor) significa que seu desconto/crédio é aplicável à transação desejada pelo cliente." closeButtonTitle:@"OK" duration:0.0];
}

- (IBAction)startScanner:(id)sender
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        
        //Segue para o leitor normalmente
        [self goToCameraScanner];
        
    } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        
        //Explica o motivo da requisição
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT_TITLE_CAMERA_PERMISSION", "") message: NSLocalizedString(@"ALERT_MESSAGE_CAMERA_PHOTO_PERMISSION_QRCODE_READER", "") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAct = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }];
        [alert addAction:okAct];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAct];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        
        // Solicita permissão
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                
                [self goToCameraScanner];
                
            } else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (dataList.count > 0){
        NSMutableDictionary *sectionDic = [dataList objectAtIndex:section];
        NSMutableArray *currentList = [sectionDic valueForKey:[[sectionDic allKeys] objectAtIndex:0]];
        return currentList.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScannerCardCell";
    
    TVC_ScannerHistory *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[TVC_ScannerHistory alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Data
    if (dataList.count > 0){
        NSDictionary *sectionDic = [dataList objectAtIndex:indexPath.section];
        NSMutableArray *currentArray = [sectionDic valueForKey:[[sectionDic allKeys] objectAtIndex:0]];
        NSDictionary *currentDic = [currentArray objectAtIndex:indexPath.row];
        //
        cell.lbPromotionName.text = [NSString stringWithFormat:@"📌  %@", [currentDic valueForKey:kCouponPromotionNameKey]];
        cell.lbUserStoreName.text = [currentDic valueForKey:kCouponConsumerNameKey];
        cell.lbUserStoreEmail.text = [currentDic valueForKey:kCouponConsumerEmailKey];
        cell.lbScanDate.text = [ToolBox dateHelper_StringFromDate: [ToolBox dateHelper_DateFromString:[currentDic valueForKey:kCouponConsumeDateKey] withFormat:TOOLBOX_DATA_HIFEN_LONGA_INVERTIDA] withFormat:TOOLBOX_DATA_BARRA_LONGA_NORMAL];
        //
        if ([[currentDic valueForKey:kCouponDiscountTypeKey] isEqualToString:kCouponDiscountTypeCredit]){
            [cell updateLayout:eStoreDiscountType_Value withBackgroundImageSize:CGSizeMake(self.view.frame.size.width - 4, 86)];
            double valueD = [[currentDic valueForKey:kCouponDiscountValueKey] doubleValue];
            cell.lbDiscount.text = [ToolBox converterHelper_MonetaryStringForValue:valueD];
            //
            cell.lbType.text = @"Crédito";
        }else{
            if ([[currentDic valueForKey:kCouponDiscountTypeKey] isEqualToString:kCouponDiscountTypePercentage]){
                [cell updateLayout:eStoreDiscountType_Percentage withBackgroundImageSize:CGSizeMake(self.view.frame.size.width - 4, 86)];
                cell.lbDiscount.text = [NSString stringWithFormat:@"%@%%", [currentDic valueForKey:kCouponDiscountValueKey]];
            }else{
                [cell updateLayout:eStoreDiscountType_Value withBackgroundImageSize:CGSizeMake(self.view.frame.size.width - 4, 86)];
                double valueD = [[currentDic valueForKey:kCouponDiscountValueKey] doubleValue];
                cell.lbDiscount.text = [ToolBox converterHelper_MonetaryStringForValue:valueD];
            }
            //
            cell.lbType.text = @"Desconto";
        }
        
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 28.0)];
    UILabel *lbHeader = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 28.0)];
    lbHeader.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbHeader.textColor = [UIColor darkTextColor];
    lbHeader.textAlignment = NSTextAlignmentCenter;
    lbHeader.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:17];
    [view addSubview:lbHeader];
    
    //Texto
    if (scanHistoryList.count == 0){
        lbHeader.text = NSLocalizedString(@"LABEL_NODATA", @"");
    }else{
        NSDictionary *sectionDic = [dataList objectAtIndex:section];
        NSString* sData = [[sectionDic allKeys] objectAtIndex:0];
        NSDate *data = [ToolBox dateHelper_DateFromString:sData withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
        NSString *wData = [ToolBox dateHelper_IdentifiesYesterdayTodayTomorrowFromDate:data];
        if ([wData isEqualToString:@""]){
            lbHeader.text = [[sectionDic allKeys] objectAtIndex:0];
        }else{
            lbHeader.text = wData;
        }
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.0;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //Label histórico
    lblScanner.backgroundColor = [UIColor darkGrayColor];
    lblScanner.textColor = [UIColor whiteColor];
    lblScanner.font = [UIFont fontWithName:FONT_DEFAULT_ITALIC size:16];
    lblScanner.text = @"Buscando cupons...";
    
    //Button
    btnScanner.backgroundColor = [UIColor clearColor];
    [btnScanner setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnScanner.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    btnScanner.titleLabel.numberOfLines = 0;
    [btnScanner setTitle:@"Escanear\nQRCode" forState:UIControlStateNormal];
    [btnScanner setExclusiveTouch:YES];
    [btnScanner setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnScanner.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnScanner setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnScanner.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    UIImage *iconCreate = [ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:[UIImage imageNamed:@"CouponScannerIcon_QRCode"]];
    [btnScanner setImage:iconCreate forState:UIControlStateNormal];
    [btnScanner setImageEdgeInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 10.0)];
    [btnScanner.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnScanner setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [btnScanner setTintColor:[UIColor whiteColor]];
    //btnScanner.tag = 1;
    
    //TableView
    [tvScanner setTableFooterView:[UIView new]];
    [tvScanner setBackgroundColor:[UIColor clearColor]];
}

- (void)goToCameraScanner
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Utilities" bundle:[NSBundle mainBundle]];
    BarcodeReaderViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BarcodeReaderViewController"];
    [vc awakeFromNib];
    //
    vc.typesToRead = @[AVMetadataObjectTypeQRCode];
    vc.rectScanType = ScannableAreaFormatTypeLargeSquare;
    vc.resultType = BarcodeReaderResultTypeNotifyAndClose;
    vc.titleScreen = @"Escanear Cupom";
    vc.instructionText = nil;
    vc.validationKey = kSecureCouponHashKey;
    vc.validationValue = kSecureCouponHashValue;
    //
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadDataList
{
    //************************************************************************************
    //Remover após testes (histórico manual para preencher a lista)
    /*
     scanHistoryList = [NSMutableArray new];
     
     NSMutableDictionary *dicTeste1 = [NSMutableDictionary new];
     [dicTeste1 setValue:@"Promoção: Mais para você!" forKey:kCouponPromotionNameKey];
     [dicTeste1 setValue:@"Maria Aurora" forKey:kCouponConsumerNameKey];
     [dicTeste1 setValue:@"maria.aurora@gmail.com" forKey:kCouponConsumerEmailKey];
     [dicTeste1 setValue:@"2016-09-12 08:15" forKey:kCouponConsumeDateKey];
     [dicTeste1 setValue:@"15" forKey:kCouponDiscountValueKey];
     [dicTeste1 setValue:kCouponDiscountTypePercentage forKey:kCouponDiscountTypeKey];
     [scanHistoryList addObject:dicTeste1];
     //
     NSMutableDictionary *dicTeste2 = [NSMutableDictionary new];
     [dicTeste2 setValue:@"Promoção: Mais para você!" forKey:kCouponPromotionNameKey];
     [dicTeste2 setValue:@"Gerson Teixeira" forKey:kCouponConsumerNameKey];
     [dicTeste2 setValue:@"gerson.teixeira@gmail.com" forKey:kCouponConsumerEmailKey];
     [dicTeste2 setValue:@"2016-09-12 08:41" forKey:kCouponConsumeDateKey];
     [dicTeste2 setValue:@"15" forKey:kCouponDiscountValueKey];
     [dicTeste2 setValue:kCouponDiscountTypePercentage forKey:kCouponDiscountTypeKey];
     [scanHistoryList addObject:dicTeste2];
     //
     NSMutableDictionary *dicTeste3 = [NSMutableDictionary new];
     [dicTeste3 setValue:@"Promoção: Mais para você!" forKey:kCouponPromotionNameKey];
     [dicTeste3 setValue:@"Erico Gimenes Teixeira" forKey:kCouponConsumerNameKey];
     [dicTeste3 setValue:@"erico.gimenes@gmail.com" forKey:kCouponConsumerEmailKey];
     [dicTeste3 setValue:@"2016-09-22 08:15" forKey:kCouponConsumeDateKey];
     [dicTeste3 setValue:@"120.00" forKey:kCouponDiscountValueKey];
     [dicTeste3 setValue:kCouponDiscountTypeValue forKey:kCouponDiscountTypeKey];
     [scanHistoryList addObject:dicTeste3];
     //
     NSMutableDictionary *dicTeste4 = [NSMutableDictionary new];
     [dicTeste4 setValue:@"Promoção: Mais para você!" forKey:kCouponPromotionNameKey];
     [dicTeste4 setValue:@"Erico Gimenes Teixeira 2" forKey:kCouponConsumerNameKey];
     [dicTeste4 setValue:@"erico.gimenes@gmail.com" forKey:kCouponConsumerEmailKey];
     [dicTeste4 setValue:@"2016-09-23 08:15" forKey:kCouponConsumeDateKey];
     [dicTeste4 setValue:@"50.00" forKey:kCouponDiscountValueKey];
     [dicTeste4 setValue:kCouponDiscountTypeValue forKey:kCouponDiscountTypeKey];
     [scanHistoryList addObject:dicTeste4];
     //
     NSMutableDictionary *dicTeste5 = [NSMutableDictionary new];
     [dicTeste5 setValue:@"Promoção: Mais para você!" forKey:kCouponPromotionNameKey];
     [dicTeste5 setValue:@"Erico Gimenes Teixeira 3" forKey:kCouponConsumerNameKey];
     [dicTeste5 setValue:@"erico.gimenes@gmail.com" forKey:kCouponConsumerEmailKey];
     [dicTeste5 setValue:@"2016-09-15 08:15" forKey:kCouponConsumeDateKey];
     [dicTeste5 setValue:@"35" forKey:kCouponDiscountValueKey];
     [dicTeste5 setValue:kCouponDiscountTypePercentage forKey:kCouponDiscountTypeKey];
     [scanHistoryList addObject:dicTeste5];
     //
     NSMutableDictionary *dicTeste6 = [NSMutableDictionary new];
     [dicTeste6 setValue:@"Promoção: Mais para você!" forKey:kCouponPromotionNameKey];
     [dicTeste6 setValue:@"Erico Gimenes Teixeira 4" forKey:kCouponConsumerNameKey];
     [dicTeste6 setValue:@"erico.gimenes@gmail.com" forKey:kCouponConsumerEmailKey];
     [dicTeste6 setValue:@"2016-09-01 08:15" forKey:kCouponConsumeDateKey];
     [dicTeste6 setValue:@"30.00" forKey:kCouponDiscountValueKey];
     [dicTeste6 setValue:kCouponDiscountTypeValue forKey:kCouponDiscountTypeKey];
     [scanHistoryList addObject:dicTeste6];
    */
    //************************************************************************************
    
    
    //Ordenando a lista original:
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:kCouponConsumeDateKey ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSMutableArray *workList = [[NSMutableArray alloc]initWithArray:[scanHistoryList sortedArrayUsingDescriptors:sortDescriptors]];
    
    dataList = [NSMutableArray new];
    
    //Separando a lista em dias:
    NSMutableArray *keysList = [NSMutableArray new];
    for (int i=0; i<scanHistoryList.count; i++){
        NSDictionary *dicAux = [workList objectAtIndex:i];
        NSString *dataOriginal = [dicAux valueForKey:kCouponConsumeDateKey];
        NSString *dataResumida = [ToolBox dateHelper_StringFromDate: [ToolBox dateHelper_DateFromString:dataOriginal withFormat:TOOLBOX_DATA_HIFEN_LONGA_INVERTIDA] withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
        
        if (![keysList containsObject:dataResumida]){
            [keysList addObject:dataResumida];
        }
    }
    
    //Neste ponto 'keysList' possui todos os dias da lista
    for (int i=0; i<keysList.count; i++){
        [dataList addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSMutableArray new], [keysList objectAtIndex:i], nil]];
    }
    
    //Aqui os itens são separados por dia (para criar as seções da tabela)
    for (int i=0; i<scanHistoryList.count; i++){
        
        NSDictionary *dicAux = [workList objectAtIndex:i];
        NSString *dataOriginal = [dicAux valueForKey:kCouponConsumeDateKey];
        NSString *dataResumida = [ToolBox dateHelper_StringFromDate: [ToolBox dateHelper_DateFromString:dataOriginal withFormat:TOOLBOX_DATA_HIFEN_LONGA_INVERTIDA] withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
        //
        for (int j=0; j<keysList.count; j++){
            if ([dataResumida isEqualToString:[keysList objectAtIndex:j]]){
                NSMutableDictionary *sectionDic = [dataList objectAtIndex:j];
                NSMutableArray *currentList = [sectionDic valueForKey:[[sectionDic allKeys] objectAtIndex:0]];
                [currentList addObject:dicAux];
            }
        }
    }
    
    if (scanHistoryList.count > 0){
        if (scanHistoryList.count == 1){
            lblScanner.text = @"1 cupom escaneado!";
        }else{
            lblScanner.text = [NSString stringWithFormat:@"%li cupons escaneados!", scanHistoryList.count];
        }
    }else{
        lblScanner.text = @"Nenhum cupom escaneado!";
    }
    
    [tvScanner reloadData];
}

- (void)processCouponData
{
    //Buscando dados do cupom
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Processing];
        });
        
        __block NSDictionary *dicMessage = [ToolBox converterHelper_DictionaryFromStringJson:scannedCouponData];
        
        NSString *couponCode = [dicMessage valueForKey:kCouponCodeKey];
        int consumerID = [[dicMessage valueForKey:kCouponConsumerIDKey] intValue];
        
        //A busca dos dados do cupom servem para confirmar a validade dos dados lidos no QRCode:
        [connectionManager getTicketDiscountInfo:couponCode consumerID:consumerID withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error)
        {
             [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
             
             if (error){
                 SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                 [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:[error localizedDescription] closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
             }else{
                 
                 NSLog(@"\n//************************\nDados do CUPOM: %@\n//************************", response);
                 
                 //Sucesso ao buscar dados do cupom:
                 NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithDictionary:[ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:response withString:@""]];
                 [mDic setValue:[dicMessage valueForKey:kCouponConsumerIDKey] forKey:kCouponConsumerIDKey];
                 [mDic setValue:[dicMessage valueForKey:kCouponOriginAppID] forKey:kCouponOriginAppID];
                 [mDic setValue:[dicMessage valueForKey:kCouponPromotionIDKey] forKey:kCouponPromotionIDKey];
                 [mDic setValue:[dicMessage valueForKey:kCouponDiscountTypeKey] forKey:kCouponDiscountTypeKey];
                 [self consumeCouponDiscount:mDic];
             }
         }];
        
    }else{
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (void)consumeCouponDiscount:(NSDictionary*)dicCoupon
{
    //Iniciando o localizador
    //[AppD.locationManager startMonitoringLocation];
    
    //Texto para exibição do desconto
    NSMutableString *couponInfo = [NSMutableString new];
    [couponInfo appendFormat:@"Promoção: %@\n", [dicCoupon valueForKey:kCouponPromotionNameKey]];
    [couponInfo appendFormat:@"Consumidor: %@ (%@)\n", [dicCoupon valueForKey:kCouponConsumerNameKey], [dicCoupon valueForKey:kCouponConsumerEmailKey]];
    
    if ([[dicCoupon valueForKey:kCouponDiscountTypeKey] isEqualToString:kCouponDiscountTypeCredit]){
        double valueD = [[dicCoupon valueForKey:kCouponDiscountValueKey] doubleValue];
        [couponInfo appendFormat:@"Crédito: %@\n", [ToolBox converterHelper_MonetaryStringForValue:valueD]];
    }else{
        if ([[dicCoupon valueForKey:kCouponDiscountTypeKey] isEqualToString:kCouponDiscountTypePercentage]){
            [couponInfo appendFormat:@"Desconto: %@%%\n", [dicCoupon valueForKey:kCouponDiscountValueKey]];
        }else{
            double valueD = [[dicCoupon valueForKey:kCouponDiscountValueKey] doubleValue];
            [couponInfo appendFormat:@"Desconto: %@\n", [ToolBox converterHelper_MonetaryStringForValue:valueD]];
        }
    }
    
    //Consumindo o desconto
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cupom QRCode" message: couponInfo preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAct = [UIAlertAction actionWithTitle:@"Utilizar Desconto!" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        
        //Consumindo o coupon
        ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
        
        if ([connectionManager isConnectionActive])
        {
            dispatch_async(dispatch_get_main_queue(),^{
                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Processing];
            });
            
            NSMutableDictionary *parameters = [NSMutableDictionary new];
            [parameters setValue:[dicCoupon valueForKey:kCouponConsumerIDKey ] forKey:kCouponConsumerIDKey];
            [parameters setValue:[dicCoupon valueForKey:kCouponCodeKey ] forKey:kCouponCodeKey];
            [parameters setValue:[dicCoupon valueForKey:kCouponOriginAppID ] forKey:kCouponOriginAppID];
            [parameters setValue:[NSString stringWithFormat:@"%f", locationService.latitude] forKey:@"latitude"];
            [parameters setValue:[NSString stringWithFormat:@"%f", locationService.longitude] forKey:@"longitude"];
            [parameters setValue:[ToolBox deviceHelper_IdentifierForVendor] forKey:@"device_id_vendor"];
            
            NSLog(@"\n//************************\nDados enviados CUPOM: %@\n//************************", parameters);
            
            [connectionManager consumeTicketDiscount:parameters withCompletionHandler:^(NSDictionary *response, NSError *error)
             {
                 [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                 
                 if (error){
                     SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                     [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:[error localizedDescription] closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                 }else{
                     
                     NSLog(@"\n//************************\nResposta consumo CUPOM: %@\n//************************", response);
                     
                     NSArray *allKeys = [response allKeys];
                     
                     if ([allKeys containsObject:@"errors"]){
                         
                         NSArray *errors = [response valueForKey:@"errors"];
                         NSDictionary *dicFirst = [errors firstObject];
                         NSDictionary *dicError = [dicFirst valueForKey:@"error"];
                         NSString *errorText = [dicError valueForKey:@"title"];
                         //
                         SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                         [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:errorText closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                         
                     }else{
                         
                         if ([allKeys containsObject:@"status"]){
                             
                             NSString *status = [response valueForKey:@"status"];
                             if ([status isEqualToString:@"used"]){
                                 
                                 //Sucesso ao consumir coupon:
                                 NSMutableDictionary *dicToSave = [[NSMutableDictionary alloc]initWithDictionary:dicCoupon];
                                 [dicToSave setValue:[ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_LONGA_INVERTIDA] forKey:kCouponConsumeDateKey];
                                 
                                 if (scanHistoryList == nil){
                                     scanHistoryList = [NSMutableArray new];
                                 }
                                 [scanHistoryList addObject:dicToSave];
                                 
                                 [self saveUserScans:scanHistoryList withUserIdentifier:[NSString stringWithFormat:@"USER_%i", AppD.loggedUser.userID]];
                                 
                                 //TODO:
                                 //log adalive do coupon
                                 
                                 SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                 [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                                     [self reloadDataList];
                                 }];
                                 [alert showSuccess:@"Cupom Desconto" subTitle:@"O cupom foi utilizado com sucesso!" closeButtonTitle:nil duration:0.0];
                                 
                             }else{
                                 SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                 [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:@"Erro ao consumir o cupom. Por favor, tente novamente." closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                             }
                             
                         }else{
                             SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                             [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:@"Erro ao consumir o cupom. Por favor, tente novamente." closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                         }
                         
                     }
                 }
             }];
            
        }else{
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        }
    }];
    [alert addAction:okAct];
    //
    UIAlertAction *okCancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        scannedCouponData = nil;
    }];
    [alert addAction:okCancel];
    //
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UTILS (General Use)

- (void)createHelpButton
{
    UIImage *image = [[UIImage imageNamed:@"NavControllerHelpIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    [button setClipsToBounds:YES];
    [button setExclusiveTouch:YES];
    [button setTintColor:AppD.styleManager.colorPalette.textNormal];
    [button addTarget:self action:@selector(actionHelp:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[button.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[button.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = b;
}

#pragma mark - Store Data

- (bool)saveUserScans:(NSArray*)scanList withUserIdentifier:(NSString*)userIdentifier
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
    
    if (![self directoryExists:profileDataDir])
    {
        if (![self createDirectoryAtPath:profileDataDir]) {
            return NO;
        }
    }
    
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", userIdentifier]];
    
    if (![self fileExists:profileDataFile])
    {
        if (![self createFileAtPath:profileDataFile])
        {
            return NO;
        }
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:scanList,  userIdentifier,nil];
    return [dic writeToFile:profileDataFile atomically:YES];
}

- (NSArray*)loadUserScans:(NSString*)userIdentifier
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *profileDataDir = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", PROFILE_DIRECTORY]];
    
    NSString *profileDataFile = [profileDataDir stringByAppendingString:[NSString stringWithFormat:@"/%@", userIdentifier]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:profileDataFile];
    
    if(dic){
        return [NSArray arrayWithArray:[dic valueForKey:userIdentifier]];
    }else{
        return [NSArray new];
    }
}

#pragma mark -

-(BOOL)directoryExists:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:directoryPath];
}

-(BOOL)fileExists:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

-(BOOL)createDirectoryAtPath:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
}

-(BOOL)createFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

@end
