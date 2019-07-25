//
//  SceneLightControlVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 10/08/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT

#import <SpriteKit/SpriteKit.h>
#import <ARKit/ARKit.h>
//
#import "AppDelegate.h"
#import "SceneLightControlVC.h"
#import "ToolBox.h"
#import "SceneLightControlVC.h"
#import "LightControlView.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface SceneLightControlVC()<LightControlViewDelegate, UIScrollViewDelegate>

//Data:
@property (nonatomic, strong) SCNNode *directionalLightNode;
@property (nonatomic, weak) UIViewController<SceneLightControlDelegate>* delegate;
@property (nonatomic, strong) NSMutableArray *colorsList;
@property (nonatomic, strong) NSMutableArray *lightControlViewList;

//Layout:
@property (nonatomic, weak) IBOutlet UIView *topView;
@property (nonatomic, weak) IBOutlet UIButton *btnClose;
@property (nonatomic, weak) IBOutlet UIView *controlContainerView;
//
@property (nonatomic, weak) IBOutlet UIView *lightControlView;
@property (nonatomic, weak) IBOutlet UIView *lightControlHeaderView;
@property (nonatomic, weak) IBOutlet UILabel *lblLightControlTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblLightControlMessage;
@property (nonatomic, weak) IBOutlet UISwitch *swtLightControl;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollLightControl;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@end

#pragma mark - • IMPLEMENTATION
@implementation SceneLightControlVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
}

#pragma mark - • SYNTESIZES
@synthesize directionalLightNode, delegate, colorsList, lightControlViewList, shadowQuality;
@synthesize topView, btnClose, controlContainerView;
@synthesize lightControlView, lightControlHeaderView, lblLightControlTitle, lblLightControlMessage, swtLightControl, confirmButton, scrollLightControl, pageControl;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    shadowQuality = SceneLightControlShadowQualityUltra;
    directionalLightNode = [self createDirectionalLightNode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    colorsList = [NSMutableArray new];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Branco", @"name", [UIColor whiteColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Cinza Claro", @"name", [UIColor lightGrayColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Cinza Médio", @"name", [UIColor grayColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Cinza Escuro", @"name", [UIColor darkGrayColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Vermelho", @"name", [UIColor redColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rosa", @"name", [UIColor magentaColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Roxo", @"name",[UIColor purpleColor], @"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Azul", @"name", [UIColor blueColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Ciano", @"name", [UIColor cyanColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Verde", @"name", [UIColor greenColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Amarelo", @"name", [UIColor yellowColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Laranja", @"name", [UIColor orangeColor],@"color",  nil]];
    [colorsList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Marrom", @"name",[UIColor brownColor], @"color",  nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    if (self.view.tag == 0){
        [self setupLayout];
        self.view.tag = 1;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return [AppD statusBarStyleForViewController:self];
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

+ (SceneLightControlVC* _Nonnull)newSceneLightControl
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Viewers" bundle:[NSBundle mainBundle]];
    SceneLightControlVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"SceneLightControlVC"];
    [vc awakeFromNib];
    //
    return vc;
}

- (void)showSceneLightControlWithDelegate:(UIViewController<SceneLightControlDelegate>*)vcDelegate
{
    delegate = vcDelegate;
    
    if (delegate){
        [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [delegate presentViewController:self animated:YES completion:^{
            //[delegate floatingPickerViewDidShow:self];
        }];
    }
}

- (void)hideSceneLightControl
{
    if (delegate){
        [delegate sceneLightControlWillHide:self];
        [delegate dismissViewControllerAnimated:YES completion:^{
            //[delegate floatingPickerViewDidHide:self];
        }];
    }
}

- (void)setCategoryBitMask:(NSInteger)bitMask
{
    [directionalLightNode.light setCategoryBitMask:bitMask];
}

#pragma mark - • ACTION METHODS

- (IBAction)actionClose:(id)sender
{
    if (delegate){
        [delegate dismissViewControllerAnimated:YES completion:^{
            //[delegate floatingPickerViewDidHide:self];
        }];
    }
}

- (IBAction)actionSwitchChangeValue:(UISwitch*)sender
{
    if (sender.on){
        [directionalLightNode setHidden:NO];
        //
        [scrollLightControl setUserInteractionEnabled:YES];
        scrollLightControl.alpha = 1.0;
    }else{
        [directionalLightNode setHidden:YES];
        //
        [scrollLightControl setUserInteractionEnabled:NO];
        scrollLightControl.alpha = 0.3;
    }
    
    if (delegate){
        [delegate sceneLightControl:self changeLightState:sender.on];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - LightControlViewDelegate

- (NSString*)lightControlView:(LightControlView*)lcView textForUpdatedParameterValue:(LightControlParameter*)updatedParameter
{
    NSString *text = @"???";
    
    [SCNTransaction begin];
    switch (updatedParameter.type) {
        case LightControlParameterTypeGeneric:{
            //do nothing
        }break;
            
        case LightControlParameterTypeIntensity:{
            directionalLightNode.light.intensity = updatedParameter.currentValue;
            text = [NSString stringWithFormat:@"%.0f (lumens)", updatedParameter.currentValue];
        }break;
            
        case LightControlParameterTypeTemperature:{
            directionalLightNode.light.temperature = updatedParameter.currentValue;
            text = [NSString stringWithFormat:@"%.0f (K)", updatedParameter.currentValue];
        }break;
            
        case LightControlParameterTypeColor:{
            int index = round(updatedParameter.currentValue) - 1;
            NSDictionary *dic = [colorsList objectAtIndex:index];
            directionalLightNode.light.color = [dic valueForKey:@"color"];
            text = [NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]];
        }break;
            
        case LightControlParameterTypeShadowOpacity:{
            directionalLightNode.light.shadowColor = [UIColor colorWithWhite:0.0 alpha:updatedParameter.currentValue];
            text = [NSString stringWithFormat:@"%.1f %%", (updatedParameter.currentValue * 100.0)];
        }break;
            
        case LightControlParameterTypeShadowRadius:{
            directionalLightNode.light.shadowRadius = updatedParameter.currentValue;
            text = [NSString stringWithFormat:@"%.0f", updatedParameter.currentValue];
        }break;
            
            
        case LightControlParameterTypeEulerAngleX:{
            directionalLightNode.eulerAngles = SCNVector3Make([ToolBox converterHelper_DegreeToRadian:updatedParameter.currentValue], directionalLightNode.eulerAngles.y, directionalLightNode.eulerAngles.z);
            text = [NSString stringWithFormat:@"%.0f º (roll)", updatedParameter.currentValue];
        }break;
            
        case LightControlParameterTypeEulerAngleY:{
            directionalLightNode.eulerAngles = SCNVector3Make(directionalLightNode.eulerAngles.x, [ToolBox converterHelper_DegreeToRadian:updatedParameter.currentValue], directionalLightNode.eulerAngles.z);
            text = [NSString stringWithFormat:@"%.0f º (pitch)", updatedParameter.currentValue];
        }break;
            
        case LightControlParameterTypeEulerAngleZ:{
            directionalLightNode.eulerAngles = SCNVector3Make(directionalLightNode.eulerAngles.x, directionalLightNode.eulerAngles.y, [ToolBox converterHelper_DegreeToRadian:updatedParameter.currentValue]);
            text = [NSString stringWithFormat:@"%.0f º (yaw)", updatedParameter.currentValue];
        }break;
    }
    [SCNTransaction commit];
    
    return text;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat r = scrollView.contentOffset.x / scrollView.frame.size.width;
    int pageN = round(r);
    [pageControl setCurrentPage:pageN];
    //
    [self updateLightControlMessageForIndex:pageN];
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor clearColor];
    
    topView.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    btnClose.backgroundColor = nil;
    [btnClose setTitle:@"Fechar Controle" forState:UIControlStateNormal];
    [btnClose setTintColor:[UIColor whiteColor]];
    
    controlContainerView.backgroundColor = nil;
    
    lightControlView.backgroundColor = [UIColor darkGrayColor];
    lightControlView.alpha = 1.0;
    [lightControlView setClipsToBounds:YES];
    lightControlView.layer.cornerRadius = 5.0;
    
    lightControlHeaderView.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    
    lblLightControlTitle.backgroundColor = [UIColor clearColor];
    lblLightControlTitle.textColor = [UIColor whiteColor];
    lblLightControlTitle.text = @"Controle de Luz Direcional";
    [lblLightControlTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION]];
    
    swtLightControl.onTintColor = AppD.styleManager.colorPalette.primaryButtonNormal;
    swtLightControl.on = NO;
    
    confirmButton.backgroundColor = [UIColor darkGrayColor];
    UIImage *bIcon = [[UIImage imageNamed:@"icon-webview-stop"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [confirmButton setImage:bIcon forState:UIControlStateNormal];
    [confirmButton setTintColor:[UIColor whiteColor]];
    [confirmButton setTitle:@"" forState:UIControlStateNormal];
    confirmButton.layer.cornerRadius = 5.0;
    [confirmButton setExclusiveTouch:YES];
    
    lblLightControlMessage.backgroundColor = [UIColor clearColor];
    lblLightControlMessage.textColor = [UIColor lightGrayColor];
    lblLightControlMessage.text = @"";
    [lblLightControlMessage setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    
    scrollLightControl.backgroundColor = [UIColor darkGrayColor];
    scrollLightControl.delegate = self;
    
    pageControl.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    
    [self configureLightControl];
}

#pragma mark -

- (SCNNode*)createDirectionalLightNode
{
    SCNNode *lightNode = [SCNNode new];
    lightNode.light = [SCNLight new];
    //
    lightNode.light.type = SCNLightTypeDirectional;
    lightNode.light.intensity = 1000;
    lightNode.light.temperature = 6500; //white default
    lightNode.light.color = [UIColor whiteColor];
    //
//    lightNode.light.shadowMode = SCNShadowModeDeferred;
    lightNode.light.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.0];
//    lightNode.light.shadowRadius = 8.0;
//    //Qualidade da sombra:
//    switch (shadowQuality) {
//        case SceneLightControlShadowQualityLow:{
//            lightNode.light.shadowSampleCount = 1;
//            lightNode.light.shadowMapSize = CGSizeZero; //será definido pelo sistema automaticamente
//        }break;
//        case SceneLightControlShadowQualityMedium:{
//            lightNode.light.shadowSampleCount = 16;
//            lightNode.light.shadowMapSize = CGSizeMake(512, 512);
//        }break;
//        case SceneLightControlShadowQualityHigh:{
//            lightNode.light.shadowSampleCount = 32;
//            lightNode.light.shadowMapSize = CGSizeMake(1024, 1024);
//        }break;
//        case SceneLightControlShadowQualityUltra:{
//            lightNode.light.shadowSampleCount = 64;
//            lightNode.light.shadowMapSize = CGSizeMake(2048, 2048);
//        }break;
//    }
    //
    lightNode.light.orthographicScale = 5.0;
    lightNode.light.castsShadow = YES;
    lightNode.light.categoryBitMask = 0;
    //
    lightNode.position = SCNVector3Zero;
    lightNode.eulerAngles = SCNVector3Make([ToolBox converterHelper_DegreeToRadian:161.0], [ToolBox converterHelper_DegreeToRadian:185.0], [ToolBox converterHelper_DegreeToRadian:129.0]);
    //
    return lightNode;
}

- (void)configureLightControl
{
    CGRect CommomFrame = CGRectMake(0.0, 0.0, scrollLightControl.frame.size.width, scrollLightControl.frame.size.height);
    lightControlViewList = [NSMutableArray new];
    
    //Intensidade ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeIntensity;
        parameter.name = @"INTENSIDADE";
        parameter.minValue = 0.0;
        parameter.maxValue = 2000.0;
        parameter.currentValue = 1000.0;
        parameter.color = nil;
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    //Temperatura ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeTemperature;
        parameter.name = @"TEMPERATURA";
        parameter.minValue = 100.0;
        parameter.maxValue = 40000.0;
        parameter.currentValue = 6500.0;
        parameter.color = nil;
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    //Cor ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeColor;
        parameter.name = @"COR";
        parameter.minValue = 1.0;
        parameter.maxValue = (double)colorsList.count;
        parameter.currentValue = 1.0;
        parameter.color = [UIColor whiteColor];
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
//    //Sombra (Opacidade) ===========================================================================
//    {
//        LightControlParameter *parameter = [LightControlParameter new];
//        parameter.type = LightControlParameterTypeShadowOpacity;
//        parameter.name = @"OPACIDADE DA SOMBRA";
//        parameter.minValue = 0.0;
//        parameter.maxValue = 1.0;
//        parameter.currentValue = 0.5;
//        parameter.color = nil;
//        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
//        [lightControlViewList addObject:lightControlView];
//    }
//
//    //Sombra (Blur) ===========================================================================
//    {
//        LightControlParameter *parameter = [LightControlParameter new];
//        parameter.type = LightControlParameterTypeShadowRadius;
//        parameter.name = @"RAIO DA SOMBRA";
//        parameter.minValue = 0.0;
//        parameter.maxValue = 100.0;
//        parameter.currentValue = 8;
//        parameter.color = nil;
//        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
//        [lightControlViewList addObject:lightControlView];
//    }
    
    //Angulo X ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeEulerAngleX;
        parameter.name = @"ROTAÇÃO EIXO - X";
        parameter.minValue = 0.0;
        parameter.maxValue = 359.9;
        parameter.currentValue = 161.0;
        parameter.color = nil;
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    //Angulo Y ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeEulerAngleY;
        parameter.name = @"ROTAÇÃO EIXO - Y";
        parameter.minValue = 0.0;
        parameter.maxValue = 359.9;
        parameter.currentValue = 185.0;
        parameter.color = nil;
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    //Angulo Z ===========================================================================
    {
        LightControlParameter *parameter = [LightControlParameter new];
        parameter.type = LightControlParameterTypeEulerAngleZ;
        parameter.name = @"ROTAÇÃO EIXO - Z";
        parameter.minValue = 0.0;
        parameter.maxValue = 359.9;
        parameter.currentValue = 129.0;
        parameter.color = nil;
        LightControlView *lightControlView = [LightControlView newLightControlViewWithFrame:CommomFrame parameter:parameter andDelegate:self];
        [lightControlViewList addObject:lightControlView];
    }
    
    CGFloat totalWidth = (CGFloat)(lightControlViewList.count) * scrollLightControl.frame.size.width;
    [scrollLightControl setContentSize:CGSizeMake(totalWidth, scrollLightControl.frame.size.height)];
    
    for (int i=0; i<lightControlViewList.count; i++){
        LightControlView *lcv = [lightControlViewList objectAtIndex:i];
        [lcv setFrame:CGRectMake((CGFloat)(i) * scrollLightControl.frame.size.width, 0.0, lcv.frame.size.width, lcv.frame.size.height)];
        [scrollLightControl addSubview:lcv];
    }
    pageControl.numberOfPages = lightControlViewList.count;
    
    if (swtLightControl.on){
        [scrollLightControl setUserInteractionEnabled:YES];
        scrollLightControl.alpha = 1.0;
    }else{
        [scrollLightControl setUserInteractionEnabled:NO];
        scrollLightControl.alpha = 0.3;
    }
    
    [self updateLightControlMessageForIndex:0];
}

- (void)updateLightControlMessageForIndex:(int)index
{
    LightControlView *lcv = [lightControlViewList objectAtIndex:index];
    NSString *message = nil;
    
    switch ([lcv currentParameterType]) {
        case LightControlParameterTypeGeneric:{
            message = @"";
        }break;
            
        case LightControlParameterTypeIntensity:{
            message = @"💡 Dica: A intensidade define o quanto da cor da luz é visível.";
        }break;
            
        case LightControlParameterTypeTemperature:{
            message = @"💡 Dica: 6500K equivale a temperatura neutra. Abaixo a imagem 'esquenta'. Acima a imagem 'esfria'.";
        }break;
            
        case LightControlParameterTypeColor:{
            message = @"💡 Dica: Defina a cor da luz que inside no objeto.";
        }break;
            
        case LightControlParameterTypeShadowOpacity:{
            message = @"💡 Dica: Escolha o quanto a sombra do objeto será visível.";
        }break;
            
        case LightControlParameterTypeShadowRadius:{
            message = @"💡 Dica: Defina um raio para o contorno da sombra. Quanto menor, mais nítida será.";
        }break;
            
        case LightControlParameterTypeEulerAngleX:{
            message = @"💡 Dica: Rotaciona a diração da luz no eixo X.";
        }break;
            
        case LightControlParameterTypeEulerAngleY:{
            message = @"💡 Dica: Rotaciona a diração da luz no eixo Y.";
        }break;
            
        case LightControlParameterTypeEulerAngleZ:{
            message = @"💡 Dica: Rotaciona a diração da luz no eixo Z.";
        }break;
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        lblLightControlMessage.text = message;
    });
}

@end
