//
//  DigitalCardMainVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 18/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "DigitalCardMainVC.h"
#import "DigitalCardReaderVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface DigitalCardMainVC()

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblInstructions;
@property(nonatomic, weak) IBOutlet UIButton *btnCreateCard;
@property(nonatomic, weak) IBOutlet UIButton *btnReadCard;
//
@property (nonatomic, strong) UIColor *customViewColor;

@end

#pragma mark - • IMPLEMENTATION
@implementation DigitalCardMainVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize lblTitle, lblInstructions, btnCreateCard, btnReadCard;
@synthesize customViewColor;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    customViewColor = [UIColor colorWithRed:178.0/255.0 green:58.0/255.0 blue:108.0/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout:@"Cartão Presente"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToCardReader"]){
        DigitalCardReaderVC *vc = segue.destinationViewController;
        if (((UIButton*)sender).tag == 1){
            vc.screenType = DigitalCardReaderScreenTypeCreate;
        }else{
            vc.screenType = DigitalCardReaderScreenTypeReader;
        }
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionCreateCard:(id)sender
{
    NSMutableArray *iList = [NSMutableArray new];
    [iList addObject:[UIImage imageNamed:@"mother_qrcode_card_sample_1.png"]];
    [iList addObject:[UIImage imageNamed:@"mother_qrcode_card_sample_1.png"]];
    [iList addObject:[UIImage imageNamed:@"mother_qrcode_card_sample_2.png"]];
    SCLAlertViewPlus *alert = [AppD createDefaultRichAlert:@"Para gravar uma mensagem para seu Cartão Presente será preciso escanear um QRCode. Verifique na parte de trás do seu cartão." images:iList animationTimePerFrame:0.3];
    [alert addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
        [self performSegueWithIdentifier:@"SegueToCardReader" sender:sender];
    }];
    [alert showInfo:@"Atenção!" subTitle:nil closeButtonTitle:nil duration:0.0];
}

- (IBAction)actionReadCard:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToCardReader" sender:sender];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    lblTitle.backgroundColor = nil;
    lblTitle.textColor = customViewColor;
    [lblTitle setFont:[UIFont fontWithName:FONT_SIGNPAINTER size:30.0]];
    [lblTitle setText:@"Mensagem para o\nDia das Mães"];
    
    lblInstructions.backgroundColor = nil;
    lblInstructions.textColor = [UIColor darkTextColor];
    [lblInstructions setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:16.0]];
    [lblInstructions setText:@"Para utilizar as funcionalidades deste módulo crie uma imagem QRCode a partir do seguinte texto: \"LAB360VIDEOCARD_\" + código alfanumérico de 12 dígitos."];
    
    btnCreateCard.backgroundColor = [UIColor clearColor];
    [btnCreateCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCreateCard.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnCreateCard setTitle:@"Gravar Cartão" forState:UIControlStateNormal];
    [btnCreateCard setExclusiveTouch:YES];
    [btnCreateCard setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnCreateCard.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnCreateCard setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnCreateCard.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    UIImage *iconCreate = [ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:[UIImage imageNamed:@"DigitalCardCreate"]];
    [btnCreateCard setImage:iconCreate forState:UIControlStateNormal];
    [btnCreateCard setImageEdgeInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 15.0)];
    [btnCreateCard.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnCreateCard setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [btnCreateCard setTintColor:[UIColor whiteColor]];
    btnCreateCard.tag = 1;
    
    btnReadCard.backgroundColor = [UIColor clearColor];
    [btnReadCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnReadCard.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnReadCard setTitle:@"Ler Cartão" forState:UIControlStateNormal];
    [btnReadCard setExclusiveTouch:YES];
    [btnReadCard setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReadCard.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnReadCard setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnReadCard.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    UIImage *iconRead = [ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:[UIImage imageNamed:@"DigitalCardRead"]];
    [btnReadCard setImage:iconRead forState:UIControlStateNormal];
    [btnReadCard setImageEdgeInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 15.0)];
    [btnReadCard.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnReadCard setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [btnReadCard setTintColor:[UIColor whiteColor]];
    btnReadCard.tag = 2;
}

@end
