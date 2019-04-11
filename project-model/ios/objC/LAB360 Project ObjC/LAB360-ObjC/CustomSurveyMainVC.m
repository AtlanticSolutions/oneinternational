//
//  CustomSurveyMainVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 08/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "CustomSurveyMainVC.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "VC_WebViewCustom.h"
#import "CustomSurveyListGroupVC.h"
#import "CustomSurveyDataSource.h"
#import "CustomSurvey.h"
#import "CustomSurveyGeralFormVC.h"
#import "CustomSurveyShareableCodeViewerVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface CustomSurveyMainVC()

//Data:
@property(nonatomic, assign) BOOL contentLoaded;

//Layout:
@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UIImageView *imvBanner;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property(nonatomic, weak) IBOutlet UILabel *lblDescription;
@property(nonatomic, weak) IBOutlet UIButton *btnLink;
@property(nonatomic, weak) IBOutlet UIButton *btnStart;

@end

#pragma mark - • IMPLEMENTATION
@implementation CustomSurveyMainVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize survey, contentLoaded;
@synthesize lblTitle, imvBanner, indicatorView, lblDescription, btnLink, btnStart;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    contentLoaded = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      if (!contentLoaded){
        [self setupLayout:@"Questionário"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadSurveyData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToWebBrowser"]){
        VC_WebViewCustom *destViewController = (VC_WebViewCustom*)segue.destinationViewController;
        destViewController.titleNav = ((WebItemToShow*)sender).titleMenu;
        destViewController.fileURL = ((WebItemToShow*)sender).urlString;
        destViewController.showShareButton = NO;
        destViewController.hideViewButtons = YES;
        destViewController.showAppMenu = NO;
        //
        return;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToGroupedList"]){
        CustomSurveyListGroupVC *destViewController = (CustomSurveyListGroupVC*)segue.destinationViewController;
        destViewController.survey = [self.survey copyObject];
        destViewController.showAppMenu = NO;
        //
        return;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToSurvey"]){
        CustomSurveyGeralFormVC *destViewController = (CustomSurveyGeralFormVC*)segue.destinationViewController;
        destViewController.survey = survey;
        destViewController.groupIndex = 0;
        destViewController.showAppMenu = NO;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToCodeViewer"]){
        CustomSurveyShareableCodeViewerVC *destViewController = (CustomSurveyShareableCodeViewerVC*)segue.destinationViewController;
        destViewController.shareableCode = [NSString stringWithFormat:@"%@", self.survey.shareableCode];
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionLink:(id)sender
{
    WebItemToShow *webItem = [WebItemToShow new];
    webItem.urlString = survey.link;
    webItem.titleMenu = survey.name;
    //
    [self performSegueWithIdentifier:@"SegueToWebBrowser" sender:webItem];
}

- (IBAction)actionStartSurvey:(id)sender
{
    //validations here:
    if (survey.groups.count == 0 || survey.formType == SurveyFormTypeUnanswerable){
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:@"Atenção!" subTitle:@"Este questionário não pode ser respondido no momento." closeButtonTitle:@"OK" duration:0.0];
    }else{
        
        if (survey.requiredMedia){
            [self downloadAllMediaFromSurvey];
        }else{
            [self startSurvey];
        }
    }
}

- (IBAction)actionQRCode:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CustomSurvey" bundle:[NSBundle mainBundle]];
    CustomSurveyShareableCodeViewerVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomSurveyShareableCodeViewerVC"];
    vc.showAppMenu = NO;
    vc.shareableCode = [NSString stringWithFormat:@"%@", self.survey.shareableCode];
    [vc awakeFromNib];
    //
    vc.providesPresentationContextTransitionStyle = YES;
    vc.definesPresentationContext = YES;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical; //UIModalTransitionStyleCrossDissolve;
    //
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor darkTextColor];
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]];
    lblTitle.text = @"";
    
    imvBanner.backgroundColor = [UIColor clearColor];
    imvBanner.image = nil;
    [imvBanner.layer setCornerRadius:5.0];
    
    [indicatorView setColor:AppD.styleManager.colorPalette.primaryButtonSelected];
    [indicatorView setHidesWhenStopped:YES];
    
    lblDescription.backgroundColor = [UIColor clearColor];
    lblDescription.textColor = [UIColor grayColor];
    [lblDescription setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TITLE_NAVBAR]];
    lblDescription.text = @"";
    
    [btnLink setBackgroundColor:[UIColor clearColor]];
    [btnLink setTitleColor:COLOR_MA_BLUE forState:UIControlStateNormal];
    [btnLink.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_NO_BORDERS]];
    [btnLink setTitle:@"" forState:UIControlStateNormal];
    [btnLink setEnabled:YES];
    [btnLink setClipsToBounds:YES];
    //
    [btnLink.layer setMasksToBounds:YES];
    [btnLink.layer setBorderColor:[UIColor grayColor].CGColor];
    [btnLink.layer setBorderWidth:1.0];
    [btnLink.layer setCornerRadius:btnLink.frame.size.height / 2.0];
    //
    [btnLink setHidden:YES];
    
    btnStart.backgroundColor = [UIColor clearColor];
    [btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnStart.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
    [btnStart setTitle:@"INICIAR" forState:UIControlStateNormal];
    [btnStart setExclusiveTouch:YES];
    [btnStart setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnStart.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnStart setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnStart.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    [btnStart setEnabled:NO];
    
    if ([ToolBox textHelper_CheckRelevantContentInString:self.survey.shareableCode]){
        [self createQRCodeButton];
    }
}

- (void)createQRCodeButton
{
    UIImage *image = [[UIImage imageNamed:@"CouponScannerIcon_QRCode"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    [button setClipsToBounds:YES];
    [button setExclusiveTouch:YES];
    [button setTintColor:AppD.styleManager.colorPalette.textNormal];
    [button addTarget:self action:@selector(actionQRCode:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[button.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[button.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = b;
}

- (void)loadSurveyData
{
    if (self.survey != nil){
        
        [survey finishSurvey];
        
        //layout
        lblTitle.text = self.survey.name;
        lblDescription.text = self.survey.presentation;
        
        if ([ToolBox textHelper_CheckRelevantContentInString:self.survey.linkMessage]){
            [btnLink setTitle:self.survey.linkMessage forState:UIControlStateNormal];
            [btnLink setHidden:NO];
        }
        
        [self loadBannerImage];
        [btnStart setEnabled:YES];
        
        if (![ToolBox textHelper_CheckRelevantContentInString:self.survey.linkMessage] || ![ToolBox textHelper_CheckRelevantContentInString:self.survey.link]){
            [btnLink setEnabled:NO];
        }
        
        contentLoaded = YES;
        
    }else{
        
        lblDescription.text = @"No momento não há nenhum questionário válido...";
        
    }
}

- (void)loadBannerImage
{
    [indicatorView startAnimating];
    [imvBanner setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:survey.urlBanner]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        [indicatorView stopAnimating];
        survey.bannerImage = image;
        imvBanner.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [indicatorView stopAnimating];
        imvBanner.image = nil; //[UIImage imageNamed:@"cell-sponsor-image-placeholder"];
    }];
}

- (void)startSurvey
{
    NSString *message = @"Está certo que deseja iniciar o questionário?";
    
    if (survey.secondsToFinish > 0){
        NSString *timeString = [survey calculateTimeToSurvey];
        NSString *timeMessage = [NSString stringWithFormat:@"Você terá um tempo limite para finalizar o questionário (%@). Não será possível submeter o resultado após o tempo estipulado.", timeString ];
        message = [NSString stringWithFormat:@"%@\n\n%@", message, timeMessage];
    }
    
    if (!survey.acceptsInterruption){
        NSString *interruptionMessage = @"Não é permitido interromper ou sair do questionário. Estas ações resultarão em cancelamento automático da mesma.";
        message = [NSString stringWithFormat:@"%@\n\n%@", message, interruptionMessage];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Atenção!" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionStart = [UIAlertAction actionWithTitle:@"Iniciar" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (survey.formType == SurveyFormTypeGroups){
            [self performSegueWithIdentifier:@"SegueToGroupedList" sender:nil];
        }else{
            [self performSegueWithIdentifier:@"SegueToSurvey" sender:nil];
        }
        
    }];
    [alertController addAction:actionStart];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UTILS (General Use)

- (void)downloadAllMediaFromSurvey
{
    if (survey){
        
        __block int totalMedias = 0;
        __block int downloadedMedias = 0;
        
        for (CustomSurveyGroup *group in survey.groups){
            if ([ToolBox textHelper_CheckRelevantContentInString:group.imageURL]){
                totalMedias += 1;
            }
            //
            for (CustomSurveyQuestion *question in group.questions){
                if ([ToolBox textHelper_CheckRelevantContentInString:question.imageURL]){
                    totalMedias += 1;
                }
                //
                for (CustomSurveyAnswer *answer in question.answers){
                    if ([ToolBox textHelper_CheckRelevantContentInString:answer.imageURL]){
                        totalMedias += 1;
                    }
                }
            }
        }
        
        if (totalMedias == 0){
            
            //Não há mídia alguma para transferência:
            [self startSurvey];
            
        }else{
            
            //O conteúdo precisa ser baixado:
            
            dispatch_async(dispatch_get_main_queue(),^{
                [AppD showLoadingAnimationWithType:eActivityIndicatorType_Downloading];
            });
            
            dispatch_group_t serviceGroup = dispatch_group_create();
            
            for (CustomSurveyGroup *group in survey.groups){
                if ([ToolBox textHelper_CheckRelevantContentInString:group.imageURL]){
                    
                    dispatch_group_enter(serviceGroup);
                    [[[AsyncImageDownloader alloc] initWithFileURL:group.imageURL successBlock:^(NSData *data) {
                        if (data != nil){
                            @try {
                                if ([group.imageURL hasSuffix:@"GIF"] || [group.imageURL hasSuffix:@"gif"]) {
                                    group.image = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:data];
                                }else{
                                    group.image = [UIImage imageWithData:data];
                                }
                                downloadedMedias += 1;
                                //
                                dispatch_async(dispatch_get_main_queue(),^{
                                    float completed = ((float)downloadedMedias / (float)totalMedias) * 100.0;
                                    [AppD updateLoadingAnimationMessage:[NSString stringWithFormat:@"%.1f %%", completed]];
                                });
                            } @catch (NSException *exception) {
                                NSLog(@"downloadAllMediaFromSurvey >> Error >> %@", [exception reason]);
                            }
                        }
                        dispatch_group_leave(serviceGroup);
                    } failBlock:^(NSError *error) {
                        dispatch_group_leave(serviceGroup);
                    }] startDownload];
                    
                }
                //
                for (CustomSurveyQuestion *question in group.questions){
                    if ([ToolBox textHelper_CheckRelevantContentInString:question.imageURL]){
                        
                        dispatch_group_enter(serviceGroup);
                        [[[AsyncImageDownloader alloc] initWithFileURL:question.imageURL successBlock:^(NSData *data) {
                            if (data != nil){
                                @try {
                                    if ([question.imageURL hasSuffix:@"GIF"] || [question.imageURL hasSuffix:@"gif"]) {
                                        question.image = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:data];
                                    }else{
                                        question.image = [UIImage imageWithData:data];
                                    }
                                    downloadedMedias += 1;
                                    //
                                    dispatch_async(dispatch_get_main_queue(),^{
                                        float completed = ((float)downloadedMedias / (float)totalMedias) * 100.0;
                                        [AppD updateLoadingAnimationMessage:[NSString stringWithFormat:@"%.1f %%", completed]];
                                    });
                                } @catch (NSException *exception) {
                                    NSLog(@"downloadAllMediaFromSurvey >> Error >> %@", [exception reason]);
                                }
                            }
                            dispatch_group_leave(serviceGroup);
                        } failBlock:^(NSError *error) {
                            dispatch_group_leave(serviceGroup);
                        }] startDownload];
                        
                    }
                    //
                    for (CustomSurveyAnswer *answer in question.answers){
                        if ([ToolBox textHelper_CheckRelevantContentInString:answer.imageURL]){
                            
                            dispatch_group_enter(serviceGroup);
                            [[[AsyncImageDownloader alloc] initWithFileURL:answer.imageURL successBlock:^(NSData *data) {
                                if (data != nil){
                                    @try {
                                        if ([answer.imageURL hasSuffix:@"GIF"] || [answer.imageURL hasSuffix:@"gif"]) {
                                            answer.image = (UIImage*)[UIImage animatedImageWithAnimatedGIFData:data];
                                        }else{
                                            answer.image = [UIImage imageWithData:data];
                                        }
                                        downloadedMedias += 1;
                                        //
                                        dispatch_async(dispatch_get_main_queue(),^{
                                            float completed = ((float)downloadedMedias / (float)totalMedias) * 100.0;
                                            [AppD updateLoadingAnimationMessage:[NSString stringWithFormat:@"%.1f %%", completed]];
                                        });
                                    } @catch (NSException *exception) {
                                        NSLog(@"downloadAllMediaFromSurvey >> Error >> %@", [exception reason]);
                                    }
                                }
                                dispatch_group_leave(serviceGroup);
                            } failBlock:^(NSError *error) {
                                dispatch_group_leave(serviceGroup);
                            }] startDownload];
                            
                        }
                    }
                }
            }
            
            dispatch_group_notify(serviceGroup, dispatch_get_main_queue(),^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ANIMA_TIME_NORMAL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                        [AppD hideLoadingAnimation];
                    });
                    
                    if (downloadedMedias == totalMedias){
                        
                        //Todas as mídias foram baixadas com sucesso:
                        [self startSurvey];
                        
                    }else{
                        
                        //Alguma das mídias não pôde ser baixada:
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showError:@"Erro" subTitle:@"O conjunto de mídias necessárias para realização do questionário não pôde ser baixado por completo. Por favor, verifique sua conexão com a internet ou tente mais tarde." closeButtonTitle:@"OK" duration:0.0];
                        
                    }
                    
                });
                
            });
            
        }
        
    }
    
}

@end
