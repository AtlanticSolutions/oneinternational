//
//  VC_Promotions.m
//  ShoppingBH
//
//  Created by Erico GT on 01/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_Promotions.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_Promotions()

//Layout:
@property (nonatomic, weak) IBOutlet UITableView *tvPromotions;
@property (nonatomic, weak) IBOutlet UILabel *lblNoData;

//Data:
@property (nonatomic, strong) NSMutableArray<ShoppingPromotion*> *promotionsList;
@property (nonatomic, strong) ShoppingPromotion *selectedPromotion;
@property (nonatomic, assign) bool isLoaded;
@property (nonatomic, assign) bool tapInPromotionResolved;
@property (nonatomic, strong) UIImage *placeholderImage;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_Promotions
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize tvPromotions, lblNoData;
@synthesize promotionsList, selectedPromotion, isLoaded, placeholderImage, tapInPromotionResolved;

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
    self.navigationItem.leftBarButtonItem = [AppD createProfileButton];

    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_PROMOTIONS", @"");
    
    tvPromotions.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    promotionsList = [NSMutableArray new];
    
    placeholderImage = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
    
    tapInPromotionResolved = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
    if (!isLoaded){
        [self setupLayout];
        //
        [self getPromotionsData];
        //
        isLoaded = true;
        
        //TODO: mock
//        promotionsList = [NSMutableArray new];
//        //
//        ShoppingPromotion *p1 = [ShoppingPromotion new];
//        p1.promotionID = 1;
//        p1.name = @"Promoção 1";
//        p1.urlImage = @"http://wowslider.com/sliders/demo-10/data/images/dock.jpg";
//        p1.urlTerms = @"";
//        p1.isUserRegistered = false;
//        [promotionsList addObject:p1];
//        //
//        ShoppingPromotion *p2 = [ShoppingPromotion new];
//        p2.promotionID = 2;
//        p2.name = @"Promoção 2";
//        p2.urlImage = @"https://www.jssor.com/demos/img/gallery/980x380/011.jpg";
//        p2.urlTerms = @"";
//        p2.isUserRegistered = true;
//        [promotionsList addObject:p2];
//        //
//        [tvPromotions reloadData];
//        tvPromotions.alpha = 1.0;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    //
    if ([segue.identifier isEqualToString:@"SegueToPromotionRegister"]){
        VC_PromotionRegister *vcPR = (VC_PromotionRegister*)segue.destinationViewController;
        vcPR.promotion = [selectedPromotion copyObject];
    }
    else if ([segue.identifier isEqualToString:@"SegueToPromotionExtract"]){
        VC_PromotionsExtract *vcPE = (VC_PromotionsExtract*)segue.destinationViewController;
        vcPE.promotion = [selectedPromotion copyObject];
    }
    else if([segue.identifier isEqualToString:@"SegueToTerms"]){
        VC_TermsAndRules *termsVC = [segue destinationViewController];
        //
        termsVC.screenType = eTermsAndRulesScreenType_Promotion;
        termsVC.webItem = [WebItemToShow new];
        termsVC.webItem.urlString = selectedPromotion.urlTerms;
        termsVC.webItem.titleMenu = selectedPromotion.name;
        //
        tapInPromotionResolved = true;
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)actionPromotion:(UIButton*)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    selectedPromotion = [promotionsList objectAtIndex:sender.tag];
    //
    if (selectedPromotion.isUserRegistered){
        [self performSegueWithIdentifier:@"SegueToPromotionExtract" sender:self];
    }else{
        [self performSegueWithIdentifier:@"SegueToPromotionRegister" sender:self];
    }
}

- (IBAction)actionPromotionRules:(UIButton*)sender
{
    if (tapInPromotionResolved){
        tapInPromotionResolved = false;
        long index = sender.tag;
        selectedPromotion = [promotionsList objectAtIndex:index];
        //
        [self performSegueWithIdentifier:@"SegueToTerms" sender:nil];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return promotionsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierGroup = @"PromotionCell";
    
    TVC_PromotionBanner *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierGroup];
    
    if(cell == nil)
    {
        cell = [[TVC_PromotionBanner alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierGroup];
    }
    
    [cell updateLayout];
    //
    ShoppingPromotion *promotion = [promotionsList objectAtIndex:indexPath.row];
    //
    cell.imvBanner.tag = indexPath.row;
    //
    [cell.activityIndicator startAnimating];
    [cell.imvBanner setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:promotion.urlImage]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        [cell.activityIndicator stopAnimating];
        cell.imvBanner.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [cell.activityIndicator stopAnimating];
        //cell.imvBanner.image = placeholderImage;
    }];
    
    if (promotion.isUserRegistered){
        cell.lblRegistered.alpha = 1.0;
        [cell.btnRegister setTitle:NSLocalizedString(@"BUTTON_TITLE_PROMOTION_DONE_REGISTER", @"") forState:UIControlStateNormal];
        [cell.btnRegister setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:cell.btnRegister.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:COLOR_MA_GREEN] forState:UIControlStateNormal];
        //
        //[cell.imvBanner addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnPromotionBanner:)]];
    }else{
        cell.lblRegistered.alpha = 0.0;
        [cell.btnRegister setTitle:NSLocalizedString(@"BUTTON_TITLE_SIGNUP_PROMOTION", @"") forState:UIControlStateNormal];
        [cell.btnRegister setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:cell.btnRegister.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(5.0, 5.0) andColor:AppD.styleManager.colorPalette.backgroundNormal] forState:UIControlStateNormal];
    }
    
    [cell.btnTermsAndRules setTitle:NSLocalizedString(@"BUTTON_TITLE_TERMS_AND_RULES", @"") forState:UIControlStateNormal];
    
    cell.btnRegister.tag = indexPath.row;
    cell.btnTermsAndRules.tag = indexPath.row;
    //[cell.btnRegister addTarget:self action:@selector(actionPromotion:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 252.0;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    //Background
    self.view.backgroundColor = [UIColor whiteColor];
    tvPromotions.backgroundColor = nil;
    lblNoData.backgroundColor = nil;
    
    //Label
    lblNoData.font = [UIFont fontWithName:FONT_DEFAULT_ITALIC size:FONT_SIZE_TITLE_NAVBAR];
    lblNoData.textColor = [UIColor grayColor];
    lblNoData.text = NSLocalizedString(@"LABEL_PROMOTION_NO_DATA", @"");
    lblNoData.alpha = 0.0;
    //
    
}

- (void)getPromotionsData
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getAvailablePromotionsWithCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (!error) {
                if (response) {
                    
                    if ([[response allKeys] containsObject:@"promotions"]){
                        
                        NSArray *pList = [[NSArray alloc] initWithArray:[response valueForKey:@"promotions"]];
                        
                        promotionsList = [NSMutableArray new];
                        
                        for (NSDictionary *dic in pList){
                            [promotionsList addObject:[ShoppingPromotion createObjectFromDictionary:dic]];
                        }
                        
                        if (promotionsList.count > 0){
                            [tvPromotions reloadData];
                            tvPromotions.alpha = 1.0;
                            lblNoData.alpha = 0.0;
                        }else{
                            tvPromotions.alpha = 0.0;
                            lblNoData.alpha = 1.0;
                        }
                        
                    }else{
                        //Erro
                        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
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

@end
