//
//  VC_Category.m
//  CozinhaTudo
//
//  Created by lucas on 12/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_Category.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_Category()

@property (nonatomic, weak) IBOutlet UITableView *tbvCategory;
@property (nonatomic, strong) NSArray *categoriesList;
@property (nonatomic, strong) DocVidCategory *selectedCategory;
@property (nonatomic, assign) BOOL showSearch;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_Category
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize tbvCategory;
@synthesize categoriesList, categoryType, selectedCategory, showSearch;
#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tbvCategory.delegate = self;
    self.tbvCategory.dataSource = self;
    
    [tbvCategory registerNib:[UINib nibWithNibName:@"DocVidCategory" bundle:nil] forCellReuseIdentifier: @"CustomCellCategory"];
    [tbvCategory setTableFooterView:[UIView new]];
    categoriesList = [[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    showSearch = false;
    
    [self.view layoutIfNeeded];
    [self setupData];
    
    if(categoryType == eCategoryType_Video) {
        [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_FEED_VIDEOS", @"")];
    } else if (categoryType == eCategoryType_Document) {
        [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_DOWNLOADS", @"")];
    } else if(categoryType == eCategoryType_Product) {
        [self setupLayout:NSLocalizedString(@"SCREEN_TITLE_PRODUCTS", @"")];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"Segue_SubCat"]) {
        
        VC_SubCategory *vcsub = (VC_SubCategory*)[segue destinationViewController];
        vcsub.categoryType = self.categoryType;
        vcsub.selectedCategory = self.selectedCategory;
    } else if([segue.identifier isEqualToString:@"Segue_VideoList"]) {
        
        VC_VideoPreviewList *vclist = (VC_VideoPreviewList *)[segue destinationViewController];
        vclist.selectedCategory = self.selectedCategory;
        vclist.showSearchBar = self.showSearch;
        
    } else if ([segue.identifier isEqualToString:@"Segue_DocumentList"]) {
        
        VC_DocumentList *vcDocList = (VC_DocumentList *)[segue destinationViewController];
        vcDocList.selectedCateogry = self.selectedCategory;
        vcDocList.showSearchBar = self.showSearch;
        
    } else if ([segue.identifier isEqualToString:@""]) {
        
    }
    
    tbvCategory.tag = 0;
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS
-(void) touchSearchButton {
    
    showSearch = true;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    if(categoryType == eCategoryType_Video) {
        
        [self performSegueWithIdentifier:@"Segue_VideoList" sender:nil];
        
    } else if(categoryType == eCategoryType_Product) {
        
        [self performSegueWithIdentifier:@"" sender:nil];
        
    } else if(categoryType == eCategoryType_Document) {
        
        [self performSegueWithIdentifier:@"Segue_DocumentList" sender:nil];
    }
    
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categoriesList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TVC_DocVidCategory *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellCategory"];
    DocVidCategory *cat = [categoriesList objectAtIndex:indexPath.row];
    
    cell.lblCategory.text = cat.name;
    //
    if (cat.imgCategory == nil){
        
        [cell.imvCategory setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:cat.imageUrl]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            cell.imvCategory.image = image;
            cat.imgCategory = image;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {

            cell.imvCategory.image = nil;
        }];
    }else{
        cell.imvCategory.image = cat.imgCategory;
    }

    UIImage *imgFolder = [UIImage imageNamed:@"folder"];
    cell.imvFolder.image = imgFolder;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0)
    {
        tableView.tag = 1;
        
        TVC_DocVidCategory *cell = (TVC_DocVidCategory*)[tableView cellForRowAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion:^(BOOL finished) {
            
            selectedCategory = [categoriesList objectAtIndex:indexPath.row];
            if(selectedCategory.subcategoryArray.count != 0) {
                
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                [self performSegueWithIdentifier:@"Segue_SubCat" sender:nil];
                
            } else {
                
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
                if(categoryType == eCategoryType_Video) {
                    
                    [self performSegueWithIdentifier:@"Segue_VideoList" sender:nil];
                    
                } else if(categoryType == eCategoryType_Product) {
                    
                    [self performSegueWithIdentifier:@"" sender:nil];
                    
                } else if(categoryType == eCategoryType_Document) {
                    
                    [self performSegueWithIdentifier:@"Segue_DocumentList" sender:nil];
                }
            }
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout:(NSString*)screenName
{
    [super setupLayout:screenName];
    
    //Button Profile User
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //    if (loggedUser.profilePic){
    //        [userButton setImage:loggedUser.profilePic forState:UIControlStateNormal];
    //        [userButton setImage:loggedUser.profilePic forState:UIControlStateHighlighted];
    //    }else{
    UIImage *img = [[UIImage imageNamed:@"RotationalZoomButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [userButton setImage:img forState:UIControlStateNormal];
    [userButton setImage:img forState:UIControlStateHighlighted];
    //    }
    [userButton setFrame:CGRectMake(0, 0, 32, 32)];
    [userButton setClipsToBounds:YES];
    //[userButton.layer setCornerRadius:16];
    [userButton setExclusiveTouch:YES];
    [userButton setTintColor:AppD.styleManager.colorPalette.textNormal];
    [userButton addTarget:self action:@selector(touchSearchButton) forControlEvents:UIControlEventTouchUpInside];
    //
    [[userButton.widthAnchor constraintEqualToConstant:32.0] setActive:YES];
    [[userButton.heightAnchor constraintEqualToConstant:32.0] setActive:YES];
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    
}

-(void) setupData {
    
    ConnectionManager *connectionManager = [[ConnectionManager alloc] init];
    
    if ([connectionManager isConnectionActive])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
        });
        
        [connectionManager getCategories:[NSString stringWithFormat:@"%i", categoryType] limit:@"" offset:@"" category_id:@"" withCompletionHandler:^(NSDictionary * _Nonnull response, NSInteger statusCode, NSError * _Nonnull error) {
            [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
            
            if (error){
                SCLAlertView *alert = [AppD createDefaultAlert];
                [alert showError:self title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"") subTitle:NSLocalizedString(@"ALERT_MESSAGE_CATEGORY_ERROR", @"") closeButtonTitle:NSLocalizedString(@"ALERT_OPTION_OK", @"") duration:0.0];
                //PushNotification - Firebase
                   [AppD removeForRemoteNotifications];
                   //
                   [AppD registerLogoutForCurrentUser];
                   [AppD.rootViewController.navigationController popToRootViewControllerAnimated:YES];
            }else{
                
                if (response){
                    
                    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:(NSArray*)response];
                    NSMutableArray *tempResult = [NSMutableArray new];
                    for (NSDictionary *dic in tempArray){
                        [tempResult addObject:[DocVidCategory createObjectFromDictionary:dic]];
                    }
                    
                    //ordenando a lista
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                    categoriesList = [[NSArray alloc] initWithArray:[tempResult sortedArrayUsingDescriptors:sortDescriptors]];
                    
                    [tbvCategory reloadData];
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
