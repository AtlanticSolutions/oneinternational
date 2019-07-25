//
//  VC_InvoiceScan.m
//  ShoppingBH
//
//  Created by Erico GT on 03/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_InvoiceScan.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_InvoiceScan()

//Layout
@property (nonatomic, weak) IBOutlet UIImageView *imvScanner;
@property (nonatomic, weak) IBOutlet UIButton *btnNewPhoto;
@property (nonatomic, weak) IBOutlet UIButton *btnRegister;

//Data
@property (nonatomic, assign) bool isLoaded;
@property (nonatomic, strong) UIImage *invoicePhoto;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSMutableArray<ShoppingPromotion*> *promotionsList;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_InvoiceScan
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize isLoaded, invoicePhoto, placeholderImage, promotionsList;
@synthesize imvScanner, btnNewPhoto, btnRegister;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //Button Profile Pic
    self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_INVOICE_SCAN", @"");
    
    promotionsList = [NSMutableArray new];
    placeholderImage = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self.view layoutIfNeeded];
        [self setupLayout];
        
        imvScanner.alpha = 0.0;
        btnRegister.alpha = 0.0;
        btnNewPhoto.alpha = 0.0;
        
        imvScanner.image = placeholderImage;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (!isLoaded){
//        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
//        [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", "") withType:SCLAlertButtonType_Normal actionBlock:^{
//            [self actionTakePhoto:nil];
//            imvScanner.alpha = 1.0;
//            btnRegister.alpha = 1.0;
//            btnNewPhoto.alpha = 1.0;
//            isLoaded = true;
//        }];
//        [alert showInfo:@"Scanner NF" subTitle:@"Fotografe sua nota fiscal enquadrando-a por inteiro.\n\nApós o envio ela será processada e estará sujeita às devidas validações." closeButtonTitle:nil duration:0.0];
//    }
    
    if (!isLoaded){
        [self getPromotionsFromServer];
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionTakePhoto:(id)sender
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //
        [self presentViewController:picker animated:YES completion:NULL];
        
    } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        
        //Explica o motivo da requisição
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        //
        [alert showInfo:NSLocalizedString(@"ALERT_TITLE_CAMERA_PERMISSION", "") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CAMERA_PHOTO_PERMISSION_NF_REGISTER", "") closeButtonTitle:nil duration:0.0];
        
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        
        // Solicita permissão
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                
                NSLog(@"Granted access to %@", AVMediaTypeVideo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = NO;
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                    //
                    [self presentViewController:picker animated:YES completion:NULL];
                    
                });
                
            } else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
            }
        }];
    }
}

- (IBAction)actionRegisterNF:(id)sender
{
    if (invoicePhoto == nil){
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_INVOICE_SCAN_EMPTY", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
        
    }else{
        
        [self sendInvoicePhotoToServer];
    }
}

- (IBAction)actionTapOnPhoto:(id)sender
{
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:imvScanner.image backgroundImage:nil andDelegate:self];
    photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    photoView.autoresizingMask = (1 << 6) -1;
    photoView.alpha = 0.0;
    //
    [AppD.window addSubview:photoView];
    [AppD.window bringSubviewToFront:photoView];
    //
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 1.0;
    }];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)photoViewDidHide:(VIPhotoView *)photoView
{
    __block id pv = photoView;
    
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [pv removeFromSuperview];
        pv = nil;
    }];
}

#pragma mark - Image picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage* chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    //
    imvScanner.image = chosenImage;
    //
    invoicePhoto = [self normalizeInvoiceImage:chosenImage usingMaxResolution:2048]; //4032

    [btnRegister setEnabled:YES];
    btnRegister.alpha = 1.0;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    imvScanner.backgroundColor = nil;
    btnNewPhoto.backgroundColor = nil;
    btnRegister.backgroundColor = nil;
    
    btnNewPhoto.backgroundColor = [UIColor clearColor];
    [btnNewPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnNewPhoto.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnNewPhoto setTitle:NSLocalizedString(@"BUTTON_TITLE_NF_SCAN_TAKE_PHOTO", @"") forState:UIControlStateNormal];
    [btnNewPhoto setExclusiveTouch:YES];
    [btnNewPhoto setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnNewPhoto.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:[UIColor grayColor]] forState:UIControlStateNormal];
    
    btnRegister.backgroundColor = [UIColor clearColor];
    [btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnRegister setTitle:NSLocalizedString(@"BUTTON_TITLE_NF_SCAN_INVOICE_REGISTER", @"") forState:UIControlStateNormal];
    [btnRegister setExclusiveTouch:YES];
    [btnRegister setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnNewPhoto.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
    
    [btnRegister setEnabled:NO];
    btnRegister.alpha = 0.5;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapOnPhoto:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    //tapRecognizer.delegate = self;
    [imvScanner addGestureRecognizer:tapRecognizer];
}

- (UIImage *)normalizeInvoiceImage:(UIImage *)imageIn usingMaxResolution:(int)kMaxResolution
{
    //...thx: http://blog.logichigh.com/2008/06/05/uiimage-fix/
    //int kMaxResolution = 2048; // Or whatever
    
    CGImageRef        imgRef    = imageIn.CGImage;
    CGFloat           width     = CGImageGetWidth(imgRef);
    CGFloat           height    = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect            bounds    = CGRectMake( 0, 0, width, height );
    
    if ( width > kMaxResolution || height > kMaxResolution )
    {
        CGFloat ratio = width/height;
        
        if (ratio > 1)
        {
            bounds.size.width  = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = kMaxResolution;
            bounds.size.width  = bounds.size.height * ratio;
        }
    }
    
    CGFloat            scaleRatio   = bounds.size.width / width;
    CGSize             imageSize    = CGSizeMake( CGImageGetWidth(imgRef),         CGImageGetHeight(imgRef) );
    UIImageOrientation orient       = imageIn.imageOrientation;
    CGFloat            boundHeight;
    
    switch(orient)
    {
        case UIImageOrientationUp:                                        //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored:                                //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:                                      //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:                              //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:                              //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft:                                      //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:                             //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:                                     //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise: NSInternalInconsistencyException format: @"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext( bounds.size );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ( orient == UIImageOrientationRight || orient == UIImageOrientationLeft )
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM( context, transform );
    
    CGContextDrawImage( UIGraphicsGetCurrentContext(), CGRectMake( 0, 0, width, height ), imgRef );
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return( imageCopy );
    
    /*
    NSData *iData = UIImageJPEGRepresentation(imageCopy, 1.0);
    double sizeB = (double)[iData length];
    double sizeMB = (sizeB / 1024.0 / 1024.0);
    if (sizeMB > 4.0){
        //return [self normalizeInvoiceImage:imageCopy];
        NSLog(@"normalizeInvoiceImage > inputImageSize: %@", [ToolBox messureHelper_FormatSizeString:sizeB]);
        return [self normalizeInvoiceImage:imageCopy usingMaxResolution:(kMaxResolution - 500)];
    }else{
        return( imageCopy );
    }
     */
}

#pragma mark - Connections

- (void)sendInvoicePhotoToServer
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Processing];
        });
        
        NSMutableDictionary *dicImage = [NSMutableDictionary new];
        //O código abaixo foi pego da ToolBox para se poder usar uma variante:
        NSString *base64Image = [UIImageJPEGRepresentation(invoicePhoto, 0.9) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        [dicImage setValue:base64Image forKey:@"base64_image"];
        //
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:dicImage forKey:@"sh_promotion_nf"];
        
        [connectionManager postInvoicePhotoUsingParameters:parameters WithCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (!error) {
                if (response) {
                    
                    if ([[response allKeys] containsObject:@"nf"]){
                        
                        NSDictionary *dResult = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:[response valueForKey:@"nf"] withString:@""];
                        
                        //TODO: no momento, o sucesso é determinado se o dicionário 'nf' possui conteúdo ou não
                        if ([[dResult allKeys] containsObject:@"image_url"]){
                            
                            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                            //
                            [alert addButton:NSLocalizedString(@"BUTTON_TITLE_NF_SCAN_INVOICE_NEW", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
                                invoicePhoto = nil;
                                [btnRegister setEnabled:NO];
                                btnRegister.alpha = 0.5;
                                imvScanner.image = placeholderImage;
                            }];
                            //
                            [alert addButton:NSLocalizedString(@"BUTTON_TITLE_NF_SCAN_SEE_MY_INVOICES", @"") withType:SCLAlertButtonType_Question actionBlock:^{
                                //Instanciando a nova view destino
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Invoice" bundle:[NSBundle mainBundle]];
                                VC_MyInvoices *vcInvoices = [storyboard instantiateViewControllerWithIdentifier:@"VC_MyInvoices"];
                                [vcInvoices awakeFromNib];
                                //
                                UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
                                topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                                topVC.navigationController.navigationBar.tintColor = AppD.styleManager.colorPalette.textNormal;
                                //
                                //Abrindo a tela
                                [AppD.rootViewController.navigationController pushViewController:vcInvoices animated:YES];
                                
                                //Readaptando a lista de controllers:
                                NSMutableArray *listaC = [[NSMutableArray alloc]initWithArray:[AppD.rootViewController.navigationController viewControllers]];
                                NSMutableArray *listaF = [NSMutableArray new];
                                [listaF addObject:[listaC objectAtIndex:0]]; //vc_configuracoes
                                [listaF addObject:[listaC objectAtIndex:1]]; //vc_login
                                [listaF addObject:[listaC objectAtIndex:2]]; //vc_timeline
                                [listaF addObject:vcInvoices];
                                
                                //Carregando dados
                                AppD.rootViewController.navigationController.viewControllers = listaF;
                            }];
                            //
                            [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:^{
                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                            }];
                            //
                            [alert showSuccess:self title:NSLocalizedString(@"ALERT_TITLE_SUCCESS", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_INVOICE_SCAN_SUCCESS", @"") closeButtonTitle:nil duration:0.0];
                            
                        }else{
                            //Erro
                            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SEND_INVOICE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                        }
                        
                    }else{
                        //Erro
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SEND_INVOICE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                }else{
                    //Erro
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SEND_INVOICE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }
            } else {
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_SEND_INVOICE_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
        }];
    } else {
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        //
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (void)getPromotionsFromServer
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getAvailablePromotionsWithCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (!error) {
                if (response) {
                    
                    if ([[response allKeys] containsObject:@"promotions"]){
                        
                        NSArray *pList = [[NSArray alloc] initWithArray:[response valueForKey:@"promotions"]];
                        
                        promotionsList = [NSMutableArray new];
                        
                        for (NSDictionary *dic in pList){
                            [promotionsList addObject:[ShoppingPromotion createObjectFromDictionary:dic]];
                        }
                        
                        if (promotionsList.count > 0){
                            
                            bool userRegistered = false;
                            bool promoAvailable = false;
                            
                            for (ShoppingPromotion *promo in promotionsList){
                                if (promo.isInvoiceScanPermited){
                                    promoAvailable = true;
                                    if (promo.isUserRegistered){
                                        userRegistered = true;
                                        break;
                                    }
                                    
                                }
                            }
                            
                            if (promoAvailable){
                                if (userRegistered){
                                    //Sucesso, pode enviar nota fiscal:
                                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                    [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", "") withType:SCLAlertButtonType_Normal actionBlock:^{
                                        [self actionTakePhoto:nil];
                                        imvScanner.alpha = 1.0;
                                        btnRegister.alpha = 1.0;
                                        btnNewPhoto.alpha = 1.0;
                                        isLoaded = true;
                                    }];
                                    
                                    [alert showInfo:NSLocalizedString(@"ALERT_TITLE_INVOICE_SCAN_INFO", "") subTitle:NSLocalizedString(@"ALERT_MESSAGE_INVOICE_SCAN_INFO", "") closeButtonTitle:nil duration:0.0];
                                }else{
                                    //Mensagem de usuário não registrado em nenhuma promoção:
                                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                    [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_NO_APP", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_INVOICE_SCAN_NO_REGISTRATION", "") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                                }
                            }else{
                                //Mensagem de nenhuma promoção disponível
                                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                                [alert showInfo:self title:NSLocalizedString(@"ALERT_TITLE_NO_APP", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_INVOICE_SCAN_NO_PROMOTION", "") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                            }
                            
                        }else{
                            //Erro:
                            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                            [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                        }
                        
                    }else{
                        //Erro
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }
                }else{
                    //Erro
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }
            } else {
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
        }];
    } else {
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        //
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

@end
