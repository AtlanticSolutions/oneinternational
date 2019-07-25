//
//  VC_MyInvoices.m
//  ShoppingBH
//
//  Created by Erico GT on 03/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_MyInvoices.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_MyInvoices()

//Layout
@property (nonatomic, weak) IBOutlet UITableView *tvMyInvoices;
@property (nonatomic, weak) IBOutlet UILabel *lblFooterMessage;
@property (nonatomic, weak) IBOutlet UILabel *lblNoData;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

//Data
@property(nonatomic, strong) NSMutableArray *invoicesList;
@property(nonatomic, assign) bool isLoaded;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_MyInvoices
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize tvMyInvoices, lblFooterMessage, lblNoData, refreshControl;
@synthesize invoicesList, isLoaded;

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
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_MY_INVOICES", @"");
    
    UINib *cellNib = [UINib nibWithNibName:@"TVC_InvoiceItem" bundle:nil];
    [tvMyInvoices registerNib:cellNib forCellReuseIdentifier:@"InvoiceItemCell"];
    
    tvMyInvoices.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
    tvMyInvoices.alpha = 0.0;
    lblNoData.alpha = 0.0;
    lblFooterMessage.alpha = 0.0;
    
    [self getMyInvoices];
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

- (void)photoViewDidHide:(VIPhotoView *)photoView
{
    __block id pv = photoView;
    
    [UIView animateWithDuration:0.3 animations:^{
        photoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [pv removeFromSuperview];
        pv = nil;
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!refreshControl.refreshing){
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:AppD.styleManager.colorPalette.backgroundNormal forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LABEL_POST_REFRESH_CONTROL_PULL_TO_UPDATE", @"") attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return invoicesList.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"InvoiceItemCell";
    
    TVC_InvoiceItem *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[TVC_InvoiceItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell updateLayout];
    
    PromotionInvoice *invoice = [invoicesList objectAtIndex:indexPath.row];
    
    NSString *strDate = NSLocalizedString(@"LABEL_POINTS_DATE", @"");
    NSString *strStore = NSLocalizedString(@"LABEL_POINTS_STORE", @"");
    NSString *strValue = NSLocalizedString(@"LABEL_ORDERS_PRICE", @"");
    
    //Data:
    if ([invoice.storeName isEqualToString:@""]){
        if ([invoice.cnpj isEqualToString:@""]){
            cell.lblTitle.text = [NSString stringWithFormat:@"%@: -", strStore];
        }else{
            cell.lblTitle.text = [NSString stringWithFormat:@"CNPJ: %@", invoice.cnpj];
        }
    }else{
        cell.lblTitle.text = invoice.storeName;
    }
    cell.lblPrice.text = [NSString stringWithFormat:@"%@: %@", strValue, [ToolBox converterHelper_MonetaryStringForValue:invoice.totalAmount]];
    NSString *sDate = [ToolBox dateHelper_StringFromDate:invoice.invoiceDate withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
    cell.lblDate.text = ([sDate isEqualToString:@""] ? [NSString stringWithFormat:@"%@: -", strDate] : sDate);
    cell.lblCOO.text = ([invoice.nf isEqualToString:@""] ? @"COO: -" : [NSString stringWithFormat:@"COO: %@", invoice.nf]);;
    
    cell.lblStatusDate.text = [ToolBox dateHelper_StringFromDate:invoice.statusDate withFormat:TOOLBOX_DATA_BARRA_CURTA_NORMAL];
    //
    cell.lblStatus.text = invoice.statusText;
    cell.viewStatus.backgroundColor = invoice.statusColor;
    
//    if ([invoice.status isEqualToString:@"pending"]){
//        cell.lblStatus.text = NSLocalizedString(@"LABEL_MY_INVOICES_STATUS_PENDING", @"");
//        cell.viewStatus.backgroundColor = COLOR_MA_YELLOW;
//    }else if ([invoice.status isEqualToString:@"proccessed"]){
//        cell.lblStatus.text = NSLocalizedString(@"LABEL_MY_INVOICES_STATUS_PROCESSED", @"");
//        cell.viewStatus.backgroundColor = COLOR_MA_GREEN;
//    }else if ([invoice.status isEqualToString:@"invalid"]){
//        cell.lblStatus.text = NSLocalizedString(@"LABEL_MY_INVOICES_STATUS_INVALID", @"");
//        cell.viewStatus.backgroundColor = COLOR_MA_RED;
//    }else if ([invoice.status isEqualToString:@"analysing"]){
//        cell.lblStatus.text = NSLocalizedString(@"LABEL_MY_INVOICES_STATUS_ANALISING", @"");
//        cell.viewStatus.backgroundColor = COLOR_MA_BLUE;
//    }
    
    [cell.spinner startAnimating];
    [cell.imvInvoice setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:invoice.imageURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        [cell.spinner stopAnimating];
        cell.imvInvoice.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [cell.spinner stopAnimating];
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVC_InvoiceItem *cell = (TVC_InvoiceItem*)[tableView cellForRowAtIndexPath:indexPath];
    
    PromotionInvoice *invoice = [invoicesList objectAtIndex:indexPath.row];
    
    if ([invoice.status isEqualToString:@"invalid"] && (![invoice.statusDisapprovalMessage isEqualToString:@""] && invoice.statusDisapprovalMessage != nil)){
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        //
        if (cell.imvInvoice.image != nil && (cell.imvInvoice.image.size.height > 0.0 || cell.imvInvoice.image.size.width > 0.0)){
            
            [alert addButton:NSLocalizedString(@"ALERT_OPTION_SEE_INVOICE", @"") withType:SCLAlertButtonType_Normal actionBlock:^{
                [cell setBackgroundColor:AppD.styleManager.colorPalette.backgroundNormal];
                //UI - Animação de seleção
                [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    [cell setBackgroundColor:nil];
                } completion:nil];
                //
                VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:cell.imvInvoice.image backgroundImage:nil andDelegate:self];
                photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
                photoView.autoresizingMask = (1 << 6) -1;
                photoView.alpha = 0.0;
                //
                [AppD.window addSubview:photoView];
                [AppD.window bringSubviewToFront:photoView];
                //
                [UIView animateWithDuration:0.3 animations:^{
                    photoView.alpha = 1.0;
                }];
            }];
            
        }
        //
        [alert addButton:NSLocalizedString(@"ALERT_OPTION_CLOSE", @"") withType:SCLAlertButtonType_Neutral actionBlock:nil];
        //
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_INVALID_INVOICE", @"") subTitle:invoice.statusDisapprovalMessage closeButtonTitle:nil duration:0.0];
    }else{
        
        //A imagem precisa existir e possuir tamanho válido:
        if (cell.imvInvoice.image != nil && (cell.imvInvoice.image.size.height > 0.0 || cell.imvInvoice.image.size.width > 0.0)){
            [cell setBackgroundColor:AppD.styleManager.colorPalette.backgroundNormal];
            //UI - Animação de seleção
            [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [cell setBackgroundColor:nil];
            } completion:nil];
            //
            VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds image:cell.imvInvoice.image backgroundImage:nil andDelegate:self];
            photoView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
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
    }
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
    
    tvMyInvoices.backgroundColor = [UIColor whiteColor];
    //
    lblFooterMessage.backgroundColor = nil;
    lblFooterMessage.font = [UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_LABEL_SMALL];
    lblFooterMessage.textColor = COLOR_MA_RED;
    lblFooterMessage.text = NSLocalizedString(@"LABEL_MY_INVOICES_FOOTER", @"");
    
    //Label
    lblNoData.backgroundColor = nil;
    lblNoData.font = [UIFont fontWithName:FONT_DEFAULT_ITALIC size:FONT_SIZE_TITLE_NAVBAR];
    lblNoData.textColor = [UIColor grayColor];
    lblNoData.text = NSLocalizedString(@"LABEL_MY_INVOICES_NO_DATA", @"");
    lblNoData.alpha = 0.0;
    
    //Refresh Control
    refreshControl = [UIRefreshControl new];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = AppD.styleManager.colorPalette.backgroundNormal;
    //
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:AppD.styleManager.colorPalette.backgroundNormal forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LABEL_POST_REFRESH_CONTROL_PULL_TO_UPDATE", @"") attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    //
    //[tvMyInvoices addSubview:refreshControl];
    [tvMyInvoices insertSubview:refreshControl atIndex:0];
    [refreshControl addTarget:self action:@selector(refreshControlUpdate) forControlEvents:UIControlEventValueChanged];
}

- (void)getMyInvoices
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:AppD.styleManager.colorPalette.backgroundNormal forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LABEL_POST_REFRESH_CONTROL_UPDATING", @"") attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [connectionManager getMyInvoicesWithCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            [refreshControl endRefreshing];
            
            if (!error) {
                if (response) {
                    
                    if ([[response allKeys] containsObject:@"nfs"]){
                        
                        NSArray *pList = [[NSArray alloc] initWithArray:[response valueForKey:@"nfs"]];
                        
                        invoicesList = [NSMutableArray new];
                        
                        for (NSDictionary *dic in pList){
                            [invoicesList addObject:[PromotionInvoice createObjectFromDictionary:dic]];
                        }
                        
                        if (invoicesList.count > 0){
                            
                            //ordenando:
                            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"statusDate" ascending:NO];
                            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                            invoicesList = [[NSMutableArray alloc] initWithArray:[invoicesList sortedArrayUsingDescriptors:sortDescriptors]];
                            //
                            [tvMyInvoices reloadData];
                            tvMyInvoices.alpha = 1.0;
                            lblNoData.alpha = 0.0;
                            lblFooterMessage.alpha = 1.0;
                        }else{
                            tvMyInvoices.alpha = 0.0;
                            lblNoData.alpha = 1.0;
                            lblFooterMessage.alpha = 0.0;
                        }
                        
                    }else{
                        
                        tvMyInvoices.alpha = 0.0;
                        lblNoData.alpha = 1.0;
                        lblFooterMessage.alpha = 0.0;
                        
                        //Erro
                        //SCLAlertViewPlus *alert = [AppD createDefaultAlert];
                        //[alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_GET_PROMOTIONS_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
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

-(void)refreshControlUpdate
{
    [self getMyInvoices];
}

@end
