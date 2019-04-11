//
//  PriceActionViewController.m
//  AdAlive
//
//  Created by Monique Trevisan on 8/14/15.
//  Copyright (c) 2015 Lab360. All rights reserved.
//

#import "PriceActionViewController.h"
#import "ConstantsManager.h"

@interface PriceActionViewController ()

@property(nonatomic, weak) IBOutlet UIView *viewPrice;
@property(nonatomic, weak) IBOutlet UILabel *lblOnePrice;
@property(nonatomic, weak) IBOutlet UILabel *lblPrice;
@property(nonatomic, weak) IBOutlet UILabel *lblDe;
@property(nonatomic, weak) IBOutlet UILabel *lblPor;
@property(nonatomic, weak) IBOutlet UILabel *lblDiscountPrice;
@property(nonatomic, weak) IBOutlet UILabel *lblProductName;

@end

@implementation PriceActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.viewPrice.layer.borderWidth = 3.0;
//    self.viewPrice.layer.borderColor = [[UIColor colorWithRed:0 green:0.3764 blue:0.5019 alpha:1] CGColor];
    self.viewPrice.layer.cornerRadius = 5;
    self.viewPrice.layer.borderWidth = 1.0;
    //self.viewPrice.layer.borderColor = [[UIColor colorWithRed:0.0352 green:0.3058 blue:0.5019 alpha:1.0] CGColor];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_buttonCloseTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *currencyPriceString;
    NSString *currencyDiscountString;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    
    if ([[self.dicProduct objectForKey: PRODUCT_DISCOUNT_PRICE_KEY] isKindOfClass:[NSNull class]] || [[self.dicProduct objectForKey: PRODUCT_DISCOUNT_PRICE_KEY] isEqualToString:[self.dicProduct objectForKey: PRODUCT_PRICE_KEY]])
    {
        self.lblPrice.hidden = YES;
        self.lblDiscountPrice.hidden = YES;
        self.lblDe.hidden = YES;
        self.lblPor.hidden = YES;
        self.lblOnePrice.hidden = NO;
        
        NSNumber *priceValue = [NSNumber numberWithFloat:[[self.dicProduct objectForKey: PRODUCT_PRICE_KEY] floatValue]];
        currencyPriceString = [formatter stringFromNumber:priceValue];
        
        self.lblOnePrice.text = currencyPriceString;
    }
    else
    {
        self.lblPrice.hidden = NO;
        self.lblDiscountPrice.hidden = NO;
        self.lblDe.hidden = NO;
        self.lblPor.hidden = NO;
        self.lblOnePrice.hidden = YES;
        
        NSNumber *priceValue = [NSNumber numberWithFloat:[[self.dicProduct objectForKey: PRODUCT_PRICE_KEY] floatValue]];
        NSNumber *discountValue = [NSNumber numberWithFloat:[[self.dicProduct objectForKey: PRODUCT_DISCOUNT_PRICE_KEY] floatValue]];
        currencyPriceString = [formatter stringFromNumber:priceValue];
        currencyDiscountString = [formatter stringFromNumber:discountValue];
        self.lblPrice.text = currencyPriceString;
        self.lblDiscountPrice.text = currencyDiscountString;
    }
}


-(IBAction)_buttonCloseTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
