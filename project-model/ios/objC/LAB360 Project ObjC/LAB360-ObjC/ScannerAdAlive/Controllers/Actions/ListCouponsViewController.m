//
//  ListCouponsViewController.m
//  AdAlive
//
//  Created by Lab360 on 1/18/16.
//  Copyright © 2016 Lab360. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ListCouponsViewController.h"
#import "CouponTableViewCell.h"
#import "CouponViewController.h"
#import "ConnectionManager.h"
#import "Error.h"
#import "AppDelegate.h"
#import "AdAliveConnectionManager.h"
#import "LocationService.h"

#pragma mark - • LOCAL DEFINES

typedef NS_ENUM(NSInteger, ListCouponVCType) {
    ListCouponVCType_Generic        = 0,
    ListCouponVCType_Coupon         = 1,
    ListCouponVCType_Voucher        = 2
};

@interface ListCouponsViewController () <ConnectionManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UIView *redView;
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) UIImage *logoImage;
@property(nonatomic, assign) BOOL isGenerateCoupon;
@property(nonatomic, assign) BOOL isLoaded;
@property(nonatomic, assign) ListCouponVCType screenType;
@property(nonatomic, strong) UIImage *backgroundCellImage;
//
@property(nonatomic, strong) LocationService *locationService;

@end

@implementation ListCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isGenerateCoupon = NO;
    self.isLoaded = NO;
    self.backgroundCellImage = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    
    if (!self.isLoaded){
        [self setupLayout];
        
        self.locationService = [LocationService initAndStartMonitoringLocation];
        
        self.tableView.allowsSelection = YES;
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        
        NSURL *logoUrl = [NSURL URLWithString:[self.dicPromotionData objectForKey:@"logo_url"]];
        [self downloadImageWithURL:logoUrl completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded){
                self.logoImage = image;
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
        }];
        
        NSString *pt = [self.dicPromotionData valueForKey:@"promotion_type"];
        if ([pt isEqualToString:kCouponDiscountTypeDiscount]){
            self.screenType = ListCouponVCType_Coupon;
            
            //O botão de QRCode (para consumo de cupons) só está disponível para promoções de desconto:
            [self createCouponScannerButton];
        }else if ([pt isEqualToString:kCouponDiscountTypeCredit]){
            self.screenType = ListCouponVCType_Voucher;
        }
        
        self.isLoaded = YES;
        
    }else{
        [self getPromotionData];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController])
    {
        [self.locationService stopMonitoring];
        self.locationService = nil;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
//    if ([segue.identifier isEqualToString:@"???"]){
//
//    }
}

#pragma mark - Private methods

-(void)actionCouponScanner:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"SegueToCouponHistory" sender:nil];
}

-(void)showCouponDetailWithData:(NSDictionary *)dicCouponData
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CouponViewController *viewController = (CouponViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CouponViewController"];
    viewController.couponData = [ToolBox converterHelper_NewDictionaryRemovingNullValuesFromDictionary:dicCouponData withString:@""];
    viewController.promotionId = [self.dicPromotionData objectForKey:@"id"];
    viewController.promotionName = [self.dicPromotionData objectForKey:@"title"];
    viewController.promotionType = [self.dicPromotionData objectForKey:@"promotion_type"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)requestCouponDataWithActionId:(NSString *)actionId andPromotionId:(NSString *)promotionId
{
    AdAliveConnectionManager *connectionManager = [[AdAliveConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        NSDictionary *coupomDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", self.locationService.latitude], LOG_LATITUDE_KEY, [NSString stringWithFormat:@"%f", self.locationService.longitude], LOG_LONGITUDE_KEY,[[[UIDevice currentDevice] identifierForVendor] UUIDString], LOG_DEVICE_ID_VENDOR_KEY,[[[UIDevice currentDevice] identifierForVendor] UUIDString], @"mobile_id", [self.dicProductData objectForKey:PRODUCT_ID_KEY], @"product_id", actionId, @"action_id", nil];
        NSDictionary *parameters = nil;

        NSString *urlString = @"";
        if (self.screenType == ListCouponVCType_Coupon){
            parameters = [NSDictionary dictionaryWithObjectsAndKeys:coupomDic, @"coupon", AppD.loggedUser.email, AUTHENTICATE_EMAIL_KEY, promotionId, @"promotion_id", nil];
            urlString = SERVICE_URL_COUPON;
        }else if (self.screenType == ListCouponVCType_Voucher){
            parameters = [NSDictionary dictionaryWithObjectsAndKeys:coupomDic, @"voucher", AppD.loggedUser.email, AUTHENTICATE_EMAIL_KEY, promotionId, @"promotion_id", nil];
            urlString = SERVICE_URL_VOUCHER;
        }
        
        [connectionManager postRequestUsingParameters:parameters fromURL:urlString withDictionaryCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            if (error){
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle: NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }else{
                if ([response isKindOfClass:[NSDictionary class]]){
                    
                    NSArray *allkeys = [response allKeys];
                    
                    if ([allkeys containsObject:ERROR_ARRAY_KEY])
                    {
                        Error *error = [[Error alloc] initWithDictionary:response];
                        NSString *errorMessage = [error formatCompleteErrorMessage];
                        //
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_CONNECTION_DATA", @"") subTitle:errorMessage closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }else{
                        
                        if (self.screenType == ListCouponVCType_Coupon){
                            if ([allkeys containsObject:@"coupon"])
                            {
                                [self showCouponDetailWithData:[response objectForKey:@"coupon"]];
                            }
                            else if ([allkeys containsObject:@"coupons"])
                            {
                                [self.dicPromotionData setValue:[response valueForKey:@"coupons"] forKey:@"coupons"];
                                [self.tableView reloadData];
                            }
                        }else if (self.screenType == ListCouponVCType_Voucher){
                            if ([allkeys containsObject:@"voucher"])
                            {
                                [self showCouponDetailWithData:[response objectForKey:@"voucher"]];
                            }
                            else if ([allkeys containsObject:@"vouchers"])
                            {
                                [self.dicPromotionData setValue:[response valueForKey:@"vouchers"] forKey:@"vouchers"];
                                [self.tableView reloadData];
                            }
                        }
                    }
                }
            }
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        }];
    }
    else
    {
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

-(void)getExistentCouponWithId:(NSString *)couponId
{
    AdAliveConnectionManager *connectionManager = [[AdAliveConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@" ,SERVICE_URL_COUPON, couponId];
        if (self.screenType == ListCouponVCType_Coupon){
            urlString = [NSString stringWithFormat:@"%@/%@" ,SERVICE_URL_COUPON, couponId];
        }else if (self.screenType == ListCouponVCType_Voucher){
            urlString = [NSString stringWithFormat:@"%@/%@" ,SERVICE_URL_VOUCHER, couponId];
        }
        
        [connectionManager getRequestUsingParametersFromURL:urlString withDictionaryCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            if (error){
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle: NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }else{
                if ([response isKindOfClass:[NSDictionary class]]){
                    
                    NSArray *allkeys = [response allKeys];
                    
                    if ([allkeys containsObject:ERROR_ARRAY_KEY])
                    {
                        Error *error = [[Error alloc] initWithDictionary:response];
                        NSString *errorMessage = [error formatCompleteErrorMessage];
                        //
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_CONNECTION_DATA", @"") subTitle:errorMessage closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }else{
                        
                        if (self.screenType == ListCouponVCType_Coupon){
                            if ([allkeys containsObject:@"coupon"])
                            {
                                [self showCouponDetailWithData:[response objectForKey:@"coupon"]];
                            }
                            else if ([allkeys containsObject:@"coupons"])
                            {
                                [self.dicPromotionData setValue:[response valueForKey:@"coupons"] forKey:@"coupons"];
                                [self.tableView reloadData];
                            }
                        }else if (self.screenType == ListCouponVCType_Voucher){
                            if ([allkeys containsObject:@"voucher"])
                            {
                                [self showCouponDetailWithData:[response objectForKey:@"voucher"]];
                            }
                            else if ([allkeys containsObject:@"vouchers"])
                            {
                                [self.dicPromotionData setValue:[response valueForKey:@"vouchers"] forKey:@"vouchers"];
                                [self.tableView reloadData];
                            }
                        }
                    }
                }
            }
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        }];
    }
    else
    {
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    
}

-(void)generateCoupon
{
    self.isGenerateCoupon = YES;
    [self requestCouponDataWithActionId:self.actionId andPromotionId:[self.dicPromotionData objectForKey:@"id"]];
}

-(void)getPromotionData
{
    AdAliveConnectionManager *connectionManager = [[AdAliveConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@?email=%@", SERVICE_URL_PROMOTION, [self.dicPromotionData objectForKey:@"id"], AppD.loggedUser.email];
        
        [connectionManager getRequestUsingParametersFromURL:urlString withDictionaryCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            if (error){
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle: NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }else{
                if ([response isKindOfClass:[NSDictionary class]]){
                    
                    NSArray *allkeys = [response allKeys];
                    
                    if ([allkeys containsObject:ERROR_ARRAY_KEY]){
                        Error *error = [[Error alloc] initWithDictionary:response];
                        NSString *errorMessage = [error formatCompleteErrorMessage];
                        //
                        SCLAlertView *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR_CONNECTION_DATA", @"") subTitle:errorMessage closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                    }else{
                        
                        if (self.screenType == ListCouponVCType_Coupon){
                            if ([allkeys containsObject:@"coupon"])
                            {
                                [self showCouponDetailWithData:[response objectForKey:@"coupon"]];
                            }
                            else if ([allkeys containsObject:@"coupons"])
                            {
                                [self.dicPromotionData setValue:[response valueForKey:@"coupons"] forKey:@"coupons"];
                                [self.tableView reloadData];
                            }
                        }else if (self.screenType == ListCouponVCType_Voucher){
                            if ([allkeys containsObject:@"voucher"])
                            {
                                [self showCouponDetailWithData:[response objectForKey:@"voucher"]];
                            }
                            else if ([allkeys containsObject:@"vouchers"])
                            {
                                [self.dicPromotionData setValue:[response valueForKey:@"vouchers"] forKey:@"vouchers"];
                                [self.tableView reloadData];
                            }
                        }
                    }
                }
            }
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        }];
    }
    else
    {
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

#pragma mark - UITableView delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(10.0, 10.0, headerView.frame.size.width - 20.0, headerView.frame.size.height - 20.0)];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    [button setExclusiveTouch:YES];
    [button setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:button.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [button setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:button.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    UIImage *icon = [[UIImage imageNamed:@"ActionIconCoupon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:icon forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5.0, 20.0, 5.0, 5.0)];
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 20.0)]; //para imagens retangulares...
    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button.imageView setClipsToBounds:YES];
    [button setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button addTarget:self action:@selector(generateCoupon) forControlEvents:UIControlEventTouchUpInside];
    [button setTintColor:[UIColor whiteColor]];
    
    //TODO: por enquanto vouchers não serão criados no app, portanto o botão ficará desabilitado
    if (self.screenType == ListCouponVCType_Coupon){
        [button setTitle:[NSLocalizedString(@"BUTTON_COUPON_TITLE", @"") uppercaseString] forState:UIControlStateNormal];
    }else if (self.screenType == ListCouponVCType_Voucher){
        [button setTitle:[NSLocalizedString(@"BUTTON_VOUCHER_TITLE", @"") uppercaseString] forState:UIControlStateNormal];
        [button setEnabled:NO];
    }else{
        [button setTitle:@"-" forState:UIControlStateNormal];
        [button setEnabled:NO];
    }
    
    [headerView addSubview:button];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrayCoupons = [NSArray new];
    
    if (self.screenType == ListCouponVCType_Coupon){
        arrayCoupons = [self.dicPromotionData objectForKey:@"coupons"];
    }else if (self.screenType == ListCouponVCType_Voucher){
        arrayCoupons = [self.dicPromotionData objectForKey:@"vouchers"];
    }
    
    return [arrayCoupons count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"couponCell";
    
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[CouponTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setupLayout];
    
    NSArray *arrayCoupons = [NSArray new];
    
    if (self.screenType == ListCouponVCType_Coupon){
        arrayCoupons = [self.dicPromotionData objectForKey:@"coupons"];
    }else if (self.screenType == ListCouponVCType_Voucher){
        arrayCoupons = [self.dicPromotionData objectForKey:@"vouchers"];
    }
    NSDictionary *dicCoupon = [arrayCoupons objectAtIndex:indexPath.row];
    
    if (self.backgroundCellImage == nil){
        UIColor *tintColor = AppD.styleManager.colorPalette.backgroundNormal;
        @try {
            NSString *hexColor = [dicCoupon valueForKey:@"fg_color"];
            if (hexColor && [hexColor hasPrefix:@"#"]){
                tintColor = [ToolBox graphicHelper_colorWithHexString:hexColor];
            }
        } @catch (NSException *exception) {
            NSLog(@"ListCouponsVC >> cellForRowAtIndexPath >> compositeBackgroundForCouponCellWithColor >> %@", [exception reason]);
        }
        self.backgroundCellImage = [self compositeBackgroundForCouponCellWithColor:tintColor];
    }
    
    //Background:
    cell.imvBackground.image = self.backgroundCellImage;
    
    //Valor:
    if ([[self.dicPromotionData valueForKey:@"promotion_type"] isEqualToString:kCouponDiscountTypeCredit]){
        NSString *strValue = [NSString stringWithFormat:@"%@", [dicCoupon objectForKey:kCouponDiscountTypeValue]]; //"value"
        double valueD = [strValue doubleValue];
        cell.value.text = [ToolBox converterHelper_MonetaryStringForValue:valueD];
        //
        cell.type.text = @"Voucher de crédito";
    }else{
        NSString *strValue = [NSString stringWithFormat:@"%@", [dicCoupon objectForKey:kCouponDiscountValueKey]]; //"discount_value"
        double valueD = [strValue doubleValue];
        if ([[dicCoupon valueForKey:kCouponDiscountTypeKey] isEqualToString:kCouponDiscountTypePercentage]){
            cell.value.text = [NSString stringWithFormat:@"%.1f%%", valueD];
        }else{
            cell.value.text = [ToolBox converterHelper_MonetaryStringForValue:valueD];
        }
        //
        cell.type.text = @"Cupom de desconto";
    }
	
    //Data:
	if (![[dicCoupon objectForKey:@"end_date"] isKindOfClass:[NSNull class]]) {
		
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd"];
		NSDate *date = [df dateFromString:[dicCoupon objectForKey:@"end_date"]];
		[df setDateFormat:@"dd/MM/yyyy"];
		
		cell.endDate.text = [NSString stringWithFormat:@"Validade: %@", [df stringFromDate:date]];
	}
	
    //Image:
    if (self.logoImage){
        cell.logoImage.image = self.logoImage;
        cell.logoImage.backgroundColor = [UIColor clearColor];
        cell.logoImage.hidden = NO;
    }else{
        cell.logoImage.hidden = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: por enquanto vouchers não serão criados no app.
    if (self.screenType == ListCouponVCType_Coupon){
        NSArray *arrayCoupons = [NSArray new];
        
        if (self.screenType == ListCouponVCType_Coupon){
            arrayCoupons = [self.dicPromotionData objectForKey:@"coupons"];
        }else if (self.screenType == ListCouponVCType_Voucher){
            arrayCoupons = [self.dicPromotionData objectForKey:@"vouchers"];
        }
        NSDictionary *dicCoupon = [arrayCoupons objectAtIndex:indexPath.row];
        
        self.isGenerateCoupon = NO;
        
        [self getExistentCouponWithId:[dicCoupon objectForKey:@"id"]];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}



#pragma mark - Private Methods

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Navigation Controller
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = [self.dicPromotionData objectForKey:@"title"];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
}

- (void)createCouponScannerButton
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
    [button addTarget:self action:@selector(actionCouponScanner:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[button.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[button.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = b;
}

- (UIImage*)compositeBackgroundForCouponCellWithColor:(UIColor*)tintColor
{
    //A imagem do cupom é composta em tempo real para ser compatível com a cor de fundo parâmetro (ou a cor padrão do background do app, caso a parâmetro não esteja disponível):
    
    //frente e fundo originais
    UIImage *backImage = [UIImage imageNamed:@"background_cupom_cell_back.png"];
    //cópia recolorida e merge com fundo
    UIImage *blendImage = [ToolBox graphicHelper_ImageWithTintColor:tintColor andImageTemplate:backImage];
    UIImage *maskedBackImage = [ToolBox graphicHelper_MergeImage:backImage withImage:blendImage position:CGPointZero blendMode:kCGBlendModeMultiply alpha:0.7 scale:1.0];
    //
    return maskedBackImage;
}

#pragma mark -

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( !error ){
            UIImage *image = [[UIImage alloc] initWithData:data];
            completionBlock(YES,image);
        } else{
            completionBlock(NO,nil);
        }
    }];
}

@end
