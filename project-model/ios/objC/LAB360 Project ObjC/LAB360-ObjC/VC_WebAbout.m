//
//  VC_MA_About.m
//  GS&MD
//
//  Created by Erico GT on 05/12/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_WebAbout.h"
#import <WebKit/WebKit.h>
#import "AsyncImageDownloader.h"
#import "UIImageView+AFNetworking.h"
//
#import "JPSVolumeButtonHandler.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_WebAbout()

@property (nonatomic, weak) IBOutlet UIView *viewVersion;
@property (nonatomic, weak) IBOutlet UILabel *lblVersion;
@property (nonatomic, weak) IBOutlet UIView *wbvAbout;
@property (nonatomic, strong) WKWebView *wb;
@property (nonatomic, strong) NSString *aboutURL;
//
@property (nonatomic, strong) JPSVolumeButtonHandler *volumeHandler;
@property (nonatomic, strong) NSString *secretText;
@property (nonatomic, assign) BOOL secretEnabled;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_WebAbout
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize viewVersion, lblVersion, wbvAbout, wb, aboutURL;
@synthesize volumeHandler, secretText, secretEnabled;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aboutURL = nil;
    
    volumeHandler = [JPSVolumeButtonHandler volumeButtonHandlerWithUpBlock:^{
        [self actionVolumeUp];
    } downBlock:^{
        [self actionVolumeDown];
    }];
    
    secretText = @"";
    secretEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_ABOUT", @"")];
    [self getAboutPage];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Start
    [self.volumeHandler startHandler:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Stop
    [self.volumeHandler stopHandler];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (void)actionVolumeUp
{
    if (secretEnabled) {
        secretText = [NSString stringWithFormat:@"%@%@", secretText, @"U"];
        if (secretText.length > 6) {
            secretText = @"";
        }
        self.navigationItem.title = secretText;
    }
}

- (void)actionVolumeDown
{
    if (secretEnabled) {
        secretText = [NSString stringWithFormat:@"%@%@", secretText, @"D"];
        if ([secretText isEqualToString:@"UUDDUD"]) {
            [self actionSecretCommand];
            secretText = @"";
        } else {
            if (secretText.length > 6) {
                secretText = @"";
            }
            self.navigationItem.title = secretText;
        }
    }
}

- (void) actionTapGesture:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.view.tag == 0) {
        recognizer.view.tag = 1;
        lblVersion.textColor =[UIColor redColor];
        //
        secretEnabled = YES;
        secretText = @"";
        //
        self.navigationItem.title = secretText;
    } else {
        recognizer.view.tag = 0;
        lblVersion.textColor = AppD.styleManager.colorPalette.textNormal;
        //
        secretEnabled = NO;
        secretText = @"";
        //
        self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_ABOUT", @"");
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

//Motion Shake
//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//
//-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    if (motion == UIEventSubtypeMotionShake){
//        NSLog(@"Shake!");
//    }
//}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)
- (void) getAboutPage
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getAboutPageWithCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            NSLog(@"VC_WebAbout >> getAboutPage >> %@", response);
            
            if (error){
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:[error localizedDescription] closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }else{
                if ([response isKindOfClass:[NSDictionary class]]){
                    NSArray *abouts = [response valueForKey:@"abouts"];
                    if (abouts.count > 0){
                        NSDictionary *firstAbout = [abouts firstObject];
                        //title
                        NSString *title = [firstAbout valueForKey:@"title"];
                        if (title){
                            self.navigationItem.title = title;
                        }
                        //url
                        NSString *url = [firstAbout valueForKey:@"url"];
                        if (url){
                            aboutURL = url;
                            [wb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aboutURL]]];
                        }
                        //message
                        NSString *message = [firstAbout valueForKey:@"message"];
                        if ([ToolBox textHelper_CheckRelevantContentInString:message]){
                            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                            [alert showInfo:NSLocalizedString(@"SCREEN_TITLE_ABOUT", @"") subTitle:message closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                        }
                    }
                }
            }
            
            /*
             //Formato de resposta válido, conferido dia (30/11/2018)
             abouts = (
                {
                    id = 1;
                    message = "Bem vindo ao aplicativo modela da LAB360.";
                    title = "Sobre LAB360";
                    url = "http://lab360.com.br/";
                }
             );
             */
    
        }];
        
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}


- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Background Image
    //imvBackground.image = [UIImage imageNamed:@"ma-background-insurance-life.jpg"];
    //
    lblVersion.textColor = AppD.styleManager.colorPalette.textNormal;
    lblVersion.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    //status:
    if ([AppD webServerLoggerIsRunning]){
        NSString *status = [AppD webServerLoggerStatus];
        NSString *sei = [AppD serverEnvironmentIdentifier];
        lblVersion.text = [NSString stringWithFormat:@"%@: %@ %@\n%@", NSLocalizedString(@"LABEL_APP_VERSION", @""),[ToolBox applicationHelper_VersionBundle], sei, status];
    }else{
        NSString *sei = [AppD serverEnvironmentIdentifier];
        lblVersion.text = [NSString stringWithFormat:@"%@: %@ %@", NSLocalizedString(@"LABEL_APP_VERSION", @""),[ToolBox applicationHelper_VersionBundle], sei];
    }
    //
    viewVersion.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    //
    wb = [[WKWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, wbvAbout.frame.size.width, wbvAbout.frame.size.height)];
    [wbvAbout addSubview:wb];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    gesture.numberOfTapsRequired = 2;
    [lblVersion setUserInteractionEnabled:YES];
    [lblVersion addGestureRecognizer:gesture];
}

- (void)actionSecretCommand
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert addButton:@"Start Servers" withType:SCLAlertButtonType_Normal actionBlock:^{
        
        NSString *strSub = [AppD startWebServerLogger];
        SCLAlertViewPlus *alertSub = [AppD createDefaultAlert];
        [alertSub addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
            
            NSString *status = [AppD webServerLoggerStatus];
            //
            NSString *sei = [AppD serverEnvironmentIdentifier];
            lblVersion.text = [NSString stringWithFormat:@"%@: %@ %@\n%@", NSLocalizedString(@"LABEL_APP_VERSION", @""),[ToolBox applicationHelper_VersionBundle], sei, status];
        }];
        [alertSub showNotice:@"Command Result" subTitle:strSub closeButtonTitle:nil duration:0.0];
        
    }];
    [alert addButton:@"Stop Servers" withType:SCLAlertButtonType_Destructive actionBlock:^{
        
        NSString *strSub = [AppD stopWebServerLogger];
        SCLAlertViewPlus *alertSub = [AppD createDefaultAlert];
        [alertSub addButton:@"OK" withType:SCLAlertButtonType_Normal actionBlock:^{
            
            NSString *sei = [AppD serverEnvironmentIdentifier];
            lblVersion.text = [NSString stringWithFormat:@"%@: %@ %@", NSLocalizedString(@"LABEL_APP_VERSION", @""),[ToolBox applicationHelper_VersionBundle], sei];
        }];
        [alertSub showNotice:@"Command Result" subTitle:strSub closeButtonTitle:nil duration:0.0];
        
    }];
    [alert addButton:@"Cancel" withType:SCLAlertButtonType_Neutral actionBlock:nil];
    NSString *strLog = [AppD webServerLoggerStatus];
    [alert showInfo:@"Dev Data Logger" subTitle:strLog closeButtonTitle:nil duration:0.0];
    
    lblVersion.tag = 0;
    lblVersion.textColor = AppD.styleManager.colorPalette.textNormal;
    secretEnabled = NO;
    secretText = @"";
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_ABOUT", @"");
}

@end

