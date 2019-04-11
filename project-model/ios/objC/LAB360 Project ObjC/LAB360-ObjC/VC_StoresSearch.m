//
//  VC_StoresSearch.m
//  ShoppingBH
//
//  Created by Erico GT on 06/11/17.
//  Copyright © 2017 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_StoresSearch.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_StoresSearch()

//Layout
@property (nonatomic, strong) IBOutlet UISearchBar *searchBarStores;
@property (nonatomic, weak) IBOutlet UITableView *tvStores;
@property (nonatomic, weak) IBOutlet UILabel *lblNoData;
//Data
@property (nonatomic, strong) ShoppingStore *selectedStore;
@property (nonatomic, strong) NSMutableArray *storesList;
@property (nonatomic, strong) NSArray *filteredList;
@property (nonatomic, assign) BOOL isSeaching;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL isTouchResolved;
@property (nonatomic, strong) UIImage *placeholderImage;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_StoresSearch
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize searchBarStores, tvStores, lblNoData;
@synthesize storesList, filteredList, isSeaching, isTouchResolved, isLoaded, placeholderImage;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //Title
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    self.navigationItem.title = NSLocalizedString(@"SIDE_MENU_OPTION_6_STORES",@"");
    
    self.navigationItem.leftBarButtonItem = [AppD createProfileButton];
    
    tvStores.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    storesList = [NSMutableArray new];
    filteredList = [NSMutableArray new];
    
    UINib *cellNib = [UINib nibWithNibName:@"TVC_StoreItem" bundle:nil];
    [self.tvStores registerNib:cellNib forCellReuseIdentifier:@"StoreCell"];
    
    placeholderImage = [UIImage imageNamed:@"cell-sponsor-image-placeholder"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded){
        [self.view layoutIfNeeded];
        [self setupLayout];
        
        searchBarStores.alpha = 0.0;
        tvStores.alpha = 0.0;
        
        isLoaded = true;
        
        [self getStoresFromServer];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    UIViewController *topVC = AppD.rootViewController.navigationController.topViewController;
//    topVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    if ([segue.identifier isEqualToString:@"SegueToStoreDetail"]){
//        VC_StoreDetail *vcDestination = (VC_StoreDetail*)segue.destinationViewController;
//        //vcDestination.selectedProduct = [selectedProduct copyObject];
//    }
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - Search delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    isSeaching = YES;
    searchBar.showsCancelButton = YES;
    filteredList = storesList;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    self.isSeaching = NO;
    searchBar.text = @"";
    searchBar.showsCancelButton = NO;
    filteredList = storesList;
    [tvStores reloadData];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if([searchText isEqualToString:@""]){
        self.filteredList = storesList;
    }
    else{
        NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@ || %K contains[cd] %@", @"storeName", searchText, @"segment", searchText];
        self.filteredList = [storesList filteredArrayUsingPredicate:predicateString];
    }
    
    [tvStores reloadData];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filteredList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierGroup = @"StoreCell";
    
    TVC_StoreItem *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierGroup];

    if(cell == nil)
    {
        cell = [[TVC_StoreItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierGroup];
    }

    [cell updateLayout];

    ShoppingStore *store = [filteredList objectAtIndex:indexPath.row];
    
    cell.lblTitle.text = store.storeName;
    //
    cell.lblDescription1.text = [NSString stringWithFormat:@"Segmento: %@\n", ([store.segment isEqualToString:@""] ? @"-" : store.segment)];
    cell.lblDescription2.text = [NSString stringWithFormat:@"Tel.: %@\n", ([store.phoneNumber isEqualToString:@""] ? @"-" : store.phoneNumber)];
    cell.lblDescription3.text = [NSString stringWithFormat:@"Piso: %@\n", ([store.floor isEqualToString:@""] ? @"-" : store.floor)];
    
    [cell.spinner startAnimating];
    [cell.imvLogo setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:store.logoURL]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        [cell.spinner stopAnimating];
        cell.imvLogo.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [cell.spinner stopAnimating];
        cell.imvLogo.image = placeholderImage;
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //O toque na célula é tratado desta forma pois a animação e o processo a ser executado ocorrem na main thread, o que impede a execução da animação da forma correta.
    //Controlando por uma variável, impedimos que dois toques seguidos sejam iniciados.
    [self.view endEditing:YES];
    
    if (isTouchResolved)
    {
        isTouchResolved = false;

        TVC_StoreItem *cell = (TVC_StoreItem*)[tableView cellForRowAtIndexPath:indexPath];
        [cell setBackgroundColor:AppD.styleManager.colorBackground];

        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [cell setBackgroundColor:nil];
        } completion:^(BOOL finished) {
            nil;
        }];

        _selectedStore = [filteredList objectAtIndex:indexPath.row];

        //Resolução da seleção
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ANIMA_TIME_SUPER_FAST * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self selectionResolveForIndex:indexPath.row];
        });
    }
}
*/

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    
    //Background
    self.view.backgroundColor = [UIColor whiteColor];
    tvStores.backgroundView = nil;
    
    //SearchBar
    self.searchBarStores.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
    self.searchBarStores.tintColor = [UIColor whiteColor];
    //Para mudar a cor do botão do searchBar sem mudar o cursor:
    for ( UIView *v in [self.searchBarStores.subviews.firstObject subviews] )
    {
        if ( YES == [v isKindOfClass:[UITextField class]] )
        {
            [((UITextField*)v) setTintColor:[UIColor darkGrayColor]];
            break;
        }
    }
    
    //Label
    lblNoData.backgroundColor = nil;
    lblNoData.font = [UIFont fontWithName:FONT_DEFAULT_ITALIC size:FONT_SIZE_TITLE_NAVBAR];
    lblNoData.textColor = [UIColor grayColor];
    lblNoData.text = @"Ops!\nNenhuma loja foi encontrada no momento.";
    
    tvStores.alpha = 0.0;
    searchBarStores.alpha = 0.0;
    lblNoData.alpha = 0.0;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    //
    [UIView animateWithDuration:0.2 animations:^{
        tvStores.contentInset = contentInsets;
        tvStores.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    [UIView animateWithDuration:0.2 animations:^{
        tvStores.contentInset = UIEdgeInsetsZero;
        tvStores.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

- (void)selectionResolveForIndex:(long)index
{
    [self performSegueWithIdentifier:@"SegueToStoreDetail" sender:self];
    isTouchResolved = YES;
}

- (void)getStoresFromServer
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getShoppingStoresWithCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (!error) {
                if (response) {
                    
                    if ([[response allKeys] containsObject:@"stores"]){
                        
                        NSArray *pList = [[NSArray alloc] initWithArray:[response valueForKey:@"stores"]];
                        
                        storesList = [NSMutableArray new];
                        
                        for (NSDictionary *dic in pList){
                            [storesList addObject:[ShoppingStore createObjectFromDictionary:dic]];
                        }
                        
                        //ordenação dos dados:
                        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"storeName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                        storesList = [[NSMutableArray alloc] initWithArray:[storesList sortedArrayUsingDescriptors:sortDescriptors]];
                        
                        if (storesList.count > 0){
                            filteredList = [[NSMutableArray alloc] initWithArray:storesList];
                            [tvStores reloadData];
                            tvStores.alpha = 1.0;
                            searchBarStores.alpha = 1.0;
                            lblNoData.alpha = 0.0;
                        }else{
                            tvStores.alpha = 0.0;
                            searchBarStores.alpha = 0.0;
                            lblNoData.alpha = 1.0;
                        }
                        
                    }else{
                        
                        tvStores.alpha = 0.0;
                        searchBarStores.alpha = 0.0;
                        lblNoData.alpha = 1.0;
                        
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

@end
