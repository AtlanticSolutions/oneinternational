//
//  ScannerAdAliveHistoryVC.m
//  
//
//  Created by Erico GT on 07/06/18.
//

#pragma mark - • HEADER IMPORT
#import "ScannerAdAliveHistoryVC.h"

#pragma mark - • INTERFACE PRIVATE PROPERTIES
@interface ScannerAdAliveHistoryVC ()

//Layout:
@property(nonatomic, weak) IBOutlet UITableView *tvHistory;
@property (nonatomic, weak) IBOutlet UILabel *lblEmptyList;

//Data:
@property(nonatomic, strong) NSArray *targetList;
@property(nonatomic, assign) BOOL isTouchResolved;
@property(nonatomic, strong) UIImage *placeholderImage;
//
@property(nonatomic, assign) BOOL isLoaded;

@end

#pragma mark - • IMPLEMENTATION
@implementation ScannerAdAliveHistoryVC
{
#pragma mark - • I_VARS
    //here...
    //i.e. NSString* _sampleName;
    
}

#pragma mark - • SYNTESIZES
@synthesize targetManager, targetList, isTouchResolved, placeholderImage, isLoaded;
@synthesize tvHistory, lblEmptyList;

#pragma mark - • CLASS METHODS

#pragma mark - • INTERFACE METHODS

#pragma mark - • INITIALISERS

#pragma mark - • DEALLOC

#pragma mark - • CONTROLLER LIFECYCLE/ TABLEVIEW/ DATA-SOURCE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isTouchResolved = YES;
    placeholderImage = [[UIImage imageNamed:@"cell-sponsor-image-placeholder"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if (targetManager == nil){
        targetManager = [AdAliveScannerTargetManager new];
    }
    [targetManager loadIdentifiedProductsToUser:AppD.loggedUser.userID];
    
    [self orderHistoryItemsByDate];
    //targetList = [targetManager.productsFound allKeys];
    
    isLoaded = NO;
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
        [self setupLayout:@"Histórico Scanner"];
        [tvHistory reloadData];
        isLoaded = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (targetList.count == 0){
        [lblEmptyList setHidden:NO];
    }else{
        [tvHistory setHidden:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [AppD performSelectorOnMainThread:@selector(hideLoadingAnimation) withObject:nil waitUntilDone:NO];
}

#pragma mark - • SUPER CLASS

-(void)setupLayout:(NSString *)screenName
{
    [super setupLayout:screenName];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    tvHistory.backgroundColor = [UIColor whiteColor];
    [tvHistory setTableFooterView:[UIView new]];
    [tvHistory setHidden:YES];
    
    lblEmptyList.text = @"No momento não há nenhum produto esconeado no seu histórico.";
    lblEmptyList.textColor = [UIColor grayColor];
    lblEmptyList.backgroundColor = nil;
    lblEmptyList.numberOfLines = 0;
    lblEmptyList.textAlignment = NSTextAlignmentCenter;
    lblEmptyList.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:17];
    [lblEmptyList setHidden:YES];
}

#pragma mark - • PUBLIC METHODS

#pragma mark - • ACTION METHODS

-(IBAction)actionDeleteButton:(UIButton*)sender
{
    NSLog(@"Delete Button: %i", sender.tag);
}

#pragma mark - • CUSTOM ACCESSORS (SETS & GETS)

#pragma mark - • OTHER DELEGATE/ PROTOCOL METHODS

#pragma mark - TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return targetList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block ScannerTargetHistoryTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"TargetHistoryCell"];
    if(cell == nil){
        cell = [[ScannerTargetHistoryTVC alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TargetHistoryCell"];
    }
    
    [cell updateLayout];
    
    //Data:
    NSString *key = [targetList objectAtIndex:indexPath.row];
    __block AdAliveIdentifiedProduct *iProduct = [self.targetManager.productsFound objectForKey:key];

    NSString *urlImage = [iProduct.productData valueForKey:@"image_url"];
    NSString *name = [iProduct.productData valueForKey:@"name"];
    NSString *date = iProduct.identificationDate;
    
    if (iProduct.productImage == nil) {
        [cell.activityIndicator startAnimating];
        [cell.imvProductImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlImage]] placeholderImage:[UIImage new] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            iProduct.productImage = image;
            //
            [cell.activityIndicator stopAnimating];
            cell.imvProductImage.image = image;
            [cell.imvProductImage setTintColor:[UIColor clearColor]];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            //
            [cell.activityIndicator stopAnimating];
            cell.imvProductImage.image = placeholderImage;
            [cell.imvProductImage setTintColor:[UIColor whiteColor]];
        }];
    }else{
        cell.imvProductImage.image = iProduct.productImage;
    }
   
    cell.lblName.text = name;
    cell.lblDate.text = date;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isTouchResolved)
    {
        isTouchResolved = NO;
        
        ScannerTargetHistoryTVC *cell = (ScannerTargetHistoryTVC*)[tableView cellForRowAtIndexPath:indexPath];
        __block UIColor *originalBColor = [UIColor colorWithCGColor:cell.backgroundColor.CGColor];
        [cell setBackgroundColor:AppD.styleManager.colorPalette.primaryButtonNormal];
        
        //UI - Animação de seleção
        [UIView animateWithDuration:ANIMA_TIME_NORMAL delay:0.0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [cell setBackgroundColor:originalBColor];
        } completion:^(BOOL finished) {
            
            //Resolução da seleção
            NSString *key = [targetList objectAtIndex:indexPath.row];
            AdAliveIdentifiedProduct *iProduct = [self.targetManager.productsFound objectForKey:key];
            [self openProductsDetailWithData:iProduct.productData forTarget:iProduct.targetID];
            
        }];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SCLAlertViewPlus *alert = [AppD createDefaultAlert];
        [alert addButton:@"Remover" withType:SCLAlertButtonType_Destructive actionBlock:^{
            
            NSString *key = [targetList objectAtIndex:indexPath.row];
            [self.targetManager.productsFound removeObjectForKey:key];
            //
            targetList = [targetManager.productsFound allKeys];
            //
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ANIMA_TIME_NORMAL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (targetList.count == 0){
                    [tvHistory setHidden:YES];
                    [lblEmptyList setHidden:NO];
                    //
                    [targetManager saveIdentifiedProductsToUser:AppD.loggedUser.userID];
                }
            });
        }];
        
        [alert showQuestion:self title:@"Produto Escaneado" subTitle:@"Deseja remover este item do seu histórico?" closeButtonTitle:@"Cancelar" duration:0.0];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remover";
}

//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Clona" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        //insert your editAction here
//    }];
//    editAction.backgroundColor = [UIColor blueColor];
//
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        //insert your deleteAction here
//    }];
//    deleteAction.backgroundColor = [UIColor redColor];
//    return @[deleteAction,editAction];
//}

#pragma mark - • PRIVATE METHODS (INTERNAL USE)

- (void)openProductsDetailWithData:(NSDictionary*)pData forTarget:(NSString*)target
{
    dispatch_async(dispatch_get_main_queue(),^{
        [AppD showLoadingAnimationWithType:eActivityIndicatorType_Loading];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ANIMA_TIME_FAST * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductViewController *productController = (ProductViewController *)[sb instantiateViewControllerWithIdentifier:@"ProductViewController"];
        //
        productController.dicProductData = pData;
        productController.targetName = target;
        productController.showBackButton = YES;
        productController.executeAutoLaunch = YES;
        productController.vcDelegate = nil; //ericogt
        //
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:productController animated:YES];
        //
        isTouchResolved = YES;
        
    });
    
}

- (void)orderHistoryItemsByDate
{
    NSArray *allKeys = [targetManager.productsFound allKeys];
    NSMutableArray *tempList = [NSMutableArray new];
    NSMutableArray *ordenedCodes = [NSMutableArray new];
    
    for (NSString *key in allKeys){
        AdAliveIdentifiedProduct *iProduct = [self.targetManager.productsFound objectForKey:key];
        [tempList addObject: iProduct];
    }
    
    if (tempList.count > 0){
        NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc] initWithKey:@"objDate" ascending:NO];
        NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"productData.name" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptorDate, sortDescriptorName];
        ordenedCodes = [[NSMutableArray alloc] initWithArray:[tempList sortedArrayUsingDescriptors:sortDescriptors]];
        //
        NSMutableArray *ordenedTargets = [NSMutableArray new];
        for (AdAliveIdentifiedProduct *p in ordenedCodes){
            [ordenedTargets addObject:p.targetID];
        }
        //
        targetList = [[NSArray alloc] initWithArray:ordenedTargets];
    }
}
@end
