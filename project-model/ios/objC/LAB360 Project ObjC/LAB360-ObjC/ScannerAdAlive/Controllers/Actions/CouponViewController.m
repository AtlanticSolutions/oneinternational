//
//  CouponViewController.m
//  AdAlive
//
//  Created by Lab360 on 1/12/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import "CouponViewController.h"
#import "VIPhotoView.h"

@interface CouponViewController()<VIPhotoViewDelegate>

//Data
@property(nonatomic, strong) NSString *termsOfUse;
@property(nonatomic, strong) UIImage *qrcodeImage;

//Layout
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbCouponCode;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lbEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lbDescName;
@property (weak, nonatomic) IBOutlet UILabel *lbDescCode;
@property (weak, nonatomic) IBOutlet UILabel *lbDescEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbValue;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
//
@property (weak, nonatomic) IBOutlet UIImageView *imvBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblApp;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

//@property (weak, nonatomic) IBOutlet UILabel *lbTermsOfUse;
//@property (weak, nonatomic) IBOutlet UIView *couponView;
//@property (weak, nonatomic) IBOutlet UIView *couponPrintView;

@end

@implementation CouponViewController

@synthesize imvBackground, lblApp, lblVersion;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.termsOfUse = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    [self loadComponentsValues];
    
    NSMutableDictionary *dicQRCode = [NSMutableDictionary new];
    NSArray *dicKeys = [self.couponData allKeys];
    
    //Hash de segurança (ignora outros QRCodes que o usuário tente escanear com o aplicativo)
    [dicQRCode setValue:kSecureCouponHashValue forKey:kSecureCouponHashKey];
    
    //Identificador do cupom
    //if ([dicKeys containsObject:kCouponIDKey]){
    //    [dicQRCode setValue:[self.couponData objectForKey:kCouponIDKey] forKey:kCouponIDKey];
    //}else{
    //    [dicQRCode setValue:@(0) forKey:kCouponIDKey];
    //}
    //
    if ([dicKeys containsObject:kCouponCodeKey]){
        [dicQRCode setValue:[self.couponData objectForKey:kCouponCodeKey] forKey:kCouponCodeKey];
    }else{
        [dicQRCode setValue:@"" forKey:kCouponCodeKey];
    }
    
    //Usuário (criador do QRCode)
    [dicQRCode setValue:@(AppD.loggedUser.userID) forKey:kCouponConsumerIDKey];
    //
    [dicQRCode setValue:AppD.loggedUser.name forKey:kCouponConsumerNameKey];
    //
    [dicQRCode setValue:AppD.loggedUser.email forKey:kCouponConsumerEmailKey];
    
    //Identificador do aplicativo
    [dicQRCode setValue:[NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)] forKey:kCouponOriginAppID];
    
    //identificador da promoção
    [dicQRCode setValue:self.promotionId forKey:kCouponPromotionIDKey];
    //
    [dicQRCode setValue:self.promotionName forKey:kCouponPromotionNameKey];
    
    //tipo de promoção
    if ([dicKeys containsObject:kCouponDiscountTypeKey]){
        NSString *type = [self.couponData objectForKey:kCouponDiscountTypeKey];
        if ([ToolBox textHelper_CheckRelevantContentInString:type]){
            [dicQRCode setValue:[self.couponData objectForKey:kCouponDiscountTypeKey] forKey:kCouponDiscountTypeKey];
        }else{
            [dicQRCode setValue:self.promotionType forKey:kCouponDiscountTypeKey];
        }
    }else{
        [dicQRCode setValue:self.promotionType forKey:kCouponDiscountTypeKey];
    }
    
    //valor da promoção
    if ([dicKeys containsObject:kCouponDiscountValueKey]){
        [dicQRCode setValue:[self.couponData objectForKey:kCouponDiscountValueKey] forKey:kCouponDiscountValueKey];
    }else{
        [dicQRCode setValue:@(0) forKey:kCouponDiscountValueKey];
    }
     
    //Criando o QRCode
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicQRCode options:0 error:nil];
    NSString *qrCodeString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    CIImage *image = [self createQRForString:qrCodeString];
    
    self.qrcodeImage = [UIImage imageWithCIImage:image];
    
    self.qrCodeImageView.image = self.qrcodeImage;
    
    self.imvBackground.image = [self compositeBackgroundForCoupon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

-(void)loadComponentsValues
{
    [self.indicator startAnimating];
    [self downloadImageWithURL:[NSURL URLWithString:[self.couponData objectForKey:@"logo_url"]] completionBlock:^(BOOL succeeded, UIImage *image)
     {
         if (succeeded)
         {
             self.logoImageView.image = image;
             self.logoImageView.backgroundColor = [UIColor clearColor];
         }
         else
         {
             self.logoImageView.image = nil;
             self.logoImageView.backgroundColor = [UIColor lightGrayColor];
         }
         
         [self.indicator stopAnimating];
     }];
    
    self.lbDescName.text = @"Consumidor:";
    self.lbDescEndDate.text = @"Válido até:";
    //
    self.lbTitle.text = [[self.couponData objectForKey:@"title"] isKindOfClass:[NSNull class]]? @"": [self.couponData objectForKey:@"title"];
    self.lbCouponCode.text = [[self.couponData objectForKey:@"coupon_code"] isKindOfClass:[NSNull class]]? @"": [self.couponData objectForKey:@"coupon_code"];
    
    NSString *terms =[self.couponData objectForKey:@"condition_terms"];
    if ([ToolBox textHelper_CheckRelevantContentInString:terms]){
        self.termsOfUse = terms;
        [self createNavigationButtons];
    }
    
    NSString *subTitle = [self.couponData objectForKey:@"subtitle"];
    if ([ToolBox textHelper_CheckRelevantContentInString:subTitle]){
        self.lbSubtitle.text = subTitle;
    }else{
        if ([self.promotionType isEqualToString:kCouponDiscountTypeCredit]){
            self.lbSubtitle.text = @"Voucher de crédito";
            self.lbDescCode.text = @"Código do voucher:";
        }else{
            self.lbSubtitle.text = @"Cupom de desconto";
            self.lbDescCode.text = @"Código do cupom:";
        }
    }
    
    NSString *discount_type = [self.couponData objectForKey:@"discount_type"];
    
    if (discount_type && [discount_type isEqualToString:@"percentage"])
    {
        self.lbValue.text = [NSString stringWithFormat:@"%@%%", [self.couponData objectForKey:@"discount_value"]];
    }
    else if(discount_type)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setLocale:[NSLocale currentLocale]];
        NSNumber *priceValue = [NSNumber numberWithFloat:[[self.couponData objectForKey:@"discount_value"] floatValue]];
        
        self.lbValue.text = [formatter stringFromNumber:priceValue];
    }
    else
    {
        self.lbValue.text = @"-";
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *endDate = [[self.couponData objectForKey:@"end_date"] isKindOfClass:[NSNull class]]? @"": [self.couponData objectForKey:@"end_date"];
    if (![endDate isEqualToString:@""])
    {
        NSDate *date = [df dateFromString:[self.couponData objectForKey:@"end_date"]];
        [df setDateFormat:@"dd/MM/yyyy"];
        NSString *formatedDate = [df stringFromDate:date];
        
        self.lbEndDate.text = formatedDate;
    }
    
    self.lbUserName.text = AppD.loggedUser.name;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapQRCode:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.qrCodeImageView addGestureRecognizer:tapGesture];
    [self.qrCodeImageView setUserInteractionEnabled:YES];
    
    [ToolBox graphicHelper_ApplyShadowToView:self.imvBackground withColor:[UIColor blackColor] offSet:CGSizeMake(1.0, 1.0) radius:2.0 opacity:0.65];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void)actionShowTermsOfUse:(UIButton*)sender
{
    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
    [alert showInfo:@"Termos de Uso" subTitle:self.termsOfUse closeButtonTitle:@"OK" duration:0.0];
}

- (void)actionTapQRCode:(UITapGestureRecognizer*)gesture
{
    [self.qrCodeImageView setUserInteractionEnabled:NO];
    
    VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:self.qrcodeImage backgroundImage:nil andDelegate:self];
    photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    photoView.autoresizingMask = (1 << 6) -1;
    photoView.alpha = 0.0;
    //
    [AppD.window addSubview:photoView];
    [AppD.window bringSubviewToFront:photoView];
    //
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 1.0;
    }];
    
}

- (IBAction)actionScreenshot:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [ToolBox graphicHelper_Snapshot_View:self.view];
        
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
        if (IDIOM == IPAD){
            activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems.firstObject;
        }
        [self presentViewController:activityController animated:YES completion:^{
            NSLog(@"activityController presented");
        }];
        [activityController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            NSLog(@"activityController completed: %@", (completed ? @"YES" : @"NO"));
        }];
    });
}

- (void)photoViewDidHide:(VIPhotoView *)photoView
{
    __block id pv = photoView;
    
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [pv removeFromSuperview];
        pv = nil;
        //
        [self.qrCodeImageView setUserInteractionEnabled:YES];
    }];
}

#pragma mark - QR Code generate

- (CIImage *)createQRForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    CGAffineTransform transform = CGAffineTransformMakeScale(10.0, 10.0);
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    //[qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"]; //default
    
    CIImage *ciImage = [qrFilter.outputImage imageByApplyingTransform:transform];
    
    return ciImage;
}

#pragma mark - Private Methods

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Navigation Controller
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    
    if ([self.promotionType isEqualToString:kCouponDiscountTypeDiscount]){
        //cupom
        self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_COUPOM", @"");
    }else if([self.promotionType isEqualToString:kCouponDiscountTypeCredit]){
        //voucher
        self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_VOUCHER", @"");
    }else{
        //genérico
        self.navigationItem.title = @"";
    }
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    [self.lbValue setTextColor:[UIColor darkTextColor]];
    [ToolBox graphicHelper_ApplyShadowToView:self.lbValue withColor:[UIColor grayColor] offSet:CGSizeMake(2.0, 2.0) radius:1.0 opacity:0.65];
    
    [self.indicator stopAnimating];
    
    lblApp.backgroundColor = [UIColor clearColor];
    lblApp.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:12];
    lblApp.textColor = [UIColor whiteColor];
    lblApp.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    lblVersion.backgroundColor = [UIColor clearColor];
    lblVersion.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:12];
    lblVersion.textColor = [UIColor whiteColor];
    lblVersion.text = [NSString stringWithFormat:@"v%@", [ToolBox applicationHelper_VersionBundle]];
    
}

- (void)createNavigationButtons
{
    //INFO
    UIImage *image = [[UIImage imageNamed:@"NavControllerInfoIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
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
    [button addTarget:self action:@selector(actionShowTermsOfUse:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[button.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[button.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    //SHARE
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionScreenshot:)];
    
    self.navigationItem.rightBarButtonItems = @[infoButton, shareButton];
    
}

- (UIImage*)compositeBackgroundForCoupon
{
    //A imagem do cupom é composta em tempo real para ser compatível com a cor de fundo parâmetro (ou a cor padrão do background do app, caso a parâmetro não esteja disponível):
    
    UIColor *tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    @try {
        NSString *hexColor = [self.couponData valueForKey:@"fg_color"];
        if (hexColor && [hexColor hasPrefix:@"#"]){
            tintColor = [ToolBox graphicHelper_colorWithHexString:hexColor];
        }
    } @catch (NSException *exception) {
        NSLog(@"CuponViewController >> compositeBackgroundForCoupon >> %@", [exception reason]);
    }
    
    //frente e fundo originais
    UIImage *backImage = [UIImage imageNamed:@"background_cupom_action_back.png"];
    UIImage *frontImage = [UIImage imageNamed:@"background_cupom_action_front.png"];
    //cópia recolorida e merge com fundo
    UIImage *blendImage = [ToolBox graphicHelper_ImageWithTintColor:tintColor andImageTemplate:backImage];
    UIImage *maskedBackImage = [ToolBox graphicHelper_MergeImage:backImage withImage:blendImage position:CGPointZero blendMode:kCGBlendModeMultiply alpha:0.7 scale:1.0];
    //merge final
    UIImage *finalImage = [ToolBox graphicHelper_MergeImage:maskedBackImage withImage:frontImage position:CGPointZero blendMode:kCGBlendModeNormal alpha:1.0 scale:1.0];
    //
    return finalImage;
}



@end
