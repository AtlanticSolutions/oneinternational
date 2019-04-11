//
//  AddressSearchVC.m
//  LAB360-ObjC
//
//  Created by Erico GT on 03/01/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "AddressSearchVC.h"
#import "AppDelegate.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface AddressSearchVC()

//Data:

//Layout:
@property (nonatomic, strong) IBOutlet UIButton *btnSearch;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBarZipCode;
@property (nonatomic, weak) IBOutlet UITextView* txtMessage;

@end

#pragma mark - • IMPLEMENTATION
@implementation AddressSearchVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize btnSearch, searchBarZipCode, txtMessage;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    
    [self setupLayout:@"Busca CEP"];
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    if ([segue.identifier isEqualToString:@"???"]){
//        AppOptionsVC *vc = segue.destinationViewController;
//    }
//}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

- (IBAction)actionGetZipCodeData:(id)sender
{
    if ([ToolBox textHelper_CheckRelevantContentInString:searchBarZipCode.text]){
        [self.view resignFirstResponder];
        //
        [self getAddressByZipCode:searchBarZipCode.text];
    }
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - Search delegate

//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    searchBar.showsBookmarkButton = YES;
//    //searchBar.showsCancelButton = YES;
//}
//
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    searchBar.text = @"";
//    searchBar.showsCancelButton = NO;
//    [searchBar resignFirstResponder];
//}

//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//    //
//    if ([ToolBox textHelper_CheckRelevantContentInString:searchBar.text]){
//        [self getAddressByZipCode:searchBar.text];
//    }
//}
//
//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    if([searchText isEqualToString:@""]){
//        searchBar.showsCancelButton = NO;
//    }
//    else{
//        searchBar.showsSearchResultsButton = YES;
//        //searchBar.showsCancelButton = YES;
//    }
//}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //SearchBar
    searchBarZipCode.placeholder = @"insira o CEP";
    searchBarZipCode.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
    searchBarZipCode.tintColor = [UIColor whiteColor];
    searchBarZipCode.inputAccessoryView = [self createAcessoryViewForTextView:searchBarZipCode];
    //Para mudar a cor do botão do searchBar sem mudar o cursor:
    for ( UIView *v in [searchBarZipCode.subviews.firstObject subviews] ){
        if ( YES == [v isKindOfClass:[UITextField class]] ){
            [((UITextField*)v) setTintColor:[UIColor darkGrayColor]];
            break;
        }
    }
    
    //TextView
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.maximumLineHeight = 20.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    //
    NSString *finalString = @"";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:finalString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_DEFAULT_REGULAR size:FONT_SIZE_TITLE_NAVBAR] range:NSMakeRange(0, finalString.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, finalString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppD.styleManager.colorPalette.primaryButtonTitleNormal range:NSMakeRange(0, finalString.length)];
    //
    txtMessage.attributedText = attributedString;
    [txtMessage setTextColor:AppD.styleManager.colorPalette.textDark];
    [txtMessage.layer setCornerRadius:5.0];
    [txtMessage.layer setBorderWidth:1.0];
    [txtMessage.layer setBorderColor:AppD.styleManager.colorCalendarAvailable.CGColor];
    [txtMessage setTextContainerInset:UIEdgeInsetsMake(10.0, 0.0, 5.0, 0.0)];
    
    //Button
    btnSearch.backgroundColor = [UIColor clearColor];
    //[btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSearch.titleLabel.font = [UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR];
    [btnSearch setTitle:@"Buscar" forState:UIControlStateNormal];
    [btnSearch setExclusiveTouch:YES];
    [btnSearch setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSearch.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonNormal] forState:UIControlStateNormal];
    [btnSearch setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:btnSearch.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeMake(4.0, 4.0) andColor:AppD.styleManager.colorPalette.primaryButtonSelected] forState:UIControlStateHighlighted];
    UIImage *icon = [UIImage imageNamed:@"RotationalZoomButton"];
    [btnSearch setImage:icon forState:UIControlStateNormal];
    [btnSearch setImageEdgeInsets:UIEdgeInsetsMake(5.0, 20.0, 5.0, 5.0)];
    [btnSearch.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnSearch setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    [btnSearch setTintColor:[UIColor whiteColor]];
    //btnSearch.tag = 1;    
    
}

#pragma mark - UTILS (General Use)

-(UIView*)createAcessoryViewForTextView:(UISearchBar*)searchBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width/2, 40)];
    btnClose.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnClose addTarget:searchBar action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClose.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]];
    [btnClose setTitle:@"Cancelar" forState:UIControlStateNormal];
    [view addSubview:btnClose];
    //
    UIButton *btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 40)];
    btnSearch.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnSearch addTarget:self action:@selector(actionGetZipCodeData:) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSearch.titleLabel setFont:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TEXT_FIELDS]];
    [btnSearch setTitle:@"Buscar" forState:UIControlStateNormal];
    [view addSubview:btnSearch];
    
    return view;
}

#pragma mark - Connection

- (void)getAddressByZipCode:(NSString*)zipCode
{
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.view endEditing:YES];
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager findAddressByCEP:zipCode withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            if(error){
                txtMessage.text = error.localizedDescription;
            }
            else{
                
                if (![[response allKeys] containsObject:@"erro"]){
                    
                    //    {
                    //        "cep": "18103-540",
                    //        "logradouro": "Rua Picolomo Cataldo",
                    //        "complemento": "",
                    //        "bairro": "Jardim Carolina",
                    //        "localidade": "Sorocaba",
                    //        "uf": "SP",
                    //        "unidade": "",
                    //        "ibge": "3552205",
                    //        "gia": "6695"
                    //    }
                    
                    NSString *message = [NSString stringWithFormat:@"CEP encontrado: \n\n%@\n\n[%@]\nhttps://viacep.com.br/ws/%@/json/", response, [ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_BARRA_COMPLETA_NORMAL], zipCode];
                    txtMessage.text = message;
                    
                }else{
                    
                    NSString *message = [NSString stringWithFormat:@"CEP não encontrado.\n\n%@\n\n[%@]\nhttps://viacep.com.br/ws/%@/json/", [response valueForKey:@"erro"], [ToolBox dateHelper_StringFromDate:[NSDate date] withFormat:TOOLBOX_DATA_BARRA_COMPLETA_NORMAL], zipCode];
                    txtMessage.text = message;
                    
                    //txtMessage.text = @"CEP não encontrado.";
                    
                }
            }
            
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
        }];
    }
    
}
@end
