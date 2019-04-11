//
//  RsvpViewController.m
//  AdAlive
//
//  Created by Monique Trevisan on 12/2/14.
//  Copyright (c) 2014 Lab360. All rights reserved.
//

#import "RsvpViewController.h"

@interface RsvpViewController ()

@property(nonatomic, weak) IBOutlet UILabel *lbInvite;
@property(nonatomic, weak) IBOutlet UILabel *lbNeedLogin;
@property(nonatomic, weak) IBOutlet UIButton *btConfirm;

@end

@implementation RsvpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    //TODO: verificar se é necessário mostrar esse logo
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavBarQuiz"]]; //NavBarAdAlive...
    //UIBarButtonItem *logoView = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    //self.navigationItem.rightBarButtonItem = logoView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    
    //Atualmente não é possível entrar nesta tela sem ter feito login
//    if (AppD.loggedUser.userID != 0){
//        self.lbNeedLogin.tag = 1;
//        [self.btConfirm setTitle:NSLocalizedString(@"BUTTON_TITLE_RSVP_CONFIRM", @"") forState:UIControlStateNormal];
//    }else{
//        self.lbNeedLogin.tag = 2;
//        [self.btConfirm setTitle:NSLocalizedString(@"BUTTON_TITLE_RSVP_LOGIN", @"") forState:UIControlStateNormal];
//    }
}

-(IBAction)clickConfirmButton:(UIButton *)button
{
    if (button.tag == 1){
        //Confirmação:
        
        //TODO: O que é pra fazer aqui? (no app exemplo não existe ação)
//        dispatch_async(dispatch_get_main_queue(),^{
//            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
//        });
//        //
//        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showSuccess:self title:NSLocalizedString(@"ALERT_TITLE_CONFIRM_ATTENDANCE", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CONFIRM_ATTENDANCE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            
    }
//    else
//    {
//        //TODO: precisa logar (não funcional pois neste app não é possível entrar sem estar logado).
//    }
}

#pragma mark - Private Methods
- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Navigation Controller
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_CONFIRM_ATTENDANCE", @"");
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    [self.btConfirm setTitle:NSLocalizedString(@"BUTTON_TITLE_RSVP_CONFIRM", @"") forState:UIControlStateNormal];
    self.lbNeedLogin.tag = 1;
}

@end
