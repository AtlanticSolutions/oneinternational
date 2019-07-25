//
//  CouponViewController.m
//  AdAlive
//
//  Created by Lab360 on 1/12/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import "CouponViewController.h"
//#import "Constants.h"
#import "UIColor+Category.h"

@interface CouponViewController ()

@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIView *couponPrintView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbCouponCode;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lbEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lbDescName;

@property (weak, nonatomic) IBOutlet UILabel *lbDescCode;
@property (weak, atomic) IBOutlet UILabel *lbDescEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbTermsOfUse;
@property (weak, nonatomic) IBOutlet UILabel *lbValue;

@property(nonatomic, strong) UIImage *couponImage;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView;
    
#ifdef WILVALE
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-navbar3"]];
#elif NATURA
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-navbar-natura"]];
#elif ETNA
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
#elif IPIRANGA
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
#elif HINODE
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
#endif
    
    UIBarButtonItem *logoView = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.rightBarButtonItem = logoView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadComponentsValues];
    
    //MARK: EricoGT (update for AdAliveStore project)
    NSMutableDictionary *dicQRCode = [NSMutableDictionary new];
    //Hash de segurança (ignora outros QRCodes que o usuário tente escanear com o aplicativo)
    [dicQRCode setValue:@"56f741f91faa7ac1a2eeb17ff4919d46" forKey:@"hash"]; //MD5 para texto fixo "AdAliveStore"
    //Identificador do cupom
    [dicQRCode setValue:[self.couponData objectForKey:@"coupon_code"] forKey:@"coupon_code"];
    //ID do usuário (criador do QRCode)
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *productData = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", PROFILE_DIRECTORY, PROFILE_FILE]];
    NSDictionary *dicUser = [NSDictionary dictionaryWithContentsOfFile:productData];
    [dicQRCode setValue:[dicUser objectForKey:@"id"] forKey:@"app_user_id"];
    //Identificador do aplicativo
    [dicQRCode setValue:[NSString stringWithFormat:@"%s", VALUE_APP_ID(APP_ID)] forKey:@"app_id"];
    //identificador da promoção
    [dicQRCode setValue:self.promotionId forKey:@"promotion_id"];
    
    //Criando o QRCode
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicQRCode options:0 error:nil];
    NSString *qrCodeString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    CIImage *image = [self createQRForString:qrCodeString];
    
    float scaleX = self.qrCodeImageView.frame.size.width / [image extent].size.width;
    float scaleY = self.qrCodeImageView.frame.size.height / [image extent].size.height;
    
    CIImage *transformedImage = [image imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    self.qrCodeImageView.image = [UIImage imageWithCIImage:transformedImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

-(void)loadComponentsValues
{
    [self downloadImageWithURL:[NSURL URLWithString:[self.couponData objectForKey:@"logo_url"]] completionBlock:^(BOOL succeeded, UIImage *image)
     {
         if (succeeded)
         {
             self.logoImageView.image = image;
         }
         else
         {
             self.logoImageView.backgroundColor = [UIColor lightGrayColor];
         }
     }];
    
    self.lbDescName.text = NSLocalizedString(@"LABEL_NAME", @"Labels");
    self.lbDescEndDate.text = NSLocalizedString(@"LABEL_END_DATE", @"Labels");
    self.lbDescCode.text = NSLocalizedString(@"LABEL_CODE", @"Labels");
    
    self.lbTitle.text = [[self.couponData objectForKey:@"title"] isKindOfClass:[NSNull class]]? @"": [self.couponData objectForKey:@"title"];
    self.lbSubtitle.text = [[self.couponData objectForKey:@"subtitle"] isKindOfClass:[NSNull class]]? @"": [self.couponData objectForKey:@"subtitle"];
    self.lbCouponCode.text = [[self.couponData objectForKey:@"coupon_code"] isKindOfClass:[NSNull class]]? @"": [self.couponData objectForKey:@"coupon_code"];
    self.lbTermsOfUse.text = [[self.couponData objectForKey:@"condition_terms"] isKindOfClass:[NSNull class]]? @"": [self.couponData objectForKey:@"condition_terms"];
    
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *productData = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", PROFILE_DIRECTORY, PROFILE_FILE]];
    
    NSDictionary *dicUser = [NSDictionary dictionaryWithContentsOfFile:productData];
    self.lbUserName.text = [NSString stringWithFormat:@"%@ %@",[dicUser objectForKey:AUTHENTICATE_FIRST_NAME], [dicUser objectForKey:AUTHENTICATE_LAST_NAME]];
    
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

#pragma mark - QR Code generate

- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    return qrFilter.outputImage;
}

@end
