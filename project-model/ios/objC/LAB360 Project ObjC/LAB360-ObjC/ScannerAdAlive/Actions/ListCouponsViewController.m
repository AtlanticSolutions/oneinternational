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
#import "LocationManager.h"
#import "Constants.h"
#import "UIColor+Category.h"
#import "Error.h"

@interface ListCouponsViewController () <ConnectionManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UIView *redView;
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) UIImage *logoImage;
@property BOOL isGenerateCoupon;

@end

@implementation ListCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.dicPromotionData objectForKey:@"title"];
    self.isGenerateCoupon = NO;
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
    
    self.tableView.allowsSelection = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    NSURL *logoUrl = [NSURL URLWithString:[self.dicPromotionData objectForKey:@"logo_url"]];
    [self downloadImageWithURL:logoUrl completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded)
        {
            self.logoImage = image;
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    }];
    
    if (self.isGenerateCoupon)
    {
        [self getPromotionData];
    }
}

#pragma mark - Private methods

-(void)showCouponDetailWithData:(NSDictionary *)dicCouponData
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CouponViewController *viewController = (CouponViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CouponViewController"];
    viewController.couponData = dicCouponData;
    viewController.promotionId = [self.dicPromotionData objectForKey:@"id"];
    viewController.providesPresentationContextTransitionStyle = YES;
    viewController.definesPresentationContext = YES;
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.navigationController pushViewController:viewController animated:YES];

}

-(void)requestCouponDataWithActionId:(NSString *)actionId andPromotionId:(NSString *)promotionId
{
    LocationManager *locationManager = [LocationManager sharedLocation];
    [locationManager startStandardUpdates];
    
    CLLocation *lastLocation = locationManager.lastLocation;
    CLLocationDegrees latitude = lastLocation.coordinate.latitude;
    CLLocationDegrees longitude = lastLocation.coordinate.longitude;
    
    [locationManager stopStandardUpdates];
    
    NSDictionary *dicParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", latitude], LOG_LATITUDE_KEY, [NSString stringWithFormat:@"%f", longitude], LOG_LONGITUDE_KEY,[[[UIDevice currentDevice] identifierForVendor] UUIDString], LOG_DEVICE_ID_VENDOR_KEY,[[[UIDevice currentDevice] identifierForVendor] UUIDString], @"mobile_id", [self.dicProductData objectForKey:PRODUCT_ID_KEY], @"product_id", actionId, @"action_id", nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
    NSString *productData = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", PROFILE_DIRECTORY, PROFILE_FILE]];
    
    NSDictionary *dicUser = [NSDictionary dictionaryWithContentsOfFile:productData];
    
    NSDictionary *dicParameter2 = [NSDictionary dictionaryWithObjectsAndKeys:dicParameters, @"coupon", [dicUser objectForKey: AUTHENTICATE_EMAIL_KEY], @"email", promotionId, @"promotion_id", nil];
    
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    connection.delegate = self;
    
    [connection couponLogWithParameters:dicParameter2];
}

-(void)getExistentCouponWithId:(NSString *)couponId
{
    ConnectionManager *connection = [[ConnectionManager alloc] init];
    connection.delegate = self;
    
    [connection loadCouponWithId:couponId];
}

-(void)generateCoupon
{
    self.isGenerateCoupon = YES;
    [self requestCouponDataWithActionId:self.actionId andPromotionId:[self.dicPromotionData objectForKey:@"id"]];
}

-(void)getPromotionData
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken])
    {
        //verificar se usuario esta logado
        ConnectionManager *connection = [[ConnectionManager alloc] init];
        connection.delegate = self;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,    NSUserDomainMask ,YES );
        NSString *productData = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", PROFILE_DIRECTORY, PROFILE_FILE]];
        
        NSDictionary *dicUser = [NSDictionary dictionaryWithContentsOfFile:productData];
        [connection loadPromotionCouponsWithId:[self.dicPromotionData objectForKey:@"id"] andUserId:[dicUser objectForKey: AUTHENTICATE_EMAIL_KEY]];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TITLE_CONNECTION_ERROR", @"Mensagens Gerais") message:NSLocalizedString(@"MESSAGE_NEED_LOGIN", @"Mensagens Gerais") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UITableView delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(10, 15, headerView.frame.size.width-20, 50)];
    [button setBackgroundColor:[UIColor colorWithRed:0 green:0.3764 blue:0.5019 alpha:1]];
    [button setTitle:NSLocalizedString(@"BUTTON_COUPON_TITLE", @"Titles") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.5372 green:0.8431 blue:0.9098 alpha:1] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(generateCoupon) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.shadowColor = [UIColor grayColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    button.layer.shadowOpacity = 0.8;
    button.layer.shadowRadius = 0.0;
    
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [headerView addSubview:button];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrayCoupons = [self.dicPromotionData objectForKey:@"coupons"];
    return [arrayCoupons count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponTableViewCell *cell = (CouponTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"couponCell" forIndexPath:indexPath];
    
    NSArray *arrayCoupons = [self.dicPromotionData objectForKey:@"coupons"];
    NSDictionary *dicCoupon = [arrayCoupons objectAtIndex:indexPath.row];
    
    NSString *discount_type = [dicCoupon objectForKey:@"discount_type"];
    
    if (discount_type)
    {
        if ([discount_type isEqualToString:@"percentage"])
        {
            cell.value.text = [NSString stringWithFormat:@"%@%%", [dicCoupon objectForKey:@"value"]];
        }
        else
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [formatter setLocale:[NSLocale currentLocale]];
            NSNumber *priceValue = [NSNumber numberWithFloat:[[dicCoupon objectForKey:@"value"] floatValue]];
            
            cell.value.text = [formatter stringFromNumber:priceValue];
        }
    }
    else{
        cell.value.text = [NSString stringWithFormat:@"%@%%", [dicCoupon objectForKey:@"value"]];
    }
	
	if (![[dicCoupon objectForKey:@"end_date"] isKindOfClass:[NSNull class]]) {
		
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd"];
		NSDate *date = [df dateFromString:[dicCoupon objectForKey:@"end_date"]];
		[df setDateFormat:@"dd/MM/yyyy"];
		
		cell.endDate.text = [NSString stringWithFormat:@"Validade: %@", [df stringFromDate:date]];
	}
	
    if (self.logoImage)
    {
        cell.logoImage.image = self.logoImage;
        cell.logoImage.backgroundColor = [UIColor clearColor];
        cell.logoImage.hidden = NO;
    }
    else
    {
        cell.logoImage.hidden = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayCoupons = [self.dicPromotionData objectForKey:@"coupons"];
    NSDictionary *dicCoupon = [arrayCoupons objectAtIndex:indexPath.row];
    self.isGenerateCoupon = NO;
    
    [self getExistentCouponWithId:[dicCoupon objectForKey:@"id"]];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - ConnectionManager delegate

-(void)didConnectWithSuccess:(NSDictionary *)response
{
    NSArray *allkeys = [response allKeys];
    
    if ([allkeys containsObject:ERROR_ARRAY_KEY])
    {
        Error *error = [[Error alloc] initWithDictionary:response];
        NSString *errorMessage = [error formatCompleteErrorMessage];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TITLE_CONNECTION_ERROR", @"") message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([allkeys containsObject:@"coupon"])
    {
        [self showCouponDetailWithData:[response objectForKey:@"coupon"]];
    }
    else if ([allkeys containsObject:@"coupons"])
    {
        self.dicPromotionData = response;
        [self.tableView reloadData];
    }
}

-(void)didConnectWithFailure:(NSError *)error
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TITLE_CONNECTION_ERROR", @"") message:NSLocalizedString(@"MESSAGE_CONNECTION_ERROR", @"") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
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

@end
