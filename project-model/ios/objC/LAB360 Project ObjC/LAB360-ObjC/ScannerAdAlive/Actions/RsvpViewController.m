//
//  RsvpViewController.m
//  AdAlive
//
//  Created by Monique Trevisan on 12/2/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import "RsvpViewController.h"
#import "Constants.h"

@interface RsvpViewController ()

@property(nonatomic, weak) IBOutlet UILabel *lbInvite;
@property(nonatomic, weak) IBOutlet UILabel *lbNeedLogin;
@property(nonatomic, weak) IBOutlet UIButton *btConfirm;

@end

@implementation RsvpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"SCREEN_CONFIRM_ATTENDANCE", @"Titles");
	
    UIImageView *imageView;
    
#ifdef SERVER_URL
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-navbar3"]];
#else
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_navbar2"]];
#endif
	
	UIBarButtonItem *logoView = [[UIBarButtonItem alloc] initWithCustomView:imageView];
	self.navigationItem.rightBarButtonItem = logoView;
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.3764 blue:0.5019 alpha:1];
	
	if ([[NSUserDefaults standardUserDefaults] valueForKey:kAccessToken])
	{
		self.lbNeedLogin.hidden = YES;
		[self.btConfirm setTitle:NSLocalizedString(@"BUTTON_TITLE_CONFIRM", @"Buttons") forState:UIControlStateNormal];
	}
	else
	{
		self.lbNeedLogin.hidden = NO;
		[self.btConfirm setTitle:NSLocalizedString(@"BUTTON_TITLE_LOGIN", @"Buttons") forState:UIControlStateNormal];
	}	
}

-(IBAction)clickConfirmButton:(UIButton *)button
{
	if ([button.titleLabel.text isEqualToString:NSLocalizedString(@"BUTTON_TITLE_LOGIN", @"Buttons")])
	{
		//Mostrar tela de login
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TITLE_CONFIRM_ATTENDANCE", @"Mensagens gerais") message:NSLocalizedString(@"MESSAGE_CONFIRM_ATTENDANCE", @"Mensagens gerais") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
	}
	
}


@end
