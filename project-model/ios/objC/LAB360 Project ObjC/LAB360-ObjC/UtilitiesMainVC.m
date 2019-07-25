//
//  UtilitiesMainVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 02/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "UtilitiesMainVC.h"
#import "AppDelegate.h"
#import "DocScannerViewController.h"
#import "FloatingPickerView.h"
#import "BarcodeReaderViewController.h"
#import "BarcodeGeneratorViewController.h"
#import "OCRViewController.h"
#import "MediaTransferVC.h"
#import "AddressSearchVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface UtilitiesMainVC()<FloatingPickerViewDelegate, DocScannerViewControllerDelegate>
//Data:
@property (nonatomic, strong) UIImage *scannedImage;

//Layout:
@property(nonatomic, strong) FloatingPickerView *pickerView;
//
@property (nonatomic, weak) IBOutlet UIButton *btnDocScanner;
@property (nonatomic, weak) IBOutlet UIButton *btnDocHelp;
//
@property (nonatomic, weak) IBOutlet UIButton *btnCodeReader;
@property (nonatomic, weak) IBOutlet UIButton *btnCodeGenerator;
//
@property (nonatomic, weak) IBOutlet UIButton *btnMediaTransfer;
@property (nonatomic, weak) IBOutlet UIButton *btnAdAliveTransferFile;
//
@property (nonatomic, weak) IBOutlet UIButton *btnTextAndVoice;
//
@property (nonatomic, weak) IBOutlet UIButton *btnAddressSearch;

@end

#pragma mark - • IMPLEMENTATION
@implementation UtilitiesMainVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize scannedImage;
@synthesize pickerView, btnDocScanner, btnDocHelp, btnCodeReader, btnCodeGenerator, btnMediaTransfer, btnAdAliveTransferFile, btnTextAndVoice, btnAddressSearch;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [self setupLayout:@"Utilitários"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (scannedImage){
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        
        [alert addButton:@"Salvar / Compartilhar" withType:SCLAlertButtonType_Normal actionBlock:^{
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[scannedImage] applicationActivities:nil];
            if (IDIOM == IPAD){
                activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems.firstObject;
            }
            [self presentViewController:activityController animated:YES completion:^{
                NSLog(@"activityController presented");
            }];
            [activityController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
                NSLog(@"activityController completed: %@", (completed ? @"YES" : @"NO"));
                scannedImage = nil;
            }];
        }];
        
        [alert addButton:@"Extrair Texto (OCR)" withType:SCLAlertButtonType_Normal actionBlock:^{
            [self performSegueWithIdentifier:@"SegueToOCR" sender:nil];
        }];
        
        [alert addButton:@"Descartar" withType:SCLAlertButtonType_Neutral actionBlock:nil];
        
        [alert showInfo:@"Scanner de Documentos" subTitle:@"Como deseja usar a imagem do documento escaneado?" closeButtonTitle:nil duration:0.0];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];

    if ([segue.identifier isEqualToString:@"SegueToCodeReader"]){
        FloatingPickerElement *el = (FloatingPickerElement*)sender;
        //
        BarcodeReaderViewController *vc = segue.destinationViewController;
        vc.rectScanType = ScannableAreaFormatTypeDefinedByUser;
        vc.instructionText = el.title;
        vc.titleScreen = @"Leitor Barcode";
        switch (el.tagID) {
            case 2:{
                vc.typesToRead = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeDataMatrixCode];
            }break;
            case 3:{
                vc.typesToRead = @[AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeUPCECode];
            }break;
            case 4:{
                vc.typesToRead = @[AVMetadataObjectTypeCode128Code];
            }break;
            default:{
                vc.typesToRead = @[];
            }break;
        }
    }
    
    if ([segue.identifier isEqualToString:@"SegueToCodeGenerator"]){
        FloatingPickerElement *el = (FloatingPickerElement*)sender;
        //
        BarcodeGeneratorViewController *vc = segue.destinationViewController;
        vc.titleScreen = el.title;
        switch (el.tagID) {
            case 1:{
                vc.typeToGenerate = AVMetadataObjectTypeQRCode;
            }break;
            case 2:{
                vc.typeToGenerate = AVMetadataObjectTypeAztecCode;
            }break;
            case 3:{
                vc.typeToGenerate = AVMetadataObjectTypePDF417Code;
            }break;
            case 4:{
                vc.typeToGenerate = AVMetadataObjectTypeCode128Code;
            }break;
        }
    }
    
    scannedImage = nil;
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionScanner:(id)sender
{
    DocScannerViewController *scanner = [DocScannerViewController cameraViewWithDefaultType:DocScannerViewTypeNormal defaultDetectorType:DocScannerDetectorTypeAccuracy withDelegate:self];
    scanner.screenTitle = @"Doc Scanner";
    //
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:scanner animated:YES];
}

- (IBAction)actionScannerHelp:(id)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showInfo:@"Doc Scanner" subTitle:@"Para facilitar o reconhecimento do documento procure colocá-lo sobre uma superfície contrastante e certifíque-se de enquadrá-lo por inteiro." closeButtonTitle:@"OK" duration:0.0];
}

- (IBAction)actionCodeReader:(id)sender
{
    pickerView.tag = 1;
    [pickerView showFloatingPickerViewWithDelegate:self];
}

- (IBAction)actionCodeGenerator:(id)sender
{
    pickerView.tag = 2;
    [pickerView showFloatingPickerViewWithDelegate:self];
}

- (IBAction)actionMediaTransfer:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToMediaTransfer" sender:nil];
}

- (IBAction)actionAdAliveFileTransfer:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"SegueToAdAliveFileTransfer" sender:nil];
}

- (IBAction)actionTextAndVoice:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"SegueToTextAndVoice" sender:nil];
}

- (IBAction)actionAddressSearch:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToAddressSearch" sender:nil];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - FloatingPickerElement

- (NSArray<FloatingPickerElement*>* _Nonnull)floatingPickerViewElementsList:(FloatingPickerView *)pickerView
{
    NSMutableArray *elements = [NSMutableArray new];
    
    if (pickerView.tag == 1){
        
        //READER:
        FloatingPickerElement *element_1 = [FloatingPickerElement newElementWithTitle:@"Genérico" selection:YES tagID:1 enum:0 andData:nil];
        FloatingPickerElement *element_2 = [FloatingPickerElement newElementWithTitle:@"QRCode / Aztec / DataMatrix" selection:NO tagID:2 enum:0 andData:nil];
        FloatingPickerElement *element_3 = [FloatingPickerElement newElementWithTitle:@"EAN (8 / 13 / UPCE)" selection:NO tagID:3 enum:0 andData:nil];
        FloatingPickerElement *element_4 = [FloatingPickerElement newElementWithTitle:@"Code128" selection:NO tagID:4 enum:0 andData:nil];
        //
        [elements addObject:element_1];
        [elements addObject:element_2];
        [elements addObject:element_3];
        [elements addObject:element_4];
        
    }else{
        
        //GENERATOR
        FloatingPickerElement *element_1 = [FloatingPickerElement newElementWithTitle:@"QRCode" selection:YES tagID:1 enum:0 andData:nil];
        FloatingPickerElement *element_2 = [FloatingPickerElement newElementWithTitle:@"Aztec" selection:NO tagID:2 enum:0 andData:nil];
        FloatingPickerElement *element_3 = [FloatingPickerElement newElementWithTitle:@"PDF417" selection:NO tagID:3 enum:0 andData:nil]; //PDF417 codes are commonly used in postage, package tracking, personal identification documents, and coffeeshop membership cards.
        FloatingPickerElement *element_4 = [FloatingPickerElement newElementWithTitle:@"Code128" selection:NO tagID:4 enum:0 andData:nil];
        //
        [elements addObject:element_1];
        [elements addObject:element_2];
        [elements addObject:element_3];
        [elements addObject:element_4];

    }
    
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
    return @"Tipo de Código";
}

- (NSString* _Nonnull)floatingPickerViewSubtitle:(FloatingPickerView* _Nonnull)pickerView
{
    if (pickerView.tag == 1){
        
        //READER:
        return @"Selecione o tipo de código que deseja escanear:";
        
    }else{
        
        //GENERATOR
        return @"Selecione o tipo de código que deseja gerar:";
        
    }
}

//Control:
- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willCancelPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    return YES;
}

- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willConfirmPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    if (elements.count == 0){
        return NO;
    }else{
        FloatingPickerElement *element = [elements firstObject];
        
        if (pickerView.tag == 1){
            
            //READER:
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"SegueToCodeReader" sender:element];
            });
            
        }else{
            
            //GENERATOR
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"SegueToCodeGenerator" sender:element];
            });
            
        }
        
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

#pragma mark - DocScannerViewControllerDelegate

-(void)pageSnapped:(UIImage* _Nonnull)image from:(DocScannerViewController* _Nonnull)cameraView
{
    self.scannedImage = image;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    btnDocScanner.backgroundColor = [UIColor clearColor];
    [btnDocScanner setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDocScanner.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnDocScanner setTitle:@"Scanner de Documentos" forState:UIControlStateNormal];
    [btnDocScanner setExclusiveTouch:YES];
    [btnDocScanner setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnDocScanner.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnDocScanner setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnDocScanner.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnDocHelp.backgroundColor = [UIColor clearColor];
    [btnDocHelp.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnDocHelp setTitle:@"" forState:UIControlStateNormal];
    [btnDocHelp setImage:[ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonNormal andImageTemplate:[UIImage imageNamed:@"NavControllerHelpIcon"]] forState:UIControlStateNormal];
    [btnDocHelp setExclusiveTouch:YES];
    
    btnCodeReader.backgroundColor = [UIColor clearColor];
    [btnCodeReader setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCodeReader.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnCodeReader setTitle:@"Leitor de Barcode" forState:UIControlStateNormal];
    [btnCodeReader setExclusiveTouch:YES];
    [btnCodeReader setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnDocScanner.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnCodeReader setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnDocScanner.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnCodeGenerator.backgroundColor = [UIColor clearColor];
    [btnCodeGenerator setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCodeGenerator.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnCodeGenerator setTitle:@"Gerador de Barcode" forState:UIControlStateNormal];
    [btnCodeGenerator setExclusiveTouch:YES];
    [btnCodeGenerator setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnCodeGenerator.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnCodeGenerator setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnCodeGenerator.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnMediaTransfer.backgroundColor = [UIColor clearColor];
    [btnMediaTransfer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnMediaTransfer.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnMediaTransfer setTitle:@"Transferir Mídia" forState:UIControlStateNormal];
    [btnMediaTransfer setExclusiveTouch:YES];
    [btnMediaTransfer setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnMediaTransfer.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnMediaTransfer setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnMediaTransfer.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnAdAliveTransferFile.backgroundColor = [UIColor clearColor];
    [btnAdAliveTransferFile setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnAdAliveTransferFile.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnAdAliveTransferFile setTitle:@"Arquivo AdAlive" forState:UIControlStateNormal];
    [btnAdAliveTransferFile setExclusiveTouch:YES];
    [btnAdAliveTransferFile setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnAdAliveTransferFile.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnAdAliveTransferFile setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnAdAliveTransferFile.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnTextAndVoice.backgroundColor = [UIColor clearColor];
    [btnTextAndVoice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTextAndVoice.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnTextAndVoice setTitle:@"Texto e Fala" forState:UIControlStateNormal];
    [btnTextAndVoice setExclusiveTouch:YES];
    [btnTextAndVoice setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnTextAndVoice.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnTextAndVoice setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnTextAndVoice.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
    btnAddressSearch.backgroundColor = [UIColor clearColor];
    [btnAddressSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnAddressSearch.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnAddressSearch setTitle:@"Busca CEP" forState:UIControlStateNormal];
    [btnAddressSearch setExclusiveTouch:YES];
    [btnAddressSearch setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnAddressSearch.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnAddressSearch setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnAddressSearch.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    
}

#pragma mark - UTILS (General Use)

@end
