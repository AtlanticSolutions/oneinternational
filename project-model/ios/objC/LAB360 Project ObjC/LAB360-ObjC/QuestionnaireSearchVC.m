//
//  QuestionnaireSearchVC.m
//  LAB360-Dev
//
//  Created by Erico GT on 01/04/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "QuestionnaireSearchVC.h"
#import "BarcodeReaderViewController.h"
#import "CustomSurveyMainVC.h"
#import "CustomSurvey.h"
#import "AppDelegate.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface QuestionnaireSearchVC()

//Data:
@property(nonatomic, strong) NSString *readedCode;

//Layout:
@property (nonatomic, weak) IBOutlet UIView *viewMessage;
@property (nonatomic, weak) IBOutlet UILabel *lblMessage;
@property (nonatomic, weak) IBOutlet UIButton *btnSearch;

@end

#pragma mark - • IMPLEMENTATION
@implementation QuestionnaireSearchVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES

@synthesize readedCode, viewMessage, lblMessage, btnSearch;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    readedCode = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:@"Buscar Questionário"];
    
    if (readedCode){
        [self loadQuestionnaireData:readedCode];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.readedCode = nil;
    
    if ([segue.identifier isEqualToString:@"SegueToCodeReader"]){

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionBarcodeReaderNotification:) name:BARCODE_READER_RESULT_NOTIFICATION_KEY object:nil];
        
        BarcodeReaderViewController *vc = segue.destinationViewController;
        vc.rectScanType = ScannableAreaFormatTypeLargeSquare;
        vc.instructionText = nil;
        vc.titleScreen = @"Leitor QRCode";
        vc.typesToRead = @[AVMetadataObjectTypeQRCode];
        vc.resultType = BarcodeReaderResultTypeNotifyAndClose;
        vc.validationKey = @"APPID";
        NSString *appID = [NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)];
        vc.validationValue = appID;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToQuestionnaire"]){
        
        CustomSurveyMainVC *vc = segue.destinationViewController;
        vc.survey = (CustomSurvey*)sender;
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)actionSearch:(id)sender
{
    [self performSegueWithIdentifier:@"SegueToCodeReader" sender:nil];
}

-(void)actionBarcodeReaderNotification:(NSNotification*)notification
{
    if ([notification.object isKindOfClass:[NSString class]]){
        self.readedCode = [NSString stringWithFormat:@"%@", notification.object];
    }else{
        self.readedCode = nil;
    }
    
    NSLog(@"QRCODE: %@", readedCode);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textColor = [UIColor darkGrayColor];
    [lblMessage setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_NOTE]];
    lblMessage.text = @"Você pode encontrar um QRCode de Questionário em banners, posters, páginas web, redes sociais, produtos.\nUm usuário com questionário compatível também pode gerar um QRCode especialmente para compartilhá-lo com você.";
    
    viewMessage.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viewMessage.layer.cornerRadius = 5.0;
    viewMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    viewMessage.layer.borderWidth = 1.5;
    
    btnSearch.backgroundColor = [UIColor clearColor];
    [btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSearch.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnSearch setTitle:@"Escanear QRCode" forState:UIControlStateNormal];
    [btnSearch setExclusiveTouch:YES];
    [btnSearch setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSearch.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnSearch setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSearch.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    UIImage *iconCreate = [ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:[UIImage imageNamed:@"RotationalZoomButton"]];
    [btnSearch setImage:iconCreate forState:UIControlStateNormal];
    [btnSearch setImageEdgeInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 10.0)];
    [btnSearch.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnSearch setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [btnSearch setTintColor:[UIColor whiteColor]];
    btnSearch.tag = 1;
}

#pragma mark - Connection

-(void)loadQuestionnaireData:(NSString*)code
{
    NSDictionary *dic = [ToolBox converterHelper_DictionaryFromStringJson:code];
    if (dic){
        
        long questionnaireID = [[dic valueForKey:@"QID"] integerValue];
        
        [self loadQuestionnaireWithID:questionnaireID];
    }
}

#pragma mark - UTILS (General Use)

- (void)loadQuestionnaireWithID:(long)qID
{
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });
    
    //TODO: Ainda não existe endpoint consumível...
    
    //code here...
    
    //Abrindo um exemplo temporário:
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadLocalSample];
    });
    
}

- (void)loadLocalSample
{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"questionnaire-sample-complete-components" ofType:@"json"]]];
    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"Custom Survey: %@", json);
    
    if (error == nil){
        if ([json isKindOfClass:[NSDictionary class]]){
            NSDictionary *dicResponse = (NSDictionary *)json;
            if ([[dicResponse allKeys] containsObject:@"custom_survey"]) {
                CustomSurvey *survey = [CustomSurvey createObjectFromDictionary:[dicResponse valueForKey:@"custom_survey"]];
                [self performSegueWithIdentifier:@"SegueToQuestionnaire" sender:survey];
                
            }
        }
    }
    
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
}

@end
