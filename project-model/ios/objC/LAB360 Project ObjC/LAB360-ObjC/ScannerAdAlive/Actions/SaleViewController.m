//
//  SaleViewController.m
//  AdAlive
//
//  Created by Monique Trevisan on 11/7/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import "SaleViewController.h"
#import "Constants.h"

@interface SaleViewController ()

@property(nonatomic, weak) IBOutlet UIImageView *productImage;
@property(nonatomic, weak) IBOutlet UIView *productDetailView;
@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@property(nonatomic, weak) IBOutlet UILabel *lblSubtitle;
@property(nonatomic, weak) IBOutlet UIButton *btBuy;

@end

@implementation SaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SCREEN_SALE", @"Titles");
    
    UIImageView *imageView;
    
#ifdef SERVER_URL
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-navbar3"]];
#else
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_navbar2"]];
#endif
    
    UIBarButtonItem *logoView = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.rightBarButtonItem = logoView;
    
    self.btBuy.layer.cornerRadius = 4.0;
    
    self.productImage.contentMode = UIViewContentModeScaleAspectFill;
    self.productImage.clipsToBounds = YES;
    
    self.productImage.layer.borderWidth = 1;
    self.productImage.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.productImage.image = self.image;
    
    UIFont *font = [UIFont fontWithName:@"Lato-Bold" size:18];
    self.lblTitle.font = font;
    self.lblTitle.text = [self.dicProduct objectForKey:PRODUCT_TITLE_KEY];
    font = [UIFont fontWithName:@"Lato-Bold" size:15];
    self.lblSubtitle.font = font;
    self.lblSubtitle.text = [self.dicProduct objectForKey:PRODUCT_SUBTITLE_KEY];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Events 

-(IBAction)clickOkButton:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TITLE_SUCCESS", @"Mensagens gerais") message:NSLocalizedString(@"MESSAGE_SALE_SUCCESS", @"Mensagens gerais") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

-(IBAction)clickCancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
