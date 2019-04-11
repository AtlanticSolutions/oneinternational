//
//  VC_SubCategory.m
//  CozinhaTudo
//
//  Created by lucas on 12/04/2018.
//  Copyright © 2018 Atlantic Solutions. All rights reserved.
//

#pragma mark - • HEADER IMPORT
#import "VC_SubCategory.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface VC_SubCategory()

@property (nonatomic, weak) IBOutlet UITableView *tbvSubCategory;
@property (nonatomic, strong) DocVidCategory *selectedSubCategory;

@end

#pragma mark - • IMPLEMENTATION
@implementation VC_SubCategory
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize tbvSubCategory;
@synthesize categoryType, selectedCategory, selectedSubCategory;
#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.tbvSubCategory.delegate = self;
    self.tbvSubCategory.dataSource = self;
    
    [tbvSubCategory registerNib:[UINib nibWithNibName:@"DocVidCategory" bundle:nil] forCellReuseIdentifier: @"CustomCellCategory"];
    [tbvSubCategory setTableFooterView:[UIView new]];
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
    [tbvSubCategory reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"Segue_VideoList"]) {
        
        VC_VideoPreviewList *vclist = (VC_VideoPreviewList *)[segue destinationViewController];
        vclist.selectedCategory = self.selectedCategory;
        
    } else if ([segue.identifier isEqualToString:@"Segue_DocumentList"]) {
        
        VC_DocumentList *vcDocList = (VC_DocumentList *)[segue destinationViewController];
        vcDocList.selectedCateogry = self.selectedCategory;
        
    } else if ([segue.identifier isEqualToString:@""]) {
        
    }
    
    tbvSubCategory.tag = 0;
}

#pragma mark - • SUPER CLASS

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return selectedCategory.subcategoryArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TVC_DocVidCategory *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellCategory"];
    DocVidCategory *cat = [selectedCategory.subcategoryArray objectAtIndex:indexPath.row];
    
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
            
            for (DocVidCategory *subcat in selectedCategory.subcategoryArray) {
                subcat.selected = false;
            }
            
            selectedSubCategory = [selectedCategory.subcategoryArray objectAtIndex:indexPath.row];
            selectedCategory.subcategoryArray[indexPath.row].selected = true;
            
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            if(categoryType == eCategoryType_Video) {
                
                [self performSegueWithIdentifier:@"Segue_VideoList" sender:nil];
                
            } else if(categoryType == eCategoryType_Product) {
                
                [self performSegueWithIdentifier:@"" sender:nil];
                
            } else if(categoryType == eCategoryType_Document) {
                
                [self performSegueWithIdentifier:@"Segue_DocumentList" sender:nil];
            }
            
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)setupLayout
{
    //Self
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //Navigation Controller
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[ToolBox graphicHelper_CreateFlatImageWithSize:self.navigationController.view.frame.size byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[ToolBox graphicHelper_CreateFlatImageWithSize:CGSizeMake(self.navigationController.view.frame.size.width, 1) byRoundingCorners:UIRectCornerAllCorners cornerRadius:CGSizeZero andColor:AppD.styleManager.colorPalette.backgroundNormal]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:AppD.styleManager.colorPalette.textNormal, NSFontAttributeName:[UIFont fontWithName:FONT_DEFAULT_SEMIBOLD size:FONT_SIZE_TITLE_NAVBAR]}];
    //self.navigationController.toolbar.translucent = YES;
    //self.navigationController.toolbar.barTintColor = AppD.styleManager.colorPalette.backgroundNormal;
    
    self.navigationItem.title = selectedCategory.name;
}

@end

