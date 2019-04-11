//
//  PromotionalCardMainVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 25/04/18.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "PromotionalCardMainVC.h"
#import "PromotionalCardScratchVC.h"
#import "PromotionalCard.h"
#import "AsyncImageDownloader.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface PromotionalCardMainVC()

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UITextField *txtCode;
@property (nonatomic, weak) IBOutlet UIButton *btnSubmit;
//
@property (nonatomic, strong) PromotionalCard *currentCard;
@property (nonatomic, strong) NSMutableDictionary *cardCache;
//
@property (nonatomic, assign) BOOL isLoaded;

@end

#pragma mark - • IMPLEMENTATION
@implementation PromotionalCardMainVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize lblTitle, txtCode, btnSubmit;
@synthesize currentCard, cardCache, isLoaded;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentCard = nil;
    cardCache = [NSMutableDictionary new];
    isLoaded = NO;
    //
    self.navigationItem.rightBarButtonItem = [self createHelpButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self.view layoutIfNeeded];
        [self setupLayout:@"Raspadinha Promocional"];
        isLoaded = YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([segue.identifier isEqualToString:@"SegueToCardScratch"]){
        PromotionalCardScratchVC *vc = segue.destinationViewController;
        vc.promotionalCard = [currentCard copyObject];
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionVerifyCode:(id)sender
{
    [self.view endEditing:YES];
    
    if ([ToolBox textHelper_CheckRelevantContentInString:txtCode.text]){
        PromotionalCard *card = [cardCache objectForKey:txtCode.text];
        if (card){
            [self processPromotionalCard:card];
        }else{
            [self getDataForPromotionalCode:txtCode.text];
        }
    }
}

- (IBAction)actionHelp:(id)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showInfo:@"Ajuda" subTitle:@"As promoções válidas no momento são:\n\n lab360 \n atlantic \n adalive\n" closeButtonTitle:@"OK" duration:0.0];

}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    lblTitle.backgroundColor = nil;
    lblTitle.textColor = [UIColor darkTextColor];
    [lblTitle setFont:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:16.0]];
    [lblTitle setText:@"Para interagir com a Raspadinha insira o código promocional relacionado. Todas as configurações de interação e visualização devem ser inseridas ambiente Amazon S3, pasta adalive/downloads/lab360/promotionalcards."];
    
    btnSubmit.backgroundColor = [UIColor clearColor];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [btnSubmit setTitle:@"VERIFICAR CÓDIGO" forState:UIControlStateNormal];
    [btnSubmit setExclusiveTouch:YES];
    [btnSubmit setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSubmit.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSubmit.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    UIImage *iconCreate = [ToolBox graphicHelper_ImageWithTintColor:[UIColor whiteColor] andImageTemplate:[UIImage imageNamed:@"RotationalZoomButton"]];
    [btnSubmit setImage:iconCreate forState:UIControlStateNormal];
    [btnSubmit setImageEdgeInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 10.0)];
    [btnSubmit.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnSubmit setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    [btnSubmit setTintColor:[UIColor whiteColor]];
    btnSubmit.tag = 1;
    
    txtCode.text = @"";
}

- (void)processPromotionalCard:(PromotionalCard*)card
{
    //Verificando carregamento de imagens:
    currentCard = card;
    
    if (currentCard.imgPrizeWon){
        //Se a raspadinha possui uma imagem, então possui todas, pois o carregamento das mesmas é atômico.
        [self openCurrentCard];
    }else{
        
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Downloading];
        });
        
        [self fetchDownloadImagesWithCompletion:^(NSError *error) {
            if (error){
                currentCard = nil;
                //
                [self showErrorMessageWithDetail:[error localizedDescription]];
            }else{
                [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
                [self openCurrentCard];
            }
        }];
    }
}

- (void)openCurrentCard
{
    //Guardando a raspadinha para busca futura:
    NSArray *allKeys = [cardCache allKeys];
    if (![allKeys containsObject:currentCard.code]){
        [cardCache setValue:[currentCard copyObject] forKey:currentCard.code];
    }
    
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert addButton:@"Premiada" withType:SCLAlertButtonType_Normal actionBlock:^{
        currentCard.isPremium = YES;
        [self performSegueWithIdentifier:@"SegueToCardScratch" sender:self];
    }];
    [alert addButton:@"Não premiada" withType:SCLAlertButtonType_Destructive actionBlock:^{
        currentCard.isPremium = NO;
        [self performSegueWithIdentifier:@"SegueToCardScratch" sender:self];
    }];
    [alert showInfo:@"Resultado" subTitle:@"Você deseja simular uma raspadinha premiada ou não?\n\nAmbas as opções não irão consumir a raspadinha definitivamente após o uso." closeButtonTitle:nil duration:0.0];
}

#pragma mark - Connections

- (void)getDataForPromotionalCode:(NSString*)code
{
    //TODO:modifique aqui a forma de aquisição dos dados (endpoint adalive, por exemplo)
    
    NSURL *cardDataURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/promotionalcards/card_%@/carddata.xml", code]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:cardDataURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];

    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration]; //backgroundSessionConfigurationWithIdentifier:@"br.com.lab360.download.task"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });
    
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error){
            [self showErrorMessageWithDetail:[error localizedDescription]];
        }else{
            NSPropertyListFormat format;
            NSError *errorStr = nil;
            NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:&format error:&errorStr];
            //
            if (errorStr){
                [self showErrorMessageWithDetail:[errorStr localizedDescription]];
            }else{
                if (dictionary){
                    PromotionalCard *card = [PromotionalCard createObjectFromDictionary:dictionary];
                    if (card.cardID != 0){
                        [self processPromotionalCard:card];
                    }else{
                        [self showErrorMessageWithDetail:@"Nenhum conteúdo válido encontrado."];
                    }
                }else{
                    [self showErrorMessageWithDetail:@"Nenhum conteúdo encontrado."];
                }
            }
        }
    }] resume];
}

-(void)fetchDownloadImagesWithCompletion:(void (^)(NSError* error))completion
{
    __block NSError *genericError = nil;
    
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    // IMAGE 1 =============================================================================================================
    dispatch_group_enter(serviceGroup);
    [[[AsyncImageDownloader alloc] initWithFileURL:currentCard.urlPrizeWon successBlock:^(NSData *data) {
        if (data != nil){
            currentCard.imgPrizeWon = [UIImage imageWithData:data];
        }else{
            genericError = [NSError errorWithDomain:@"br.com.lab360.download.images.error" code:0 userInfo:nil];
        }
        dispatch_group_leave(serviceGroup);
    } failBlock:^(NSError *error) {
        genericError = error;
        dispatch_group_leave(serviceGroup);
    }] startDownload];
    
    // IMAGE 2 =============================================================================================================
    dispatch_group_enter(serviceGroup);
    [[[AsyncImageDownloader alloc] initWithFileURL:currentCard.urlPrizeLose successBlock:^(NSData *data) {
        if (data != nil){
            currentCard.imgPrizeLose = [UIImage imageWithData:data];
        }else{
            genericError = [NSError errorWithDomain:@"br.com.lab360.download.images.error" code:0 userInfo:nil];
        }
        dispatch_group_leave(serviceGroup);
    } failBlock:^(NSError *error) {
        genericError = error;
        dispatch_group_leave(serviceGroup);
    }] startDownload];
    
    // IMAGE 3 =============================================================================================================
    dispatch_group_enter(serviceGroup);
    [[[AsyncImageDownloader alloc] initWithFileURL:currentCard.urlPrizePending successBlock:^(NSData *data) {
        if (data != nil){
            currentCard.imgPrizePending = [UIImage imageWithData:data];
        }else{
            genericError = [NSError errorWithDomain:@"br.com.lab360.download.images.error" code:0 userInfo:nil];
        }
        dispatch_group_leave(serviceGroup);
    } failBlock:^(NSError *error) {
        genericError = error;
        dispatch_group_leave(serviceGroup);
    }] startDownload];
    
    // IMAGE 4 =============================================================================================================
    dispatch_group_enter(serviceGroup);
    [[[AsyncImageDownloader alloc] initWithFileURL:currentCard.urlCoverCard successBlock:^(NSData *data) {
        if (data != nil){
            currentCard.imgCoverCard = [UIImage imageWithData:data];
        }else{
            genericError = [NSError errorWithDomain:@"br.com.lab360.download.images.error" code:0 userInfo:nil];
        }
        dispatch_group_leave(serviceGroup);
    } failBlock:^(NSError *error) {
        genericError = error;
        dispatch_group_leave(serviceGroup);
    }] startDownload];
    
    // IMAGE 5 =============================================================================================================
    dispatch_group_enter(serviceGroup);
    [[[AsyncImageDownloader alloc] initWithFileURL:currentCard.urlBackgroundCard successBlock:^(NSData *data) {
        if (data != nil){
            currentCard.imgBackgroundCard = [UIImage imageWithData:data];
        }else{
            genericError = [NSError errorWithDomain:@"br.com.lab360.download.images.error" code:0 userInfo:nil];
        }
        dispatch_group_leave(serviceGroup);
    } failBlock:^(NSError *error) {
        genericError = error;
        dispatch_group_leave(serviceGroup);
    }] startDownload];
    
    // IMAGE 6 =============================================================================================================
    //Imagem Opcional (não gera excessão caso não carregue):
    dispatch_group_enter(serviceGroup);
    [[[AsyncImageDownloader alloc] initWithFileURL:currentCard.urlWallpaperScreen successBlock:^(NSData *data) {
        if (data != nil){
            currentCard.imgWallpaperScreen = [UIImage imageWithData:data];
        }
        dispatch_group_leave(serviceGroup);
    } failBlock:^(NSError *error) {
        dispatch_group_leave(serviceGroup);
    }] startDownload];
    
    // IMAGE 7 =============================================================================================================
    //Imagem Opcional (não gera excessão caso não carregue):
    dispatch_group_enter(serviceGroup);
    [[[AsyncImageDownloader alloc] initWithFileURL:currentCard.urlParticleObject successBlock:^(NSData *data) {
        if (data != nil){
            currentCard.imgParticleObject = [UIImage imageWithData:data];
        }
        dispatch_group_leave(serviceGroup);
    } failBlock:^(NSError *error) {
        dispatch_group_leave(serviceGroup);
    }] startDownload];
    
    // FINAL =============================================================================================================
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(),^{
        completion(genericError);
    });
}

- (void)showErrorMessageWithDetail:(NSString*)messageDetail
{
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
    //
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showError:@"Erro" subTitle:@"O código promocional inserido não existe ou os recursos necessários para a raspadinha não estão todos disponíveis no momento.\nPor favor, tente mais tarde ou insira um novo código." closeButtonTitle:@"OK" duration:0.0];
    //
    NSLog(@"showErrorMessageWithDetail: %@", messageDetail);
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
    [userButton setTintColor:AppD.styleManager.colorPalette.primaryButtonTitleNormal];
    [userButton addTarget:self action:@selector(actionHelp:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    return [[UIBarButtonItem alloc] initWithCustomView:userButton];
}

@end
