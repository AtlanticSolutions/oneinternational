//
//  TextAndVoiceVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 30/10/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import <AVFoundation/AVFoundation.h>
//
#import "TextAndVoiceVC.h"
#import "AppDelegate.h"
#import "SpeechRecognitionManager.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface TextAndVoiceVC()<SpeechRecognitionManagerDelegate, AVSpeechSynthesizerDelegate>
//Data:
@property (nonatomic, strong) AVSpeechSynthesizer* speechSynthesizer;
@property (nonatomic, strong) AVSpeechSynthesisVoice* speechVoice;
@property (nonatomic, strong) SpeechRecognitionManager* speechRecognator;
//
@property (nonatomic, assign) BOOL isLoaded;

//Layout:
@property (nonatomic, weak) IBOutlet UILabel* lblTitle;
@property (nonatomic, weak) IBOutlet UITextView* txtMessage;
@property (nonatomic, weak) IBOutlet UIView* viewButtons;
@property (nonatomic, strong) UIButton* speakerButton;

@end

#pragma mark - • IMPLEMENTATION
@implementation TextAndVoiceVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize speechSynthesizer, speechVoice, speechRecognator, isLoaded;
@synthesize lblTitle, txtMessage, viewButtons, speakerButton;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLayout:@"Texto e Fala"];
    
    if (SYSTEM_VERSION_LESS_THAN_10){
        speechRecognator = [SpeechRecognitionManager newSpeechRecognitionManagerWithDelegate:self];
        //
        SpeechRecognitionButtonConfiguration *config = [SpeechRecognitionButtonConfiguration new];
        config.isTypeAutoStop = YES;
        config.showRemainingTimeAnimation = YES;
        config.frame = CGRectMake(viewButtons.frame.size.width - 100.0, 0.0, 100.0, 100.0);
        config.normalBackgroundColor = AppD.styleManager.colorPalette.primaryButtonNormal;
        config.highlightedBackgroundColor = AppD.styleManager.colorPalette.primaryButtonSelected;
        config.normalIconColor = [UIColor whiteColor];
        config.highlightedIconColor = [UIColor lightGrayColor];
        config.shadowColor = [UIColor blackColor];
        //
        [speechRecognator configureEmbeddedButton:config];
        //
        [viewButtons addSubview:speechRecognator.embeddedMicButton];
    }
    
    [self createSpeakerButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isLoaded){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [self speakText:@" "];
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

- (IBAction)actionSpeakerPressed:(UIButton*)sender
{
    if ([ToolBox textHelper_CheckRelevantContentInString:txtMessage.text]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [speechRecognator.embeddedMicButton setEnabled:NO];
            [self speakText:txtMessage.text];
        });
    }
}

-(IBAction)actionClearMessage:(UIButton*)sender
{
    txtMessage.text = @"";
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark SpeechRecognitionManagerDelegate

- (void)speechRecognitionManager:(SpeechRecognitionManager*)manager didRecognizePartialText:(NSString*)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        txtMessage.text = text;
    });
}

- (void)speechRecognitionManager:(SpeechRecognitionManager*)manager didRecognizeAllText:(NSString*)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        txtMessage.text = text;
    });
}

- (void)speechRecognitionManager:(SpeechRecognitionManager*)manager didChangeStatus:(SpeechRecognitionManagerStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (status) {
            case SpeechRecognitionManagerStatusStoped:{
                [speakerButton setEnabled:YES];
                return;
            }break;
                
            case SpeechRecognitionManagerStatusRunning:{
                [speakerButton setEnabled:NO];
                return;
            }break;
                
            case SpeechRecognitionManagerStatusError:{
                
                [speakerButton setEnabled:YES];
                
                if (speechRecognator.speechRecognizerPermission == SFSpeechRecognizerAuthorizationStatusAuthorized && speechRecognator.micRecordPermission == AVAudioSessionRecordPermissionGranted){
                    //Ocorreu algum outro erro que não tem a ver com autorização do usuário:
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showError:@"Erro" subTitle:speechRecognator.statusDescription closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }else{
                    //O usuário não deu autorização apropriada (seja microfone ou reconhecedor de voz):
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert addButton:NSLocalizedString(@"ALERT_OPTION_SETTINGS", "") withType:SCLAlertButtonType_Normal actionBlock:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }];
                    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
                    //
                    [alert showInfo:@"Permissão" subTitle:@"Para utilizar esta funcionalidade você precisa autorizar o acesso ao Microfone e a utilização do Reconhecedor de Voz." closeButtonTitle:nil duration:0.0];
                }
            }
        }
    });
}

#pragma mark AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [speechRecognator.embeddedMicButton setEnabled:YES];
    
    if (!isLoaded){
        [UIView animateWithDuration:0.25 animations:^{
            lblTitle.alpha = 1.0;
            txtMessage.alpha = 1.0;
        }];
        isLoaded = YES;
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
    }
}

//others:
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {}
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance {}
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance {}
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {}
//- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor darkGrayColor];
    lblTitle.text = @"Toque no botão da esquerda para ouvir o texto ou no da direita para registrar uma nova mensagem.";
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_MENU_OPTION]];
    
    //TextView
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.maximumLineHeight = 20.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    //
    NSString *finalString = @"A poesia, ou texto lírico, é uma das sete artes tradicionais, pela qual a linguagem humana é utilizada com fins estéticos ou críticos, ou seja, ela retrata algo em que tudo pode acontecer dependendo da imaginação do autor como a do leitor.";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TITLE_NAVBAR] range:NSMakeRange(0, finalString.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, finalString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppD.styleManager.colorPalette.primaryButtonTitleNormal range:NSMakeRange(0, finalString.length)];
    //
    txtMessage.attributedText = attributedString;
    [txtMessage setTextColor:AppD.styleManager.colorPalette.textDark];
    [txtMessage.layer setCornerRadius:5.0];
    [txtMessage.layer setBorderWidth:1.0];
    [txtMessage.layer setBorderColor:AppD.styleManager.colorCalendarAvailable.CGColor];
    [txtMessage setTextContainerInset:UIEdgeInsetsMake(10.0, 0.0, 5.0, 0.0)];
    //
    txtMessage.inputAccessoryView = [self createAcessoryViewForTextView:txtMessage];
    
    //footer
    viewButtons.backgroundColor = [UIColor clearColor];
    
    lblTitle.alpha = 0.0;
    txtMessage.alpha = 0.0;
}

- (void)createSpeakerButton
{
    speakerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [speakerButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [speakerButton setTitle:@"" forState:UIControlStateNormal];
    [speakerButton setExclusiveTouch:YES];
    //
    [speakerButton addTarget:self action:@selector(actionSpeakerPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [speakerButton setFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    
    UIImage *back = [UIImage imageNamed:@"SpeechRecognitionMicButtonBackground"];
    UIImage *backSmall = [UIImage imageNamed:@"SpeechRecognitionMicButtonBackgroundSmall"];
    UIImage *icon = [UIImage imageNamed:@"SpeechRecognitionSpeakerButtonIcon"];
    UIImage *iconSmall = [UIImage imageNamed:@"SpeechRecognitionSpeakerButtonIconSmall"];
    
    [speakerButton setBackgroundImage:[ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonNormal andImageTemplate:back] forState:UIControlStateNormal];
    [speakerButton setBackgroundImage:[ToolBox graphicHelper_ImageWithTintColor:AppD.styleManager.colorPalette.primaryButtonSelected andImageTemplate:backSmall] forState:UIControlStateHighlighted];
    
    [speakerButton setImage:[ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:icon] forState:UIControlStateNormal];
    [speakerButton setImage:[ToolBox graphicHelper_ImageWithTintColor:[UIColor lightGrayColor] andImageTemplate:iconSmall] forState:UIControlStateHighlighted];
    
    [ToolBox graphicHelper_ApplyShadowToView:speakerButton withColor:[UIColor blackColor] offSet:CGSizeMake(2.0, 2.0) radius:3.0 opacity:0.5];
    
    [viewButtons addSubview:speakerButton];
}

-(UIView*)createAcessoryViewForTextView:(UITextView*)txtView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width/2, 40)];
    btnClose.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnClose addTarget:txtView action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClose.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [btnClose setTitle:@"Fechar" forState:UIControlStateNormal];
    [view addSubview:btnClose];
    //
    UIButton *btnClear = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 40)];
    btnClear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnClear addTarget:self action:@selector(actionClearMessage:) forControlEvents:UIControlEventTouchUpInside];
    [btnClear setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [btnClear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClear.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TEXT_FIELDS]];
    [btnClear setTitle:@"Limpar" forState:UIControlStateNormal];
    [view addSubview:btnClear];
    
    return view;
}

- (void)speakText:(NSString*)text
{
    AVSpeechUtterance* speechUtterance = [[AVSpeechUtterance alloc] initWithString:text];
    speechUtterance.pitchMultiplier = 1.0;
    speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    speechUtterance.volume = 0.9;
    //Busca por voz aprimorada (provavelmente a 'Luciana')
    if (speechVoice == nil){
        NSArray *voices = [AVSpeechSynthesisVoice speechVoices];
        AVSpeechSynthesisVoice *voiceEnhanced = nil;
        for (AVSpeechSynthesisVoice *v in voices){
            if (v.quality == AVSpeechSynthesisVoiceQualityEnhanced && [v.language isEqualToString:@"pt-BR"]){
                speechVoice = v;
                break;
            }
        }
        if (voiceEnhanced == nil){
            speechVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"pt-BR"];
        }
    }
    speechUtterance.voice = speechVoice;
    //
    if (speechSynthesizer == nil){
        speechSynthesizer = [AVSpeechSynthesizer new];
        speechSynthesizer.delegate = self;
    }
    //
    [speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    [speechSynthesizer speakUtterance:speechUtterance];
}

#pragma mark - UTILS (General Use)

@end
