//
//  VC_DocumentList.m
//  CozinhaTudo
//
//  Created by lucas on 18/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_DocumentList.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_DocumentList()

@property(nonatomic, weak) IBOutlet UITableView *tbvDocments;
@property(nonatomic, strong) NSMutableArray *docList;
@property(nonatomic, weak) IBOutlet UISearchBar *srbDocument;
@property(nonatomic, strong) DownloadItem *selectedDocument;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint *tbvTopSpace;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_DocumentList
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize selectedCateogry, docList, tbvDocments, selectedDocument, srbDocument, showSearchBar, tbvTopSpace;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    docList = [[NSMutableArray alloc] init];
    [tbvDocments setTableFooterView:[UIView new]];
    tbvDocments.delegate = self;
    tbvDocments.dataSource = self;
    srbDocument.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(showSearchBar) {
        showSearchBar = false;
        tbvTopSpace.constant = 56;
    } else {
        tbvTopSpace.constant = 0;
        [srbDocument setHidden:YES];
    }
    
    [self.view layoutIfNeeded];
    [self setupLayout];
    [self setupData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"Segue_DocViewer"]) {
        
        VC_WebFileShareViewer *vcViewer = (VC_WebFileShareViewer *)[segue destinationViewController];
        vcViewer.fileType = selectedDocument.fileExtension;
        vcViewer.fileURL = selectedDocument.urlFile;
        vcViewer.fileTitle = selectedDocument.title;
    }
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - SEARCH DELEGATE
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.text = @"";
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    NSLog(@"%i", AppD.loggedUser.userID);
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getDocumentsWithLimit:@"" offset:@"" documentId:@"" category_id:@"" subcategory_id:@"" tag:searchBar.text withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD hideLoadingAnimation];
            
            if(error) {
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_MASTER_DOWNLOAD_NODATA_RESPONSE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            } else {
                
                if(response) {
                    
                    [docList removeAllObjects];
                    NSArray *tempArray = [response valueForKey:@"documents"];
                    
                    for (NSDictionary *docDic in tempArray) {
                        
                        DownloadItem *document = [DownloadItem createObjectFromDictionary:docDic];
                        [docList addObject:document];
                    }
                    
                    [tbvDocments reloadData];
                }
            }
            
        }];
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
}

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return docList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TVC_DocumentItem *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellDocument"];
    DownloadItem *document = [docList objectAtIndex:indexPath.row];
    
    cell.lblDocTitle.text = document.title;
    if (!document.imgThumb){
        
        [[[AsyncImageDownloader alloc] initWithFileURL:document.thumbUrl successBlock:^(NSData *data) {
            
            UIImage *img = nil;
            
            if (data != nil){
                img = [UIImage imageWithData:data];
                
                DownloadItem *doc = [docList objectAtIndex:indexPath.row];
                doc.imgThumb = img;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    TVC_DocumentItem *updateCell = (id)[tbvDocments cellForRowAtIndexPath:indexPath];
                    if (updateCell){
                        updateCell.imvDoc.image = img;
                    }
                });
            }
            
        } failBlock:^(NSError *error) {
            NSLog(@"Erro ao buscar imagem: %@", error.domain);
        }] startDownload];
    } else {
        cell.imvDoc.image = document.imgThumb;
        [cell.imvDoc setBackgroundColor:nil];
    }
    
    [cell updateLayout];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedDocument = [docList objectAtIndex:indexPath.row];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self performSegueWithIdentifier:@"Segue_DocViewer" sender:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0f;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //Navigation Controller
    self.navigationItem.title = NSLocalizedString(@"SCREEN_TITLE_DOWNLOADS", nil);
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    //self.navigationController.toolbar.translucent = YES;
    //self.navigationController.toolbar.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
    //
    srbDocument.placeholder = NSLocalizedString(@"PLACEHOLDER_DOCUMENT_SEARCH", nil);
    srbDocument.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
}

-(void) setupData {
    
    NSString *subcatId = @"";
    
    for (DocVidCategory* cat in selectedCateogry.subcategoryArray) {
        if(cat.selected) {
            self.navigationItem.title = cat.name;
            subcatId = [NSString stringWithFormat:@"%li", cat.idCategory];
            break;
        }
    }
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    NSLog(@"%i", AppD.loggedUser.userID);
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getDocumentsWithLimit:@"" offset:@"" documentId:@"" category_id:[NSString stringWithFormat:@"%li", selectedCateogry.idCategory] subcategory_id:subcatId tag:@"" withCompletionHandler:^(NSDictionary *response, NSInteger statusCode, NSError *error) {
            
            [AppD hideLoadingAnimation];
            
            if(error) {
                
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_MASTER_DOWNLOAD_NODATA_RESPONSE", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                
            } else {
                
                if(response) {
                    
                    [docList removeAllObjects];
                    NSArray *tempArray = [response valueForKey:@"documents"];
                    
                    for (NSDictionary *docDic in tempArray) {
                        
                        DownloadItem *document = [DownloadItem createObjectFromDictionary:docDic];
                        [docList addObject:document];
                    }
                    
                    [tbvDocments reloadData];
                }
            }
            
        }];
    }
    else
    {
        SCLAlertView *alert = [AppD createDefaultAlert];
        [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_NO_CONNECTION", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_NO_CONNECTION", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
    }
    
}

@end
