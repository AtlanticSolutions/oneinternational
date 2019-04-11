//
//  MediaTransferVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 08/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "MediaTransferVC.h"
#import "AppDelegate.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerFileResponse.h"
#import "BarcodeReaderViewController.h"
#import "VC_WebViewCustom.h"
#import "FloatingPickerView.h"
#import "VC_WebFileShareViewer.h"

#define MT_KEY_CODE @"code"
#define MT_KEY_NAME @"name"
#define MT_KEY_TYPE @"type"
#define MT_KEY_EXTENSION @"extension"
//
#define MT_VALUE_CODE @"LAB360MT"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface MediaTransferVC()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, FloatingPickerViewDelegate>

//Data:
@property (nonatomic, strong) GCDWebServer *webServer;
@property (nonatomic, strong) NSString *scannedText;
//
@property (nonatomic, strong) id mediaData;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) NSString *mediaURL;
@property (nonatomic, strong) NSString *mediaName;
@property (nonatomic, strong) NSString *mediaExtension;
//
@property (nonatomic, assign) TransferMediaType transferMediaTypeToOpen;
//
@property (nonatomic, assign) BOOL isLoaded;

//Layout:
@property(nonatomic, strong) FloatingPickerView *pickerView;
//
@property (nonatomic, weak) IBOutlet UIButton *btnShare;
@property (nonatomic, weak) IBOutlet UIButton *btnFind;
@property (nonatomic, weak) IBOutlet UIImageView *imgQRCode;

@end

#pragma mark - • IMPLEMENTATION
@implementation MediaTransferVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize webServer, scannedText, mediaData, mediaType, mediaURL, mediaName, mediaExtension, isLoaded, transferMediaTypeToOpen;
@synthesize pickerView, btnShare, btnFind, imgQRCode;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mediaData = nil;
    mediaType = nil;
    mediaURL = nil;
    mediaName = nil;
    mediaExtension = nil;
    scannedText = nil;
    isLoaded = NO;
    transferMediaTypeToOpen = TransferMediaTypeNone;
    //
    pickerView = [FloatingPickerView newFloatingPickerView];
    pickerView.contentStyle = FloatingPickerViewContentStyleAuto;
    pickerView.backgroundTouchForceCancel = YES;
    pickerView.tag = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self setupLayout:@"Transferir Mídia"];
        isLoaded = YES;
    }
    
    //Para teste de abertura de arquivo:
    //
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (scannedText != nil){
        [self openBrowser];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController])
    {
        //View controller was popped
        if ([self webServerLoggerIsRunning]){
            [self stopWebServer];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];

    if ([segue.identifier isEqualToString:@"SegueToBarcodeReader"]){
        BarcodeReaderViewController *vc = segue.destinationViewController;
        vc.typesToRead = @[AVMetadataObjectTypeQRCode];
        vc.rectScanType = ScannableAreaFormatTypeLargeSquare;
        vc.resultType = BarcodeReaderResultTypeNotifyAndClose;
        vc.titleScreen = @"Buscar Mídia";
        vc.instructionText = @"Procurando QRCode...";
        vc.validationKey = MT_KEY_CODE;
        vc.validationValue = MT_VALUE_CODE;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToWebFileShareViewer"]){
        VC_WebFileShareViewer *destViewController = (VC_WebFileShareViewer*)segue.destinationViewController;
        destViewController.fileURL = ((WebItemToShow*)sender).urlString;
        //
        destViewController.fileType = mediaExtension;
        destViewController.fileTitle = mediaName;
        //
        destViewController.titleScreen = ((WebItemToShow*)sender).titleMenu;
        //
        scannedText = nil;
        transferMediaTypeToOpen = TransferMediaTypeNone;
    }
    
    [btnShare setEnabled:YES];
    [btnFind setEnabled:YES];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionStartSharing:(UIButton*)sender
{
    if (sender.tag == 0){
        //Neste caso o compartilhamento vai começar:
        [btnFind setEnabled:NO];
        //
        [pickerView showFloatingPickerViewWithDelegate:self];
    }else{
        //Aqui o compartilhamento será interrompido:
        btnShare.tag = 0;
        [btnShare setTitle:@"Compartilhar Mídia" forState:UIControlStateNormal];
        [btnFind setEnabled:YES];
        //
        imgQRCode.image = nil;
        //
        [self stopWebServer];
    }
}

- (IBAction)actionStartSeeking:(UIButton*)sender
{
    [btnShare setEnabled:NO];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionBarcodeReaderResult:) name:BARCODE_READER_RESULT_NOTIFICATION_KEY object:nil];
    //
    [self performSegueWithIdentifier:@"SegueToBarcodeReader" sender:nil];
}

- (IBAction)actionBarcodeReaderResult:(NSNotification*)notification
{
    scannedText = [NSString stringWithFormat:@"%@", (NSString*)notification.object];
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BARCODE_READER_RESULT_NOTIFICATION_KEY object:nil];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - FloatingPickerElement

- (NSArray<FloatingPickerElement*>* _Nonnull)floatingPickerViewElementsList:(FloatingPickerView *)pickerView
{
    NSMutableArray *elements = [NSMutableArray new];
    
    FloatingPickerElement *element_1 = [FloatingPickerElement newElementWithTitle:@"Documentos" selection:YES tagID:0 enum:0 andData:nil];
    element_1.associatedEnum = TransferMediaTypeDocument;
    FloatingPickerElement *element_2 = [FloatingPickerElement newElementWithTitle:@"Imagens da Biblioteca" selection:NO tagID:0 enum:0 andData:nil];
    element_2.associatedEnum = TransferMediaTypeImage;
    FloatingPickerElement *element_3 = [FloatingPickerElement newElementWithTitle:@"Vídeos da Biblioteca" selection:NO tagID:0 enum:0 andData:nil];
    element_3.associatedEnum = TransferMediaTypeVideo;
    //
    [elements addObject:element_1];
    [elements addObject:element_2];
    [elements addObject:element_3];
    
    return elements;
}

//Appearence:
- (NSString* _Nonnull)floatingPickerViewTextForCancelButton:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Cancelar";
}

- (NSString* _Nonnull)floatingPickerViewTextForConfirmButton:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Confirmar";
}

- (NSString* _Nonnull)floatingPickerViewTitle:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Tipo de Mídia";
}

- (NSString* _Nonnull)floatingPickerViewSubtitle:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Selecione o tipo de mídia que deseja compartilhar:";
}

//Control:
- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willCancelPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    [btnFind setEnabled:YES];
    transferMediaTypeToOpen = TransferMediaTypeNone;
    //
    return YES;
}

- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willConfirmPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    if (elements.count == 0){
        return NO;
    }else{
        FloatingPickerElement *element = [elements firstObject];
        transferMediaTypeToOpen = element.associatedEnum;
        //
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self openFileSelector];
        });
        //
        return YES;
    }
}

- (void)floatingPickerViewDidShow:(FloatingPickerView* _Nonnull)pickerView
{
    NSLog(@"floatingPickerViewDidShow");
}

- (void)floatingPickerViewDidHide:(FloatingPickerView* _Nonnull)pickerView
{
    NSLog(@"floatingPickerViewDidHide");
}

//Aparência
- (UIColor* _Nonnull)floatingPickerViewBackgroundColorCancelButton:(FloatingPickerView* _Nonnull)pickerView
{
    return COLOR_MA_RED;
}

- (UIColor* _Nonnull)floatingPickerViewTextColorCancelButton:(FloatingPickerView* _Nonnull)pickerView
{
    return [UIColor whiteColor];
}

- (UIColor* _Nonnull)floatingPickerViewBackgroundColorConfirmButton:(FloatingPickerView* _Nonnull)pickerView
{
    return COLOR_MA_GREEN;
}

- (UIColor* _Nonnull)floatingPickerViewTextColorConfirmButton:(FloatingPickerView* _Nonnull)pickerView
{
    return [UIColor whiteColor];
}

- (UIColor* _Nonnull)floatingPickerViewSelectedBackgroundColor:(FloatingPickerView* _Nonnull)pickerView
{
    return [UIColor groupTableViewBackgroundColor];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    switch (transferMediaTypeToOpen) {
        case TransferMediaTypeNone:{
            NSLog(@"Ignoring type 'TransferMediaTypeNone'.");
        }break;
            
        case TransferMediaTypeDocument:{
            NSLog(@"Ignoring type 'TransferMediaTypeDocument'.");
        }break;
            
        case TransferMediaTypeImage:{
            if (@available(iOS 11.0, *)) {
                mediaURL = [info objectForKey:UIImagePickerControllerImageURL];
                mediaData = [NSData dataWithContentsOfFile:mediaURL];
                mediaType = [info objectForKey:UIImagePickerControllerMediaType];
                mediaName = @"file";
                mediaExtension = [mediaURL pathExtension];
            }else{
                mediaURL = nil;
                mediaData = UIImagePNGRepresentation((UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage]);
                mediaType = [info objectForKey:UIImagePickerControllerMediaType];
                mediaName = @"file";
                mediaExtension = @".png";
            }
        }break;
            
        case TransferMediaTypeVideo:{
            mediaType = [info objectForKey:UIImagePickerControllerMediaType];
            if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
                mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
                mediaData = [NSData dataWithContentsOfFile:mediaURL];
                mediaName = @"file";
                mediaExtension = [mediaURL pathExtension];
            }
        }break;
    }
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
    //Iniciando o servidor local de mídia:
    NSString *addressServer = [self startMediaWebServer];
    if (addressServer){
        [self generateImageWithText:addressServer];
    }else{
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Erro" subTitle:@"Não foi possível inicializar o servidor de mídia no momento." closeButtonTitle:@"OK" duration:0.0];
        //
        [btnShare setEnabled:YES];
        [btnFind setEnabled:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    //
    [btnShare setEnabled:YES];
    [btnFind setEnabled:YES];
}

#pragma mark - UIDocumentPickerDelegate


- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls
{
    if (transferMediaTypeToOpen == TransferMediaTypeDocument){
        NSURL *url = [urls firstObject];
        mediaURL = url.absoluteString;
        mediaData = [NSData dataWithContentsOfURL:url];
        mediaType = @"document";
        mediaName = [mediaURL lastPathComponent];
        mediaExtension = [mediaURL pathExtension];
    }
    
    [controller dismissViewControllerAnimated:NO completion:NULL];
    
    //Iniciando o servidor local de mídia:
    NSString *addressServer = [self startMediaWebServer];
    if (addressServer){
        [self generateImageWithText:addressServer];
    }else{
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Erro" subTitle:@"Não foi possível inicializar o servidor de mídia no momento." closeButtonTitle:@"OK" duration:0.0];
        //
        [btnShare setEnabled:YES];
        [btnFind setEnabled:YES];
    }
}

// called if the user dismisses the document picker without selecting a document (using the Cancel button)
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    //
    [btnShare setEnabled:YES];
    [btnFind setEnabled:YES];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    btnShare.backgroundColor = [UIColor clearColor];
    [btnShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnShare.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnShare setTitle:@"Compartilhar Mídia" forState:UIControlStateNormal];
    [btnShare setExclusiveTouch:YES];
    [btnShare setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnShare.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnShare setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnShare.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnFind.backgroundColor = [UIColor clearColor];
    [btnFind setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFind.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnFind setTitle:@"Buscar Mídia" forState:UIControlStateNormal];
    [btnFind setExclusiveTouch:YES];
    [btnFind setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnFind.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnFind setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnFind.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    imgQRCode.backgroundColor = nil;
    imgQRCode.image = nil;
}

- (void)generateImageWithText:(NSString*)str
{
    imgQRCode.image = nil;
    //
    if (str != nil && ![str isEqualToString:@""]){
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        CGAffineTransform transform = CGAffineTransformMakeScale(10.0, 10.0);
        
        if (filter){
            NSData *strData = [str dataUsingEncoding:NSISOLatin1StringEncoding];
            [filter setValue:strData forKey:@"inputMessage"];
            [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
            CIImage *ciImage = [filter.outputImage imageByApplyingTransform:transform];
            UIImage *finalImage = [UIImage imageWithCIImage:ciImage];
            imgQRCode.image = finalImage;
            //
            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
            [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
                [btnShare setTitle:@"Parar Compartilhamento" forState:UIControlStateNormal];
                btnShare.tag = 1;
            }];
            [alert showSuccess:@"Compartilhar" subTitle:@"Escaneie o QRCode abaixo do segundo dispositivo, para o qual deseja disponibilizar o conteúdo de mídia." closeButtonTitle:nil duration:0.0];
        }
    }
}

- (void)openFileSelector
{
    switch (transferMediaTypeToOpen) {
        case TransferMediaTypeNone:{
            NSLog(@"Ignoring type 'TransferMediaTypeNone'.");
        }break;
           
        case TransferMediaTypeDocument:{
            NSArray *types = @[(NSString*)kUTTypeContent, (NSString*)kUTTypeCompositeContent];
            UIDocumentPickerViewController *docPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];
            //docPicker.allowsMultipleSelection = NO;
            docPicker.delegate = self;
            [self presentViewController:docPicker animated:YES completion:NULL];
        }break;
        
        case TransferMediaTypeImage:{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
        }break;
            
        case TransferMediaTypeVideo:{
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            [self presentViewController:picker animated:YES completion:NULL];
        }break;
    }
}

- (void)openBrowser
{
    //Resetando o layout:
    btnShare.tag = 0;
    btnFind.tag = 0;
    //
    [btnShare setTitle:@"Compartilhar Mídia" forState:UIControlStateNormal];
    [btnFind setTitle:@"Buscar Mídia" forState:UIControlStateNormal];
    //
    [btnShare setEnabled:YES];
    [btnFind setEnabled:YES];
    //
    imgQRCode.image = nil;
    //
    [self stopWebServer];
    
    //Abrindo o browser:
    NSDictionary *dic = [ToolBox converterHelper_DictionaryFromStringJson:scannedText];
    NSString *url = [dic valueForKey:@"url"];
    WebItemToShow *webItem = [WebItemToShow new];
    webItem.urlString = url;
    webItem.titleMenu = @"Visualizador de mídia";
    //
    mediaType = [dic valueForKey:MT_KEY_TYPE];
    mediaName = [dic valueForKey:MT_KEY_NAME];
    mediaExtension = [dic valueForKey:MT_KEY_EXTENSION];
    //
    [self performSegueWithIdentifier:@"SegueToWebFileShareViewer" sender:webItem];
}

#pragma mark - Web Server

- (NSString*)startMediaWebServer
{
    NSString *strResult = nil;
    
    __weak MediaTransferVC *weakSelf = self;
    
    //CONNECTIONS
    webServer = [[GCDWebServer alloc] init];
    [webServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
        
        switch (weakSelf.transferMediaTypeToOpen) {
            case TransferMediaTypeNone:{
                return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>Nenhum arquivo válido foi encontrado!</p></body></html>"];
            }break;
                
            case TransferMediaTypeDocument:{
                return [GCDWebServerDataResponse responseWithData:weakSelf.mediaData contentType:weakSelf.mediaType];
            }break;
                
            case TransferMediaTypeImage:{
                return [GCDWebServerDataResponse responseWithData:weakSelf.mediaData contentType:weakSelf.mediaType];
            }break;
                
            case TransferMediaTypeVideo:{
                GCDWebServerResponse* response = [GCDWebServerFileResponse responseWithFile:weakSelf.mediaURL byteRange:request.byteRange];
                [response setValue:@"bytes" forAdditionalHeader:@"Accept-Ranges"];
                return response;
            }break;
        }
        
        return nil;
        
    }];
    [webServer startWithPort:8080 bonjourName:nil];
    
    if ([webServer isRunning]) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:webServer.serverURL.absoluteString forKey:@"url"];
        [dic setValue:mediaType forKey:MT_KEY_TYPE];
        [dic setValue:mediaName forKey:MT_KEY_NAME];
        [dic setValue:mediaExtension forKey:MT_KEY_EXTENSION];
        [dic setValue:MT_VALUE_CODE forKey:MT_KEY_CODE];
        strResult = [ToolBox converterHelper_StringJsonFromDictionary:dic];
        //
        NSLog(@"serverURL: %@", dic);
    }
    
    return strResult;
}

- (void)stopWebServer
{
    if (webServer) {
        if ([webServer isRunning]) {
            [webServer stop];
            [webServer removeAllHandlers];
        }
    }
}

- (NSString*)webServerLoggerStatus
{
    NSString *strResult = @"";
    if (webServer) {
        if ([webServer isRunning]) {
            strResult = [NSString stringWithFormat:@"Web Server Running: %@", webServer.serverURL];
        }else{
            strResult = @"Web Server Error: See DEBUG logs for detail.";
        }
    }else{
        strResult = @"Web Server Not Started!";
    }
    
    return strResult;
}

- (BOOL)webServerLoggerIsRunning
{
    return [webServer isRunning];
}

#pragma mark - UTILS (General Use)

@end
