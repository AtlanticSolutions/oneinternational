//
//  PromotionalCardScratchVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 25/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "PromotionalCardScratchVC.h"

#define RandomNumber(min, max) min + arc4random_uniform(max - min + 1)

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface PromotionalCardScratchVC()

//Layout:
@property(nonatomic, weak) IBOutlet UIImageView *imvWallpaper;
@property(nonatomic, weak) IBOutlet UIView *viewContainer;
@property(nonatomic, weak) IBOutlet UIView *viewScratch;
@property(nonatomic, weak) IBOutlet UIImageView *imvBackground;
@property(nonatomic, weak) IBOutlet UITextView *txvCardInfo;

//Data:
@property(nonatomic, strong) ScrathItem *premiumItem;
@property(nonatomic, strong) ScrathItem *scratchyItem;
@property(nonatomic, assign) CGFloat resultProgress;
//
@property (nonatomic, strong) GameParticleEmitter *particleEmitter;
@property (nonatomic, strong) UIImage *imgSnapshotCardValidation;
@property (nonatomic, assign) BOOL blockUserInteraction;
//
@property (nonatomic, strong) AVAudioPlayer *goodSoundPlayer;
@property (nonatomic, strong) AVAudioPlayer *badSoundPlayer;
//
@property (nonatomic, strong) NSArray *framesHelp;

@end

#pragma mark - • IMPLEMENTATION
@implementation PromotionalCardScratchVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize promotionalCard, framesHelp;
@synthesize imvWallpaper, viewContainer, viewScratch, imvBackground, txvCardInfo;
@synthesize premiumItem, scratchyItem, resultProgress, particleEmitter, imgSnapshotCardValidation, blockUserInteraction, goodSoundPlayer, badSoundPlayer;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    blockUserInteraction = NO;
    resultProgress = 0.0;
    
    NSURL *urlG = [[NSBundle mainBundle] URLForResource:@"promotionalcard-good-result" withExtension:@"mp3"];
    goodSoundPlayer = [SoundManager playerForResource:urlG];
    NSURL *urlB = [[NSBundle mainBundle] URLForResource:@"promotionalcard-bad-result" withExtension:@"mp3"];
    badSoundPlayer = [SoundManager playerForResource:urlB];
    
    framesHelp = [[NSArray alloc] initWithObjects:
                  [UIImage imageNamed:@"promotional_card_frame_01.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_01.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_01.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_01.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_01.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_02.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_03.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_04.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_05.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_06.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_07.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_08.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_09.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_10.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_11.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_12.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_13.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_14.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_15.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_16.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_17.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_18.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_19.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_20.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_21.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_22.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_23.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_24.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_25.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_26.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_27.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_27.jpg"],
                  [UIImage imageNamed:@"promotional_card_frame_27.jpg"],
                nil];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") style:UIBarButtonItemStylePlain target:self action:@selector(actionBackButton:)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    [self setupScratchView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self finalizeEmitter];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    //
    [self.navigationController.navigationBar setTintColor:AppD.styleManager.colorPalette.textNormal];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionHelp:(id)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultRichAlert:@"Passe o dedo sobre a raspadinha até descobrir a área de interesse. Continue a limpar a imagem até que o resultado seja exibido.\nBoa sorte!\n" images:framesHelp animationTimePerFrame:0.15];
    [alert showInfo:@"Ajuda" subTitle:nil closeButtonTitle:@"OK" duration:0.0];
}

- (void)actionTheEndTap:(UITapGestureRecognizer*)gesture
{
    [self.view removeGestureRecognizer:gesture];
    
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    if (promotionalCard.promotionalLink != nil && ![promotionalCard.promotionalLink isEqualToString:@""]){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:promotionalCard.promotionalLink]]) {
            [alert addButton:@"Saiba Mais" withType:SCLAlertButtonType_Normal actionBlock:^{
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:promotionalCard.promotionalLink]];
                [self syncronizeCardStatus];
            }];
        }else{
            [self syncronizeCardStatus];
        }
    }
    [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:^{
        [self syncronizeCardStatus];
    }];
    //
    UIImage *icon = [UIImage imageNamed:@"gold-coin.png"];
    if (promotionalCard.imgParticleObject != nil){
        icon = promotionalCard.imgParticleObject;
    }
    //
    [alert showCustom:icon color:AppD.styleManager.colorPalette.backgroundNormal title:@"Parabéns!" subTitle:promotionalCard.promotionalMessage closeButtonTitle:nil duration:0.0];
}

- (void)actionBackButton:(id)sender
{
    if (resultProgress > 0.0 &&  resultProgress < promotionalCard.coverLimit) {
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CANCEL", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        [alert showError:NSLocalizedString(@"ALERT_TITLE_NO_APP", @"") subTitle:@"Você ainda não finalizou a raspadinha. Continue 'raspando' até o resultado ser revelado!" closeButtonTitle:nil duration:0.0];
    }else if (resultProgress == 0.0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - MDScratchImageViewDelegate

- (void)mdScratchImageView:(MDScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress
{
    resultProgress = maskingProgress;
    
    //Buscando o momento de exibir o resultado:
    if (!blockUserInteraction){
        //Somente o progresso da view prêmio precisa ser analisado (tag==0)
        if (scratchImageView.tag == 0){
            
            NSLog(@">>>>>> maskingProgress: %f", maskingProgress);
            
            //Quando o usuário chegar no percentual definido considera-se que a raspadinha foi 'descoberta'.
            if (maskingProgress >= promotionalCard.coverLimit){
                
                blockUserInteraction = YES;
                [viewContainer setUserInteractionEnabled:NO];
                [self.navigationItem setHidesBackButton:YES];
                [self.navigationItem setRightBarButtonItem:nil animated:YES];
                [self.navigationItem setLeftBarButtonItem:nil animated:YES];
                
                premiumItem.scrathView.alpha = 0.0;
                
                [UIView animateWithDuration:ANIMA_TIME_SLOW animations:^{
                    scratchyItem.scrathView.alpha = 0.0;
                } completion:^(BOOL finished) {
                                        
                    if (promotionalCard.isPremium){
                        
                        [AppD.devLogger newLogEvent:@"WIN!" category:@"CardScratch-Open" dicData:[NSDictionary new]];
                        //
                        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveLinear animations:^{
                            premiumItem.backImageView.transform = CGAffineTransformScale(premiumItem.backImageView.transform, 1.4, 1.4);
                        } completion:^(BOOL finished) {
                            
                            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveLinear animations:^{
                                premiumItem.backImageView.transform = CGAffineTransformIdentity;
                            } completion:nil];
                        }];
                        //
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [UIView transitionWithView:premiumItem.backImageView
                                              duration:0.49f
                                               options:UIViewAnimationOptionTransitionFlipFromLeft|UIViewAnimationOptionAllowAnimatedContent
                                            animations:^{
                                                premiumItem.backImageView.image = promotionalCard.imgPrizeWon;
                                            }
                                            completion:^(BOOL finished) {
                                                
                                                CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                                                scaleAnimation2.fromValue = @(1.0);
                                                scaleAnimation2.toValue = @(1.05);
                                                scaleAnimation2.duration = 0.15;
                                                scaleAnimation2.autoreverses = YES;
                                                scaleAnimation2.repeatCount = HUGE_VALF;
                                                scaleAnimation2.fillMode = kCAFillModeBoth;
                                                scaleAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                                [premiumItem.backImageView.layer addAnimation:scaleAnimation2 forKey:@"RaspeScaleAnimation2"];
                                                
                                                [self snapshotScreen];
                                                [self startEmitter];
                                            }];
                        });
                        
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTheEndTap:)];
                        [tap setNumberOfTapsRequired:1];
                        [tap setNumberOfTouchesRequired:1];
                        [self.view addGestureRecognizer:tap];
                        
                        [goodSoundPlayer play];
                        
                    }else{
                        
                        [AppD.devLogger newLogEvent:@"LOSE!" category:@"CardScratch-Open" dicData:[NSDictionary new]];
                        
                        premiumItem.backImageView.transform = CGAffineTransformIdentity;
                        
                        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveLinear animations:^{
                            premiumItem.backImageView.transform = CGAffineTransformScale(premiumItem.backImageView.transform, 1.4, 1.4);
                        } completion:^(BOOL finished) {
                            
                            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveLinear animations:^{
                                premiumItem.backImageView.transform = CGAffineTransformIdentity;
                            } completion:nil];
                        }];
                        //
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [UIView transitionWithView:premiumItem.backImageView
                                              duration:0.49f
                                               options:UIViewAnimationOptionTransitionFlipFromLeft|UIViewAnimationOptionAllowAnimatedContent
                                            animations:^{
                                                premiumItem.backImageView.image = promotionalCard.imgPrizeLose;
                                            }
                                            completion:^(BOOL finished) {
                                                 [self snapshotScreen];
                                            }];
                        });
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.52 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [badSoundPlayer play];
                            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                            [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
                                [self syncronizeCardStatus];
                            }];
                            [alert showError:@"Ops!" subTitle:@"Não foi dessa vez. Assim que você tiver uma outra raspadinha disponível tente novamente!" closeButtonTitle:nil duration:0.0];
                            //[alert showCustom:[ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:[SCLAlertViewStyleKit imageOfInfo]] color:AppD.styleManager.colorPalette.backgroundNormal title:@"Ops!" subTitle:@"Não foi dessa vez. Assim que você tiver uma outra raspadinha disponível tente novamente!" closeButtonTitle:nil duration:0.0];
                            
                        });
                    }
                    
                }];
            }
        }else{
            NSLog(@">>>>>> maskingProgress Pai: %f", maskingProgress);
        }
    }
}

- (void)mdScratchImageViewTouchesBegan:(MDScratchImageView *)scratchImageView touches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //O processo de raspar na view prêmio não ocorre diretamente. Isso permite a análise independente de progresso.
    if (scratchyItem.scrathView == scratchImageView){
        [premiumItem.scrathView processTouches:touches];
    }
}

- (void)mdScratchImageViewTouchesMoved:(MDScratchImageView *)scratchImageView touches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //O processo de raspar na view prêmio não ocorre diretamente. Isso permite a análise independente de progresso.
    if (scratchyItem.scrathView == scratchImageView){
        [premiumItem.scrathView processTouches:touches];
    }
}

- (void)mdScratchImageViewTouchesEnded:(MDScratchImageView *)scratchImageView touches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //O processo de raspar na view prêmio não ocorre diretamente. Isso permite a análise independente de progresso.
    if (scratchyItem.scrathView == scratchImageView){
        [premiumItem.scrathView processTouches:touches];
    }
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [ToolBox graphicHelper_colorWithHexString:promotionalCard.colorBackground];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:[ToolBox graphicHelper_colorWithHexString:promotionalCard.colorDetail]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:[ToolBox graphicHelper_colorWithHexString:promotionalCard.colorDetail]]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[ToolBox graphicHelper_colorWithHexString:promotionalCard.colorText], NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];

    self.navigationItem.title = promotionalCard.titleScreen;
    
    [self.navigationController.navigationBar setTintColor:[ToolBox graphicHelper_colorWithHexString:promotionalCard.colorText]];

    
    imvWallpaper.backgroundColor = nil;
    imvWallpaper.image = promotionalCard.imgWallpaperScreen;
    
    viewContainer.backgroundColor = nil;
    //
    viewScratch.backgroundColor = nil;
    viewScratch.layer.borderWidth = 3;
    viewScratch.layer.borderColor = [ToolBox graphicHelper_colorWithHexString:promotionalCard.colorDetail].CGColor;
    viewScratch.layer.cornerRadius = 10;
    //
    imvBackground.backgroundColor = nil;
    imvBackground.image = promotionalCard.imgBackgroundCard;
    //
    txvCardInfo.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [txvCardInfo setTextContainerInset:UIEdgeInsetsMake(30.0, 20.0, 20.0, 20.0)];
    txvCardInfo.text = @"";
    
    viewContainer.alpha = 0.0;
}

- (void)setupScratchView
{
    //Scratch Configuration ****************************************************************
    
    //Tamanho:
    CGFloat rectSize = 0.0;
    switch (promotionalCard.preferedSize) {
        case PromotionalCardSizeSmall:{rectSize = viewScratch.frame.size.width * 0.25;}break;
        case PromotionalCardSizeNormal:{rectSize = viewScratch.frame.size.width * 0.40;}break;
        case PromotionalCardSizeLarge:{rectSize = viewScratch.frame.size.width * 0.55;}break;
            //
        default:{rectSize = 90.0;}break;
    }
    
    //Posição:
    CGFloat positionX = 0.0;
    CGFloat positionY = 0.0;
    if (promotionalCard.preferedPosition == PromotionalCardPositionRandom){
        positionX = RandomPositiveNumber(10.0, (viewScratch.frame.size.width - (rectSize + 10.0)));
        positionY = RandomPositiveNumber(10.0, (viewScratch.frame.size.height - (rectSize + 10.0)));
    }else{
        positionX = (viewScratch.frame.size.width - rectSize) / 2.0;
        positionY = (viewScratch.frame.size.height - rectSize) / 2.0;
    }
    
    //Criação dos retângulos para os componentes:
    CGRect rectPremium = CGRectMake(positionX, positionY, rectSize, rectSize);
    CGRect rectScratch = CGRectMake(0.0, 0.0, viewScratch.frame.size.width, viewScratch.frame.size.height);
    
    //Scratch Image para o componente resultado ****************************************************************
    CGFloat width = rectPremium.size.width * (promotionalCard.imgCoverCard.size.width / rectScratch.size.width);
    CGFloat height = rectPremium.size.height * (promotionalCard.imgCoverCard.size.height / rectScratch.size.height);
    UIImage *premiumCover = [ToolBox graphicHelper_ResizeImage:promotionalCard.imgCoverCard toSize:CGSizeMake(width, height)];
    
    //Criação das views que efetivamente serão 'raspadas' ****************************************************************
    UIImage *imgResult = promotionalCard.imgPrizePending;
//    if (showResult){ //aqui depende se existirá animação ou não
//        if (promotionalCard.isPremium){
//            imgResult = promotionalCard.imgPrizeWon;
//        }else{
//            imgResult = promotionalCard.imgPrizeLose;
//        }
//    }
    //
    premiumItem = [ScrathItem newItemWithRect:rectPremium imageItem:imgResult imageTexture:premiumCover lineThickness:promotionalCard.lineWidth premium:false delegate:self order:0];
    [premiumItem.scrathView setExternalUIResponder:true];
    scratchyItem = [ScrathItem newItemWithRect:rectScratch imageItem:nil  imageTexture:promotionalCard.imgCoverCard lineThickness:promotionalCard.lineWidth premium:false delegate:self order:1];
    
    //Organização do componente ****************************************************************
    [viewScratch addSubview:premiumItem.backImageView];
    [viewScratch addSubview:premiumItem.scrathView];
    [viewScratch addSubview:scratchyItem.scrathView];
    [viewScratch bringSubviewToFront:premiumItem.backImageView];
    [viewScratch bringSubviewToFront:premiumItem.scrathView];
    [viewScratch bringSubviewToFront:scratchyItem.scrathView];
    
    //Card Data:
    
    if ([ToolBox textHelper_CheckRelevantContentInString:promotionalCard.info]){
        [txvCardInfo setHidden:NO];
        
        NSMutableString *strData = [NSMutableString new];
        //    [strData appendString:@"--- DADOS IMPORTANTES ---"];
        //    [strData appendString:[NSString stringWithFormat:@"\nCódigo desta Raspadinha: %li", promotionalCard.cardID]];
        //    [strData appendString:[NSString stringWithFormat:@"\nCódigo do Carnê: %@", referenceCard.skuCode]];
        //    [strData appendString:[NSString stringWithFormat:@"\nCódigo do Pagamento: %@", referenceCard.paymentCode]];
        //    [strData appendString:[NSString stringWithFormat:@"\nData: %@", ]];
        //    [strData appendString:[NSString stringWithFormat:@"\nLote: %li", referenceCard.batchID]];
        //
        [strData appendString:promotionalCard.info];
        //
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strData];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:15.0] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
        //
        [txvCardInfo setAttributedText:attributedString];
    }else{
        [txvCardInfo setHidden:YES];
    }
    
    self.navigationItem.rightBarButtonItem = [self createHelpButton];
    
    [UIView animateWithDuration:ANIMA_TIME_NORMAL animations:^{
        viewContainer.alpha = 1.0;
    }];
    
}

- (UIBarButtonItem*)createHelpButton
{
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    UIImage *img = [[UIImage imageNamed:@"NavControllerHelpIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    [userButton setFrame:CGRectMake(0, 0, 32, 32)];
    [userButton setClipsToBounds:YES];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:[ToolBox graphicHelper_colorWithHexString:promotionalCard.colorText]];
    [userButton addTarget:self action:@selector(actionHelp:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}

#pragma mark - Particles Animation

- (void)startEmitter
{
    particleEmitter = [GameParticleEmitter new];
    //
    if (promotionalCard.imgParticleObject != nil){
        [particleEmitter setTextureImage:promotionalCard.imgParticleObject];
    }
    //
    [particleEmitter addParticleEmitterToView:self.view];
}

- (void)finalizeEmitter
{
    [particleEmitter finalizeEmitter];
    particleEmitter = nil;
}

- (void)pauseEmitter
{
    [particleEmitter pauseEmitterAnimation];
}

- (void)continueEmitter
{
    [particleEmitter continueEmitterAnimation];
}

#pragma mark - Connections

//- (void)getCardDetail
//{
//    PaymentAndSalesDataSource *ds = [PaymentAndSalesDataSource new];
//
//    [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
//
//    [ds getPaymentCardDetail:(int)referenceCard.cardID withCompletionHandler:^(PaymentCard * _Nullable card, DataSourceResponse * _Nonnull response) {
//
//        if (response.status == DataSourceResponseStatusSuccess){
//            referenceCard = card;
//            [self getNecessaryCardImages];
//        }else{
//            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
//            [alert showError:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:response.message closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
//            //
//            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
//        }
//    }];
//}

//-(void)getNecessaryCardImages
//{
//    //Verifica se existe uma url para busca da imagem de resultado (seja premiada ou não)
//    if ([ToolBox textHelper_CheckRelevantContentInString:referenceCard.urlPrizeImage]){
//
//        //Prize Image:
//        [[[AsyncImageDownloader alloc] initWithFileURL:referenceCard.urlPrizeImage successBlock:^(NSData *data) {
//            referenceCard.imgPrize = [UIImage imageWithData:data];
//
//            //Cover Image:
//            [[[AsyncImageDownloader alloc] initWithFileURL:referenceCard.urlCoverScratchImage successBlock:^(NSData *data) {
//                //usa imagem de textura personalizada:
//                referenceCard.imgCoverScratch = [UIImage imageWithData:data];
//                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
//                [self setupScratchView];
//            } failBlock:^(NSError *error) {
//                //permite continuar mas com a imagem de textura padrão:
//                referenceCard.imgCoverScratch = [UIImage imageNamed:@"scratch-card-texture.png"];
//                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
//                [self setupScratchView];
//            }] startDownload];
//
//        } failBlock:^(NSError *error) {
//            [self showErrorForNecessaryData];
//        }] startDownload];
//
//    }else{
//        [self showErrorForNecessaryData];
//    }
//}

- (void)syncronizeCardStatus
{
    [self.navigationController popViewControllerAnimated:YES];
    
//    PaymentAndSalesDataSource *ds = [PaymentAndSalesDataSource new];
//
//    [AppD showLoadingAnimationWithType:eActivityIndicatorType_Processing];
//
//    //NOTE: ericogt >> A imagem recibo passou a ser otimizada antes do envio.
//    //NSString *base64Card = [ToolBox graphicHelper_EncodeToBase64String:imgSnapshotCardValidation];
//    
//    UIImage *reducedImage = [ToolBox graphicHelper_ResizeImage:imgSnapshotCardValidation toSize:CGSizeMake(405.0, 720.0)];
//    NSString *base64Card = [self encodeImageToBase64String:reducedImage usingCompressionQuality:0.7];
//
//    [ds putPaymentCardReceipt:(int)referenceCard.cardID image:base64Card withCompletionHandler:^(DataSourceResponse * _Nonnull response) {
//
//        if (response.status == DataSourceResponseStatusSuccess){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:SYSNOT_PAYMENT_BOOK_CARD_UPDATED object:[referenceCard copyObject] userInfo:nil];
//            });
//            //
//            if (openedByNotification){
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
//            }
//
//        }else{
//            SCLAlertViewPlus *alert = [AppD createDefaultAlert];
//            [alert addButton:NSLocalizedString(@"ALERT_OPTION_OK", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
//                if (openedByNotification){
//                    [self.navigationController popViewControllerAnimated:YES];
//                }else{
//                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
//                }
//
//            }];
//            [alert showError:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:@"Não foi possível sincronizar o resultado da raspadinha no momento.\nVocê precisará tentar novamente mais tarde." closeButtonTitle:nil duration:0.0];
//        }
//
//        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
//
//    }];
}

- (void)showErrorForNecessaryData
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showError:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:@"Não foi possível resgatar todos os dados necessários para utilizar seu 'Raspe Raspe Baú'. Por favor, tente novamente mais tarde!" closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    //
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
}

#pragma mark - Processing Images

- (void)snapshotScreen
{
    UIImage *screenImage = [self printScaledLayerImage:self.view.layer];
    
    CGFloat maxWidth = 500.0;
    CGFloat maxHeight = 820.0;
    CGFloat maxRatio = maxWidth / maxHeight;
    
    CGFloat imgRatio = screenImage.size.width / screenImage.size.height;
    
    CGFloat finalWidth = 0.0;
    CGFloat finalHeight = 0.0;
    
    if (screenImage.size.width > maxWidth || screenImage.size.height > maxHeight){
        if (imgRatio < maxRatio){
            //snapshot precisa de nova largura:
            finalHeight = maxHeight;
            finalWidth = finalHeight * imgRatio;
        }else{
            //snapshot precisa de nova altura:
            finalWidth = maxWidth;
            finalHeight = finalWidth / imgRatio;
        }
    }else{
        finalWidth = screenImage.size.width;
        finalHeight = screenImage.size.height;
    }
    
    UIImage *finalScreenImage = [ToolBox graphicHelper_ResizeImage:screenImage toSize:CGSizeMake(finalWidth, finalHeight)];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"scratch-card-receipt-background"];
    
    CGFloat marginX = (maxWidth - finalScreenImage.size.width) / 2.0 + 20.0;
    CGFloat marginY = (maxHeight - finalScreenImage.size.height) / 2.0 + 20.0;
    UIImage *mergedImages = [ToolBox graphicHelper_MergeImage:backgroundImage withImage:finalScreenImage position:CGPointMake(marginX, marginY) blendMode:kCGBlendModeNormal alpha:1.0 scale:1.0];
    
    //Desenhando o texto "log"
    NSMutableString *strLog = [NSMutableString new];
    [strLog appendString:@"RASPE RASPE BAÚ - COMPROVANTE RESULTADO"];
    [strLog appendString:[NSString stringWithFormat:@"\nDISPOSITIVO: %@ (iOS %@)", [ToolBox deviceHelper_Model], [ToolBox deviceHelper_SystemVersion]]];
    [strLog appendString:[NSString stringWithFormat:@"\nVERSÃO APP: %@", [ToolBox applicationHelper_VersionBundle]]];
    [strLog appendString:[NSString stringWithFormat:@"\nDATA LOCAL: %@", [ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_HIFEN_COMPLETA_INVERTIDA]]];
    [strLog appendString:[NSString stringWithFormat:@"\nUSUÁRIO: [%i] %@", AppD.loggedUser.userID, AppD.loggedUser.name]];
    
    UIFont *font = [UIFont fontWithName:FONT_FAKE_RECEIPT size:15.0];
    UIGraphicsBeginImageContext(mergedImages.size);
    [mergedImages drawInRect:CGRectMake(0.0, 0.0, mergedImages.size.width, mergedImages.size.height)];
    CGRect rect = CGRectMake(20.0, 852.0, 500.0, 100.0);
    [[UIColor darkTextColor] set];
    NSDictionary *attributes =[[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName, nil];
    [strLog drawInRect:CGRectIntegral(rect) withAttributes:attributes];
    imgSnapshotCardValidation = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (UIImage*) printScaledLayerImage:(CALayer*)layer
{
    if (layer != nil){
        //Captura a imagem do layer
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.opaque, 0);
        [layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //Escala conforme a tela
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGSize size = CGSizeMake(layer.bounds.size.width * scale, layer.bounds.size.height * scale);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //
        return newImage;
    }
    return nil;
}

- (UIImage*) createFlatImageWithSize:(CGSize)size andColor:(UIColor*)color
{
    UIBezierPath* rect =  [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)]; //[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:corners cornerRadii:radius];
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [color setFill];
    [rect fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSString *) encodeImageToBase64String:(UIImage *)image usingCompressionQuality:(CGFloat)iQuality
{
    if (image != nil){
        return [UIImageJPEGRepresentation(image, iQuality) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    else{
        return nil;
    }
}

@end
