//
//  Horus3DViewerVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 07/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "Horus3DViewerVC.h"
#import "AppDelegate.h"
#import "FloatingPickerView.h"
#import "VirtualSceneViewerVC.h"
#import "VirtualARViewerVC.h"
#import "Viewer3DSceneRendererVC.h"
//
#import "InternetConnectionManager.h"
#import "Reachability.h"
#import "ConstantsManager.h"
#import "SSZipArchive.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface Horus3DViewerVC ()<FloatingPickerViewDelegate, VirtualSceneViewerDelegate, InternetConnectionManagerDelegate, UITextFieldDelegate>

//Data:
@property (nonatomic, strong) NSString *lastOBJ;
@property (nonatomic, strong) NSString *currentOBJ;
@property (nonatomic, assign) NSInteger currentID;
//
@property (nonatomic, assign) NSInteger viewerTypeID;

//Layout:
@property(nonatomic, strong) FloatingPickerView *pickerView;
//
@property(nonatomic, weak) IBOutlet UIButton *btnOBJ1;
@property(nonatomic, weak) IBOutlet UIButton *btnOBJ2;
@property(nonatomic, weak) IBOutlet UIButton *btnOBJ3;
@property(nonatomic, weak) IBOutlet UIButton *btnOBJ4;
@property(nonatomic, weak) IBOutlet UIButton *btnOBJ5;
@property(nonatomic, weak) IBOutlet UIButton *btnOBJ6;
@property(nonatomic, weak) IBOutlet UIButton *btnOBJCustom;
@property(nonatomic, weak) IBOutlet UIButton *btnOBJReabrir;
//
@property(nonatomic, weak) IBOutlet UISegmentedControl *segCameraControl;
@property(nonatomic, weak) IBOutlet UILabel* lblCameraControl;
//
@property(nonatomic, weak) IBOutlet UISlider* slider;
@property(nonatomic, weak) IBOutlet UILabel* lblZoomValue;
//
@property(nonatomic, weak) IBOutlet UISwitch* swtEmission;
@property(nonatomic, weak) IBOutlet UILabel* lblEmission;

@end

#pragma mark - • IMPLEMENTATION
@implementation Horus3DViewerVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize viewerTypeID, lastOBJ, currentOBJ, currentID, pickerView;
@synthesize btnOBJ1, btnOBJ2, btnOBJ3, btnOBJ4, btnOBJ5, btnOBJ6, btnOBJCustom, btnOBJReabrir, segCameraControl, lblCameraControl, slider, lblZoomValue, swtEmission, lblEmission;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    viewerTypeID = 0;
    currentOBJ = nil;
    lastOBJ = nil;
    
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
    
    if (pickerView.tag == 0){
        [self setupLayout:@"Horus OBJ"];
        pickerView.tag = 1;
        //
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(actionHelp:)];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueTo3DViewer"]){
        VirtualSceneViewerVC *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.tagID = viewerTypeID;
        vc.enableMaterialAutoIlumination = swtEmission.on;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToTargetViewer"]){
        Viewer3DSceneRendererVC *vc = segue.destinationViewController;
        vc.screenTitle = @"Image Target Scene";
        //
        vc.xmlDataSetFileURL = @"LAB360DB.xml";
        vc.objectModelURL = [[NSURL fileURLWithPath:currentOBJ isDirectory:NO] absoluteString];
        //
        vc.lightPositionX = 0.0;
        vc.lightPositionY = -50.0;
        vc.lightPositionZ = 50.0;
        vc.modelPositionX = 0.0;
        vc.modelPositionY = 0.0;
        vc.modelPositionZ = 0.0;
        vc.modelRotationX = 1.0;
        vc.modelRotationY = 0.0;
        vc.modelRotationZ = 0.0;
        vc.modelRotationW = 1.5708; //equivale a 90º em rad
        //
        vc.modelScale = slider.value;
        //
        vc.showShareButton = YES;
        vc.showTargetHintButton = YES;
        vc.hintImage = [UIImage imageNamed:@"lab360_vuforia_local_target_marker.jpg"];
        //
        vc.enableMaterialAutoIlumination = swtEmission.on;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToARViewer"]){
        VirtualARViewerVC *vc = segue.destinationViewController;
        vc.screenTitle = @"OBJ Viewer - AR";
        vc.objectModelURL = [[NSURL fileURLWithPath:currentOBJ isDirectory:NO] absoluteString];
        vc.showPhotoButton = YES;
        vc.showLightControlOption = YES;
        vc.sceneQuality = VirtualARViewerSceneQualityUltra;
        //
        vc.modelScale = slider.value;
        //
        vc.enableMaterialAutoIlumination = swtEmission.on;
    }
    
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)actionOBJ:(UIButton*)sender
{
    currentID = sender.tag;
    [self downloadOBJWithID:sender.tag];
}

-(IBAction)actionOBJCustom:(UIButton*)sender
{
//    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
//    [alert showError:@"Atenção!" subTitle:@"Funcionalidade em desenvolvimento..." closeButtonTitle:@"OK" duration:0.0];
    
    currentID = sender.tag;

    SCLAlertViewPlus *alert = [AppD createDefaultAlert];

    UITextField *textField = [alert addTextField:@"Insira código do produto"];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    //textField.inputAccessoryView = [self createAcessoryView];
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [textField setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setSpellCheckingType:UITextSpellCheckingTypeNo];
    [textField setDelegate:self];

    [alert addButton:@"Buscar" actionBlock:^{
        [textField resignFirstResponder];
        if ([ToolBox textHelper_CheckRelevantContentInString:textField.text]){
            [self downloadOBJWithProductCode:textField.text];
        }
    }];

    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];

    [alert showInfo:self title:@"OBJ" subTitle:@"Para visualizar um OBJ específico insira o código do produto (SKU) completo, incluindo zeros a esquerda, quando necessário.\n\nÉ necessário que o arquivo zip tenha o nome conforme digitado para que possa ser carregado." closeButtonTitle:nil duration:0.0];
}

- (IBAction)actionLastOBJ:(UIButton*)sender
{
    if (lastOBJ != nil){
        currentOBJ = [NSString stringWithFormat:@"%@", lastOBJ];
        [pickerView showFloatingPickerViewWithDelegate:self];
    }
}

- (IBAction)actionHelp:(id)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showInfo:@"Nota" subTitle:@"Faça o upload dos arquivos para teste no endereço <https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/resources/horus/objects3D/obj1.zip>, nomeando corretamente o zip com o número correspondente (1~6)." closeButtonTitle:@"OK" duration:0.0];
}

- (IBAction)actionSliderChangeValue:(UISlider*)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        lblZoomValue.text = [self textForScale:sender.value];
    });
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - InternetConnectionManagerDelegate

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithSuccess:(id _Nullable)responseObject
{
    NSLog(@"didConnectWithSuccess");
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithFailure:(NSError * _Nullable)error
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showError:@"Erro" subTitle:[error localizedDescription] closeButtonTitle:@"OK" duration:0.0];
    //
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD hideLoadingAnimation];
    });
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager didConnectWithSuccessData:(id _Nullable)responseObject
{
    [AppD showLoadingAnimationWithType:eActivityIndicatorType_Processing];
    [AppD updateLoadingAnimationMessage:@""];
    //
    [self processDataForOBJ:(NSData*)responseObject];
}

-(void)internetConnectionManager:(InternetConnectionManager* _Nonnull)manager downloadProgress:(float)dProgress
{
    dProgress = dProgress < 0.0 ? 0.0 : (dProgress > 1.0 ? 1.0 : dProgress);
    [AppD updateLoadingAnimationMessage:[NSString stringWithFormat:@"%.1f %%", (dProgress * 100.0)]];
}

#pragma mark - FloatingPickerElement

- (NSArray<FloatingPickerElement*>* _Nonnull)floatingPickerViewElementsList:(FloatingPickerView *)pickerView
{
    NSMutableArray *elements = [NSMutableArray new];
    
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"3D - Fundo Preto" selection:YES tagID:1 enum:0 andData:nil]];
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"3D - Fundo Branco" selection:NO tagID:2 enum:0 andData:nil]];
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"3D - Fundo Imagem Fixa" selection:NO tagID:3 enum:0 andData:nil]];
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"3D - Fundo Ambiente" selection:NO tagID:4 enum:0 andData:nil]];
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"3D - Camera Dispositivo" selection:NO tagID:5 enum:0 andData:nil]];
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"* AR - Imagem Target" selection:NO tagID:6 enum:0 andData:nil]];
    [elements addObject:[FloatingPickerElement newElementWithTitle:@"* ARKit (iOS 11+)" selection:NO tagID:7 enum:0 andData:nil]];
    
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
    return @"OBJ Viewer";
}

- (NSString* _Nonnull)floatingPickerViewSubtitle:(FloatingPickerView* _Nonnull)pickerView
{
    return @"Selecione uma das opções abaixo:";
}

//Control:
- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willCancelPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    return YES;
}

- (BOOL)floatingPickerView:(FloatingPickerView* _Nonnull)pickerView willConfirmPickerWithSelectedElements:(NSArray<FloatingPickerElement*>* _Nonnull)elements
{
    FloatingPickerElement *element = [elements firstObject];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self openViewerForType:element.tagID];
    });
    
    return YES;
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

#pragma mark - VirtualSceneViewerDelegate

//@required

- (NSURL*)virtualSceneViewerLocalURLFor3DModel:(VirtualSceneViewerVC*)sceneViewer
{
    //return [[NSBundle mainBundle] URLForResource:@"couro_bege" withExtension:@"obj"];
    return  [NSURL fileURLWithPath:currentOBJ isDirectory:NO];
}

- (BOOL)virtualSceneViewerScaleObjectAllowed:(VirtualSceneViewerVC*)sceneViewer
{
    return YES;
}

- (BOOL)virtualSceneViewerTranslateObjectAllowed:(VirtualSceneViewerVC*)sceneViewer
{
    return YES;
}

- (UIColor*)virtualSceneViewerBackgroundColorForScene:(VirtualSceneViewerVC*)sceneViewer
{
    if (viewerTypeID == 1){
        return [UIColor blackColor];
    }
    else if (viewerTypeID == 2){
        return [UIColor whiteColor];
    }
    else{
        return [UIColor blackColor];
    }
}

- (NSArray<UIImage*>*)virtualSceneViewer:(VirtualSceneViewerVC*)sceneViewer enviromentImagesForScene:(NSInteger)sceneIndex
{
    //NOTE: Para a cena tipo ambiente é possível passar um cube map com 6 imagens separadas (right, left, up, down, front, back) ou 1 imagem única (6 * height = width)
    
    NSMutableArray *images = [NSMutableArray new];
    NSString *imageName = [NSString stringWithFormat:@"virtual-skybox-enviroment-scene-%li.jpg", (sceneIndex + 1)];
    [images addObject:[UIImage imageNamed:imageName]];
    //
    return images;
    
    //Abaixo exemplo de cube map com 6 imagens distintas:
    //    [images addObject:[UIImage imageNamed:@"virtual-skybox-enviroment-right.png"]];
    //    [images addObject:[UIImage imageNamed:@"virtual-skybox-enviroment-left.png"]];
    //    [images addObject:[UIImage imageNamed:@"virtual-skybox-enviroment-up.png"]];
    //    [images addObject:[UIImage imageNamed:@"virtual-skybox-enviroment-down.png"]];
    //    [images addObject:[UIImage imageNamed:@"virtual-skybox-enviroment-front.png"]];
    //    [images addObject:[UIImage imageNamed:@"virtual-skybox-enviroment-back.png"]];
}

- (NSArray<NSString*>*)virtualSceneViewerEnviromentSceneNames:(VirtualSceneViewerVC*)sceneViewer
{
    NSMutableArray *name = [NSMutableArray new];
    [name addObject:@"Céu Azul"];
    [name addObject:@"Ponto de Desembarque"];
    [name addObject:@"Acima das Nuvens"];
    [name addObject:@"Antiquário"];
    [name addObject:@"Vista do Parque"];
    [name addObject:@"Sala Colorida"];
    [name addObject:@"Gran Canyon"];
    //
    return name;
}

- (void)virtualSceneViewer:(VirtualSceneViewerVC*)sceneViewer errorWithMessage:(NSString*)errorMessage
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showError:@"Erro" subTitle:[NSString stringWithFormat:@"O visualizador 3D comunicou o seguinte erro:\n%@", errorMessage] closeButtonTitle:@"OK" duration:0.0];
}

- (VirtualSceneViewerBackgroundStyle)virtualSceneViewerBackgroundStyle:(VirtualSceneViewerVC*)sceneViewer
{
    if (viewerTypeID == 1 || viewerTypeID == 2){
        return VirtualSceneViewerBackgroundStyleSolidColor;
    }else if (viewerTypeID == 3){
        return VirtualSceneViewerBackgroundStyleImage;
    }else if (viewerTypeID == 4){
        return VirtualSceneViewerBackgroundStyleEnviroment;
    }else{
        return VirtualSceneViewerBackgroundStyleBackCamera;
    }
}

//@optional

- (NSString*)virtualSceneViewerNavigationBarTitle:(VirtualSceneViewerVC*)sceneViewer
{
    return @"OBJ Viewer";
}

- (VirtualSceneViewerInstructionStyle)virtualSceneViewerStyleForInstructionMessage:(VirtualSceneViewerVC*)sceneViewer
{
    return VirtualSceneViewerInstructionStyleNormal;
}

- (BOOL)virtualSceneViewerShowShareButton:(VirtualSceneViewerVC*)sceneViewer
{
    return YES;
}

-(VirtualSceneViewerHDRState)virtualSceneViewerHDRState:(VirtualSceneViewerVC *)sceneViewer
{
    if (viewerTypeID == 3){
        return VirtualSceneViewerHDRStateON; 
    }else{
        return VirtualSceneViewerHDRStateOFF;
    }
}

- (NSString*)virtualSceneViewerMessageForInstructionMessage:(VirtualSceneViewerVC*)sceneViewer
{
    return [NSString stringWithFormat:@"Dimensões do objeto carregado:  W: %.2f,  H: %.2f,  L: %.2f", sceneViewer.objectBoxSize.W, sceneViewer.objectBoxSize.H, sceneViewer.objectBoxSize.L];
}

- (BOOL)virtualSceneViewerShowPhotoButton:(VirtualSceneViewerVC*)sceneViewer
{
    return YES;
}

- (VirtualSceneViewerRotationMode)virtualSceneViewerRotationMode:(VirtualSceneViewerVC*)sceneViewer
{
    if (self.segCameraControl.selectedSegmentIndex == 0){
        return VirtualSceneViewerRotationModeFree;
    }else if (self.segCameraControl.selectedSegmentIndex == 1){
        return VirtualSceneViewerRotationModeLimited;
    }else if (self.segCameraControl.selectedSegmentIndex == 2){
        return VirtualSceneViewerRotationModeXAxis;
    }else{
        return VirtualSceneViewerRotationModeYAxis;
    }
}

- (UIImage*)virtualSceneViewerBackgroundImageForScene:(VirtualSceneViewerVC*)sceneViewer
{
    if (viewerTypeID == 3){
        return [UIImage imageNamed:@"virtual-scene-viewer-background.jpg"];
    }else{
        return nil;
    }
}

//- (VirtualSceneNodeParameters*)virtualSceneViewerModelInitialStateParameters:(VirtualSceneViewerVC*)sceneViewer
//{
//
//}
//
//- (VirtualSceneNodeParameters*)virtualSceneViewerModelLightParameters:(VirtualSceneViewerVC*)sceneViewer
//{
//
//}
//
//- (VirtualSceneNodeParameters*)virtualSceneViewerAmbientLightParameters:(VirtualSceneViewerVC*)sceneViewer
//{
//
//}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    btnOBJ1.backgroundColor = [UIColor clearColor];
    [btnOBJ1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOBJ1.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnOBJ1 setTitle:@"OBJ 1" forState:UIControlStateNormal];
    [btnOBJ1 setExclusiveTouch:YES];
    [btnOBJ1 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ1.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnOBJ1 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ1.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    btnOBJ1.tag = 1;
    
    btnOBJ2.backgroundColor = [UIColor clearColor];
    [btnOBJ2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOBJ2.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnOBJ2 setTitle:@"OBJ 2" forState:UIControlStateNormal];
    [btnOBJ2 setExclusiveTouch:YES];
    [btnOBJ2 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ2.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnOBJ2 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ2.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    btnOBJ2.tag = 2;
    
    btnOBJ3.backgroundColor = [UIColor clearColor];
    [btnOBJ3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOBJ3.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnOBJ3 setTitle:@"OBJ 3" forState:UIControlStateNormal];
    [btnOBJ3 setExclusiveTouch:YES];
    [btnOBJ3 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ3.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnOBJ3 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ3.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    btnOBJ3.tag = 3;
    
    btnOBJ4.backgroundColor = [UIColor clearColor];
    [btnOBJ4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOBJ4.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnOBJ4 setTitle:@"OBJ 4" forState:UIControlStateNormal];
    [btnOBJ4 setExclusiveTouch:YES];
    [btnOBJ4 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ4.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnOBJ4 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ4.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    btnOBJ4.tag = 4;
    
    btnOBJ5.backgroundColor = [UIColor clearColor];
    [btnOBJ5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOBJ5.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnOBJ5 setTitle:@"OBJ 5" forState:UIControlStateNormal];
    [btnOBJ5 setExclusiveTouch:YES];
    [btnOBJ5 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ5.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnOBJ5 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ5.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    btnOBJ5.tag = 5;
    
    btnOBJ6.backgroundColor = [UIColor clearColor];
    [btnOBJ6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOBJ6.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnOBJ6 setTitle:@"OBJ 6" forState:UIControlStateNormal];
    [btnOBJ6 setExclusiveTouch:YES];
    [btnOBJ6 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ6.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnOBJ6 setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJ6.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    btnOBJ6.tag = 6;
    
    btnOBJCustom.backgroundColor = [UIColor clearColor];
    [btnOBJCustom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOBJCustom.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnOBJCustom setTitle:@"OBJ by Product Code" forState:UIControlStateNormal];
    [btnOBJCustom setExclusiveTouch:YES];
    [btnOBJCustom setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJCustom.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnOBJCustom setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJCustom.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    btnOBJCustom.tag = 7;
    
    btnOBJReabrir.backgroundColor = [UIColor clearColor];
    [btnOBJReabrir setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOBJReabrir.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnOBJReabrir setTitle:@"Reabrir Último..." forState:UIControlStateNormal];
    [btnOBJReabrir setExclusiveTouch:YES];
    [btnOBJReabrir setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJReabrir.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:COLOR_MA_BLUE] forState:UIControlStateNormal];
    [btnOBJReabrir setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnOBJReabrir.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:COLOR_MA_PURPLE] forState:UIControlStateHighlighted];
    btnOBJReabrir.tag = 0;
    [btnOBJReabrir setEnabled:NO];
    
    [segCameraControl setBackgroundColor:[UIColor whiteColor]];
    [segCameraControl setTintColor:COLOR_MA_BLUE];
    
    lblCameraControl.backgroundColor = [UIColor clearColor];
    lblCameraControl.textColor = [UIColor darkGrayColor];
    [lblCameraControl setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblCameraControl.text = @"Modo da Câmera";
    
    slider.backgroundColor = [UIColor clearColor];
    slider.minimumTrackTintColor = COLOR_MA_BLUE;
    //
    slider.minimumValueImage = [ToolBox graphicHelper_ImageWithTintColor:[UIColor darkGrayColor] andImageTemplate:[UIImage imageNamed:@"VirtualSceneSliderMinus"]];
    slider.maximumValueImage = [ToolBox graphicHelper_ImageWithTintColor:[UIColor darkGrayColor] andImageTemplate:[UIImage imageNamed:@"VirtualSceneSliderPlus"]];
    //
    slider.minimumValue = 0.001;
    slider.maximumValue = 1.0;
    slider.value = 1.0;
    
    lblZoomValue.backgroundColor = [UIColor clearColor];
    lblZoomValue.textColor = [UIColor darkGrayColor];
    [lblZoomValue setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblZoomValue.text = [self textForScale:slider.value];
    
    lblEmission.backgroundColor = [UIColor clearColor];
    lblEmission.textColor = [UIColor darkGrayColor];
    [lblEmission setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    lblEmission.text = @"Habilitar Autoiluminação";
    
    [swtEmission setOnTintColor:AppD.styleManager.colorPalette.primaryButtonNormal];
    swtEmission.on = NO;
    
}

//-(UIView*)createAcessoryView
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
//
//    UIButton *btnApply = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 40)];
//    btnApply.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [btnApply addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    [btnApply setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
//    [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnApply.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
//    [btnApply setTitle:@"Buscar" forState:UIControlStateNormal];
//
//    [view addSubview:btnApply];
//
//    return view;
//}

- (NSString*)textForScale:(float)scale
{
    return [NSString stringWithFormat:@"* Escala do modelo: %.1f %%", (scale * 100.00)];
}

- (void)openViewerForType:(NSInteger)type
{
    viewerTypeID = type;
    
    lastOBJ = [NSString stringWithFormat:@"%@", currentOBJ];
    if (currentID == 7){
        [btnOBJReabrir setTitle:[NSString stringWithFormat:@"Reabrir Último (%@)", [lastOBJ lastPathComponent]] forState:UIControlStateNormal];
    }else{
        [btnOBJReabrir setTitle:[NSString stringWithFormat:@"Reabrir Último (OBJ %li)", currentID] forState:UIControlStateNormal];
    }
    [btnOBJReabrir setEnabled:YES];
    
    if (viewerTypeID == 6){
        [self performSegueWithIdentifier:@"SegueToTargetViewer" sender:nil];
    }
    else if (viewerTypeID == 7){
        [self performSegueWithIdentifier:@"SegueToARViewer" sender:nil];
    }else{
        [self performSegueWithIdentifier:@"SegueTo3DViewer" sender:nil];
    }
}

- (void)downloadOBJWithID:(NSInteger)objID
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Downloading];
        });
        
        NSString *objURL = [NSString stringWithFormat:@"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/resources/horus/objects3D/obj%li.zip", (long)objID];
        [icm downloadDataFrom:objURL withDelegate:self andCompletionHandler:nil];
        
    }else{
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Erro" subTitle:@"" closeButtonTitle:@"OK" duration:0.0];
    }
}

- (void)downloadOBJWithProductCode:(NSString*)productCode
{
    InternetConnectionManager *icm = [InternetConnectionManager new];
    InternetActiveConnectionType iType = [icm activeConnectionType];
    
    if (iType == InternetActiveConnectionTypeWiFi || iType == InternetActiveConnectionTypeCellData){
        
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Downloading];
        });
        
        NSString *objURL = [NSString stringWithFormat:@"https://s3-sa-east-1.amazonaws.com/horus-etna/3D_ETNA_ZIPS/%@.zip", productCode];
        [icm downloadDataFrom:objURL withDelegate:self andCompletionHandler:nil];
        
    }else{
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Erro" subTitle:@"" closeButtonTitle:@"OK" duration:0.0];
    }
}

- (void)processDataForOBJ:(NSData*)zipData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *horusFolder = @"HORUS";
    NSString *objFolder = [NSString stringWithFormat:@"obj%li", (long)currentID];
    NSString *objName = [NSString stringWithFormat:@"obj%li.zip", (long)currentID];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *horusPath = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", horusFolder]];
    NSString *objPath = [horusPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objFolder]];
    
    //Controle de diretórios ******************************************************************************************************
    
    if (![self directoryExists:objPath])
    {
        if (![self createDirectoryAtPath:objPath]) {
            [self showProcessError:@"Não foi possível processar o arquivo baixado no momento."];
            return;
        }
    }else{
        NSError *error;
        NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:objPath error:&error];
        if (directoryContents != nil){
            for (NSString *path in directoryContents){
                NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                if ([fileManager removeItemAtPath:fullPath error:&error]){
                    NSLog(@"Arquivo antigo removido: %@", fullPath);
                }else{
                    [self showProcessError:[error localizedDescription]];
                    return;
                }
            }
        }else{
            [self showProcessError:[error localizedDescription]];
            return;
        }
    }
    
    NSString *objFile = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", objName]];
    
    if (![self fileExists:objFile])
    {
        if (![self createFileAtPath:objFile])
        {
            [self showProcessError:@"Não foi possível processar o arquivo baixado no momento."];
            return;
        }
    }
    
    [zipData writeToFile:objFile atomically:NO];
    
    //Unzip do arquivo ******************************************************************************************************
    
    if ([SSZipArchive unzipFileAtPath:objFile toDestination:objPath]){
        
        NSError *zipError;
        NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:objPath error:&zipError];
        if (directoryContents != nil){
            currentOBJ = nil;
            for (NSString *path in directoryContents){
                NSString *fullPath = [objPath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
                //
                if ([[fullPath lowercaseString] hasSuffix:@"obj"]){
                    currentOBJ = fullPath;
                    break;
                }
            }
            
            if (currentOBJ){
                
                dispatch_async(dispatch_get_main_queue(),^{
                    [AppD hideLoadingAnimation];
                });
                
                [pickerView showFloatingPickerViewWithDelegate:self];
                
            }else{
                [self showProcessError:@"Nenhum arquivo OBJ foi encontrado no zip baixado."];
                return;
            }
            
        }else{
            [self showProcessError:[zipError localizedDescription]];
            return;
        }
        
    }else{
        [self showProcessError:@"Não foi possível processar o arquivo baixado no momento."];
        return;
    }
}

#pragma mark -

- (void)showProcessError:(NSString*)errorMessage
{
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD hideLoadingAnimation];
    });
    //
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showError:@"Erro" subTitle:errorMessage closeButtonTitle:@"OK" duration:0.0];
}

#pragma mark - General Methods

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
    return [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
}

-(BOOL)createFileAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

//-(BOOL)deleteFileAtPath:(NSString *)filePath
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if([fileManager isDeletableFileAtPath:filePath]){
//        NSError * err = NULL;
//        if([fileManager removeItemAtPath:filePath error:&err]){
//            return YES;
//        }else{
//            return NO;
//        }
//    }else{
//        return NO;
//    }
//}

@end
