//
//  VC_PromotionsExtract.m
//  ShoppingBH
//
//  Created by Erico GT on 06/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_PromotionsExtract.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_PromotionsExtract()

//Layout
@property (nonatomic, weak) IBOutlet UIView *viewCoupon;
@property (nonatomic, weak) IBOutlet UILabel *lblCouponTitle;
@property (nonatomic, weak) IBOutlet UIImageView *imvCouponAvailable;
@property (nonatomic, weak) IBOutlet UIImageView *imvCouponRedeemed;
@property (nonatomic, weak) IBOutlet UIImageView *imvCouponBalance;
@property (nonatomic, weak) IBOutlet UILabel *lblCouponAvailableTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblCouponRedeemedTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblCouponBalanceTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblCouponAvailableValue;
@property (nonatomic, weak) IBOutlet UILabel *lblCouponRedeemedValue;
@property (nonatomic, weak) IBOutlet UILabel *lblCouponBalanceValue;
//
@property (nonatomic, weak) IBOutlet UIView *viewBonus;
@property (nonatomic, weak) IBOutlet UILabel *lblBonusTitle;
@property (nonatomic, weak) IBOutlet UIImageView *imvBonusAvailable;
@property (nonatomic, weak) IBOutlet UIImageView *imvBonusRedeemed;
@property (nonatomic, weak) IBOutlet UIImageView *imvBonusBalance;
@property (nonatomic, weak) IBOutlet UILabel *lblBonusAvailableTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblBonusRedeemedTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblBonusBalanceTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblBonusAvailableValue;
@property (nonatomic, weak) IBOutlet UILabel *lblBonusRedeemedValue;
@property (nonatomic, weak) IBOutlet UILabel *lblBonusBalanceValue;
//
@property (nonatomic, weak) IBOutlet UIView *viewLuckyNumbers;
@property (nonatomic, weak) IBOutlet UILabel *lblTitleLuckyNumbers;
@property (nonatomic, weak) IBOutlet UIButton *btnCreateLuckyNumbers;
@property (nonatomic, weak) IBOutlet UITableView *tvLuckyNumbers;
//
@property (nonatomic, weak) IBOutlet UIScrollView *baseScrollView;
@property (nonatomic, weak) IBOutlet UILabel *lblNoData;
//
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topConstraintLuckyNumberTableView;

//Data
@property (nonatomic, strong) NSMutableArray *luckyNumbersList;
@property (nonatomic, assign) bool canShowCouponGenerator;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_PromotionsExtract
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize viewCoupon, lblCouponTitle, imvCouponAvailable, imvCouponRedeemed, imvCouponBalance, lblCouponAvailableTitle, lblCouponRedeemedTitle, lblCouponBalanceTitle, lblCouponAvailableValue, lblCouponRedeemedValue, lblCouponBalanceValue;
@synthesize viewBonus, lblBonusTitle, imvBonusAvailable, imvBonusRedeemed, imvBonusBalance, lblBonusAvailableTitle, lblBonusRedeemedTitle, lblBonusBalanceTitle, lblBonusAvailableValue, lblBonusRedeemedValue, lblBonusBalanceValue;
@synthesize viewLuckyNumbers, lblTitleLuckyNumbers, btnCreateLuckyNumbers, tvLuckyNumbers, promotion, lblNoData, contentHeightConstraint, baseScrollView;
@synthesize luckyNumbersList, canShowCouponGenerator, topConstraintLuckyNumberTableView;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //Button Profile Pic
    //self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_INVOICE_EXTRACT", @"");
    
    tvLuckyNumbers.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    canShowCouponGenerator = false;
    
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
    
    //TOTO: mock para teste:
//    lblCouponAvailableValue.text = @"1";
//    lblCouponRedeemedValue.text = @"2";
//    lblCouponBalanceValue.text = @"R$ 123,45";
//    //
//    lblBonusAvailableValue.text = @"3";
//    lblBonusRedeemedValue.text = @"4";
//    lblBonusBalanceValue.text = @"R$ 200,95";
//    //
//    luckyNumbersList = [NSMutableArray new];
//    [luckyNumbersList addObject:@"001232"];
//    [luckyNumbersList addObject:@"423231"];
//    [luckyNumbersList addObject:@"987321"];
//    [luckyNumbersList addObject:@"004321"];
//    [tvLuckyNumbers reloadData];
//    //
//    viewLuckyNumbers.alpha = 1.0;
//    viewBonus.alpha = 1.0;
//    viewCoupon.alpha = 1.0;
//    //
//    [self updateBaseScrollHeightSize];
    
    [self getExtractFromServer];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionConsumeCoupon:(id)sender
{
    [self postExtractFromServer];
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return luckyNumbersList.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"LuckyNumberCell";
    
    TVC_SurveyOptionPromotion *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[TVC_SurveyOptionPromotion alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell updateLayout];
    
    NSString *lNumber = [luckyNumbersList objectAtIndex:indexPath.row];
    
    //Data:
    cell.lblTitleOption.text = lNumber;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    //Backgrounds
    viewCoupon.backgroundColor = nil;
    lblCouponTitle.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    imvCouponAvailable.backgroundColor = nil;
    imvCouponRedeemed.backgroundColor = nil;
    imvCouponBalance.backgroundColor = nil;
    lblCouponAvailableTitle.backgroundColor = nil;
    lblCouponRedeemedTitle.backgroundColor = nil;
    lblCouponBalanceTitle.backgroundColor = nil;
    lblCouponAvailableValue.backgroundColor = nil;
    lblCouponRedeemedValue.backgroundColor = nil;
    lblCouponBalanceValue.backgroundColor = nil;
    //
    viewBonus.backgroundColor = nil;
    lblBonusTitle.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    imvBonusAvailable.backgroundColor = nil;
    imvBonusRedeemed.backgroundColor = nil;
    imvBonusBalance.backgroundColor = nil;
    lblBonusAvailableTitle.backgroundColor = nil;
    lblBonusRedeemedTitle.backgroundColor = nil;
    lblBonusBalanceTitle.backgroundColor = nil;
    lblBonusAvailableValue.backgroundColor = nil;
    lblBonusRedeemedValue.backgroundColor = nil;
    lblBonusBalanceValue.backgroundColor = nil;
    //
    viewLuckyNumbers.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:237.0/255.0 blue:230.0/255.0 alpha:1.0];
    lblTitleLuckyNumbers.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    tvLuckyNumbers.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:237.0/255.0 blue:230.0/255.0 alpha:1.0];
    btnCreateLuckyNumbers.backgroundColor = nil;
    //
    baseScrollView.backgroundColor = nil;
    
    //Imagens:
    imvCouponAvailable.image = [ToolBox graphicHelper_CreateFlatImageWithSize:imvCouponAvailable.frame.size byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadius:CGSizeMake(10.0, 10.0) andColor:COLOR_MA_GREEN];
    imvCouponRedeemed.image = [ToolBox graphicHelper_CreateFlatImageWithSize:imvCouponRedeemed.frame.size byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadius:CGSizeMake(10.0, 10.0) andColor:COLOR_MA_RED];
    imvCouponBalance.image = [ToolBox graphicHelper_CreateFlatImageWithSize:imvCouponBalance.frame.size byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadius:CGSizeMake(10.0, 10.0) andColor:COLOR_MA_PURPLE];
    //
    imvBonusAvailable.image = [ToolBox graphicHelper_CreateFlatImageWithSize:imvCouponAvailable.frame.size byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadius:CGSizeMake(10.0, 10.0) andColor:COLOR_MA_GREEN];
    imvBonusRedeemed.image = [ToolBox graphicHelper_CreateFlatImageWithSize:imvCouponRedeemed.frame.size byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadius:CGSizeMake(10.0, 10.0) andColor:COLOR_MA_RED];
    imvBonusBalance.image = [ToolBox graphicHelper_CreateFlatImageWithSize:imvCouponBalance.frame.size byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadius:CGSizeMake(10.0, 10.0) andColor:COLOR_MA_PURPLE];

    //Labels:
    lblCouponTitle.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    lblCouponTitle.textColor = [UIColor whiteColor];
    lblBonusTitle.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    lblBonusTitle.textColor = [UIColor whiteColor];
    
    //Titles:
    lblCouponAvailableTitle.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    lblCouponAvailableTitle.textColor = [UIColor whiteColor];
    lblCouponRedeemedTitle.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    lblCouponRedeemedTitle.textColor = [UIColor whiteColor];
    lblCouponBalanceTitle.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    lblCouponBalanceTitle.textColor = [UIColor whiteColor];
    //
    lblBonusAvailableTitle.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    lblBonusAvailableTitle.textColor = [UIColor whiteColor];
    lblBonusRedeemedTitle.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    lblBonusRedeemedTitle.textColor = [UIColor whiteColor];
    lblBonusBalanceTitle.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_BUTTON_BOTTOM];
    lblBonusBalanceTitle.textColor = [UIColor whiteColor];
    
    //Values:
    lblCouponAvailableValue.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:22.0];
    lblCouponAvailableValue.textColor = [UIColor whiteColor];
    lblCouponRedeemedValue.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:22.0];
    lblCouponRedeemedValue.textColor = [UIColor whiteColor];
    lblCouponBalanceValue.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:22.0];
    lblCouponBalanceValue.textColor = [UIColor whiteColor];
    //
    lblBonusAvailableValue.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:22.0];
    lblBonusAvailableValue.textColor = [UIColor whiteColor];
    lblBonusRedeemedValue.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:22.0];
    lblBonusRedeemedValue.textColor = [UIColor whiteColor];
    lblBonusBalanceValue.font = [UIFont fontWithName:FONT_DEFAULT_BOLD size:22.0];
    lblBonusBalanceValue.textColor = [UIColor whiteColor];
    
    //Label
    lblNoData.backgroundColor = nil;
    lblNoData.font = [UIFont fontWithName:FONT_DEFAULT_ITALIC size:FONT_SIZE_TITLE_NAVBAR];
    lblNoData.textColor = [UIColor grayColor];
    lblNoData.text = NSLocalizedString(@"LABEL_PROMOTION_EXTRACT_NO_DATA", @"");
    
    //CUPONS:
    lblCouponTitle.text = NSLocalizedString(@"LABEL_PROMOTION_EXTRACT_COUPONS", @"");
    //
    lblCouponAvailableTitle.text = NSLocalizedString(@"LABEL_PROMOTION_EXTRACT_NF_REGISTERED", @"");
    lblCouponRedeemedTitle.text = NSLocalizedString(@"LABEL_PROMOTION_EXTRACT_NF_CONSUMED", @"");
    lblCouponBalanceTitle.text = NSLocalizedString(@"LABEL_PROMOTION_EXTRACT_NF_BALANCE", @"");
    //
    lblCouponAvailableValue.text = @"";
    lblCouponRedeemedValue.text = @"";
    lblCouponBalanceValue.text = @"";
    
    //BRINDES:
    lblBonusTitle.text = NSLocalizedString(@"LABEL_PROMOTION_EXTRACT_GIFTS", @"");
    //
    lblBonusAvailableTitle.text = NSLocalizedString(@"LABEL_PROMOTION_EXTRACT_GIFT_AVAILABLE", @"");
    lblBonusRedeemedTitle.text = NSLocalizedString(@"LABEL_PROMOTION_EXTRACT_GIFT_CONSUMED", @"");
    lblBonusBalanceTitle.text = NSLocalizedString(@"LABEL_PROMOTION_EXTRACT_NF_BALANCE", @"");
    //
    lblBonusAvailableValue.text = @"";
    lblBonusRedeemedValue.text = @"";
    lblBonusBalanceValue.text = @"";
    
    //NÚMEROS DA SORTE:
    lblTitleLuckyNumbers.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_BUTTON_MENU_OPTION];
    lblTitleLuckyNumbers.textColor = [UIColor whiteColor];
    
    lblTitleLuckyNumbers.text = NSLocalizedString(@"LABEL_PROMOTION_EXTRACT_LUCKY_NUMBERS", @"");
    
    [btnCreateLuckyNumbers setTitle:NSLocalizedString(@"BUTTON_TITLE_CREATE_LUCKY_NUMBERS", @"") forState:UIControlStateNormal];
    btnCreateLuckyNumbers.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:15.0];
    [btnCreateLuckyNumbers setExclusiveTouch:YES];
    [btnCreateLuckyNumbers setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnCreateLuckyNumbers.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(btnCreateLuckyNumbers.frame.size.height / 2.0, btnCreateLuckyNumbers.frame.size.height / 2.0) andColor:COLOR_MA_BLUE] forState:UIControlStateNormal];
    [btnCreateLuckyNumbers setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //btnCreateLuckyNumbers.layer.cornerRadius = btnCreateLuckyNumbers.frame.size.height / 2.0;
    
    [ToolBox graphicHelper_ApplyShadowToView:lblCouponTitle withColor:[UIColor blackColor] offSet:CGSizeMake(0.0, 1.0) radius:2.0 opacity:0.50];
    [ToolBox graphicHelper_ApplyShadowToView:lblBonusTitle withColor:[UIColor blackColor] offSet:CGSizeMake(0.0, 1.0) radius:2.0 opacity:0.50];
    [ToolBox graphicHelper_ApplyShadowToView:lblTitleLuckyNumbers withColor:[UIColor blackColor] offSet:CGSizeMake(0.0, 1.0) radius:2.0 opacity:0.50];
    
    viewCoupon.alpha = 0.0;
    viewBonus.alpha = 0.0;
    viewLuckyNumbers.alpha = 0.0;
    lblNoData.alpha = 0.0;
    
    [self updateBaseScrollHeightSize];
}

- (NSString*)clearMask:(NSString*)text
{
    NSString *result = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"," withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"(" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@")" withString:@""];
    //
    return result;
}

- (void)getExtractFromServer
{
    canShowCouponGenerator = false;
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getExtractsForPromotion:promotion.promotionID withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (!error) {
                if (response) {
                    
                    if ([[response allKeys] containsObject:@"extract"]){
                        
                        NSDictionary *dicStatus = [[NSDictionary alloc] initWithDictionary:[response valueForKey:@"extract"]];
                        
                        NSArray *statusList = [[NSArray alloc] initWithArray:[dicStatus valueForKey:@"itensStatus"]];
                        
                        int componentsFinded = 0;
                        
                        for (NSDictionary *dicItem in statusList){
                            
                            NSString *nome = [dicItem valueForKey:@"nome"];
                            NSString *valor = [dicItem valueForKey:@"valor"];
                            //
                            componentsFinded += [self updateScreenWithName:nome andValue:valor];
                        }
                        
                        if (componentsFinded > 0){
                            [tvLuckyNumbers reloadData];
                            viewCoupon.alpha = 1.0;
                            viewBonus.alpha = 1.0;
                            viewLuckyNumbers.alpha = 1.0;
                            //
                            [self updateBaseScrollHeightSize];
                        }
                        
                    }else{
                        
                        lblNoData.alpha = 1.0;
                    }
                }else{
                    //Erro
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }
            } else {
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
        }];
    } else {
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        //
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (void)postExtractFromServer
{
    canShowCouponGenerator = false;
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager postConsumeExtractBalanceForPromotion:promotion.promotionID andUserCPF:[self clearMask:AppD.loggedUser.CPF] withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (!error) {
                
                if (response) {
                    
                    NSString *status = [response valueForKey:@"status"];
                    
                    if ([status isEqualToString:@"SUCCESS"]){
                        
                        if ([[response allKeys] containsObject:@"extract"]){
                            
                            NSDictionary *dicStatus = [[NSDictionary alloc] initWithDictionary:[response valueForKey:@"extract"]];
                            
                            NSArray *statusList = [[NSArray alloc] initWithArray:[dicStatus valueForKey:@"itensStatus"]];
                            
                            int componentsFinded = 0;
                            
                            for (NSDictionary *dicItem in statusList){
                                
                                NSString *nome = [dicItem valueForKey:@"nome"];
                                NSString *valor = [dicItem valueForKey:@"valor"];
                                //
                                componentsFinded += [self updateScreenWithName:nome andValue:valor];
                            }
                            
                            if (componentsFinded > 0){
                                [tvLuckyNumbers reloadData];
                                viewCoupon.alpha = 1.0;
                                viewBonus.alpha = 1.0;
                                viewLuckyNumbers.alpha = 1.0;
                                //
                                [self updateBaseScrollHeightSize];
                            }
                            
                        }else{
                            
                            lblNoData.alpha = 1.0;
                        }
                        
                    }else{
                        
                        lblNoData.alpha = 1.0;
                    }
                    
                }else{
                    //Erro
                    SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                    [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                }
            } else {
                SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
            }
        }];
    } else {
        
        [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        //
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

- (int)updateScreenWithName:(NSString*)name andValue:(NSString*)value
{
    //Cupons disponíveis:
    if ([name isEqualToString:@"TOTAL_CUPOM_DIREITO"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            lblCouponAvailableValue.text = value;
        });
        return 1;
    }
    
    //Cupons resgatados:
    if ([name isEqualToString:@"TOTAL_CUPOM_TROCADO"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            lblCouponRedeemedValue.text = value;
        });
        return 1;
    }
    
    //Saldo Cupons:
    if ([name isEqualToString:@"SALDO_DE_CUPOM"]){
        double saldo = [ToolBox converterHelper_DecimalValueFromText:value];
        if (saldo >= promotion.minValueToGenerateCoupons && saldo > 0.0){
            canShowCouponGenerator = true;
        }
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            lblCouponBalanceValue.text = value;
        });
        return 1;
    }
    
    //********************************************
    
    //Brindes disponíveis:
    if ([name isEqualToString:@"TOTAL_BRINDE_DIREITO"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            lblBonusAvailableValue.text = value;
        });
        return 1;
    }
    
    //Brindes resgatados:
    if ([name isEqualToString:@"TOTAL_BRINDE_TROCADO"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            lblBonusRedeemedValue.text = value;
        });
        return 1;
    }
    
    //Saldo Brindes:
    if ([name isEqualToString:@"SALDO_DE_BRINDE"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            lblBonusBalanceValue.text = value;
        });
        return 1;
    }
    
    //********************************************
    
    //Números da sorte:
    if ([name isEqualToString:@"NUM_SORTE"]){
        
        luckyNumbersList = [NSMutableArray new];
        NSString *trimS = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *numbers = [trimS componentsSeparatedByString:@"-"];
        
        for (NSString *str in numbers){
            [luckyNumbersList addObject:str];
        }
        
        if (luckyNumbersList.count > 0){
            return 1;
        }else{
            return 0;
        }
    }
    
    return 0;
}

- (void)updateBaseScrollHeightSize
{
    CGFloat couponButtonSize = canShowCouponGenerator ? (6.0 + 32.0 + 6.0) : (6.0);
    CGFloat contentSize = 8.0 + viewCoupon.frame.size.height + 8.0 + viewBonus.frame.size.height + 8.0 + (couponButtonSize) +36.0;
    //O tamanho do content size aumenta para cada item na lista:
    if (luckyNumbersList.count > 0){
        contentSize += (luckyNumbersList.count * 40.0);
    }
    //Caso o tamanho do content seja menor que o próprio scroll, ele fica com o tamanho do scroll:
    if (contentSize < baseScrollView.frame.size.height){
        contentSize = baseScrollView.frame.size.height;
    }
    //Verificando existência do botão na tela
    if (canShowCouponGenerator){
        topConstraintLuckyNumberTableView.constant = 44.0;
        btnCreateLuckyNumbers.alpha = 1.0;
    }else{
        topConstraintLuckyNumberTableView.constant = 6.0;
        btnCreateLuckyNumbers.alpha = 0.0;
    }
    //Atualizando a tela:
    contentHeightConstraint.constant = contentSize;
    [self.view layoutIfNeeded];
}

@end
