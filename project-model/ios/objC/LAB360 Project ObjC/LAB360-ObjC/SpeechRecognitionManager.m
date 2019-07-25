//
//  SpeechRecognitionManager.m
//  MaisAmigas
//
//  Created by Erico GT on 11/07/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#import "SpeechRecognitionManager.h"
#import "ToolBox.h"

@interface SpeechRecognitionManager()<SFSpeechRecognitionTaskDelegate>

@property(nonatomic, strong) NSString * _Nullable statusDescription;
@property(nonatomic, strong) NSString * _Nullable lastRecognizedText;
//
@property(nonatomic, weak) id<SpeechRecognitionManagerDelegate> managerDelegate;
@property(nonatomic, strong) AVAudioEngine* audioEngine;
@property(nonatomic, strong) SFSpeechRecognizer* speechRecognizer;
@property(nonatomic, strong) SFSpeechAudioBufferRecognitionRequest* recognitionRequest;
@property(nonatomic, strong) SFSpeechRecognitionTask* recognitionTask;
//
@property(nonatomic, strong) NSTimer* recognizerTimer;
@property(nonatomic, strong) NSTimer* autoStopTimer;
@property(nonatomic, assign) NSTimeInterval autoStopSeconds;
@property(nonatomic, assign) BOOL isRunning;
//
@property(nonatomic, strong) UIButton *embeddedMicButton;
@property(nonatomic, assign) BOOL micButtonAutoStop;
@property(nonatomic, assign) BOOL micButtonAutoAnimated;

@end

@implementation SpeechRecognitionManager

@synthesize autoStopSeconds, localeIdentifier, reportOnlyNumbers, speechRecognizerPermission, micRecordPermission, statusDescription, lastRecognizedText, managerDelegate, audioEngine, speechRecognizer, recognitionRequest, recognitionTask, recognizerTimer, autoStopTimer, isRunning;
@synthesize embeddedMicButton, micButtonAutoStop, micButtonAutoAnimated;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureManager];
    }
    return self;
}

+ (SpeechRecognitionManager*)newSpeechRecognitionManagerWithDelegate:(id<SpeechRecognitionManagerDelegate>)delegate
{
    SpeechRecognitionManager* manager = [SpeechRecognitionManager new];
    manager.managerDelegate = delegate;
    //
    return manager;
}

- (void)startRecognition
{
    if (!isRunning){
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            
            speechRecognizerPermission = status;
            
            BOOL bad = NO;
            
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:{
                    bad = YES;
                }break;
                    
                case SFSpeechRecognizerAuthorizationStatusDenied:{
                    bad = YES;
                }break;
                    
                case SFSpeechRecognizerAuthorizationStatusRestricted:{
                    bad = YES;
                }break;
                    
                case SFSpeechRecognizerAuthorizationStatusAuthorized:{
                    [self verifyMicAuthorization];
                }break;
            }
            
            if (bad){
                statusDescription = @"O aplicativo não possui autorização executar o 'Reconhecimento de Voz'.";
                if (managerDelegate){
                    [managerDelegate speechRecognitionManager:self didChangeStatus:SpeechRecognitionManagerStatusError];
                }
            }
        }];
    }
}

- (void)verifyMicAuthorization
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
        micRecordPermission = [[AVAudioSession sharedInstance] recordPermission];
        
        if (granted) {
            [self startRecording];
        }
        else {
            statusDescription = @"O aplicativo não possui autorização para utilizar o 'Microfone'.";
            if (managerDelegate){
                [managerDelegate speechRecognitionManager:self didChangeStatus:SpeechRecognitionManagerStatusError];
            }
        }
    }];
    
}

- (void)startRecording
{
    //***********************************************************************************
    // Configurando categoria e modo de funcionamento
    //***********************************************************************************
    
    NSError *categoryError = nil;
    NSError *modeError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&categoryError];
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeMeasurement error:&modeError];
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    if (categoryError){
        statusDescription = [categoryError localizedDescription];
        if (managerDelegate){
            [managerDelegate speechRecognitionManager:self didChangeStatus:SpeechRecognitionManagerStatusError];
        }
        return;
    }
    if (modeError){
        statusDescription = [modeError localizedDescription];
        if (managerDelegate){
            [managerDelegate speechRecognitionManager:self didChangeStatus:SpeechRecognitionManagerStatusError];
        }
        return;
    }
    
    //***********************************************************************************
    // Localização para o reconhecedor
    //***********************************************************************************
    
    if (localeIdentifier == nil){
        localeIdentifier = @"pt_BR";
    }
    
    speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:localeIdentifier]];
    
    recognitionRequest = [SFSpeechAudioBufferRecognitionRequest new];
    recognitionRequest.shouldReportPartialResults = YES;
    
    //***********************************************************************************
    // Parâmetros de entrada
    //***********************************************************************************
    
    AVAudioInputNode* inputNode = audioEngine.inputNode;
    AVAudioFormat* audioFormat = [inputNode outputFormatForBus:0];
    
    [inputNode removeTapOnBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:audioFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    [audioEngine prepare];
    
    NSError *error;
    [audioEngine startAndReturnError:&error];
    
    if (error){
        statusDescription = [error localizedDescription];
        if (managerDelegate){
            [managerDelegate speechRecognitionManager:self didChangeStatus:SpeechRecognitionManagerStatusError];
        }
    }else{
        
        recognitionTask = [speechRecognizer recognitionTaskWithRequest:recognitionRequest delegate:self];
        
        isRunning = YES;
        lastRecognizedText = @"";
        statusDescription = @"Reconhecimento de voz iniciado.";
        if (managerDelegate){
            [managerDelegate speechRecognitionManager:self didChangeStatus:SpeechRecognitionManagerStatusRunning];
        }
        
        recognizerTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(actionMaxTimeToRecognitionReached:) userInfo:nil repeats:NO];
    }
}

- (void)startRecognitionWithAutoStop:(SpeechRecognitionAutoStopTimer)seconds
{
    if (!isRunning){
        
        switch (seconds) {
            case SpeechRecognitionAutoStopTimer2seconds:{
                autoStopSeconds = 2.0;
            }break;
            case SpeechRecognitionAutoStopTimer4seconds:{
                autoStopSeconds = 4.0;
            }break;
            case SpeechRecognitionAutoStopTimer6seconds:{
                autoStopSeconds = 6.0;
            }break;
            case SpeechRecognitionAutoStopTimer8seconds:{
                autoStopSeconds = 8.0;
            }break;
        }
        
        [self startRecognition];
    }
}

- (void)stopRecognition
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(audioEngine.isRunning){
            [audioEngine.inputNode removeTapOnBus:0];
            [audioEngine.inputNode reset];
            [audioEngine stop];
            [recognitionRequest endAudio];
            [recognitionTask finish]; //cancel
            recognitionRequest = nil;
            recognitionTask = nil;
            speechRecognizer.delegate = nil;
            //
            [recognizerTimer invalidate];
            recognizerTimer = nil;
            [autoStopTimer invalidate];
            autoStopTimer = nil;
            //
            isRunning = NO;
            autoStopSeconds = 0.0;
            //
            statusDescription = @"Reconhecimento de voz parado.";
            if (managerDelegate){
                [managerDelegate speechRecognitionManager:self didChangeStatus:SpeechRecognitionManagerStatusStoped];
            }
        }
        
        if (micButtonAutoAnimated){
            [embeddedMicButton.imageView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        }
    });
}

- (void)configureEmbeddedButton:(SpeechRecognitionButtonConfiguration* _Nonnull)configuration
{
    [self configureButtonWithParameters:configuration];
}

#pragma mark - PRIVATE METHODS

- (void)configureManager
{
    autoStopSeconds = 0;
    localeIdentifier = @"pt_BR";
    speechRecognizerPermission = [SFSpeechRecognizer authorizationStatus];
    micRecordPermission = [[AVAudioSession sharedInstance] recordPermission];
    statusDescription = @"Aguardando comando.";
    lastRecognizedText = @"";
    managerDelegate = nil;
    audioEngine = [AVAudioEngine new];
    speechRecognizer = nil;
    recognitionRequest = [SFSpeechAudioBufferRecognitionRequest new];
    recognitionTask = [SFSpeechRecognitionTask new];
    recognizerTimer = nil;
    isRunning = NO;
    reportOnlyNumbers = NO;
    //
    embeddedMicButton = nil;
    [self createEmbeddedMicButton];
}

- (void)actionMaxTimeToRecognitionReached:(NSTimer*)timer
{
    [self stopRecognition];
}

- (void)actionAutoStopRecognition:(NSTimer*)timer
{
    [self stopRecognition];
}

#pragma mark - SFSpeechRecognitionTaskDelegate

// Called when the task first detects speech in the source audio
- (void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task
{
    return;
}

// Called for all recognitions, including non-final hypothesis
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didHypothesizeTranscription:(SFTranscription *)transcription
{
    NSString *partialText = transcription.formattedString;
    if (reportOnlyNumbers){
        partialText = [partialText stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [partialText length])];
    }
    
    if (managerDelegate){
        [managerDelegate speechRecognitionManager:self didRecognizePartialText:partialText];
    }
    
    if (![partialText isEqualToString:@""] && autoStopSeconds > 0.0){
        [autoStopTimer invalidate];
        autoStopTimer = [NSTimer scheduledTimerWithTimeInterval:autoStopSeconds target:self selector:@selector(actionAutoStopRecognition:) userInfo:nil repeats:NO];
    }
}

// Called only for final recognitions of utterances. No more about the utterance will be reported
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult
{
    lastRecognizedText = recognitionResult.bestTranscription.formattedString;
    
    if (reportOnlyNumbers){
        lastRecognizedText = [lastRecognizedText stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [lastRecognizedText length])];
    }
    
    if (managerDelegate){
        [managerDelegate speechRecognitionManager:self didRecognizeAllText:lastRecognizedText];
    }
    
    [self resetAudioSessionCategory];
}

// Called when the task is no longer accepting new audio but may be finishing final processing
- (void)speechRecognitionTaskFinishedReadingAudio:(SFSpeechRecognitionTask *)task
{
    return;
}

// Called when the task has been cancelled, either by client app, the user, or the system
- (void)speechRecognitionTaskWasCancelled:(SFSpeechRecognitionTask *)task
{
    [self resetAudioSessionCategory];
    //
    return;
}

// Called when recognition of all requested utterances is finished.
// If successfully is false, the error property of the task will contain error information
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishSuccessfully:(BOOL)successfully
{
    if (!successfully) {
        statusDescription = [task.error localizedDescription];
        if (managerDelegate){
            [managerDelegate speechRecognitionManager:self didChangeStatus:SpeechRecognitionManagerStatusError];
        }
    }
}

#pragma mark - Utils

- (void)createEmbeddedMicButton
{
    SpeechRecognitionButtonConfiguration *baseConfig = [SpeechRecognitionButtonConfiguration new];
    //
    embeddedMicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [embeddedMicButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [embeddedMicButton setTitle:@"" forState:UIControlStateNormal];
    [embeddedMicButton setExclusiveTouch:YES];
    //
    [embeddedMicButton addTarget:self action:@selector(actionMicPressed:) forControlEvents:UIControlEventTouchDown];
    [embeddedMicButton addTarget:self action:@selector(actionMicReleased:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    
    [self configureButtonWithParameters:baseConfig];
}

- (void)configureButtonWithParameters:(SpeechRecognitionButtonConfiguration*)config
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [embeddedMicButton setFrame:CGRectMake(config.frame.origin.x, config.frame.origin.y, config.frame.size.width, config.frame.size.height)];
        
        micButtonAutoStop = config.isTypeAutoStop;
        micButtonAutoAnimated = config.showRemainingTimeAnimation;
        
        UIImage *back = [UIImage imageNamed:@"SpeechRecognitionMicButtonBackground"];
        UIImage *backSmall = [UIImage imageNamed:@"SpeechRecognitionMicButtonBackgroundSmall"];
        UIImage *icon = [UIImage imageNamed:@"SpeechRecognitionMicButtonIcon"];
        UIImage *iconSmall = [UIImage imageNamed:@"SpeechRecognitionMicButtonIconSmall"];
        
        [embeddedMicButton setBackgroundImage:[ToolBox graphicHelper_ImageWithTintColor:config.normalBackgroundColor andImageTemplate:back] forState:UIControlStateNormal];
        [embeddedMicButton setBackgroundImage:[ToolBox graphicHelper_ImageWithTintColor:config.highlightedBackgroundColor andImageTemplate:backSmall] forState:UIControlStateHighlighted];
        
        [embeddedMicButton setImage:[ToolBox graphicHelper_ImageWithTintColor:config.normalIconColor andImageTemplate:icon] forState:UIControlStateNormal];
        [embeddedMicButton setImage:[ToolBox graphicHelper_ImageWithTintColor:config.highlightedIconColor andImageTemplate:iconSmall] forState:UIControlStateHighlighted];
        
        [ToolBox graphicHelper_ApplyShadowToView:embeddedMicButton withColor:config.shadowColor offSet:CGSizeMake(2.0, 2.0) radius:3.0 opacity:0.5];
    });
    
}

- (IBAction)actionMicPressed:(UIButton*)sender
{
    if (micButtonAutoStop){
        [self startRecognitionWithAutoStop:SpeechRecognitionAutoStopTimer2seconds];
    }else{
        [self startRecognition];
    }

    if (micButtonAutoAnimated){
        [self applyTimerEffectInView:embeddedMicButton.imageView];
    }
}

- (IBAction)actionMicReleased:(UIButton*)sender
{
    if (!micButtonAutoStop){
        [self stopRecognition];
    }
}

- (void)applyTimerEffectInView:(UIView*)view
{
    CGFloat radius = (MIN(view.frame.size.width / 2.0, view.frame.size.height / 2.0) * 0.8);
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(view.frame.size.width / 2.0, view.frame.size.height / 2.0) radius:radius startAngle:-M_PI_2 endAngle:2 * M_PI - M_PI_2 clockwise:YES].CGPath;
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor redColor].CGColor;
    circle.lineWidth = 5;
    circle.lineJoin = kCALineJoinRound;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 30; //limite que o reconhecedor grava audio
    animation.removedOnCompletion = YES;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circle addAnimation:animation forKey:@"drawCircleAnimation"];
    
    [view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [view.layer insertSublayer:circle atIndex:0];
}

- (void)resetAudioSessionCategory
{
    NSError *categoryError = nil;
    NSError *activationError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&categoryError];
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&activationError];
    
    if (categoryError){
        NSLog(@"resetAudioSessionCategory >> Error >> %@", [categoryError localizedDescription]);
    }else if (activationError){
        NSLog(@"resetAudioSessionCategory >> Error >> %@", [activationError localizedDescription]);
    }
}

@end

#pragma mark - Class Interface

@implementation SpeechRecognitionButtonConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isTypeAutoStop = NO;
        self.showRemainingTimeAnimation = YES;
        self.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
        self.normalBackgroundColor = [UIColor grayColor];
        self.highlightedBackgroundColor = [UIColor darkGrayColor];
        self.normalIconColor = [UIColor whiteColor];
        self.highlightedIconColor = [UIColor groupTableViewBackgroundColor];
        self.shadowColor = [UIColor blackColor];
    }
    return self;
}

@end
